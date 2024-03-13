-module(foldex).

main(_) ->
	L = [1,4,5,2],
	F = fun(A,B)-> A + B end,
	R = lists:foldl(F,0,L),
	io:format("Total: ~w",[R]).