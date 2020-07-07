using Toybox.WatchUi;

class ConnectIQLIFXView extends WatchUi.View {
    // Initial view when app is first loaded
    hidden var mMessage = "Press menu button";
    hidden var mModel;
    hidden var lifx_api;
    function initialize(api_obj) {
        WatchUi.View.initialize();
        lifx_api = api_obj;
    }

    // Load your resources here
    function onLayout(dc) {
        mMessage = "Loading data from LIFX...";
    }

    // Restore the state of the app and prepare the view to be shown
    function onShow() {
        // Start initial view
        var init_menu = new WatchUi.Menu();
        var init_menu_delegate;
        init_menu.setTitle("Select operation");
        init_menu.addItem("Toggle all lights", :toggle_all_lights);
        init_menu.addItem("Apply a Scene", :apply_scene);
        init_menu.addItem("Toggle a light", :toggle_light);
        init_menu_delegate = new LifxMainInputDelegate(self.lifx_api);
        WatchUi.pushView(init_menu, init_menu_delegate, WatchUi.SLIDE_IMMEDIATE);
    }

    // Update the view
    function onUpdate(dc) {
//        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
//        dc.clear();
//        dc.drawText(dc.getWidth()/2, dc.getHeight()/2, Graphics.FONT_MEDIUM, mMessage, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    // Called when this View is removed from the screen. Save the
    // state of your app here.
    function onHide() {
    }

    function onReceive(args) {
        if (args instanceof Lang.String) {
            mMessage = args;
        }
        else if (args instanceof Dictionary) {
            // Print the arguments duplicated and returned by jsonplaceholder.typicode.com
            var keys = args.keys();
            mMessage = "";
            for( var i = 0; i < keys.size(); i++ ) {
                mMessage += Lang.format("$1$: $2$\n", [keys[i], args[keys[i]]]);
            }
        }
        WatchUi.requestUpdate();
    }
}