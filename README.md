# Overview

This was developed as part of the **Logic for Programming (LP)** course at IST-UL.

The objective was to implement a Prolog-based solver for the classic logic puzzle “Tents and Trees”.

This project leverages constraint logic programming and backtracking to automatically solve grid-based puzzles under strict logical constraints.

# Data Representation

A puzzle is represented as:
- `(Tabuleiro, TendasPorLinha, TendasPorColuna)`
  + Translated: `(Table, TentsPerLine, TentsPerColumn)`

Example:
```text
([
[_, _, _, _, a, _],
[a, _, _, _, _, _],
[_, a, _, a, a, _],
[_, _, _, a, _, a],
[_, _, _, _, _, _],
[_, a, _, _, _, _]],
[2,1,2,1,1,1],
[3,0,1,1,0,3])
```

Symbols:
- a → tree
- t → tent
- r → grass
- _ → empty cell

# Usage

- Using puzzle from the auxiliary file ``puzzlesAcampar.pl`
```text
?- puzzle(6-14, P), resolve(P).
```

- Manually inserting data
```text
?- P = ([
[_, a, _, a, _, _],
[a, _, _, _, _, _],
[_, _, _, _, _, _],
[_, _, a, a, _, _],
[_, _, _, _, _, _],
[_, a, _, _, a, _]],
[3, 0, 1, 1, 1, 1], [2, 1, 1, 1, 2, 0]), resolve(P).
```

- Output
```text
P = ([[t,a,t,a,t,r],
      [a,r,r,r,r,r],
      [r,r,r,t,r,r],
      [r,t,a,a,r,r],
      [r,r,r,r,t,r],
      [t,a,r,r,a,r]],
     [3,0,1,1,1,1],
     [2,1,1,1,2,0]).
```

# Technologies

- Language: Prolog
- Interpreter: [SWI-Prolog](https://www.swi-prolog.org/Download.html)
