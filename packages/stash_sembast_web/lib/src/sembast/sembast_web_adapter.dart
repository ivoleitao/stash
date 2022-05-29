import 'package:sembast/sembast.dart';
import 'package:sembast_web/sembast_web.dart';
import 'package:stash_sembast/stash_sembast.dart';

class SembastWebAdapter extends SembastAdapter {
  /// The database name
  final String name;

  /// [SembastWebAdapter] constructor.
  ///
  /// * [db]: The database
  /// * [name]: The database name
  SembastWebAdapter._(super.db, this.name);

  /// Builds [SembastWebAdapter].
  ///
  /// * [name]: The name of the database
  /// * [version]: The expected version
  /// * [onVersionChanged]:  If [version] not null and if the existing version is different, onVersionChanged is called
  /// * [mode]: The database mode
  /// * [codec]: The codec which can be used to load/save a record, allowing for user encryption
  static Future<SembastWebAdapter> build(String name,
      {int? version,
      OnVersionChangedFunction? onVersionChanged,
      DatabaseMode? mode,
      SembastCodec? codec}) {
    return databaseFactoryWeb
        .openDatabase(name,
            version: version,
            onVersionChanged: onVersionChanged,
            mode: mode,
            codec: codec)
        .then((db) => SembastWebAdapter._(db, name));
  }

  @override
  Future<void> deleteDatabase(String path) {
    return databaseFactoryWeb.deleteDatabase(path);
  }
}
