% I assume that the locations on the board are numbered
% (1,1), (1,2), ...., (9,9)
% the topleft corner is (1,1) and the rightbottom corner
% is (9,9)
% row is horizontal
% column is vertical

% cell(i,j,k) means that the number k is placed at the
% location (i,j)
% to run the program use the command
%    lparse sudoku.lp instance | smodels
% where instance is the name of the file describing the
% problem (the website has three examples, download them
% and save them into exp1, exp2, exp3 for example; then
%    lparse sudoku.lp exp1 | smodels solves the first instance)

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

0 {cell(I1,J1,K)} 1:- number(I1), number(J1), number(K).

pair(I,J):- number(I), number(J).
square(1,I,J):- in(1,I), in(1,J).
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
% cell(I,J,k) where I is a number (between 1 and 9)
% J is a number (between 1 and 9)
% in the stable model (if one exists!)

:- number(K), A = #count  {pair(I,J) : cell(I,J,K)}, A != 9.

% for each K, the above rule is equivalent to the following rule:
% 9 {cell(1,1,1), cell(1,2,1),...,cell(9,9,1)} 9 :- number(1).
% between the brackets are all the 81 locations of the board.

% one cell cannot have two numbers
% neq(K1,K2) means that K1 is different than K2

:- cell(I, J, K1), cell(I, J, K2), K1 != K2.

% not in same row
%false:- cell(I, J1, K), cell(I, J2, K), J1 != J2.  
:- cell(I, J1, K), cell(I, J2, K), J1 != J2.

% not in same column

:- cell(I1, J, K), cell(I2, J, K), I1 != I2.

% % not in same square

:- cell(I1, J1, K), cell(I2, J2, K), diff(I1,J1,I2,J2), square(S1, I1, J1), square(S2, I2, J2), S1 == S2.

diff(I1,J1,I2,J2):- number(I1), number(J1), number(I2), number(J2), I1 != I2.
diff(I1,J1,I2,J2):- number(I1), number(J1), number(I2), number(J2), J1 != J2.

#show cell/3.
