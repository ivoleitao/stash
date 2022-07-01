// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings

extension GetCacheModelCollection on Isar {
  IsarCollection<CacheModel> get cacheModels => getCollection();
}

const CacheModelSchema = CollectionSchema(
  name: r'Cache',
  schema:
      r'{"name":"Cache","idName":"id","properties":[{"name":"accessTime","type":"Long"},{"name":"creationTime","type":"Long"},{"name":"expiryTime","type":"Long"},{"name":"hitCount","type":"Long"},{"name":"key","type":"String"},{"name":"updateTime","type":"Long"},{"name":"value","type":"ByteList"}],"indexes":[{"name":"key","unique":false,"replace":false,"properties":[{"name":"key","type":"Hash","caseSensitive":true}]}],"links":[]}',
  idName: r'id',
  propertyIds: {
    r'accessTime': 0,
    r'creationTime': 1,
    r'expiryTime': 2,
    r'hitCount': 3,
    r'key': 4,
    r'updateTime': 5,
    r'value': 6
  },
  listProperties: {r'value'},
  indexIds: {r'key': 0},
  indexValueTypes: {
    r'key': [
      IndexValueType.stringHash,
    ]
  },
  linkIds: {},
  backlinkLinkNames: {},
  getId: _cacheModelGetId,
  setId: _cacheModelSetId,
  getLinks: _cacheModelGetLinks,
  attachLinks: _cacheModelAttachLinks,
  serializeNative: _cacheModelSerializeNative,
  deserializeNative: _cacheModelDeserializeNative,
  deserializePropNative: _cacheModelDeserializePropNative,
  serializeWeb: _cacheModelSerializeWeb,
  deserializeWeb: _cacheModelDeserializeWeb,
  deserializePropWeb: _cacheModelDeserializePropWeb,
  version: 4,
);

int? _cacheModelGetId(CacheModel object) {
  if (object.id == Isar.autoIncrement) {
    return null;
  } else {
    return object.id;
  }
}

void _cacheModelSetId(CacheModel object, int id) {
  object.id = id;
}

List<IsarLinkBase<dynamic>> _cacheModelGetLinks(CacheModel object) {
  return [];
}

void _cacheModelSerializeNative(
    IsarCollection<CacheModel> collection,
    IsarCObject cObj,
    CacheModel object,
    int staticSize,
    List<int> offsets,
    AdapterAlloc alloc) {
  final key$Bytes = IsarBinaryWriter.utf8Encoder.convert(object.key);
  final size = (staticSize + (key$Bytes.length) + (object.value.length)) as int;
  cObj.buffer = alloc(size);
  cObj.buffer_length = size;

  final buffer = IsarNative.bufAsBytes(cObj.buffer, size);
  final writer = IsarBinaryWriter(buffer, staticSize);
  writer.writeHeader();
  writer.writeDateTime(offsets[0], object.accessTime);
  writer.writeDateTime(offsets[1], object.creationTime);
  writer.writeDateTime(offsets[2], object.expiryTime);
  writer.writeLong(offsets[3], object.hitCount);
  writer.writeBytes(offsets[4], key$Bytes);
  writer.writeDateTime(offsets[5], object.updateTime);
  writer.writeBytes(offsets[6], object.value);
}

CacheModel _cacheModelDeserializeNative(IsarCollection<CacheModel> collection,
    int id, IsarBinaryReader reader, List<int> offsets) {
  final object = CacheModel();
  object.accessTime = reader.readDateTimeOrNull(offsets[0]);
  object.creationTime = reader.readDateTime(offsets[1]);
  object.expiryTime = reader.readDateTime(offsets[2]);
  object.hitCount = reader.readLongOrNull(offsets[3]);
  object.id = id;
  object.key = reader.readString(offsets[4]);
  object.updateTime = reader.readDateTimeOrNull(offsets[5]);
  object.value = reader.readBytes(offsets[6]);
  return object;
}

P _cacheModelDeserializePropNative<P>(
    int id, IsarBinaryReader reader, int propertyIndex, int offset) {
  switch (propertyIndex) {
    case -1:
      return id as P;
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 6:
      return (reader.readBytes(offset)) as P;
    default:
      throw IsarError('Illegal propertyIndex');
  }
}

Object _cacheModelSerializeWeb(
    IsarCollection<CacheModel> collection, CacheModel object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(
      jsObj, r'accessTime', object.accessTime?.toUtc().millisecondsSinceEpoch);
  IsarNative.jsObjectSet(jsObj, r'creationTime',
      object.creationTime.toUtc().millisecondsSinceEpoch);
  IsarNative.jsObjectSet(
      jsObj, r'expiryTime', object.expiryTime.toUtc().millisecondsSinceEpoch);
  IsarNative.jsObjectSet(jsObj, r'hitCount', object.hitCount);
  IsarNative.jsObjectSet(jsObj, r'id', object.id);
  IsarNative.jsObjectSet(jsObj, r'key', object.key);
  IsarNative.jsObjectSet(
      jsObj, r'updateTime', object.updateTime?.toUtc().millisecondsSinceEpoch);
  IsarNative.jsObjectSet(jsObj, r'value', object.value);
  return jsObj;
}

