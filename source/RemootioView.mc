using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Communications;

class RemootioView extends WatchUi.View 
{
  var stateText;
  
  var currentState = "Closed";


  function updateState(data)
  {
    currentState = data["state"];
    //stateText = View.findDrawableById("state");   
      //stateText.setText(currentState);
    WatchUi.requestUpdate();
  }
  
  function onReceive(responseCode, data) {
    if (responseCode == 200) 
    {
      System.println("Layout State Request Successful");
      System.println("Response: " + responseCode + " Data: " + data);  
    }
    else 
    {
      System.println("Response: " + responseCode + " Data: " + data);
    }
    updateState(data);
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


  var button;
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
    checkState();
    }

    // Update the view
    function onUpdate(dc) 
    {
        stateText = View.findDrawableById("state");   
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
    
    function onRecieve(args)
    {
      WatchUi.requestUpdate();
    }

}
