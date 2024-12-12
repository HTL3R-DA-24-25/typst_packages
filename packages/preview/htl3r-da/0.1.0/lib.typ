#import "lib/settings.typ" as settings
#import "lib/page/cover.typ" as cover
#import "lib/page/abstract.typ" as abstract
#import "lib/page/erklaerung.typ" as erklaerung
#import "lib/page/toc.typ" as toc
#import "lib/page/tot.typ" as tot
#import "lib/page/tof.typ" as tof
#import "lib/util.typ": blank_page

#let author(name) = [
  #metadata(name) <CHAPTER_AUTHOR>
]

#let diplomarbeit(
  titel: "Meine Diplomarbeit",
  titel_zusatz: "Wir sind super toll!",
  abteilung: "ITN",
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
  assert(("ITN", "ITM", "M").contains(abteilung), message: "Abteilung muss entweder \"ITN\", \"ITM\" oder \"M\" sein.")

  // document
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
  cover.create_page(
    titel: titel,
    titel_zusatz: titel_zusatz,
    abteilung: abteilung,
    schuljahr: schuljahr,
    autoren: autoren,
    datum: datum,
  )
  set page(
    header-ascent: 10pt,
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
              [#box(height: 40%, image("lib/assets/htl3r_logo.svg")) #h(1fr) #current]
            }
          }
        }
      }
      v(-10pt)
      line(length: 100%, stroke: 0.5pt)
    },
    footer-descent: 10pt,
    footer: context {
      let counter = counter(page)
      let is-odd = calc.odd(counter.at(here()).first())
      let aln = if is-odd {
        right
      } else {
        left
      }
      line(length: 100%, stroke: 0.5pt)
      v(-10pt)
      align(aln)[#counter.display("i") <footer>]
    }
  )
  show page: p => {
    let i = counter(page).at(here()).first()
    let is-odd = calc.odd(i)
    set page(binding: if is-odd { right } else { left })
  }
  abstract.create_page(kurzfassung_text, abstract_text)
  erklaerung.create_page(autoren, datum, generative_ki_tools_klausel)
  toc.create_page()
  tot.create_page()
  tof.create_page()
  text([#metadata("BEGIN_DA") <BEGIN_DA>])
  blank_page()
  counter(page).update(1)
  set page(
    footer: context {
      let counter = counter(page)
      let is-odd = calc.odd(counter.at(here()).first())
      let aln = if is-odd {
        right
      } else {
        left
      }
      let author = query(selector(<CHAPTER_AUTHOR>).before(here())).last().value
      line(length: 100%, stroke: 0.5pt)
      v(-10pt)
      align(aln)[
        #counter.display("1") <footer>
        #h(1fr)
        #author
      ]
    }
  )
  set heading(
    numbering: "1.1"
  )
  body
}
