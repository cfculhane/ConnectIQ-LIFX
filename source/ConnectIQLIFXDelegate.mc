
using Toybox.Communications;
using Toybox.WatchUi;

class ConnectIQLIFXDelegate extends WatchUi.BehaviorDelegate {
    var notify;
    var lifx_api;
    var scenes;
    // Set up the callback to the view
    function initialize(handler) {
        WatchUi.BehaviorDelegate.initialize();
        notify = handler;
        lifx_api = new LIFX_API(self.notify);

    }

    // Handle menu button press
    function onMenu() {
        // Use WatchUi.switchToView() ??
        // https://developer.garmin.com/downloads/connect-iq/monkey-c/doc/Toybox/WatchUi.html#switchToView-instance_method
        var menu = new WatchUi.Menu();
        var delegate;
        menu.setTitle("Select Scene");
        var num_scenes = lifx_api.scenes.size();
        System.println("Attempting to display " + num_scenes);
        for( var i = 0; i < num_scenes; i++ ) {
            menu.addItem(lifx_api.scenes[i]["name"], :one);
        }

        delegate = new WatchUi.MenuInputDelegate(); // a WatchUi.Menu2InputDelegate
        WatchUi.pushView(menu, delegate, WatchUi.SLIDE_IMMEDIATE);
        return true;
    }

    function onSelect() {
        makeRequest();
        return true;
    }

    function makeRequest() {
        notify.invoke("Executing\nRequest");


        lifx_api.power_toggle();
//        lifx_api.get_lights(null);
    }


}