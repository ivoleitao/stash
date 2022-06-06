// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vault_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, unused_local_variable, no_leading_underscores_for_local_identifiers

extension GetVaultModelCollection on Isar {
  IsarCollection<VaultModel> get vaultModels => getCollection();
}

const VaultModelSchema = CollectionSchema(
  name: 'Vault',
  schema:
      '{"name":"Vault","idName":"id","properties":[{"name":"accessTime","type":"Long"},{"name":"creationTime","type":"Long"},{"name":"key","type":"String"},{"name":"updateTime","type":"Long"},{"name":"value","type":"ByteList"}],"indexes":[{"name":"key","unique":false,"replace":false,"properties":[{"name":"key","type":"Hash","caseSensitive":true}]}],"links":[]}',
  idName: 'id',
  propertyIds: {
    'accessTime': 0,
    'creationTime': 1,
    'key': 2,
    'updateTime': 3,
    'value': 4
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
  getId: _vaultModelGetId,
  setId: _vaultModelSetId,
  getLinks: _vaultModelGetLinks,
  attachLinks: _vaultModelAttachLinks,
  serializeNative: _vaultModelSerializeNative,
  deserializeNative: _vaultModelDeserializeNative,
  deserializePropNative: _vaultModelDeserializePropNative,
  serializeWeb: _vaultModelSerializeWeb,
  deserializeWeb: _vaultModelDeserializeWeb,
  deserializePropWeb: _vaultModelDeserializePropWeb,
  version: 4,
);

int? _vaultModelGetId(VaultModel object) {
  if (object.id == Isar.autoIncrement) {
    return null;
  } else {
    return object.id;
  }
}

void _vaultModelSetId(VaultModel object, int id) {
  object.id = id;
}

List<IsarLinkBase> _vaultModelGetLinks(VaultModel object) {
  return [];
}

void _vaultModelSerializeNative(
    IsarCollection<VaultModel> collection,
    IsarCObject cObj,
    VaultModel object,
    int staticSize,
    List<int> offsets,
    AdapterAlloc alloc) {
  var dynamicSize = 0;
  final value0 = object.accessTime;
  final _accessTime = value0;
  final value1 = object.creationTime;
  final _creationTime = value1;
  final value2 = object.key;
  final _key = IsarBinaryWriter.utf8Encoder.convert(value2);
  dynamicSize += (_key.length) as int;
  final value3 = object.updateTime;
  final _updateTime = value3;
  final value4 = object.value;
  dynamicSize += (value4.length) * 1;
  final _value = value4;
  final size = staticSize + dynamicSize;

  cObj.buffer = alloc(size);
  cObj.buffer_length = size;
  final buffer = IsarNative.bufAsBytes(cObj.buffer, size);
  final writer = IsarBinaryWriter(buffer, staticSize);
  writer.writeDateTime(offsets[0], _accessTime);
  writer.writeDateTime(offsets[1], _creationTime);
  writer.writeBytes(offsets[2], _key);
  writer.writeDateTime(offsets[3], _updateTime);
  writer.writeBytes(offsets[4], _value);
}

VaultModel _vaultModelDeserializeNative(IsarCollection<VaultModel> collection,
    int id, IsarBinaryReader reader, List<int> offsets) {
  final object = VaultModel();
  object.accessTime = reader.readDateTimeOrNull(offsets[0]);
  object.creationTime = reader.readDateTime(offsets[1]);
  object.id = id;
  object.key = reader.readString(offsets[2]);
  object.updateTime = reader.readDateTimeOrNull(offsets[3]);
  object.value = reader.readBytes(offsets[4]);
  return object;
}

P _vaultModelDeserializePropNative<P>(
    int id, IsarBinaryReader reader, int propertyIndex, int offset) {
  switch (propertyIndex) {
    case -1:
      return id as P;
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readBytes(offset)) as P;
    default:
      throw 'Illegal propertyIndex';
  }
}

dynamic _vaultModelSerializeWeb(
    IsarCollection<VaultModel> collection, VaultModel object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(
      jsObj, 'accessTime', object.accessTime?.toUtc().millisecondsSinceEpoch);
  IsarNative.jsObjectSet(jsObj, 'creationTime',
      object.creationTime.toUtc().millisecondsSinceEpoch);
  IsarNative.jsObjectSet(jsObj, 'id', object.id);
  IsarNative.jsObjectSet(jsObj, 'key', object.key);
  IsarNative.jsObjectSet(
      jsObj, 'updateTime', object.updateTime?.toUtc().millisecondsSinceEpoch);
  IsarNative.jsObjectSet(jsObj, 'value', object.value);
  return jsObj;
}

