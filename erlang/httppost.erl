-module(httppost).

main(_) ->
	inets:start(),
	
	Url = "http://localhost:5984/productsdb/f7bdb198abe378b39d0170e72d003c3c",
	
	AuthHeader = {"Authorization","Basic YWRtaW46MTIzNA=="},	
	{ok,{Version,Header,Result}} = httpc:request(put,{Url,[AuthHeader],
	"application/json",
    "{\"name\":\"Bread\",\"price\":334.2,\"units\":190}"
    }, [], []),
	_ = Header,
	_ = Version,
	io:format("~s",[Result]).