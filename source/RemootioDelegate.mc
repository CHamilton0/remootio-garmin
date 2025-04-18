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
    door.checkState();
  }

  function onPhoneAppMessage(msg as Toybox.Communications.PhoneAppMessage) as Void
  {
    var data = msg.data;
    System.println(data);
    if (data == null) {
      return;
    }

    // Validate the data is a Dictionary
    if (data instanceof Toybox.Lang.Dictionary) {
      if (data.hasKey("state")) {
        door.setState(data.get("state"));
        WatchUi.requestUpdate();
      }
      if (data.hasKey("error")) {
        door.setState("Error");
        WatchUi.requestUpdate();
        System.println("Error: " + data.get("error"));
      }
    }
  }

  //Function for checking key press
  function onKey(keyEvent)
  {
    System.println(keyEvent.getKey());
    if(keyEvent.getKey() == 4) //If key is start/stop key
    {
      door.activateDoor();
    } else if(keyEvent.getKey() == 5) //If key is back key
    {
      door.disconnect();
      WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }

    return true;
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
