%% each node is assigned a color

colored(X,red):- node(X), not colored(X,blue), not colored(X, yellow).
colored(X,blue):- node(X), not colored(X,red), not colored(X, yellow).
colored(X,yellow):- node(X), not colored(X,blue), not colored(X, red).

%% constraint checking 

:- edge(X,Y), colored(X,C), colored(Y,C).