CacheModel _cacheModelDeserializeWeb(
    IsarCollection<CacheModel> collection, Object jsObj) {
  final object = CacheModel();
  object.accessTime = IsarNative.jsObjectGet(jsObj, r'accessTime') != null
      ? DateTime.fromMillisecondsSinceEpoch(
              IsarNative.jsObjectGet(jsObj, r'accessTime') as int,
              isUtc: true)
          .toLocal()
      : null;
  object.creationTime = IsarNative.jsObjectGet(jsObj, r'creationTime') != null
      ? DateTime.fromMillisecondsSinceEpoch(
              IsarNative.jsObjectGet(jsObj, r'creationTime') as int,
              isUtc: true)
          .toLocal()
      : DateTime.fromMillisecondsSinceEpoch(0);
  object.expiryTime = IsarNative.jsObjectGet(jsObj, r'expiryTime') != null
      ? DateTime.fromMillisecondsSinceEpoch(
              IsarNative.jsObjectGet(jsObj, r'expiryTime') as int,
              isUtc: true)
          .toLocal()
      : DateTime.fromMillisecondsSinceEpoch(0);
  object.hitCount = IsarNative.jsObjectGet(jsObj, r'hitCount');
  object.id = IsarNative.jsObjectGet(jsObj, r'id');
  object.key = IsarNative.jsObjectGet(jsObj, r'key') ?? '';
  object.updateTime = IsarNative.jsObjectGet(jsObj, r'updateTime') != null
      ? DateTime.fromMillisecondsSinceEpoch(
              IsarNative.jsObjectGet(jsObj, r'updateTime') as int,
              isUtc: true)
          .toLocal()
      : null;
  object.value = IsarNative.jsObjectGet(jsObj, r'value') ?? Uint8List(0);
  return object;
}

P _cacheModelDeserializePropWeb<P>(Object jsObj, String propertyName) {
  switch (propertyName) {
    case r'accessTime':
      return (IsarNative.jsObjectGet(jsObj, r'accessTime') != null
          ? DateTime.fromMillisecondsSinceEpoch(
                  IsarNative.jsObjectGet(jsObj, r'accessTime') as int,
                  isUtc: true)
              .toLocal()
          : null) as P;
    case r'creationTime':
      return (IsarNative.jsObjectGet(jsObj, r'creationTime') != null
          ? DateTime.fromMillisecondsSinceEpoch(
                  IsarNative.jsObjectGet(jsObj, r'creationTime') as int,
                  isUtc: true)
              .toLocal()
          : DateTime.fromMillisecondsSinceEpoch(0)) as P;
    case r'expiryTime':
      return (IsarNative.jsObjectGet(jsObj, r'expiryTime') != null
          ? DateTime.fromMillisecondsSinceEpoch(
                  IsarNative.jsObjectGet(jsObj, r'expiryTime') as int,
                  isUtc: true)
              .toLocal()
          : DateTime.fromMillisecondsSinceEpoch(0)) as P;
    case r'hitCount':
      return (IsarNative.jsObjectGet(jsObj, r'hitCount')) as P;
    case r'id':
      return (IsarNative.jsObjectGet(jsObj, r'id')) as P;
    case r'key':
      return (IsarNative.jsObjectGet(jsObj, r'key') ?? '') as P;
    case r'updateTime':
      return (IsarNative.jsObjectGet(jsObj, r'updateTime') != null
          ? DateTime.fromMillisecondsSinceEpoch(
                  IsarNative.jsObjectGet(jsObj, r'updateTime') as int,
                  isUtc: true)
              .toLocal()
          : null) as P;
    case r'value':
      return (IsarNative.jsObjectGet(jsObj, r'value') ?? Uint8List(0)) as P;
    default:
      throw IsarError('Illegal propertyName');
  }
}

void _cacheModelAttachLinks(
    IsarCollection<dynamic> col, int id, CacheModel object) {}

extension CacheModelQueryWhereSort
    on QueryBuilder<CacheModel, CacheModel, QWhere> {
  QueryBuilder<CacheModel, CacheModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterWhere> anyKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'key'),
      );
    });
  }
}

extension CacheModelQueryWhere
    on QueryBuilder<CacheModel, CacheModel, QWhereClause> {
  QueryBuilder<CacheModel, CacheModel, QAfterWhereClause> idEqualTo(int id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterWhereClause> idNotEqualTo(int id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterWhereClause> idGreaterThan(int id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterWhereClause> idLessThan(int id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterWhereClause> idBetween(
    int lowerId,
    int upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterWhereClause> keyEqualTo(
      String key) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'key',
        value: [key],
      ));
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterWhereClause> keyNotEqualTo(
      String key) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'key',
              lower: [],
              upper: [key],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'key',
              lower: [key],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'key',
              lower: [key],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'key',
              lower: [],
              upper: [key],
              includeUpper: false,
            ));
      }
    });
  }
}

