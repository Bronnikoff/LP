% Task 2: Relational Data
% data from two.pl
% 2nd varios

:- ['two.pl'].
% ------------------------------------------------------------------------------
% 1) get average score for all subjects

% predicat for find sum os list elems
sum_list([], 0).
sum_list([H|T], N) :- sum_list(T, M), N is H + M.

% predicat for find average score of subject
av_score(Sub, N) :-
  findall(Grade, grade(_,_,Sub,Grade), Grades),
  sum_list(Grades, M),
  length(Grades, C),
  N is M/C.

% ------------------------------------------------------------------------------
% 2) get number of person from all groups have mark '2'

person_from_group(Gr, N) :-
  setof(F, C^grade(Gr,F,C,2), List),
  length(List, N).

% ------------------------------------------------------------------------------
% 3) get number of person for all subjects have mark '2'

person_from_subj(Sub, N) :-
  findall(1, grade(_,_,Sub,2), List),
  length(List, N).
