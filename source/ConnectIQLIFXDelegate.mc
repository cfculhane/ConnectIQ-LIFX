
using Toybox.Communications;
using Toybox.WatchUi;


class ConnectIQLIFXDelegate extends WatchUi.BehaviorDelegate {
    var notify;
    // Set up the callback to the view
    function initialize() {
        WatchUi.BehaviorDelegate.initialize();
    }

    // Handle back button press to exit safely
    function onBack() {
        System.println("ConnectIQLIFXDelegate: back pressed");
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return false;
    }
}

class LifxMainInputDelegate extends WatchUi.MenuInputDelegate {
    // Handles the main menu selection
    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
        // Builds the sub menus for each option
        Application.getApp().setSelection(true);

        System.println("Recieved item: " + item);
        if (item == :toggle_all_lights) {
            $.LIFX_API_OBJ.toggle_power("all");

        } else if (item == :apply_scene) {
            var menu = new WatchUi.Menu();
            var delegate;
            menu.setTitle("Select Scene");
            var num_scenes = $.LIFX_API_OBJ.scenes.size();
            System.println("Number of scenes to display: "+ num_scenes);
            for( var i = 0; i < num_scenes; i++ ) {
                menu.addItem($.LIFX_API_OBJ.scenes[i]["name"], $.LIFX_API_OBJ.scenes[i]["scene_num"]);
            }

            delegate = new LifxSceneInputDelegate();
            WatchUi.pushView(menu, delegate, WatchUi.SLIDE_IMMEDIATE);
        } else if (item == :toggle_light) {
            var menu = new WatchUi.Menu();
            var delegate;
            menu.setTitle("Select Light to toggle");
            var num_lights = $.LIFX_API_OBJ.lights.size();
            System.println("Number of lights to display: "+ num_lights);
            for( var i = 0; i < num_lights; i++ ) {
                menu.addItem($.LIFX_API_OBJ.lights[i]["label"], $.LIFX_API_OBJ.lights[i]["light_num"]);
            }

            delegate = new LifxLightInputDelegate();
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
    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
        var loading_view = new SendingSignalView();
        var loading_delegate = new ConnectIQLIFXDelegate();
        WatchUi.pushView(loading_view, loading_delegate, WatchUi.SLIDE_DOWN);
        $.LIFX_API_OBJ.applying_selection = true;
        WatchUi.requestUpdate();
        System.println("Recieved item: " + item);
        var selected_scene = $.LIFX_API_OBJ.scenes[item];
        $.LIFX_API_OBJ.set_scene(selected_scene["uuid"]);
    }
}

class LifxLightInputDelegate extends WatchUi.MenuInputDelegate {
    // Handles selection of a light to apply

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
        var loading_view = new SendingSignalView();
        var loading_delegate = new ConnectIQLIFXDelegate();
        WatchUi.pushView(loading_view, loading_delegate, WatchUi.SLIDE_DOWN);
        $.LIFX_API_OBJ.applying_selection = true;
        WatchUi.requestUpdate();
        System.println("Recieved item: " + item);
        var selected_light = $.LIFX_API_OBJ.lights[item];
        $.LIFX_API_OBJ.toggle_power("id:" + selected_light["id"]);

    }
}