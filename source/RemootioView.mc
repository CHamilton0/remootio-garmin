using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Communications;

class RemootioView extends WatchUi.View 
{
  var stateText; // Variable to hold the state text object in the UI
  var doorText; // Variable to hold the door text object in the UI
  var currentState = "Unknown"; // Updated using call to the server
  
  function initialize() 
  {
    WatchUi.View.initialize();
    stateText = null;
    doorText = null;
  }

  // Load your resources here
  function onLayout(dc) 
  {
    setLayout(Rez.Layouts.MainLayout(dc));
    stateText = View.findDrawableById("state");
    doorText = View.findDrawableById("door");
  }

  // Called when this View is brought to the foreground. Restore
  // the state of this View and prepare it to be shown. This includes
  // loading resources into memory.
  function onShow() 
  {
    var url = Env.CheckStateURL;
    var params =
    {
        "ip" => Application.Storage.getValue("homeIP"),
        "deviceName" => "GARAGE",
        "devicePort" => 8080,
        "authKey" => door.hashString(door.GARAGE_API_AUTH),
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

  // Update the view
  function onUpdate(dc) 
  {
    stateText.setText(door.getCurrentState());
    doorText.setText(door.getDoor() ? "Gate" : "Garage");
    // Call the parent onUpdate function to redraw the layout
    View.onUpdate(dc);
  }

  function doNothing(responseCode, data)
  {
  }

  // Called when this View is removed from the screen. Save the
  // state of this View here. This includes freeing resources from
  // memory.
  function onHide() 
  {
  }
}
