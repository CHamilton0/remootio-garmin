# Garmin watch Remootio Control

> Control your Remootio garage door from your Garmin wearable

This app has been developed for the Garmin Vivoactive 4 device and requires the use of a touchscreen to work. However,
it may also work on other Garmin devices with a touchscreen, but it has not been tested.

It requires connection to the internet through connection to a mobile phone via Bluetooth. The app uses the Garmin
ConnectIQ `Toybox.Communications.makeWebRequest` function in order to access the internet. See
[makeWebRequest](https://developer.garmin.com/connect-iq/api-docs/Toybox/Communications.html#makeWebRequest-instance_function)
for more details and the full API reference.

## Development information

### Environment Variables

This ConnectIQ app requires a [Env.mc](./source/Env.mc) file that contains certain environment variables that the app
will use. An example `Env.mc` file content is below:

```java
module Env {
    var GarageAPIAuth = "GARAGE_API_AUTH_CODE_HERE";
    var GateAPIAuth = "GATE_API_AUTH_CODE_HERE";
    var TriggerURL = "https://functionapp.com/api/trigger";
    var CheckStateURL = "https://functionapp.com/api/state";
}
```
