import 'dart:typed_data';

import 'package:objectbox/objectbox.dart';

import 'objectbox_entity.dart';

@Entity()
class VaultEntity implements ObjectboxEntity {
  @override
  @Id(assignable: true)
  int id;

  @override
  String key;
  @override
  Uint8List value;
  @override
  String creationTime;
  @override
  String? accessTime;
  @override
  String? updateTime;

  VaultEntity(
      {required this.id,
      required this.key,
      required this.value,
      required this.creationTime,
      this.accessTime,
      this.updateTime});
}
