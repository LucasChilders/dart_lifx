import 'package:lifx/lifx.dart';
import 'dart:io' show Platform;

void main() {
    Map<String, String> envVars = Platform.environment;

    var lifx = new LIFX(envVars["DART_LIFX"], loggingEnabled: true);
    lifx.getLights().then((res) => print(res));
}