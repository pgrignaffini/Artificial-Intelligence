
% Defining the constants%
time(0..length).  

% Three missionaries/three cannibals 
number(0..3). 

% Two banks of the river
location(l1).           
location(l2).      

% X missionaries and Y cannibals are at location L 
fluent(at(X,Y,L)):- number(X),number(Y),location(L).

% X missionaries and Y cannibals are in the boat 
fluent(in_boat(X,Y)):- number(X),number(Y).

% the boat is at location L
fluent(boat_at(L)):- location(L).

% The boat moves from one bank to another  
action(cross(L)):-   location(L).

% X missionaries and Y cannibals depart the boat  
action(depart(I,J)):- 
   number(I), number(J), I+J>0.

% X missionaries and Y cannibals get on the boat  
action(board(I,J)):- 
   number(I), number(J), I+J>0.

% Effects of departing from the boat
% increasing the number of individuals on the bank 
holds(at(M+P,N+Q, L),T+1):-  time(T), 
   occ(depart(M,N), T), 
   holds(boat_at(L), T),  
   holds(at(P,Q,L), T), 
   holds(in_boat(X,Y), T), 
   M <= X, N <= Y. 

% reducing the number in the boat 
holds(in_boat(P,Q),T+1):-  time(T), 
   occ(depart(M,N), T), 
   holds(boat_at(L), T),
   fluent(in_boat(P,Q)),
   holds(in_boat(M+P,N+Q), T). 

% does not change the number of individuals on the other bank 
holds(at(P,Q,L1),T+1):-  time(T), 
   occ(depart(M,N), T), 
   holds(boat_at(L), T),  
   holds(at(P,Q,L1), T),
   location(L1), L1!=L.   

% does not change the location of the boat 
holds(boat_at(L), T+1):-  time(T), 
   location(L),
   holds(boat_at(L), T), 
   action(depart(M,N)),
   occ(depart(M,N), T).

% boarding to the boat
% reducing the number of individuals on the bank 
holds(at(M-P,N-Q,L),T+1):-  time(T), 
   occ(board(P,Q), T), 
   holds(boat_at(L), T),  
   holds(at(M,N,L), T),
   M >=P, N >= Q. 

% increasing the number of individuals in the boat 
holds(in_boat(M+P,N+Q),T+1):-  time(T), 
   occ(board(P,Q), T), 
   holds(boat_at(L), T),  
   holds(in_boat(M,N), T). 

% does not change the number of individuals on the other bank  
holds(at(M,N,L1),T+1):-  time(T), 
   occ(board(P,Q), T), 
   holds(boat_at(L), T),  
   holds(at(M,N,L1), T),
   location(L1), L1!=L.   

% does not change the location of the boat 
holds(boat_at(L), T+1):-  time(T), 
   location(L),
   action(board(P,Q)),
   holds(boat_at(L), T), 
   occ(board(P,Q), T).

% boat crossing 
% change the location of the boat 
holds(boat_at(L1),T+1):-
     time(T), location(L1), L!=L1,
     occ(cross(L), T).

% does not change the number of individuals in the boat 
holds(in_boat(M,N), T+1):- 
     time(T), 
     holds(in_boat(M,N), T), 
     occ(cross(L), T).

% does not change the number of individuals on the banks 
holds(at(M,N,L1),T+1):-  time(T), 
     occ(cross(L), T),   
     holds(at(M,N,L1), T),
     location(L1).   

 
% executability condition%
executable(cross(L), T):-
     time(T), holds(in_boat(I,J),T), I+J>0, 
     action(cross(L)), 
     holds(boat_at(L), T).

executable(board(M,N), T):-
     time(T), 
     action(board(M,N)), 
     holds(boat_at(L), T), 
     holds(in_boat(P,Q), T), 
     holds(at(X,Y,L), T),
     X>=M, Y>=N, M+N>0, M+N+P+Q<=2.

executable(depart(M,N), T):-
     time(T), 
     action(depart(M,N)),  
     holds(in_boat(P,Q), T), 
     M<=P, N<=Q, M+N>0.

% initial condition%

holds(at(3,3,l1),0). 
holds(at(0,0,l2),0). 
holds(boat_at(l1),0). 
holds(in_boat(0,0),0).
  
% constraint%
bad(1,T)
:- time(T), action(A), occ(A, T), not executable(A, T).

bad(2,T)
:- number(I), number(J), location(L), 
   time(T), holds(at(I,J,L), T), I<J, I> 0.

% goal%
%:- not goal(length).

goal(T):- holds(at(3,3,l2), T). 

1 { occ(A, T): action(A) } 1 :- time(T), T < length.


pos(F, T) :- fluent(F), holds(F, T).

occ(board(1,1),0).    %[2,2] [1,1] [0,0] l1
occ(cross(l1),1).
occ(depart(0,1),2).   %[2,2] [1,0] [0,1] l2
occ(cross(l2),3).
occ(depart(1,0),4).   %[3,2] [0,0] [0,1] l1
occ(board(0,2),5).    %[3,0] [0,2] [0,1] 
occ(cross(l1),6).
occ(depart(0,1),7).   %[3,0] [0,1] [0,2] l2
occ(cross(l2),8).
occ(depart(0,1),9).   %[3,1] [0,0] [0,2] l1
occ(board(2,0),10).    %[1,1] [2,0] [0,2] 
occ(cross(l1),11).
occ(depart(2,0),12).   %[1,1] [0,0] [2,2] l2
occ(board(1,1),13).    %[1,1] [1,1] [1,1] 
occ(cross(l2),14).
occ(depart(1,1),15).   %[2,2] [0,0] [1,1] l1
occ(board(2,0),16).    %[0,2] [2,0] [1,1] 
occ(cross(l1),17).
occ(depart(2,0),18).   %[0,2] [0,0] [3,1] l2
occ(board(0,1),19).    %[0,2] [0,1] [3,0] 
occ(cross(l2),20).
occ(board(0,1),21).    %[0,1] [0,2] [3,0] l1 
occ(cross(l1), 22). 
occ(depart(0,1),23).   %[0,1] [0,1] [3,1] l2
occ(cross(l2),24).
occ(board(0,1),25).    %[0,0] [0,2] [3,1] l1
occ(cross(l1), 26). 
occ(depart(0,2),27).   %[0,0] [0,0] [3,3] l2




#show pos/2. 
#show bad/2.


%pos(at(3,3,l1),0) pos(at(0,0,l2),0) pos(in_boat(0,0),0) pos(boat_at(l1),0)
%occ(board(1,1),0).  
%pos(at(2,2,l1),1) pos(at(0,0,l2),1) pos(in_boat(1,1),1) pos(boat_at(l1),1)
%occ(cross(l1),1).
%pos(at(2,2,l1),2) pos(at(0,0,l2),2) pos(in_boat(1,1),2) pos(boat_at(l2),2) 
%occ(depart(0,1),2). 
%pos(at(2,2,l1),3) pos(at(0,1,l2),3) pos(in_boat(1,0),3) pos(boat_at(l2),3) 
%occ(cross(l2),3).
%pos(at(2,2,l1),4) pos(at(0,1,l2),4) pos(in_boat(1,0),4) pos(boat_at(l1),4)  
%occ(depart(1,0),4). 
%pos(at(3,2,l1),5) pos(at(0,1,l2),5) pos(in_boat(0,0),5) pos(boat_at(l1),5)


 
