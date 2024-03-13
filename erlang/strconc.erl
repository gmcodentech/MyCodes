-module(strconc).

main(_) ->
	S1 = "Hello",
	S2 = " World!",
	C = S1 ++ S2,
	io:format("~s",[C]).