// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vault_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings

extension GetVaultModelCollection on Isar {
  IsarCollection<VaultModel> get vaultModels => getCollection();
}

const VaultModelSchema = CollectionSchema(
  name: r'Vault',
  schema:
      r'{"name":"Vault","idName":"id","properties":[{"name":"accessTime","type":"Long"},{"name":"creationTime","type":"Long"},{"name":"key","type":"String"},{"name":"updateTime","type":"Long"},{"name":"value","type":"ByteList"}],"indexes":[{"name":"key","unique":false,"replace":false,"properties":[{"name":"key","type":"Hash","caseSensitive":true}]}],"links":[]}',
  idName: r'id',
  propertyIds: {
    r'accessTime': 0,
    r'creationTime': 1,
    r'key': 2,
    r'updateTime': 3,
    r'value': 4
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

List<IsarLinkBase<dynamic>> _vaultModelGetLinks(VaultModel object) {
  return [];
}

void _vaultModelSerializeNative(
    IsarCollection<VaultModel> collection,
    IsarCObject cObj,
    VaultModel object,
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
  writer.writeBytes(offsets[2], key$Bytes);
  writer.writeDateTime(offsets[3], object.updateTime);
  writer.writeBytes(offsets[4], object.value);
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
      throw IsarError('Illegal propertyIndex');
  }
}

Object _vaultModelSerializeWeb(
    IsarCollection<VaultModel> collection, VaultModel object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(
      jsObj, r'accessTime', object.accessTime?.toUtc().millisecondsSinceEpoch);
  IsarNative.jsObjectSet(jsObj, r'creationTime',
      object.creationTime.toUtc().millisecondsSinceEpoch);
  IsarNative.jsObjectSet(jsObj, r'id', object.id);
  IsarNative.jsObjectSet(jsObj, r'key', object.key);
  IsarNative.jsObjectSet(
      jsObj, r'updateTime', object.updateTime?.toUtc().millisecondsSinceEpoch);
  IsarNative.jsObjectSet(jsObj, r'value', object.value);
  return jsObj;
}

VaultModel _vaultModelDeserializeWeb(
    IsarCollection<VaultModel> collection, Object jsObj) {
  final object = VaultModel();
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

P _vaultModelDeserializePropWeb<P>(Object jsObj, String propertyName) {
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

void _vaultModelAttachLinks(
    IsarCollection<dynamic> col, int id, VaultModel object) {}

extension VaultModelQueryWhereSort
    on QueryBuilder<VaultModel, VaultModel, QWhere> {
  QueryBuilder<VaultModel, VaultModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<VaultModel, VaultModel, QAfterWhere> anyKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'key'),
      );
    });
  }
}

