-module(mapf).

main(_) ->
	Disp = fun(X) -> io:format("~w ~n",[X]) end,
	L = [1,2,3,4,5,6,7],
	lists:map(Disp,L).