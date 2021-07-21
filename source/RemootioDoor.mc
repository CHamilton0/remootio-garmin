using Toybox.Communications;

class RemootioDoor
{
  private var _currentDoor;
  private var _currentState;
  const API_AUTH = "";

  function initialize(door, state)
  {
    // Door 0 is garage, 1 is gate
    // State 0 is closed, 1 is open
    _currentDoor = door;
    _currentState = state;
  }

  function onReceive(responseCode, data)
  {
    if(responseCode == 200)
    {
      System.println("Request Successful");
    }
    else
    {
      System.println("Response: " + responseCode);
    }
  }

  function switchWebRequest(type) //Type is either switch (0) or activate (1)
  //if type == switch, url should be /switch-from-selectedDoor
  //if type == activate, url should be /activate-selectedDoor
  {
    var selectedDoor = _currentDoor ? "gate" : "garage";
    var url = type ? "https://remootio-server.glitch.me/activate-" + selectedDoor : "https://remootio-server.glitch.me/switch-from-" + selectedDoor;
    System.println(url);
    //Send the hash of authentication and IP address
    var params = {
      "Auth" => RemootioDelegate.hashString(API_AUTH),
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

  function switchDoor()
  {
    switchWebRequest(0);
    _currentDoor = _currentDoor ? 0 : 1;
    System.println(_currentDoor);
  }

  function switchState()
  {
    switchWebRequest(1);
    _currentState = _currentState ? 0 : 1;
    System.println(_currentState);
  }

  function getDoor()
  {
    return _currentDoor;
  }

  function getCurrentState()
  {
    return _currentState;
  }
}