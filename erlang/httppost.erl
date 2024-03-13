-module(httppost).
-import(base64,[encode/1]).

main(_) ->
	inets:start(),
	
	Url = "http://localhost:5984/productsdb/f7bdb198abe378b39d0170e72d003c3c",
	
	Base64String = encode("admin:1234"),
	BE = "Basic " ++ Base64String,
	AuthHeader = {"Authorization",BE},
	
	{ok,{Version,Header,Result}} = httpc:request(put,{Url,[AuthHeader],
	"application/json",
    "{\"name\":\"Bread\",\"price\":334.2,\"units\":190}"
    }, [], []),
	
	_ = Header,
	_ = Version,
	
	io:format("~s",[Result]).