using Toybox.Application;
using Toybox.WatchUi;

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
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        lifx_api = new LIFX_API();
        main_delegate = new ConnectIQLIFXDelegate(lifx_api);
        mView = new ConnectIQLIFXView(lifx_api);
        return [mView, main_delegate];
    }
    function getSelection() {
        return mSelection;
    }

    function setSelection(bool) {
        mSelection = bool;
    }

}
