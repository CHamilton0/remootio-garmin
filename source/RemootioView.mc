using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Communications;

class RemootioView extends WatchUi.View 
{
  var stateText; //Variable to hold the object in the UI
  var currentState = "Unknown"; //Updated using call to the server
  
  function initialize() 
  {
    WatchUi.View.initialize();
    stateText = null;
  }

  // Load your resources here
  function onLayout(dc) 
  {
    setLayout(Rez.Layouts.MainLayout(dc));
    stateText = View.findDrawableById("state");
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
    var responseCallback = method(:waitForConnected);
    Communications.makeWebRequest(url, params, options, responseCallback);
  }

  // Update the view
  function onUpdate(dc) 
  {
    stateText.setText(door.getCurrentState());
    // Call the parent onUpdate function to redraw the layout
    View.onUpdate(dc);
  }

  function doNothing(responseCode, data)
  {

  }

  function waitForConnected(responseCode, data)
  {
    if(responseCode == 200)
    {
      door.setState("Connected");
    }
    else
    {
      door.setState("Failed to connect");
    }
      WatchUi.requestUpdate();
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
