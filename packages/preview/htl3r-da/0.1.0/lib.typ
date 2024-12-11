#import "lib/settings.typ" as settings

#let diplomarbeit(
  titel: "Meine Diplomarbeit",
  titel_zusatz: "Wir sind supper toll!",
  abteilung: "IT",
  schuljahr: "2024/25",
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
  )
  body
}
