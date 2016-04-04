# Fractal maze manager

Mazes are graphs with a source node, destination node, and (presumably) one or
more paths between them.

A maze is nested if it contains another maze within it. Suppose that maze A
contains maze B. Graph-wize, B is a subset of A. The boundary between them is
the collection of nodes which are members of both. If B is the extremely
simple maze "edge node 2 connects to 3, 3 connets to edge node 4", and A is
the maze "1 connects to 2 on B, 4 on B connets to 5", then there is a path
from 1 to 5 through B, 1 -> B(from: 2, to: 4, via: [3]) -> 5

Explaining that in advance helps with the next part.

When the inner maze has the same definition as the outer maze, then it also
contains a copy of itself which contains a copy ... etc. Such a maze is
recursive and therefore fractal.

# So what does this do?

This app is for defining, generating, solving and (hopefully) rendering nested
and recursive mazes.
