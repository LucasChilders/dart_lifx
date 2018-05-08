import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:json_object/json_object.dart';


class LIFX {
    var apiKey;

    LIFX(String this.apiKey);

    Future<Map> getLights([String light = "all"]) async {
        final url = "https://api.lifx.com/v1/lights/$light";

        Completer<Map> com = new Completer<Map>();

        http.get(url, headers: {"Authorization": "Bearer ${this.apiKey}"}).then((response) {
            // print("Response status: ${response.statusCode}");
            // print("Response body: ${response.body}");
            
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

    Future<bool> togglePower([String light = "all"]) async {
        final url = "https://api.lifx.com/v1/lights/$light/toggle";

        Completer<bool> com = new Completer<bool>();

        http.post(url, headers: {"Authorization": "Bearer ${this.apiKey}"}).then((response) {
            print("Response status: ${response.statusCode}");
            print("Response body: ${response.body}");
            
            if (response.statusCode == 207) {
                com.complete(true);
            } else {
                com.complete(false);
            }
        });

        return com.future;
    }
}