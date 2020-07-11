// API interface to LIFX servers


using Toybox.Communications as comms;
using Toybox.WatchUi;
using Toybox.Background;
using Toybox.Application as app;


class LIFX_API extends WatchUi.BehaviorDelegate {
    var notify;
    var auth_ok;
    var applying_selection = false;
    public var scenes;
    public var lights;
    public var locations;
    public var groups;
    public var access_token;
    const BASE_URL = "https://api.lifx.com/v1";
    var HEADERS = {"User-Agent"=> "connectIQ-LIFX/0.1.0",
                 "Authorization"=> "Bearer " + LIFX_API_KEY
                 };


    function initialize() {
        self.auth_ok = null;
        WatchUi.BehaviorDelegate.initialize();
        self.get_scenes();
        self.get_lights("all");
    }

    function is_http_ok(responseCode) {
        if (responseCode == 200 or responseCode == 207) {
            return true;
        } else {
            return false;
        }
    }

    function http_generic_handler(responseCode, data) {
        if (is_http_ok(responseCode)){
            System.println("Request Successful, data below:");
            System.println(data);
        }
        self.applying_selection = false;
        WatchUi.requestUpdate();
    }

    function check_auth() {
        // Returns true if authenticated, false if auth is failed, null if it is still waiting for a response
        return self.auth_ok;
    }


    function parse_scenes(responseCode, data) {
        // Handles returned JSON

        System.println("Scenes request completed with responseCode: " + responseCode.toString());
        if (is_http_ok(responseCode)){
            self.auth_ok = true;
            var num_scenes = data.size();
            System.println("Number of scenes returned: " + num_scenes);

            self.scenes = data;
            for( var i = 0; i < num_scenes; i++ ) {
                self.scenes[i].put("scene_num", i);
            }
            System.println("Scene request Successful, written data below:");
            System.println(self.scenes);

        } else {
            self.auth_ok = false;
        }
        if (self.lights != null || self.auth_ok == false) {
            WatchUi.requestUpdate();
        } else {
            System.println("Waiting for parse_lights()...");
        }

    }

    function parse_lights(responseCode, data) {
        // Handles returned JSON

        System.println("Lights request completed with responseCode: " + responseCode.toString());
        if (is_http_ok(responseCode)){
            self.auth_ok = true;
            var num_lights = data.size();
            System.println("Number of lights returned: " + num_lights);
            self.lights = data;
            for( var i = 0; i < num_lights; i++ ) {
                self.lights[i].put("light_num", i);  // Used as a symbol later on, has to be a number
            }
            System.println("Lights request Successful, written data below:");
            System.println(self.lights);
        } else {
            self.auth_ok = false;
        }
        if (self.scenes != null || self.auth_ok == false) {
            WatchUi.requestUpdate();
        } else {
            System.println("Waiting for parse_scenes()...");
        }
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
        comms.makeWebRequest(url, params, options, method(:parse_lights));
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
    }

    function set_scene(scene_uuid) {
        self.applying_selection = true;
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

    function toggle_power(selector) {
        self.applying_selection = true;
        // Toggle power of a light / group / all etc
        // Selector is defined as per https://api.developer.lifx.com/v1/docs/selectors
        // e.g. 'all' for all lights, 'id:afs097fds87a4f' for a specific light ID
        if (selector == null) {
            selector = "all";
        }
        var url_format = BASE_URL + "/lights/$1$/toggle";
        var url = Lang.format(url_format, [selector]);
        System.println("Toggling power with URL : " + url);

        var params = null;
        var options = {                                             // set the options
               :method => comms.HTTP_REQUEST_METHOD_POST,      // set HTTP method
               :headers => HEADERS,
               :responseType => comms.HTTP_RESPONSE_CONTENT_TYPE_JSON
           };

           // Make the Communications.makeWebRequest() call
           comms.makeWebRequest(url, params, options, method(:http_generic_handler));

      }
}