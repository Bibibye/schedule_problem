group(g1).
group(g2).
group(g3).

prof(alice).
prof(bob).
prof(carol).

course(algebra).
course(geometry).
course(cryptography).

teach(alice, [algebra]).
teach(bob, [algebra,geometry]).
teach(carol, [cryptography]).

nb_students(g1, 15).
nb_students(g2, 10).
nb_students(g3, 12).

attends(g1, [algebra,geometry]).
attends(g2, [geometry,cryptography]).
attends(g3, [algebra,cryptography]).

room(room_a).
room(room_b).
room(room_c).

nb_seats(room_a, 20).
nb_seats(room_b, 20).
nb_seats(room_c, 30).

time_slot(monday_8_9).
time_slot(monday_9_10).
time_slot(monday_10_11).
time_slot(monday_11_12).
time_slot(monday_14_15).

not_in(_,[]).
not_in(X,[T|Q]):-not(X = T), not_in(X,Q).

group_list([G]):-group(G).
group_list([T|Q]):-group(T), not_in(T,Q), group_list(Q).

assignement([Time_slot,Room,Prof,Course,Group]):-
	time_slot(Time_slot),
	room(Room),
	prof(Prof),
	course(Course),
	group_list(Group).

get_time_slot([Time_slot,_,_,_,_], Time_slot).
get_room([_,Room,_,_,_], Room).
get_prof([_,_,Prof,_,_], Prof).
get_course([_,_,_,Course,_], Course).
get_groups([_,_,_,_,Group], Group).

all_groups_attend([],_).
all_groups_attend([Group|T],Course):-
	attends(Group,L),
	member(Course,L),
	all_groups_attend(T,Course).

all_groups_available(_,[],_).
all_groups_available(Time_slot,[Group|T],TG):-
	member([Time_slot,Group],TG),
	all_groups_available(Time_slot,T,TG).

delete_item(_,[],[]).
delete_item(I,[I|T],T).
delete_item(I,[H|T],[H|L]):-not(I=H),delete_item(I,T,L).

delete_groups(_,[],TG,TG).
delete_groups(Time_slot,[H|T],TG,New_TG):-
	delete_item([Time_slot,H],TG,TG_tmp),
	delete_groups(Time_slot,T,TG_tmp,New_TG).

cartesian_product_aux(H1,[H2],[[H1,H2]]).
cartesian_product_aux(H1,[H2|T2],[[H1,H2]|T3]):-
	cartesian_product_aux(H1,T2,T3).

cartesian_product([H1],Set2,Set3):-cartesian_product_aux(H1,Set2,Set3).
cartesian_product([H1|T1],Set2,Set3):-
	cartesian_product_aux(H1,Set2,L1),
	cartesian_product(T1,Set2,L2),
	append(L1,L2,Set3).

all_tr(TR):-
	setof(Time_slot,time_slot(Time_slot),Set1),
	setof(Room,room(Room),Set2),
	cartesian_product(Set1,Set2,TR).

all_tp(TP):-
	setof(Time_slot,time_slot(Time_slot),Set1),
	setof(Prof,prof(Prof),Set2),
	cartesian_product(Set1,Set2,TP).

all_tg(TG):-
	setof(Time_slot,time_slot(Time_slot),Set1),
	setof(Group,group(Group),Set2),
	cartesian_product(Set1,Set2,TG).

all_c(Course_list):- setof(X,course(X),Course_list).

valid_solution(_,_,_,_,[]).
valid_solution([Assign|T], TR, TP, TG, Course_list):-
	assignement(Assign),
	get_time_slot(Assign,Time_slot),
	get_room(Assign,Room),
	get_prof(Assign,Prof),
	get_course(Assign,Course),
	get_groups(Assign,Group_list),
	teach(Prof,Taught_courses),
	member(Course, Taught_courses),
	all_groups_attend(Group_list,Course),
	member([Time_slot,Room],TR),
	member([Time_slot,Prof],TP),
	all_groups_available(Time_slot,Group_list,TG),
	delete_item([Time_slot,Room],TR,New_TR),
	delete_item([Time_slot,Prof],TP,New_TP),
	delete_groups(Time_slot,Group_list,TG,New_TG),
	delete_item(Course,Course_list,New_Course_list),
	valid_solution(T, New_TR, New_TP,New_TG,New_Course_list).

main(S):-
	all_tr(TR),
	all_tp(TP),
	all_tg(TG),
	all_c(Course_list),
	valid_solution(S, TR, TP, TG, Course_list).