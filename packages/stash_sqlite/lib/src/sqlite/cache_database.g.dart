// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_database.dart';

// ignore_for_file: type=lint
class $CacheTableTable extends CacheTable
    with TableInfo<$CacheTableTable, CacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CacheTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _creationTimeMeta =
      const VerificationMeta('creationTime');
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, String> creationTime =
      GeneratedColumn<String>('creation_time', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<DateTime>($CacheTableTable.$convertercreationTime);
  static const VerificationMeta _expiryTimeMeta =
      const VerificationMeta('expiryTime');
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, String> expiryTime =
      GeneratedColumn<String>('expiry_time', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<DateTime>($CacheTableTable.$converterexpiryTime);
  static const VerificationMeta _accessTimeMeta =
      const VerificationMeta('accessTime');
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, String> accessTime =
      GeneratedColumn<String>('access_time', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<DateTime>($CacheTableTable.$converteraccessTime);
  static const VerificationMeta _updateTimeMeta =
      const VerificationMeta('updateTime');
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, String> updateTime =
      GeneratedColumn<String>('update_time', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<DateTime>($CacheTableTable.$converterupdateTime);
  static const VerificationMeta _hitCountMeta =
      const VerificationMeta('hitCount');
  @override
  late final GeneratedColumn<int> hitCount = GeneratedColumn<int>(
      'hit_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<Uint8List> value = GeneratedColumn<Uint8List>(
      'value', aliasedName, false,
      type: DriftSqlType.blob, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        name,
        key,
        creationTime,
        expiryTime,
        accessTime,
        updateTime,
        hitCount,
        value
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'Cache';
  @override
  VerificationContext validateIntegrity(Insertable<CacheData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    context.handle(_creationTimeMeta, const VerificationResult.success());
    context.handle(_expiryTimeMeta, const VerificationResult.success());
    context.handle(_accessTimeMeta, const VerificationResult.success());
    context.handle(_updateTimeMeta, const VerificationResult.success());
    if (data.containsKey('hit_count')) {
      context.handle(_hitCountMeta,
          hitCount.isAcceptableOrUnknown(data['hit_count']!, _hitCountMeta));
    } else if (isInserting) {
      context.missing(_hitCountMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {name, key};
  @override
  CacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CacheData(
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      creationTime: $CacheTableTable.$convertercreationTime.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}creation_time'])!),
      expiryTime: $CacheTableTable.$converterexpiryTime.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}expiry_time'])!),
      accessTime: $CacheTableTable.$converteraccessTime.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}access_time'])!),
      updateTime: $CacheTableTable.$converterupdateTime.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}update_time'])!),
      hitCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}hit_count'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.blob, data['${effectivePrefix}value'])!,
    );
  }

  @override
  $CacheTableTable createAlias(String alias) {
    return $CacheTableTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, String> $convertercreationTime =
      const Iso8601Converter();
  static TypeConverter<DateTime, String> $converterexpiryTime =
      const Iso8601Converter();
  static TypeConverter<DateTime, String> $converteraccessTime =
      const Iso8601Converter();
  static TypeConverter<DateTime, String> $converterupdateTime =
      const Iso8601Converter();
}

class CacheData extends DataClass implements Insertable<CacheData> {
  /// Returns a [TextColumn] for the name
  final String name;

  /// Returns a [TextColumn] for the key
  final String key;

  /// Returns a [TextColumn] that stores the creation time with a String format through the [Iso8601Converter]
  final DateTime creationTime;

  /// Returns a [TextColumn] that stores the expiry time with a String format through the [Iso8601Converter]
  final DateTime expiryTime;

  /// Returns a [TextColumn] that stores the access time with a String format through the [Iso8601Converter]
  final DateTime accessTime;

  /// Returns a [TextColumn] that stores the update time with a String format through the [Iso8601Converter]
  final DateTime updateTime;

  /// Returns a [IntColumn] for the hit count
  final int hitCount;

  /// Returns a [BlobColumn] to store the value field
  final Uint8List value;
  const CacheData(
      {required this.name,
      required this.key,
      required this.creationTime,
      required this.expiryTime,
      required this.accessTime,
      required this.updateTime,
      required this.hitCount,
      required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['name'] = Variable<String>(name);
    map['key'] = Variable<String>(key);
    {
      final converter = $CacheTableTable.$convertercreationTime;
      map['creation_time'] = Variable<String>(converter.toSql(creationTime));
    }
    {
      final converter = $CacheTableTable.$converterexpiryTime;
      map['expiry_time'] = Variable<String>(converter.toSql(expiryTime));
    }
    {
      final converter = $CacheTableTable.$converteraccessTime;
      map['access_time'] = Variable<String>(converter.toSql(accessTime));
    }
    {
      final converter = $CacheTableTable.$converterupdateTime;
      map['update_time'] = Variable<String>(converter.toSql(updateTime));
    }
    map['hit_count'] = Variable<int>(hitCount);
    map['value'] = Variable<Uint8List>(value);
    return map;
  }

  CacheTableCompanion toCompanion(bool nullToAbsent) {
    return CacheTableCompanion(
      name: Value(name),
      key: Value(key),
      creationTime: Value(creationTime),
      expiryTime: Value(expiryTime),
      accessTime: Value(accessTime),
      updateTime: Value(updateTime),
      hitCount: Value(hitCount),
      value: Value(value),
    );
  }

  factory CacheData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CacheData(
      name: serializer.fromJson<String>(json['name']),
      key: serializer.fromJson<String>(json['key']),
      creationTime: serializer.fromJson<DateTime>(json['creationTime']),
      expiryTime: serializer.fromJson<DateTime>(json['expiryTime']),
      accessTime: serializer.fromJson<DateTime>(json['accessTime']),
      updateTime: serializer.fromJson<DateTime>(json['updateTime']),
      hitCount: serializer.fromJson<int>(json['hitCount']),
      value: serializer.fromJson<Uint8List>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'name': serializer.toJson<String>(name),
      'key': serializer.toJson<String>(key),
      'creationTime': serializer.toJson<DateTime>(creationTime),
      'expiryTime': serializer.toJson<DateTime>(expiryTime),
      'accessTime': serializer.toJson<DateTime>(accessTime),
      'updateTime': serializer.toJson<DateTime>(updateTime),
      'hitCount': serializer.toJson<int>(hitCount),
      'value': serializer.toJson<Uint8List>(value),
    };
  }

  CacheData copyWith(
          {String? name,
          String? key,
          DateTime? creationTime,
          DateTime? expiryTime,
          DateTime? accessTime,
          DateTime? updateTime,
          int? hitCount,
          Uint8List? value}) =>
      CacheData(
        name: name ?? this.name,
        key: key ?? this.key,
        creationTime: creationTime ?? this.creationTime,
        expiryTime: expiryTime ?? this.expiryTime,
        accessTime: accessTime ?? this.accessTime,
        updateTime: updateTime ?? this.updateTime,
        hitCount: hitCount ?? this.hitCount,
        value: value ?? this.value,
      );
  @override
  String toString() {
    return (StringBuffer('CacheData(')
          ..write('name: $name, ')
          ..write('key: $key, ')
          ..write('creationTime: $creationTime, ')
          ..write('expiryTime: $expiryTime, ')
          ..write('accessTime: $accessTime, ')
          ..write('updateTime: $updateTime, ')
          ..write('hitCount: $hitCount, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(name, key, creationTime, expiryTime,
      accessTime, updateTime, hitCount, $driftBlobEquality.hash(value));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CacheData &&
          other.name == this.name &&
          other.key == this.key &&
          other.creationTime == this.creationTime &&
          other.expiryTime == this.expiryTime &&
          other.accessTime == this.accessTime &&
          other.updateTime == this.updateTime &&
          other.hitCount == this.hitCount &&
          $driftBlobEquality.equals(other.value, this.value));
}

class CacheTableCompanion extends UpdateCompanion<CacheData> {
  final Value<String> name;
  final Value<String> key;
  final Value<DateTime> creationTime;
  final Value<DateTime> expiryTime;
  final Value<DateTime> accessTime;
  final Value<DateTime> updateTime;
  final Value<int> hitCount;
  final Value<Uint8List> value;
  final Value<int> rowid;
  const CacheTableCompanion({
    this.name = const Value.absent(),
    this.key = const Value.absent(),
    this.creationTime = const Value.absent(),
    this.expiryTime = const Value.absent(),
    this.accessTime = const Value.absent(),
    this.updateTime = const Value.absent(),
    this.hitCount = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CacheTableCompanion.insert({
    required String name,
    required String key,
    required DateTime creationTime,
    required DateTime expiryTime,
    required DateTime accessTime,
    required DateTime updateTime,
    required int hitCount,
    required Uint8List value,
    this.rowid = const Value.absent(),
  })  : name = Value(name),
        key = Value(key),
        creationTime = Value(creationTime),
        expiryTime = Value(expiryTime),
        accessTime = Value(accessTime),
        updateTime = Value(updateTime),
        hitCount = Value(hitCount),
        value = Value(value);
  static Insertable<CacheData> custom({
    Expression<String>? name,
    Expression<String>? key,
    Expression<String>? creationTime,
    Expression<String>? expiryTime,
    Expression<String>? accessTime,
    Expression<String>? updateTime,
    Expression<int>? hitCount,
    Expression<Uint8List>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (name != null) 'name': name,
      if (key != null) 'key': key,
      if (creationTime != null) 'creation_time': creationTime,
      if (expiryTime != null) 'expiry_time': expiryTime,
      if (accessTime != null) 'access_time': accessTime,
      if (updateTime != null) 'update_time': updateTime,
      if (hitCount != null) 'hit_count': hitCount,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CacheTableCompanion copyWith(
      {Value<String>? name,
      Value<String>? key,
      Value<DateTime>? creationTime,
      Value<DateTime>? expiryTime,
      Value<DateTime>? accessTime,
      Value<DateTime>? updateTime,
      Value<int>? hitCount,
      Value<Uint8List>? value,
      Value<int>? rowid}) {
    return CacheTableCompanion(
      name: name ?? this.name,
      key: key ?? this.key,
      creationTime: creationTime ?? this.creationTime,
      expiryTime: expiryTime ?? this.expiryTime,
      accessTime: accessTime ?? this.accessTime,
      updateTime: updateTime ?? this.updateTime,
      hitCount: hitCount ?? this.hitCount,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (creationTime.present) {
      final converter = $CacheTableTable.$convertercreationTime;
      map['creation_time'] =
          Variable<String>(converter.toSql(creationTime.value));
    }
    if (expiryTime.present) {
      final converter = $CacheTableTable.$converterexpiryTime;
      map['expiry_time'] = Variable<String>(converter.toSql(expiryTime.value));
    }
    if (accessTime.present) {
      final converter = $CacheTableTable.$converteraccessTime;
      map['access_time'] = Variable<String>(converter.toSql(accessTime.value));
    }
    if (updateTime.present) {
      final converter = $CacheTableTable.$converterupdateTime;
      map['update_time'] = Variable<String>(converter.toSql(updateTime.value));
    }
    if (hitCount.present) {
      map['hit_count'] = Variable<int>(hitCount.value);
    }
    if (value.present) {
      map['value'] = Variable<Uint8List>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CacheTableCompanion(')
          ..write('name: $name, ')
          ..write('key: $key, ')
          ..write('creationTime: $creationTime, ')
          ..write('expiryTime: $expiryTime, ')
          ..write('accessTime: $accessTime, ')
          ..write('updateTime: $updateTime, ')
          ..write('hitCount: $hitCount, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$CacheDatabase extends GeneratedDatabase {
  _$CacheDatabase(QueryExecutor e) : super(e);
  late final $CacheTableTable cacheTable = $CacheTableTable(this);
  late final CacheDao cacheDao = CacheDao(this as CacheDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [cacheTable];
}
