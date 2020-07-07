using Toybox.Application;
using Toybox.WatchUi;

class ConnectIQLIFXApp extends Application.AppBase {
    hidden var mView;
    var lifx_api;
    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        lifx_api = new LIFX_API();
        mView = new ConnectIQLIFXView(lifx_api);
        return [mView, new ConnectIQLIFXDelegate(lifx_api, mView.method(:onReceive))];
    }

}
