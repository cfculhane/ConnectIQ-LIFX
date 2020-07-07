
using Toybox.Communications;
using Toybox.WatchUi;


class ConnectIQLIFXDelegate extends WatchUi.BehaviorDelegate {
    var notify;
    var lifx_api;
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
        System.println("Number of scenes to display: "+ num_scenes);
        for( var i = 0; i < num_scenes; i++ ) {
            menu.addItem(lifx_api.scenes[i]["name"], lifx_api.scenes[i]["scene_num"]);
        }

        delegate = new LifxSceneInputDelegate(self.lifx_api);
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




class LifxSceneInputDelegate extends WatchUi.MenuInputDelegate {
    private var lifx_api;
    function initialize(api_obj) {
        MenuInputDelegate.initialize();
        lifx_api = api_obj;
    }

    function onMenuItem(item) {
        System.println("Recieved item: " + item);
        var selected_scene = lifx_api.scenes[item];
        lifx_api.set_scene(selected_scene["uuid"]);
    }
}