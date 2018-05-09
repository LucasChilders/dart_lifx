import 'package:lifx/lifx.dart';
import 'dart:io' show Platform;

void main() {
    Map<String, String> envVars = Platform.environment;

    var lifx = new LIFX(envVars["DART_LIFX"], loggingEnabled: false);
    lifx.setState(brightness: 0.5, color: "red").then((res) => print(res));
}