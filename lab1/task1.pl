% my realisation of predicate 'member'

mymember(Elem, [Elem]):-!.
mymember(Elem, [Elem|_]).
mymember(Elem, [_|T]):- mymember(Elem, T).

% my realisation of predicate 'append'

myappend([], L, L).
myappend([H|T], L, [H|Tl]):-myappend(T, L, Tl).

% my realisation of predicate 'length'

mylength([], 0).
mylength([_|T], L):-mylength(T, N), L is N + 1.

% my realisation of predicate 'remove'('delete' in SWI)

myremove([], _, []):-!.
myremove([Elem|Tail], Elem, ResultTail):-
   myremove(Tail, Elem, ResultTail), !.
myremove([Head|Tail], Elem, [Head|ResultTail]):-
   myremove(Tail, Elem, ResultTail).

% my realisation of predicate 'sublist'(SWI have similar alike 'subset')

sub_start([], _):-!.
sub_start([Head|TailSub], [Head|TailList]):-
   sub_start(TailSub, TailList).
mysublist(Sub, List):-
   sub_start(Sub, List), !.
mysublist(Sub, [_|Tail]):-
   mysublist(Sub, Tail).

% my realisation of predicate 'select' for realisation next predicate

myselect(Elem, [Elem|Tail], Tail).
myselect(Elem, [Head|Tail], [Head|Rt]):-myselect(Elem, Tail, Rt).

% my predicate 'permure'

mypermute([], []).
mypermute([X|Rest], L) :-mypermute(Rest, L1), myselect(X, L, L1).

%-------------------------------------------------------------------------------

% first realisation of predicate for working with lists from varios №2:
% Delete last element in list

myfirst_pred([H], []) :- !.
myfirst_pred([P,_], [P]) :- !.
myfirst_pred([H|T], [H|TR]) :- myfirst_pred(T, TR).

% second realisation with library predicates

first_pred(L, X):-reverse(L, [H|T]), reverse(T, X).

%-------------------------------------------------------------------------------

% first realisation of predicate for works with list of numbers from varios №7:
% Check list of numbers on sort elements position

mysecond_pred([]).
mysecond_pred([H]):-!.
mysecond_pred([H|[Hd|T]]):- H < Hd, mysecond_pred([Hd|T]).

% second realisation with library predicates
second_pred(L):-sort(L, L).

%-------------------------------------------------------------------------------

% example of use two predicates
% get last element of list:
pop_pred(L, X) :- myfirst_pred(L, Ll), myappend(Ll, [X], L).

