#script (python)
import gringo

def __on_model(m):
    print m

def get(val, default):
    return val if val!=None else default

def main(prg):

    imin   = get(prg.get_const("imin"), 1)
    imax   = get(prg.get_const("imax"), 100)
    istop  = get(prg.get_const("istop"), "SAT")

    step   = 0

    prg.ground([("base", [])])

    ret = prg.solve(on_model = __on_model)

    while ((imax is None or step < imax) and
               (step == 0   or step < imin or (
                  (istop == "SAT"     and ret != gringo.SolveResult.SAT) or
                  (istop == "UNSAT"   and ret != gringo.SolveResult.UNSAT) or
                  (istop == "UNKNOWN" and ret != gringo.SolveResult.UNKNOWN)))):

            # print "=== Add cumulative rules to program"
            print "=== Set cumulative(" + str(step)  + ")"

            prg.ground([("step", [step])])

            # print "=== Set external query(" + str(step) +  ") to be true "
            prg.assign_external(gringo.Fun("query", [step]), True)

            ret = prg.solve(on_model = __on_model)
            # print "=== Release external query(" + str(step) + ")   "
            prg.release_external(gringo.Fun("query", [step]))

            if ret == gringo.SolveResult.SAT:
                 print "=== Found solution "
                 break

            step = step+1

#end.


#program base.

number(0..3).

location(l1).           location(l2).       % two banks

% X missionaries and Y cannibals are at location L
fluent(at(X,Y,L)):-      number(X),number(Y),location(L).

% the boat is at location L
fluent(boat_at(L)):-     location(L).

% X missionaries and Y cannibals move from one bank to another
action(cross(I,J,L)):-
   number(I), number(J), location(L), I+J <= 2, I+J > 0.

% initial condition
holds(at(3,3,l1),0).
holds(at(0,0,l2),0).
holds(boat_at(l1),0).

#program step(t).

holds(at(M+P,N+Q,L1),t):-
   number(M), number(N), location(L),
   number(P), number(Q), action(cross(M,N,L)),
   occ(cross(M,N,L), t-1), location(L1),   L!=L1,
   holds(at(P,Q,L1), t-1).

holds(at(P-M,Q-N,L),t):-
     number(M), number(N), location(L),
     number(P), number(Q), action(cross(M,N,L)),
     occ(cross(M,N,L), t-1),
     holds(at(P,Q,L), t-1).

holds(boat_at(L1), t):-
     number(M), number(N), location(L),
     action(cross(M,N,L)), location(L1), L!=L1,
     occ(cross(M,N,L), t-1).

% executability condition
executable(cross(I,J,L), t):-
     number(I), number(J), location(L),
     number(P), number(Q), action(cross(I,J,L)),
     holds(boat_at(L), t),
     holds(at(P, Q, L), t),  P>=I, Q>=J.

% constraint

:- occ(cross(I,J,L), t), not executable(cross(I,J,L), t).

:- holds(at(I,J,L), t), I < J, I > 0.

0 { occ(A, t): action(A) } 1 :- not goal(t).

%#program check(t).

 #external query(t).

% goal

goal(t):- holds(at(3,3,l2), t).

:- query(t), not goal(t).

%occ(cross(1,1,l1), 0).

%occ(cross(1,0,l2), 1).
%occ(cross(0,2,l1), 2).
%occ(cross(0,1,l2), 3).
%occ(cross(2,0,l1), 4).
%occ(cross(1,1,l2), 5).
%occ(cross(2,0,l1), 6).
%occ(cross(0,1,l2), 7).
%occ(cross(0,2,l1), 8).
%occ(cross(0,1,l2), 9).
%occ(cross(0,2,l1), 10).


#show goal/1.
%%#show true(F) : holds(F, t).
#show occ/2.
% #show fluent/1.
% #show holds/2.
