using Toybox.Communications;
using Toybox.WatchUi;
using Toybox.System;

class RemootioDelegate extends WatchUi.BehaviorDelegate
{
  var foundIP = 0;
  var button;

  function initialize()
  {
    WatchUi.BehaviorDelegate.initialize();
    door = new RemootioDoor(0, "Connecting"); //Create garage door that is closed
  }

  //Function for checking key press
  function onKey(keyEvent)
  {
    if(keyEvent.getKey() == 4) //If key is start/stop key
    {
      door.switchState();
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
      door.setState("IP is: " + foundIP);
      WatchUi.requestUpdate();
    }
  }
  
  //Check IP address currently connected to
  function checkIP()
  {
    door.setState("Getting IP");
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

  function checkState() {
    door.checkState();
  }

  function switchDoor()
  {
    var currentDoor = door.getDoor();
    door.setDoor(currentDoor ? 0 : 1);
    door.checkState();
  }
}
