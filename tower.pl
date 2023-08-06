ntower(N, T, counts(Top, Bottom, Left, Right)) :-
    % Ensure that T is a list of N lists, each containing N distinct integers from 1 to N
    length(T,N), % check that the length of the list of lists is indeed N
    maplist(length2(N),T), % check that each list within the list has length N
    maplist(fd_domain2(N),T), % makes sure each row of elements are each between 1 to N
    maplist(fd_all_different,T), % makes sure each row of elements contain distinct value
    transpose(T,TT), % transpose so columns become rows and repeat previous step
    maplist(fd_all_different,TT),
    
    maplist(fd_labeling,T), % finite domain solver
    
    maplist(isVisible,T,Left), % T is Left to Right
    maplist(reverse,T,TR), % TR is Right to Left
    maplist(isVisible,TR,Right),
    
    maplist(isVisible,TT,Top), % TT is Top to Bottom
    maplist(reverse,TT,TTR), % TTR is Bottom to Top
    maplist(isVisible,TTR,Bottom).

plain_ntower(N, T, counts(Top, Bottom, Left, Right)) :-
    % ensure the grid is NxN
    length(T, N),
    maplist(length2(N),T),

    % check if A is permutation of num 1 to B
    increasing(Nlist,N), % Nlist becomes a list of size N containing values from 1 ... N.
    maplist(permutation2(Nlist),T),

    % ensure each column contains distinct values from 1 to N
    transpose(T, TT),
    maplist(permutation2(Nlist),TT),

    maplist(isVisible,T,Left), % T is Left to Right
    maplist(reverse,T,TR), % TR is Right to Left
    maplist(isVisible,TR,Right),
    
    maplist(isVisible,TT,Top), % TT is Top to Bottom
    maplist(reverse,TT,TTR), % TTR is Bottom to Top
    maplist(isVisible,TTR,Bottom).

speedup(Ratio) :-
    statistics(cpu_time, [Start1|_]),
    ntower(4,T1,counts([4,3,2,1],[1,2,2,2],[4,3,2,1],[1,2,2,2])),
    statistics(cpu_time, [End1|_]),
    statistics(cpu_time, [Start2|_]), 
    plain_ntower(4,T2,counts([4,3,2,1],[1,2,2,2],[4,3,2,1],[1,2,2,2])),
    statistics(cpu_time, [End2|_]),
    Time1 is End1-Start1+1, % T1 is sometimes less than 1s.
    Time2 is End2-Start2,
    Ratio is Time2/Time1. 

ambiguous(N, C, T1, T2) :- ntower(N, T1, C), ntower(N, T2, C), T1 \= T2.

% helper function for length
length2(N,T) :- length(T,N).
% helper function for fd_domain
fd_domain2(N,T) :- fd_domain(T,1,N).
% transposes given matrix
transpose([[]|_], []).
transpose(Matrix, [Row|Rows]) :- transpose2(Matrix, Row, RestMatrix),transpose(RestMatrix, Rows).
transpose2([], [], []).
transpose2([[H|T]|Rows], [H|Hs], [T|Ts]) :- transpose2(Rows, Hs, Ts).
% checks to see if there are exactly Target number of visible towers in HeightList
isVisible(HeightList, Target) :- isVisible2(0,HeightList,Target,0).
isVisible2(_,[],Target,Count) :- (Target #= Count). % when list is [], we have looked through all the heights, and our count is final.
isVisible2(Tallest,[H | Rest],Target,Count) :-
    ((Tallest #< H -> NewTallest #= H); NewTallest #= Tallest), % update Tallest building if the current building is taller.
    ((NewTallest #> Tallest -> NewCount #= (Count + 1)); NewCount #= Count), % only increment Count by 1 if the Tallest building was updated.
    isVisible2(NewTallest,Rest,Target,NewCount).

permutation2(L,T):- permutation(T,L).

increasing(L, N):- increasing2(L, N, 1).
increasing2([], N, X):- X > N, !.
increasing2([X|L], N, X):- X =< N, X1 is X + 1, increasing2(L, N, X1).