using Toybox.Communications;
using Toybox.WatchUi;
using Toybox.System;
import Toybox.Lang;

class RemootioDelegate extends WatchUi.BehaviorDelegate
{
  var foundIP = 0;
  var button;

  function initialize()
  {
    Communications.registerForPhoneAppMessages(method(:onPhoneAppMessage));
    WatchUi.BehaviorDelegate.initialize();
    door = new RemootioDoor(0, "Connecting"); //Create garage door that is closed
    //door.checkState();
  }

  function onPhoneAppMessage(msg as Toybox.Communications.PhoneAppMessage) as Void
  {
    var data = msg.data;
    if (data == null) {
      return;
    }

    // Validate the data is a Dictionary
    if (data instanceof Toybox.Lang.Dictionary) {
      if (data.hasKey("ip")) {
        foundIP = data.get("ip");
        Application.Storage.setValue("homeIP", foundIP); //Save IP address into homeIP storage
        door.setState("IP is: " + foundIP);
        WatchUi.requestUpdate();
      }
      if (data.hasKey("setting2")) {
        var setting2 = data["setting2"];
        System.println("Received setting2: " + setting2.toString());
      }
    }
  }

  //Function for checking key press
  function onKey(keyEvent)
  {
    if(keyEvent.getKey() == 4) //If key is start/stop key
    {
      door.activateDoor();
    }
    return true;
  }
  
  //Check the current IP address and save it in foundIP variable
  function setIP(responseCode as Number, data as Dictionary or Null) as Void
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
    Communications.makeWebRequest(url, params, options, responseCallback);
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
