using Toybox.Communications;
using Toybox.WatchUi;
using Toybox.System;

class RemootioDelegate extends WatchUi.BehaviorDelegate
{
  var foundIP = 0;
  var button;

  var gotIPResponse = true;

  function initialize()
  {
    WatchUi.BehaviorDelegate.initialize();
    door = new RemootioDoor(0, "Connecting"); //Create garage door that is closed
  }
  
  //Callback function after web request
  function updateIpResponse(responseCode, data)
  {
    System.println("Code: " + responseCode + " Data: " + data);
    gotIPResponse = true;
    door.setGotResponse(true);
    door.setState("IP reset");
    WatchUi.requestUpdate();
  }
  
  //Function for checking key press
  function onKey(keyEvent)
  {
    if(keyEvent.getKey() == 4) //If key is start/stop key
    {
      door.switchState();
      //TODO check state and update UI
    }
    return true;
  }
  
  //Check the current IP address and save it in foundIP variable
  function setIP(responseCode, data)
  {
    if (responseCode == 200)
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
      };
      var responseCallback = method(:updateIpResponse);
      Communications.makeWebRequest(url, params, options, responseCallback);
    }
  }
  
  //Check IP address currently connected to
  function checkIP()
  {
    if(gotIPResponse)
    {
      gotIPResponse = false;
      var url = "https://api.ipify.org?format=json";
      var params = {};
      var options = { // set the options
      :method => Communications.HTTP_REQUEST_METHOD_GET,
      :headers => 
      {
        "Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON},
      };
      var responseCallback = method(:setIP);
      Communications.makeWebRequest(url, params, options, method(:setIP));
    }
  }

  function checkState()
  {
    var url = "https://remootio-server.glitch.me/state";
    var params = {};
    var options = { // set the options
    :method => Communications.HTTP_REQUEST_METHOD_GET,
    :headers => 
    {
      "Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON},
    };
    var responseCallback = door.method(:setDoorState);
    Communications.makeWebRequest(url, params, options, responseCallback);
  }
}