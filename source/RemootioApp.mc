using Toybox.Application;
using Toybox.System;
using Toybox.Communications;

class RemootioApp extends Application.AppBase 
{
  hidden var view;
  hidden var delegate;

  function initialize() 
  {
      AppBase.initialize();
  }

  // onStart() is called on application start up
  function onStart(state) 
  {
  }

  // onStop() is called when your application is exiting
  function onStop(state) 
  {
  }

  // Return the initial view of your application here
  function getInitialView() 
  {
    view = new RemootioView();
    delegate = new RemootioDelegate();
    return [view, delegate];
  }
}