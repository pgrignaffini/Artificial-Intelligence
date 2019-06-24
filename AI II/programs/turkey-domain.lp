% Defining the steps 
time(0..length).  

% Defining fluents 
fluent(loaded).   fluent(dead).  fluent(walking).  % fluent(alive).

% Defining actions 
action(load).     action(shoot).

% Representing action's effects 
executable(shoot, T):- time(T). 
holds(dead, T+1) :- occ(shoot, T), holds(loaded, T). 
holds(neg(loaded), T+1) :- time(T), occ(shoot, T). 
executable(load, T):- time(T), holds(neg(loaded), T). 
holds(loaded, T+1) :- time(T), occ(load, T).

% The inertial rule 
holds(F,T+1):-  time(T), fluent(F), holds(F,T), not holds(neg(F),T+1). 
holds(neg(F),T+1):-  time(T), fluent(F), holds(neg(F),T), not holds(F,T+1).

% Static causal law 
 holds(neg(walking), T):- time(T), holds(dead, T). 