extension CacheModelQueryFilter
    on QueryBuilder<CacheModel, CacheModel, QFilterCondition> {
  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition>
      accessTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'accessTime',
      ));
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> accessTimeEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'accessTime',
        value: value,
      ));
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition>
      accessTimeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'accessTime',
        value: value,
      ));
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition>
      accessTimeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'accessTime',
        value: value,
      ));
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> accessTimeBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'accessTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition>
      creationTimeEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'creationTime',
        value: value,
      ));
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition>
      creationTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'creationTime',
        value: value,
      ));
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition>
      creationTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'creationTime',
        value: value,
      ));
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition>
      creationTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'creationTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> expiryTimeEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'expiryTime',
        value: value,
      ));
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition>
      expiryTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'expiryTime',
        value: value,
      ));
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition>
      expiryTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'expiryTime',
        value: value,
      ));
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> expiryTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'expiryTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> hitCountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'hitCount',
      ));
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> hitCountEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hitCount',
        value: value,
      ));
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition>
      hitCountGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hitCount',
        value: value,
      ));
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> hitCountLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hitCount',
        value: value,
      ));
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> hitCountBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hitCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> idEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> idGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> idLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> idBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> keyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> keyGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> keyLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> keyBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'key',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> keyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> keyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> keyContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> keyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'key',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition>
      updateTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'updateTime',
      ));
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> updateTimeEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition>
      updateTimeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition>
      updateTimeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> updateTimeBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updateTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CacheModelQueryLinks
    on QueryBuilder<CacheModel, CacheModel, QFilterCondition> {}

extension CacheModelQueryWhereSortBy
    on QueryBuilder<CacheModel, CacheModel, QSortBy> {
  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> sortByAccessTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accessTime', Sort.asc);
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> sortByAccessTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accessTime', Sort.desc);
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> sortByCreationTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creationTime', Sort.asc);
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> sortByCreationTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creationTime', Sort.desc);
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> sortByExpiryTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiryTime', Sort.asc);
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> sortByExpiryTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiryTime', Sort.desc);
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> sortByHitCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hitCount', Sort.asc);
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> sortByHitCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hitCount', Sort.desc);
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> sortByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> sortByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> sortByUpdateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updateTime', Sort.asc);
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> sortByUpdateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updateTime', Sort.desc);
    });
  }
}

extension CacheModelQueryWhereSortThenBy
    on QueryBuilder<CacheModel, CacheModel, QSortThenBy> {
  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> thenByAccessTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accessTime', Sort.asc);
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> thenByAccessTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accessTime', Sort.desc);
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> thenByCreationTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creationTime', Sort.asc);
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> thenByCreationTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creationTime', Sort.desc);
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> thenByExpiryTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiryTime', Sort.asc);
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> thenByExpiryTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiryTime', Sort.desc);
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> thenByHitCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hitCount', Sort.asc);
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> thenByHitCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hitCount', Sort.desc);
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> thenByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> thenByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> thenByUpdateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updateTime', Sort.asc);
    });
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> thenByUpdateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updateTime', Sort.desc);
    });
  }
}

extension CacheModelQueryWhereDistinct
    on QueryBuilder<CacheModel, CacheModel, QDistinct> {
  QueryBuilder<CacheModel, CacheModel, QDistinct> distinctByAccessTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'accessTime');
    });
  }

  QueryBuilder<CacheModel, CacheModel, QDistinct> distinctByCreationTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'creationTime');
    });
  }

  QueryBuilder<CacheModel, CacheModel, QDistinct> distinctByExpiryTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'expiryTime');
    });
  }

  QueryBuilder<CacheModel, CacheModel, QDistinct> distinctByHitCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hitCount');
    });
  }

  QueryBuilder<CacheModel, CacheModel, QDistinct> distinctByKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'key', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CacheModel, CacheModel, QDistinct> distinctByUpdateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updateTime');
    });
  }

  QueryBuilder<CacheModel, CacheModel, QDistinct> distinctByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'value');
    });
  }
}

extension CacheModelQueryProperty
    on QueryBuilder<CacheModel, CacheModel, QQueryProperty> {
  QueryBuilder<CacheModel, DateTime?, QQueryOperations> accessTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'accessTime');
    });
  }

  QueryBuilder<CacheModel, DateTime, QQueryOperations> creationTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'creationTime');
    });
  }

  QueryBuilder<CacheModel, DateTime, QQueryOperations> expiryTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expiryTime');
    });
  }

  QueryBuilder<CacheModel, int?, QQueryOperations> hitCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hitCount');
    });
  }

  QueryBuilder<CacheModel, int?, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CacheModel, String, QQueryOperations> keyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'key');
    });
  }

  QueryBuilder<CacheModel, DateTime?, QQueryOperations> updateTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updateTime');
    });
  }

  QueryBuilder<CacheModel, Uint8List, QQueryOperations> valueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'value');
    });
  }
}
