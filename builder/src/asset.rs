//! Makefile-like system.

use ::{
    anyhow::Context as _,
    std::{
        cell::Cell,
        fs,
        path::{Path, PathBuf},
        time::SystemTime,
    },
};

pub(crate) trait Asset {
    type Output;

    /// Get the time at which [`Self::generate`] started returning the value that it did.
    ///
    /// This can be used to avoid calling `generate` again, since that may be expensive.
    fn modified(&self) -> Modified;

    /// Generate the asset's value.
    fn generate(&self) -> anyhow::Result<Self::Output>;

    fn map<O, F: Fn(Self::Output) -> O>(self, f: F) -> Map<Self, F>
    where
        Self: Sized,
    {
        Map::new(self, f)
    }

    fn and_then<O, F: Fn(Self::Output) -> anyhow::Result<O>>(self, f: F) -> AndThen<Self, F>
    where
        Self: Sized,
    {
        AndThen::new(self, f)
    }

    /// Cache the result of this asset.
    fn cache(self) -> Cache<Self>
    where
        Self: Sized,
        Self::Output: Clone,
    {
        Cache::new(self)
    }

    /// Output the asset to a file if generating it didn't error.
    fn to_file<P: AsRef<Path>>(self, path: P) -> ToFile<Self, P>
    where
        Self: Sized,
        Self::Output: AsRef<[u8]>,
    {
        ToFile::new(self, path)
    }
}

#[derive(PartialEq, Eq, PartialOrd, Ord, Clone, Copy)]
pub(crate) enum Modified {
    Never,
    At(SystemTime),
    Now,
}

impl Modified {
    fn path<P: AsRef<Path>>(path: P) -> Option<Self> {
        path.as_ref()
            .metadata()
            .and_then(|meta| meta.modified())
            .map(Self::At)
            .ok()
    }
    fn input_path<P: AsRef<Path>>(path: P) -> Self {
        Modified::path(path).unwrap_or(Modified::Now)
    }
    fn output_path<P: AsRef<Path>>(path: P) -> Self {
        Modified::path(path).unwrap_or(Modified::Never)
    }
}

pub(crate) struct Map<A, F> {
    asset: A,
    f: F,
}
impl<A, F> Map<A, F> {
    fn new(asset: A, f: F) -> Self {
        Self { asset, f }
    }
}
impl<A: Asset, F: Fn(A::Output) -> O, O> Asset for Map<A, F> {
    type Output = O;

    fn modified(&self) -> Modified {
        self.asset.modified()
    }
    fn generate(&self) -> anyhow::Result<Self::Output> {
        self.asset.generate().map(&self.f)
    }
}

pub(crate) struct AndThen<A, F> {
    asset: A,
    f: F,
}
impl<A, F> AndThen<A, F> {
    fn new(asset: A, f: F) -> Self {
        Self { asset, f }
    }
}
impl<A: Asset, F: Fn(A::Output) -> anyhow::Result<O>, O> Asset for AndThen<A, F> {
    type Output = O;

    fn modified(&self) -> Modified {
        self.asset.modified()
    }
    fn generate(&self) -> anyhow::Result<Self::Output> {
        self.asset.generate().and_then(&self.f)
    }
}

pub(crate) struct Cache<A: Asset> {
    asset: A,
    cached: Cell<Option<(Modified, A::Output)>>,
}
impl<A: Asset> Cache<A> {
    fn new(asset: A) -> Self {
        Self {
            asset,
            cached: Cell::new(None),
        }
    }
}
impl<A: Asset> Asset for Cache<A>
where
    A::Output: Clone,
{
    type Output = A::Output;

    fn modified(&self) -> Modified {
        self.asset.modified()
    }
    fn generate(&self) -> anyhow::Result<Self::Output> {
        let inner_modified = self.asset.modified();
        let (last_modified, output) = self
            .cached
            .take()
            .filter(|&(last_modified, _)| last_modified >= inner_modified)
            .map_or_else(|| Ok((inner_modified, self.asset.generate()?)), anyhow::Ok)?;
        self.cached.set(Some((last_modified, output.clone())));
        Ok(output)
    }
}

