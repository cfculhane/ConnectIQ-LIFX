// API interface to LIFX servers


using Toybox.Communications as comms;
using Toybox.WatchUi;
using Toybox.Background;
using Toybox.Application as app;



enum
{
    ACCESS_TOKEN
}

const API_TOKEN = "c7b6a7b2936032035025758fd1348d73e34a0e46b8601bee433466933c9b88a2";
const HEADERS = {"User-Agent"=> "connectIQ-LIFX/0.0.0",
                 "Authorization"=> "Bearer " + API_TOKEN
                 };


const TEST_SCENE_UUID = "67374067-1a0b-48b6-9120-900312077693";
const BASE_URL = "https://api.lifx.com/v1";

class LifxGroup {
    // Reperesents a Lifx Group, e.g. "Bedroom"
    var name = "";
    var id = "";
}

class LifxLocation {
    // Reperesents a Lifx Location, e.g. "Home"
    var name = "";
    var id = "";
}


class LifxLight {
    var name = "";
    var uuid = "";
    var id = "";
    var group;
    var location;
}

class LIFX_API extends WatchUi.BehaviorDelegate {
    var notify;
    public var scenes;
    public var lights;
    public var locations;
    public var groups;
    public var access_token;
    var mySetting = Application.getApp().getProperty("mySetting");



//    function isAuthenticated() {
//        var app_obj = Application.getApp();
//        var token = app_obj.getProperty(ACCESS_TOKEN);
//        return (token != null);
//    }

    function initialize(handler) {
        WatchUi.BehaviorDelegate.initialize();
        notify = handler;
//        if (self.isAuthenticated()){
//            self.access_token = Application.getApp().getProperty(ACCESS_TOKEN);
            self.get_scenes();
            self.get_lights("all");
            System.println("self.scenes: " + self.scenes);
            System.println("self.lights: " + self.lights);
//        } else {
            System.println("Not authenticated, redirecting to LIFX page");
            notify.invoke("Not authenticated, redirecting to LIFX page");
//            comms.openWebPage("https://cloud.lifx.com/settings", {}, {});

//        }


    }

    function makeRequest() {
        notify.invoke("Executing\nRequest");

//        Communications.makeWebRequest(
//            "https://jsonplaceholder.typicode.com/todos/115",
//            {
//            },
//            {
//                "Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED
//            },
//            method(:onReceive)
//        );
        self.power_toggle();
    }

    function is_http_ok(responseCode) {
        if (responseCode == 200 or responseCode == 207) {
            return true;
        } else {
            notify.invoke("Failed to load\nError: " + responseCode.toString());
            return false;
        }
    }

    function http_generic_handler(responseCode, data) {
        if (is_http_ok(responseCode)){
            System.println("Request Successful, data below:");
            System.println(data);
        }
    }
    function parse_scenes(responseCode, data) {
        // Handles returned JSON

        System.println("Scenes request completed with responseCode: " + responseCode.toString());
        if (is_http_ok(responseCode)){
            var num_scenes = data.size();
            System.println("Number of scenes returned: " + num_scenes);

            self.scenes = data;
            for( var i = 0; i < num_scenes; i++ ) {
                self.scenes[i].put("scene_num", i);
            }
            System.println("Scene request Successful, written data below:");
            System.println(self.scenes);
        }

    }

    function parse_lights(responseCode, data) {
        // Handles returned JSON

        System.println("Lights request completed with responseCode: " + responseCode.toString());
        if (is_http_ok(responseCode)){

            var num_lights = data.size();
            System.println("Number of lights returned: " + num_lights);
            self.lights = data;
            System.println("Lights request Successful, written data below:");
            System.println(self.lights);
            notify.invoke(self.lights);
        }
    }


    function power_toggle(){
        // Just toggles the power state of ALL lights
        var url = BASE_URL + "/lights/all/toggle";
        var params = null;
        var options = {
                :method => comms.HTTP_REQUEST_METHOD_POST,
                :headers => HEADERS,
                :responseType => comms.HTTP_RESPONSE_CONTENT_TYPE_JSON
                };

        // Make the Communications.makeWebRequest() call
        comms.makeWebRequest(url, params, options, method(:http_generic_handler));
        notify.invoke("Lights toggled");
    }

    function get_lights(selector){
        // Gets all lights on network, returns dict
        // Selector is defined as per https://api.developer.lifx.com/v1/docs/selectors
        // e.g. 'all' for all lights, 'id:afs097fds87a4f' for a specific light ID

        if (selector == null) {
            selector = "all";
        }

        System.println("Getting all lights with selector: " + selector);
        var url = "https://api.lifx.com/v1/lights/all";
        var params = null;
        var options = {
                :method => comms.HTTP_REQUEST_METHOD_GET,
                :headers => HEADERS,
                :responseType => comms.HTTP_RESPONSE_CONTENT_TYPE_JSON
                };
        var responseCallback = method(:parse_lights);

        // Make the Communications.makeWebRequest() call
        comms.makeWebRequest(url, params, options, responseCallback);
        notify.invoke("Getting lights...");
    }

        function get_scenes(){
        // Gets all scenes on accont, returns dict
        // e.g. 'all' for all lights, 'id:afs097fds87a4f' for a specific light ID

        var url = "https://api.lifx.com/v1/scenes";
        var params = null;
        var options = {
                :method => comms.HTTP_REQUEST_METHOD_GET,
                :headers => HEADERS,
                :responseType => comms.HTTP_RESPONSE_CONTENT_TYPE_JSON
                };
        var scenes;

        // Make the Communications.makeWebRequest() call
        comms.makeWebRequest(url, params, options, method(:parse_scenes));
        notify.invoke("Getting scenes...");
    }

    function set_scene(scene_uuid) {
        var url_format = BASE_URL + "/scenes/scene_id:$1$/activate";                         // set the url
        var url = Lang.format(url_format, [scene_uuid]);
        System.println("Setting scene with URL : " + url);

        var params = null;
        var options = {                                             // set the options
               :method => comms.HTTP_REQUEST_METHOD_PUT,      // set HTTP method
               :headers => HEADERS,
               :responseType => comms.HTTP_RESPONSE_CONTENT_TYPE_JSON
           };

           // Make the Communications.makeWebRequest() call
           comms.makeWebRequest(url, params, options, method(:http_generic_handler));

      }
}