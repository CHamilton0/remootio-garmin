using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Communications;

class RemootioView extends WatchUi.View 
{
  var stateText; //Variable to hold the text in the UI
  var currentState = "Closed"; //Updated using call to the server

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
    WatchUi.requestUpdate(); //Request update for the UI
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
      WatchUi.requestUpdate();
    }
  }
  
  function checkState()
  {
    var url = "https://remootio-server.glitch.me/state";
    var params = {};
    var options = { // set the options
    :method => Communications.HTTP_REQUEST_METHOD_GET,
    :headers => 
    {
      "Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON},
      :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
    };
    var responseCallback = method(:onReceive);
    Communications.makeWebRequest(url, params, options, method(:onReceive));
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
    //checkState();
    stateText = View.findDrawableById("state");   
  }

  // Update the view
  function onUpdate(dc) 
  {
    stateText.setText(currentState);
    // Call the parent onUpdate function to redraw the layout
    View.onUpdate(dc);
  }

  // Called when this View is removed from the screen. Save the
  // state of this View here. This includes freeing resources from
  // memory.
  function onHide() 
  {

  }
}
