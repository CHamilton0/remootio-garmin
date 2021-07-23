using Toybox.Communications;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Cryptography;

class RemootioDelegate extends WatchUi.BehaviorDelegate
{
  const API_AUTH = "";
  var foundIP = 0;
  var button;
  var door;

  function initialize()
  {
    WatchUi.BehaviorDelegate.initialize();
    door = new RemootioDoor(0, 0); //Create garage door that is closed
  }
  
  //Callback function after web request
  function onReceive(responseCode, data)
  {
    if (responseCode == 200) 
    {
    }
    else 
    {
    }
  }
  
  //Function for checking key press
  function onKey(keyEvent)
  {
    if(keyEvent.getKey() == 4) //If key is start/stop key
    {
      door.switchState();
      //TODO check state here and update UI
    }
    return true;
  }
  
  //Check the current IP address and save it in foundIP variable
  function setIP(responseCode, data)
  {
    foundIP = data.get("ip");
    Application.Storage.setValue("homeIP", foundIP); //Save IP address into homeIP storage

    var url = "https://remootio-server.glitch.me/set-ip";
    var params = 
    {
      "IP" => Application.Storage.getValue("homeIP")
    };
    var options = { // set the options
    :method => Communications.HTTP_REQUEST_METHOD_POST,
    :headers => 
    {
      "Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON},
      :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
    };
    var responseCallback = method(:onReceive);
    Communications.makeWebRequest(url, params, options, responseCallback);
  }
  
  //Check IP address currently connected to
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

  //Switch door function required for the button to work
  function switchDoor()
  {
    door.switchDoor();
  }
}