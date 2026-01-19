#import "template.typ": book
#show: book.with(
  title: [An Epic Battle],
  subtitle: [Where a historian and an AI meet],
  author: [Charlotte Thomas],
  text_size: 11pt,
  first_chapter: 0,
  last_chapter: 1,
  chapter_numbering: "1.",
)

#let break_line = stack(dir: ltr, 1fr, [* \*\*\* *], 1fr)
#include "chapters/oneshot.typ"
