-module(sum)

getsum(N) -> lists:sum(lists:seq(1,N)).

main(_) ->
 S = getsum(10000),
 io:format("~w",[S]).