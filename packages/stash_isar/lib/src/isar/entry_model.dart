import 'package:isar/isar.dart';

abstract class EntryModel {
  Id? id;

  @Index(name: 'key')
  late String key;
  late List<byte> value;
  late DateTime creationTime;
  DateTime? accessTime;
  DateTime? updateTime;
}
