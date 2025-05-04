<?php
	//Prerequisites:
	//Apache CouchDB is installed
	//CouchDB service is running
	//Curl extension is enabled in php.ini
	
	//$response = http_get("localhost:5984/_all_dbs");
	//echo $response;
	
	$query = array("selector"=> array("price"=> array("\$gt"=>10.0)));
	$result = http_post("localhost:5984/productsdb/_find", json_encode($query));
	$json_result = json_decode($result);
	$docs = $json_result->docs;
	foreach($docs as $doc){
		echo $doc->name.' '.$doc->price.' '.$doc->units.PHP_EOL;
	}

//	$product = array("name"=>"php", "price"=>"12.5", "units"=>15, "category"=>"programming");
//	$uuid_result = http_get("localhost:5984/_uuids");
//	$ids = json_decode($uuid_result)->uuids;
//	$product_id=$ids[0];
//	$result = http_put("localhost:5984/productsdb/$product_id",json_encode($product));
//	echo $result;
	
	function http_put($url,$data){
		$ch = curl_init();
		curl_setopt($ch, CURLOPT_URL, $url);
		set_common_options($ch);
		
		curl_setopt($ch, CURLOPT_POST, false);
		curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "PUT");
		curl_setopt($ch, CURLOPT_HTTPHEADER, array("Content-Type:application/json"));
		curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
		
		$response = curl_exec($ch);
		
		if(curl_errno($ch)){
			die(curl_error($ch));
		}
		
		curl_close($ch);
		
		return $response;

	}
	
	function http_post($url,$post_data){
		$ch = curl_init();
		curl_setopt($ch, CURLOPT_URL, $url);
		set_common_options($ch);
		
		curl_setopt($ch, CURLOPT_POST, true);
		curl_setopt($ch, CURLOPT_HTTPHEADER, array("Content-Type:application/json"));
		curl_setopt($ch, CURLOPT_POSTFIELDS, $post_data);
		
		$response = curl_exec($ch);
		
		if(curl_errno($ch)){
			die(curl_error($ch));
		}
		
		curl_close($ch);
		
		return $response;

	}
	
	function http_get($url){
		$ch = curl_init();
		curl_setopt($ch, CURLOPT_URL, $url);
		set_common_options($ch);
		
		$response = curl_exec($ch);
		
		if(curl_errno($ch)){
			die(curl_error($ch));
		}
		
		curl_close($ch);
		
		return $response;
	}
	
	function set_common_options($ch){
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, true); //get response from the server
		curl_setopt($ch, CURLOPT_HTTPAUTH, CURLAUTH_BASIC);
		curl_setopt($ch, CURLOPT_USERPWD, "admin:1234");//username:password
	}