extension VaultModelQueryWhere
    on QueryBuilder<VaultModel, VaultModel, QWhereClause> {
  QueryBuilder<VaultModel, VaultModel, QAfterWhereClause> idEqualTo(int id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<VaultModel, VaultModel, QAfterWhereClause> idNotEqualTo(int id) {
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

  QueryBuilder<VaultModel, VaultModel, QAfterWhereClause> idGreaterThan(int id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<VaultModel, VaultModel, QAfterWhereClause> idLessThan(int id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<VaultModel, VaultModel, QAfterWhereClause> idBetween(
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

  QueryBuilder<VaultModel, VaultModel, QAfterWhereClause> keyEqualTo(
      String key) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'key',
        value: [key],
      ));
    });
  }

  QueryBuilder<VaultModel, VaultModel, QAfterWhereClause> keyNotEqualTo(
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

extension VaultModelQueryFilter
    on QueryBuilder<VaultModel, VaultModel, QFilterCondition> {
  QueryBuilder<VaultModel, VaultModel, QAfterFilterCondition>
      accessTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'accessTime',
      ));
    });
  }

  QueryBuilder<VaultModel, VaultModel, QAfterFilterCondition> accessTimeEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'accessTime',
        value: value,
      ));
    });
  }

  QueryBuilder<VaultModel, VaultModel, QAfterFilterCondition>
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

  QueryBuilder<VaultModel, VaultModel, QAfterFilterCondition>
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

  QueryBuilder<VaultModel, VaultModel, QAfterFilterCondition> accessTimeBetween(
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

  QueryBuilder<VaultModel, VaultModel, QAfterFilterCondition>
      creationTimeEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'creationTime',
        value: value,
      ));
    });
  }

  QueryBuilder<VaultModel, VaultModel, QAfterFilterCondition>
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

  QueryBuilder<VaultModel, VaultModel, QAfterFilterCondition>
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

  QueryBuilder<VaultModel, VaultModel, QAfterFilterCondition>
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

  QueryBuilder<VaultModel, VaultModel, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<VaultModel, VaultModel, QAfterFilterCondition> idEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<VaultModel, VaultModel, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<VaultModel, VaultModel, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<VaultModel, VaultModel, QAfterFilterCondition> idBetween(
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

  QueryBuilder<VaultModel, VaultModel, QAfterFilterCondition> keyEqualTo(
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

  QueryBuilder<VaultModel, VaultModel, QAfterFilterCondition> keyGreaterThan(
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

  QueryBuilder<VaultModel, VaultModel, QAfterFilterCondition> keyLessThan(
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

  QueryBuilder<VaultModel, VaultModel, QAfterFilterCondition> keyBetween(
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

  QueryBuilder<VaultModel, VaultModel, QAfterFilterCondition> keyStartsWith(
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

  QueryBuilder<VaultModel, VaultModel, QAfterFilterCondition> keyEndsWith(
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

  QueryBuilder<VaultModel, VaultModel, QAfterFilterCondition> keyContains(
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

  QueryBuilder<VaultModel, VaultModel, QAfterFilterCondition> keyMatches(
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

  QueryBuilder<VaultModel, VaultModel, QAfterFilterCondition>
      updateTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'updateTime',
      ));
    });
  }

  QueryBuilder<VaultModel, VaultModel, QAfterFilterCondition> updateTimeEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<VaultModel, VaultModel, QAfterFilterCondition>
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

  QueryBuilder<VaultModel, VaultModel, QAfterFilterCondition>
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

  QueryBuilder<VaultModel, VaultModel, QAfterFilterCondition> updateTimeBetween(
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

extension VaultModelQueryLinks
    on QueryBuilder<VaultModel, VaultModel, QFilterCondition> {}

extension VaultModelQueryWhereSortBy
    on QueryBuilder<VaultModel, VaultModel, QSortBy> {
  QueryBuilder<VaultModel, VaultModel, QAfterSortBy> sortByAccessTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accessTime', Sort.asc);
    });
  }

  QueryBuilder<VaultModel, VaultModel, QAfterSortBy> sortByAccessTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accessTime', Sort.desc);
    });
  }

  QueryBuilder<VaultModel, VaultModel, QAfterSortBy> sortByCreationTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creationTime', Sort.asc);
    });
  }

  QueryBuilder<VaultModel, VaultModel, QAfterSortBy> sortByCreationTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creationTime', Sort.desc);
    });
  }

  QueryBuilder<VaultModel, VaultModel, QAfterSortBy> sortByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<VaultModel, VaultModel, QAfterSortBy> sortByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }

  QueryBuilder<VaultModel, VaultModel, QAfterSortBy> sortByUpdateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updateTime', Sort.asc);
    });
  }

  QueryBuilder<VaultModel, VaultModel, QAfterSortBy> sortByUpdateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updateTime', Sort.desc);
    });
  }
}

extension VaultModelQueryWhereSortThenBy
    on QueryBuilder<VaultModel, VaultModel, QSortThenBy> {
  QueryBuilder<VaultModel, VaultModel, QAfterSortBy> thenByAccessTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accessTime', Sort.asc);
    });
  }

  QueryBuilder<VaultModel, VaultModel, QAfterSortBy> thenByAccessTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accessTime', Sort.desc);
    });
  }

  QueryBuilder<VaultModel, VaultModel, QAfterSortBy> thenByCreationTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creationTime', Sort.asc);
    });
  }

  QueryBuilder<VaultModel, VaultModel, QAfterSortBy> thenByCreationTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creationTime', Sort.desc);
    });
  }

  QueryBuilder<VaultModel, VaultModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<VaultModel, VaultModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<VaultModel, VaultModel, QAfterSortBy> thenByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<VaultModel, VaultModel, QAfterSortBy> thenByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }

  QueryBuilder<VaultModel, VaultModel, QAfterSortBy> thenByUpdateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updateTime', Sort.asc);
    });
  }

  QueryBuilder<VaultModel, VaultModel, QAfterSortBy> thenByUpdateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updateTime', Sort.desc);
    });
  }
}

extension VaultModelQueryWhereDistinct
    on QueryBuilder<VaultModel, VaultModel, QDistinct> {
  QueryBuilder<VaultModel, VaultModel, QDistinct> distinctByAccessTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'accessTime');
    });
  }

  QueryBuilder<VaultModel, VaultModel, QDistinct> distinctByCreationTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'creationTime');
    });
  }

  QueryBuilder<VaultModel, VaultModel, QDistinct> distinctByKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'key', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VaultModel, VaultModel, QDistinct> distinctByUpdateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updateTime');
    });
  }

  QueryBuilder<VaultModel, VaultModel, QDistinct> distinctByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'value');
    });
  }
}

extension VaultModelQueryProperty
    on QueryBuilder<VaultModel, VaultModel, QQueryProperty> {
  QueryBuilder<VaultModel, DateTime?, QQueryOperations> accessTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'accessTime');
    });
  }

  QueryBuilder<VaultModel, DateTime, QQueryOperations> creationTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'creationTime');
    });
  }

  QueryBuilder<VaultModel, int?, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<VaultModel, String, QQueryOperations> keyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'key');
    });
  }

  QueryBuilder<VaultModel, DateTime?, QQueryOperations> updateTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updateTime');
    });
  }

  QueryBuilder<VaultModel, Uint8List, QQueryOperations> valueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'value');
    });
  }
}
