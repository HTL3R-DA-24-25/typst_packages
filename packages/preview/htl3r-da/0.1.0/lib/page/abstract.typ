#let create_page(
  kurzfassung_text,
  abstract_text,
) = [
  #pagebreak()
  #pagebreak()
  = Kurzfassung
  #kurzfassung_text
  #pagebreak()
  #pagebreak()
  = Abstract
  #abstract_text
]
