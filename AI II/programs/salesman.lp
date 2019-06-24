% The graph encoding 
% cities are nodes

node(1..5).

% starting city

start(1).

% connectivity and distance

edge(1,2,7).edge(1,3,5). edge(1,4,12).
edge(2,5,43). edge(2,4,8). edge(3,5,6).
edge(3,4,100). edge(4,5,9).

% first step -- selecting a route

{path(I,J) : edge(I,J,_)} .       % the edge(I,J,_) is selected for being a part of the route

% need to check whether the selected route going through all cities
% especially we need to reach these cities from the starting node

reachable(1).

reachable(X):- reachable(Y), path(Y,X).

% showing only reachable and route

#show path/2.
#show reachable/1.

% need to make sure that every city is reachable

:- node(X), not reachable(X).

% need to make sure that there is one going out from the city

:- node(X), not #count {J : path(X, J)} = 1.

% need to make sure that there is one going into the city

:- node(X), not #count {J : path(J, X)} = 1.

% this requires that we declare the edges are bi-directional

edge(X,Y,C):- edge(Y,X,C).

% need to minimize the cost

cost(TC) :- TC = #sum {C, X, Y : path(X,Y), edge(X,Y,C)}.

#show cost/1.

#minimize {TC : cost(TC)}.
