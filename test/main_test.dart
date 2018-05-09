import 'package:test/test.dart';
import 'package:lifx/lifx.dart';
import 'dart:async';
import 'dart:io' show Platform;

void main() {
    Map<String, String> envVars = Platform.environment;
    var lifx = new LIFX(envVars["DART_LIFX"], loggingEnabled: false);

    /**
     * Test [getHexFromRGB()]
     */

    test("Test getHexFromRGB", () {
        expect(lifx.getHexFromRGB(50, 100, 150), equals("#326496"));
    });


    /**
     * Test [getLights()]
     */

    test("Test getLights", () async {
        var response = await new Future(() => lifx.getLights());
        expect(response.containsKey("count"), true);
    });


    /**
     * Test [getScenes()]
     */

    test("Test getScenes", () async {
        var response = await new Future(() => lifx.getScenes());
        expect(response.containsKey("count"), true);
    });


    /**
     * Test [toggleLights()]
     */

    test("Test toggleLights", () async {
        var response = await new Future(() => lifx.togglePower());
        expect(response, true);
    });

    /**
     * Test [activateScene()]
     */

    test("Test activateScene", () async {
        Map scenes = await new Future(() => lifx.getScenes());
        var response = await new Future(() => lifx.activateScene(scenes[scenes.keys.first.toString()]));
        expect(response, true);
    });


    /**
     * Test [setState()]
     */

    test("Test setState", () async {
        var response = await new Future(() => lifx.setState(power: "on", color: "white", brightness: 0.5, duration: 2.0));
        expect(response, true);
    });
}