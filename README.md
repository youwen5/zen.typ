# zen.typ

A beautifully handcrafted Typst template forked from
[dvdtyp](https://typst.app/universe/package/dvdtyp/), for the stubborn enlightened mathematician.

> It is a tale as old as time. A melodramatic, LaTeX dwelling mathematician,
> envious of the features of modern word processors, spirals into despair
> before succumbing to the [dark side](https://typst.app/). This is his template.

It's been adjusted to be a little more sophisticated (in my eyes) and polished.
Inspiration and general conventions were taken from Evan Chen's
[evan.sty](https://github.com/vEnhance/dotfiles/blob/main/texmf/tex/latex/evan/evan.sty).

![image](https://github.com/user-attachments/assets/5e4d27aa-b68e-45e4-8e8a-41381b7df537)

## Conventions

This template provides the following functions, which function similarly to the
ones in `evan.sty`:

```typst
// for turn-key exercises designed to reinforce understanding
#exercise

// facts stated without justification or proof
#fact

#definition

#proof
// for abuses of notation i.e. when notation is elided or shortened or
// otherwise changed for brevity
#abuse

// the below functions show in a large colored block to draw attention

#example

#theorem

// for non-trivial problems
#problem

#corollary

#remark
```

Each function besides `proof` can be called with a title and body argument or simply just the body argument.

```typst
#theorem[
    Every continuous function from an $n$-sphere to Euclidean $n$-space maps
    some pair of antipodal points to the same point.
]

// the following are equivalent uses

#theorem(title: "Fundamental theorem of arithmetic")[
    Each integer greater than 1 can be written as the unique product of primes.
]

#theorem[Euclid's][
    There are an infinite amount of prime numbers.
]
```

Also it can set up the document, via

```typst
#show: zen.with(
  title: "My Title",
  author: "Youwen Wu",
  date: #datetime(day: 1, month: 1, year: 1970).display(),
  subtitle: [Wonderful],
  abstract: [
    In the broad light of day mathematicians check their equations and their
    proofs, leaving no stone unturned in their search for rigour. But, at night,
    under the full moon, they dream, they float among the stars and wonder at the
    miracle of the heavens. They are inspired. Without dreams there is no art, no
    mathematics, no life.
    #align(end, [-- Michael Atiyah])
  ],
)
```

## Usage

Review the Typst documentation to see how to install packages. Since this isn't
in the Typst official repository yet, it cannot be download automatically and
you need to copy it into your Typst package cache manually (on Linux it is
`~/.cache/typst/packages`).

Alternatively, a home-manager module is provided for NixOS users to
automatically install the template to be discoverable by Typst, under
`@youwen/zen` (e.g. you can use `import "@youwen/zen:0.1.0 : *`).

Add `zenTyp` to your inputs, then import `inputs.zenTyp.homeManagerModules.default` into your home-manager configuration, then set

```nix
zenTyp.enable = true;
```

Then the package will be available on the machine.
