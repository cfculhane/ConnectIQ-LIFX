using Toybox.Application;
using Toybox.WatchUi;
public var LIFX_API_KEY = null;
public var LIFX_API_OBJ;
class ConnectIQLIFXApp extends Application.AppBase {
    var mSelection;

    hidden var mView;
    var lifx_api;
    var main_delegate;
    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
        LIFX_API_KEY = retrieve_api_key();
        System.println("Starting with api key: " + LIFX_API_KEY);
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        LIFX_API_OBJ = new LIFX_API();
        main_delegate = new ConnectIQLIFXDelegate(LIFX_API_OBJ);
        mView = new ConnectIQLIFXView(LIFX_API_OBJ);
        return [mView, main_delegate];
    }

    function getSelection() {
        return mSelection;
    }

    function setSelection(bool) {
        mSelection = bool;
    }

    function onSettingsChanged() { // triggered by settings change in GCM
        LIFX_API_KEY = retrieve_api_key();
        System.println("Re-reading settings, retrieved api key: " + LIFX_API_KEY);
        WatchUi.requestUpdate();   // update the view to reflect changes
        self.getInitialView();
    }

    function retrieve_api_key(){
        var api_key = null;
        if ( Toybox.Application has :Storage ) {
            api_key = Application.Properties.getValue("LIFX_API_KEY");
        } else {
            api_key = Application.getApp().getProperty("LIFX_API_KEY");
        }

        if (api_key != null && api_key != "") {
                return api_key;
        } else {
            System.println("MISSING API KEY!");
            return false;
        }
    }

}
