module(total).

main(_) ->
	Display = fun(X) -> io:fwrite("~w~n",[X]) end,
	lists:foreach(Display,	lists:seq(1,10)).