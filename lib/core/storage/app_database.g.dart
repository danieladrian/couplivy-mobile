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
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [id, slug, category];
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
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
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
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
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
  final String category;
  const CachedInterest({
    required this.id,
    required this.slug,
    required this.category,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['slug'] = Variable<String>(slug);
    map['category'] = Variable<String>(category);
    return map;
  }

  CachedInterestsCompanion toCompanion(bool nullToAbsent) {
    return CachedInterestsCompanion(
      id: Value(id),
      slug: Value(slug),
      category: Value(category),
    );
  }

  factory CachedInterest.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedInterest(
      id: serializer.fromJson<int>(json['id']),
      slug: serializer.fromJson<String>(json['slug']),
      category: serializer.fromJson<String>(json['category']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'slug': serializer.toJson<String>(slug),
      'category': serializer.toJson<String>(category),
    };
  }

  CachedInterest copyWith({int? id, String? slug, String? category}) =>
      CachedInterest(
        id: id ?? this.id,
        slug: slug ?? this.slug,
        category: category ?? this.category,
      );
  CachedInterest copyWithCompanion(CachedInterestsCompanion data) {
    return CachedInterest(
      id: data.id.present ? data.id.value : this.id,
      slug: data.slug.present ? data.slug.value : this.slug,
      category: data.category.present ? data.category.value : this.category,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedInterest(')
          ..write('id: $id, ')
          ..write('slug: $slug, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, slug, category);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedInterest &&
          other.id == this.id &&
          other.slug == this.slug &&
          other.category == this.category);
}

class CachedInterestsCompanion extends UpdateCompanion<CachedInterest> {
  final Value<int> id;
  final Value<String> slug;
  final Value<String> category;
  const CachedInterestsCompanion({
    this.id = const Value.absent(),
    this.slug = const Value.absent(),
    this.category = const Value.absent(),
  });
  CachedInterestsCompanion.insert({
    this.id = const Value.absent(),
    required String slug,
    this.category = const Value.absent(),
  }) : slug = Value(slug);
  static Insertable<CachedInterest> custom({
    Expression<int>? id,
    Expression<String>? slug,
    Expression<String>? category,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (slug != null) 'slug': slug,
      if (category != null) 'category': category,
    });
  }

  CachedInterestsCompanion copyWith({
    Value<int>? id,
    Value<String>? slug,
    Value<String>? category,
  }) {
    return CachedInterestsCompanion(
      id: id ?? this.id,
      slug: slug ?? this.slug,
      category: category ?? this.category,
    );
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
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedInterestsCompanion(')
          ..write('id: $id, ')
          ..write('slug: $slug, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }
}

class $ProfilesTable extends Profiles with TableInfo<$ProfilesTable, Profile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nickNameMeta = const VerificationMeta(
    'nickName',
  );
  @override
  late final GeneratedColumn<String> nickName = GeneratedColumn<String>(
    'nick_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fullNameMeta = const VerificationMeta(
    'fullName',
  );
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ageMeta = const VerificationMeta('age');
  @override
  late final GeneratedColumn<int> age = GeneratedColumn<int>(
    'age',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bioMeta = const VerificationMeta('bio');
  @override
  late final GeneratedColumn<String> bio = GeneratedColumn<String>(
    'bio',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _occupationMeta = const VerificationMeta(
    'occupation',
  );
  @override
  late final GeneratedColumn<String> occupation = GeneratedColumn<String>(
    'occupation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _educationMeta = const VerificationMeta(
    'education',
  );
  @override
  late final GeneratedColumn<String> education = GeneratedColumn<String>(
    'education',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _heightCmMeta = const VerificationMeta(
    'heightCm',
  );
  @override
  late final GeneratedColumn<int> heightCm = GeneratedColumn<int>(
    'height_cm',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ethnicityMeta = const VerificationMeta(
    'ethnicity',
  );
  @override
  late final GeneratedColumn<String> ethnicity = GeneratedColumn<String>(
    'ethnicity',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _religionMeta = const VerificationMeta(
    'religion',
  );
  @override
  late final GeneratedColumn<String> religion = GeneratedColumn<String>(
    'religion',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _relationshipGoalMeta = const VerificationMeta(
    'relationshipGoal',
  );
  @override
  late final GeneratedColumn<String> relationshipGoal = GeneratedColumn<String>(
    'relationship_goal',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _drinkingMeta = const VerificationMeta(
    'drinking',
  );
  @override
  late final GeneratedColumn<String> drinking = GeneratedColumn<String>(
    'drinking',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _smokingMeta = const VerificationMeta(
    'smoking',
  );
  @override
  late final GeneratedColumn<String> smoking = GeneratedColumn<String>(
    'smoking',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _petPreferenceMeta = const VerificationMeta(
    'petPreference',
  );
  @override
  late final GeneratedColumn<String> petPreference = GeneratedColumn<String>(
    'pet_preference',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _childrenPreferenceMeta =
      const VerificationMeta('childrenPreference');
  @override
  late final GeneratedColumn<String> childrenPreference =
      GeneratedColumn<String>(
        'children_preference',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _marriagePreferenceMeta =
      const VerificationMeta('marriagePreference');
  @override
  late final GeneratedColumn<String> marriagePreference =
      GeneratedColumn<String>(
        'marriage_preference',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _completenessPercentMeta =
      const VerificationMeta('completenessPercent');
  @override
  late final GeneratedColumn<int> completenessPercent = GeneratedColumn<int>(
    'completeness_percent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _preferenceAgeMinMeta = const VerificationMeta(
    'preferenceAgeMin',
  );
  @override
  late final GeneratedColumn<int> preferenceAgeMin = GeneratedColumn<int>(
    'preference_age_min',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _preferenceAgeMaxMeta = const VerificationMeta(
    'preferenceAgeMax',
  );
  @override
  late final GeneratedColumn<int> preferenceAgeMax = GeneratedColumn<int>(
    'preference_age_max',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _preferenceGenderPreferenceMeta =
      const VerificationMeta('preferenceGenderPreference');
  @override
  late final GeneratedColumn<String> preferenceGenderPreference =
      GeneratedColumn<String>(
        'preference_gender_preference',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _hasPreferencesMeta = const VerificationMeta(
    'hasPreferences',
  );
  @override
  late final GeneratedColumn<bool> hasPreferences = GeneratedColumn<bool>(
    'has_preferences',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_preferences" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nickName,
    fullName,
    age,
    bio,
    occupation,
    education,
    heightCm,
    gender,
    ethnicity,
    religion,
    relationshipGoal,
    drinking,
    smoking,
    petPreference,
    childrenPreference,
    marriagePreference,
    completenessPercent,
    preferenceAgeMin,
    preferenceAgeMax,
    preferenceGenderPreference,
    hasPreferences,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<Profile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nick_name')) {
      context.handle(
        _nickNameMeta,
        nickName.isAcceptableOrUnknown(data['nick_name']!, _nickNameMeta),
      );
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('age')) {
      context.handle(
        _ageMeta,
        age.isAcceptableOrUnknown(data['age']!, _ageMeta),
      );
    }
    if (data.containsKey('bio')) {
      context.handle(
        _bioMeta,
        bio.isAcceptableOrUnknown(data['bio']!, _bioMeta),
      );
    }
    if (data.containsKey('occupation')) {
      context.handle(
        _occupationMeta,
        occupation.isAcceptableOrUnknown(data['occupation']!, _occupationMeta),
      );
    }
    if (data.containsKey('education')) {
      context.handle(
        _educationMeta,
        education.isAcceptableOrUnknown(data['education']!, _educationMeta),
      );
    }
    if (data.containsKey('height_cm')) {
      context.handle(
        _heightCmMeta,
        heightCm.isAcceptableOrUnknown(data['height_cm']!, _heightCmMeta),
      );
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    }
    if (data.containsKey('ethnicity')) {
      context.handle(
        _ethnicityMeta,
        ethnicity.isAcceptableOrUnknown(data['ethnicity']!, _ethnicityMeta),
      );
    }
    if (data.containsKey('religion')) {
      context.handle(
        _religionMeta,
        religion.isAcceptableOrUnknown(data['religion']!, _religionMeta),
      );
    }
    if (data.containsKey('relationship_goal')) {
      context.handle(
        _relationshipGoalMeta,
        relationshipGoal.isAcceptableOrUnknown(
          data['relationship_goal']!,
          _relationshipGoalMeta,
        ),
      );
    }
    if (data.containsKey('drinking')) {
      context.handle(
        _drinkingMeta,
        drinking.isAcceptableOrUnknown(data['drinking']!, _drinkingMeta),
      );
    }
    if (data.containsKey('smoking')) {
      context.handle(
        _smokingMeta,
        smoking.isAcceptableOrUnknown(data['smoking']!, _smokingMeta),
      );
    }
    if (data.containsKey('pet_preference')) {
      context.handle(
        _petPreferenceMeta,
        petPreference.isAcceptableOrUnknown(
          data['pet_preference']!,
          _petPreferenceMeta,
        ),
      );
    }
    if (data.containsKey('children_preference')) {
      context.handle(
        _childrenPreferenceMeta,
        childrenPreference.isAcceptableOrUnknown(
          data['children_preference']!,
          _childrenPreferenceMeta,
        ),
      );
    }
    if (data.containsKey('marriage_preference')) {
      context.handle(
        _marriagePreferenceMeta,
        marriagePreference.isAcceptableOrUnknown(
          data['marriage_preference']!,
          _marriagePreferenceMeta,
        ),
      );
    }
    if (data.containsKey('completeness_percent')) {
      context.handle(
        _completenessPercentMeta,
        completenessPercent.isAcceptableOrUnknown(
          data['completeness_percent']!,
          _completenessPercentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completenessPercentMeta);
    }
    if (data.containsKey('preference_age_min')) {
      context.handle(
        _preferenceAgeMinMeta,
        preferenceAgeMin.isAcceptableOrUnknown(
          data['preference_age_min']!,
          _preferenceAgeMinMeta,
        ),
      );
    }
    if (data.containsKey('preference_age_max')) {
      context.handle(
        _preferenceAgeMaxMeta,
        preferenceAgeMax.isAcceptableOrUnknown(
          data['preference_age_max']!,
          _preferenceAgeMaxMeta,
        ),
      );
    }
    if (data.containsKey('preference_gender_preference')) {
      context.handle(
        _preferenceGenderPreferenceMeta,
        preferenceGenderPreference.isAcceptableOrUnknown(
          data['preference_gender_preference']!,
          _preferenceGenderPreferenceMeta,
        ),
      );
    }
    if (data.containsKey('has_preferences')) {
      context.handle(
        _hasPreferencesMeta,
        hasPreferences.isAcceptableOrUnknown(
          data['has_preferences']!,
          _hasPreferencesMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Profile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Profile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nickName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nick_name'],
      ),
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      )!,
      age: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}age'],
      ),
      bio: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bio'],
      ),
      occupation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}occupation'],
      ),
      education: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}education'],
      ),
      heightCm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}height_cm'],
      ),
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      ),
      ethnicity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ethnicity'],
      ),
      religion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}religion'],
      ),
      relationshipGoal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}relationship_goal'],
      ),
      drinking: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}drinking'],
      ),
      smoking: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}smoking'],
      ),
      petPreference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pet_preference'],
      ),
      childrenPreference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}children_preference'],
      ),
      marriagePreference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}marriage_preference'],
      ),
      completenessPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completeness_percent'],
      )!,
      preferenceAgeMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}preference_age_min'],
      ),
      preferenceAgeMax: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}preference_age_max'],
      ),
      preferenceGenderPreference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preference_gender_preference'],
      ),
      hasPreferences: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_preferences'],
      )!,
    );
  }

  @override
  $ProfilesTable createAlias(String alias) {
    return $ProfilesTable(attachedDatabase, alias);
  }
}

class Profile extends DataClass implements Insertable<Profile> {
  final int id;
  final String? nickName;
  final String fullName;
  final int? age;
  final String? bio;
  final String? occupation;
  final String? education;
  final int? heightCm;
  final String? gender;
  final String? ethnicity;
  final String? religion;
  final String? relationshipGoal;
  final String? drinking;
  final String? smoking;
  final String? petPreference;
  final String? childrenPreference;
  final String? marriagePreference;
  final int completenessPercent;
  final int? preferenceAgeMin;
  final int? preferenceAgeMax;
  final String? preferenceGenderPreference;
  final bool hasPreferences;
  const Profile({
    required this.id,
    this.nickName,
    required this.fullName,
    this.age,
    this.bio,
    this.occupation,
    this.education,
    this.heightCm,
    this.gender,
    this.ethnicity,
    this.religion,
    this.relationshipGoal,
    this.drinking,
    this.smoking,
    this.petPreference,
    this.childrenPreference,
    this.marriagePreference,
    required this.completenessPercent,
    this.preferenceAgeMin,
    this.preferenceAgeMax,
    this.preferenceGenderPreference,
    required this.hasPreferences,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || nickName != null) {
      map['nick_name'] = Variable<String>(nickName);
    }
    map['full_name'] = Variable<String>(fullName);
    if (!nullToAbsent || age != null) {
      map['age'] = Variable<int>(age);
    }
    if (!nullToAbsent || bio != null) {
      map['bio'] = Variable<String>(bio);
    }
    if (!nullToAbsent || occupation != null) {
      map['occupation'] = Variable<String>(occupation);
    }
    if (!nullToAbsent || education != null) {
      map['education'] = Variable<String>(education);
    }
    if (!nullToAbsent || heightCm != null) {
      map['height_cm'] = Variable<int>(heightCm);
    }
    if (!nullToAbsent || gender != null) {
      map['gender'] = Variable<String>(gender);
    }
    if (!nullToAbsent || ethnicity != null) {
      map['ethnicity'] = Variable<String>(ethnicity);
    }
    if (!nullToAbsent || religion != null) {
      map['religion'] = Variable<String>(religion);
    }
    if (!nullToAbsent || relationshipGoal != null) {
      map['relationship_goal'] = Variable<String>(relationshipGoal);
    }
    if (!nullToAbsent || drinking != null) {
      map['drinking'] = Variable<String>(drinking);
    }
    if (!nullToAbsent || smoking != null) {
      map['smoking'] = Variable<String>(smoking);
    }
    if (!nullToAbsent || petPreference != null) {
      map['pet_preference'] = Variable<String>(petPreference);
    }
    if (!nullToAbsent || childrenPreference != null) {
      map['children_preference'] = Variable<String>(childrenPreference);
    }
    if (!nullToAbsent || marriagePreference != null) {
      map['marriage_preference'] = Variable<String>(marriagePreference);
    }
    map['completeness_percent'] = Variable<int>(completenessPercent);
    if (!nullToAbsent || preferenceAgeMin != null) {
      map['preference_age_min'] = Variable<int>(preferenceAgeMin);
    }
    if (!nullToAbsent || preferenceAgeMax != null) {
      map['preference_age_max'] = Variable<int>(preferenceAgeMax);
    }
    if (!nullToAbsent || preferenceGenderPreference != null) {
      map['preference_gender_preference'] = Variable<String>(
        preferenceGenderPreference,
      );
    }
    map['has_preferences'] = Variable<bool>(hasPreferences);
    return map;
  }

  ProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      id: Value(id),
      nickName: nickName == null && nullToAbsent
          ? const Value.absent()
          : Value(nickName),
      fullName: Value(fullName),
      age: age == null && nullToAbsent ? const Value.absent() : Value(age),
      bio: bio == null && nullToAbsent ? const Value.absent() : Value(bio),
      occupation: occupation == null && nullToAbsent
          ? const Value.absent()
          : Value(occupation),
      education: education == null && nullToAbsent
          ? const Value.absent()
          : Value(education),
      heightCm: heightCm == null && nullToAbsent
          ? const Value.absent()
          : Value(heightCm),
      gender: gender == null && nullToAbsent
          ? const Value.absent()
          : Value(gender),
      ethnicity: ethnicity == null && nullToAbsent
          ? const Value.absent()
          : Value(ethnicity),
      religion: religion == null && nullToAbsent
          ? const Value.absent()
          : Value(religion),
      relationshipGoal: relationshipGoal == null && nullToAbsent
          ? const Value.absent()
          : Value(relationshipGoal),
      drinking: drinking == null && nullToAbsent
          ? const Value.absent()
          : Value(drinking),
      smoking: smoking == null && nullToAbsent
          ? const Value.absent()
          : Value(smoking),
      petPreference: petPreference == null && nullToAbsent
          ? const Value.absent()
          : Value(petPreference),
      childrenPreference: childrenPreference == null && nullToAbsent
          ? const Value.absent()
          : Value(childrenPreference),
      marriagePreference: marriagePreference == null && nullToAbsent
          ? const Value.absent()
          : Value(marriagePreference),
      completenessPercent: Value(completenessPercent),
      preferenceAgeMin: preferenceAgeMin == null && nullToAbsent
          ? const Value.absent()
          : Value(preferenceAgeMin),
      preferenceAgeMax: preferenceAgeMax == null && nullToAbsent
          ? const Value.absent()
          : Value(preferenceAgeMax),
      preferenceGenderPreference:
          preferenceGenderPreference == null && nullToAbsent
          ? const Value.absent()
          : Value(preferenceGenderPreference),
      hasPreferences: Value(hasPreferences),
    );
  }

  factory Profile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Profile(
      id: serializer.fromJson<int>(json['id']),
      nickName: serializer.fromJson<String?>(json['nickName']),
      fullName: serializer.fromJson<String>(json['fullName']),
      age: serializer.fromJson<int?>(json['age']),
      bio: serializer.fromJson<String?>(json['bio']),
      occupation: serializer.fromJson<String?>(json['occupation']),
      education: serializer.fromJson<String?>(json['education']),
      heightCm: serializer.fromJson<int?>(json['heightCm']),
      gender: serializer.fromJson<String?>(json['gender']),
      ethnicity: serializer.fromJson<String?>(json['ethnicity']),
      religion: serializer.fromJson<String?>(json['religion']),
      relationshipGoal: serializer.fromJson<String?>(json['relationshipGoal']),
      drinking: serializer.fromJson<String?>(json['drinking']),
      smoking: serializer.fromJson<String?>(json['smoking']),
      petPreference: serializer.fromJson<String?>(json['petPreference']),
      childrenPreference: serializer.fromJson<String?>(
        json['childrenPreference'],
      ),
      marriagePreference: serializer.fromJson<String?>(
        json['marriagePreference'],
      ),
      completenessPercent: serializer.fromJson<int>(
        json['completenessPercent'],
      ),
      preferenceAgeMin: serializer.fromJson<int?>(json['preferenceAgeMin']),
      preferenceAgeMax: serializer.fromJson<int?>(json['preferenceAgeMax']),
      preferenceGenderPreference: serializer.fromJson<String?>(
        json['preferenceGenderPreference'],
      ),
      hasPreferences: serializer.fromJson<bool>(json['hasPreferences']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nickName': serializer.toJson<String?>(nickName),
      'fullName': serializer.toJson<String>(fullName),
      'age': serializer.toJson<int?>(age),
      'bio': serializer.toJson<String?>(bio),
      'occupation': serializer.toJson<String?>(occupation),
      'education': serializer.toJson<String?>(education),
      'heightCm': serializer.toJson<int?>(heightCm),
      'gender': serializer.toJson<String?>(gender),
      'ethnicity': serializer.toJson<String?>(ethnicity),
      'religion': serializer.toJson<String?>(religion),
      'relationshipGoal': serializer.toJson<String?>(relationshipGoal),
      'drinking': serializer.toJson<String?>(drinking),
      'smoking': serializer.toJson<String?>(smoking),
      'petPreference': serializer.toJson<String?>(petPreference),
      'childrenPreference': serializer.toJson<String?>(childrenPreference),
      'marriagePreference': serializer.toJson<String?>(marriagePreference),
      'completenessPercent': serializer.toJson<int>(completenessPercent),
      'preferenceAgeMin': serializer.toJson<int?>(preferenceAgeMin),
      'preferenceAgeMax': serializer.toJson<int?>(preferenceAgeMax),
      'preferenceGenderPreference': serializer.toJson<String?>(
        preferenceGenderPreference,
      ),
      'hasPreferences': serializer.toJson<bool>(hasPreferences),
    };
  }

  Profile copyWith({
    int? id,
    Value<String?> nickName = const Value.absent(),
    String? fullName,
    Value<int?> age = const Value.absent(),
    Value<String?> bio = const Value.absent(),
    Value<String?> occupation = const Value.absent(),
    Value<String?> education = const Value.absent(),
    Value<int?> heightCm = const Value.absent(),
    Value<String?> gender = const Value.absent(),
    Value<String?> ethnicity = const Value.absent(),
    Value<String?> religion = const Value.absent(),
    Value<String?> relationshipGoal = const Value.absent(),
    Value<String?> drinking = const Value.absent(),
    Value<String?> smoking = const Value.absent(),
    Value<String?> petPreference = const Value.absent(),
    Value<String?> childrenPreference = const Value.absent(),
    Value<String?> marriagePreference = const Value.absent(),
    int? completenessPercent,
    Value<int?> preferenceAgeMin = const Value.absent(),
    Value<int?> preferenceAgeMax = const Value.absent(),
    Value<String?> preferenceGenderPreference = const Value.absent(),
    bool? hasPreferences,
  }) => Profile(
    id: id ?? this.id,
    nickName: nickName.present ? nickName.value : this.nickName,
    fullName: fullName ?? this.fullName,
    age: age.present ? age.value : this.age,
    bio: bio.present ? bio.value : this.bio,
    occupation: occupation.present ? occupation.value : this.occupation,
    education: education.present ? education.value : this.education,
    heightCm: heightCm.present ? heightCm.value : this.heightCm,
    gender: gender.present ? gender.value : this.gender,
    ethnicity: ethnicity.present ? ethnicity.value : this.ethnicity,
    religion: religion.present ? religion.value : this.religion,
    relationshipGoal: relationshipGoal.present
        ? relationshipGoal.value
        : this.relationshipGoal,
    drinking: drinking.present ? drinking.value : this.drinking,
    smoking: smoking.present ? smoking.value : this.smoking,
    petPreference: petPreference.present
        ? petPreference.value
        : this.petPreference,
    childrenPreference: childrenPreference.present
        ? childrenPreference.value
        : this.childrenPreference,
    marriagePreference: marriagePreference.present
        ? marriagePreference.value
        : this.marriagePreference,
    completenessPercent: completenessPercent ?? this.completenessPercent,
    preferenceAgeMin: preferenceAgeMin.present
        ? preferenceAgeMin.value
        : this.preferenceAgeMin,
    preferenceAgeMax: preferenceAgeMax.present
        ? preferenceAgeMax.value
        : this.preferenceAgeMax,
    preferenceGenderPreference: preferenceGenderPreference.present
        ? preferenceGenderPreference.value
        : this.preferenceGenderPreference,
    hasPreferences: hasPreferences ?? this.hasPreferences,
  );
  Profile copyWithCompanion(ProfilesCompanion data) {
    return Profile(
      id: data.id.present ? data.id.value : this.id,
      nickName: data.nickName.present ? data.nickName.value : this.nickName,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      age: data.age.present ? data.age.value : this.age,
      bio: data.bio.present ? data.bio.value : this.bio,
      occupation: data.occupation.present
          ? data.occupation.value
          : this.occupation,
      education: data.education.present ? data.education.value : this.education,
      heightCm: data.heightCm.present ? data.heightCm.value : this.heightCm,
      gender: data.gender.present ? data.gender.value : this.gender,
      ethnicity: data.ethnicity.present ? data.ethnicity.value : this.ethnicity,
      religion: data.religion.present ? data.religion.value : this.religion,
      relationshipGoal: data.relationshipGoal.present
          ? data.relationshipGoal.value
          : this.relationshipGoal,
      drinking: data.drinking.present ? data.drinking.value : this.drinking,
      smoking: data.smoking.present ? data.smoking.value : this.smoking,
      petPreference: data.petPreference.present
          ? data.petPreference.value
          : this.petPreference,
      childrenPreference: data.childrenPreference.present
          ? data.childrenPreference.value
          : this.childrenPreference,
      marriagePreference: data.marriagePreference.present
          ? data.marriagePreference.value
          : this.marriagePreference,
      completenessPercent: data.completenessPercent.present
          ? data.completenessPercent.value
          : this.completenessPercent,
      preferenceAgeMin: data.preferenceAgeMin.present
          ? data.preferenceAgeMin.value
          : this.preferenceAgeMin,
      preferenceAgeMax: data.preferenceAgeMax.present
          ? data.preferenceAgeMax.value
          : this.preferenceAgeMax,
      preferenceGenderPreference: data.preferenceGenderPreference.present
          ? data.preferenceGenderPreference.value
          : this.preferenceGenderPreference,
      hasPreferences: data.hasPreferences.present
          ? data.hasPreferences.value
          : this.hasPreferences,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Profile(')
          ..write('id: $id, ')
          ..write('nickName: $nickName, ')
          ..write('fullName: $fullName, ')
          ..write('age: $age, ')
          ..write('bio: $bio, ')
          ..write('occupation: $occupation, ')
          ..write('education: $education, ')
          ..write('heightCm: $heightCm, ')
          ..write('gender: $gender, ')
          ..write('ethnicity: $ethnicity, ')
          ..write('religion: $religion, ')
          ..write('relationshipGoal: $relationshipGoal, ')
          ..write('drinking: $drinking, ')
          ..write('smoking: $smoking, ')
          ..write('petPreference: $petPreference, ')
          ..write('childrenPreference: $childrenPreference, ')
          ..write('marriagePreference: $marriagePreference, ')
          ..write('completenessPercent: $completenessPercent, ')
          ..write('preferenceAgeMin: $preferenceAgeMin, ')
          ..write('preferenceAgeMax: $preferenceAgeMax, ')
          ..write('preferenceGenderPreference: $preferenceGenderPreference, ')
          ..write('hasPreferences: $hasPreferences')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    nickName,
    fullName,
    age,
    bio,
    occupation,
    education,
    heightCm,
    gender,
    ethnicity,
    religion,
    relationshipGoal,
    drinking,
    smoking,
    petPreference,
    childrenPreference,
    marriagePreference,
    completenessPercent,
    preferenceAgeMin,
    preferenceAgeMax,
    preferenceGenderPreference,
    hasPreferences,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Profile &&
          other.id == this.id &&
          other.nickName == this.nickName &&
          other.fullName == this.fullName &&
          other.age == this.age &&
          other.bio == this.bio &&
          other.occupation == this.occupation &&
          other.education == this.education &&
          other.heightCm == this.heightCm &&
          other.gender == this.gender &&
          other.ethnicity == this.ethnicity &&
          other.religion == this.religion &&
          other.relationshipGoal == this.relationshipGoal &&
          other.drinking == this.drinking &&
          other.smoking == this.smoking &&
          other.petPreference == this.petPreference &&
          other.childrenPreference == this.childrenPreference &&
          other.marriagePreference == this.marriagePreference &&
          other.completenessPercent == this.completenessPercent &&
          other.preferenceAgeMin == this.preferenceAgeMin &&
          other.preferenceAgeMax == this.preferenceAgeMax &&
          other.preferenceGenderPreference == this.preferenceGenderPreference &&
          other.hasPreferences == this.hasPreferences);
}

class ProfilesCompanion extends UpdateCompanion<Profile> {
  final Value<int> id;
  final Value<String?> nickName;
  final Value<String> fullName;
  final Value<int?> age;
  final Value<String?> bio;
  final Value<String?> occupation;
  final Value<String?> education;
  final Value<int?> heightCm;
  final Value<String?> gender;
  final Value<String?> ethnicity;
  final Value<String?> religion;
  final Value<String?> relationshipGoal;
  final Value<String?> drinking;
  final Value<String?> smoking;
  final Value<String?> petPreference;
  final Value<String?> childrenPreference;
  final Value<String?> marriagePreference;
  final Value<int> completenessPercent;
  final Value<int?> preferenceAgeMin;
  final Value<int?> preferenceAgeMax;
  final Value<String?> preferenceGenderPreference;
  final Value<bool> hasPreferences;
  const ProfilesCompanion({
    this.id = const Value.absent(),
    this.nickName = const Value.absent(),
    this.fullName = const Value.absent(),
    this.age = const Value.absent(),
    this.bio = const Value.absent(),
    this.occupation = const Value.absent(),
    this.education = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.gender = const Value.absent(),
    this.ethnicity = const Value.absent(),
    this.religion = const Value.absent(),
    this.relationshipGoal = const Value.absent(),
    this.drinking = const Value.absent(),
    this.smoking = const Value.absent(),
    this.petPreference = const Value.absent(),
    this.childrenPreference = const Value.absent(),
    this.marriagePreference = const Value.absent(),
    this.completenessPercent = const Value.absent(),
    this.preferenceAgeMin = const Value.absent(),
    this.preferenceAgeMax = const Value.absent(),
    this.preferenceGenderPreference = const Value.absent(),
    this.hasPreferences = const Value.absent(),
  });
  ProfilesCompanion.insert({
    this.id = const Value.absent(),
    this.nickName = const Value.absent(),
    required String fullName,
    this.age = const Value.absent(),
    this.bio = const Value.absent(),
    this.occupation = const Value.absent(),
    this.education = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.gender = const Value.absent(),
    this.ethnicity = const Value.absent(),
    this.religion = const Value.absent(),
    this.relationshipGoal = const Value.absent(),
    this.drinking = const Value.absent(),
    this.smoking = const Value.absent(),
    this.petPreference = const Value.absent(),
    this.childrenPreference = const Value.absent(),
    this.marriagePreference = const Value.absent(),
    required int completenessPercent,
    this.preferenceAgeMin = const Value.absent(),
    this.preferenceAgeMax = const Value.absent(),
    this.preferenceGenderPreference = const Value.absent(),
    this.hasPreferences = const Value.absent(),
  }) : fullName = Value(fullName),
       completenessPercent = Value(completenessPercent);
  static Insertable<Profile> custom({
    Expression<int>? id,
    Expression<String>? nickName,
    Expression<String>? fullName,
    Expression<int>? age,
    Expression<String>? bio,
    Expression<String>? occupation,
    Expression<String>? education,
    Expression<int>? heightCm,
    Expression<String>? gender,
    Expression<String>? ethnicity,
    Expression<String>? religion,
    Expression<String>? relationshipGoal,
    Expression<String>? drinking,
    Expression<String>? smoking,
    Expression<String>? petPreference,
    Expression<String>? childrenPreference,
    Expression<String>? marriagePreference,
    Expression<int>? completenessPercent,
    Expression<int>? preferenceAgeMin,
    Expression<int>? preferenceAgeMax,
    Expression<String>? preferenceGenderPreference,
    Expression<bool>? hasPreferences,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nickName != null) 'nick_name': nickName,
      if (fullName != null) 'full_name': fullName,
      if (age != null) 'age': age,
      if (bio != null) 'bio': bio,
      if (occupation != null) 'occupation': occupation,
      if (education != null) 'education': education,
      if (heightCm != null) 'height_cm': heightCm,
      if (gender != null) 'gender': gender,
      if (ethnicity != null) 'ethnicity': ethnicity,
      if (religion != null) 'religion': religion,
      if (relationshipGoal != null) 'relationship_goal': relationshipGoal,
      if (drinking != null) 'drinking': drinking,
      if (smoking != null) 'smoking': smoking,
      if (petPreference != null) 'pet_preference': petPreference,
      if (childrenPreference != null) 'children_preference': childrenPreference,
      if (marriagePreference != null) 'marriage_preference': marriagePreference,
      if (completenessPercent != null)
        'completeness_percent': completenessPercent,
      if (preferenceAgeMin != null) 'preference_age_min': preferenceAgeMin,
      if (preferenceAgeMax != null) 'preference_age_max': preferenceAgeMax,
      if (preferenceGenderPreference != null)
        'preference_gender_preference': preferenceGenderPreference,
      if (hasPreferences != null) 'has_preferences': hasPreferences,
    });
  }

  ProfilesCompanion copyWith({
    Value<int>? id,
    Value<String?>? nickName,
    Value<String>? fullName,
    Value<int?>? age,
    Value<String?>? bio,
    Value<String?>? occupation,
    Value<String?>? education,
    Value<int?>? heightCm,
    Value<String?>? gender,
    Value<String?>? ethnicity,
    Value<String?>? religion,
    Value<String?>? relationshipGoal,
    Value<String?>? drinking,
    Value<String?>? smoking,
    Value<String?>? petPreference,
    Value<String?>? childrenPreference,
    Value<String?>? marriagePreference,
    Value<int>? completenessPercent,
    Value<int?>? preferenceAgeMin,
    Value<int?>? preferenceAgeMax,
    Value<String?>? preferenceGenderPreference,
    Value<bool>? hasPreferences,
  }) {
    return ProfilesCompanion(
      id: id ?? this.id,
      nickName: nickName ?? this.nickName,
      fullName: fullName ?? this.fullName,
      age: age ?? this.age,
      bio: bio ?? this.bio,
      occupation: occupation ?? this.occupation,
      education: education ?? this.education,
      heightCm: heightCm ?? this.heightCm,
      gender: gender ?? this.gender,
      ethnicity: ethnicity ?? this.ethnicity,
      religion: religion ?? this.religion,
      relationshipGoal: relationshipGoal ?? this.relationshipGoal,
      drinking: drinking ?? this.drinking,
      smoking: smoking ?? this.smoking,
      petPreference: petPreference ?? this.petPreference,
      childrenPreference: childrenPreference ?? this.childrenPreference,
      marriagePreference: marriagePreference ?? this.marriagePreference,
      completenessPercent: completenessPercent ?? this.completenessPercent,
      preferenceAgeMin: preferenceAgeMin ?? this.preferenceAgeMin,
      preferenceAgeMax: preferenceAgeMax ?? this.preferenceAgeMax,
      preferenceGenderPreference:
          preferenceGenderPreference ?? this.preferenceGenderPreference,
      hasPreferences: hasPreferences ?? this.hasPreferences,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nickName.present) {
      map['nick_name'] = Variable<String>(nickName.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (age.present) {
      map['age'] = Variable<int>(age.value);
    }
    if (bio.present) {
      map['bio'] = Variable<String>(bio.value);
    }
    if (occupation.present) {
      map['occupation'] = Variable<String>(occupation.value);
    }
    if (education.present) {
      map['education'] = Variable<String>(education.value);
    }
    if (heightCm.present) {
      map['height_cm'] = Variable<int>(heightCm.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (ethnicity.present) {
      map['ethnicity'] = Variable<String>(ethnicity.value);
    }
    if (religion.present) {
      map['religion'] = Variable<String>(religion.value);
    }
    if (relationshipGoal.present) {
      map['relationship_goal'] = Variable<String>(relationshipGoal.value);
    }
    if (drinking.present) {
      map['drinking'] = Variable<String>(drinking.value);
    }
    if (smoking.present) {
      map['smoking'] = Variable<String>(smoking.value);
    }
    if (petPreference.present) {
      map['pet_preference'] = Variable<String>(petPreference.value);
    }
    if (childrenPreference.present) {
      map['children_preference'] = Variable<String>(childrenPreference.value);
    }
    if (marriagePreference.present) {
      map['marriage_preference'] = Variable<String>(marriagePreference.value);
    }
    if (completenessPercent.present) {
      map['completeness_percent'] = Variable<int>(completenessPercent.value);
    }
    if (preferenceAgeMin.present) {
      map['preference_age_min'] = Variable<int>(preferenceAgeMin.value);
    }
    if (preferenceAgeMax.present) {
      map['preference_age_max'] = Variable<int>(preferenceAgeMax.value);
    }
    if (preferenceGenderPreference.present) {
      map['preference_gender_preference'] = Variable<String>(
        preferenceGenderPreference.value,
      );
    }
    if (hasPreferences.present) {
      map['has_preferences'] = Variable<bool>(hasPreferences.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesCompanion(')
          ..write('id: $id, ')
          ..write('nickName: $nickName, ')
          ..write('fullName: $fullName, ')
          ..write('age: $age, ')
          ..write('bio: $bio, ')
          ..write('occupation: $occupation, ')
          ..write('education: $education, ')
          ..write('heightCm: $heightCm, ')
          ..write('gender: $gender, ')
          ..write('ethnicity: $ethnicity, ')
          ..write('religion: $religion, ')
          ..write('relationshipGoal: $relationshipGoal, ')
          ..write('drinking: $drinking, ')
          ..write('smoking: $smoking, ')
          ..write('petPreference: $petPreference, ')
          ..write('childrenPreference: $childrenPreference, ')
          ..write('marriagePreference: $marriagePreference, ')
          ..write('completenessPercent: $completenessPercent, ')
          ..write('preferenceAgeMin: $preferenceAgeMin, ')
          ..write('preferenceAgeMax: $preferenceAgeMax, ')
          ..write('preferenceGenderPreference: $preferenceGenderPreference, ')
          ..write('hasPreferences: $hasPreferences')
          ..write(')'))
        .toString();
  }
}

class $LoveLanguagesTable extends LoveLanguages
    with TableInfo<$LoveLanguagesTable, LoveLanguage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LoveLanguagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _rowIdMeta = const VerificationMeta('rowId');
  @override
  late final GeneratedColumn<int> rowId = GeneratedColumn<int>(
    'row_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [rowId, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'love_languages';
  @override
  VerificationContext validateIntegrity(
    Insertable<LoveLanguage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('row_id')) {
      context.handle(
        _rowIdMeta,
        rowId.isAcceptableOrUnknown(data['row_id']!, _rowIdMeta),
      );
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {rowId};
  @override
  LoveLanguage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LoveLanguage(
      rowId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}row_id'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $LoveLanguagesTable createAlias(String alias) {
    return $LoveLanguagesTable(attachedDatabase, alias);
  }
}

class LoveLanguage extends DataClass implements Insertable<LoveLanguage> {
  final int rowId;
  final String value;
  const LoveLanguage({required this.rowId, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['row_id'] = Variable<int>(rowId);
    map['value'] = Variable<String>(value);
    return map;
  }

  LoveLanguagesCompanion toCompanion(bool nullToAbsent) {
    return LoveLanguagesCompanion(rowId: Value(rowId), value: Value(value));
  }

  factory LoveLanguage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LoveLanguage(
      rowId: serializer.fromJson<int>(json['rowId']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'rowId': serializer.toJson<int>(rowId),
      'value': serializer.toJson<String>(value),
    };
  }

  LoveLanguage copyWith({int? rowId, String? value}) =>
      LoveLanguage(rowId: rowId ?? this.rowId, value: value ?? this.value);
  LoveLanguage copyWithCompanion(LoveLanguagesCompanion data) {
    return LoveLanguage(
      rowId: data.rowId.present ? data.rowId.value : this.rowId,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LoveLanguage(')
          ..write('rowId: $rowId, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(rowId, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LoveLanguage &&
          other.rowId == this.rowId &&
          other.value == this.value);
}

class LoveLanguagesCompanion extends UpdateCompanion<LoveLanguage> {
  final Value<int> rowId;
  final Value<String> value;
  const LoveLanguagesCompanion({
    this.rowId = const Value.absent(),
    this.value = const Value.absent(),
  });
  LoveLanguagesCompanion.insert({
    this.rowId = const Value.absent(),
    required String value,
  }) : value = Value(value);
  static Insertable<LoveLanguage> custom({
    Expression<int>? rowId,
    Expression<String>? value,
  }) {
    return RawValuesInsertable({
      if (rowId != null) 'row_id': rowId,
      if (value != null) 'value': value,
    });
  }

  LoveLanguagesCompanion copyWith({Value<int>? rowId, Value<String>? value}) {
    return LoveLanguagesCompanion(
      rowId: rowId ?? this.rowId,
      value: value ?? this.value,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (rowId.present) {
      map['row_id'] = Variable<int>(rowId.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LoveLanguagesCompanion(')
          ..write('rowId: $rowId, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }
}

class $ProfileInterestsTable extends ProfileInterests
    with TableInfo<$ProfileInterestsTable, ProfileInterest> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfileInterestsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _rowIdMeta = const VerificationMeta('rowId');
  @override
  late final GeneratedColumn<int> rowId = GeneratedColumn<int>(
    'row_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [rowId, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profile_interests';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProfileInterest> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('row_id')) {
      context.handle(
        _rowIdMeta,
        rowId.isAcceptableOrUnknown(data['row_id']!, _rowIdMeta),
      );
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {rowId};
  @override
  ProfileInterest map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProfileInterest(
      rowId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}row_id'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $ProfileInterestsTable createAlias(String alias) {
    return $ProfileInterestsTable(attachedDatabase, alias);
  }
}

class ProfileInterest extends DataClass implements Insertable<ProfileInterest> {
  final int rowId;
  final String value;
  const ProfileInterest({required this.rowId, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['row_id'] = Variable<int>(rowId);
    map['value'] = Variable<String>(value);
    return map;
  }

  ProfileInterestsCompanion toCompanion(bool nullToAbsent) {
    return ProfileInterestsCompanion(rowId: Value(rowId), value: Value(value));
  }

  factory ProfileInterest.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProfileInterest(
      rowId: serializer.fromJson<int>(json['rowId']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'rowId': serializer.toJson<int>(rowId),
      'value': serializer.toJson<String>(value),
    };
  }

  ProfileInterest copyWith({int? rowId, String? value}) =>
      ProfileInterest(rowId: rowId ?? this.rowId, value: value ?? this.value);
  ProfileInterest copyWithCompanion(ProfileInterestsCompanion data) {
    return ProfileInterest(
      rowId: data.rowId.present ? data.rowId.value : this.rowId,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProfileInterest(')
          ..write('rowId: $rowId, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(rowId, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProfileInterest &&
          other.rowId == this.rowId &&
          other.value == this.value);
}

class ProfileInterestsCompanion extends UpdateCompanion<ProfileInterest> {
  final Value<int> rowId;
  final Value<String> value;
  const ProfileInterestsCompanion({
    this.rowId = const Value.absent(),
    this.value = const Value.absent(),
  });
  ProfileInterestsCompanion.insert({
    this.rowId = const Value.absent(),
    required String value,
  }) : value = Value(value);
  static Insertable<ProfileInterest> custom({
    Expression<int>? rowId,
    Expression<String>? value,
  }) {
    return RawValuesInsertable({
      if (rowId != null) 'row_id': rowId,
      if (value != null) 'value': value,
    });
  }

  ProfileInterestsCompanion copyWith({
    Value<int>? rowId,
    Value<String>? value,
  }) {
    return ProfileInterestsCompanion(
      rowId: rowId ?? this.rowId,
      value: value ?? this.value,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (rowId.present) {
      map['row_id'] = Variable<int>(rowId.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfileInterestsCompanion(')
          ..write('rowId: $rowId, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }
}

class $PhotosTable extends Photos with TableInfo<$PhotosTable, Photo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PhotosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _rowIdMeta = const VerificationMeta('rowId');
  @override
  late final GeneratedColumn<int> rowId = GeneratedColumn<int>(
    'row_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isMainMeta = const VerificationMeta('isMain');
  @override
  late final GeneratedColumn<bool> isMain = GeneratedColumn<bool>(
    'is_main',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_main" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [rowId, path, position, isMain];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'photos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Photo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('row_id')) {
      context.handle(
        _rowIdMeta,
        rowId.isAcceptableOrUnknown(data['row_id']!, _rowIdMeta),
      );
    }
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('is_main')) {
      context.handle(
        _isMainMeta,
        isMain.isAcceptableOrUnknown(data['is_main']!, _isMainMeta),
      );
    } else if (isInserting) {
      context.missing(_isMainMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {rowId};
  @override
  Photo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Photo(
      rowId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}row_id'],
      )!,
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      isMain: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_main'],
      )!,
    );
  }

  @override
  $PhotosTable createAlias(String alias) {
    return $PhotosTable(attachedDatabase, alias);
  }
}

class Photo extends DataClass implements Insertable<Photo> {
  final int rowId;
  final String path;
  final int position;
  final bool isMain;
  const Photo({
    required this.rowId,
    required this.path,
    required this.position,
    required this.isMain,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['row_id'] = Variable<int>(rowId);
    map['path'] = Variable<String>(path);
    map['position'] = Variable<int>(position);
    map['is_main'] = Variable<bool>(isMain);
    return map;
  }

  PhotosCompanion toCompanion(bool nullToAbsent) {
    return PhotosCompanion(
      rowId: Value(rowId),
      path: Value(path),
      position: Value(position),
      isMain: Value(isMain),
    );
  }

  factory Photo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Photo(
      rowId: serializer.fromJson<int>(json['rowId']),
      path: serializer.fromJson<String>(json['path']),
      position: serializer.fromJson<int>(json['position']),
      isMain: serializer.fromJson<bool>(json['isMain']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'rowId': serializer.toJson<int>(rowId),
      'path': serializer.toJson<String>(path),
      'position': serializer.toJson<int>(position),
      'isMain': serializer.toJson<bool>(isMain),
    };
  }

  Photo copyWith({int? rowId, String? path, int? position, bool? isMain}) =>
      Photo(
        rowId: rowId ?? this.rowId,
        path: path ?? this.path,
        position: position ?? this.position,
        isMain: isMain ?? this.isMain,
      );
  Photo copyWithCompanion(PhotosCompanion data) {
    return Photo(
      rowId: data.rowId.present ? data.rowId.value : this.rowId,
      path: data.path.present ? data.path.value : this.path,
      position: data.position.present ? data.position.value : this.position,
      isMain: data.isMain.present ? data.isMain.value : this.isMain,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Photo(')
          ..write('rowId: $rowId, ')
          ..write('path: $path, ')
          ..write('position: $position, ')
          ..write('isMain: $isMain')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(rowId, path, position, isMain);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Photo &&
          other.rowId == this.rowId &&
          other.path == this.path &&
          other.position == this.position &&
          other.isMain == this.isMain);
}

class PhotosCompanion extends UpdateCompanion<Photo> {
  final Value<int> rowId;
  final Value<String> path;
  final Value<int> position;
  final Value<bool> isMain;
  const PhotosCompanion({
    this.rowId = const Value.absent(),
    this.path = const Value.absent(),
    this.position = const Value.absent(),
    this.isMain = const Value.absent(),
  });
  PhotosCompanion.insert({
    this.rowId = const Value.absent(),
    required String path,
    required int position,
    required bool isMain,
  }) : path = Value(path),
       position = Value(position),
       isMain = Value(isMain);
  static Insertable<Photo> custom({
    Expression<int>? rowId,
    Expression<String>? path,
    Expression<int>? position,
    Expression<bool>? isMain,
  }) {
    return RawValuesInsertable({
      if (rowId != null) 'row_id': rowId,
      if (path != null) 'path': path,
      if (position != null) 'position': position,
      if (isMain != null) 'is_main': isMain,
    });
  }

  PhotosCompanion copyWith({
    Value<int>? rowId,
    Value<String>? path,
    Value<int>? position,
    Value<bool>? isMain,
  }) {
    return PhotosCompanion(
      rowId: rowId ?? this.rowId,
      path: path ?? this.path,
      position: position ?? this.position,
      isMain: isMain ?? this.isMain,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (rowId.present) {
      map['row_id'] = Variable<int>(rowId.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (isMain.present) {
      map['is_main'] = Variable<bool>(isMain.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PhotosCompanion(')
          ..write('rowId: $rowId, ')
          ..write('path: $path, ')
          ..write('position: $position, ')
          ..write('isMain: $isMain')
          ..write(')'))
        .toString();
  }
}

class $PreferenceChildrenTable extends PreferenceChildren
    with TableInfo<$PreferenceChildrenTable, PreferenceChildrenData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PreferenceChildrenTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _rowIdMeta = const VerificationMeta('rowId');
  @override
  late final GeneratedColumn<int> rowId = GeneratedColumn<int>(
    'row_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [rowId, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'preference_children';
  @override
  VerificationContext validateIntegrity(
    Insertable<PreferenceChildrenData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('row_id')) {
      context.handle(
        _rowIdMeta,
        rowId.isAcceptableOrUnknown(data['row_id']!, _rowIdMeta),
      );
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {rowId};
  @override
  PreferenceChildrenData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PreferenceChildrenData(
      rowId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}row_id'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $PreferenceChildrenTable createAlias(String alias) {
    return $PreferenceChildrenTable(attachedDatabase, alias);
  }
}

class PreferenceChildrenData extends DataClass
    implements Insertable<PreferenceChildrenData> {
  final int rowId;
  final String value;
  const PreferenceChildrenData({required this.rowId, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['row_id'] = Variable<int>(rowId);
    map['value'] = Variable<String>(value);
    return map;
  }

  PreferenceChildrenCompanion toCompanion(bool nullToAbsent) {
    return PreferenceChildrenCompanion(
      rowId: Value(rowId),
      value: Value(value),
    );
  }

  factory PreferenceChildrenData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PreferenceChildrenData(
      rowId: serializer.fromJson<int>(json['rowId']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'rowId': serializer.toJson<int>(rowId),
      'value': serializer.toJson<String>(value),
    };
  }

  PreferenceChildrenData copyWith({int? rowId, String? value}) =>
      PreferenceChildrenData(
        rowId: rowId ?? this.rowId,
        value: value ?? this.value,
      );
  PreferenceChildrenData copyWithCompanion(PreferenceChildrenCompanion data) {
    return PreferenceChildrenData(
      rowId: data.rowId.present ? data.rowId.value : this.rowId,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PreferenceChildrenData(')
          ..write('rowId: $rowId, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(rowId, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PreferenceChildrenData &&
          other.rowId == this.rowId &&
          other.value == this.value);
}

class PreferenceChildrenCompanion
    extends UpdateCompanion<PreferenceChildrenData> {
  final Value<int> rowId;
  final Value<String> value;
  const PreferenceChildrenCompanion({
    this.rowId = const Value.absent(),
    this.value = const Value.absent(),
  });
  PreferenceChildrenCompanion.insert({
    this.rowId = const Value.absent(),
    required String value,
  }) : value = Value(value);
  static Insertable<PreferenceChildrenData> custom({
    Expression<int>? rowId,
    Expression<String>? value,
  }) {
    return RawValuesInsertable({
      if (rowId != null) 'row_id': rowId,
      if (value != null) 'value': value,
    });
  }

  PreferenceChildrenCompanion copyWith({
    Value<int>? rowId,
    Value<String>? value,
  }) {
    return PreferenceChildrenCompanion(
      rowId: rowId ?? this.rowId,
      value: value ?? this.value,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (rowId.present) {
      map['row_id'] = Variable<int>(rowId.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PreferenceChildrenCompanion(')
          ..write('rowId: $rowId, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }
}

class $PreferenceMarriagesTable extends PreferenceMarriages
    with TableInfo<$PreferenceMarriagesTable, PreferenceMarriage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PreferenceMarriagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _rowIdMeta = const VerificationMeta('rowId');
  @override
  late final GeneratedColumn<int> rowId = GeneratedColumn<int>(
    'row_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [rowId, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'preference_marriages';
  @override
  VerificationContext validateIntegrity(
    Insertable<PreferenceMarriage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('row_id')) {
      context.handle(
        _rowIdMeta,
        rowId.isAcceptableOrUnknown(data['row_id']!, _rowIdMeta),
      );
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {rowId};
  @override
  PreferenceMarriage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PreferenceMarriage(
      rowId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}row_id'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $PreferenceMarriagesTable createAlias(String alias) {
    return $PreferenceMarriagesTable(attachedDatabase, alias);
  }
}

class PreferenceMarriage extends DataClass
    implements Insertable<PreferenceMarriage> {
  final int rowId;
  final String value;
  const PreferenceMarriage({required this.rowId, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['row_id'] = Variable<int>(rowId);
    map['value'] = Variable<String>(value);
    return map;
  }

  PreferenceMarriagesCompanion toCompanion(bool nullToAbsent) {
    return PreferenceMarriagesCompanion(
      rowId: Value(rowId),
      value: Value(value),
    );
  }

  factory PreferenceMarriage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PreferenceMarriage(
      rowId: serializer.fromJson<int>(json['rowId']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'rowId': serializer.toJson<int>(rowId),
      'value': serializer.toJson<String>(value),
    };
  }

  PreferenceMarriage copyWith({int? rowId, String? value}) =>
      PreferenceMarriage(
        rowId: rowId ?? this.rowId,
        value: value ?? this.value,
      );
  PreferenceMarriage copyWithCompanion(PreferenceMarriagesCompanion data) {
    return PreferenceMarriage(
      rowId: data.rowId.present ? data.rowId.value : this.rowId,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PreferenceMarriage(')
          ..write('rowId: $rowId, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(rowId, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PreferenceMarriage &&
          other.rowId == this.rowId &&
          other.value == this.value);
}

class PreferenceMarriagesCompanion extends UpdateCompanion<PreferenceMarriage> {
  final Value<int> rowId;
  final Value<String> value;
  const PreferenceMarriagesCompanion({
    this.rowId = const Value.absent(),
    this.value = const Value.absent(),
  });
  PreferenceMarriagesCompanion.insert({
    this.rowId = const Value.absent(),
    required String value,
  }) : value = Value(value);
  static Insertable<PreferenceMarriage> custom({
    Expression<int>? rowId,
    Expression<String>? value,
  }) {
    return RawValuesInsertable({
      if (rowId != null) 'row_id': rowId,
      if (value != null) 'value': value,
    });
  }

  PreferenceMarriagesCompanion copyWith({
    Value<int>? rowId,
    Value<String>? value,
  }) {
    return PreferenceMarriagesCompanion(
      rowId: rowId ?? this.rowId,
      value: value ?? this.value,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (rowId.present) {
      map['row_id'] = Variable<int>(rowId.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PreferenceMarriagesCompanion(')
          ..write('rowId: $rowId, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }
}

class $PreferenceEthnicitiesTable extends PreferenceEthnicities
    with TableInfo<$PreferenceEthnicitiesTable, PreferenceEthnicity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PreferenceEthnicitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _rowIdMeta = const VerificationMeta('rowId');
  @override
  late final GeneratedColumn<int> rowId = GeneratedColumn<int>(
    'row_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [rowId, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'preference_ethnicities';
  @override
  VerificationContext validateIntegrity(
    Insertable<PreferenceEthnicity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('row_id')) {
      context.handle(
        _rowIdMeta,
        rowId.isAcceptableOrUnknown(data['row_id']!, _rowIdMeta),
      );
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {rowId};
  @override
  PreferenceEthnicity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PreferenceEthnicity(
      rowId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}row_id'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $PreferenceEthnicitiesTable createAlias(String alias) {
    return $PreferenceEthnicitiesTable(attachedDatabase, alias);
  }
}

class PreferenceEthnicity extends DataClass
    implements Insertable<PreferenceEthnicity> {
  final int rowId;
  final String value;
  const PreferenceEthnicity({required this.rowId, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['row_id'] = Variable<int>(rowId);
    map['value'] = Variable<String>(value);
    return map;
  }

  PreferenceEthnicitiesCompanion toCompanion(bool nullToAbsent) {
    return PreferenceEthnicitiesCompanion(
      rowId: Value(rowId),
      value: Value(value),
    );
  }

  factory PreferenceEthnicity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PreferenceEthnicity(
      rowId: serializer.fromJson<int>(json['rowId']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'rowId': serializer.toJson<int>(rowId),
      'value': serializer.toJson<String>(value),
    };
  }

  PreferenceEthnicity copyWith({int? rowId, String? value}) =>
      PreferenceEthnicity(
        rowId: rowId ?? this.rowId,
        value: value ?? this.value,
      );
  PreferenceEthnicity copyWithCompanion(PreferenceEthnicitiesCompanion data) {
    return PreferenceEthnicity(
      rowId: data.rowId.present ? data.rowId.value : this.rowId,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PreferenceEthnicity(')
          ..write('rowId: $rowId, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(rowId, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PreferenceEthnicity &&
          other.rowId == this.rowId &&
          other.value == this.value);
}

class PreferenceEthnicitiesCompanion
    extends UpdateCompanion<PreferenceEthnicity> {
  final Value<int> rowId;
  final Value<String> value;
  const PreferenceEthnicitiesCompanion({
    this.rowId = const Value.absent(),
    this.value = const Value.absent(),
  });
  PreferenceEthnicitiesCompanion.insert({
    this.rowId = const Value.absent(),
    required String value,
  }) : value = Value(value);
  static Insertable<PreferenceEthnicity> custom({
    Expression<int>? rowId,
    Expression<String>? value,
  }) {
    return RawValuesInsertable({
      if (rowId != null) 'row_id': rowId,
      if (value != null) 'value': value,
    });
  }

  PreferenceEthnicitiesCompanion copyWith({
    Value<int>? rowId,
    Value<String>? value,
  }) {
    return PreferenceEthnicitiesCompanion(
      rowId: rowId ?? this.rowId,
      value: value ?? this.value,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (rowId.present) {
      map['row_id'] = Variable<int>(rowId.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PreferenceEthnicitiesCompanion(')
          ..write('rowId: $rowId, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }
}

class $PreferenceReligionsTable extends PreferenceReligions
    with TableInfo<$PreferenceReligionsTable, PreferenceReligion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PreferenceReligionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _rowIdMeta = const VerificationMeta('rowId');
  @override
  late final GeneratedColumn<int> rowId = GeneratedColumn<int>(
    'row_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [rowId, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'preference_religions';
  @override
  VerificationContext validateIntegrity(
    Insertable<PreferenceReligion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('row_id')) {
      context.handle(
        _rowIdMeta,
        rowId.isAcceptableOrUnknown(data['row_id']!, _rowIdMeta),
      );
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {rowId};
  @override
  PreferenceReligion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PreferenceReligion(
      rowId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}row_id'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $PreferenceReligionsTable createAlias(String alias) {
    return $PreferenceReligionsTable(attachedDatabase, alias);
  }
}

class PreferenceReligion extends DataClass
    implements Insertable<PreferenceReligion> {
  final int rowId;
  final String value;
  const PreferenceReligion({required this.rowId, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['row_id'] = Variable<int>(rowId);
    map['value'] = Variable<String>(value);
    return map;
  }

  PreferenceReligionsCompanion toCompanion(bool nullToAbsent) {
    return PreferenceReligionsCompanion(
      rowId: Value(rowId),
      value: Value(value),
    );
  }

  factory PreferenceReligion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PreferenceReligion(
      rowId: serializer.fromJson<int>(json['rowId']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'rowId': serializer.toJson<int>(rowId),
      'value': serializer.toJson<String>(value),
    };
  }

  PreferenceReligion copyWith({int? rowId, String? value}) =>
      PreferenceReligion(
        rowId: rowId ?? this.rowId,
        value: value ?? this.value,
      );
  PreferenceReligion copyWithCompanion(PreferenceReligionsCompanion data) {
    return PreferenceReligion(
      rowId: data.rowId.present ? data.rowId.value : this.rowId,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PreferenceReligion(')
          ..write('rowId: $rowId, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(rowId, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PreferenceReligion &&
          other.rowId == this.rowId &&
          other.value == this.value);
}

class PreferenceReligionsCompanion extends UpdateCompanion<PreferenceReligion> {
  final Value<int> rowId;
  final Value<String> value;
  const PreferenceReligionsCompanion({
    this.rowId = const Value.absent(),
    this.value = const Value.absent(),
  });
  PreferenceReligionsCompanion.insert({
    this.rowId = const Value.absent(),
    required String value,
  }) : value = Value(value);
  static Insertable<PreferenceReligion> custom({
    Expression<int>? rowId,
    Expression<String>? value,
  }) {
    return RawValuesInsertable({
      if (rowId != null) 'row_id': rowId,
      if (value != null) 'value': value,
    });
  }

  PreferenceReligionsCompanion copyWith({
    Value<int>? rowId,
    Value<String>? value,
  }) {
    return PreferenceReligionsCompanion(
      rowId: rowId ?? this.rowId,
      value: value ?? this.value,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (rowId.present) {
      map['row_id'] = Variable<int>(rowId.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PreferenceReligionsCompanion(')
          ..write('rowId: $rowId, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }
}

class $PreferenceEducationsTable extends PreferenceEducations
    with TableInfo<$PreferenceEducationsTable, PreferenceEducation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PreferenceEducationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _rowIdMeta = const VerificationMeta('rowId');
  @override
  late final GeneratedColumn<int> rowId = GeneratedColumn<int>(
    'row_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [rowId, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'preference_educations';
  @override
  VerificationContext validateIntegrity(
    Insertable<PreferenceEducation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('row_id')) {
      context.handle(
        _rowIdMeta,
        rowId.isAcceptableOrUnknown(data['row_id']!, _rowIdMeta),
      );
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {rowId};
  @override
  PreferenceEducation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PreferenceEducation(
      rowId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}row_id'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $PreferenceEducationsTable createAlias(String alias) {
    return $PreferenceEducationsTable(attachedDatabase, alias);
  }
}

class PreferenceEducation extends DataClass
    implements Insertable<PreferenceEducation> {
  final int rowId;
  final String value;
  const PreferenceEducation({required this.rowId, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['row_id'] = Variable<int>(rowId);
    map['value'] = Variable<String>(value);
    return map;
  }

  PreferenceEducationsCompanion toCompanion(bool nullToAbsent) {
    return PreferenceEducationsCompanion(
      rowId: Value(rowId),
      value: Value(value),
    );
  }

  factory PreferenceEducation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PreferenceEducation(
      rowId: serializer.fromJson<int>(json['rowId']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'rowId': serializer.toJson<int>(rowId),
      'value': serializer.toJson<String>(value),
    };
  }

  PreferenceEducation copyWith({int? rowId, String? value}) =>
      PreferenceEducation(
        rowId: rowId ?? this.rowId,
        value: value ?? this.value,
      );
  PreferenceEducation copyWithCompanion(PreferenceEducationsCompanion data) {
    return PreferenceEducation(
      rowId: data.rowId.present ? data.rowId.value : this.rowId,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PreferenceEducation(')
          ..write('rowId: $rowId, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(rowId, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PreferenceEducation &&
          other.rowId == this.rowId &&
          other.value == this.value);
}

class PreferenceEducationsCompanion
    extends UpdateCompanion<PreferenceEducation> {
  final Value<int> rowId;
  final Value<String> value;
  const PreferenceEducationsCompanion({
    this.rowId = const Value.absent(),
    this.value = const Value.absent(),
  });
  PreferenceEducationsCompanion.insert({
    this.rowId = const Value.absent(),
    required String value,
  }) : value = Value(value);
  static Insertable<PreferenceEducation> custom({
    Expression<int>? rowId,
    Expression<String>? value,
  }) {
    return RawValuesInsertable({
      if (rowId != null) 'row_id': rowId,
      if (value != null) 'value': value,
    });
  }

  PreferenceEducationsCompanion copyWith({
    Value<int>? rowId,
    Value<String>? value,
  }) {
    return PreferenceEducationsCompanion(
      rowId: rowId ?? this.rowId,
      value: value ?? this.value,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (rowId.present) {
      map['row_id'] = Variable<int>(rowId.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PreferenceEducationsCompanion(')
          ..write('rowId: $rowId, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }
}

class $PreferenceDrinkingsTable extends PreferenceDrinkings
    with TableInfo<$PreferenceDrinkingsTable, PreferenceDrinking> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PreferenceDrinkingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _rowIdMeta = const VerificationMeta('rowId');
  @override
  late final GeneratedColumn<int> rowId = GeneratedColumn<int>(
    'row_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [rowId, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'preference_drinkings';
  @override
  VerificationContext validateIntegrity(
    Insertable<PreferenceDrinking> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('row_id')) {
      context.handle(
        _rowIdMeta,
        rowId.isAcceptableOrUnknown(data['row_id']!, _rowIdMeta),
      );
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {rowId};
  @override
  PreferenceDrinking map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PreferenceDrinking(
      rowId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}row_id'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $PreferenceDrinkingsTable createAlias(String alias) {
    return $PreferenceDrinkingsTable(attachedDatabase, alias);
  }
}

class PreferenceDrinking extends DataClass
    implements Insertable<PreferenceDrinking> {
  final int rowId;
  final String value;
  const PreferenceDrinking({required this.rowId, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['row_id'] = Variable<int>(rowId);
    map['value'] = Variable<String>(value);
    return map;
  }

  PreferenceDrinkingsCompanion toCompanion(bool nullToAbsent) {
    return PreferenceDrinkingsCompanion(
      rowId: Value(rowId),
      value: Value(value),
    );
  }

  factory PreferenceDrinking.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PreferenceDrinking(
      rowId: serializer.fromJson<int>(json['rowId']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'rowId': serializer.toJson<int>(rowId),
      'value': serializer.toJson<String>(value),
    };
  }

  PreferenceDrinking copyWith({int? rowId, String? value}) =>
      PreferenceDrinking(
        rowId: rowId ?? this.rowId,
        value: value ?? this.value,
      );
  PreferenceDrinking copyWithCompanion(PreferenceDrinkingsCompanion data) {
    return PreferenceDrinking(
      rowId: data.rowId.present ? data.rowId.value : this.rowId,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PreferenceDrinking(')
          ..write('rowId: $rowId, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(rowId, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PreferenceDrinking &&
          other.rowId == this.rowId &&
          other.value == this.value);
}

class PreferenceDrinkingsCompanion extends UpdateCompanion<PreferenceDrinking> {
  final Value<int> rowId;
  final Value<String> value;
  const PreferenceDrinkingsCompanion({
    this.rowId = const Value.absent(),
    this.value = const Value.absent(),
  });
  PreferenceDrinkingsCompanion.insert({
    this.rowId = const Value.absent(),
    required String value,
  }) : value = Value(value);
  static Insertable<PreferenceDrinking> custom({
    Expression<int>? rowId,
    Expression<String>? value,
  }) {
    return RawValuesInsertable({
      if (rowId != null) 'row_id': rowId,
      if (value != null) 'value': value,
    });
  }

  PreferenceDrinkingsCompanion copyWith({
    Value<int>? rowId,
    Value<String>? value,
  }) {
    return PreferenceDrinkingsCompanion(
      rowId: rowId ?? this.rowId,
      value: value ?? this.value,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (rowId.present) {
      map['row_id'] = Variable<int>(rowId.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PreferenceDrinkingsCompanion(')
          ..write('rowId: $rowId, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }
}

class $PreferenceSmokingsTable extends PreferenceSmokings
    with TableInfo<$PreferenceSmokingsTable, PreferenceSmoking> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PreferenceSmokingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _rowIdMeta = const VerificationMeta('rowId');
  @override
  late final GeneratedColumn<int> rowId = GeneratedColumn<int>(
    'row_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [rowId, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'preference_smokings';
  @override
  VerificationContext validateIntegrity(
    Insertable<PreferenceSmoking> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('row_id')) {
      context.handle(
        _rowIdMeta,
        rowId.isAcceptableOrUnknown(data['row_id']!, _rowIdMeta),
      );
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {rowId};
  @override
  PreferenceSmoking map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PreferenceSmoking(
      rowId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}row_id'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $PreferenceSmokingsTable createAlias(String alias) {
    return $PreferenceSmokingsTable(attachedDatabase, alias);
  }
}

class PreferenceSmoking extends DataClass
    implements Insertable<PreferenceSmoking> {
  final int rowId;
  final String value;
  const PreferenceSmoking({required this.rowId, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['row_id'] = Variable<int>(rowId);
    map['value'] = Variable<String>(value);
    return map;
  }

  PreferenceSmokingsCompanion toCompanion(bool nullToAbsent) {
    return PreferenceSmokingsCompanion(
      rowId: Value(rowId),
      value: Value(value),
    );
  }

  factory PreferenceSmoking.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PreferenceSmoking(
      rowId: serializer.fromJson<int>(json['rowId']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'rowId': serializer.toJson<int>(rowId),
      'value': serializer.toJson<String>(value),
    };
  }

  PreferenceSmoking copyWith({int? rowId, String? value}) =>
      PreferenceSmoking(rowId: rowId ?? this.rowId, value: value ?? this.value);
  PreferenceSmoking copyWithCompanion(PreferenceSmokingsCompanion data) {
    return PreferenceSmoking(
      rowId: data.rowId.present ? data.rowId.value : this.rowId,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PreferenceSmoking(')
          ..write('rowId: $rowId, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(rowId, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PreferenceSmoking &&
          other.rowId == this.rowId &&
          other.value == this.value);
}

class PreferenceSmokingsCompanion extends UpdateCompanion<PreferenceSmoking> {
  final Value<int> rowId;
  final Value<String> value;
  const PreferenceSmokingsCompanion({
    this.rowId = const Value.absent(),
    this.value = const Value.absent(),
  });
  PreferenceSmokingsCompanion.insert({
    this.rowId = const Value.absent(),
    required String value,
  }) : value = Value(value);
  static Insertable<PreferenceSmoking> custom({
    Expression<int>? rowId,
    Expression<String>? value,
  }) {
    return RawValuesInsertable({
      if (rowId != null) 'row_id': rowId,
      if (value != null) 'value': value,
    });
  }

  PreferenceSmokingsCompanion copyWith({
    Value<int>? rowId,
    Value<String>? value,
  }) {
    return PreferenceSmokingsCompanion(
      rowId: rowId ?? this.rowId,
      value: value ?? this.value,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (rowId.present) {
      map['row_id'] = Variable<int>(rowId.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PreferenceSmokingsCompanion(')
          ..write('rowId: $rowId, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }
}

class $PreferencePetsTable extends PreferencePets
    with TableInfo<$PreferencePetsTable, PreferencePet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PreferencePetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _rowIdMeta = const VerificationMeta('rowId');
  @override
  late final GeneratedColumn<int> rowId = GeneratedColumn<int>(
    'row_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [rowId, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'preference_pets';
  @override
  VerificationContext validateIntegrity(
    Insertable<PreferencePet> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('row_id')) {
      context.handle(
        _rowIdMeta,
        rowId.isAcceptableOrUnknown(data['row_id']!, _rowIdMeta),
      );
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {rowId};
  @override
  PreferencePet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PreferencePet(
      rowId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}row_id'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $PreferencePetsTable createAlias(String alias) {
    return $PreferencePetsTable(attachedDatabase, alias);
  }
}

class PreferencePet extends DataClass implements Insertable<PreferencePet> {
  final int rowId;
  final String value;
  const PreferencePet({required this.rowId, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['row_id'] = Variable<int>(rowId);
    map['value'] = Variable<String>(value);
    return map;
  }

  PreferencePetsCompanion toCompanion(bool nullToAbsent) {
    return PreferencePetsCompanion(rowId: Value(rowId), value: Value(value));
  }

  factory PreferencePet.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PreferencePet(
      rowId: serializer.fromJson<int>(json['rowId']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'rowId': serializer.toJson<int>(rowId),
      'value': serializer.toJson<String>(value),
    };
  }

  PreferencePet copyWith({int? rowId, String? value}) =>
      PreferencePet(rowId: rowId ?? this.rowId, value: value ?? this.value);
  PreferencePet copyWithCompanion(PreferencePetsCompanion data) {
    return PreferencePet(
      rowId: data.rowId.present ? data.rowId.value : this.rowId,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PreferencePet(')
          ..write('rowId: $rowId, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(rowId, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PreferencePet &&
          other.rowId == this.rowId &&
          other.value == this.value);
}

class PreferencePetsCompanion extends UpdateCompanion<PreferencePet> {
  final Value<int> rowId;
  final Value<String> value;
  const PreferencePetsCompanion({
    this.rowId = const Value.absent(),
    this.value = const Value.absent(),
  });
  PreferencePetsCompanion.insert({
    this.rowId = const Value.absent(),
    required String value,
  }) : value = Value(value);
  static Insertable<PreferencePet> custom({
    Expression<int>? rowId,
    Expression<String>? value,
  }) {
    return RawValuesInsertable({
      if (rowId != null) 'row_id': rowId,
      if (value != null) 'value': value,
    });
  }

  PreferencePetsCompanion copyWith({Value<int>? rowId, Value<String>? value}) {
    return PreferencePetsCompanion(
      rowId: rowId ?? this.rowId,
      value: value ?? this.value,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (rowId.present) {
      map['row_id'] = Variable<int>(rowId.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PreferencePetsCompanion(')
          ..write('rowId: $rowId, ')
          ..write('value: $value')
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
  late final $ProfilesTable profiles = $ProfilesTable(this);
  late final $LoveLanguagesTable loveLanguages = $LoveLanguagesTable(this);
  late final $ProfileInterestsTable profileInterests = $ProfileInterestsTable(
    this,
  );
  late final $PhotosTable photos = $PhotosTable(this);
  late final $PreferenceChildrenTable preferenceChildren =
      $PreferenceChildrenTable(this);
  late final $PreferenceMarriagesTable preferenceMarriages =
      $PreferenceMarriagesTable(this);
  late final $PreferenceEthnicitiesTable preferenceEthnicities =
      $PreferenceEthnicitiesTable(this);
  late final $PreferenceReligionsTable preferenceReligions =
      $PreferenceReligionsTable(this);
  late final $PreferenceEducationsTable preferenceEducations =
      $PreferenceEducationsTable(this);
  late final $PreferenceDrinkingsTable preferenceDrinkings =
      $PreferenceDrinkingsTable(this);
  late final $PreferenceSmokingsTable preferenceSmokings =
      $PreferenceSmokingsTable(this);
  late final $PreferencePetsTable preferencePets = $PreferencePetsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    cachedInterests,
    profiles,
    loveLanguages,
    profileInterests,
    photos,
    preferenceChildren,
    preferenceMarriages,
    preferenceEthnicities,
    preferenceReligions,
    preferenceEducations,
    preferenceDrinkings,
    preferenceSmokings,
    preferencePets,
  ];
}

typedef $$CachedInterestsTableCreateCompanionBuilder =
    CachedInterestsCompanion Function({
      Value<int> id,
      required String slug,
      Value<String> category,
    });
typedef $$CachedInterestsTableUpdateCompanionBuilder =
    CachedInterestsCompanion Function({
      Value<int> id,
      Value<String> slug,
      Value<String> category,
    });

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

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
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

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
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

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);
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
                Value<String> category = const Value.absent(),
              }) => CachedInterestsCompanion(
                id: id,
                slug: slug,
                category: category,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String slug,
                Value<String> category = const Value.absent(),
              }) => CachedInterestsCompanion.insert(
                id: id,
                slug: slug,
                category: category,
              ),
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
typedef $$ProfilesTableCreateCompanionBuilder =
    ProfilesCompanion Function({
      Value<int> id,
      Value<String?> nickName,
      required String fullName,
      Value<int?> age,
      Value<String?> bio,
      Value<String?> occupation,
      Value<String?> education,
      Value<int?> heightCm,
      Value<String?> gender,
      Value<String?> ethnicity,
      Value<String?> religion,
      Value<String?> relationshipGoal,
      Value<String?> drinking,
      Value<String?> smoking,
      Value<String?> petPreference,
      Value<String?> childrenPreference,
      Value<String?> marriagePreference,
      required int completenessPercent,
      Value<int?> preferenceAgeMin,
      Value<int?> preferenceAgeMax,
      Value<String?> preferenceGenderPreference,
      Value<bool> hasPreferences,
    });
typedef $$ProfilesTableUpdateCompanionBuilder =
    ProfilesCompanion Function({
      Value<int> id,
      Value<String?> nickName,
      Value<String> fullName,
      Value<int?> age,
      Value<String?> bio,
      Value<String?> occupation,
      Value<String?> education,
      Value<int?> heightCm,
      Value<String?> gender,
      Value<String?> ethnicity,
      Value<String?> religion,
      Value<String?> relationshipGoal,
      Value<String?> drinking,
      Value<String?> smoking,
      Value<String?> petPreference,
      Value<String?> childrenPreference,
      Value<String?> marriagePreference,
      Value<int> completenessPercent,
      Value<int?> preferenceAgeMin,
      Value<int?> preferenceAgeMax,
      Value<String?> preferenceGenderPreference,
      Value<bool> hasPreferences,
    });

class $$ProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableFilterComposer({
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

  ColumnFilters<String> get nickName => $composableBuilder(
    column: $table.nickName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bio => $composableBuilder(
    column: $table.bio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get occupation => $composableBuilder(
    column: $table.occupation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get education => $composableBuilder(
    column: $table.education,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ethnicity => $composableBuilder(
    column: $table.ethnicity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get religion => $composableBuilder(
    column: $table.religion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relationshipGoal => $composableBuilder(
    column: $table.relationshipGoal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get drinking => $composableBuilder(
    column: $table.drinking,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get smoking => $composableBuilder(
    column: $table.smoking,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get petPreference => $composableBuilder(
    column: $table.petPreference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get childrenPreference => $composableBuilder(
    column: $table.childrenPreference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get marriagePreference => $composableBuilder(
    column: $table.marriagePreference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completenessPercent => $composableBuilder(
    column: $table.completenessPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get preferenceAgeMin => $composableBuilder(
    column: $table.preferenceAgeMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get preferenceAgeMax => $composableBuilder(
    column: $table.preferenceAgeMax,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preferenceGenderPreference => $composableBuilder(
    column: $table.preferenceGenderPreference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasPreferences => $composableBuilder(
    column: $table.hasPreferences,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableOrderingComposer({
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

  ColumnOrderings<String> get nickName => $composableBuilder(
    column: $table.nickName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bio => $composableBuilder(
    column: $table.bio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get occupation => $composableBuilder(
    column: $table.occupation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get education => $composableBuilder(
    column: $table.education,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ethnicity => $composableBuilder(
    column: $table.ethnicity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get religion => $composableBuilder(
    column: $table.religion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relationshipGoal => $composableBuilder(
    column: $table.relationshipGoal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get drinking => $composableBuilder(
    column: $table.drinking,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get smoking => $composableBuilder(
    column: $table.smoking,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get petPreference => $composableBuilder(
    column: $table.petPreference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get childrenPreference => $composableBuilder(
    column: $table.childrenPreference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get marriagePreference => $composableBuilder(
    column: $table.marriagePreference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completenessPercent => $composableBuilder(
    column: $table.completenessPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get preferenceAgeMin => $composableBuilder(
    column: $table.preferenceAgeMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get preferenceAgeMax => $composableBuilder(
    column: $table.preferenceAgeMax,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preferenceGenderPreference => $composableBuilder(
    column: $table.preferenceGenderPreference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasPreferences => $composableBuilder(
    column: $table.hasPreferences,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nickName =>
      $composableBuilder(column: $table.nickName, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<int> get age =>
      $composableBuilder(column: $table.age, builder: (column) => column);

  GeneratedColumn<String> get bio =>
      $composableBuilder(column: $table.bio, builder: (column) => column);

  GeneratedColumn<String> get occupation => $composableBuilder(
    column: $table.occupation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get education =>
      $composableBuilder(column: $table.education, builder: (column) => column);

  GeneratedColumn<int> get heightCm =>
      $composableBuilder(column: $table.heightCm, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<String> get ethnicity =>
      $composableBuilder(column: $table.ethnicity, builder: (column) => column);

  GeneratedColumn<String> get religion =>
      $composableBuilder(column: $table.religion, builder: (column) => column);

  GeneratedColumn<String> get relationshipGoal => $composableBuilder(
    column: $table.relationshipGoal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get drinking =>
      $composableBuilder(column: $table.drinking, builder: (column) => column);

  GeneratedColumn<String> get smoking =>
      $composableBuilder(column: $table.smoking, builder: (column) => column);

  GeneratedColumn<String> get petPreference => $composableBuilder(
    column: $table.petPreference,
    builder: (column) => column,
  );

  GeneratedColumn<String> get childrenPreference => $composableBuilder(
    column: $table.childrenPreference,
    builder: (column) => column,
  );

  GeneratedColumn<String> get marriagePreference => $composableBuilder(
    column: $table.marriagePreference,
    builder: (column) => column,
  );

  GeneratedColumn<int> get completenessPercent => $composableBuilder(
    column: $table.completenessPercent,
    builder: (column) => column,
  );

  GeneratedColumn<int> get preferenceAgeMin => $composableBuilder(
    column: $table.preferenceAgeMin,
    builder: (column) => column,
  );

  GeneratedColumn<int> get preferenceAgeMax => $composableBuilder(
    column: $table.preferenceAgeMax,
    builder: (column) => column,
  );

  GeneratedColumn<String> get preferenceGenderPreference => $composableBuilder(
    column: $table.preferenceGenderPreference,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hasPreferences => $composableBuilder(
    column: $table.hasPreferences,
    builder: (column) => column,
  );
}

class $$ProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProfilesTable,
          Profile,
          $$ProfilesTableFilterComposer,
          $$ProfilesTableOrderingComposer,
          $$ProfilesTableAnnotationComposer,
          $$ProfilesTableCreateCompanionBuilder,
          $$ProfilesTableUpdateCompanionBuilder,
          (Profile, BaseReferences<_$AppDatabase, $ProfilesTable, Profile>),
          Profile,
          PrefetchHooks Function()
        > {
  $$ProfilesTableTableManager(_$AppDatabase db, $ProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> nickName = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<int?> age = const Value.absent(),
                Value<String?> bio = const Value.absent(),
                Value<String?> occupation = const Value.absent(),
                Value<String?> education = const Value.absent(),
                Value<int?> heightCm = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                Value<String?> ethnicity = const Value.absent(),
                Value<String?> religion = const Value.absent(),
                Value<String?> relationshipGoal = const Value.absent(),
                Value<String?> drinking = const Value.absent(),
                Value<String?> smoking = const Value.absent(),
                Value<String?> petPreference = const Value.absent(),
                Value<String?> childrenPreference = const Value.absent(),
                Value<String?> marriagePreference = const Value.absent(),
                Value<int> completenessPercent = const Value.absent(),
                Value<int?> preferenceAgeMin = const Value.absent(),
                Value<int?> preferenceAgeMax = const Value.absent(),
                Value<String?> preferenceGenderPreference =
                    const Value.absent(),
                Value<bool> hasPreferences = const Value.absent(),
              }) => ProfilesCompanion(
                id: id,
                nickName: nickName,
                fullName: fullName,
                age: age,
                bio: bio,
                occupation: occupation,
                education: education,
                heightCm: heightCm,
                gender: gender,
                ethnicity: ethnicity,
                religion: religion,
                relationshipGoal: relationshipGoal,
                drinking: drinking,
                smoking: smoking,
                petPreference: petPreference,
                childrenPreference: childrenPreference,
                marriagePreference: marriagePreference,
                completenessPercent: completenessPercent,
                preferenceAgeMin: preferenceAgeMin,
                preferenceAgeMax: preferenceAgeMax,
                preferenceGenderPreference: preferenceGenderPreference,
                hasPreferences: hasPreferences,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> nickName = const Value.absent(),
                required String fullName,
                Value<int?> age = const Value.absent(),
                Value<String?> bio = const Value.absent(),
                Value<String?> occupation = const Value.absent(),
                Value<String?> education = const Value.absent(),
                Value<int?> heightCm = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                Value<String?> ethnicity = const Value.absent(),
                Value<String?> religion = const Value.absent(),
                Value<String?> relationshipGoal = const Value.absent(),
                Value<String?> drinking = const Value.absent(),
                Value<String?> smoking = const Value.absent(),
                Value<String?> petPreference = const Value.absent(),
                Value<String?> childrenPreference = const Value.absent(),
                Value<String?> marriagePreference = const Value.absent(),
                required int completenessPercent,
                Value<int?> preferenceAgeMin = const Value.absent(),
                Value<int?> preferenceAgeMax = const Value.absent(),
                Value<String?> preferenceGenderPreference =
                    const Value.absent(),
                Value<bool> hasPreferences = const Value.absent(),
              }) => ProfilesCompanion.insert(
                id: id,
                nickName: nickName,
                fullName: fullName,
                age: age,
                bio: bio,
                occupation: occupation,
                education: education,
                heightCm: heightCm,
                gender: gender,
                ethnicity: ethnicity,
                religion: religion,
                relationshipGoal: relationshipGoal,
                drinking: drinking,
                smoking: smoking,
                petPreference: petPreference,
                childrenPreference: childrenPreference,
                marriagePreference: marriagePreference,
                completenessPercent: completenessPercent,
                preferenceAgeMin: preferenceAgeMin,
                preferenceAgeMax: preferenceAgeMax,
                preferenceGenderPreference: preferenceGenderPreference,
                hasPreferences: hasPreferences,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProfilesTable,
      Profile,
      $$ProfilesTableFilterComposer,
      $$ProfilesTableOrderingComposer,
      $$ProfilesTableAnnotationComposer,
      $$ProfilesTableCreateCompanionBuilder,
      $$ProfilesTableUpdateCompanionBuilder,
      (Profile, BaseReferences<_$AppDatabase, $ProfilesTable, Profile>),
      Profile,
      PrefetchHooks Function()
    >;
typedef $$LoveLanguagesTableCreateCompanionBuilder =
    LoveLanguagesCompanion Function({Value<int> rowId, required String value});
typedef $$LoveLanguagesTableUpdateCompanionBuilder =
    LoveLanguagesCompanion Function({Value<int> rowId, Value<String> value});

class $$LoveLanguagesTableFilterComposer
    extends Composer<_$AppDatabase, $LoveLanguagesTable> {
  $$LoveLanguagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LoveLanguagesTableOrderingComposer
    extends Composer<_$AppDatabase, $LoveLanguagesTable> {
  $$LoveLanguagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LoveLanguagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LoveLanguagesTable> {
  $$LoveLanguagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get rowId =>
      $composableBuilder(column: $table.rowId, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$LoveLanguagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LoveLanguagesTable,
          LoveLanguage,
          $$LoveLanguagesTableFilterComposer,
          $$LoveLanguagesTableOrderingComposer,
          $$LoveLanguagesTableAnnotationComposer,
          $$LoveLanguagesTableCreateCompanionBuilder,
          $$LoveLanguagesTableUpdateCompanionBuilder,
          (
            LoveLanguage,
            BaseReferences<_$AppDatabase, $LoveLanguagesTable, LoveLanguage>,
          ),
          LoveLanguage,
          PrefetchHooks Function()
        > {
  $$LoveLanguagesTableTableManager(_$AppDatabase db, $LoveLanguagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LoveLanguagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LoveLanguagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LoveLanguagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                Value<String> value = const Value.absent(),
              }) => LoveLanguagesCompanion(rowId: rowId, value: value),
          createCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                required String value,
              }) => LoveLanguagesCompanion.insert(rowId: rowId, value: value),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LoveLanguagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LoveLanguagesTable,
      LoveLanguage,
      $$LoveLanguagesTableFilterComposer,
      $$LoveLanguagesTableOrderingComposer,
      $$LoveLanguagesTableAnnotationComposer,
      $$LoveLanguagesTableCreateCompanionBuilder,
      $$LoveLanguagesTableUpdateCompanionBuilder,
      (
        LoveLanguage,
        BaseReferences<_$AppDatabase, $LoveLanguagesTable, LoveLanguage>,
      ),
      LoveLanguage,
      PrefetchHooks Function()
    >;
typedef $$ProfileInterestsTableCreateCompanionBuilder =
    ProfileInterestsCompanion Function({
      Value<int> rowId,
      required String value,
    });
typedef $$ProfileInterestsTableUpdateCompanionBuilder =
    ProfileInterestsCompanion Function({Value<int> rowId, Value<String> value});

class $$ProfileInterestsTableFilterComposer
    extends Composer<_$AppDatabase, $ProfileInterestsTable> {
  $$ProfileInterestsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProfileInterestsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfileInterestsTable> {
  $$ProfileInterestsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProfileInterestsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfileInterestsTable> {
  $$ProfileInterestsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get rowId =>
      $composableBuilder(column: $table.rowId, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$ProfileInterestsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProfileInterestsTable,
          ProfileInterest,
          $$ProfileInterestsTableFilterComposer,
          $$ProfileInterestsTableOrderingComposer,
          $$ProfileInterestsTableAnnotationComposer,
          $$ProfileInterestsTableCreateCompanionBuilder,
          $$ProfileInterestsTableUpdateCompanionBuilder,
          (
            ProfileInterest,
            BaseReferences<
              _$AppDatabase,
              $ProfileInterestsTable,
              ProfileInterest
            >,
          ),
          ProfileInterest,
          PrefetchHooks Function()
        > {
  $$ProfileInterestsTableTableManager(
    _$AppDatabase db,
    $ProfileInterestsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfileInterestsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfileInterestsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfileInterestsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                Value<String> value = const Value.absent(),
              }) => ProfileInterestsCompanion(rowId: rowId, value: value),
          createCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                required String value,
              }) =>
                  ProfileInterestsCompanion.insert(rowId: rowId, value: value),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProfileInterestsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProfileInterestsTable,
      ProfileInterest,
      $$ProfileInterestsTableFilterComposer,
      $$ProfileInterestsTableOrderingComposer,
      $$ProfileInterestsTableAnnotationComposer,
      $$ProfileInterestsTableCreateCompanionBuilder,
      $$ProfileInterestsTableUpdateCompanionBuilder,
      (
        ProfileInterest,
        BaseReferences<_$AppDatabase, $ProfileInterestsTable, ProfileInterest>,
      ),
      ProfileInterest,
      PrefetchHooks Function()
    >;
typedef $$PhotosTableCreateCompanionBuilder =
    PhotosCompanion Function({
      Value<int> rowId,
      required String path,
      required int position,
      required bool isMain,
    });
typedef $$PhotosTableUpdateCompanionBuilder =
    PhotosCompanion Function({
      Value<int> rowId,
      Value<String> path,
      Value<int> position,
      Value<bool> isMain,
    });

class $$PhotosTableFilterComposer
    extends Composer<_$AppDatabase, $PhotosTable> {
  $$PhotosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isMain => $composableBuilder(
    column: $table.isMain,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PhotosTableOrderingComposer
    extends Composer<_$AppDatabase, $PhotosTable> {
  $$PhotosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isMain => $composableBuilder(
    column: $table.isMain,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PhotosTableAnnotationComposer
    extends Composer<_$AppDatabase, $PhotosTable> {
  $$PhotosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get rowId =>
      $composableBuilder(column: $table.rowId, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<bool> get isMain =>
      $composableBuilder(column: $table.isMain, builder: (column) => column);
}

class $$PhotosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PhotosTable,
          Photo,
          $$PhotosTableFilterComposer,
          $$PhotosTableOrderingComposer,
          $$PhotosTableAnnotationComposer,
          $$PhotosTableCreateCompanionBuilder,
          $$PhotosTableUpdateCompanionBuilder,
          (Photo, BaseReferences<_$AppDatabase, $PhotosTable, Photo>),
          Photo,
          PrefetchHooks Function()
        > {
  $$PhotosTableTableManager(_$AppDatabase db, $PhotosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PhotosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PhotosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PhotosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                Value<String> path = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<bool> isMain = const Value.absent(),
              }) => PhotosCompanion(
                rowId: rowId,
                path: path,
                position: position,
                isMain: isMain,
              ),
          createCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                required String path,
                required int position,
                required bool isMain,
              }) => PhotosCompanion.insert(
                rowId: rowId,
                path: path,
                position: position,
                isMain: isMain,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PhotosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PhotosTable,
      Photo,
      $$PhotosTableFilterComposer,
      $$PhotosTableOrderingComposer,
      $$PhotosTableAnnotationComposer,
      $$PhotosTableCreateCompanionBuilder,
      $$PhotosTableUpdateCompanionBuilder,
      (Photo, BaseReferences<_$AppDatabase, $PhotosTable, Photo>),
      Photo,
      PrefetchHooks Function()
    >;
typedef $$PreferenceChildrenTableCreateCompanionBuilder =
    PreferenceChildrenCompanion Function({
      Value<int> rowId,
      required String value,
    });
typedef $$PreferenceChildrenTableUpdateCompanionBuilder =
    PreferenceChildrenCompanion Function({
      Value<int> rowId,
      Value<String> value,
    });

class $$PreferenceChildrenTableFilterComposer
    extends Composer<_$AppDatabase, $PreferenceChildrenTable> {
  $$PreferenceChildrenTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PreferenceChildrenTableOrderingComposer
    extends Composer<_$AppDatabase, $PreferenceChildrenTable> {
  $$PreferenceChildrenTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PreferenceChildrenTableAnnotationComposer
    extends Composer<_$AppDatabase, $PreferenceChildrenTable> {
  $$PreferenceChildrenTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get rowId =>
      $composableBuilder(column: $table.rowId, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$PreferenceChildrenTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PreferenceChildrenTable,
          PreferenceChildrenData,
          $$PreferenceChildrenTableFilterComposer,
          $$PreferenceChildrenTableOrderingComposer,
          $$PreferenceChildrenTableAnnotationComposer,
          $$PreferenceChildrenTableCreateCompanionBuilder,
          $$PreferenceChildrenTableUpdateCompanionBuilder,
          (
            PreferenceChildrenData,
            BaseReferences<
              _$AppDatabase,
              $PreferenceChildrenTable,
              PreferenceChildrenData
            >,
          ),
          PreferenceChildrenData,
          PrefetchHooks Function()
        > {
  $$PreferenceChildrenTableTableManager(
    _$AppDatabase db,
    $PreferenceChildrenTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PreferenceChildrenTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PreferenceChildrenTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PreferenceChildrenTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                Value<String> value = const Value.absent(),
              }) => PreferenceChildrenCompanion(rowId: rowId, value: value),
          createCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                required String value,
              }) => PreferenceChildrenCompanion.insert(
                rowId: rowId,
                value: value,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PreferenceChildrenTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PreferenceChildrenTable,
      PreferenceChildrenData,
      $$PreferenceChildrenTableFilterComposer,
      $$PreferenceChildrenTableOrderingComposer,
      $$PreferenceChildrenTableAnnotationComposer,
      $$PreferenceChildrenTableCreateCompanionBuilder,
      $$PreferenceChildrenTableUpdateCompanionBuilder,
      (
        PreferenceChildrenData,
        BaseReferences<
          _$AppDatabase,
          $PreferenceChildrenTable,
          PreferenceChildrenData
        >,
      ),
      PreferenceChildrenData,
      PrefetchHooks Function()
    >;
typedef $$PreferenceMarriagesTableCreateCompanionBuilder =
    PreferenceMarriagesCompanion Function({
      Value<int> rowId,
      required String value,
    });
typedef $$PreferenceMarriagesTableUpdateCompanionBuilder =
    PreferenceMarriagesCompanion Function({
      Value<int> rowId,
      Value<String> value,
    });

class $$PreferenceMarriagesTableFilterComposer
    extends Composer<_$AppDatabase, $PreferenceMarriagesTable> {
  $$PreferenceMarriagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PreferenceMarriagesTableOrderingComposer
    extends Composer<_$AppDatabase, $PreferenceMarriagesTable> {
  $$PreferenceMarriagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PreferenceMarriagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PreferenceMarriagesTable> {
  $$PreferenceMarriagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get rowId =>
      $composableBuilder(column: $table.rowId, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$PreferenceMarriagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PreferenceMarriagesTable,
          PreferenceMarriage,
          $$PreferenceMarriagesTableFilterComposer,
          $$PreferenceMarriagesTableOrderingComposer,
          $$PreferenceMarriagesTableAnnotationComposer,
          $$PreferenceMarriagesTableCreateCompanionBuilder,
          $$PreferenceMarriagesTableUpdateCompanionBuilder,
          (
            PreferenceMarriage,
            BaseReferences<
              _$AppDatabase,
              $PreferenceMarriagesTable,
              PreferenceMarriage
            >,
          ),
          PreferenceMarriage,
          PrefetchHooks Function()
        > {
  $$PreferenceMarriagesTableTableManager(
    _$AppDatabase db,
    $PreferenceMarriagesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PreferenceMarriagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PreferenceMarriagesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PreferenceMarriagesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                Value<String> value = const Value.absent(),
              }) => PreferenceMarriagesCompanion(rowId: rowId, value: value),
          createCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                required String value,
              }) => PreferenceMarriagesCompanion.insert(
                rowId: rowId,
                value: value,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PreferenceMarriagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PreferenceMarriagesTable,
      PreferenceMarriage,
      $$PreferenceMarriagesTableFilterComposer,
      $$PreferenceMarriagesTableOrderingComposer,
      $$PreferenceMarriagesTableAnnotationComposer,
      $$PreferenceMarriagesTableCreateCompanionBuilder,
      $$PreferenceMarriagesTableUpdateCompanionBuilder,
      (
        PreferenceMarriage,
        BaseReferences<
          _$AppDatabase,
          $PreferenceMarriagesTable,
          PreferenceMarriage
        >,
      ),
      PreferenceMarriage,
      PrefetchHooks Function()
    >;
typedef $$PreferenceEthnicitiesTableCreateCompanionBuilder =
    PreferenceEthnicitiesCompanion Function({
      Value<int> rowId,
      required String value,
    });
typedef $$PreferenceEthnicitiesTableUpdateCompanionBuilder =
    PreferenceEthnicitiesCompanion Function({
      Value<int> rowId,
      Value<String> value,
    });

class $$PreferenceEthnicitiesTableFilterComposer
    extends Composer<_$AppDatabase, $PreferenceEthnicitiesTable> {
  $$PreferenceEthnicitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PreferenceEthnicitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $PreferenceEthnicitiesTable> {
  $$PreferenceEthnicitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PreferenceEthnicitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PreferenceEthnicitiesTable> {
  $$PreferenceEthnicitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get rowId =>
      $composableBuilder(column: $table.rowId, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$PreferenceEthnicitiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PreferenceEthnicitiesTable,
          PreferenceEthnicity,
          $$PreferenceEthnicitiesTableFilterComposer,
          $$PreferenceEthnicitiesTableOrderingComposer,
          $$PreferenceEthnicitiesTableAnnotationComposer,
          $$PreferenceEthnicitiesTableCreateCompanionBuilder,
          $$PreferenceEthnicitiesTableUpdateCompanionBuilder,
          (
            PreferenceEthnicity,
            BaseReferences<
              _$AppDatabase,
              $PreferenceEthnicitiesTable,
              PreferenceEthnicity
            >,
          ),
          PreferenceEthnicity,
          PrefetchHooks Function()
        > {
  $$PreferenceEthnicitiesTableTableManager(
    _$AppDatabase db,
    $PreferenceEthnicitiesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PreferenceEthnicitiesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$PreferenceEthnicitiesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PreferenceEthnicitiesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                Value<String> value = const Value.absent(),
              }) => PreferenceEthnicitiesCompanion(rowId: rowId, value: value),
          createCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                required String value,
              }) => PreferenceEthnicitiesCompanion.insert(
                rowId: rowId,
                value: value,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PreferenceEthnicitiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PreferenceEthnicitiesTable,
      PreferenceEthnicity,
      $$PreferenceEthnicitiesTableFilterComposer,
      $$PreferenceEthnicitiesTableOrderingComposer,
      $$PreferenceEthnicitiesTableAnnotationComposer,
      $$PreferenceEthnicitiesTableCreateCompanionBuilder,
      $$PreferenceEthnicitiesTableUpdateCompanionBuilder,
      (
        PreferenceEthnicity,
        BaseReferences<
          _$AppDatabase,
          $PreferenceEthnicitiesTable,
          PreferenceEthnicity
        >,
      ),
      PreferenceEthnicity,
      PrefetchHooks Function()
    >;
typedef $$PreferenceReligionsTableCreateCompanionBuilder =
    PreferenceReligionsCompanion Function({
      Value<int> rowId,
      required String value,
    });
typedef $$PreferenceReligionsTableUpdateCompanionBuilder =
    PreferenceReligionsCompanion Function({
      Value<int> rowId,
      Value<String> value,
    });

class $$PreferenceReligionsTableFilterComposer
    extends Composer<_$AppDatabase, $PreferenceReligionsTable> {
  $$PreferenceReligionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PreferenceReligionsTableOrderingComposer
    extends Composer<_$AppDatabase, $PreferenceReligionsTable> {
  $$PreferenceReligionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PreferenceReligionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PreferenceReligionsTable> {
  $$PreferenceReligionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get rowId =>
      $composableBuilder(column: $table.rowId, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$PreferenceReligionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PreferenceReligionsTable,
          PreferenceReligion,
          $$PreferenceReligionsTableFilterComposer,
          $$PreferenceReligionsTableOrderingComposer,
          $$PreferenceReligionsTableAnnotationComposer,
          $$PreferenceReligionsTableCreateCompanionBuilder,
          $$PreferenceReligionsTableUpdateCompanionBuilder,
          (
            PreferenceReligion,
            BaseReferences<
              _$AppDatabase,
              $PreferenceReligionsTable,
              PreferenceReligion
            >,
          ),
          PreferenceReligion,
          PrefetchHooks Function()
        > {
  $$PreferenceReligionsTableTableManager(
    _$AppDatabase db,
    $PreferenceReligionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PreferenceReligionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PreferenceReligionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PreferenceReligionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                Value<String> value = const Value.absent(),
              }) => PreferenceReligionsCompanion(rowId: rowId, value: value),
          createCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                required String value,
              }) => PreferenceReligionsCompanion.insert(
                rowId: rowId,
                value: value,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PreferenceReligionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PreferenceReligionsTable,
      PreferenceReligion,
      $$PreferenceReligionsTableFilterComposer,
      $$PreferenceReligionsTableOrderingComposer,
      $$PreferenceReligionsTableAnnotationComposer,
      $$PreferenceReligionsTableCreateCompanionBuilder,
      $$PreferenceReligionsTableUpdateCompanionBuilder,
      (
        PreferenceReligion,
        BaseReferences<
          _$AppDatabase,
          $PreferenceReligionsTable,
          PreferenceReligion
        >,
      ),
      PreferenceReligion,
      PrefetchHooks Function()
    >;
typedef $$PreferenceEducationsTableCreateCompanionBuilder =
    PreferenceEducationsCompanion Function({
      Value<int> rowId,
      required String value,
    });
typedef $$PreferenceEducationsTableUpdateCompanionBuilder =
    PreferenceEducationsCompanion Function({
      Value<int> rowId,
      Value<String> value,
    });

class $$PreferenceEducationsTableFilterComposer
    extends Composer<_$AppDatabase, $PreferenceEducationsTable> {
  $$PreferenceEducationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PreferenceEducationsTableOrderingComposer
    extends Composer<_$AppDatabase, $PreferenceEducationsTable> {
  $$PreferenceEducationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PreferenceEducationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PreferenceEducationsTable> {
  $$PreferenceEducationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get rowId =>
      $composableBuilder(column: $table.rowId, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$PreferenceEducationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PreferenceEducationsTable,
          PreferenceEducation,
          $$PreferenceEducationsTableFilterComposer,
          $$PreferenceEducationsTableOrderingComposer,
          $$PreferenceEducationsTableAnnotationComposer,
          $$PreferenceEducationsTableCreateCompanionBuilder,
          $$PreferenceEducationsTableUpdateCompanionBuilder,
          (
            PreferenceEducation,
            BaseReferences<
              _$AppDatabase,
              $PreferenceEducationsTable,
              PreferenceEducation
            >,
          ),
          PreferenceEducation,
          PrefetchHooks Function()
        > {
  $$PreferenceEducationsTableTableManager(
    _$AppDatabase db,
    $PreferenceEducationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PreferenceEducationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PreferenceEducationsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PreferenceEducationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                Value<String> value = const Value.absent(),
              }) => PreferenceEducationsCompanion(rowId: rowId, value: value),
          createCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                required String value,
              }) => PreferenceEducationsCompanion.insert(
                rowId: rowId,
                value: value,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PreferenceEducationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PreferenceEducationsTable,
      PreferenceEducation,
      $$PreferenceEducationsTableFilterComposer,
      $$PreferenceEducationsTableOrderingComposer,
      $$PreferenceEducationsTableAnnotationComposer,
      $$PreferenceEducationsTableCreateCompanionBuilder,
      $$PreferenceEducationsTableUpdateCompanionBuilder,
      (
        PreferenceEducation,
        BaseReferences<
          _$AppDatabase,
          $PreferenceEducationsTable,
          PreferenceEducation
        >,
      ),
      PreferenceEducation,
      PrefetchHooks Function()
    >;
typedef $$PreferenceDrinkingsTableCreateCompanionBuilder =
    PreferenceDrinkingsCompanion Function({
      Value<int> rowId,
      required String value,
    });
typedef $$PreferenceDrinkingsTableUpdateCompanionBuilder =
    PreferenceDrinkingsCompanion Function({
      Value<int> rowId,
      Value<String> value,
    });

class $$PreferenceDrinkingsTableFilterComposer
    extends Composer<_$AppDatabase, $PreferenceDrinkingsTable> {
  $$PreferenceDrinkingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PreferenceDrinkingsTableOrderingComposer
    extends Composer<_$AppDatabase, $PreferenceDrinkingsTable> {
  $$PreferenceDrinkingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PreferenceDrinkingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PreferenceDrinkingsTable> {
  $$PreferenceDrinkingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get rowId =>
      $composableBuilder(column: $table.rowId, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$PreferenceDrinkingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PreferenceDrinkingsTable,
          PreferenceDrinking,
          $$PreferenceDrinkingsTableFilterComposer,
          $$PreferenceDrinkingsTableOrderingComposer,
          $$PreferenceDrinkingsTableAnnotationComposer,
          $$PreferenceDrinkingsTableCreateCompanionBuilder,
          $$PreferenceDrinkingsTableUpdateCompanionBuilder,
          (
            PreferenceDrinking,
            BaseReferences<
              _$AppDatabase,
              $PreferenceDrinkingsTable,
              PreferenceDrinking
            >,
          ),
          PreferenceDrinking,
          PrefetchHooks Function()
        > {
  $$PreferenceDrinkingsTableTableManager(
    _$AppDatabase db,
    $PreferenceDrinkingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PreferenceDrinkingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PreferenceDrinkingsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PreferenceDrinkingsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                Value<String> value = const Value.absent(),
              }) => PreferenceDrinkingsCompanion(rowId: rowId, value: value),
          createCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                required String value,
              }) => PreferenceDrinkingsCompanion.insert(
                rowId: rowId,
                value: value,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PreferenceDrinkingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PreferenceDrinkingsTable,
      PreferenceDrinking,
      $$PreferenceDrinkingsTableFilterComposer,
      $$PreferenceDrinkingsTableOrderingComposer,
      $$PreferenceDrinkingsTableAnnotationComposer,
      $$PreferenceDrinkingsTableCreateCompanionBuilder,
      $$PreferenceDrinkingsTableUpdateCompanionBuilder,
      (
        PreferenceDrinking,
        BaseReferences<
          _$AppDatabase,
          $PreferenceDrinkingsTable,
          PreferenceDrinking
        >,
      ),
      PreferenceDrinking,
      PrefetchHooks Function()
    >;
typedef $$PreferenceSmokingsTableCreateCompanionBuilder =
    PreferenceSmokingsCompanion Function({
      Value<int> rowId,
      required String value,
    });
typedef $$PreferenceSmokingsTableUpdateCompanionBuilder =
    PreferenceSmokingsCompanion Function({
      Value<int> rowId,
      Value<String> value,
    });

class $$PreferenceSmokingsTableFilterComposer
    extends Composer<_$AppDatabase, $PreferenceSmokingsTable> {
  $$PreferenceSmokingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PreferenceSmokingsTableOrderingComposer
    extends Composer<_$AppDatabase, $PreferenceSmokingsTable> {
  $$PreferenceSmokingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PreferenceSmokingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PreferenceSmokingsTable> {
  $$PreferenceSmokingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get rowId =>
      $composableBuilder(column: $table.rowId, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$PreferenceSmokingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PreferenceSmokingsTable,
          PreferenceSmoking,
          $$PreferenceSmokingsTableFilterComposer,
          $$PreferenceSmokingsTableOrderingComposer,
          $$PreferenceSmokingsTableAnnotationComposer,
          $$PreferenceSmokingsTableCreateCompanionBuilder,
          $$PreferenceSmokingsTableUpdateCompanionBuilder,
          (
            PreferenceSmoking,
            BaseReferences<
              _$AppDatabase,
              $PreferenceSmokingsTable,
              PreferenceSmoking
            >,
          ),
          PreferenceSmoking,
          PrefetchHooks Function()
        > {
  $$PreferenceSmokingsTableTableManager(
    _$AppDatabase db,
    $PreferenceSmokingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PreferenceSmokingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PreferenceSmokingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PreferenceSmokingsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                Value<String> value = const Value.absent(),
              }) => PreferenceSmokingsCompanion(rowId: rowId, value: value),
          createCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                required String value,
              }) => PreferenceSmokingsCompanion.insert(
                rowId: rowId,
                value: value,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PreferenceSmokingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PreferenceSmokingsTable,
      PreferenceSmoking,
      $$PreferenceSmokingsTableFilterComposer,
      $$PreferenceSmokingsTableOrderingComposer,
      $$PreferenceSmokingsTableAnnotationComposer,
      $$PreferenceSmokingsTableCreateCompanionBuilder,
      $$PreferenceSmokingsTableUpdateCompanionBuilder,
      (
        PreferenceSmoking,
        BaseReferences<
          _$AppDatabase,
          $PreferenceSmokingsTable,
          PreferenceSmoking
        >,
      ),
      PreferenceSmoking,
      PrefetchHooks Function()
    >;
typedef $$PreferencePetsTableCreateCompanionBuilder =
    PreferencePetsCompanion Function({Value<int> rowId, required String value});
typedef $$PreferencePetsTableUpdateCompanionBuilder =
    PreferencePetsCompanion Function({Value<int> rowId, Value<String> value});

class $$PreferencePetsTableFilterComposer
    extends Composer<_$AppDatabase, $PreferencePetsTable> {
  $$PreferencePetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PreferencePetsTableOrderingComposer
    extends Composer<_$AppDatabase, $PreferencePetsTable> {
  $$PreferencePetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PreferencePetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PreferencePetsTable> {
  $$PreferencePetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get rowId =>
      $composableBuilder(column: $table.rowId, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$PreferencePetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PreferencePetsTable,
          PreferencePet,
          $$PreferencePetsTableFilterComposer,
          $$PreferencePetsTableOrderingComposer,
          $$PreferencePetsTableAnnotationComposer,
          $$PreferencePetsTableCreateCompanionBuilder,
          $$PreferencePetsTableUpdateCompanionBuilder,
          (
            PreferencePet,
            BaseReferences<_$AppDatabase, $PreferencePetsTable, PreferencePet>,
          ),
          PreferencePet,
          PrefetchHooks Function()
        > {
  $$PreferencePetsTableTableManager(
    _$AppDatabase db,
    $PreferencePetsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PreferencePetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PreferencePetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PreferencePetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                Value<String> value = const Value.absent(),
              }) => PreferencePetsCompanion(rowId: rowId, value: value),
          createCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                required String value,
              }) => PreferencePetsCompanion.insert(rowId: rowId, value: value),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PreferencePetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PreferencePetsTable,
      PreferencePet,
      $$PreferencePetsTableFilterComposer,
      $$PreferencePetsTableOrderingComposer,
      $$PreferencePetsTableAnnotationComposer,
      $$PreferencePetsTableCreateCompanionBuilder,
      $$PreferencePetsTableUpdateCompanionBuilder,
      (
        PreferencePet,
        BaseReferences<_$AppDatabase, $PreferencePetsTable, PreferencePet>,
      ),
      PreferencePet,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CachedInterestsTableTableManager get cachedInterests =>
      $$CachedInterestsTableTableManager(_db, _db.cachedInterests);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db, _db.profiles);
  $$LoveLanguagesTableTableManager get loveLanguages =>
      $$LoveLanguagesTableTableManager(_db, _db.loveLanguages);
  $$ProfileInterestsTableTableManager get profileInterests =>
      $$ProfileInterestsTableTableManager(_db, _db.profileInterests);
  $$PhotosTableTableManager get photos =>
      $$PhotosTableTableManager(_db, _db.photos);
  $$PreferenceChildrenTableTableManager get preferenceChildren =>
      $$PreferenceChildrenTableTableManager(_db, _db.preferenceChildren);
  $$PreferenceMarriagesTableTableManager get preferenceMarriages =>
      $$PreferenceMarriagesTableTableManager(_db, _db.preferenceMarriages);
  $$PreferenceEthnicitiesTableTableManager get preferenceEthnicities =>
      $$PreferenceEthnicitiesTableTableManager(_db, _db.preferenceEthnicities);
  $$PreferenceReligionsTableTableManager get preferenceReligions =>
      $$PreferenceReligionsTableTableManager(_db, _db.preferenceReligions);
  $$PreferenceEducationsTableTableManager get preferenceEducations =>
      $$PreferenceEducationsTableTableManager(_db, _db.preferenceEducations);
  $$PreferenceDrinkingsTableTableManager get preferenceDrinkings =>
      $$PreferenceDrinkingsTableTableManager(_db, _db.preferenceDrinkings);
  $$PreferenceSmokingsTableTableManager get preferenceSmokings =>
      $$PreferenceSmokingsTableTableManager(_db, _db.preferenceSmokings);
  $$PreferencePetsTableTableManager get preferencePets =>
      $$PreferencePetsTableTableManager(_db, _db.preferencePets);
}
