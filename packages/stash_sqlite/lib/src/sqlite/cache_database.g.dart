// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class CacheData extends DataClass implements Insertable<CacheData> {
  /// Returns a [TextColumn] for the name
  final String name;

  /// Returns a [TextColumn] for the key
  final String key;

  /// Returns a [TextColumn] that stores the expiry time with a String format through the [Iso8601Converter]
  final DateTime expiryTime;

  /// Returns a [TextColumn] that stores the creation time with a String format through the [Iso8601Converter]
  final DateTime creationTime;

  /// Returns a [TextColumn] that stores the access time with a String format through the [Iso8601Converter]
  final DateTime accessTime;

  /// Returns a [TextColumn] that stores the update time with a String format through the [Iso8601Converter]
  final DateTime updateTime;

  /// Returns a [IntColumn] for the hit count
  final int hitCount;

  /// Returns a [BlobColumn] to store the extra field
  final Uint8List? extra;

  /// Returns a [BlobColumn] to store the value field
  final Uint8List value;
  CacheData(
      {required this.name,
      required this.key,
      required this.expiryTime,
      required this.creationTime,
      required this.accessTime,
      required this.updateTime,
      required this.hitCount,
      this.extra,
      required this.value});
  factory CacheData.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return CacheData(
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      key: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}key'])!,
      expiryTime: $CacheTableTable.$converter0.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}expiry_time']))!,
      creationTime: $CacheTableTable.$converter1.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}creation_time']))!,
      accessTime: $CacheTableTable.$converter2.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}access_time']))!,
      updateTime: $CacheTableTable.$converter3.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}update_time']))!,
      hitCount: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}hit_count'])!,
      extra: const BlobType()
          .mapFromDatabaseResponse(data['${effectivePrefix}extra']),
      value: const BlobType()
          .mapFromDatabaseResponse(data['${effectivePrefix}value'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['name'] = Variable<String>(name);
    map['key'] = Variable<String>(key);
    {
      final converter = $CacheTableTable.$converter0;
      map['expiry_time'] = Variable<String>(converter.mapToSql(expiryTime)!);
    }
    {
      final converter = $CacheTableTable.$converter1;
      map['creation_time'] =
          Variable<String>(converter.mapToSql(creationTime)!);
    }
    {
      final converter = $CacheTableTable.$converter2;
      map['access_time'] = Variable<String>(converter.mapToSql(accessTime)!);
    }
    {
      final converter = $CacheTableTable.$converter3;
      map['update_time'] = Variable<String>(converter.mapToSql(updateTime)!);
    }
    map['hit_count'] = Variable<int>(hitCount);
    if (!nullToAbsent || extra != null) {
      map['extra'] = Variable<Uint8List?>(extra);
    }
    map['value'] = Variable<Uint8List>(value);
    return map;
  }

  CacheTableCompanion toCompanion(bool nullToAbsent) {
    return CacheTableCompanion(
      name: Value(name),
      key: Value(key),
      expiryTime: Value(expiryTime),
      creationTime: Value(creationTime),
      accessTime: Value(accessTime),
      updateTime: Value(updateTime),
      hitCount: Value(hitCount),
      extra:
          extra == null && nullToAbsent ? const Value.absent() : Value(extra),
      value: Value(value),
    );
  }

  factory CacheData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return CacheData(
      name: serializer.fromJson<String>(json['name']),
      key: serializer.fromJson<String>(json['key']),
      expiryTime: serializer.fromJson<DateTime>(json['expiryTime']),
      creationTime: serializer.fromJson<DateTime>(json['creationTime']),
      accessTime: serializer.fromJson<DateTime>(json['accessTime']),
      updateTime: serializer.fromJson<DateTime>(json['updateTime']),
      hitCount: serializer.fromJson<int>(json['hitCount']),
      extra: serializer.fromJson<Uint8List?>(json['extra']),
      value: serializer.fromJson<Uint8List>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'name': serializer.toJson<String>(name),
      'key': serializer.toJson<String>(key),
      'expiryTime': serializer.toJson<DateTime>(expiryTime),
      'creationTime': serializer.toJson<DateTime>(creationTime),
      'accessTime': serializer.toJson<DateTime>(accessTime),
      'updateTime': serializer.toJson<DateTime>(updateTime),
      'hitCount': serializer.toJson<int>(hitCount),
      'extra': serializer.toJson<Uint8List?>(extra),
      'value': serializer.toJson<Uint8List>(value),
    };
  }

  CacheData copyWith(
          {String? name,
          String? key,
          DateTime? expiryTime,
          DateTime? creationTime,
          DateTime? accessTime,
          DateTime? updateTime,
          int? hitCount,
          Uint8List? extra,
          Uint8List? value}) =>
      CacheData(
        name: name ?? this.name,
        key: key ?? this.key,
        expiryTime: expiryTime ?? this.expiryTime,
        creationTime: creationTime ?? this.creationTime,
        accessTime: accessTime ?? this.accessTime,
        updateTime: updateTime ?? this.updateTime,
        hitCount: hitCount ?? this.hitCount,
        extra: extra ?? this.extra,
        value: value ?? this.value,
      );
  @override
  String toString() {
    return (StringBuffer('CacheData(')
          ..write('name: $name, ')
          ..write('key: $key, ')
          ..write('expiryTime: $expiryTime, ')
          ..write('creationTime: $creationTime, ')
          ..write('accessTime: $accessTime, ')
          ..write('updateTime: $updateTime, ')
          ..write('hitCount: $hitCount, ')
          ..write('extra: $extra, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      name.hashCode,
      $mrjc(
          key.hashCode,
          $mrjc(
              expiryTime.hashCode,
              $mrjc(
                  creationTime.hashCode,
                  $mrjc(
                      accessTime.hashCode,
                      $mrjc(
                          updateTime.hashCode,
                          $mrjc(hitCount.hashCode,
                              $mrjc(extra.hashCode, value.hashCode)))))))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CacheData &&
          other.name == this.name &&
          other.key == this.key &&
          other.expiryTime == this.expiryTime &&
          other.creationTime == this.creationTime &&
          other.accessTime == this.accessTime &&
          other.updateTime == this.updateTime &&
          other.hitCount == this.hitCount &&
          other.extra == this.extra &&
          other.value == this.value);
}

class CacheTableCompanion extends UpdateCompanion<CacheData> {
  final Value<String> name;
  final Value<String> key;
  final Value<DateTime> expiryTime;
  final Value<DateTime> creationTime;
  final Value<DateTime> accessTime;
  final Value<DateTime> updateTime;
  final Value<int> hitCount;
  final Value<Uint8List?> extra;
  final Value<Uint8List> value;
  const CacheTableCompanion({
    this.name = const Value.absent(),
    this.key = const Value.absent(),
    this.expiryTime = const Value.absent(),
    this.creationTime = const Value.absent(),
    this.accessTime = const Value.absent(),
    this.updateTime = const Value.absent(),
    this.hitCount = const Value.absent(),
    this.extra = const Value.absent(),
    this.value = const Value.absent(),
  });
  CacheTableCompanion.insert({
    required String name,
    required String key,
    required DateTime expiryTime,
    required DateTime creationTime,
    required DateTime accessTime,
    required DateTime updateTime,
    required int hitCount,
    this.extra = const Value.absent(),
    required Uint8List value,
  })  : name = Value(name),
        key = Value(key),
        expiryTime = Value(expiryTime),
        creationTime = Value(creationTime),
        accessTime = Value(accessTime),
        updateTime = Value(updateTime),
        hitCount = Value(hitCount),
        value = Value(value);
  static Insertable<CacheData> custom({
    Expression<String>? name,
    Expression<String>? key,
    Expression<DateTime>? expiryTime,
    Expression<DateTime>? creationTime,
    Expression<DateTime>? accessTime,
    Expression<DateTime>? updateTime,
    Expression<int>? hitCount,
    Expression<Uint8List?>? extra,
    Expression<Uint8List>? value,
  }) {
    return RawValuesInsertable({
      if (name != null) 'name': name,
      if (key != null) 'key': key,
      if (expiryTime != null) 'expiry_time': expiryTime,
      if (creationTime != null) 'creation_time': creationTime,
      if (accessTime != null) 'access_time': accessTime,
      if (updateTime != null) 'update_time': updateTime,
      if (hitCount != null) 'hit_count': hitCount,
      if (extra != null) 'extra': extra,
      if (value != null) 'value': value,
    });
  }

  CacheTableCompanion copyWith(
      {Value<String>? name,
      Value<String>? key,
      Value<DateTime>? expiryTime,
      Value<DateTime>? creationTime,
      Value<DateTime>? accessTime,
      Value<DateTime>? updateTime,
      Value<int>? hitCount,
      Value<Uint8List?>? extra,
      Value<Uint8List>? value}) {
    return CacheTableCompanion(
      name: name ?? this.name,
      key: key ?? this.key,
      expiryTime: expiryTime ?? this.expiryTime,
      creationTime: creationTime ?? this.creationTime,
      accessTime: accessTime ?? this.accessTime,
      updateTime: updateTime ?? this.updateTime,
      hitCount: hitCount ?? this.hitCount,
      extra: extra ?? this.extra,
      value: value ?? this.value,
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
    if (expiryTime.present) {
      final converter = $CacheTableTable.$converter0;
      map['expiry_time'] =
          Variable<String>(converter.mapToSql(expiryTime.value)!);
    }
    if (creationTime.present) {
      final converter = $CacheTableTable.$converter1;
      map['creation_time'] =
          Variable<String>(converter.mapToSql(creationTime.value)!);
    }
    if (accessTime.present) {
      final converter = $CacheTableTable.$converter2;
      map['access_time'] =
          Variable<String>(converter.mapToSql(accessTime.value)!);
    }
    if (updateTime.present) {
      final converter = $CacheTableTable.$converter3;
      map['update_time'] =
          Variable<String>(converter.mapToSql(updateTime.value)!);
    }
    if (hitCount.present) {
      map['hit_count'] = Variable<int>(hitCount.value);
    }
    if (extra.present) {
      map['extra'] = Variable<Uint8List?>(extra.value);
    }
    if (value.present) {
      map['value'] = Variable<Uint8List>(value.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CacheTableCompanion(')
          ..write('name: $name, ')
          ..write('key: $key, ')
          ..write('expiryTime: $expiryTime, ')
          ..write('creationTime: $creationTime, ')
          ..write('accessTime: $accessTime, ')
          ..write('updateTime: $updateTime, ')
          ..write('hitCount: $hitCount, ')
          ..write('extra: $extra, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }
}

class $CacheTableTable extends CacheTable
    with TableInfo<$CacheTableTable, CacheData> {
  final GeneratedDatabase _db;
  final String? _alias;
  $CacheTableTable(this._db, [this._alias]);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedTextColumn name = _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedTextColumn key = _constructKey();
  GeneratedTextColumn _constructKey() {
    return GeneratedTextColumn(
      'key',
      $tableName,
      false,
    );
  }

  final VerificationMeta _expiryTimeMeta = const VerificationMeta('expiryTime');
  @override
  late final GeneratedTextColumn expiryTime = _constructExpiryTime();
  GeneratedTextColumn _constructExpiryTime() {
    return GeneratedTextColumn(
      'expiry_time',
      $tableName,
      false,
    );
  }

  final VerificationMeta _creationTimeMeta =
      const VerificationMeta('creationTime');
  @override
  late final GeneratedTextColumn creationTime = _constructCreationTime();
  GeneratedTextColumn _constructCreationTime() {
    return GeneratedTextColumn(
      'creation_time',
      $tableName,
      false,
    );
  }

  final VerificationMeta _accessTimeMeta = const VerificationMeta('accessTime');
  @override
  late final GeneratedTextColumn accessTime = _constructAccessTime();
  GeneratedTextColumn _constructAccessTime() {
    return GeneratedTextColumn(
      'access_time',
      $tableName,
      false,
    );
  }

  final VerificationMeta _updateTimeMeta = const VerificationMeta('updateTime');
  @override
  late final GeneratedTextColumn updateTime = _constructUpdateTime();
  GeneratedTextColumn _constructUpdateTime() {
    return GeneratedTextColumn(
      'update_time',
      $tableName,
      false,
    );
  }

  final VerificationMeta _hitCountMeta = const VerificationMeta('hitCount');
  @override
  late final GeneratedIntColumn hitCount = _constructHitCount();
  GeneratedIntColumn _constructHitCount() {
    return GeneratedIntColumn(
      'hit_count',
      $tableName,
      false,
    );
  }

  final VerificationMeta _extraMeta = const VerificationMeta('extra');
  @override
  late final GeneratedBlobColumn extra = _constructExtra();
  GeneratedBlobColumn _constructExtra() {
    return GeneratedBlobColumn(
      'extra',
      $tableName,
      true,
    );
  }

  final VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedBlobColumn value = _constructValue();
  GeneratedBlobColumn _constructValue() {
    return GeneratedBlobColumn(
      'value',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [
        name,
        key,
        expiryTime,
        creationTime,
        accessTime,
        updateTime,
        hitCount,
        extra,
        value
      ];
  @override
  $CacheTableTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'Cache';
  @override
  final String actualTableName = 'Cache';
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
    context.handle(_expiryTimeMeta, const VerificationResult.success());
    context.handle(_creationTimeMeta, const VerificationResult.success());
    context.handle(_accessTimeMeta, const VerificationResult.success());
    context.handle(_updateTimeMeta, const VerificationResult.success());
    if (data.containsKey('hit_count')) {
      context.handle(_hitCountMeta,
          hitCount.isAcceptableOrUnknown(data['hit_count']!, _hitCountMeta));
    } else if (isInserting) {
      context.missing(_hitCountMeta);
    }
    if (data.containsKey('extra')) {
      context.handle(
          _extraMeta, extra.isAcceptableOrUnknown(data['extra']!, _extraMeta));
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
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return CacheData.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $CacheTableTable createAlias(String alias) {
    return $CacheTableTable(_db, alias);
  }

  static TypeConverter<DateTime, String> $converter0 = const Iso8601Converter();
  static TypeConverter<DateTime, String> $converter1 = const Iso8601Converter();
  static TypeConverter<DateTime, String> $converter2 = const Iso8601Converter();
  static TypeConverter<DateTime, String> $converter3 = const Iso8601Converter();
}

abstract class _$CacheDatabase extends GeneratedDatabase {
  _$CacheDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $CacheTableTable cacheTable = $CacheTableTable(this);
  late final CacheDao cacheDao = CacheDao(this as CacheDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [cacheTable];
}
