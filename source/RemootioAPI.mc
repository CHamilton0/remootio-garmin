using Toybox.WatchUi as Ui;
using Toybox.Lang;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Communications as Comm;
using Toybox.System;
using Env;

class RemootioAPI
{
  var RemootioIP = Env.RemootioIP;
  var RemootioAPIAuth = Env.RemootioAPIAuth;
  var RemootioAPISecret = Env.RemootioAPISecret;

  var isConnected;
  var isAuthenticated;
  var apiSessionKey;
  var websocketClient;
  var lastActionId;
  var sendPingMessageEveryXMs = 60000;

  var autoReconnect;
  var frame;
  var unencryptedPayload;
  var decryptedPayload;
  
  var sendPingMessageIntervalHandle;
  var pingReplyTimeoutXMs;
  
  var pingReplyTimeoutHandle;
  var waitingForAuthenticationQueryActionResponse;

  function initialize()
  {
    //Set config
    websocketClient = null;
    apiSessionKey = null;
    lastActionId = null;
    autoReconnect = false;
    
    sendPingMessageIntervalHandle = null;
    pingReplyTimeoutXMs = sendPingMessageEveryXMs/2;
    
    pingReplyTimeoutHandle = null;
    waitingForAuthenticationQueryActionResponse = false;
    
    
  }

  function connect(reconnect)
  {
    if(reconnect == true)
    {
      autoReconnect = true;
    }
    
    apiSessionKey = null;
    lastActionId = null;
    waitingForAuthenticationQueryActionResponse = null;
    
    //send request to http server to connect to websocket
    //use websocket to connect to device IP
    //do websocket stuff on server side
    
  }
  
  function disconnect()
  {
  
  }
  
  function authenticate()
  {
  
  }
  
  function sendPing()
  {
  }
  
  function sendHello()
  {
  }
  
  function sendQuery()
  {
  }
  
  function sendTrigger()
  {
  }
  
  function sendOpen()
  {
  }
  
  function sendClose()
  {
  }
  
  function sendRestart()
  {
  }
  
  function sendFrame(frame)
  {
  }
  
  function sendUnencryptedPayload()
  {
  }
  
}