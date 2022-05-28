import 'package:sembast/sembast.dart';
import 'package:sembast_web/sembast_web.dart';
import 'package:stash_sembast/stash_sembast.dart';

class SembastWebAdapter extends SembastAdapter {
  final String name;

  /// Builds a [SembastWebAdapter].
  ///
  /// * [name]: The database name
  /// * [version]: The expected version
  /// * [onVersionChanged]:  If [version] not null and if the existing version is different, onVersionChanged is called
  /// * [mode]: The database mode
  /// * [codec]: The codec which can be used to load/save a record, allowing for user encryption
  SembastWebAdapter(this.name,
      {int? version,
      OnVersionChangedFunction? onVersionChanged,
      DatabaseMode? mode,
      SembastCodec? codec})
      : super(
            version: version,
            onVersionChanged: onVersionChanged,
            mode: mode,
            codec: codec);

  @override
  Future<Database> openDatabase() {
    return databaseFactoryWeb.openDatabase(name,
        version: version,
        onVersionChanged: onVersionChanged,
        mode: mode,
        codec: codec);
  }

  @override
  Future<void> deleteDatabase(String path) {
    return databaseFactoryWeb.deleteDatabase(path);
  }
}
