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
    System.println("checking state");
    Communications.transmit("Hello World.", null, listener);
    // var url = Env.CheckStateURL;
    // var params =
    // {
    //     "ip" => Application.Storage.getValue("homeIP"),
    //     "deviceName" => door.getDoor() ? "GATE" : "GARAGE",
    //     "devicePort" => door.getDoor() ? 8081 : 8080,
    //     "authKey" => door.getDoor() ? door.hashString(door.GATE_API_AUTH) : door.hashString(door.GARAGE_API_AUTH),
    // };

    // var options = {
    //     :method => Communications.HTTP_REQUEST_METHOD_POST,
    //     :headers => {
    //         "Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON,
    //     },
    // };
    // var responseCallback = door.method(:setDoorState);
    // Communications.makeWebRequest(url, params, options, responseCallback);

    // TODO: Get this from the mobile app
  }

  // Function to activate the current door
  // Will send a POST request to server with the authentication
  function activateDoor() 
  {
    // var url = Env.TriggerURL;
    // //Send the hash of authentication and IP address
    // var params =
    // {
    //     "ip" => Application.Storage.getValue("homeIP"),
    //     "deviceName" => _currentDoor ? "GATE" : "GARAGE",
    //     "devicePort" => _currentDoor ? 8081 : 8080,
    //     "authKey" => _currentDoor ? hashString(GATE_API_AUTH) : hashString(GARAGE_API_AUTH),
    // };

    // // set the options
    // var options = {
    //   :method => Communications.HTTP_REQUEST_METHOD_POST,
    //   :headers => {
    //     "Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON,
    //   },
    // };
    // var responseCallback = method(:setDoorState);
    // Communications.makeWebRequest(url, params, options, responseCallback);

    // TODO: Support the movile app
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
}
