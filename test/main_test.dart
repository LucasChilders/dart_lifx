import 'dart:io' show Platform;

import 'package:lifx/lifx.dart';
import 'package:lifx/lifx_device.dart';
import 'package:lifx/lifx_scene.dart';
import 'package:test/test.dart';

void main() {
  Map<String, String> envVars = Platform.environment;

  var lifx = new LIFX(envVars["DART_LIFX"], loggingEnabled: false);

  /// Test [getHexFromRGB()]
  test('Test getHexFromRGB', () {
    expect(lifx.getHexFromRGB(50, 100, 150), equals('#326496'));
  });

  /// Test [getLights()]
  test('Test getLights', () async {
    List<LifxDevice> response = await lifx.getLights();
    expect(response.isNotEmpty, true);
  });

  /// Test [getScenes()]
  test('Test getScenes', () async {
    var response = await lifx.getScenes();
    expect(response.isNotEmpty, true);
  });

  /// Test [toggleLights()]

  test('Test toggleLights', () async {
    var response = await lifx.togglePower();
    expect(response, true);
  });

  /// Test [activateScene()]
  test('Test activateScene', () async {
    List<LifxScene> scenes = await lifx.getScenes();
    var response = await lifx.activateScene(scenes[0].uuid);
    expect(response, true);
  });

  /// Test [setState()]
  test('Test setState', () async {
    var response = await lifx.setState(
        power: 'on', color: 'white', brightness: 0.5, duration: 2.0);
    expect(response, true);
  });
}
