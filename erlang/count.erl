-module(acc).

check(L) -> check(L,0).

check([],Acc) -> Acc;
check([_|T],Acc) -> check(T,Acc+1).

main(_) ->
	C = check([1,2,3,4,5]),
	io:format("~w",[C]).