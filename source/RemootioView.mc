using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Communications;

class RemootioView extends WatchUi.View 
{
  var stateText; //Variable to hold the object in the UI
  var currentState = "Unknown"; //Updated using call to the server

  //Function to update the state text based on the current state
  function updateStateText(data)
  {
    //Convert state text to first letter uppercase
    currentState = data["state"].toCharArray();
    currentState[0] = currentState[0].toUpper();
    var state = "";
    for(var i = 0; i < currentState.size(); i++)
    {
      state += currentState[i];
    }
    currentState = state;
    System.println(currentState);
  }
  
  //Callback function for checking state of door
  function onReceive(responseCode, data)
  {
    if (responseCode == 200) 
    {
      updateStateText(data);
    }
    else 
    {
      currentState = "Unknown";
    }
  }

  function initialize() 
  {
    WatchUi.View.initialize();
    stateText = null;
  }

  // Load your resources here
  function onLayout(dc) 
  {
    setLayout(Rez.Layouts.MainLayout(dc));
  }

  // Called when this View is brought to the foreground. Restore
  // the state of this View and prepare it to be shown. This includes
  // loading resources into memory.
  function onShow() 
  {
    var url = "https://remootio-server.glitch.me/connect";
    var params = {};
    var options = { // set the options
    :method => Communications.HTTP_REQUEST_METHOD_GET,
    :headers => 
    {
      "Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON},
    };
    var responseCallback = method(:doNothing);
    Communications.makeWebRequest(url, params, options, responseCallback);
    stateText = View.findDrawableById("state");   
  }

  // Update the view
  function onUpdate(dc) 
  {
    stateText.setText(door.getCurrentState());
    // Call the parent onUpdate function to redraw the layout
    View.onUpdate(dc);
  }

  function doNothing()
  {

  }

  // Called when this View is removed from the screen. Save the
  // state of this View here. This includes freeing resources from
  // memory.
  function onHide() 
  {
    var url = "https://remootio-server.glitch.me/dc";
    var params = {};
    var options = { // set the options
    :method => Communications.HTTP_REQUEST_METHOD_GET,
    :headers => 
    {
      "Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON},
    };
    var responseCallback = method(:doNothing);
    Communications.makeWebRequest(url, params, options, responseCallback);
  }
}
