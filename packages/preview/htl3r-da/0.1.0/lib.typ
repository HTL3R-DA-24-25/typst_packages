#import "lib/settings.typ" as settings
#import "lib/page/cover.typ" as cover
#import "lib/page/abstract.typ" as abstract
#import "lib/page/preamble.typ" as preamble
#import "lib/page/erklaerung.typ" as erklaerung
#import "lib/page/toc.typ" as toc
#import "lib/page/tot.typ" as tot
#import "lib/page/tof.typ" as tof
#import "lib/page/tol.typ" as tol
#import "lib/page/bibliography.typ" as bib
#import "lib/page/printref.typ" as printref
#import "lib/util.typ": blank_page
#import "@preview/codly:1.1.1": *
#import "@preview/codly-languages:0.1.1": *

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
#let fspace(width: settings.FIGURE_WIDTH, ..figures) = {
  let figures = figures.pos()
  let gutter = 2em
  let shave = gutter * (figures.len() - 1) / figures.len()
  let width = 100% / figures.len() - shave
  let columns = range(figures.len()).map((_) => width)
  set block(width: 100%)
  align(center)[#block(width: settings.FIGURE_WIDTH)[
    #show figure: set image(width: 100%)
    #grid(
      columns: columns,
      gutter: gutter,
      ..figures
    )
  ]]
}

