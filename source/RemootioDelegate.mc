using Toybox.Communications;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Cryptography;

class RemootioDelegate extends WatchUi.BehaviorDelegate
{
	var API_AUTH = "";
	var API_SECRET = "";

	function onReceive(responseCode, data) {
		if (responseCode == 200) 
		{
			System.println("Request Successful");
			System.println("Response: " + responseCode + " Data: " + data);  
		}
		else 
		{
			System.println("Response: " + responseCode + " Data: " + data);
		}
	}

	function makeRequest() 
	{
		var url = "https://remootio-server.glitch.me/test";
		var params = {};
		var options = { // set the options
		:method => Communications.HTTP_REQUEST_METHOD_PUT,
		:headers => 
		{
			"Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED},
			:responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
		};
		var responseCallback = method(:onReceive);
		Communications.makeWebRequest(url, params, options, method(:onReceive));
	}
	
	
	function hashString(string)
	{
		var hash = null;
		var newArray = []b;
		var chars = string.toCharArray();
		for(var i = 0; i < chars.size(); i++)
		{
			newArray.add(chars[i]);
		}
		
		hash = new Cryptography.Hash({ :algorithm => Cryptography.HASH_SHA256 }); // Create a new SHA-256 hash
		// Add the byte array to the hash
	    hash.update(newArray);
	    
	    return hash.digest();
	}

	function onButton()
	{
		makeRequest();
		System.println("Button pressed");
	}
}