import 'dart:typed_data';

import 'package:isar/isar.dart';

import 'entry_model.dart';

part 'cache_model.g.dart';

@Collection()
@Name('Cache')
class CacheModel extends EntryModel {
  late DateTime expiryTime;
  int? hitCount;
}
