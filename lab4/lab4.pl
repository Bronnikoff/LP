parent(alexey, tolya).
parent(alexey, volodya).
parent(tolya, tima).
parent(gena, sergey).
parent(gena, alexey).
parent(gena, oleg).
parent(oleg, misha).


padej(tolya, toli, tolin).
padej(alexey, alexeya, alexeev).
padej(tima, timi, timin).
padej(volodya, volodi, volodin).
padej(gena, geni, genin).
padej(oleg, olega, olegov).
padej(misha, mishi, mishin).
padej(sergey, sergeya, sergeev).



move(equal, X, X).
move(brat, X, Y) :- parent(Moth, X), parent(Moth, Y), not(move(equal, X, Y)).
move(papa, X, Y) :- parent(X, Y).
move(son, X, Y) :- parent(Y,X).
move(ded, X, Y) :- parent(X, W), parent(W, Y).

quest_first(A) :- member(A, ['Kto', kto]).
quest_second(A) :- member(A, [chei, 'Chei']).

% kto brat toli?
anwser([A, B, C, '?'], Ans):-
  quest_first(A),
  move(B, _, _),
  padej(X, C, Y),
  (parent(X, _);parent(_, X)),
  findall(Q, move(B, Q, X), Ans),
  nb_setval(lastName, X),
  write(Y), write(" "), write(B), writeln(" eto: "), !.

% kto ego brat?

anwser([A, ego, B, '?'], Ans):-
  quest_first(A),
  move(B, _, _),
  nb_getval(lastName, X),
  padej(X, _, Y),
  findall(Q, move(B, Q, X), Ans),
  write(Y), write(" "), write(B), writeln(" eto: "), !.

% Chei brat volodya?
 anwser([A, B, X, '?'], Ans):-
  quest_second(A),
  move(B, _, _),
  padej(X, C, _),
  (parent(X, _); parent(_, X)),
  nb_setval(lastName, X),
  findall(Q, (move(B, X, U), padej(U, Q, _)), Ans),
  write(X), write(" - eto "), writeln(B), !.

  % Chei on brat?
   anwser([A, on, B, '?'], Ans):-
    quest_second(A),
    move(B, _, _),
    nb_getval(lastName, X),
    findall(Q, (move(B, X, U), padej(U, Q, _)), Ans),
    write(X), write(" - eto "), writeln(B), !.

% volodya brat toli?
anwser([A, B, C, '?'], Ans):-
  (parent(A, _); parent(_, A)),
  move(B, _, _),
  padej(X, C, _),
  nb_setval(lastName, A),
  move(B, A, X), !.


printer([]).
printer([H]) :- writeln(H).
printer([H|T]) :- delete([H|T], H, T1), printer(T1), writeln(H).

numizmat([], 0).
numizmat([H|T], N) :- delete([H|T], H, T1), numizmat(T1, M), N is M + 1.
