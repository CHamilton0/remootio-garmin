using Toybox.Communications;
using Toybox.WatchUi;
using Env;
using Toybox.Cryptography;

class RemootioDoor
{
  private var _currentDoor;
  private var _currentState;
  private var _gotResponse;
  const API_AUTH = Env.RemootioAPIAuth;

  function initialize(door, state)
  {
    // Door 0 is garage, 1 is gate
    // State 0 is closed, 1 is open
    _currentDoor = door;
    _currentState = state;
    _gotResponse = true;
  }

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
      System.println("code: " + responseCode + " data: " + data);
      _gotResponse = true;
      if(data["state"])
      {
        formatCurrentState(data["state"]);
        WatchUi.requestUpdate();
      }
    }
  }

  function setDoorState(responseCode, data)
  {
    if(data)
    {
      formatCurrentState(data["state"]);
      WatchUi.requestUpdate();
    }
  }

  //Type is either switch (0) or activate (1)
  //if type == switch, url should be /switch-from-selectedDoor
  //if type == activate, url should be /activate-selectedDoor
  function switchWebRequest(type) 
  {
    var selectedDoor = _currentDoor ? "gate" : "garage";
    var url = type ?
      "https://remootio-server.glitch.me/activate-" + selectedDoor :
      "https://remootio-server.glitch.me/switch-from-" + selectedDoor;
    //Send the hash of authentication and IP address
    var params = {
      "Auth" => hashString(API_AUTH),
      "IP" => Application.Storage.getValue("homeIP")
    };
    // set the options
    var options = {
    :method => Communications.HTTP_REQUEST_METHOD_POST,
    :headers => 
    {
      "Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON},
    };
    var responseCallback = method(:webRequestResponse);
    Communications.makeWebRequest(url, params, options, responseCallback);
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

  function switchDoor()
  {
    if (_gotResponse)
    {
      _gotResponse = false;
      switchWebRequest(0);
      _currentDoor = _currentDoor ? 0 : 1;
    }
  }

  function switchState()
  {
    _gotResponse = false;
    switchWebRequest(1);
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
}