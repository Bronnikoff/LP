father("Svanidze Egor", "Svanidze Anton").
mother("CHaadaeva Viktoriya", "Svanidze Anton").
father("Svanidze Egor", "Svanidze SHarlota").
mother("CHaadaeva Viktoriya", "Svanidze SHarlota").
father("Svanidze Egor", "Svanidze Gennadij").
mother("CHaadaeva Viktoriya", "Svanidze Gennadij").
father("Svanidze Petr", "Svanidze Egor").
mother("Istomina Ekaterina", "Svanidze Egor").
father("Svanidze Petr", "Svanidze Liliya").
mother("Istomina Ekaterina", "Svanidze Liliya").
father("Istomin Gennadij", "Istomina Ekaterina").
mother("nk Elizaveta", "Istomina Ekaterina").
father("Istomin Gennadij", "Istomin Stepan").
mother("nk Elizaveta", "Istomin Stepan").
father("CHaadaev Aleksandr", "CHaadaeva Viktoriya").
mother("ZHarova Anastasiya", "CHaadaeva Viktoriya").
father("CHaadaev Aleksandr", "CHaadaev Aleksej").
mother("ZHarova Anastasiya", "CHaadaev Aleksej").
father("CHaadaev Aleksandr", "CHaadaev Petr").
mother("ZHarova Anastasiya", "CHaadaev Petr").
father("ZHarov Mihail", "ZHarova Anastasiya").
mother("Goncharova Elizaveta", "ZHarova Anastasiya").
father("ZHarov Mihail", "ZHarov Georgij").
mother("Goncharova Elizaveta", "ZHarov Georgij").
father("CHaadaev Viktor", "CHaadaev Aleksandr").
mother("Goncharova Evgeniya", "CHaadaev Aleksandr").
father("Goncharov Nikolaj", "Goncharova Elizaveta").
mother("nk Nataliya", "Goncharova Elizaveta").
father("Goncharov Nikolaj", "Goncharova Evgeniya").
mother("nk Nataliya", "Goncharova Evgeniya").
father("CHaadaev Sergej", "CHaadaev Viktor").
father("Svanidze Andrej", "Svanidze Petr").
mother("nk Angelina", "Svanidze Petr").
father("CHaadaev Aleksej", "CHaadaev Evgenij").
mother("nk Ekaterina", "CHaadaev Evgenij").
father("Svanidze Anton", "").
mother("Svanidze SHarlota", "").
father("Svanidze Gennadij", "").
father("CHaadaev Evgenij", "").
father("CHaadaev Petr", "").
father("ZHarov Georgij", "").
father("Istomin Stepan", "").
mother("Svanidze Liliya", "").

shurin(Y, X) :- father(X, Chl), Chl \= "", mother(Moth, Chl), !, father(Ded, Moth), father(Ded, Y), father(Y, _).
shurin(Y, X) :- father(X, Chl), Chl \= "", mother(Moth, Chl), !, mother(Ba, Moth), mother(Ba, Y), father(Y, _).

% близкие родственники:

move(equal, X, X).
move(brother, X, Y) :- mother(Moth, X), mother(Moth, Y), father(X, _), not(move(equal, X, Y)).
move(brother, X, Y) :- father(Moth, X), father(Moth, Y), father(X, _), not(move(equal, X, Y)).
move(father, X, Y) :- father(X, Y).
move(mother, X, Y) :- mother(X, Y).
move(son, X, Y) :- father(Y,X), father(X, _).
move(son, X, Y) :- mother(Y, X), father(X, _).
move(dauther, X, Y) :- father(Y,X), mother(X, _).
move(dauther, X, Y) :- mother(Y, X), mother(X, _).
move(sister, X, Y) :- mother(Moth, X), mother(Moth, Y), mother(X, _), not(move(equal, X, Y)).
move(sister, X, Y) :- father(Moth, X), father(Moth, Y), mother(X, _), not(move(equal, X, Y)).
move(husband, X, Y) :- father(X, Z), mother(Y, Z), Z \= "".
move(wife, Y, X) :-  father(X, Z), mother(Y, Z), Z \= "".

waycreate([X|T], [Y, X|T]):-
  move(_, X, Y),
  not(member(Y, [X|T])).

natural(1).
natural(B) :- natural(A), B is A + 1.

itdpth([A|T], A, [A|T], 0).

itdpth(P, A, L, N) :-
  N > 0,
  waycreate(P, Pl),
  Nl is N - 1,
  itdpth(Pl, A, L, Nl).

id_search(Until, After, L) :-
  natural(N),
  itdpth([Until], After, L, N), write("Степень:"), writeln(N), !.

translator([H, R], [W]) :- move(W, R, H), !.
translator([H, R|T], TQ) :- translator([R|T], TY), move(W, R, H), append(TY, [W], TQ), !.

