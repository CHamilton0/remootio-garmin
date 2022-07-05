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
    System.println("Check state");
    var url = Env.CheckStateURL;
    var params =
    {
        "ip" => Application.Storage.getValue("homeIP"),
        "deviceName" => door.getDoor() ? "GATE" : "GARAGE",
        "devicePort" => door.getDoor() ? 8081 : 8080,
        "authKey" => door.getDoor() ? door.hashString(door.GATE_API_AUTH) : door.hashString(door.GARAGE_API_AUTH),
    };

    System.println(params);
    var options = {
        :method => Communications.HTTP_REQUEST_METHOD_POST,
        :headers => {
            "Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON,
        },
    };
    var responseCallback = door.method(:setDoorState);
    Communications.makeWebRequest(url, params, options, responseCallback);
  }

  function switchDoor()
  {
    var currentDoor = door.getDoor();
    door.setDoor(currentDoor ? 0 : 1);
    checkState();
  }
}
