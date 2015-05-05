not_in(_,[]).
not_in(X,[T|Q]):-not(X = T), not_in(X,Q).

delete_item(_,[],[]).
delete_item(I,[I|T],T).
delete_item(I,[H|T],[H|L]):-not(I=H),delete_item(I,T,L).

cartesian_product_aux(H1,[H2],[[H1,H2]]).
cartesian_product_aux(H1,[H2|T2],[[H1,H2]|T3]):-
	cartesian_product_aux(H1,T2,T3).

cartesian_product([H1],Set2,Set3):-cartesian_product_aux(H1,Set2,Set3).
cartesian_product([H1|T1],Set2,Set3):-
	cartesian_product_aux(H1,Set2,L1),
	cartesian_product(T1,Set2,L2),
	append(L1,L2,Set3).
