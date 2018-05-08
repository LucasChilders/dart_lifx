import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:json_object/json_object.dart';


class LIFX {
    Map _apiKeyHeader;
    bool loggingEnabled;

    /**
     * Requires [apiKey] to be passed.
     * 
     * [loggerEnabled] is a optional, defaulted to false. When true,
     * all [response.statusCode] and [response.body] will be printed.
     */

    LIFX(String apiKey, {bool this.loggingEnabled = false}) {
        this._apiKeyHeader = { "Authorization": "Bearer $apiKey" };
    }

    /**
     * Instead of print(), logger() is used in order to toggle
     * debug output.
     */

    void logger(String log) {
        if (this.loggingEnabled) {
            print(log);
        }
    }

    /**
     * Asynchronously returns a Map containing every light by [label] and [id] 
     * as well as the [count] of total lights.
     */ 

    Future<Map> getLights({String light = "all"}) async {
        final url = "https://api.lifx.com/v1/lights/$light";

        Completer<Map> com = new Completer<Map>();

        http.get(url, headers: _apiKeyHeader).then((response) {
            logger("Response status: ${response.statusCode}");
            logger("Response body: ${response.body}");

            if (response.statusCode == 200) {
                Map lights = new Map();
                int lightCount = 0;
                var parsedResponse = new JsonObject.fromJsonString(response.body);

                try {
                    for (int i = 0; ; i++) {
                        lights.putIfAbsent(parsedResponse[i].label, () => parsedResponse[i].id);
                        lightCount++;
                    }
                } 
                 
                catch (e) {
                    lights.putIfAbsent("count", () => lightCount);
                }

                com.complete(lights);
            }
            
            else {
                com.complete(new Map().putIfAbsent("error", () => "${response.statusCode}"));
            }
        });

        return com.future;
    }


    /**
     * Asynchronously returns a boolean based on the [response.statusCode] 
     * of the API request.
     */ 

    Future<bool> togglePower({String light = "all"}) async {
        final url = "https://api.lifx.com/v1/lights/$light/toggle";

        Completer<bool> com = new Completer<bool>();

        http.post(url, headers: _apiKeyHeader).then((response) {
            logger("Response status: ${response.statusCode}");
            logger("Response body: ${response.body}");
            
            if (response.statusCode == 207) {
                com.complete(true);
            } else {
                com.complete(false);
            }
        });

        return com.future;
    }

    /**
     * Asynchronously returns a boolean based on the [response.statusCode]
     * of the API request. All parameters have a default value and are optional.
     * 
     * 
     * From: https://api.developer.lifx.com/docs/set-state
     * 
     * power: String
     * The power state you want to set on the selector. on or off
     * 
     * color: String
     * The color to set the light to.
     * 
     * brightness: double
     * The brightness level from 0.0 to 1.0. Overrides any brightness set in color (if any).
     * 
     * duration: double
     * How long in seconds you want the power action to take. Range: 0.0 – 3155760000.0 (100 years)
     * 
     * infrared: double
     * The maximum brightness of the infrared channel.
     */

    Future<bool> setState({String light = "all", String power = "on", String color = "", double brightness = 0.5, double duration = 1.5, double infrared = 0.0}) async {
        final url = "https://api.lifx.com/v1/lights/$light/state";

        Completer<bool> com = new Completer<bool>();

        var bodyParams = { "power": "$power",
                           "color": "$color",
                           "brightness": "$brightness",
                           "duration": "$duration",
                           "infrared": "$infrared" };

        http.put(url, headers: _apiKeyHeader, body: bodyParams).then((response) {
            logger("Response status: ${response.statusCode}");
            logger("Response body: ${response.body}");
            
            if (response.statusCode == 207) {
                com.complete(true);
            } else {
                com.complete(false);
            }
        });

        return com.future;
    }
}