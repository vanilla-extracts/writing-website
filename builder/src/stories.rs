const STORY_CSS_PATH: &str = "story.css";
pub(crate) fn asset<'a>(
    template_dir: &'a Path,
    src_dir: &'a Path,
    out_dir: &'a Path,
    templater: impl Asset<Output = Templater> + Clone + 'a,
    config: impl Asset<Output = &'a Config> + Copy + 'a,
) -> impl Asset<Output = ()> + 'a {
    let index_template = Rc::new(
        asset::TextFile::new(template_dir.join("index.hbs"))
            .map(|src| Template::compile(&src?).context("failed to compile blog post template"))
            .map(Rc::new)
            .cache(),
    );

    let index_markdown = Rc::new(
        asset::TextFile::new(src_dir.join("index.md"))
            .map(|src| Rc::new(src.map(|src| markdown::parse(&src)))),
    );

    let post_css = asset::TextFile::new(template_dir.join("story.css")).map(|res| {
        res.unwrap_or_else(|e| {
            log::error!("{e:?}");
            String::new()
        })
    });

    let css = asset::all((post_css, config))
        .map(|(mut post_css, config)| {
            if config.minify {
                minify(minify::FileType::Css, &mut post_css);
            }
            write_file(out_dir.join(STORY_CSS_PATH), post_css)?;
            log::info!("successfully emitted post CSS");
            Ok(())
        })
        .map(log_errors)
        .modifies_path(out_dir.join(STORY_CSS_PATH));

    let story_template = Rc::new(
        asset::TextFile::new(template_dir.join("story.hbs"))
            .map(|src| Template::compile(&src?).context("failed to compile blog index template"))
            .map(Rc::new)
            .cache(),
    );

    asset::all((index_markdown, templater.clone(), index_template))
        .map(|(markdown, templater, template)| {
            let (markdown, template) = ErrorPage::zip((*markdown).as_ref(), (*template).as_ref())?;

            #[derive(Serialize)]
            struct TemplateVars<'a> {
                title: &'a str,
                body: &'a str,
            }
            let vars = TemplateVars {
                title: &markdown.title,
                body: &markdown.body,
            };
            Ok(templater.render(template, vars)?)
        })
        .map(move |html| {
            write_file(
                out_dir.join("index.html"),
                html.unwrap_or_else(ErrorPage::into_html),
            )?;
            log::info!("successfully emitted index.html yay!");
            Ok(())
        })
        .map(log_errors)
        .modifies_path(out_dir.join("index.html"));

    let html = asset::Dir::new(src_dir)
        .map(move |files| -> anyhow::Result<_> {
            // TODO: Whenever the directory is changed at all, this entire bit of code is re-run
            // which throws away all the old `Asset`s.
            // That's a problem because we loes all our in-memory cache.

            let mut stories = Vec::new();
            let mut story_pages = Vec::new();

            for path in files? {
                let path = path?;
                if path.extension() != Some("md".as_ref()) {
                    continue;
                }

                let stem = if let Some(s) = path.file_stem().unwrap().to_str() {
                    <Rc<str>>::from(s)
                } else {
                    log::error!("filename `{}` is not valid UTF-8", path.display());
                    continue;
                };

                let mut output_path = out_dir.join(&*stem);
                output_path.set_extension("html");

                let story = asset::TextFile::new(path)
                    .map(move |src| Rc::new(read_post(stem.clone(), src)))
                    .cache();

                let story = Rc::new(asset::all((config, story)).map(move |(_, story)| Some(story)));

                stories.push(story.clone());

                let story_page = asset::all((story, templater.clone(), story_template.clone()))
                    .map({
                        let output_path = output_path.clone();
                        move |(story, templater, template)| {
                            if let Some(story) = story {
                                let built = build_stories(&story, &templater, (*template).as_ref())
                                    .unwrap_or_else(ErrorPage::into_html);
                                write_file(&output_path, built)?;
                                log::info!("successfully emitted {}.html", &story.stem);
                            }
                            Ok(())
                        }
                    })
                    .map(log_errors)
                    .modifies_path(output_path);

                story_pages.push(story_page);
            }

            let stories = Rc::new(asset::all(stories).map(process_stories).cache());

            Ok(asset::all(story_pages).map(|_| {}))
        })
        .map(|res| -> Rc<dyn Asset<Output = _>> {
            match res {
                Ok(asset) => Rc::new(asset),
                Err(e) => {
                    log::error!("{:?}", e);
                    Rc::new(asset::Constant::new(()))
                }
            }
        })
        .cache()
        .flatten();

    asset::all((html, css)).map(|((), ())| {})
}

