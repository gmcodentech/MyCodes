-module(filterlst).
 
main(_) ->
	L = [1,2,3,4,5,6,7,8],
	F = fun(N) -> N rem 2 == 0 end,
	R = lists:filter(F,L),
	Disp = fun(N) -> io:format("~w ~n",[N]) end,
	lists:map(Disp,R).