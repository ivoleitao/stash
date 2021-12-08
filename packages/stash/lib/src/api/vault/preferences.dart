import 'vault.dart';

abstract class Preferences extends Vault {
  /// Reads a value for the specified [key], throwing an exception if it's not a
  /// bool.
  ///
  /// * [key]: the key
  /// * [def]: the default boolean value if null
  Future<bool?> getBool(String key, {bool? def});

  /// Saves a bool [value] to persistent storage.
  ///
  /// * [key]: the key
  /// * [value]: the bool value
  Future<void> setBool(String key, bool value);

  /// Reads a value for the specified [key], throwing an exception if it's not a
  /// double.
  ///
  /// * [key]: the key
  /// * [def]: the default double value if null
  Future<int?> getInt(String key, {int? def});

  /// Saves a int [value] to persistent storage.
  ///
  /// * [key]: the key
  /// * [value]: the int value
  Future<void> setInt(String key, int value);

  /// Reads a value for the specified [key], throwing an exception if it's not a
  /// double.
  ///
  /// * [key]: the key
  /// * [def]: the default double value if null
  Future<double?> getDouble(String key, {double? def});

  /// Saves a double [value] to persistent storage.
  ///
  /// * [key]: the key
  /// * [value]: the double value
  Future<void> setDouble(String key, double value);

  /// Reads a value for the specified [key], throwing an exception if it's not a
  /// string.
  ///
  /// * [key]: the key
  /// * [def]: the default string value if null
  Future<String?> getString(String key, {String? def});

  /// Saves a string [value] to persistent storage.
  ///
  /// * [key]: the key
  /// * [value]: the string value
  Future<void> setString(String key, String value);

  /// Reads a value for the specified [key], throwing an exception if it's not a
  /// bool list.
  ///
  /// * [key]: the key
  /// * [def]: the default list of bool value if null
  Future<List<bool>?> getBoolList(String key, {List<bool>? def});

  /// Saves a bool list [value] to persistent storage.
  ///
  /// * [key]: the key
  /// * [value]: the bool list value
  Future<void> setBoolList(String key, List<bool> value);

  /// Reads a value for the specified [key], throwing an exception if it's not a
  /// int list.
  ///
  /// * [key]: the key
  /// * [def]: the default list of int value if null
  Future<List<int>?> getIntList(String key, {List<int>? def});

  /// Saves a int list [value] to persistent storage.
  ///
  /// * [key]: the key
  /// * [value]: the int list value
  Future<void> setIntList(String key, List<int> value);

  /// Reads a value for the specified [key], throwing an exception if it's not a
  /// double list.
  ///
  /// * [key]: the key
  /// * [def]: the default list of double value if null
  Future<List<double>?> getDoubleList(String key, {List<double>? def});

  /// Saves a double list [value] to persistent storage.
  ///
  /// * [key]: the key
  /// * [value]: the double list value
  Future<void> setDoubleList(String key, List<double> value);

  /// Reads a value for the specified [key], throwing an exception if it's not a
  /// string list.
  ///
  /// * [key]: the key
  /// * [def]: the default list of string value if null
  Future<List<String>?> getStringList(String key, {List<String>? def});

  /// Saves a string list [value] to persistent storage.
  ///
  /// * [key]: the key
  /// * [value]: the string list value
  Future<void> setStringList(String key, List<String> value);
}
