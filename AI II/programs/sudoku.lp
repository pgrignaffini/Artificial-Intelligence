% I assume that the locations on the board are numbered
% (1,1), (1,2), ...., (9,9)
% the topleft corner is (1,1) and the rightbottom corner
% is (9,9)
% row is horizontal
% column is vertical

% answer(i,j,k) means that the number k is placed at the
% location (i,j)
% to run the program use the command
%    clingo sudoku.lp

answer(1,1,2).
answer(1,3,9).
answer(1,4,6).
answer(1,6,5).
answer(2,2,5).
answer(2,3,7).
answer(2,4,9).
answer(2,8,1).

answer(3,2,1).
answer(3,3,3).
answer(3,6,7).
answer(3,8,6).
answer(3,9,9).

answer(4,1,5).
answer(4,3,1).
answer(4,5,7).
answer(4,9,4).

answer(5,4,5).
answer(5,6,6).

answer(6,1,9).
answer(6,5,8).
answer(6,7,2).
answer(6,9,5).

answer(7,1,4).
answer(7,2,9).
answer(7,4,1).
answer(7,7,3).
answer(7,8,5).

answer(8,2,6).
answer(8,6,3).
answer(8,7,9).
answer(8,8,4).

answer(9,4,8).
answer(9,6,4).
answer(9,7,1).
answer(9,9,6).

% define that 1,..,9 are number
% (i.e., number(1),...,number(9) are facts of the program
%

number(1..9).

% defining the small squares
% e.g. the locations (I,J) for in1(I) and in1(I) are true
%      represents the first square

in(1,N) :- number(N), N >= 1, N <= 3.
in(2,N) :- number(N), N >= 4, N <= 6.
in(3,N) :- number(N), N >= 7, N <= 9.

0 {answer(I1,J1,K)} 1:- number(I1), number(J1), number(K).

pair(I,J):- number(I), number(J).
square(1,I,J):- in(1,I), in(1,J). %to belong to the first square: I = 1..3, J = 1..3
square(2,I,J):- in(1,I), in(2,J).
square(3,I,J):- in(1,I), in(3,J).
square(4,I,J):- in(2,I), in(1,J).
square(5,I,J):- in(2,I), in(2,J).
square(6,I,J):- in(2,I), in(3,J).
square(7,I,J):- in(3,I), in(1,J).
square(8,I,J):- in(3,I), in(2,J).
square(9,I,J):- in(3,I), in(3,J).


% for each number k (k=1,...,9)
% there are exactly 9 atoms of the from
% answer(I,J,k) where I is a number (between 1 and 9)
% J is a number (between 1 and 9)
% in the stable model (if one exists!)

:- number(K), A = #count  {pair(I,J) : answer(I,J,K)}, A != 9.

% if there's not left hand side to the definition, it means that's false
% per ogni numero che viene inserito nella tabella del sudoku, ci sono esattamente 9 istanze di esso all'interno della soluzione
% il numero 1 compare 9 volte, il numero 2 compare 9 volte ecc...

% for each K, the above rule is equivalent to the following rule:
% 9 {answer(1,1,1), answer(1,2,1),...,answer(9,9,1)} 9 :- number(1).
% between the brackets are all the 81 locations of the board.

% one cell cannot have two numbers
% neq(K1,K2) means that K1 is different than K2

:- answer(I, J, K1), answer(I, J, K2), K1 != K2.
%se ho due numeri K1, K2, nella stessa cella, significa che K1 = K2

% not in same row

:- answer(I, J1, K), answer(I, J2, K), J1 != J2.
%stessa riga, colonna diversa, stesso numero => le due colonne devono essere la stessa

% not in same column

:- answer(I1, J, K), answer(I2, J, K), I1 != I2.

% not in same square

:- answer(I1, J1, K), answer(I2, J2, K), diff(I1,J1,I2,J2), square(S1, I1, J1), square(S2, I2, J2), S1 == S2.

diff(I1,J1,I2,J2):- number(I1), number(J1), number(I2), number(J2), I1 != I2.
diff(I1,J1,I2,J2):- number(I1), number(J1), number(I2), number(J2), J1 != J2.

#show answer/3.
