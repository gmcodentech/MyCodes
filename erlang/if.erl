-module(ifexample).

main(_) ->
	X = 10,
	if 
		X < 10 -> io:format("less");
		X > 10 -> io:format("greater");
		true -> io:format("equal")
	end.