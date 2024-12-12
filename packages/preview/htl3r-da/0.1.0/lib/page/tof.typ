#import "../util.typ": blank_page

#let create_page() = [
  #blank_page()
  <TOF_BEGIN>
  #outline(
    title: [Abbildungsverzeichnis],
    target: figure.where(kind: image)
  )
  #hide("TOF_END")
  <TOF_END>
  #context {
    let toc_begin = query(<TOF_BEGIN>).first()
    let toc_end = query(<TOF_END>).first()
    let count = toc_end.location().page() - toc_begin.location().page()
    if not calc.odd(count) {
      blank_page()
    }
  }
]