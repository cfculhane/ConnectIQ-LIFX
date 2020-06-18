
using Toybox.Communications;
using Toybox.WatchUi;

class ConnectIQLIFXDelegate extends WatchUi.BehaviorDelegate {
    var notify;
    // Set up the callback to the view
    function initialize(handler) {
        WatchUi.BehaviorDelegate.initialize();
        notify = handler;
    }

    // Handle menu button press
    function onMenu() {
        makeRequest();
        return true;
    }

    function onSelect() {
        makeRequest();
        return true;
    }

    function makeRequest() {
        notify.invoke("Executing\nRequest");
        var lifx_api;
        lifx_api = new LIFX_API(self.notify);
//        lifx_api.power_toggle();
        lifx_api.get_lights(null);
    }


}