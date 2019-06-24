
% constants

airplane(a1).
airplane(a2).

airport(sfo).
airport(elp).
airport(lax).

package(p1).
package(p2). 

time(0..length).

%% fluent

fluent(at(P, A)):- airplane(P), airport(A).
fluent(at(P, A)):- package(P), airport(A).
fluent(in(P, A)):- package(P), airplane(A).

%% actions

% fly

action(fly(P, A1, A2)):-
     airplane(P), airport(A1), airport(A2), A1!=A2.

% loading/unloading

action(load(P, A)):-
     package(P), airplane(A).

action(unload(P, A)):-
     package(P), airplane(A).

%%% effects of actions

% positive effect

h(at(P, A2), T+1):- time(T),
     action(fly(P, A1, A2)),
     occ(fly(P, A1, A2), T).

% negative effect

h(-at(P, A1), T+1):- time(T),
     action(fly(P, A1, A2)),
     occ(fly(P, A1, A2), T).

% executability condition /precondition

executable(fly(P, A1, A2), T):- time(T),
     action(fly(P, A1, A2)),
     h(at(P, A1), T).

:- time(T), occ(fly(P, A1, A2), T), not executable(fly(P, A1, A2), T).

%% load(P,A) at X

% positive effect

h(in(P, A), T+1):- time(T),
     action(load(P, A)),
     occ(load(P, A), T).

% negative effect

h(-at(P, X), T+1):- time(T),
     action(load(P, A)),
     h(at(A, X), T),
     occ(load(P, A), T).

% executability condition /precondition

executable(load(P, A), T):- time(T),
     action(load(P, A)),
     airport(X),
     h(at(P, X), T),
     h(at(A, X), T).

:- time(T), occ(load(P, A), T), not executable(load(P, A), T).

%% unload(P,A) at X

% positive effect

h(at(P, X), T+1):- time(T),
     action(unload(P, A)),
     h(at(A, X), T),
     occ(unload(P, A), T).

% negative effect

h(-in(P, A), T+1):- time(T),
     action(unload(P, A)),
     occ(unload(P, A), T).

% executability condition /precondition

executable(unload(P, A), T):- time(T),
     action(unload(P, A)),
     airport(X),
     h(in(P, A), T),
     h(at(A, X), T).

:- time(T), occ(unload(P, A), T), not executable(unload(P, A), T).

h(F,T+1) :- time(T), fluent(F), h(F,T), not h(-F,T+1).
h(-F,T+1) :- time(T), fluent(F), h(-F,T), not h(F,T+1).


%%% initial state

h(at(p1, sfo), 0).
h(at(p2, elp), 0).
h(at(a1, lax), 0).
h(at(a2, elp), 0).

h(-F, 0):- fluent(F), not h(F, 0).

%%% goal

goal(T) :- time(T), h(at(p1, lax), T), h(at(p2, lax), T).

:- not goal(length).

{occ(A,T): action(A)} 1 :- time(T), T < length.

#show true(F) : fluent(F), h(F,length).
#show occ/2.
