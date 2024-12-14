#import "settings.typ" as settings
#import "@preview/codly:1.1.1": *
#import "@preview/codly-languages:0.1.1": *

/// Converts a date to a german format, currently not implemented in typst.
#let format_date(date) = {
  let months = ("Januar", "Februar", "März", "April", "Mai", "Juni", "Juli", "August", "September", "Oktober", "November", "Dezember")
  date.display("[day]. ") + months.at(date.month() - 1) + date.display(" [year]")
}

#let format_department(department) = {
  let departments = (
    ITN: "Informationstechnologie/Netzwerktechnik",
    ITM: "Informationstechnologie/Medientechnik",
    M: "Mechatronik",
  )
  departments.at(department)
}

/// Creates a completly blank page, useful for book binding
#let blank_page() = {
  page(header: none, footer: none, [])
}

/// Definiert den aktuellen Autor eines Kapitels. Der Autor eines
/// Kapitels sollte immer nach dem Kapitel-Heading definiert werden.
/// Definiert man den Autor nicht, so wird der Autor des vorherigen
/// Kapitels angenommen.
#let author(name) = [
  #metadata(name) <CHAPTER_AUTHOR>
]

/// Markiert eine Abkürzung, sodass diese nachgeschlagen werden kann.
/// Die Abkürzung sollte in den definierten Abkürzungen
/// beinhaltet sein. Ansonsten ist diese nicht nachschlagbar.
#let abbr(body) = [
  #link(label("ABBR_DES_"+body.text), body) #label("ABBR_"+body.text)
]

#let code(caption: none, description: none, body) = [
  #codly(
    header: description,
  )
  #figure(
    body,
    caption: caption,
    supplement: [Quellcode],
    kind: "code",
  )
]

#let code_file(caption: none, filename: none, lang: none, text: none, range: none, ranges: none) = {
  codly(
    header: filename,
    ranges: ranges,
    range: range,
  )
  figure(
    raw(text, block: true, lang: lang),
    caption: caption,
    supplement: [Quellcode],
    kind: "code",
  )
}

/// Positioniert mehrere Abbildungen auf einer Zeile
#let fspace(figure_width: settings.FIGURE_WIDTH, ..figures) = {
  let figures = figures.pos()
  let gutter = 2em
  let shave = gutter * (figures.len() - 1) / figures.len()
  let width = 100% / figures.len() - shave
  let columns = range(figures.len()).map((_) => width)
  set block(width: 100%)
  align(center)[#block(width: figure_width)[
    #show figure: set image(width: 100%)
    #grid(
      columns: columns,
      gutter: gutter,
      ..figures
    )
  ]]
}
