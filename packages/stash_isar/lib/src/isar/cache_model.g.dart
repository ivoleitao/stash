// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, unused_local_variable, no_leading_underscores_for_local_identifiers, inference_failure_on_function_invocation

extension GetCacheModelCollection on Isar {
  IsarCollection<CacheModel> get cacheModels => getCollection();
}

const CacheModelSchema = CollectionSchema(
  name: 'Cache',
  schema:
      '{"name":"Cache","idName":"id","properties":[{"name":"accessTime","type":"Long"},{"name":"creationTime","type":"Long"},{"name":"expiryTime","type":"Long"},{"name":"hitCount","type":"Long"},{"name":"key","type":"String"},{"name":"updateTime","type":"Long"},{"name":"value","type":"ByteList"}],"indexes":[{"name":"key","unique":false,"replace":false,"properties":[{"name":"key","type":"Hash","caseSensitive":true}]}],"links":[]}',
  idName: 'id',
  propertyIds: {
    'accessTime': 0,
    'creationTime': 1,
    'expiryTime': 2,
    'hitCount': 3,
    'key': 4,
    'updateTime': 5,
    'value': 6
  },
  listProperties: {'value'},
  indexIds: {'key': 0},
  indexValueTypes: {
    'key': [
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
  final size = staticSize + (key$Bytes.length) + (object.value.length);
  cObj.buffer = alloc(size);
  cObj.buffer_length = size;

  final buffer = IsarNative.bufAsBytes(cObj.buffer, size);
  final writer = IsarBinaryWriter(buffer, staticSize);
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
      throw 'Illegal propertyIndex';
  }
}

Object _cacheModelSerializeWeb(
    IsarCollection<CacheModel> collection, CacheModel object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(
      jsObj, 'accessTime', object.accessTime?.toUtc().millisecondsSinceEpoch);
  IsarNative.jsObjectSet(jsObj, 'creationTime',
      object.creationTime.toUtc().millisecondsSinceEpoch);
  IsarNative.jsObjectSet(
      jsObj, 'expiryTime', object.expiryTime.toUtc().millisecondsSinceEpoch);
  IsarNative.jsObjectSet(jsObj, 'hitCount', object.hitCount);
  IsarNative.jsObjectSet(jsObj, 'id', object.id);
  IsarNative.jsObjectSet(jsObj, 'key', object.key);
  IsarNative.jsObjectSet(
      jsObj, 'updateTime', object.updateTime?.toUtc().millisecondsSinceEpoch);
  IsarNative.jsObjectSet(jsObj, 'value', object.value);
  return jsObj;
}

CacheModel _cacheModelDeserializeWeb(
    IsarCollection<CacheModel> collection, Object jsObj) {
  final object = CacheModel();
  object.accessTime = IsarNative.jsObjectGet(jsObj, 'accessTime') != null
      ? DateTime.fromMillisecondsSinceEpoch(
              IsarNative.jsObjectGet(jsObj, 'accessTime') as int,
              isUtc: true)
          .toLocal()
      : null;
  object.creationTime = IsarNative.jsObjectGet(jsObj, 'creationTime') != null
      ? DateTime.fromMillisecondsSinceEpoch(
              IsarNative.jsObjectGet(jsObj, 'creationTime') as int,
              isUtc: true)
          .toLocal()
      : DateTime.fromMillisecondsSinceEpoch(0);
  object.expiryTime = IsarNative.jsObjectGet(jsObj, 'expiryTime') != null
      ? DateTime.fromMillisecondsSinceEpoch(
              IsarNative.jsObjectGet(jsObj, 'expiryTime') as int,
              isUtc: true)
          .toLocal()
      : DateTime.fromMillisecondsSinceEpoch(0);
  object.hitCount = IsarNative.jsObjectGet(jsObj, 'hitCount');
  object.id = IsarNative.jsObjectGet(jsObj, 'id');
  object.key = IsarNative.jsObjectGet(jsObj, 'key') ?? '';
  object.updateTime = IsarNative.jsObjectGet(jsObj, 'updateTime') != null
      ? DateTime.fromMillisecondsSinceEpoch(
              IsarNative.jsObjectGet(jsObj, 'updateTime') as int,
              isUtc: true)
          .toLocal()
      : null;
  object.value = IsarNative.jsObjectGet(jsObj, 'value') ?? Uint8List(0);
  return object;
}

P _cacheModelDeserializePropWeb<P>(Object jsObj, String propertyName) {
  switch (propertyName) {
    case 'accessTime':
      return (IsarNative.jsObjectGet(jsObj, 'accessTime') != null
          ? DateTime.fromMillisecondsSinceEpoch(
                  IsarNative.jsObjectGet(jsObj, 'accessTime') as int,
                  isUtc: true)
              .toLocal()
          : null) as P;
    case 'creationTime':
      return (IsarNative.jsObjectGet(jsObj, 'creationTime') != null
          ? DateTime.fromMillisecondsSinceEpoch(
                  IsarNative.jsObjectGet(jsObj, 'creationTime') as int,
                  isUtc: true)
              .toLocal()
          : DateTime.fromMillisecondsSinceEpoch(0)) as P;
    case 'expiryTime':
      return (IsarNative.jsObjectGet(jsObj, 'expiryTime') != null
          ? DateTime.fromMillisecondsSinceEpoch(
                  IsarNative.jsObjectGet(jsObj, 'expiryTime') as int,
                  isUtc: true)
              .toLocal()
          : DateTime.fromMillisecondsSinceEpoch(0)) as P;
    case 'hitCount':
      return (IsarNative.jsObjectGet(jsObj, 'hitCount')) as P;
    case 'id':
      return (IsarNative.jsObjectGet(jsObj, 'id')) as P;
    case 'key':
      return (IsarNative.jsObjectGet(jsObj, 'key') ?? '') as P;
    case 'updateTime':
      return (IsarNative.jsObjectGet(jsObj, 'updateTime') != null
          ? DateTime.fromMillisecondsSinceEpoch(
                  IsarNative.jsObjectGet(jsObj, 'updateTime') as int,
                  isUtc: true)
              .toLocal()
          : null) as P;
    case 'value':
      return (IsarNative.jsObjectGet(jsObj, 'value') ?? Uint8List(0)) as P;
    default:
      throw 'Illegal propertyName';
  }
}

void _cacheModelAttachLinks(
    IsarCollection<dynamic> col, int id, CacheModel object) {}

extension CacheModelQueryWhereSort
    on QueryBuilder<CacheModel, CacheModel, QWhere> {
  QueryBuilder<CacheModel, CacheModel, QAfterWhere> anyId() {
    return addWhereClauseInternal(const IdWhereClause.any());
  }

  QueryBuilder<CacheModel, CacheModel, QAfterWhere> anyKey() {
    return addWhereClauseInternal(const IndexWhereClause.any(indexName: 'key'));
  }
}

extension CacheModelQueryWhere
    on QueryBuilder<CacheModel, CacheModel, QWhereClause> {
  QueryBuilder<CacheModel, CacheModel, QAfterWhereClause> idEqualTo(int id) {
    return addWhereClauseInternal(IdWhereClause.between(
      lower: id,
      includeLower: true,
      upper: id,
      includeUpper: true,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterWhereClause> idNotEqualTo(int id) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(
        IdWhereClause.lessThan(upper: id, includeUpper: false),
      ).addWhereClauseInternal(
        IdWhereClause.greaterThan(lower: id, includeLower: false),
      );
    } else {
      return addWhereClauseInternal(
        IdWhereClause.greaterThan(lower: id, includeLower: false),
      ).addWhereClauseInternal(
        IdWhereClause.lessThan(upper: id, includeUpper: false),
      );
    }
  }

  QueryBuilder<CacheModel, CacheModel, QAfterWhereClause> idGreaterThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.greaterThan(lower: id, includeLower: include),
    );
  }

  QueryBuilder<CacheModel, CacheModel, QAfterWhereClause> idLessThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.lessThan(upper: id, includeUpper: include),
    );
  }

  QueryBuilder<CacheModel, CacheModel, QAfterWhereClause> idBetween(
    int lowerId,
    int upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClauseInternal(IdWhereClause.between(
      lower: lowerId,
      includeLower: includeLower,
      upper: upperId,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterWhereClause> keyEqualTo(
      String key) {
    return addWhereClauseInternal(IndexWhereClause.equalTo(
      indexName: 'key',
      value: [key],
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterWhereClause> keyNotEqualTo(
      String key) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(IndexWhereClause.lessThan(
        indexName: 'key',
        upper: [key],
        includeUpper: false,
      )).addWhereClauseInternal(IndexWhereClause.greaterThan(
        indexName: 'key',
        lower: [key],
        includeLower: false,
      ));
    } else {
      return addWhereClauseInternal(IndexWhereClause.greaterThan(
        indexName: 'key',
        lower: [key],
        includeLower: false,
      )).addWhereClauseInternal(IndexWhereClause.lessThan(
        indexName: 'key',
        upper: [key],
        includeUpper: false,
      ));
    }
  }
}

extension CacheModelQueryFilter
    on QueryBuilder<CacheModel, CacheModel, QFilterCondition> {
  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition>
      accessTimeIsNull() {
    return addFilterConditionInternal(const FilterCondition.isNull(
      property: 'accessTime',
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> accessTimeEqualTo(
      DateTime? value) {
    return addFilterConditionInternal(FilterCondition.equalTo(
      property: 'accessTime',
      value: value,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition>
      accessTimeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition.greaterThan(
      include: include,
      property: 'accessTime',
      value: value,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition>
      accessTimeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition.lessThan(
      include: include,
      property: 'accessTime',
      value: value,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> accessTimeBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'accessTime',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition>
      creationTimeEqualTo(DateTime value) {
    return addFilterConditionInternal(FilterCondition.equalTo(
      property: 'creationTime',
      value: value,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition>
      creationTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition.greaterThan(
      include: include,
      property: 'creationTime',
      value: value,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition>
      creationTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition.lessThan(
      include: include,
      property: 'creationTime',
      value: value,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition>
      creationTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'creationTime',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> expiryTimeEqualTo(
      DateTime value) {
    return addFilterConditionInternal(FilterCondition.equalTo(
      property: 'expiryTime',
      value: value,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition>
      expiryTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition.greaterThan(
      include: include,
      property: 'expiryTime',
      value: value,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition>
      expiryTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition.lessThan(
      include: include,
      property: 'expiryTime',
      value: value,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> expiryTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'expiryTime',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> hitCountIsNull() {
    return addFilterConditionInternal(const FilterCondition.isNull(
      property: 'hitCount',
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> hitCountEqualTo(
      int? value) {
    return addFilterConditionInternal(FilterCondition.equalTo(
      property: 'hitCount',
      value: value,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition>
      hitCountGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition.greaterThan(
      include: include,
      property: 'hitCount',
      value: value,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> hitCountLessThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition.lessThan(
      include: include,
      property: 'hitCount',
      value: value,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> hitCountBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'hitCount',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> idIsNull() {
    return addFilterConditionInternal(const FilterCondition.isNull(
      property: 'id',
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> idEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition.equalTo(
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> idGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition.greaterThan(
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> idLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition.lessThan(
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> idBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'id',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> keyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition.equalTo(
      property: 'key',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> keyGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition.greaterThan(
      include: include,
      property: 'key',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> keyLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition.lessThan(
      include: include,
      property: 'key',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> keyBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'key',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> keyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition.startsWith(
      property: 'key',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> keyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition.endsWith(
      property: 'key',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> keyContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition.contains(
      property: 'key',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> keyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition.matches(
      property: 'key',
      wildcard: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition>
      updateTimeIsNull() {
    return addFilterConditionInternal(const FilterCondition.isNull(
      property: 'updateTime',
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> updateTimeEqualTo(
      DateTime? value) {
    return addFilterConditionInternal(FilterCondition.equalTo(
      property: 'updateTime',
      value: value,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition>
      updateTimeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition.greaterThan(
      include: include,
      property: 'updateTime',
      value: value,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition>
      updateTimeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition.lessThan(
      include: include,
      property: 'updateTime',
      value: value,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> updateTimeBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'updateTime',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }
}

extension CacheModelQueryLinks
    on QueryBuilder<CacheModel, CacheModel, QFilterCondition> {}

extension CacheModelQueryWhereSortBy
    on QueryBuilder<CacheModel, CacheModel, QSortBy> {
  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> sortByAccessTime() {
    return addSortByInternal('accessTime', Sort.asc);
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> sortByAccessTimeDesc() {
    return addSortByInternal('accessTime', Sort.desc);
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> sortByCreationTime() {
    return addSortByInternal('creationTime', Sort.asc);
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> sortByCreationTimeDesc() {
    return addSortByInternal('creationTime', Sort.desc);
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> sortByExpiryTime() {
    return addSortByInternal('expiryTime', Sort.asc);
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> sortByExpiryTimeDesc() {
    return addSortByInternal('expiryTime', Sort.desc);
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> sortByHitCount() {
    return addSortByInternal('hitCount', Sort.asc);
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> sortByHitCountDesc() {
    return addSortByInternal('hitCount', Sort.desc);
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> sortByKey() {
    return addSortByInternal('key', Sort.asc);
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> sortByKeyDesc() {
    return addSortByInternal('key', Sort.desc);
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> sortByUpdateTime() {
    return addSortByInternal('updateTime', Sort.asc);
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> sortByUpdateTimeDesc() {
    return addSortByInternal('updateTime', Sort.desc);
  }
}

extension CacheModelQueryWhereSortThenBy
    on QueryBuilder<CacheModel, CacheModel, QSortThenBy> {
  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> thenByAccessTime() {
    return addSortByInternal('accessTime', Sort.asc);
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> thenByAccessTimeDesc() {
    return addSortByInternal('accessTime', Sort.desc);
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> thenByCreationTime() {
    return addSortByInternal('creationTime', Sort.asc);
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> thenByCreationTimeDesc() {
    return addSortByInternal('creationTime', Sort.desc);
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> thenByExpiryTime() {
    return addSortByInternal('expiryTime', Sort.asc);
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> thenByExpiryTimeDesc() {
    return addSortByInternal('expiryTime', Sort.desc);
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> thenByHitCount() {
    return addSortByInternal('hitCount', Sort.asc);
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> thenByHitCountDesc() {
    return addSortByInternal('hitCount', Sort.desc);
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> thenByKey() {
    return addSortByInternal('key', Sort.asc);
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> thenByKeyDesc() {
    return addSortByInternal('key', Sort.desc);
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> thenByUpdateTime() {
    return addSortByInternal('updateTime', Sort.asc);
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> thenByUpdateTimeDesc() {
    return addSortByInternal('updateTime', Sort.desc);
  }
}

extension CacheModelQueryWhereDistinct
    on QueryBuilder<CacheModel, CacheModel, QDistinct> {
  QueryBuilder<CacheModel, CacheModel, QDistinct> distinctByAccessTime() {
    return addDistinctByInternal('accessTime');
  }

  QueryBuilder<CacheModel, CacheModel, QDistinct> distinctByCreationTime() {
    return addDistinctByInternal('creationTime');
  }

  QueryBuilder<CacheModel, CacheModel, QDistinct> distinctByExpiryTime() {
    return addDistinctByInternal('expiryTime');
  }

  QueryBuilder<CacheModel, CacheModel, QDistinct> distinctByHitCount() {
    return addDistinctByInternal('hitCount');
  }

  QueryBuilder<CacheModel, CacheModel, QDistinct> distinctByKey(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('key', caseSensitive: caseSensitive);
  }

  QueryBuilder<CacheModel, CacheModel, QDistinct> distinctByUpdateTime() {
    return addDistinctByInternal('updateTime');
  }
}

extension CacheModelQueryProperty
    on QueryBuilder<CacheModel, CacheModel, QQueryProperty> {
  QueryBuilder<CacheModel, DateTime?, QQueryOperations> accessTimeProperty() {
    return addPropertyNameInternal('accessTime');
  }

  QueryBuilder<CacheModel, DateTime, QQueryOperations> creationTimeProperty() {
    return addPropertyNameInternal('creationTime');
  }

  QueryBuilder<CacheModel, DateTime, QQueryOperations> expiryTimeProperty() {
    return addPropertyNameInternal('expiryTime');
  }

  QueryBuilder<CacheModel, int?, QQueryOperations> hitCountProperty() {
    return addPropertyNameInternal('hitCount');
  }

  QueryBuilder<CacheModel, int?, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<CacheModel, String, QQueryOperations> keyProperty() {
    return addPropertyNameInternal('key');
  }

  QueryBuilder<CacheModel, DateTime?, QQueryOperations> updateTimeProperty() {
    return addPropertyNameInternal('updateTime');
  }

  QueryBuilder<CacheModel, Uint8List, QQueryOperations> valueProperty() {
    return addPropertyNameInternal('value');
  }
}
