using Toybox.Communications;
using Toybox.WatchUi;
using Env;
using Toybox.Cryptography;

class RemootioDoor
{
  private var _currentDoor;
  private var _currentState;
  private var _gotResponse;
  const GARAGE_API_AUTH = Env.GarageAPIAuth;
  const GATE_API_AUTH = Env.GateAPIAuth;

  function initialize(door, state)
  {
    // Door 0 is garage, 1 is gate
    // State 0 is closed, 1 is open
    _currentDoor = door;
    _currentState = state;
    _gotResponse = true;
  }

  // Function to convert the state data to a nice look
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

  //Callback function when data is recieved from web request
  function webRequestResponse(responseCode, data)
  {
    if(data)
    {
      _gotResponse = true;
      if(data["state"])
      {
        formatCurrentState(data["state"]);
        WatchUi.requestUpdate();
      }
    }
  }

  // Function to update the state text
  function setDoorState(responseCode, data)
  {
    System.println(responseCode);
    System.println(data);
    if(data)
    {
      formatCurrentState(data);
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
    var responseCallback = method(:webRequestResponse);
    Communications.makeWebRequest(url, params, options, responseCallback);
  }

  // Called from remootio delegate when button is pressed
  function switchState()
  {
    _gotResponse = false;
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

  function getGotResponse()
  {
    return _gotResponse;
  }

  function setGotResponse(value)
  {
    _gotResponse = value;
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