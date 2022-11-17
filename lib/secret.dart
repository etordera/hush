class Secret {
  String name;
  Map properties = Map();

  Secret({this.name});

  void set(String key, String value) {
    properties[key] = value;
  }

  String get(String key) {
    return properties[key];
  }

  void delete(String key) {
    properties.remove(key);
  }
}