% Specify the grid 

node(1..4, 1..4).

% need to specify the location of the robot at the start
% we are talking about the location of the robot along a time-axis

time(0..n). 
 
%  at(x, y, t): robot is at the location (x,y) at the time t 

at(1, 1, 0).     

% the robot can move up, down, left, right, or do nothing 
% writing and testing single action 

at(X+1,Y,T+1) :- at(X, Y, T), X < 4, right(T). 

at(X-1,Y,T+1) :- at(X, Y, T), X > 1, left(T). 
    
at(X,Y+1,T+1) :- at(X, Y, T), Y < 4, up(T). 

at(X,Y-1,T+1) :- at(X, Y, T), Y > 1, down(T). 

% first method    %%%%%%%%%%%%%%%%%%%%%%%%% 
% making sure if it does nothing it will stay at the same location 
% this is how you can specify the action of donothing 

donothing(T) :- time(T), not right(T), not left(T), not up(T), not down(T).  

at(X, Y, T+1) :- at(X, Y, T), donothing(T). 

% at each time, an action should happen

1 {right(T);  left(T);   up(T);   down(T)} 1 :- time(T), T < n.


% end first method    %%%%%%%%%%%%%%%%%%%%%%%%% 


%%% second method %%%%%%%%%%%%%%%%%%%%%%%%% 
%%% another possibility is to allow the robot to do nothing at some time 
%%% with the statement 
%%
%% 1 {right(T);  left(T);   up(T);   down(T); donothing(T)} 1 :- time(T), T < n.
%% at(X, Y, T+1) :- at(X, Y, T), donothing(T). 
%%   
%%% end second method %%%%%%%%%%%%%%%%%%%%%%%%% 

% reaching the goal 

goal_reach(T):- at(3,3,T). 

:- not goal_reach(n). 

#show at/3.  
#show up/1.
#show down/1.
#show left/1.
#show right/1.


