-module(gettotal).

total([N|T]) -> N + total(T);
total([]) -> 0.


main(_) ->
 R = total([1,2,3]),
 io:format("~w",[R]).