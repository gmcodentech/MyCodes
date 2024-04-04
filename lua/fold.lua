function fold(fun,value,list)
	local aggregated = nil
	local previous = value
	for _,v in pairs(list) do
		previous = fun(previous,v)
	end
	return previous
end

local fn = function(a,b)
	return a .."-".. b
end

l = {"abc","123","pqr"}
r = fold(fn,"start",l)
print(r)

local sum=function(x,y)
	return x + y
end

n = {1,2,3,4,5,6,7,8,9,10}
total = fold(sum,0,n)
print(total)