VaultModel _vaultModelDeserializeWeb(
    IsarCollection<VaultModel> collection, dynamic jsObj) {
  final object = VaultModel();
  object.accessTime = IsarNative.jsObjectGet(jsObj, 'accessTime') != null
      ? DateTime.fromMillisecondsSinceEpoch(
              IsarNative.jsObjectGet(jsObj, 'accessTime'),
              isUtc: true)
          .toLocal()
      : null;
  object.creationTime = IsarNative.jsObjectGet(jsObj, 'creationTime') != null
      ? DateTime.fromMillisecondsSinceEpoch(
              IsarNative.jsObjectGet(jsObj, 'creationTime'),
              isUtc: true)
          .toLocal()
      : DateTime.fromMillisecondsSinceEpoch(0);
  object.id = IsarNative.jsObjectGet(jsObj, 'id');
  object.key = IsarNative.jsObjectGet(jsObj, 'key') ?? '';
  object.updateTime = IsarNative.jsObjectGet(jsObj, 'updateTime') != null
      ? DateTime.fromMillisecondsSinceEpoch(
              IsarNative.jsObjectGet(jsObj, 'updateTime'),
              isUtc: true)
          .toLocal()
      : null;
  object.value = IsarNative.jsObjectGet(jsObj, 'value') ?? Uint8List(0);
  return object;
}

P _vaultModelDeserializePropWeb<P>(Object jsObj, String propertyName) {
  switch (propertyName) {
    case 'accessTime':
      return (IsarNative.jsObjectGet(jsObj, 'accessTime') != null
          ? DateTime.fromMillisecondsSinceEpoch(
                  IsarNative.jsObjectGet(jsObj, 'accessTime'),
                  isUtc: true)
              .toLocal()
          : null) as P;
    case 'creationTime':
      return (IsarNative.jsObjectGet(jsObj, 'creationTime') != null
          ? DateTime.fromMillisecondsSinceEpoch(
                  IsarNative.jsObjectGet(jsObj, 'creationTime'),
                  isUtc: true)
              .toLocal()
          : DateTime.fromMillisecondsSinceEpoch(0)) as P;
    case 'id':
      return (IsarNative.jsObjectGet(jsObj, 'id')) as P;
    case 'key':
      return (IsarNative.jsObjectGet(jsObj, 'key') ?? '') as P;
    case 'updateTime':
      return (IsarNative.jsObjectGet(jsObj, 'updateTime') != null
          ? DateTime.fromMillisecondsSinceEpoch(
                  IsarNative.jsObjectGet(jsObj, 'updateTime'),
                  isUtc: true)
              .toLocal()
          : null) as P;
    case 'value':
      return (IsarNative.jsObjectGet(jsObj, 'value') ?? Uint8List(0)) as P;
    default:
      throw 'Illegal propertyName';
  }
}

void _vaultModelAttachLinks(IsarCollection col, int id, VaultModel object) {}

extension VaultModelQueryWhereSort
    on QueryBuilder<VaultModel, VaultModel, QWhere> {
  QueryBuilder<VaultModel, VaultModel, QAfterWhere> anyId() {
    return addWhereClauseInternal(const IdWhereClause.any());
  }

  QueryBuilder<VaultModel, VaultModel, QAfterWhere> anyKey() {
    return addWhereClauseInternal(const IndexWhereClause.any(indexName: 'key'));
  }
}

