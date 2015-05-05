course(algebra).
course(geometry).
course(cryptography).

group(g1).
group(g2).
group(g3).

nb_students(g1, 15).
nb_students(g2, 10).
nb_students(g3, 12).

attends(g1, [algebra,geometry]).
attends(g2, [geometry,cryptography]).
attends(g3, [algebra,cryptography]).

prof(alice).
prof(bob).
prof(carol).

teach(alice, [algebra]).
teach(bob, [algebra,geometry]).
teach(carol, [cryptography]).

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