#[derive(Serialize)]
struct Story {
    stem: Rc<str>,
    #[serde(
        skip_serializing_if = "Result::is_err",
        serialize_with = "serialize_unwrap"
    )]
    content: anyhow::Result<StoryContent>,
}

#[derive(Serialize)]
struct StoryContent {
    metadata: StoryMetadata,
    markdown: Markdown,
}

#[derive(Default, Serialize, Deserialize, Debug)]
struct Chapter {
    name: String,
    link: String,
    index: u16,
}

#[derive(Default, Serialize, Deserialize, Debug)]
struct StoryMetadata {
    name: String,
    short: String,
    published: Option<NaiveDate>,
    status: String,
    chapters: Vec<Chapter>,
}

fn read_post(stem: Rc<str>, src: anyhow::Result<String>) -> Story {
    Story {
        content: src.map(|src| {
            let mut json = serde_json::Deserializer::from_str(&src).into_iter();
            let metadata = json.next().and_then(Result::ok).unwrap_or_default();
            let markdown = &src[json.byte_offset()..];
            let mut markdown = markdown::parse(markdown);
            if markdown.title.is_empty() {
                log::warn!("Post in {stem}.md does not have title");
                markdown.title = format!("Untitled post from {stem}.md");
            }
            StoryContent { metadata, markdown }
        }),
        stem,
    }
}

fn build_index(
    stories: &[Rc<Story>],
    templater: &Templater,
    template: &Template,
    markdown: &Markdown,
) -> Result<String, ErrorPage> {
    #[derive(Serialize)]
    struct TemplateVars<'a> {
        stories: &'a [Rc<Story>],
        body: &'a str,
    }
    let vars = TemplateVars {
        stories: &stories,
        body: &markdown.body,
    };
    Ok(templater.render(template, vars)?)
}

fn build_stories(
    story: &Story,
    templater: &Templater,
    template: Result<&Template, &anyhow::Error>,
) -> Result<String, ErrorPage> {
    let (story_content, template) = ErrorPage::zip(story.content.as_ref(), template)?;

    #[derive(Serialize)]
    struct TemplateVars<'a> {
        story: &'a StoryContent,
        story_css: &'static str,
    }
    let vars = TemplateVars {
        story: story_content,
        story_css: STORY_CSS_PATH,
    };

    Ok(templater.render(template, vars)?)
}

fn process_stories(stories: Box<[Option<Rc<Story>>]>) -> Rc<Vec<Rc<Story>>> {
    let stories: Vec<_> = Vec::from(stories).into_iter().flatten().collect();
    Rc::new(stories)
}

fn theme_asset(path: PathBuf) -> impl Asset<Output = Rc<String>> {
    asset::FsPath::new(path.clone())
        .map(move |()| {
            let res = ThemeSet::get_theme(&path)
                .with_context(|| format!("failed to read theme file {}", path.display()));
            Rc::new(match res {
                Ok(theme) => markdown::theme_css(&theme),
                Err(e) => {
                    log::error!("{e:?}");
                    String::new()
                }
            })
        })
        .cache()
}

fn serialize_unwrap<S, T, E>(result: &Result<T, E>, serializer: S) -> Result<S::Ok, S::Error>
where
    S: Serializer,
    T: Serialize,
{
    result
        .as_ref()
        .unwrap_or_else(|_| panic!())
        .serialize(serializer)
}

use crate::config::Config;
use crate::templater::Templater;
use crate::util::asset;
use crate::util::asset::Asset;
use crate::util::log_errors;
use crate::util::markdown;
use crate::util::markdown::Markdown;
use crate::util::minify;
use crate::util::minify::minify;
use crate::util::write_file;
use crate::util::ErrorPage;
use anyhow::Context as _;
use chrono::naive::NaiveDate;
use handlebars::template::Template;
use serde::Deserialize;
use serde::Serialize;
use serde::Serializer;
use std::path::Path;
use std::path::PathBuf;
use std::rc::Rc;
use syntect::highlighting::ThemeSet;
