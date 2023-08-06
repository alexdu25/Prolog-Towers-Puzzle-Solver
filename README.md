# Prolog-Towers-Puzzle-Solver

Simon Tatham's Tower Puzzle: https://www.chiark.greenend.org.uk/~sgtatham/puzzles/js/towers.html
Here is my implementation of a tower puzzle solver using the declarative programming language Prolog.

The predicate ntower/3 that accepts the following arguments: ntower(N, T, counts(Top, Bottom, Left, Right))
N, a nonnegative integer specifying the size of the square grid.
T, a list of N lists, each representing a row of the square grid. Each row is represented by a list of N distinct integers from 1 through N. The corresponding columns also contain all the integers from 1 through N.
C, a structure with function symbol counts and arity 4. Its arguments are all lists of N integers, and represent the tower counts for the top, bottom, left, and right edges, respectively.

For example, ntower(5, T, counts([2,3,2,1,4],[3,1,3,3,2],[4,1,2,5,2],[2,4,2,1,2])) will output
T = [[2,3,4,5,1],
     [5,4,1,3,2],
     [4,1,5,2,3],
     [1,2,3,4,5],
     [3,5,2,1,4]]
as the solution to the given counts.

The predicate plan_ntower/3 emulates ntower/3 without using GNU Prolog's finite domain solver.

The predicate ambiguous(N, C, T1, T2) uses ntower/3 to find a single N×N Towers puzzle with edges C and two distinct solutions T1 and T2, and uses it to find an ambiguous puzzle.
