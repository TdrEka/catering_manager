import 'package:shared_preferences/shared_preferences.dart';

import 'key_value_store.dart';

class SharedPrefsStore implements KeyValueStore {
  @override
  Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  @override
  Future<void> setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }
}

KeyValueStore createKeyValueStore() => SharedPrefsStore();