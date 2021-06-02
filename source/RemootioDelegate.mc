using Toybox.Communications;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Cryptography;

class RemootioDelegate extends WatchUi.BehaviorDelegate
{
	var API_AUTH = "DCE3B091456AEA890F7C9999FAD8AC6B3EEED7EAEEA50DB467C5549849A62CF8";
	var foundIP = 0;
	var currentState = "Closed";
	var currentDoor = "garage";
	var button;

	function switchDoor()
	{
		if(currentDoor == "garage")
		{
			currentDoor = "gate";
		}
		else
		{
			currentDoor = "garage";
		}
	}
	
	function onReceive(responseCode, data) {
		if (responseCode == 200) 
		{
			System.println("Next Request Successful");
			System.println("Response: " + responseCode + " Data: " + data);  
		}
		else 
		{
			System.println("Response: " + responseCode + " Data: " + data);
		}
		if(data["state"] != null)
		{
			RemootioView.updateState(data);
		}
		else
		{
			System.println("null data");
		}
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
	    
	    return hash.digest().toString();
	}

	function makeRequest() 
	{
		var url = "https://remootio-server.glitch.me/test";
		var params = {"Auth" => hashString(API_AUTH), "IP" => Application.Storage.getValue("homeIP")}; //Send the hash of authentication and IP address
		var options = { // set the options
		:method => Communications.HTTP_REQUEST_METHOD_POST,
		:headers => 
		{
			"Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON},
			:responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
		};
		var responseCallback = method(:onReceive);
		Communications.makeWebRequest(url, params, options, method(:onReceive));
	}
	
	//Function for checking key press
	function onKey(keyEvent)
	{
		if(keyEvent.getKey() == 4) //If key is start/stop key
		{
			System.println("Start/stop button pressed");
			//makeRequest();
			RemootioView.checkState();
		}
        return true;
	}
	
	//Check the current IP address and save it in foundIP variable
	function setIP(responseCode, data)
	{
		foundIP = data.get("ip");
		System.println(foundIP); //Print to console
		Application.Storage.setValue("homeIP", foundIP); //Save IP address into homeIP storage
	}
	
	//Check IP address
	function checkIP()
	{
		var url = "https://api.ipify.org?format=json";
		var params = {};
		var options = { // set the options
		:method => Communications.HTTP_REQUEST_METHOD_GET,
		:headers => 
		{
			"Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON},
			:responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
		};
		var responseCallback = method(:setIP);
		Communications.makeWebRequest(url, params, options, method(:setIP));
	}
}