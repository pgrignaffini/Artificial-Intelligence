%#const length=5.

time(0..length). 

block(a).
block(b).
block(c).

% block(d). 

fluent(on(X,Y)):- block(X), block(Y), X != Y. 
fluent(onTable(X)):- block(X). 
fluent(clear(X)):- block(X).
fluent(holding(X)):- block(X).
fluent(handEmpty). 
 
holds(onTable(a), 0). 
holds(onTable(c), 0).
holds(clear(a), 0).
holds(clear(b), 0).
holds(on(b,c), 0). 
holds(handEmpty,0). 

%%%%%%%%%%%%%%%%%%%%%%%%%
%% negative information 
%%%%%%%%%%%%%%%%%%%%%%%%%

holds(neg(F), 0) :- fluent(F), not holds(F, 0).

%%%%%%%%%%%%%%%%%%%%%%%%%
%% move X on top of Y 
%%%%%%%%%%%%%%%%%%%%%%%%%

action(stack(X,Y)):- block(X), block(Y), X != Y. 

%%%%%%%%%%%%%%%%%%%%%%%%%
%% pick up X which is on top of Y 
%%%%%%%%%%%%%%%%%%%%%%%%%

action(unstack(X,Y)):- block(X), block(Y), X != Y. 

%%%%%%%%%%%%%%%%%%%%%%%%%
%% placing X on the table 
%%%%%%%%%%%%%%%%%%%%%%%%%

action(putdown(X)):- block(X).

%%%%%%%%%%%%%%%%%%%%%%%%%
%% picking up X which is on the table
%%%%%%%%%%%%%%%%%%%%%%%%%
 
action(pickup(X)):- block(X).  

%%%%%%%%%%%%%%%%%%%%%%%%%
%% executablility condition 
%%%%%%%%%%%%%%%%%%%%%%%%%

%% stacking X on Y 

executable(stack(X,Y), T):-  time(T), T < length, action(stack(X,Y)), 
      holds(clear(Y), T), holds(holding(X),T).              
      
%% unstacking X from Y

executable(unstack(X,Y), T):-  time(T), T < length, action(unstack(X,Y)), 
      holds(clear(X), T), holds(on(X,Y), T),  holds(handEmpty,T).              

%% putdown on the table 

executable(putdown(X), T):-  time(T), T < length, action(putdown(X)), 
      holds(holding(X),T). 

%% pickup from the table 

executable(pickup(X), T):-  time(T), T < length, action(pickup(X)), 
      holds(clear(X), T), holds(handEmpty,T), holds(onTable(X), T).              

%% Effect of stacking X on Y 

holds(on(X, Y), T+1):- time(T), occ(stack(X, Y), T). 
holds(clear(X), T+1):- time(T), occ(stack(X, Y), T). 
holds(handEmpty, T+1):- time(T), occ(stack(X, Y), T). 
holds(neg(clear(Y)), T+1):- time(T), occ(stack(X, Y), T). 
holds(neg(holding(X)), T+1):- time(T), occ(stack(X, Y), T). 
%
%%% Effect of unstacking X on Y 

holds(clear(Y), T+1):- time(T), occ(unstack(X, Y), T). 
holds(holding(X), T+1):- time(T), occ(unstack(X, Y), T). 
holds(neg(on(X, Y)), T+1):- time(T), occ(unstack(X, Y), T). 
holds(neg(clear(X)), T+1):- time(T), occ(unstack(X, Y), T). 
holds(neg(handEmpty), T+1):- time(T), occ(unstack(X, Y), T). 

%% Effect of putting X on table 

holds(onTable(X), T+1):- time(T), occ(putdown(X), T). 
holds(clear(X), T+1):- time(T), occ(putdown(X), T). 
holds(handEmpty, T+1):- time(T), occ(putdown(X), T). 
holds(neg(holding(X)), T+1):- time(T), occ(putdown(X), T). 

%%% Effect of pickup  X from table 

holds(holding(X), T+1):- time(T), occ(pickup(X), T). 
holds(neg(onTable(X)), T+1):- time(T), occ(pickup(X), T). 
holds(neg(clear(X)), T+1):- time(T), occ(pickup(X), T). 
holds(neg(handEmpty), T+1):- time(T), occ(pickup(X), T). 

%%% frame axioms 

holds(F, T+1):- time(T), fluent(F), holds(F, T), not holds(neg(F), T+1).
holds(neg(F), T+1):- time(T), fluent(F), holds(neg(F), T), not holds(F, T+1).
 
%% action occurrences

 {occ(A, T) : action(A)} 1:- time(T), T < length.

:- time(T), occ(A, T), not executable(A, T).

%%% planning 
 
% goal(T) :- holds(onTable(c), T),  holds(on(a,c), T), holds(on(b,a), T).

% :- not goal(length). 

% hypothetical reasoning 

%occ(pickup(a),0).
%
%occ(stack(a,b),1).
%

occ(unstack(b,c), 0).
occ(putdown(b), 1). 
occ(pickup(b), 2).
occ(stack(b,a), 3).

#show occ/2. 
%% #show holds/2. 
#show h(F) : holds(F,length), fluent(F). 
   
