% problem

table(1).
table(2).

person(mike).
person(ann).
person(sally).
person(john).

% solutions generation

at(X, 1):- person(X), not at(X, 2).
at(X, 2):- person(X), not at(X, 1).

not_ok :- table(Y), at(mike, Y), person(P), P!=mike,
          P!= ann, at(P, Y).

not_ok :- table(Y), at(ann, Y), not at(sally, Y).

:- not_ok.

#show at/2.           
