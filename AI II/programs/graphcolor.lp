% define the graph

node(1).
node(2).
node(3).
node(4).
node(5).

edge(1,2).
edge(1,3).
edge(2,4).
edge(2,5).
edge(3,4).
edge(3,5).

edge(1,5).
edge(2,3).

%% each node is assigned a color

colored(X,red):- node(X), not colored(X,blue), not colored(X, yellow).
colored(X,blue):- node(X), not colored(X,red), not colored(X, yellow).
colored(X,yellow):- node(X), not colored(X,blue), not colored(X, red).

%%#show colored/2.

%% constraint checking

:- edge(X,Y), colored(X,C), colored(Y,C).

%this constraint states: if there's a edge between X and Y, they must not have the same color
