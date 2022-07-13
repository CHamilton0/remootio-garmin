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

  // Update the view
  function onUpdate(dc) 
  {
    stateText.setText(door.getCurrentState());
    doorText.setText(door.getDoor() ? "Gate" : "Garage");
    // Call the parent onUpdate function to redraw the layout
    View.onUpdate(dc);
  }
}
