#import "@preview/ctheorems:1.1.3": *
#import "@preview/showybox:2.0.3": showybox

#let colors = (
  rgb("#9E9E9E"),
  rgb("#F44336"),
  rgb("#E91E63"),
  rgb("#9C27B0"),
  rgb("#673AB7"),
  rgb("#3F51B5"),
  rgb("#2196F3"),
  rgb("#03A9F4"),
  rgb("#00BCD4"),
  rgb("#009688"),
  rgb("#4CAF50"),
  rgb("#8BC34A"),
  rgb("#CDDC39"),
  rgb("#FFEB3B"),
  rgb("#FFC107"),
  rgb("#FF9800"),
  rgb("#FF5722"),
  rgb("#795548"),
  rgb("#9E9E9E"),
)

#let zen(
  title: "",
  subtitle: "",
  author: "",
  abstract: none,
  bibliography: none,
  paper-size: "a4",
  date: "today",
  body,
) = {
  set document(title: title, author: author)

  set std.bibliography(style: "springer-mathphys", title: [References])

  show: thmrules

  set page(
    numbering: "1",
    number-align: center,
    header: locate(loc => {
      if loc.page() == 1 {
        return
      }
      box(stroke: (bottom: 0.7pt), inset: 0.4em)[#text(
          font: "New Computer Modern",
        )[
          *#author* --- #datetime.today().display("[day] [month repr:long] [year]")
          #h(1fr)
          *#title*
        ]]
    }),
    paper: paper-size,
    // The margins depend on the paper size.
    margin: (
      left: (86pt / 216mm) * 100%,
      right: (86pt / 216mm) * 100%,
    ),
  )


  set heading(numbering: "1.")
  show heading: it => {
    set text(font: "Libertinus Serif")

    block[
      #if it.numbering != none {
        text(rgb("#2196F3"), weight: 500)[#sym.section]

        text(rgb("#2196F3"))[#counter(heading).display() ]
      }
      #it.body
      #v(0.5em)
    ]
  }

  set text(font: "New Computer Modern", lang: "en")

  show math.equation: set text(weight: 400)


  // Title row.
  align(center)[
    #set text(font: "Libertinus Serif")
    #block(text(weight: 700, 26pt, title))


    #if subtitle != none [#text(12pt, weight: 500)[#(
          subtitle
        )]]

    #if author != none [#text(16pt)[#smallcaps(author)]]
    #v(1.2em, weak: true)

    #if date == "today" {
      datetime.today().display("[day] [month repr:long] [year]")
    } else {
      date
    }

  ]

  if abstract != none [
    #v(2.2em)
    #set text(font: "Libertinus Serif")
    #pad(x: 14%, abstract)
    #v(1em)
  ]

  set outline(fill: repeat[~.], indent: 1em)

  show outline: set heading(numbering: none)
  show outline: set par(first-line-indent: 0em)

  show outline.entry.where(level: 1): it => {
    text(font: "Libertinus Serif", rgb("#2196F3"))[#strong[#it]]
  }
  show outline.entry: it => {
    h(1em)
    text(font: "Libertinus Serif", rgb("#2196F3"))[#it]
  }


  // Main body.
  set par(
    justify: true,
    spacing: 0.65em,
    first-line-indent: 1em,
  )

  body

  // Display the bibliography, if any is given.
  if bibliography != none {
    show std.bibliography: set text(footnote-size)
    show std.bibliography: set block(above: 11pt)
    show std.bibliography: pad.with(x: 0.5pt)
    bibliography
  }
}

#let thmtitle(t, color: rgb("#000000")) = {
  return text(
    font: "Libertinus Serif",
    weight: "semibold",
    fill: color,
  )[#t]
}
#let thmname(t, color: rgb("#000000")) = {
  return text(font: "Libertinus Serif", fill: color)[(#t)]
}

#let thmtext(t, color: rgb("#000000")) = {
  let a = t.children
  if (a.at(0) == [ ]) {
    a.remove(0)
  }
  t = a.join()

  return text(font: "New Computer Modern", fill: color)[#t]
}

#let thmbase(
  identifier,
  head,
  ..blockargs,
  supplement: auto,
  padding: (top: 0.5em, bottom: 0.5em),
  namefmt: x => [(#x)],
  titlefmt: strong,
  bodyfmt: x => x,
  separator: [. \ ],
  base: "heading",
  base_level: none,
) = {
  if supplement == auto {
    supplement = head
  }
  let boxfmt(name, number, body, title: auto, ..blockargs_individual) = {
    if not name == none {
      name = [ #namefmt(name)]
    } else {
      name = []
    }
    if title == auto {
      title = head
    }
    if not number == none {
      title += " " + number
    }
    title = titlefmt(title)
    body = [#pad(top: 2pt, bodyfmt(body))]
    pad(
      ..padding,
      showybox(
        width: 100%,
        radius: 0.3em,
        breakable: true,
        padding: (top: 0em, bottom: 0em),
        ..blockargs.named(),
        ..blockargs_individual.named(),
        [
          #title#name#titlefmt(separator)#body
        ],
      ),
    )
  }

  let auxthmenv = thmenv(
    identifier,
    base,
    base_level,
    boxfmt,
  ).with(supplement: supplement)

  return auxthmenv.with(numbering: "1.1")
}

#let styled-thmbase = thmbase.with(
  titlefmt: thmtitle,
  namefmt: thmname,
  bodyfmt: thmtext,
)

#let builder-thmbox(color: rgb("#000000"), ..builderargs) = styled-thmbase.with(
  titlefmt: thmtitle.with(color: color.darken(30%)),
  bodyfmt: thmtext.with(color: color.darken(70%)),
  namefmt: thmname.with(color: color.darken(30%)),
  frame: (
    body-color: color.lighten(92%),
    border-color: color.darken(10%),
    thickness: 1.5pt,
    inset: 1.2em,
    radius: 0.3em,
  ),
  ..builderargs,
)

#let builder-thmline(
  color: rgb("#000000"),
  ..builderargs,
) = styled-thmbase.with(
  titlefmt: thmtitle.with(color: color.darken(30%)),
  bodyfmt: thmtext.with(color: color.darken(70%)),
  namefmt: thmname.with(color: color.darken(30%)),
  frame: (
    body-color: color.lighten(92%),
    border-color: color.darken(10%),
    thickness: (left: 2pt),
    inset: 1.2em,
    radius: 0em,
  ),
  ..builderargs,
)

#let problem-style = builder-thmbox(
  color: colors.at(11),
  shadow: (offset: (x: 2pt, y: 2pt), color: luma(70%)),
)


#let theorem-style = builder-thmbox(
  color: colors.at(6),
  shadow: (offset: (x: 3pt, y: 3pt), color: luma(70%)),
)

