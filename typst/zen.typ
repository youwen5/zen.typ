#import "@preview/ctheorems:1.1.3": *
#import "@preview/showybox:2.0.4": showybox

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

#let fonts = (
  sans: "Liberation Sans",
  mono: "CaskaydiaCove Nerd Font",
  serif: "New Computer Modern",
)

#let zen(
  title: "",
  subtitle: "",
  author: "",
  abstract: none,
  bibliography: none,
  paper-size: "a4",
  date: "today",
  big-headings: false,
  outline-separate-page: false,
  date-in-header: true,
  title-in-header: true,
  body,
) = {
  set document(title: title, author: author)

  set std.bibliography(style: "springer-mathphys", title: [References])

  show: thmrules

  set page(
    numbering: "1",
    number-align: center,
    header: context {
      if counter(page).get().first() > 1 {
        box(stroke: (bottom: 0.7pt))[#text(font: fonts.serif)[
            *#author*
            #if date-in-header [
              --- #datetime.today().display("[day] [month repr:long] [year]")
            ]
            #h(1fr)
            #if title-in-header [
              #emph(title)
            ]
            #v(0.4em)
          ]]
      }
    },
    paper: paper-size,
    // The margins depend on the paper size.
    margin: (
      left: (86pt / 216mm) * 100%,
      right: (86pt / 216mm) * 100%,
    ),
  )


  set heading(numbering: "1.1")
  show heading: it => {
    set text(font: fonts.sans)

    block[
      #if it.numbering != none {
        text(rgb("#2196F3"), weight: 500)[#sym.section]

        text(rgb("#2196F3"))[#counter(heading).display() ]
      }
      #it.body
      #v(0.5em)
    ]
  }

  set text(font: fonts.serif, lang: "en")

  show math.equation: set text(weight: 400)


  // Title row.
  align(center)[
    #block(text(weight: 700, font: fonts.sans, 26pt, title))


    #if subtitle != none [#text(12pt, weight: 500, font: fonts.sans)[#(
          subtitle
        )]]

    #v(0.8em)
    #if author != none [#text(16pt)[#smallcaps(author)]]
    #v(1.2em, weak: true)

    #if date == "today" {
      datetime.today().display("[day] [month repr:long] [year]")
    } else {
      date
    }

  ]

  if abstract != none [
    #v(1.8em)
    #set text(font: fonts.serif)
    #pad(x: 14%, abstract)
    #v(1em)
  ]

  show outline: set heading(numbering: none)
  show outline: set par(first-line-indent: 0em)
  set outline(depth: 2)

  show outline.entry.where(level: 1): it => {
    text(font: fonts.serif, weight: 600, rgb("#2196F3"), it)
  }
  show outline.entry: it => {
    text(font: fonts.serif, rgb("#2196F3"), it)
  }
  show outline: it => {
    it
    if outline-separate-page {
      pagebreak()
    }
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
    font: fonts.serif,
    weight: "semibold",
    fill: color,
  )[#t]
}
#let thmname(t, color: rgb("#000000")) = {
  return text(font: fonts.serif, fill: color)[(#t)]
}

#let thmtext(t, color: rgb("#000000")) = {
  let a = t.children
  if (a.at(0) == [ ]) {
    a.remove(0)
  }
  t = a.join()

  text(font: fonts.serif, fill: color)[#t]
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
  separator: none,
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


#let theorem-style = builder-thmbox(
  color: colors.at(6),
  shadow: (offset: (x: 3pt, y: 3pt), color: luma(70%)),
)

#let example-style = builder-thmbox(
  color: colors.at(2),
  shadow: (offset: (x: 3pt, y: 3pt), color: luma(70%)),
)



#let theorem = theorem-style("item", "Theorem")
#let lemma = theorem-style("item", "Lemma")
#let corollary = theorem-style("item", "Corollary")
#let example = example-style("item", "Example")



#let proposition-style = builder-thmline(color: colors.at(8))
#let remark-style = builder-thmline(color: colors.at(0))
#let problem-style = builder-thmline(color: colors.at(4))
#let recipe-style = builder-thmline(color: colors.at(17))
#let exercise-style = builder-thmline(color: colors.at(11))

#let proposition = proposition-style("item", "Proposition")
#let remark = remark-style("item", "Remark")
#let observation = remark-style("item", "Observation")
#let exercise = exercise-style("item", "Exercise")
#let problem = problem-style("item", "Problem")
#let recipe = recipe-style("item", "Recipe")


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
#let axiom = thmplain(
  "item",
  "Axiom",
  titlefmt: content => [*#content.*],
  namefmt: content => [(#emph(content)).],
  separator: [],
  inset: 0pt,
  padding: (bottom: 0.5em, top: 0.5em),
)

#let solution = (..args) => showybox(
  breakable: true,
  title-style: (
    weight: "semibold",
    color: colors.at(0).darken(40%),
    sep-thickness: 0pt,
  ),
  frame: (
    title-color: colors.at(0).lighten(80%),
    border-color: colors.at(0).darken(40%),
    thickness: (left: 1.5pt),
    radius: 0pt,
  ),
  title: (
    () => {
      if (args.pos().len() > 1) {
        return [Solution#text(weight: "medium",[ (#args.at(0))])]
      }
      "Solution"
    }
  )(),
)[
  #if args.pos().len() > 1 {
    args.at(1)
  } else {
    args.at(0)
  }
]

#let numbered-figure = (caption: none, ..opts) => {
  let base = thmenv(
    "item",
    "heading",
    none,
    (name, number, body, color: black) => {
      show figure.caption: it => [
        Figure #number#if (caption != none) [: #it.body]
      ]
      pad(
        y: 5pt,
        figure(
          body,
          numbering: none,
          caption: if caption == none { "" } else { caption },
        ),
      )
    },
  ).with(supplement: "Figure")
  base(..opts)
}