extension VaultModelQueryWhere
    on QueryBuilder<VaultModel, VaultModel, QWhereClause> {
  QueryBuilder<VaultModel, VaultModel, QAfterWhereClause> idEqualTo(int id) {
    return addWhereClauseInternal(IdWhereClause.between(
      lower: id,
      includeLower: true,
      upper: id,
      includeUpper: true,
    ));
  }

  QueryBuilder<VaultModel, VaultModel, QAfterWhereClause> idNotEqualTo(int id) {
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

  QueryBuilder<VaultModel, VaultModel, QAfterWhereClause> idGreaterThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.greaterThan(lower: id, includeLower: include),
    );
  }

  QueryBuilder<VaultModel, VaultModel, QAfterWhereClause> idLessThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.lessThan(upper: id, includeUpper: include),
    );
  }

  QueryBuilder<VaultModel, VaultModel, QAfterWhereClause> idBetween(
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

  QueryBuilder<VaultModel, VaultModel, QAfterWhereClause> keyEqualTo(
      String key) {
    return addWhereClauseInternal(IndexWhereClause.equalTo(
      indexName: 'key',
      value: [key],
    ));
  }

  QueryBuilder<VaultModel, VaultModel, QAfterWhereClause> keyNotEqualTo(
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

extension VaultModelQueryFilter
    on QueryBuilder<VaultModel, VaultModel, QFilterCondition> {
  QueryBuilder<VaultModel, VaultModel, QAfterFilterCondition>
      accessTimeIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'accessTime',
      value: null,
    ));
  }

  QueryBuilder<VaultModel, VaultModel, QAfterFilterCondition> accessTimeEqualTo(
      DateTime? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'accessTime',
      value: value,
    ));
  }

  QueryBuilder<VaultModel, VaultModel, QAfterFilterCondition>
      accessTimeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'accessTime',
      value: value,
    ));
  }

  QueryBuilder<VaultModel, VaultModel, QAfterFilterCondition>
      accessTimeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'accessTime',
      value: value,
    ));
  }

  QueryBuilder<VaultModel, VaultModel, QAfterFilterCondition> accessTimeBetween(
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

  QueryBuilder<VaultModel, VaultModel, QAfterFilterCondition>
      creationTimeEqualTo(DateTime value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'creationTime',
      value: value,
    ));
  }

  QueryBuilder<VaultModel, VaultModel, QAfterFilterCondition>
      creationTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'creationTime',
      value: value,
    ));
  }

  QueryBuilder<VaultModel, VaultModel, QAfterFilterCondition>
      creationTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'creationTime',
      value: value,
    ));
  }

  QueryBuilder<VaultModel, VaultModel, QAfterFilterCondition>
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

  QueryBuilder<VaultModel, VaultModel, QAfterFilterCondition> idIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'id',
      value: null,
    ));
  }

  QueryBuilder<VaultModel, VaultModel, QAfterFilterCondition> idEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<VaultModel, VaultModel, QAfterFilterCondition> idGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<VaultModel, VaultModel, QAfterFilterCondition> idLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<VaultModel, VaultModel, QAfterFilterCondition> idBetween(
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

  QueryBuilder<VaultModel, VaultModel, QAfterFilterCondition> keyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'key',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<VaultModel, VaultModel, QAfterFilterCondition> keyGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'key',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<VaultModel, VaultModel, QAfterFilterCondition> keyLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'key',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<VaultModel, VaultModel, QAfterFilterCondition> keyBetween(
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

  QueryBuilder<VaultModel, VaultModel, QAfterFilterCondition> keyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'key',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<VaultModel, VaultModel, QAfterFilterCondition> keyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'key',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<VaultModel, VaultModel, QAfterFilterCondition> keyContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'key',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<VaultModel, VaultModel, QAfterFilterCondition> keyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'key',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<VaultModel, VaultModel, QAfterFilterCondition>
      updateTimeIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'updateTime',
      value: null,
    ));
  }

  QueryBuilder<VaultModel, VaultModel, QAfterFilterCondition> updateTimeEqualTo(
      DateTime? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'updateTime',
      value: value,
    ));
  }

  QueryBuilder<VaultModel, VaultModel, QAfterFilterCondition>
      updateTimeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'updateTime',
      value: value,
    ));
  }

  QueryBuilder<VaultModel, VaultModel, QAfterFilterCondition>
      updateTimeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'updateTime',
      value: value,
    ));
  }

  QueryBuilder<VaultModel, VaultModel, QAfterFilterCondition> updateTimeBetween(
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

extension VaultModelQueryLinks
    on QueryBuilder<VaultModel, VaultModel, QFilterCondition> {}

extension VaultModelQueryWhereSortBy
    on QueryBuilder<VaultModel, VaultModel, QSortBy> {
  QueryBuilder<VaultModel, VaultModel, QAfterSortBy> sortByAccessTime() {
    return addSortByInternal('accessTime', Sort.asc);
  }

  QueryBuilder<VaultModel, VaultModel, QAfterSortBy> sortByAccessTimeDesc() {
    return addSortByInternal('accessTime', Sort.desc);
  }

  QueryBuilder<VaultModel, VaultModel, QAfterSortBy> sortByCreationTime() {
    return addSortByInternal('creationTime', Sort.asc);
  }

  QueryBuilder<VaultModel, VaultModel, QAfterSortBy> sortByCreationTimeDesc() {
    return addSortByInternal('creationTime', Sort.desc);
  }

  QueryBuilder<VaultModel, VaultModel, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<VaultModel, VaultModel, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<VaultModel, VaultModel, QAfterSortBy> sortByKey() {
    return addSortByInternal('key', Sort.asc);
  }

  QueryBuilder<VaultModel, VaultModel, QAfterSortBy> sortByKeyDesc() {
    return addSortByInternal('key', Sort.desc);
  }

  QueryBuilder<VaultModel, VaultModel, QAfterSortBy> sortByUpdateTime() {
    return addSortByInternal('updateTime', Sort.asc);
  }

  QueryBuilder<VaultModel, VaultModel, QAfterSortBy> sortByUpdateTimeDesc() {
    return addSortByInternal('updateTime', Sort.desc);
  }
}

extension VaultModelQueryWhereSortThenBy
    on QueryBuilder<VaultModel, VaultModel, QSortThenBy> {
  QueryBuilder<VaultModel, VaultModel, QAfterSortBy> thenByAccessTime() {
    return addSortByInternal('accessTime', Sort.asc);
  }

  QueryBuilder<VaultModel, VaultModel, QAfterSortBy> thenByAccessTimeDesc() {
    return addSortByInternal('accessTime', Sort.desc);
  }

  QueryBuilder<VaultModel, VaultModel, QAfterSortBy> thenByCreationTime() {
    return addSortByInternal('creationTime', Sort.asc);
  }

  QueryBuilder<VaultModel, VaultModel, QAfterSortBy> thenByCreationTimeDesc() {
    return addSortByInternal('creationTime', Sort.desc);
  }

  QueryBuilder<VaultModel, VaultModel, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<VaultModel, VaultModel, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<VaultModel, VaultModel, QAfterSortBy> thenByKey() {
    return addSortByInternal('key', Sort.asc);
  }

  QueryBuilder<VaultModel, VaultModel, QAfterSortBy> thenByKeyDesc() {
    return addSortByInternal('key', Sort.desc);
  }

  QueryBuilder<VaultModel, VaultModel, QAfterSortBy> thenByUpdateTime() {
    return addSortByInternal('updateTime', Sort.asc);
  }

  QueryBuilder<VaultModel, VaultModel, QAfterSortBy> thenByUpdateTimeDesc() {
    return addSortByInternal('updateTime', Sort.desc);
  }
}

extension VaultModelQueryWhereDistinct
    on QueryBuilder<VaultModel, VaultModel, QDistinct> {
  QueryBuilder<VaultModel, VaultModel, QDistinct> distinctByAccessTime() {
    return addDistinctByInternal('accessTime');
  }

  QueryBuilder<VaultModel, VaultModel, QDistinct> distinctByCreationTime() {
    return addDistinctByInternal('creationTime');
  }

  QueryBuilder<VaultModel, VaultModel, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<VaultModel, VaultModel, QDistinct> distinctByKey(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('key', caseSensitive: caseSensitive);
  }

  QueryBuilder<VaultModel, VaultModel, QDistinct> distinctByUpdateTime() {
    return addDistinctByInternal('updateTime');
  }
}

extension VaultModelQueryProperty
    on QueryBuilder<VaultModel, VaultModel, QQueryProperty> {
  QueryBuilder<VaultModel, DateTime?, QQueryOperations> accessTimeProperty() {
    return addPropertyNameInternal('accessTime');
  }

  QueryBuilder<VaultModel, DateTime, QQueryOperations> creationTimeProperty() {
    return addPropertyNameInternal('creationTime');
  }

  QueryBuilder<VaultModel, int?, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<VaultModel, String, QQueryOperations> keyProperty() {
    return addPropertyNameInternal('key');
  }

  QueryBuilder<VaultModel, DateTime?, QQueryOperations> updateTimeProperty() {
    return addPropertyNameInternal('updateTime');
  }

  QueryBuilder<VaultModel, Uint8List, QQueryOperations> valueProperty() {
    return addPropertyNameInternal('value');
  }
}
