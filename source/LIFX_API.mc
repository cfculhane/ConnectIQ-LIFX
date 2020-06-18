// API interface to LIFX servers


using Toybox.Communications as comms;
using Toybox.WatchUi;

const API_TOKEN = "c7b6a7b2936032035025758fd1348d73e34a0e46b8601bee433466933c9b88a2";
const HEADERS = {"User-Agent"=> "connectIQ-LIFX/0.0.0",
                 "Authorization"=> "Bearer " + API_TOKEN
                 };

const TEST_SCENE_UUID = "67374067-1a0b-48b6-9120-900312077693";

class LIFX_API extends WatchUi.BehaviorDelegate {
    var notify;

    function initialize(handler) {
        WatchUi.BehaviorDelegate.initialize();
        notify = handler;
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

    // Receive the data from the web request
    function onReceive(responseCode, data) {
        System.println("Request completed with responseCode: " + responseCode.toString());
        if (responseCode == 200 or responseCode == 207) {
            System.println("Request Successful, data below:");
            System.println(data);
            notify.invoke(data);
            return data;
        } else {
            notify.invoke("Failed to load\nError: " + responseCode.toString());
            System.println(data);
            return null;
        }
    }


    function power_toggle(){
        // Just toggles the power state of ALL lights
        var url = "https://api.lifx.com/v1/lights/all/toggle";
        System.println(HEADERS);
        var params = null;
        var options = {
                :method => comms.HTTP_REQUEST_METHOD_POST,
                :headers => HEADERS,
                :responseType => comms.HTTP_RESPONSE_CONTENT_TYPE_JSON
                };
        var responseCallback = method(:onReceive);

        // Make the Communications.makeWebRequest() call
        comms.makeWebRequest(url, params, options, method(:onReceive));
        return responseCallback;
    }

    function get_lights(selector){
        // Gets all lights on network, returns dict
        // Selector is defined as per https://api.developer.lifx.com/v1/docs/selectors
        // e.g. 'all' for all lights, 'id:afs097fds87a4f' for a specific light ID

        if (selector == null) {
            selector = "all";
        }

        System.println("Using selector: " + selector);
        var url = "https://api.lifx.com/v1/lights/all";
        var params = null;
        var options = {
                :method => comms.HTTP_REQUEST_METHOD_GET,
                :headers => HEADERS,
                :responseType => comms.HTTP_RESPONSE_CONTENT_TYPE_JSON
                };
        var responseCallback = method(:onReceive);

        // Make the Communications.makeWebRequest() call
        comms.makeWebRequest(url, params, options, method(:onReceive));
        return responseCallback;
    }

    function set_scene(scene_uuid) {
        var url_format = "https://api.lifx.com/v1/scenes/scene_id:$1$/activate";                         // set the url
        var url = Lang.format(url_format, [scene_uuid]);
        System.println(url);

        var params = null;
        var options = {                                             // set the options
               :method => Communications.HTTP_REQUEST_METHOD_PUT,      // set HTTP method
               :headers => HEADERS,
               :responseType => comms.HTTP_RESPONSE_CONTENT_TYPE_JSON
           };

           var responseCallback = method(:onReceive);                  // set responseCallback to
                                                                       // onReceive() method
           // Make the Communications.makeWebRequest() call
           comms.makeWebRequest(url, params, options, method(:onReceive));
           return responseCallback;
      }
}