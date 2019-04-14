# Отчет по курсовому проекту
## по курсу "Логическое программирование"

### студент: Бронников М. А.

## Результат проверки

| Преподаватель     | Дата         |  Оценка       |
|-------------------|--------------|---------------|
| Сошников Д.В. |    27.12.18          |   4            |
| Левинская М.А.|              |               |

> По рез-татам собеседования

## Введение
В результате выполнения курсового проекта я получила следующие навыки и знания:
1. Я поновому взглянул на логическое программирование, до этого я думал, что это топроная сфера основаная на узком понятии математики, но оказалось это набор довольно гибких языков, позволяющих удобно и быстро обрабатывать различные базы данных и успешно решать логические задачи.
2. Мне понравилась идея с работой над семейным древом, довольно практичный пример, котороый можно встретить в реальной жизни, также это помогло мне получше узнать свои корни.
3. Написал парсер, производящий обработку формата GEDCOM, парсер писал на Cи, так как Python до этого не знал, а про то что он удобней узнал, после того как работа была выполнена.
4. начиная с определения степени родства, задачи стали не такими тривиальными, пришлось углубиться в тему, но в конечном итоге пришёл к выводу, что оно похоже на 3 лабараторную работу, связанную с поиком в пространсве состояний. Дальше рабоут выполнил довольно быстро.
5. закрепил навыки, полученные в 4 лабораторной работе, потренировался в грамматическом разборе предложений.


## Задание

 1. Создать родословное дерево своего рода на несколько поколений (3-4) назад в стандартном формате GEDCOM с использованием сервиса MyHeritage.com 
 2. Преобразовать файл в формате GEDCOM в набор утверждений на языке Prolog, используя следующее представление: с использованием предикатов father(отец, потомок) и mother(мать, потомок)
 3. Реализовать предикат проверки/поиска шурина. 
 4. Реализовать программу на языке Prolog, которая позволит определять степень родства двух произвольных индивидуумов в дереве
 5. [На оценки хорошо и отлично] Реализовать естественно-языковый интерфейс к системе, позволяющий задавать вопросы относительно степеней родства, и получать осмысленные ответы. 

## Получение родословного дерева

Я зарегестрировался на сервисе MyHeritage.com, создал своё гениалогическое древо, к сожалению всех родственников я не знал, поэтомуу я использова вымошленных людей при выполнении задания. По размерам оно для задания подходит, но на мой взляд оно не самое большое.


## Конвертация родословного дерева
Необходимо было сделать парсер по переносу данных, из гетовского вида в Пролог. Сейчас я понимаю, что скорее всего выбрал не лучший способ, когда решил написать его на Си. Код получился объёмный и занял немало времени, но с другой стороны задача была болле интресеной и менее тривиальной. Алгоритм поиска информации был довольно обычен, при нахождении индекса в тексе я находил фамилии и имена людей, данные хранил в векторе, а после уже совершал обработку данных  и формировал предикаты необходимого вида.
Парсер находится в файле lp1.c

## Предикат поиска родственника
По заданию мне необходимо реализовать предикат поииска шурина, задача была в меру сложной, а сам предикат оказался довольнот простым, основная проблема была в том чтобы придумать условия, которые бы могли обеспечить правильный ответ.
Реализация предиката:
```swipl
    shurin(Y, X) :- father(X, Chl), Chl \= "", mother(Moth, Chl), father(Ded, Moth), father(Ded, Y), father(Y, _).
    shurin(Y, X) :- father(X, Chl), Chl \= "", mother(Moth, Chl), mother(Ba, Moth), mother(Ba, Y), father(Y, _).

```
Результат работы:
```swipl
?- shurin("CHaadaev Aleksej", X).
X = "Svanidze Egor" .

?- shurin("CHaadaev Petr", X).
X = "Svanidze Egor" .

?- shurin("ZHarov Georgij", X).
X = "CHaadaev Aleksandr" .

?- shurin("Istomin Gennadij", X).
false.

?- shurin(X, "Svanidze Egor").
X = "CHaadaev Aleksej" ;
X = "CHaadaev Petr" .

```


## Определение степени родства
Импользуем поиск в глубину с иттерационным углублением для нахождения кратчайшего отношения родства. Это позволяет использовать наиболее оптимальный путь для решения поставленной задачи с минимальными затратами.
Листинг:
```swipl
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
move(wife, Y, X) :- father(X, Z), mother(Y, Z), Z \= "".

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
translator([H, R|T], [W|TQ]) :- translator([R|T], TQ), move(W, R, H).

relative(W, X, X) :- writeln("Степень:0") W = [equal], !.
relative(W, X, Y) :- id_search(X, Y, L), translator(L, W).

```
Результат работы:
```
?- relative(W, "Svanidze Egor", "Svanidze Gennadij").
Степень:1
W = [father].

?- relative(W, "Svanidze Egor", "Svanidze Gennadij").
Степень:1
W = [father].

?- relative(W, "Svanidze Egor", "ZHarova Anastasiya").
Степень:2
W = [husband, dauther].

?- relative(W, "Goncharov Nikolaj", "ZHarova Anastasiya").
Степень:2
W = [father, mother].

?- relative(W, "Goncharov Nikolaj", "CHaadaev Aleksandr").
Степень:2
W = [father, mother].

?- relative(W, "Goncharov Nikolaj", "Svanidze Gennadij").
Степень:4
W = [father, mother, mother, mother].

```
## Естественно-языковый интерфейс
В основном предикате dialog используем такие предикаты, как: type, который занимается обработкой списка запроса при помощи предикатов fronttoken, делящим строку на 2 подстроки, а также предикаты печати списка и подсчета его уникальных элементов.

Листинг:
```

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
```
Результат работы:
```
?- dialog.
Hello, Enter your questions in correct form:
|: How many brother's does Petr CHaadaev have?
CHaadaev Petr have 1 brothers.
Enter your questions in correct form:
|: Who are sister's for him?
sister for CHaadaev Petr is: 
CHaadaeva Viktoriya
Enter your questions in correct form:
|: Who is wife for Goncharov Nikolaj?
wife for Goncharov Nikolaj is 
nk Nataliya
Enter your questions in correct form:
|: How many dauther's does he have?
Goncharov Nikolaj have 2 dauthers.
Enter your questions in correct form:
|: exit
[exit]
true.

```

## Выводы
Часть знаний которые мне принесла эта работа я описал в введнии, но также хочется ометить, что работа очень разностароння, она заключена сразу в несеольких сферах, каждая из которых требует внимания и должного труда. Например, при написании эссе я лучше познакомился с теоритической частью, при пострении древа понял приближённость задачи к реальной жизни, при написании парсера мне надо было произвести некую контектенацию между различнвми языками: выполняя работу на одном языке я подсознательно должен был предсатвлять как это будет выглядеть на другом, при работе непостредственно с Прологом понял насколько разнозадачный это язык, он решает как логическую задачу так и способед строить диалог между пользователем и компьютером на уровне логики.
На мой взгляд это одна из самых нетривиальных работ за время моей учёб, но с тоже время интересных и максимально приблеженных к реальной жизни. Также мне было приятно уведеть взаимосвязь лабараторных работ и курсавой, каждая работа учит навыкам которые пригодятся в следующей, это удобно когда приходится думать последовательно. Также я стал лучше оценивать эффективность методов и сложность алгоритмов, не заню правда в силу скоротиечных дедлайнов или общей загруженности, но подходя к заданию, я старлся поэтампно разбить его выполнение на конкретные временные отрезки.
