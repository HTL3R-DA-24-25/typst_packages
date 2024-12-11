#import "lib/settings.typ" as settings
#import "lib/page/cover.typ" as cover

#let diplomarbeit(
  titel: "Meine Diplomarbeit",
  titel_zusatz: "Wir sind supper toll!",
  abteilung: "IT",
  schuljahr: "2024/2025",
  autoren: (
    (name: "Max Mustermann", betreuung: "Otto Normalverbraucher", rolle: "Projektleiter"),
    (name: "Erika Mustermann", betreuung: "Lieschen Müller", rolle: "Stv. Projektleiter"),
  ),
  datum: datetime(year: 2024, month: 12, day: 1),
  druck_referenz: true,
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
}
