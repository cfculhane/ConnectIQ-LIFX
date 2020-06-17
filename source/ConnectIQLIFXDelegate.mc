using Toybox.WatchUi;

class ConnectIQLIFXDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new ConnectIQLIFXMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

}