relative(W, X, X) :- writeln("Степень:0"), W = [equal], !.
relative(W, X, Y) :- id_search(X, Y, L), translator(L, W).

% ==============================================================================

fors(A) :- member(A, [s, for, does]).
quest_first(A) :- member(A, ['Who', who, how, 'How']).
quest_second(A) :- member(A, [many, much]).
areis(A) :- member(A, [is, are]).
shee(A) :- member(A, [she, her]).
hee(A) :- member(A, [he, him]).
haves(A) :- member(A, [have, has]).

dialog :-
  nb_setval(lastName, ""),
  write("Hello, "),
  repeat,
  writeln("Enter your questions in correct form:"),
  readln(Line),
  ((type(Line), fail);(Line = [exit], !)).

% Who is 'ralative' for 'name'?
type([A, B, C, D, E, F, G]):-
  quest_first(A),
  areis(B), fors(D), move(C, _, _),
  (father(X, _);mother(X, _)),
  (equal_name(X, [E, F]);equal_name(X, [F, E])),
  nb_setval(lastName, X),
  move(C, Q, X), !,
  write(C), write(" for "), write(X), write(" is "), writeln(Q).

% Who are 'relative's for 'name'?
type([A, B, C, _,  D, E, F, G, H]):-
  quest_first(A),
  areis(B), fors(D), fors(E), move(C, _, _),
  (father(X, _);mother(X, _)),
  (equal_name(X, [G, F]);equal_name(X, [F, G])),
  nb_setval(lastName, X),
  findall(Q, move(C, Q, X), T), !,
  write(C), write(" for "), write(X), writeln(" is: "), printer(T).

% Who is 'relative's for him/her?
type([A, B, C, _,  D, E, F, H]):-
  quest_first(A),
  areis(B), fors(D), fors(E), move(C, _, _),
  hee(F),
  nb_getval(lastName, X),
  father(X, _),
  findall(Q, move(C, Q, X), T), !,
  write(C), write(" for "), write(X), writeln(" is: "), printer(T).

type([A, B, C, _,  D, E, F, H]):-
  quest_first(A),
  areis(B), fors(D), fors(E), move(C, _, _),
  shee(F),
  nb_getval(lastName, X),
  mother(X, _),
  findall(Q, move(C, Q, X), T), !,
  write(C), write(" for "), write(X), writeln(" is: "), printer(T).


type([A, B, C, _,  D, E, F, H]):-
  quest_first(A),
  areis(B), fors(D), fors(E), move(C, _, _),
  hee(F),
  nb_getval(lastName, X),
  father(X, _),
  move(C, Q, X), !,
  write(C), write(" for "), write(X), write(" is "), write(Q), writeln(".").

type([A, B, C, _,  D, E, F, H]):-
  quest_first(A),
  areis(B), fors(D), fors(E), move(C, _, _),
  shee(F),
  nb_getval(lastName, X),
  mother(X, _),
  move(C, Q, X), !,
  write(C), write(" for "), write(X), write(" is "), write(Q), writeln(".").

  % How many 'relative's does 'name' have?
  type([A, B, C, _,  D, E, F, G, H, _]):-
    quest_first(A), haves(H),
    quest_second(B), fors(D), fors(E), move(C, _, _),
    (father(X, _);mother(X, _)),
    (equal_name(X, [G, F]);equal_name(X, [F, G])),
    nb_setval(lastName, X),
    findall(Q, move(C, Q, X), T), !,
    numizmat(T, N),
    write(X), write(" have "), write(N), write(" "), write(C), writeln("s.").

  type([A, B, C, _,  D, E, F, H, _]):-
    quest_first(A), haves(H), hee(F),
    quest_second(B), fors(D), fors(E), move(C, _, _),
    nb_getval(lastName, X),
    father(X, _),
    findall(Q, move(C, Q, X), T), !,
    numizmat(T, N),
    write(X), write(" have "), write(N), write(" "), write(C), writeln("s.").

  type([A, B, C, _,  D, E, F, H, _]):-
    quest_first(A), haves(H), shee(F),
    quest_second(B), fors(D), fors(E), move(C, _, _),
    nb_getval(lastName, X),
    mother(X, _),
    findall(Q, move(C, Q, X), T), !,
    numizmat(T, N),
    write(X), write(" have "), write(N), write(" "), write(C), writeln("s.").

% =============================================================================

fronttoken(L,W,L1):-atom_chars(L,List),append(ListW,[' '|List1],List),!,
    atom_chars(W,ListW),atom_chars(L1,List1).

pol(Y) :- readln(X), equal(Y, X).
equal_name(X, [H, T]) :-
  fronttoken(X, H, T).

printer([]).
printer([H]) :- writeln(H).
printer([H|T]) :- delete([H|T], H, T1), printer(T1), writeln(H).

numizmat([], 0).
numizmat([H|T], N) :- delete([H|T], H, T1), numizmat(T1, M), N is M + 1.