#let diplomarbeit(
  titel: "Meine Diplomarbeit",
  titel_zusatz: "Wir sind super toll!",
  abteilung: "ITN",
  schuljahr: "2024/2025",
  autoren: (
    (name: "Max Mustermann", betreuung: "Otto Normalverbraucher", rolle: "Projektleiter"),
    (name: "Erika Mustermann", betreuung: "Lieschen Müller", rolle: "Stv. Projektleiter"),
  ),
  betreuer_inkl_titel: ("Prof, Dipl.-Ing. Otto Normalverbraucher", "Prof, Dipl.-Ing. Lieschen Müller"),
  sponsoren: ("Knallhart GmbH", "Gartenbedarfs GmbH", "Huber e.U.", "Huberit Vetrieb GmbH & Co. KG"),
  datum: datetime(year: 2024, month: 12, day: 1),
  druck_referenz: true,
  kurzfassung_text: [#lorem(180)],
  abstract_text: [#lorem(180)],
  generative_ki_tools_klausel: [Es wurden keine Hilfsmittel generativer KI-Tools für die Erstellung der Arbeit verwendet.],
  abkuerzungen: (),
  literatur: [],
  body,
) = {
  // validate
  assert(("ITN", "ITM", "M").contains(abteilung), message: "Abteilung muss entweder \"ITN\", \"ITM\" oder \"M\" sein.")

  // document
  show: codly-init.with()
  codly(
    display-icon: false,
    zebra-fill: none,
    number-align: left + top,
    lang-format: none,
    breakable: true,
    header-cell-args: (align: left, fill: luma(240)),
    header-repeat: true,
  )
  set document(
    title: titel,
    author: autoren.map((v) => v.name),
  )
  set page(
    paper: "a4",
    margin: (
      top: settings.PAGE_MARGIN_VERTICAL,
      bottom: settings.PAGE_MARGIN_VERTICAL,
      inside: settings.PAGE_MARGIN_INNER,
      outside: settings.PAGE_MARGIN_OUTER,
    ),
  )
  show heading: h => {
    set text(font: settings.FONT_TEXT_DISPLAY, size: settings.HEADING_SIZES.at(h.level - 1).size)
    if h.level == 1 {
      pagebreak(weak: true)
    }
    v(settings.HEADING_SIZES.at(h.level - 1).top)
    h
    v(settings.HEADING_SIZES.at(h.level - 1).bottom)
  }
  set par(justify: true)
  set text(
    font: settings.FONT_TEXT_BODY,
    size: settings.FONT_SIZE,
    lang: "de"
  )
  set figure(numbering: "1.1",)
  show figure: set par(justify: false)
  show figure: set block(breakable: true)
  cover.create_page(
    titel: titel,
    titel_zusatz: titel_zusatz,
    abteilung: abteilung,
    schuljahr: schuljahr,
    autoren: autoren,
    datum: datum,
  )
  set page(
    header-ascent: 1cm,
    header: context {
      let i = counter(page).at(here()).first()
      let is-odd = calc.odd(i)
      context {
        let target = heading.where(level: 1)
        let footer = query(<footer>).filter((v) => {
          v.location().page() == here().page()
        }).first()
        if footer != none {
          let before = query(target.before(footer.location()))
          if before.len() > 0 {
            let current = box(height: 28pt, align(left + horizon, before.last().body))
            if is-odd {
              [#current #h(1fr) #box(height: 28pt, image("lib/assets/htl3r_logo.svg"))]
            } else {
              [#box(height: 28pt, image("lib/assets/htl3r_logo.svg")) #h(1fr) #current]
            }
          }
        }
      }
      v(-5pt)
      line(length: 100%, stroke: 0.5pt)
    },
    footer-descent: 1cm,
    footer: context {
      let counter = counter(page)
      let is-odd = calc.odd(counter.at(here()).first())
      let aln = if is-odd {
        right
      } else {
        left
      }
      line(length: 100%, stroke: 0.5pt)
      v(-5pt)
      align(aln)[#counter.display("i") <footer>]
    }
  )
  show page: p => {
    let i = counter(page).at(here()).first()
    let is-odd = calc.odd(i)
    set page(binding: if is-odd { right } else { left })
  }
  abstract.create_page(kurzfassung_text, abstract_text)
  preamble.create_page(betreuer_inkl_titel, sponsoren)
  erklaerung.create_page(autoren, datum, generative_ki_tools_klausel)
  blank_page()
  toc.create_page()
  tot.create_page()
  tof.create_page()
  tol.create_page()
  text([#metadata("DA_BEGIN") <DA_BEGIN>])
  counter(page).update(1)
  set page(
    footer: context {
      let counter = counter(page)
      let is-odd = calc.odd(counter.at(here()).first())
      let authors = query(selector(<CHAPTER_AUTHOR>).before(here()))
      let author = none
      if authors.len() != 0 {
        author = authors.last().value
      }
      line(length: 100%, stroke: 0.5pt)
      v(-5pt)
      if is-odd {
        align(right)[
          #if author != none [
            Autor: #author
          ]
          #h(1fr)
          #counter.display("1") <footer>
        ]
      } else {
        align(left)[
          #counter.display("1") <footer>
          #h(1fr)
          #if author != none [
            Autor: #author
          ]
        ]
      }
    }
  )
  set heading(numbering: "1.1")
  body
  text([#metadata("DA_END") <DA_END>])
  context {
    let body_page_count = query(<DA_END>).first().location().page() - query(<DA_BEGIN>).first().location().page()
    if not calc.odd(body_page_count) {
      blank_page()
    }
  }
  set heading(numbering: none)
  [
    = Abkürzungsverzeichnis
    #author(none)
    #context {
      for abbr in abkuerzungen [
        #par(spacing: 0pt)[
          #strong(abbr.abbr): #label("ABBR_DES_"+abbr.abbr) #abbr.langform #h(1fr)
          #if abbr.bedeutung != none [
            #let page = query(label("ABBR_G_"+abbr.abbr)).first().location().page() - query(<DA_BEGIN>).first().location().page() + 1
            #link(label("ABBR_G_"+abbr.abbr))[#emph[Glossar (S. #page)]]
          ]
        ]
        // list abbr locations
        #let refs = query(label("ABBR_"+abbr.abbr))
        #par(hanging-indent: 2em, spacing: 6pt, first-line-indent: 2em)[
          #for (index, a) in refs.enumerate() [
            #let loc = a.location()
            #let nr = loc.page() - query(<DA_BEGIN>).first().location().page() + 1
            #let delim = if index + 1 == refs.len() {""} else {","}
            #link(loc)[#emph[(S. #{nr})#{delim} ]]
          ]
        ]
        #v(1em)
      ]
    }
    #blank_page()
    = Glossar
    #{
      for abbr in abkuerzungen [
        #if abbr.bedeutung != none [
          #par(hanging-indent: 2em)[
            #strong(abbr.langform): #label("ABBR_G_"+abbr.abbr) #abbr.bedeutung \
            #v(1em)
          ]
        ]
      ]
    }
  ]
  bib.create_page(literatur: literatur)
  if druck_referenz {
    printref.create_page()
  } else {
    blank_page()
  }
}
