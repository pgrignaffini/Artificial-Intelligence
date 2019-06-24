#include <incmode>.

% incremental computing 

#program base. 

% the fix part %%%%%%%%%%%%%%%%%%%%%%%%%%%%

% constants 

airplane(a1).
airplane(a2).

airport(sfo).
airport(elp).
airport(lax).

package(p1).
package(p2). 

%%% time(0..length). - remove this - no longer necessary 

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

%%% initial state 

h(at(p1, sfo), 0).
h(at(p2, elp), 0).
h(at(a1, lax), 0).
h(at(a2, elp), 0).

h(-F, 0):- fluent(F), not h(F, 0).

% end the fix part %%%%%%%%%%%%%%%%%%%%%%%%%%%%

#program step(t). 

%%% effects of actions 
 
% positive effect 

h(at(P, A2), t):-  action(fly(P, A1, A2)),
     occ(fly(P, A1, A2), t-1).

% negative effect 

h(-at(P, A1), t):-  action(fly(P, A1, A2)),
     occ(fly(P, A1, A2), t-1).

% executability condition /precondition 

executable(fly(P, A1, A2), t):-  
     action(fly(P, A1, A2)), h(at(P, A1), t).

:- occ(fly(P, A1, A2), t), not executable(fly(P, A1, A2), t).

%% load(P,A) at X

% positive effect 

h(in(P, A), t):- action(load(P, A)), occ(load(P, A), t-1).

% negative effect 

h(-at(P, X), t):-  action(load(P, A)), airport(X),  
     h(at(A, X), t-1), occ(load(P, A), t-1).

% executability condition /precondition 

executable(load(P, A), t):- action(load(P, A)), airport(X),
     h(at(P, X), t), h(at(A, X), t).

:-   occ(load(P, A), t), not executable(load(P, A), t).

%% unload(P,A) at X

% positive effect 

h(at(P, X), t):-  action(unload(P, A)),
     h(at(A, X), t-1), occ(unload(P, A), t-1).

% negative effect 

h(-in(P, A), t):-   action(unload(P, A)),
     occ(unload(P, A), t-1).

% executability condition /precondition 

executable(unload(P, A), t):-  action(unload(P, A)),
     airport(X), h(in(P, A), t), h(at(A, X), t).

:- occ(unload(P, A), t), not executable(unload(P, A), t).

% inertial rules 

h(F,t) :-  fluent(F), h(F,t-1), not h(-F,t).
h(-F,t) :- fluent(F), h(-F,t-1), not h(F,t).

% action generation

1 {occ(A,t): action(A)} 1.

#program check(t).

%%% goal 

goal(t) :- h(at(p1, lax), t), h(at(p2, lax), t).

%% goal(t) :- h(at(p2, lax), t).

:- query(t), not goal(t).

% #show true(F) : fluent(F), h(F,t). 
#show occ/2.




 


