import 'dart:io' show Platform;

import 'package:lifx/lifx.dart';

void main() async {
  Map<String, String> envVars = Platform.environment;

  var lifx = new LIFX(envVars["DART_LIFX"], loggingEnabled: false);

  print((await lifx.getLights())[0].label);

  // Power off all your lights
  print(await lifx.setState(power: 'off'));

  print((await lifx.getScenes())[0].name);

  print(await lifx.setState(brightness: 0.5, color: "red"));
}
