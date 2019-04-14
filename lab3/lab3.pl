manyelems([], X, 0).
manyelems([X|T], X, M) :- !, manyelems(T, X, N), M is N+1.
manyelems([H|T], X, N) :- manyelems(T, X, N).

findem([H|L], H, L) :- !.
findem([H|L], X, [H|L1]) :- findem(L, X, L1).

minuslist(L, [], L) :- !.
minuslist([X|T], [X|T1], L) :- !,  minuslist(T, T1, L).
minuslist([H|T], L, L3) :- findem(L, H, L2), !, minuslist(T, L2, L3).
minuslist([H|T], L, [H|L2]) :- minuslist(T, L, L2).

checkside(X, Y) :- X >= Y, !.
checkside(X, Y) :- X = 0, !.
checkside(_, Y) :- Y = 0, !.

% опишем возможные перемещения перебором возможных вариантов

type(["каннибал", "миссионер", "миссионер"]).
type(["каннибал", "миссионер"]).
type(["миссионер"]).
% будем считать что каннибалы могут перемещаться в лодке без надзора миссионеров
type(["каннибал"]).
type(["каннибал", "каннибал"]).



equal(L, X) :- minuslist(L, X, []).

mymember(st(X, N), [st(H, M)|T]) :- N = M, equal(X, H), !.
mymember(X, [H|T]) :- mymember(X, T), !.

% можно также описать множество возможных переходов перебором всех вариантов, что не рацонально

move(Until, After, 1) :-
  type(Between),
  minuslist(Until, Between, After),
  manyelems(After, "каннибал", N2),
  manyelems(After, "миссионер", M2),
  checkside(M2, N2),
  minuslist(["каннибал", "каннибал", "каннибал", "миссионер", "миссионер", "миссионер"], After, Another),
  manyelems(Another, "каннибал", N3),
  manyelems(Another, "миссионер", M3),
  checkside(M3, N3).

move(Until, After, 2) :-
  type(Between),
  minuslist(After, Between, Until),
  manyelems(After, "каннибал", N2),
  manyelems(After, "миссионер", M2),
  checkside(M2, N2),
  minuslist(["каннибал", "каннибал", "каннибал", "миссионер", "миссионер", "миссионер"], After, Another),
  manyelems(Another, "каннибал", N3),
  manyelems(Another, "миссионер", M3),
  checkside(M3, N3).

% предикат печати списка состояний в более понятной человеку форме

prnt([st(X, 1)]):- write("Берег 1:"), write(X), minuslist(["каннибал", "каннибал", "каннибал", "миссионер", "миссионер", "миссионер"], X, Y), write('~~'), write("Берег 2:"), writeln(Y).
prnt([st(X, _)|T]):- prnt(T), write("Берег 1:"), write(X), minuslist(["каннибал", "каннибал", "каннибал", "миссионер", "миссионер", "миссионер"], X, Y), write('~~'), write("Берег 2:"), writeln(Y).

% предикат, увеличивающий путевой список с проверкой на зацикливание

waycreate([st(X, 1)|T], [st(Y, 2), st(X, 1)|T]):-
  move(X, Y, 1),
  not(mymember(st(Y, 2), [st(X, 1)|T])).

waycreate([st(X, 2)|T], [st(Y, 1), st(X, 2)|T]):-
  move(X, Y, 2),
  not(mymember(st(Y, 1), [st(X, 2)|T])).

% поиск в глубину

dsrch([st(X, 2)|T], X, [st(X, 2)|T]).

dsrch([st(R, N)|P], X, L):-
  waycreate([st(R, N)|P], P1),
  dsrch(P1, X, L).


dpth_search(Until, After):-
 get_time(Time1),
 dsrch([st(Until, 1)], After, L),
 get_time(Time2),
 T is Time2 - Time1,
 write('Time: '),
 writeln(T),
 prnt(L).

% поиск в ширину

bdth([[st(X, 2)|T]|_], X, [st(X, 2)|T]).

bdth([B|P], X, L):-
  findall(W, waycreate(B, W), Q),
  append(P, Q, QP),
  !, bdth(QP, X, L);
  bdth(P, X, L).

 bdth_search(Until, After):-
  get_time(Time1),
  bdth([[st(Until, 1)]], After, L),
  get_time(Time2),
  T is Time2 - Time1,
  write('Time: '),
  writeln(T),
  prnt(L).

% поиск с итерационным углублением

natural(1).
natural(B) :- natural(A), B is A + 1.

itdpth([st(A, 2)|T], A, [st(A, 2)|T], 0).

itdpth(P, A, L, N) :-
  N > 0,
  waycreate(P, Pl),
  Nl is N - 1,
  itdpth(Pl, A, L, Nl).

id_search(Until, After) :-
  get_time(Time1),
  natural(N),
  itdpth([st(Until, 1)], After, L, N),
  get_time(Time2),
  T is Time2 - Time1,
  write('Time: '),
  writeln(T),
  prnt(L), !.
