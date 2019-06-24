% representing the board, using n as a constant
col(1..n).   % n column
row(1..n).   % n row

% generating solutions
1 {q(I,J) : row(J) } 1:-  col(I).

% two queens cannot be on the same row/column
:- col(I), row(J1), row(J2),  J1!=J2, q(I,J1), q(I,J2).
:- row(J), col(I1), col(I2), I1!=I2, q(I1,J), q(I2,J).

% two queens cannot be on a diagonal
:- row(J1), row(J2), J1 > J2, col(I1), col(I2), I1 > I2,
   q(I1,J1), q(I2,J2), I1 - I2 == J1 - J2.

:- row(J1), row(J2), J1 > J2, col(I1), col(I2), I1 < I2,
   q(I1,J1), q(I2,J2), I2 - I1 == J1 - J2.

%to show all the possible solutions put 0 at the end of the clingo input command
