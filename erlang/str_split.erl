-module(split).

main(_) ->
	S = "ABC 3 Something",
	L = string:tokens(S,[$\s]),  % NOTE: string.tokens(S,",") for comma separated values into a list
	io:format("~p",[L]).