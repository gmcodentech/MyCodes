-module(recordexample).

-record(person,{name,age=12,salary}).

main(_) ->
	P = #person{name="John",salary=334.5},
	io:fwrite("~w ~w ~s",[P#person.salary,P#person.age,P#person.name]).