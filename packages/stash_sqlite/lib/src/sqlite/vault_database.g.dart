// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vault_database.dart';

// ignore_for_file: type=lint
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
  const VaultData(
      {required this.name,
      required this.key,
      required this.creationTime,
      required this.accessTime,
      required this.updateTime,
      required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['name'] = Variable<String>(name);
    map['key'] = Variable<String>(key);
    {
      final converter = $VaultTableTable.$convertercreationTime;
      map['creation_time'] = Variable<String>(converter.toSql(creationTime));
    }
    {
      final converter = $VaultTableTable.$converteraccessTime;
      map['access_time'] = Variable<String>(converter.toSql(accessTime));
    }
    {
      final converter = $VaultTableTable.$converterupdateTime;
      map['update_time'] = Variable<String>(converter.toSql(updateTime));
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
    serializer ??= driftRuntimeOptions.defaultSerializer;
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
    serializer ??= driftRuntimeOptions.defaultSerializer;
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
  int get hashCode => Object.hash(name, key, creationTime, accessTime,
      updateTime, $driftBlobEquality.hash(value));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VaultData &&
          other.name == this.name &&
          other.key == this.key &&
          other.creationTime == this.creationTime &&
          other.accessTime == this.accessTime &&
          other.updateTime == this.updateTime &&
          $driftBlobEquality.equals(other.value, this.value));
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
    Expression<String>? creationTime,
    Expression<String>? accessTime,
    Expression<String>? updateTime,
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
      final converter = $VaultTableTable.$convertercreationTime;
      map['creation_time'] =
          Variable<String>(converter.toSql(creationTime.value));
    }
    if (accessTime.present) {
      final converter = $VaultTableTable.$converteraccessTime;
      map['access_time'] = Variable<String>(converter.toSql(accessTime.value));
    }
    if (updateTime.present) {
      final converter = $VaultTableTable.$converterupdateTime;
      map['update_time'] = Variable<String>(converter.toSql(updateTime.value));
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
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VaultTableTable(this.attachedDatabase, [this._alias]);
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
          .withConverter<DateTime>($VaultTableTable.$convertercreationTime);
  static const VerificationMeta _accessTimeMeta =
      const VerificationMeta('accessTime');
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, String> accessTime =
      GeneratedColumn<String>('access_time', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<DateTime>($VaultTableTable.$converteraccessTime);
  static const VerificationMeta _updateTimeMeta =
      const VerificationMeta('updateTime');
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, String> updateTime =
      GeneratedColumn<String>('update_time', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<DateTime>($VaultTableTable.$converterupdateTime);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<Uint8List> value = GeneratedColumn<Uint8List>(
      'value', aliasedName, false,
      type: DriftSqlType.blob, requiredDuringInsert: true);
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
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VaultData(
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      creationTime: $VaultTableTable.$convertercreationTime.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}creation_time'])!),
      accessTime: $VaultTableTable.$converteraccessTime.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}access_time'])!),
      updateTime: $VaultTableTable.$converterupdateTime.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}update_time'])!),
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.blob, data['${effectivePrefix}value'])!,
    );
  }

  @override
  $VaultTableTable createAlias(String alias) {
    return $VaultTableTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, String> $convertercreationTime =
      const Iso8601Converter();
  static TypeConverter<DateTime, String> $converteraccessTime =
      const Iso8601Converter();
  static TypeConverter<DateTime, String> $converterupdateTime =
      const Iso8601Converter();
}

abstract class _$VaultDatabase extends GeneratedDatabase {
  _$VaultDatabase(QueryExecutor e) : super(e);
  late final $VaultTableTable vaultTable = $VaultTableTable(this);
  late final VaultDao vaultDao = VaultDao(this as VaultDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [vaultTable];
}
