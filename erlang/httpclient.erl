module(httpget).

main(_) ->
	inets:start(),
	Url = "http://localhost:5984/_all_dbs",
	AuthHeader = {"Authorization","Basic YWRtaW46MTIzNA=="},
	{ok,{{Version,200,ReasonPhrase},Headers,Body}} =
		httpc:request(get,{Url,[AuthHeader]},
		[],
		[]),
	_ = Version, %handle warning
	_ = ReasonPhrase, %handle warning
	_ = Headers, %handle warning
	io:format("~s",[Body]).