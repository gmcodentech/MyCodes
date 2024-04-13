//http_get.v

import net.http

fn main(){
	data := http.get('http://admin:1234@localhost:5984') or {
		println('something went wrong')
		return
	}
	
	println(data.body)
}
