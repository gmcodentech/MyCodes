-module(mod).

-export([start/0,add/2]).

start() ->
	io:format("started...").
	
private() ->
	io:format("this will not be accessible from other modules").

add(X,Y) -> X + Y.