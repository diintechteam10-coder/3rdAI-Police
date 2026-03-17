// import 'package:shared_preferences/shared_preferences.dart';

// class SharedPreferencesService {
//   static SharedPreferencesService? _instance;
//   static SharedPreferences? _preferences;
// // singleton
//   static Future<SharedPreferencesService> getInstance() async {
//     if (_instance == null) {
//       _instance = SharedPreferencesService();
//       await _instance!._initPreferences();
//     }
//     return _instance!;
//   }

//   Future<void> _initPreferences() async {
//     _preferences = await SharedPreferences.getInstance();
//   }

//   // Setters
//   Future<bool> setBool(String key, bool value) {
//     return _preferences!.setBool(key, value);
//   }

//   Future<bool> setInt(String key, int value) {
//     return _preferences!.setInt(key, value);
//   }

//   Future<bool> setDouble(String key, double value) {
//     return _preferences!.setDouble(key, value);
//   }

//   Future<bool> setString(String key, String value) {
//     return _preferences!.setString(key, value);
//   }

//   Future<bool> setStringList(String key, List<String> value) {
//     return _preferences!.setStringList(key, value);
//   }

//   // Getters
//   bool? getBool(String key) {
//     return _preferences!.getBool(key);
//   }


//   int? getInt(String key) {
//     return _preferences!.getInt(key);
//   }

//   double? getDouble(String key) {
//     return _preferences!.getDouble(key);
//   }

//   String? getString(String key) {
//     return _preferences!.getString(key);
//   }

//   List<String>? getStringList(String key) {
//     return _preferences!.getStringList(key);
//   }

//   // Remove
//   Future<bool> remove(String key) {
//     return _preferences!.remove(key);
//   }

//   // Clear all data
//   Future<bool> clear() {
//     return _preferences!.clear();
//   }
//   // Get all keys
//   Set<String> getKeys() {
//     return _preferences!.getKeys();
//   }
// }




import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static SecureStorageService? _instance;
  static FlutterSecureStorage? _storage;

  // Private constructor
  SecureStorageService._();

  /// Singleton instance
  static SecureStorageService get instance {
    _instance ??= SecureStorageService._();
    _storage ??= const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock,
      ),
    );
    return _instance!;
  }

  // =========================
  // Write Methods
  // =========================

  Future<void> write({
    required String key,
    required String value,
  }) async {
    await _storage!.write(key: key, value: value);
  }

  // =========================
  // Read Method
  // =========================

  Future<String?> read(String key) async {
    return await _storage!.read(key: key);
  }

  // =========================
  // Delete Single Key
  // =========================

  Future<void> delete(String key) async {
    await _storage!.delete(key: key);
  }

  // =========================
  // Delete All
  // =========================

  Future<void> deleteAll() async {
    await _storage!.deleteAll();
  }

  // =========================
  // Check if key exists
  // =========================

  Future<bool> containsKey(String key) async {
    return await _storage!.containsKey(key: key);
  }

  // =========================
  // Read All
  // =========================

  Future<Map<String, String>> readAll() async {
    return await _storage!.readAll();
  }
}