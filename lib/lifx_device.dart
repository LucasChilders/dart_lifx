class LifxDevice {
  LifxDevice({
    required this.id,
    required this.uuid,
    required this.label,
    required this.connected,
    required this.power,
    required this.color,
    required this.brightness,
    required this.group,
    required this.location,
    required this.product,
    required this.lastSeen,
    required this.secondsSinceSeen,
  });

  factory LifxDevice.fromJson(Map<String, dynamic> json) {
    return LifxDevice(
        id: json['id'],
        uuid: json['uuid'],
        label: json['label'],
        connected: json['connected'],
        power: json['power'],
        color: 'hue',
        //TODO: create enum for color
        // color: json['color'],
        brightness: json['brightness'],
        //TODO: create enum for group
        group: 'Test',
        // group: json['group'],
        //TODO: create enum for group
        location: 'Test',
        // location: json['location'],
        //TODO: create enum for group
        product: 'Test',
        // product: json['product'],
        lastSeen: json['last_seen'],
        secondsSinceSeen: json['seconds_since_seen']);
  }

  String id;
  String uuid;
  String label;
  bool connected;
  String power;
  String color;
  double brightness;
  String group;
  String location;
  String product;
  String lastSeen;
  int secondsSinceSeen;
}
