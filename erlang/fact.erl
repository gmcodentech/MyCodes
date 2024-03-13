-module(fac).

fact(0) -> 1;
fact(N) -> N * fact(N-1).


main(_) ->
	io:format("~w",[fact(10)]).