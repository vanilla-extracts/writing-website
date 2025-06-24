#import "template.typ": book
#show: book.with(
  title: [My roommates suddenly became my girlfriends.],
  subtitle: [They keep telling I could be one too],
  author: [Charlotte Thomas],
  text_size: 11pt,
  first_chapter: 0,
  last_chapter: 3,
  chapter_numbering: "1.",
)

#let break_line = stack(dir: ltr, 1fr, [* \*\*\* *], 1fr)
#include "chapters/first.typ"
#include "chapters/second.typ"
#include "chapters/third.typ"
#include "chapters/epilogue.typ"
