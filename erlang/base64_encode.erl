-module(bs64).
-import(base64,[encode/1]).

main(_) ->
	B = encode("admin:1234"),
	io:format("~s",[B]).