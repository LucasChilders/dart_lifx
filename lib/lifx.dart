import 'dart:async';
import 'dart:convert';

import 'package:hex/hex.dart';
import 'package:http/http.dart' as http;
import 'package:lifx/lifx_device.dart';
import 'package:lifx/lifx_scene.dart';

class LIFX {
  Map<String, String>? _apiKeyHeader;
  bool loggingEnabled;

  /// Requires [apiKey] to be passed.
  /// [_loggerEnabled] is a optional, defaulted to false.
  /// When true, all [response.statusCode] and [response.body] will be printed.
  LIFX(String? apiKey, {bool this.loggingEnabled = false}) {
    this._apiKeyHeader = {'Authorization': 'Bearer $apiKey'};
  }

  /// Instead of [print()], [_logger()] is used in order to toggle debug output.
  void _logger(String log) {
    if (this.loggingEnabled) {
      print('${new DateTime.now()} lifx: $log');
    }
  }

  /// Gets the hexidecimal value from standard RGB (0 - 255) values to
  /// easily set color.
  String getHexFromRGB(int red, int green, int blue) {
    return '#${HEX.encode([red, green, blue])}';
  }

  /// Asynchronously returns a Map containing every light by [label] and [id]
  /// as well as the [count] of total lights.
  Future<List<LifxDevice>> getLights({String light = 'all'}) async {
    final uri = Uri.parse('https://api.lifx.com/v1/lights/$light');

    List<LifxDevice> lifxDevices = [];

    try {
      http.Response response = await http.get(uri, headers: _apiKeyHeader);

      _logger('Response status: ${response.statusCode}');
      _logger('Response body: ${response.body}');

      if (response.statusCode == 200) {
        List devicesAsStrings = jsonDecode(response.body);

        for (var device in devicesAsStrings) {
          lifxDevices.add(LifxDevice.fromJson(device));
        }
      } else {
        _logger('Error ${response.statusCode}');
      }
    } catch (e) {
      _logger('Error decoding json $e');
    }
    return lifxDevices;
  }

  /// Asynchronously returns a Map containing every scene by [name] and
  /// [uuid] as well as the [count] of total scenes.
  Future<List<LifxScene>> getScenes() async {
    final uri = Uri.parse('https://api.lifx.com/v1/scenes');

    List<LifxScene> lifxScenes = [];

    try {
      http.Response response = await http.get(uri, headers: _apiKeyHeader);
      _logger('Response status: ${response.statusCode}');
      _logger('Response body: ${response.body}');

      if (response.statusCode == 200) {
        List scenesAsStrings = jsonDecode(response.body);

        for (var scene in scenesAsStrings) {
          lifxScenes.add(LifxScene.fromJson(scene));
        }
      } else {
        _logger('Error ${response.statusCode}');
      }
    } catch (e) {
      _logger('Error decoding json $e');
    }

    return lifxScenes;
  }

  /// Asynchronously returns a boolean based on the [response.statusCode] of
  /// the API request. Requires UUID of scene found in [getScenes()],
  /// optional [duration].
  Future<bool> activateScene(String? uuid, {double duration = 1.0}) async {
    final uri =
        Uri.parse('https://api.lifx.com/v1/scenes/scene_id:$uuid/activate');

    Completer<bool> com = new Completer<bool>();

    var bodyParams = {'duration': '$duration'};

    http.put(uri, headers: _apiKeyHeader, body: bodyParams).then((response) {
      _logger('Response status: ${response.statusCode}');
      _logger('Response body: ${response.body}');

      if (response.statusCode == 207) {
        com.complete(true);
      } else {
        com.complete(false);
      }
    });

    return com.future;
  }

  /// Asynchronously returns a boolean based on the [response.statusCode] of
  /// the API request. Optional [light] id found in [getLights()].
  Future<bool> togglePower({String light = 'all'}) async {
    final uri = Uri.parse('https://api.lifx.com/v1/lights/$light/toggle');

    Completer<bool> com = new Completer<bool>();

    http.post(uri, headers: _apiKeyHeader).then((response) {
      _logger('Response status: ${response.statusCode}');
      _logger('Response body: ${response.body}');

      if (response.statusCode == 207) {
        com.complete(true);
      } else {
        com.complete(false);
      }
    });

    return com.future;
  }

  /// Asynchronously returns a boolean based on the [response.statusCode] of
  /// the API request. If not set, color, brightness, and infrared will stay
  /// the same of current light settings.
  ///
  /// From: https://api.developer.lifx.com/docs/set-state
  ///
  /// power: String
  /// The power state you want to set on the selector. on or off
  ///
  /// color: String
  /// The color to set the light to.
  ///
  /// brightness: double
  /// The brightness level from 0.0 to 1.0. Overrides any brightness set in color (if any).
  ///
  /// duration: double
  /// How long in seconds you want the power action to take. Range: 0.0 – 3155760000.0 (100 years)
  ///
  /// infrared: double
  /// The maximum brightness of the infrared channel.
  Future<bool> setState(
      {String light = 'all',
      String power = 'on',
      String color = 'undefined',
      double brightness = -1.0,
      double duration = 1.5,
      double infrared = -1.0}) async {
    final uri = Uri.parse('https://api.lifx.com/v1/lights/$light/state');
    Completer<bool> com = new Completer<bool>();

    var bodyParams = {
      'power': '$power',
      'duration': '$duration',
    };

    if (color != 'undefined') {
      bodyParams.putIfAbsent('color', () => '$color');
    }

    if (brightness != -1.0) {
      bodyParams.putIfAbsent('brightness', () => '$brightness');
    }

    if (infrared != -1.0) {
      bodyParams.putIfAbsent('infrared', () => '$infrared');
    }

    http.put(uri, headers: _apiKeyHeader, body: bodyParams).then((response) {
      _logger('Response status: ${response.statusCode}');
      _logger('Response body: ${response.body}');

      if (response.statusCode == 207) {
        com.complete(true);
      } else {
        com.complete(false);
      }
    });

    return com.future;
  }
}
