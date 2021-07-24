using Toybox.Communications;

class RemootioDoor
{
  private var _currentDoor;
  private var _currentState;
  private var _gotResponse;
  const API_AUTH = "";

  function initialize(door, state)
  {
    // Door 0 is garage, 1 is gate
    // State 0 is closed, 1 is open
    _currentDoor = door;
    _currentState = state;
    _gotResponse = true;
  }

  //Callback function when data is recieved from web request
  function onReceive(responseCode, data)
  {
    if(responseCode == 200)
    {
      RemootioView.checkState(); //Updates the text based on the state of the door
    }
    else
    {
    }
    _gotResponse = true;
  }

  //Type is either switch (0) or activate (1)
  //if type == switch, url should be /switch-from-selectedDoor
  //if type == activate, url should be /activate-selectedDoor
  function switchWebRequest(type) 
  {
    var selectedDoor = _currentDoor ? "gate" : "garage";
    var url = type ? "https://remootio-server.glitch.me/activate-" + selectedDoor : "https://remootio-server.glitch.me/switch-from-" + selectedDoor;
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
      :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
    };
    var responseCallback = method(:onReceive);
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
    if (_gotResponse)
    {
      _gotResponse = false;
      switchWebRequest(1);
      _currentState = _currentState ? 0 : 1;
    }
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