#let example-style = builder-thmbox(
  color: colors.at(16),
  shadow: (offset: (x: 3pt, y: 3pt), color: luma(70%)),
)

#let theorem = theorem-style("item", "Theorem")
#let lemma = theorem-style("item", "Lemma")
#let corollary = theorem-style("item", "Corollary")

#let problem = problem-style("item", "Problem")
#let definition-style = builder-thmline(color: colors.at(8))

// #let definition = definition-style("definition", "Definition")
#let proposition = definition-style("item", "Proposition")
#let remark = definition-style("item", "Remark")
#let observation = definition-style("item", "Observation")

// #let example-style = builder-thmline(color: colors.at(16))

#let example = example-style("item", "Example")

#let proof(body, name: none) = {
  v(0.5em)
  [_Proof_]
  if name != none {
    [ #thmname[#name]]
  }
  [.]
  body
  h(1fr)

  // Add a word-joiner so that the proof square and the last word before the
  // 1fr spacing are kept together.
  sym.wj

  // Add a non-breaking space to ensure a minimum amount of space between the
  // text and the proof square.
  sym.space.nobreak

  $square.stroked$
  v(0.5em)
}

#let fact = thmplain(
  "item",
  "Fact",
  titlefmt: content => [*#content.*],
  namefmt: content => [_(#content)._],
  separator: [],
  inset: 0pt,
  padding: (bottom: 0.5em, top: 0.5em),
)
#let abuse = thmplain(
  "item",
  "Abuse of Notation",
  titlefmt: content => [*#content.*],
  namefmt: content => [_(#content)._],
  separator: [],
  inset: 0pt,
  padding: (bottom: 0.5em, top: 0.5em),
)
#let definition = thmplain(
  "item",
  "Definition",
  titlefmt: content => [*#content.*],
  namefmt: content => [_(#content)._],
  separator: [],
  inset: 0pt,
  padding: (bottom: 0.5em, top: 0.5em),
)
#let exercise = thmplain(
  "item",
  "Exercise",
  titlefmt: content => [*#content.*],
  namefmt: content => [_(#content)._],
  separator: [],
  inset: 0pt,
  padding: (bottom: 0.5em, top: 0.5em),
)

