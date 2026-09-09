// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CachedInterestsTable extends CachedInterests
    with TableInfo<$CachedInterestsTable, CachedInterest> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedInterestsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
    'slug',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, slug];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_interests';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedInterest> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('slug')) {
      context.handle(
        _slugMeta,
        slug.isAcceptableOrUnknown(data['slug']!, _slugMeta),
      );
    } else if (isInserting) {
      context.missing(_slugMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedInterest map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedInterest(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      slug: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}slug'],
      )!,
    );
  }

  @override
  $CachedInterestsTable createAlias(String alias) {
    return $CachedInterestsTable(attachedDatabase, alias);
  }
}

class CachedInterest extends DataClass implements Insertable<CachedInterest> {
  final int id;
  final String slug;
  const CachedInterest({required this.id, required this.slug});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['slug'] = Variable<String>(slug);
    return map;
  }

  CachedInterestsCompanion toCompanion(bool nullToAbsent) {
    return CachedInterestsCompanion(id: Value(id), slug: Value(slug));
  }

  factory CachedInterest.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedInterest(
      id: serializer.fromJson<int>(json['id']),
      slug: serializer.fromJson<String>(json['slug']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'slug': serializer.toJson<String>(slug),
    };
  }

  CachedInterest copyWith({int? id, String? slug}) =>
      CachedInterest(id: id ?? this.id, slug: slug ?? this.slug);
  CachedInterest copyWithCompanion(CachedInterestsCompanion data) {
    return CachedInterest(
      id: data.id.present ? data.id.value : this.id,
      slug: data.slug.present ? data.slug.value : this.slug,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedInterest(')
          ..write('id: $id, ')
          ..write('slug: $slug')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, slug);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedInterest &&
          other.id == this.id &&
          other.slug == this.slug);
}

class CachedInterestsCompanion extends UpdateCompanion<CachedInterest> {
  final Value<int> id;
  final Value<String> slug;
  const CachedInterestsCompanion({
    this.id = const Value.absent(),
    this.slug = const Value.absent(),
  });
  CachedInterestsCompanion.insert({
    this.id = const Value.absent(),
    required String slug,
  }) : slug = Value(slug);
  static Insertable<CachedInterest> custom({
    Expression<int>? id,
    Expression<String>? slug,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (slug != null) 'slug': slug,
    });
  }

  CachedInterestsCompanion copyWith({Value<int>? id, Value<String>? slug}) {
    return CachedInterestsCompanion(id: id ?? this.id, slug: slug ?? this.slug);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedInterestsCompanion(')
          ..write('id: $id, ')
          ..write('slug: $slug')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CachedInterestsTable cachedInterests = $CachedInterestsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [cachedInterests];
}

typedef $$CachedInterestsTableCreateCompanionBuilder =
    CachedInterestsCompanion Function({Value<int> id, required String slug});
typedef $$CachedInterestsTableUpdateCompanionBuilder =
    CachedInterestsCompanion Function({Value<int> id, Value<String> slug});

class $$CachedInterestsTableFilterComposer
    extends Composer<_$AppDatabase, $CachedInterestsTable> {
  $$CachedInterestsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedInterestsTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedInterestsTable> {
  $$CachedInterestsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedInterestsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedInterestsTable> {
  $$CachedInterestsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get slug =>
      $composableBuilder(column: $table.slug, builder: (column) => column);
}

class $$CachedInterestsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedInterestsTable,
          CachedInterest,
          $$CachedInterestsTableFilterComposer,
          $$CachedInterestsTableOrderingComposer,
          $$CachedInterestsTableAnnotationComposer,
          $$CachedInterestsTableCreateCompanionBuilder,
          $$CachedInterestsTableUpdateCompanionBuilder,
          (
            CachedInterest,
            BaseReferences<
              _$AppDatabase,
              $CachedInterestsTable,
              CachedInterest
            >,
          ),
          CachedInterest,
          PrefetchHooks Function()
        > {
  $$CachedInterestsTableTableManager(
    _$AppDatabase db,
    $CachedInterestsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedInterestsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedInterestsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedInterestsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> slug = const Value.absent(),
              }) => CachedInterestsCompanion(id: id, slug: slug),
          createCompanionCallback:
              ({Value<int> id = const Value.absent(), required String slug}) =>
                  CachedInterestsCompanion.insert(id: id, slug: slug),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedInterestsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedInterestsTable,
      CachedInterest,
      $$CachedInterestsTableFilterComposer,
      $$CachedInterestsTableOrderingComposer,
      $$CachedInterestsTableAnnotationComposer,
      $$CachedInterestsTableCreateCompanionBuilder,
      $$CachedInterestsTableUpdateCompanionBuilder,
      (
        CachedInterest,
        BaseReferences<_$AppDatabase, $CachedInterestsTable, CachedInterest>,
      ),
      CachedInterest,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CachedInterestsTableTableManager get cachedInterests =>
      $$CachedInterestsTableTableManager(_db, _db.cachedInterests);
}
