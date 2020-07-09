
using Toybox.Communications;
using Toybox.WatchUi;


class ConnectIQLIFXDelegate extends WatchUi.BehaviorDelegate {
    var notify;
    // Set up the callback to the view
    function initialize(api_obj) {
        WatchUi.BehaviorDelegate.initialize();
    }

    // Handle back button press to exit safely
    function onBack() {
        System.println("back pressed");
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return false;
    }

    function onSelect() {
        return false;
    }

}

class LifxMainInputDelegate extends WatchUi.MenuInputDelegate {
    // Handles the main menu selection
    private var lifx_api;
    function initialize(api_obj) {
        MenuInputDelegate.initialize();
        lifx_api = api_obj;
    }

    function onMenuItem(item) {
        // Builds the sub menus for each option
        Application.getApp().setSelection(true);

        System.println("Recieved item: " + item);
        if (item == :toggle_all_lights) {
            lifx_api.toggle_power("all");

        } else if (item == :apply_scene) {
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
        } else if (item == :toggle_light) {
            var menu = new WatchUi.Menu();
            var delegate;
            menu.setTitle("Select Light to toggle");
            var num_lights = lifx_api.lights.size();
            System.println("Number of lights to display: "+ num_lights);
            for( var i = 0; i < num_lights; i++ ) {
                menu.addItem(lifx_api.lights[i]["label"], lifx_api.lights[i]["light_num"]);
            }

            delegate = new LifxLightInputDelegate(self.lifx_api);
            WatchUi.pushView(menu, delegate, WatchUi.SLIDE_IMMEDIATE);

        } else if (item == :exit) {
            System.exit();
        } else {
            System.println("Item not recognised: " + item);
        }
    }
}


class LifxSceneInputDelegate extends WatchUi.MenuInputDelegate {
    // Handles selection of a scene to apply
    var lifx_api;
    function initialize(api_obj) {
        MenuInputDelegate.initialize();
        lifx_api = api_obj;
    }

    function onMenuItem(item) {
//        var loading_view = new ConnectIQLIFXView($.LIFX_API_OBJ);
//        WatchUi.pushView(ConnectIQLIFXView, ConnectIQLIFXDelegate, WatchUi.SLIDE_IMMEDIATE);
        lifx_api.applying_selection = true;
        WatchUi.requestUpdate();
        System.println("Recieved item: " + item);
        var selected_scene = lifx_api.scenes[item];
        lifx_api.set_scene(selected_scene["uuid"]);
    }
}

class LifxLightInputDelegate extends WatchUi.MenuInputDelegate {
    // Handles selection of a light to apply

    private var lifx_api;
    function initialize(api_obj) {
        MenuInputDelegate.initialize();
        lifx_api = api_obj;
    }

    function onMenuItem(item) {
        lifx_api.applying_selection = true;
        WatchUi.requestUpdate();
        System.println("Recieved item: " + item);
        var selected_light = lifx_api.lights[item];
        lifx_api.toggle_power("id:" + selected_light["id"]);

    }
}