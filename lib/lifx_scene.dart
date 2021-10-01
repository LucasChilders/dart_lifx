class LifxScene {
  LifxScene({
    required this.uuid,
    required this.name,
    required this.account,
    required this.states,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LifxScene.fromJson(Map<String, dynamic> json) {
    return LifxScene(
      uuid: json['uuid'],
      name: json['name'],
      //TODO: fix account data
      account: 'Test',
      // account: json['account'],
      //TODO: fix states data
      states: 'Test',
      // states: json['states'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  String uuid;
  String name;
  String account;
  String states;
  int createdAt;
  int updatedAt;
}
