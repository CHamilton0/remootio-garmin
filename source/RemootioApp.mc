using Toybox.Application;
using Toybox.System;
using Toybox.Communications;

var door;

class RemootioApp extends Application.AppBase 
{
  hidden var view;
  hidden var delegate;

  function initialize() 
  {
      AppBase.initialize();
  }

  // Return the initial view of your application here
  function getInitialView() 
  {
    view = new RemootioView();
    delegate = new RemootioDelegate();
    return [view, delegate];
  }
}
