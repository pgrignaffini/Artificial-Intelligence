% place queens on the chess board

{ q(1..n,1..n) }.

% exactly 1 queen per row/column

:-X=1..n,not#count{ Y:q(X,Y) } =1.
:-Y=1..n,not#count{ X:q(X,Y) } =1.

% pre-calculate the diagonals

d1(X,Y,X-Y+n) :- X = 1..n, Y = 1..n.
d2(X,Y,X+Y-1) :- X = 1..n, Y = 1..n.

% at most one queen per diagonal
:- D = 1..n*2-1, 2 { q(X,Y) : d1(X,Y,D) }.
:- D = 1..n*2-1, 2 { q(X,Y) : d2(X,Y,D) }.
