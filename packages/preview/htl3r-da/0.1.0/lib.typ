#import "lib/settings.typ" as settings
#import "lib/page/cover.typ" as cover
#import "lib/page/abstract.typ" as abstract
#import "lib/page/ai.typ" as ai

#let diplomarbeit(
  titel: "Meine Diplomarbeit",
  titel_zusatz: "Wir sind super toll!",
  abteilung: "IT",
  schuljahr: "2024/2025",
  autoren: (
    (name: "Max Mustermann", betreuung: "Otto Normalverbraucher", rolle: "Projektleiter"),
    (name: "Erika Mustermann", betreuung: "Lieschen Müller", rolle: "Stv. Projektleiter"),
  ),
  datum: datetime(year: 2024, month: 12, day: 1),
  druck_referenz: true,
  kurzfassung_text: [#lorem(180)],
  abstract_text: [#lorem(180)],
  generative_ki_tools_klausel: [Es wurden keine Hilfsmittel generativer KI-Tools für die Erstellung der Arbeit verwendet.],
  body,
) = {
  // validate
  assert(("IT", "M").contains(abteilung), message: "Abteilung muss entweder \"IT\" oder \"M\" sein.")

  // document
  set document(
    title: titel,
    author: autoren.map((v) => v.name),
  )
  set page(
    paper: "a4",
    margin: (
      inside: settings.PAGE_MARGIN_INNER,
      outside: settings.PAGE_MARGIN_OUTER,
    )
  )
  show heading: h => [
    #set text(font: settings.FONT_TEXT_DISPLAY, size: 24pt)
    #h #v(1em)
  ]
  set par(justify: true)
  set text(
    font: settings.FONT_TEXT_BODY,
    size: settings.FONT_SIZE,
    lang: "de"
  )
  cover.create_page(
    titel: titel,
    titel_zusatz: titel_zusatz,
    abteilung: abteilung,
    schuljahr: schuljahr,
    autoren: autoren,
    datum: datum,
  )
  abstract.create_page(kurzfassung_text, abstract_text)
  ai.create_page(autoren, datum, generative_ki_tools_klausel)
}
