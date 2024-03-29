import 'dart:typed_data';

import 'package:objectbox/objectbox.dart';

import 'objectbox_entity.dart';

@Entity()
class CacheEntity implements ObjectboxEntity {
  @override
  @Id(assignable: true)
  int id;

  @override
  String key;
  @override
  Uint8List value;
  String expiryTime;
  @override
  String creationTime;
  @override
  String? accessTime;
  @override
  String? updateTime;
  int? hitCount;

  CacheEntity(
      {required this.id,
      required this.key,
      required this.value,
      required this.expiryTime,
      required this.creationTime,
      this.accessTime,
      this.updateTime,
      this.hitCount});
}
