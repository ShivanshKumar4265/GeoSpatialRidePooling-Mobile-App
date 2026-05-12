import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  // Private constructor for Singleton pattern
  SharedPreferencesUtil._();

  // The singleton instance
  static final SharedPreferencesUtil _instance = SharedPreferencesUtil._();

  // Getter to access the instance globally
  static SharedPreferencesUtil get instance => _instance;

  // Save a boolean value
  Future<void> setBoolData(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  // Save a string value
  Future<void> setStringData(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  // Save an integer value
  Future<void> setIntData(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  // Save a double value
  Future<void> setDoubleData(String key, double value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble(key, value);
  }

  // Get a boolean value
  Future<bool?> getBoolData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  // Get a string value
  Future<String?> getStringData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  // Get an integer value
  Future<int?> getIntData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  // Get a double value
  Future<double?> getDoubleData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key);
  }

  // Remove a single entry
  Future<void> removeData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  // Clear all data
  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  // Clear all data except keys in the provided list
  Future<void> clearAllExceptKeys(List<String> keepKeys) async {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve all the keys from shared preferences
    final allKeys = prefs.getKeys();

    // Loop through the keys and remove all except the ones you want to keep
    for (String key in allKeys) {
      if (!keepKeys.contains(key)) {
        await prefs.remove(key);
      }
    }
  }

  // Get data from SharedPreferences using a key path (e.g., 'user.name')
  Future<String?> getData(String sharedPrefKey, String keyPath) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(sharedPrefKey);

    if (jsonString != null) {
      // Decode XML entities
      final decodedString = jsonString
          .replaceAll('&quot;', '"')
          .replaceAll('&amp;', '&'); // Handle other entities if needed

      // Parse the JSON
      final jsonData = jsonDecode(decodedString);

      // Traverse the key path
      dynamic currentData = jsonData;
      for (final key in keyPath.split('.')) {
        if (currentData is Map<String, dynamic> &&
            currentData.containsKey(key)) {
          currentData = currentData[key];
        } else {
          return null; // Key not found
        }
      }
      return currentData?.toString();
    }
    return null; // SharedPreferences key not found
  }
}
