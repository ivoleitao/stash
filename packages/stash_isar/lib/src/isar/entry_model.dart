import 'dart:typed_data';

import 'package:isar/isar.dart';

abstract class EntryModel {
  Id? id;

  @Index(name: 'key')
  late String key;
  late Uint8List value;
  late DateTime creationTime;
  DateTime? accessTime;
  DateTime? updateTime;
}
