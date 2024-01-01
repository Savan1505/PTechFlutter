import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtils {
  static Future<SharedPreferences> get _instancePrefs async =>
      _prefs ??= await SharedPreferences.getInstance();
  static SharedPreferences? _prefs;

  SharedPreferences? _prefsInstance;

  /// In case the developer does not explicitly call the init() function.
  bool _initCalled = false;

//// Initialize the SharedPreferences object in the State object's iniState() function.
  Future<SharedPreferences?> init() async {
    _initCalled = true;
    _prefsInstance = await _instancePrefs;
    _prefs = await SharedPreferences.getInstance();
    return _prefsInstance;
  }

  SharedPreferencesUtils._privateConstructor();

  static final SharedPreferencesUtils _instance =
      SharedPreferencesUtils._privateConstructor();

  factory SharedPreferencesUtils() {
    return _instance;
  }

//// Best to clean up by calling this function in the State object's dispose() function.
  void dispose() {
    _prefs = null;
    _prefsInstance = null;
  }

  void isPreferenceReady() {
    assert(
      _initCalled,
      'Prefs.init() must be called first in an initState() preferably!',
    );
    assert(_prefsInstance != null, 'SharedPreferences not ready yet!');
  }

  bool getBool(String key, [bool? defValue]) {
    isPreferenceReady();
    return _prefsInstance!.getBool(key) ?? defValue ?? false;
  }

  int? getInt(String key, [int? defValue]) {
    return _prefsInstance!.getInt(key) ?? defValue;
  }

  double getDouble(String key, [double? defValue]) {
    isPreferenceReady();
    return _prefsInstance!.getDouble(key) ?? defValue ?? 0.0;
  }

  String getString(String key, [String? defValue]) {
    isPreferenceReady();
    return _prefsInstance!.getString(key) ?? defValue ?? '';
  }

  /// Saves a boolean [value] to persistent storage in the background.
  /// If [value] is null, this is equivalent to calling [remove()] on the [key].
  Future<bool> setBool(String key, bool value) async {
    var prefs = await _instancePrefs;
    return prefs.setBool(key, value);
  }

  /// Saves an integer [value] to persistent storage in the background.
  /// If [value] is null, this is equivalent to calling [remove()] on the [key].
  Future<bool> setInt(String key, int value) async {
    var prefs = await _instancePrefs;
    return prefs.setInt(key, value);
  }

  /// Saves a double [value] to persistent storage in the background.
  /// Android doesn't support storing doubles, so it will be stored as a float.
  /// If [value] is null, this is equivalent to calling [remove()] on the [key].
  Future<bool> setDouble(String key, double value) async {
    var prefs = await _instancePrefs;
    return prefs.setDouble(key, value);
  }

  /// Saves a string [value] to persistent storage in the background.
  /// If [value] is null, this is equivalent to calling [remove()] on the [key].
  Future<bool> setString(String key, String value) async {
    var prefs = await _instancePrefs;
    return prefs.setString(key, value);
  }

  /// Removes an entry from persistent storage.
  Future<bool> remove(String key) async {
    var prefs = await _instancePrefs;
    return prefs.remove(key);
  }

  ///Completes with true once the user preferences for the app has been cleared.
  Future<bool> clearAll() async {
    var prefs = await _instancePrefs;
    return prefs.clear();
  }
}
