// GENERATED CODE - DO NOT MODIFY BY HAND

// Currently loading model from "JSON" which always encodes with double quotes
// ignore_for_file: prefer_single_quotes
// ignore_for_file: camel_case_types

import 'dart:typed_data';

import 'package:objectbox/flatbuffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart';

import 'src/objectbox/cache_entity.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

ModelDefinition getObjectBoxModel() {
  final model = ModelInfo.fromMap({
    "entities": [
      {
        "id": "4:5011109035722287274",
        "lastPropertyId": "11:7164938786966340973",
        "name": "CacheEntity",
        "properties": [
          {
            "id": "1:1076473317927216075",
            "name": "id",
            "type": 6,
            "flags": 129,
            "dartFieldType": "int"
          },
          {
            "id": "5:1490297446569401364",
            "name": "expiryTime",
            "type": 9,
            "dartFieldType": "String"
          },
          {
            "id": "6:5071584100844141000",
            "name": "creationTime",
            "type": 9,
            "dartFieldType": "String"
          },
          {
            "id": "7:5586757287364210649",
            "name": "accessTime",
            "type": 9,
            "dartFieldType": "String?"
          },
          {
            "id": "8:1244094463178899746",
            "name": "updateTime",
            "type": 9,
            "dartFieldType": "String?"
          },
          {
            "id": "9:4880652661592067201",
            "name": "hitCount",
            "type": 6,
            "dartFieldType": "int?"
          },
          {
            "id": "10:647287731825274377",
            "name": "key",
            "type": 9,
            "dartFieldType": "String"
          },
          {
            "id": "11:7164938786966340973",
            "name": "value",
            "type": 23,
            "dartFieldType": "Uint8List"
          }
        ],
        "relations": [],
        "backlinks": [],
        "constructorParams": [
          "id named",
          "key named",
          "value named",
          "expiryTime named",
          "creationTime named",
          "accessTime named",
          "updateTime named",
          "hitCount named"
        ],
        "nullSafetyEnabled": true
      }
    ],
    "lastEntityId": "4:5011109035722287274",
    "lastIndexId": "0:0",
    "lastRelationId": "0:0",
    "lastSequenceId": "0:0",
    "modelVersion": 5
  }, check: false);

  final bindings = <Type, EntityDefinition>{};
  bindings[CacheEntity] = EntityDefinition<CacheEntity>(
      model: model.getEntityByUid(5011109035722287274),
      toOneRelations: (CacheEntity object) => [],
      toManyRelations: (CacheEntity object) => {},
      getId: (CacheEntity object) => object.id,
      setId: (CacheEntity object, int id) {
        object.id = id;
      },
      objectToFB: (CacheEntity object, fb.Builder fbb) {
        final expiryTimeOffset = fbb.writeString(object.expiryTime);
        final creationTimeOffset = fbb.writeString(object.creationTime);
        final accessTimeOffset = object.accessTime == null
            ? null
            : fbb.writeString(object.accessTime!);
        final updateTimeOffset = object.updateTime == null
            ? null
            : fbb.writeString(object.updateTime!);
        final keyOffset = fbb.writeString(object.key);
        final valueOffset = fbb.writeListInt8(object.value);
        fbb.startTable(12);
        fbb.addInt64(0, object.id);
        fbb.addOffset(4, expiryTimeOffset);
        fbb.addOffset(5, creationTimeOffset);
        fbb.addOffset(6, accessTimeOffset);
        fbb.addOffset(7, updateTimeOffset);
        fbb.addInt64(8, object.hitCount);
        fbb.addOffset(9, keyOffset);
        fbb.addOffset(10, valueOffset);
        fbb.finish(fbb.endTable());
        return object.id;
      },
      objectFromFB: (Store store, Uint8List fbData) {
        final buffer = fb.BufferContext.fromBytes(fbData);
        final rootOffset = buffer.derefObject(0);

        final object = CacheEntity(
            id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
            key: const fb.StringReader().vTableGet(buffer, rootOffset, 22, ''),
            value: Uint8List.fromList(const fb.ListReader<int>(fb.Int8Reader())
                .vTableGet(buffer, rootOffset, 24, [])),
            expiryTime:
                const fb.StringReader().vTableGet(buffer, rootOffset, 12, ''),
            creationTime:
                const fb.StringReader().vTableGet(buffer, rootOffset, 14, ''),
            accessTime: const fb.StringReader()
                .vTableGetNullable(buffer, rootOffset, 16),
            updateTime: const fb.StringReader()
                .vTableGetNullable(buffer, rootOffset, 18),
            hitCount: const fb.Int64Reader()
                .vTableGetNullable(buffer, rootOffset, 20));

        return object;
      });

  return ModelDefinition(model, bindings);
}

class CacheEntity_ {
  static final id =
      QueryIntegerProperty(entityId: 4, propertyId: 1, obxType: 6);
  static final expiryTime =
      QueryStringProperty(entityId: 4, propertyId: 5, obxType: 9);
  static final creationTime =
      QueryStringProperty(entityId: 4, propertyId: 6, obxType: 9);
  static final accessTime =
      QueryStringProperty(entityId: 4, propertyId: 7, obxType: 9);
  static final updateTime =
      QueryStringProperty(entityId: 4, propertyId: 8, obxType: 9);
  static final hitCount =
      QueryIntegerProperty(entityId: 4, propertyId: 9, obxType: 6);
  static final key =
      QueryStringProperty(entityId: 4, propertyId: 10, obxType: 9);
  static final value =
      QueryByteVectorProperty(entityId: 4, propertyId: 11, obxType: 23);
}
