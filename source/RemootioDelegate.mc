using Toybox.Communications;
using Toybox.WatchUi;
using Toybox.System;

class RemootioDelegate extends WatchUi.BehaviorDelegate
{
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
		var url = "https://faint-saber-attack.glitch.me/test";
		var params = {};
		var options = { // set the options
		:method => Communications.HTTP_REQUEST_METHOD_GET,
		:headers => 
		{
			"Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED},
			:responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
		};
		var responseCallback = method(:onReceive);
		Communications.makeWebRequest(url, params, options, method(:onReceive));
	}

	function onButton()
	{
		makeRequest();
		System.println("Button pressed");
	}
}