// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vault_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class VaultData extends DataClass implements Insertable<VaultData> {
  /// Returns a [TextColumn] for the name
  final String name;

  /// Returns a [TextColumn] for the key
  final String key;

  /// Returns a [TextColumn] that stores the creation time with a String format through the [Iso8601Converter]
  final DateTime creationTime;

  /// Returns a [TextColumn] that stores the access time with a String format through the [Iso8601Converter]
  final DateTime accessTime;

  /// Returns a [TextColumn] that stores the update time with a String format through the [Iso8601Converter]
  final DateTime updateTime;

  /// Returns a [BlobColumn] to store the value field
  final Uint8List value;
  VaultData(
      {required this.name,
      required this.key,
      required this.creationTime,
      required this.accessTime,
      required this.updateTime,
      required this.value});
  factory VaultData.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return VaultData(
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      key: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}key'])!,
      creationTime: $VaultTableTable.$converter0.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}creation_time']))!,
      accessTime: $VaultTableTable.$converter1.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}access_time']))!,
      updateTime: $VaultTableTable.$converter2.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}update_time']))!,
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
      final converter = $VaultTableTable.$converter0;
      map['creation_time'] =
          Variable<String>(converter.mapToSql(creationTime)!);
    }
    {
      final converter = $VaultTableTable.$converter1;
      map['access_time'] = Variable<String>(converter.mapToSql(accessTime)!);
    }
    {
      final converter = $VaultTableTable.$converter2;
      map['update_time'] = Variable<String>(converter.mapToSql(updateTime)!);
    }
    map['value'] = Variable<Uint8List>(value);
    return map;
  }

  VaultTableCompanion toCompanion(bool nullToAbsent) {
    return VaultTableCompanion(
      name: Value(name),
      key: Value(key),
      creationTime: Value(creationTime),
      accessTime: Value(accessTime),
      updateTime: Value(updateTime),
      value: Value(value),
    );
  }

  factory VaultData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return VaultData(
      name: serializer.fromJson<String>(json['name']),
      key: serializer.fromJson<String>(json['key']),
      creationTime: serializer.fromJson<DateTime>(json['creationTime']),
      accessTime: serializer.fromJson<DateTime>(json['accessTime']),
      updateTime: serializer.fromJson<DateTime>(json['updateTime']),
      value: serializer.fromJson<Uint8List>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'name': serializer.toJson<String>(name),
      'key': serializer.toJson<String>(key),
      'creationTime': serializer.toJson<DateTime>(creationTime),
      'accessTime': serializer.toJson<DateTime>(accessTime),
      'updateTime': serializer.toJson<DateTime>(updateTime),
      'value': serializer.toJson<Uint8List>(value),
    };
  }

  VaultData copyWith(
          {String? name,
          String? key,
          DateTime? creationTime,
          DateTime? accessTime,
          DateTime? updateTime,
          Uint8List? value}) =>
      VaultData(
        name: name ?? this.name,
        key: key ?? this.key,
        creationTime: creationTime ?? this.creationTime,
        accessTime: accessTime ?? this.accessTime,
        updateTime: updateTime ?? this.updateTime,
        value: value ?? this.value,
      );
  @override
  String toString() {
    return (StringBuffer('VaultData(')
          ..write('name: $name, ')
          ..write('key: $key, ')
          ..write('creationTime: $creationTime, ')
          ..write('accessTime: $accessTime, ')
          ..write('updateTime: $updateTime, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(name, key, creationTime, accessTime, updateTime, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VaultData &&
          other.name == this.name &&
          other.key == this.key &&
          other.creationTime == this.creationTime &&
          other.accessTime == this.accessTime &&
          other.updateTime == this.updateTime &&
          other.value == this.value);
}

class VaultTableCompanion extends UpdateCompanion<VaultData> {
  final Value<String> name;
  final Value<String> key;
  final Value<DateTime> creationTime;
  final Value<DateTime> accessTime;
  final Value<DateTime> updateTime;
  final Value<Uint8List> value;
  const VaultTableCompanion({
    this.name = const Value.absent(),
    this.key = const Value.absent(),
    this.creationTime = const Value.absent(),
    this.accessTime = const Value.absent(),
    this.updateTime = const Value.absent(),
    this.value = const Value.absent(),
  });
  VaultTableCompanion.insert({
    required String name,
    required String key,
    required DateTime creationTime,
    required DateTime accessTime,
    required DateTime updateTime,
    required Uint8List value,
  })  : name = Value(name),
        key = Value(key),
        creationTime = Value(creationTime),
        accessTime = Value(accessTime),
        updateTime = Value(updateTime),
        value = Value(value);
  static Insertable<VaultData> custom({
    Expression<String>? name,
    Expression<String>? key,
    Expression<DateTime>? creationTime,
    Expression<DateTime>? accessTime,
    Expression<DateTime>? updateTime,
    Expression<Uint8List>? value,
  }) {
    return RawValuesInsertable({
      if (name != null) 'name': name,
      if (key != null) 'key': key,
      if (creationTime != null) 'creation_time': creationTime,
      if (accessTime != null) 'access_time': accessTime,
      if (updateTime != null) 'update_time': updateTime,
      if (value != null) 'value': value,
    });
  }

  VaultTableCompanion copyWith(
      {Value<String>? name,
      Value<String>? key,
      Value<DateTime>? creationTime,
      Value<DateTime>? accessTime,
      Value<DateTime>? updateTime,
      Value<Uint8List>? value}) {
    return VaultTableCompanion(
      name: name ?? this.name,
      key: key ?? this.key,
      creationTime: creationTime ?? this.creationTime,
      accessTime: accessTime ?? this.accessTime,
      updateTime: updateTime ?? this.updateTime,
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
    if (creationTime.present) {
      final converter = $VaultTableTable.$converter0;
      map['creation_time'] =
          Variable<String>(converter.mapToSql(creationTime.value)!);
    }
    if (accessTime.present) {
      final converter = $VaultTableTable.$converter1;
      map['access_time'] =
          Variable<String>(converter.mapToSql(accessTime.value)!);
    }
    if (updateTime.present) {
      final converter = $VaultTableTable.$converter2;
      map['update_time'] =
          Variable<String>(converter.mapToSql(updateTime.value)!);
    }
    if (value.present) {
      map['value'] = Variable<Uint8List>(value.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VaultTableCompanion(')
          ..write('name: $name, ')
          ..write('key: $key, ')
          ..write('creationTime: $creationTime, ')
          ..write('accessTime: $accessTime, ')
          ..write('updateTime: $updateTime, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }
}

class $VaultTableTable extends VaultTable
    with TableInfo<$VaultTableTable, VaultData> {
  final GeneratedDatabase _db;
  final String? _alias;
  $VaultTableTable(this._db, [this._alias]);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _keyMeta = const VerificationMeta('key');
  late final GeneratedColumn<String?> key = GeneratedColumn<String?>(
      'key', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _creationTimeMeta =
      const VerificationMeta('creationTime');
  late final GeneratedColumnWithTypeConverter<DateTime, String?> creationTime =
      GeneratedColumn<String?>('creation_time', aliasedName, false,
              typeName: 'TEXT', requiredDuringInsert: true)
          .withConverter<DateTime>($VaultTableTable.$converter0);
  final VerificationMeta _accessTimeMeta = const VerificationMeta('accessTime');
  late final GeneratedColumnWithTypeConverter<DateTime, String?> accessTime =
      GeneratedColumn<String?>('access_time', aliasedName, false,
              typeName: 'TEXT', requiredDuringInsert: true)
          .withConverter<DateTime>($VaultTableTable.$converter1);
  final VerificationMeta _updateTimeMeta = const VerificationMeta('updateTime');
  late final GeneratedColumnWithTypeConverter<DateTime, String?> updateTime =
      GeneratedColumn<String?>('update_time', aliasedName, false,
              typeName: 'TEXT', requiredDuringInsert: true)
          .withConverter<DateTime>($VaultTableTable.$converter2);
  final VerificationMeta _valueMeta = const VerificationMeta('value');
  late final GeneratedColumn<Uint8List?> value = GeneratedColumn<Uint8List?>(
      'value', aliasedName, false,
      typeName: 'BLOB', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [name, key, creationTime, accessTime, updateTime, value];
  @override
  String get aliasedName => _alias ?? 'Vault';
  @override
  String get actualTableName => 'Vault';
  @override
  VerificationContext validateIntegrity(Insertable<VaultData> instance,
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
    context.handle(_accessTimeMeta, const VerificationResult.success());
    context.handle(_updateTimeMeta, const VerificationResult.success());
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
  VaultData map(Map<String, dynamic> data, {String? tablePrefix}) {
    return VaultData.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $VaultTableTable createAlias(String alias) {
    return $VaultTableTable(_db, alias);
  }

  static TypeConverter<DateTime, String> $converter0 = const Iso8601Converter();
  static TypeConverter<DateTime, String> $converter1 = const Iso8601Converter();
  static TypeConverter<DateTime, String> $converter2 = const Iso8601Converter();
}

abstract class _$VaultDatabase extends GeneratedDatabase {
  _$VaultDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $VaultTableTable vaultTable = $VaultTableTable(this);
  late final VaultDao vaultDao = VaultDao(this as VaultDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [vaultTable];
}
