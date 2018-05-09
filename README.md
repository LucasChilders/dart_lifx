dart_lifx
====

Another attempt at a LIFX library, this time written in [Dart](https://www.dartlang.org).

* Requires [LIFX API key](https://cloud.lifx.com) when creating a new object. 
* Optional named parameter, `loggingEnabled` enables or disables status codes and response body printing.
```dart
import 'package:lifx/lifx.dart';

void main() {
    var lifx = new LIFX("api_key_here", loggingEnabled: true);

    lifx.getLights().then((res) => print(res));
}
```

## Methods

All methods are asynchronous and most contain optional `light` parameter, by default all lights are selected. Pass light ID, found with `getLights()` to control individual lights. 

Read more about `setState` [here](https://api.developer.lifx.com/docs/set-state).

```dart
Future<Map> getLights({String light = "all"})
```

```dart
Future<Map> getScenes()
```

```dart
Future<bool> activateScene(String uuid, {double duration = 1.0})
```

```dart
Future<bool> togglePower({String light = "all"}) 
```

```dart
Future<bool> setState({String light = "all", String power = "on", String color = "", double brightness = 0.5, double duration = 1.5, double infrared = 0.0})
```

## Extra

Gets the hexidecimal value from standard RGB (0 - 255) values to easily set color in `setState()`.

```dart
String getHexFromRGB(int red, int green, int blue)
```
