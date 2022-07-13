using Toybox.Communications;
using Toybox.WatchUi;
using Env;
using Toybox.Cryptography;

class RemootioDoor
{
  private var _currentDoor;
  private var _currentState;
  const GARAGE_API_AUTH = Env.GarageAPIAuth;
  const GATE_API_AUTH = Env.GateAPIAuth;

  function initialize(door, state)
  {
    // Door 0 is garage, 1 is gate
    // State 0 is closed, 1 is open
    _currentDoor = door;
    _currentState = state;
  }

  // Function to convert the state data to be displayed
  function formatCurrentState(stateData)
  {
    //Convert state text to first letter uppercase
    _currentState = stateData.toCharArray();
    _currentState[0] = _currentState[0].toUpper();
    var state = "";
    for(var i = 0; i < _currentState.size(); i++)
    {
      state += _currentState[i];
    }
    _currentState = state;
  }

  // Function to update the state text
  function setDoorState(responseCode, data)
  {
    if(responseCode == 200)
    {
      formatCurrentState(data);
      WatchUi.requestUpdate();
    } else
    {
      System.println(responseCode);
      _currentState = "Failed";
      WatchUi.requestUpdate();
    }
  }

  //Creates a hash based on a string and returns it
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
    hash.update(newArray); // Add the byte array to the hash
    
    return hash.digest().toString();
  }

  // Check the state of the door
  function checkState()
  {
    door.setState("Checking state");
    var url = Env.CheckStateURL;
    var params =
    {
        "ip" => Application.Storage.getValue("homeIP"),
        "deviceName" => door.getDoor() ? "GATE" : "GARAGE",
        "devicePort" => door.getDoor() ? 8081 : 8080,
        "authKey" => door.getDoor() ? door.hashString(door.GATE_API_AUTH) : door.hashString(door.GARAGE_API_AUTH),
    };

    var options = {
        :method => Communications.HTTP_REQUEST_METHOD_POST,
        :headers => {
            "Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON,
        },
    };
    var responseCallback = door.method(:setDoorState);
    Communications.makeWebRequest(url, params, options, responseCallback);
  }

  // Function to activate the current door
  // Will send a POST request to server with the authentication
  function activateDoor() 
  {
    var url = Env.TriggerURL;
    //Send the hash of authentication and IP address
    var params =
    {
        "ip" => Application.Storage.getValue("homeIP"),
        "deviceName" => _currentDoor ? "GATE" : "GARAGE",
        "devicePort" => _currentDoor ? 8081 : 8080,
        "authKey" => _currentDoor ? hashString(GATE_API_AUTH) : hashString(GARAGE_API_AUTH),
    };

    // set the options
    var options = {
      :method => Communications.HTTP_REQUEST_METHOD_POST,
      :headers => {
        "Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON,
      },
    };
    var responseCallback = method(:setDoorState);
    Communications.makeWebRequest(url, params, options, responseCallback);
  }

  // Called from remootio delegate when button is pressed
  function switchState()
  {
    activateDoor();
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
