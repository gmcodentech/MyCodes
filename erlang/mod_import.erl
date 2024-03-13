-module("modimport").

-import(mod,[start/0,add/2]).

main(_) ->
	mod:start(),
	R = add(2,4),
	io:format("~w",[R]).