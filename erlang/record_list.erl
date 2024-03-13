-module(emp).
 
-record(employee,{name,age,salary}).
 
main(_) ->
	E1 = #employee{name="Ajay",age=23,salary=23.4},
	E2	= #employee{name="Vijay",age=43,salary=55.8},
	E3	= #employee{name="Jay",age=33,salary=545.8},
	Employees = [E1,E2,E3],
	Display = fun(E) -> io:format("~s ~n",[E#employee.name]) end,
	lists:foreach(Display,Employees).
	 