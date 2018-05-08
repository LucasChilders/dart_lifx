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

All methods are asynchronous and contain optional `light` parameter, by default all lights are selected. Pass light ID, found with `getLights()` to control individual lights.

```dart
Future<Map> getLights([String light = "all"])
```

```dart
Future<bool> togglePower([String light = "all"]) 
```
