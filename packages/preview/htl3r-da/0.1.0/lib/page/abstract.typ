#let create_page(
  kurzfassung_text,
  abstract_text,
) = [
  #page(header: none, footer: none, [])
  = Kurzfassung
  #kurzfassung_text
  #page(header: none, footer: none, [])
  = Abstract
  #abstract_text
]
