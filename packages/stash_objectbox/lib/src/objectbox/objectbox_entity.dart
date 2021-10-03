import 'dart:typed_data';

abstract class ObjectboxEntity {
  int get id;
  String get key;
  Uint8List get value;
  String get creationTime;
  String? get accessTime;
  String? get updateTime;
}
