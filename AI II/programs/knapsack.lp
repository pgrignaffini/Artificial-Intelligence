% define the items
item(1..5).

% value of items

value(1,4). value(2,2). value(3,1). value(4,10). value(5,2).

% weight of items
weight(1,12). weight(2,2). weight(3,1). weight(4,4). weight(5,1).

% select the item to put in the knapsack
% di default a sinistra della graffa c'è 0, a destra il numero di elementi del set
{in(I)} :- item(I).

% compute the weight
total_weight(W) :- W = #sum {N,I : in(I), weight(I,N)}.

% making sure that the weight is not more than the capacity
:- total_weight(W), W > 15.

% compute the total value

total_value(V) :- V = #sum {VA,I : in(I), value(I, VA)}.

#maximize {V : total_value(V)}.
