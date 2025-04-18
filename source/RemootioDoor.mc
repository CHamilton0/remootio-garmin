using Toybox.Communications;
using Toybox.WatchUi;
using Toybox.Cryptography;
import Toybox.Lang;

class RemootioDoor extends Communications.ConnectionListener
{
  private var _currentDoor as Numeric;
  private var _currentState as String;

  function initialize(door, state)
  {
    // Door 0 is garage, 1 is gate
    // State 0 is closed, 1 is open
    _currentDoor = door;
    _currentState = state;

    Communications.ConnectionListener.initialize();
  }

  // Function to convert the state data to be displayed
  function formatCurrentState(stateData as Lang.String)
  {
    //Convert state text to first letter uppercase
    var stateArray = stateData.toCharArray() as Lang.Array<Lang.Char>;
    stateArray[0] = stateArray[0].toUpper();
    var state = "";
    for(var i = 0; i < stateArray.size(); i++)
    {
      state += stateArray[i];
    }
    _currentState = state;
  }

  // Function to update the state text
  function setDoorState(responseCode as Number, data as Dictionary or Null) as Void
  {
    if(responseCode == 200 && data != null)
    {
      formatCurrentState(data.toString());
      WatchUi.requestUpdate();
    } else
    {
      _currentState = "Failed";
      WatchUi.requestUpdate();
    }
  }

  //Creates a hash based on a string and returns it
  function hashString(string)
  {
    var hash = null;
    var newArray = []b as ByteArray;
    var chars = string.toCharArray() as Array<Char>;
    for(var i = 0; i < chars.size(); i++)
    {
      newArray = newArray.add(chars[i]);
    }
    
    hash = new Cryptography.Hash({ :algorithm => Cryptography.HASH_SHA256 }); // Create a new SHA-256 hash
    hash.update(newArray); // Add the byte array to the hash
    
    return hash.digest().toString();
  }

  // Check the state of the door
  function checkState()
  {
    var listener = new Communications.ConnectionListener();
    door.setState("Checking state");

    var doorType = door.getDoor() ? "GATE" : "GARAGE";
    System.println("checking state of " + doorType);
    var message = {
      "type" => "check",
      "door" => doorType
    };
    Communications.transmit(message, null, listener);
  }

  // Function to activate the current door
  function activateDoor() 
  {
    var listener = new Communications.ConnectionListener();
    door.setState("Triggering");
    WatchUi.requestUpdate();

    var doorType = door.getDoor() ? "GATE" : "GARAGE";
    System.println("triggering " + doorType);
    var message = {
      "type" => "trigger",
      "door" => doorType
    };
    Communications.transmit(message, null, listener);
  }

  function getDoor()
  {
    return _currentDoor;
  }

  function getCurrentState()
  {
    return _currentState;
  }

  function setState(state)
  {
    _currentState = state;
  }

  function setDoor(door)
  {
    _currentDoor = door;
    WatchUi.requestUpdate();
  }

  function disconnect()
  {
    var listener = new Communications.ConnectionListener();

    System.println("Disconnecting");
    var message = {
      "type" => "disconnect"
    };
    Communications.transmit(message, null, listener);
  }
}
