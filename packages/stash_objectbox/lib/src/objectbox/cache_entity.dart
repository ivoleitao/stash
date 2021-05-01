import 'dart:typed_data';

import 'package:objectbox/objectbox.dart';

@Entity()
class CacheEntity {
  @Id(assignable: true)
  int id;

  String key;
  Uint8List value;
  String expiryTime;
  String creationTime;
  String? accessTime;
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
