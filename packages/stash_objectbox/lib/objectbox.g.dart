// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: camel_case_types

import 'dart:typed_data';

import 'package:objectbox/flatbuffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart';

import 'src/objectbox/cache_entity.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <ModelEntity>[
  ModelEntity(
      id: const IdUid(4, 5011109035722287274),
      name: 'CacheEntity',
      lastPropertyId: const IdUid(11, 7164938786966340973),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 1076473317927216075),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(5, 1490297446569401364),
            name: 'expiryTime',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 5071584100844141000),
            name: 'creationTime',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 5586757287364210649),
            name: 'accessTime',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 1244094463178899746),
            name: 'updateTime',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 4880652661592067201),
            name: 'hitCount',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 647287731825274377),
            name: 'key',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(11, 7164938786966340973),
            name: 'value',
            type: 23,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[])
];

/// ObjectBox model definition, pass it to [Store] - Store(getObjectBoxModel())
ModelDefinition getObjectBoxModel() {
  final model = ModelInfo(
      entities: _entities,
      lastEntityId: const IdUid(4, 5011109035722287274),
      lastIndexId: const IdUid(0, 0),
      lastRelationId: const IdUid(0, 0),
      lastSequenceId: const IdUid(0, 0),
      retiredEntityUids: const [
        4871219055877644958,
        3170801302516940312,
        1463056282138080085
      ],
      retiredIndexUids: const [],
      retiredPropertyUids: const [
        5420264932062407327,
        8312889772924034738,
        1201046228121717544,
        8318909918605768619,
        523235956338335547,
        7010046491295070138,
        1753659186842479407,
        3820146119054923983,
        1288818580948337948,
        4238340144319363592,
        4972912211099811194,
        7455181045514083876,
        8031194273224908966,
        3155884648946248561,
        2390847964259207140,
        7951154263744985103,
        8717053048086099196,
        841540300111972365,
        953506509246344308,
        4544165214297117582,
        5849483025584939680,
        4911809690187606511,
        2185337143616521505,
        6401280775693385501,
        6957991945771947159,
        2035604991037921275,
        1711451347244456241,
        653871223827448058,
        7798459110751191052,
        2490551660392624767,
        6628708505357165366,
        4098534613574496426
      ],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, EntityDefinition>{
    CacheEntity: EntityDefinition<CacheEntity>(
        model: _entities[0],
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
              key:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 22, ''),
              value: Uint8List.fromList(
                  const fb.ListReader<int>(fb.Int8Reader())
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
        })
  };

  return ModelDefinition(model, bindings);
}

/// [CacheEntity] entity fields to define ObjectBox queries.
class CacheEntity_ {
  static final id =
      QueryIntegerProperty<CacheEntity>(_entities[0].properties[0]);
  static final expiryTime =
      QueryStringProperty<CacheEntity>(_entities[0].properties[1]);
  static final creationTime =
      QueryStringProperty<CacheEntity>(_entities[0].properties[2]);
  static final accessTime =
      QueryStringProperty<CacheEntity>(_entities[0].properties[3]);
  static final updateTime =
      QueryStringProperty<CacheEntity>(_entities[0].properties[4]);
  static final hitCount =
      QueryIntegerProperty<CacheEntity>(_entities[0].properties[5]);
  static final key =
      QueryStringProperty<CacheEntity>(_entities[0].properties[6]);
  static final value =
      QueryByteVectorProperty<CacheEntity>(_entities[0].properties[7]);
}