pub(crate) struct ToFile<A, P> {
    asset: A,
    path: P,
}
impl<A, P> ToFile<A, P> {
    fn new(asset: A, path: P) -> Self {
        Self { asset, path }
    }
}
impl<A: Asset, P: AsRef<Path>> Asset for ToFile<A, P>
where
    A::Output: AsRef<[u8]>,
{
    type Output = ();

    fn modified(&self) -> Modified {
        Modified::Never
    }
    fn generate(&self) -> anyhow::Result<Self::Output> {
        let output = self.path.as_ref();
        if self.asset.modified() > Modified::output_path(&output) {
            if let Some(parent) = output.parent() {
                fs::create_dir_all(parent)
                    .with_context(|| format!("failed to create dir `{}`", parent.display()))?;
            }

            let bytes = self.asset.generate()?;

            fs::write(&output, bytes)
                .with_context(|| format!("couldn't write asset to `{}`", output.display()))?;
        }
        Ok(())
    }
}

macro_rules! impl_for_refs {
    ($($ty:ty),*) => { $(
        impl<A: Asset + ?Sized> Asset for $ty {
            type Output = A::Output;

            fn modified(&self) -> Modified {
                (**self).modified()
            }
            fn generate(&self) -> anyhow::Result<Self::Output> {
                (**self).generate()
            }
        }
    )* };
}

impl_for_refs!(&A, std::rc::Rc<A>);

macro_rules! impl_for_tuples {
    (@$_:ident) => {};
    (@$first:ident $($ident:ident)*) => {
        impl_for_tuples!($($ident)*);
    };
    ($($ident:ident)*) => {
        #[allow(non_snake_case)]
        impl<$($ident: Asset,)*> Asset for ($($ident,)*) {
            type Output = ($(<$ident as Asset>::Output,)*);

            #[allow(unused_mut)]
            fn modified(&self) -> Modified {
                let ($($ident,)*) = self;
                let mut latest = Modified::Never;
                $(latest = Ord::max(latest, $ident.modified());)*
                latest
            }
            #[allow(clippy::unused_unit)]
            fn generate(&self) -> anyhow::Result<Self::Output> {
                let ($($ident,)*) = self;
                Ok(($($ident.generate()?,)*))
            }
        }
        impl_for_tuples!(@$($ident)*);
    };
}
impl_for_tuples!(A B C D E F G);

macro_rules! impl_for_seq {
    ($($ty:ty),*) => { $(
        impl<A: Asset> Asset for $ty {
            // TODO: don't allocate?
            type Output = Box<[A::Output]>;

            fn modified(&self) -> Modified {
                self.iter().map(|asset| asset.modified()).min().unwrap_or(Modified::Never)
            }
            fn generate(&self) -> anyhow::Result<Self::Output> {
                self.iter().map(|asset| asset.generate()).collect()
            }
        }
    )* };
}
impl_for_seq!([A], Vec<A>);

pub(crate) struct TextFile<P> {
    path: P,
}
impl<P: AsRef<Path>> TextFile<P> {
    pub(crate) fn new(path: P) -> Self {
        Self { path }
    }
}
impl<P: AsRef<Path>> Asset for TextFile<P> {
    type Output = String;

    fn modified(&self) -> Modified {
        Modified::input_path(&self.path)
    }
    fn generate(&self) -> anyhow::Result<Self::Output> {
        let path = self.path.as_ref();
        fs::read_to_string(&path)
            .with_context(|| format!("failed to read file `{}`", path.display()))
    }
}

pub(crate) struct Dir<P> {
    path: P,
}
impl<P: AsRef<Path>> Dir<P> {
    pub(crate) fn new(path: P) -> Self {
        Self { path }
    }
}
impl<P: AsRef<Path>> Asset for Dir<P> {
    type Output = DirFiles;

    fn modified(&self) -> Modified {
        Modified::input_path(&self.path)
    }
    fn generate(&self) -> anyhow::Result<Self::Output> {
        let path = self.path.as_ref();
        Ok(DirFiles {
            iter: fs::read_dir(path)
                .with_context(|| format!("failed to open directory `{}`", path.display()))?,
            path: path.to_owned(),
        })
    }
}

pub(crate) struct DirFiles {
    iter: fs::ReadDir,
    path: PathBuf,
}

impl Iterator for DirFiles {
    type Item = anyhow::Result<PathBuf>;

    fn next(&mut self) -> Option<Self::Item> {
        Some(
            self.iter
                .next()?
                .map(|entry| entry.path())
                .with_context(|| format!("failed to read directory `{}`", self.path.display())),
        )
    }
}
