// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $UserPreferencesTableTable extends UserPreferencesTable
    with TableInfo<$UserPreferencesTableTable, UserPreferencesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserPreferencesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _firstNameMeta =
      const VerificationMeta('firstName');
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
      'first_name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _goalsMeta = const VerificationMeta('goals');
  @override
  late final GeneratedColumn<String> goals = GeneratedColumn<String>(
      'goals', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _preferredDurationSecondsMeta =
      const VerificationMeta('preferredDurationSeconds');
  @override
  late final GeneratedColumn<int> preferredDurationSeconds =
      GeneratedColumn<int>('preferred_duration_seconds', aliasedName, false,
          type: DriftSqlType.int,
          requiredDuringInsert: false,
          defaultValue: const Constant(300));
  static const VerificationMeta _preferredTimeOfDayIndexMeta =
      const VerificationMeta('preferredTimeOfDayIndex');
  @override
  late final GeneratedColumn<int> preferredTimeOfDayIndex =
      GeneratedColumn<int>('preferred_time_of_day_index', aliasedName, false,
          type: DriftSqlType.int,
          requiredDuringInsert: false,
          defaultValue: const Constant(0));
  static const VerificationMeta _customReminderHourMeta =
      const VerificationMeta('customReminderHour');
  @override
  late final GeneratedColumn<int> customReminderHour = GeneratedColumn<int>(
      'custom_reminder_hour', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(8));
  static const VerificationMeta _customReminderMinuteMeta =
      const VerificationMeta('customReminderMinute');
  @override
  late final GeneratedColumn<int> customReminderMinute = GeneratedColumn<int>(
      'custom_reminder_minute', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _notificationsEnabledMeta =
      const VerificationMeta('notificationsEnabled');
  @override
  late final GeneratedColumn<bool> notificationsEnabled = GeneratedColumn<bool>(
      'notifications_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("notifications_enabled" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _themeModeIndexMeta =
      const VerificationMeta('themeModeIndex');
  @override
  late final GeneratedColumn<int> themeModeIndex = GeneratedColumn<int>(
      'theme_mode_index', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _reducedMotionMeta =
      const VerificationMeta('reducedMotion');
  @override
  late final GeneratedColumn<bool> reducedMotion = GeneratedColumn<bool>(
      'reduced_motion', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("reduced_motion" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _hapticsEnabledMeta =
      const VerificationMeta('hapticsEnabled');
  @override
  late final GeneratedColumn<bool> hapticsEnabled = GeneratedColumn<bool>(
      'haptics_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("haptics_enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _onboardingCompletedMeta =
      const VerificationMeta('onboardingCompleted');
  @override
  late final GeneratedColumn<bool> onboardingCompleted = GeneratedColumn<bool>(
      'onboarding_completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("onboarding_completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        firstName,
        goals,
        preferredDurationSeconds,
        preferredTimeOfDayIndex,
        customReminderHour,
        customReminderMinute,
        notificationsEnabled,
        themeModeIndex,
        reducedMotion,
        hapticsEnabled,
        onboardingCompleted
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_preferences_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<UserPreferencesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('first_name')) {
      context.handle(_firstNameMeta,
          firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta));
    }
    if (data.containsKey('goals')) {
      context.handle(
          _goalsMeta, goals.isAcceptableOrUnknown(data['goals']!, _goalsMeta));
    }
    if (data.containsKey('preferred_duration_seconds')) {
      context.handle(
          _preferredDurationSecondsMeta,
          preferredDurationSeconds.isAcceptableOrUnknown(
              data['preferred_duration_seconds']!,
              _preferredDurationSecondsMeta));
    }
    if (data.containsKey('preferred_time_of_day_index')) {
      context.handle(
          _preferredTimeOfDayIndexMeta,
          preferredTimeOfDayIndex.isAcceptableOrUnknown(
              data['preferred_time_of_day_index']!,
              _preferredTimeOfDayIndexMeta));
    }
    if (data.containsKey('custom_reminder_hour')) {
      context.handle(
          _customReminderHourMeta,
          customReminderHour.isAcceptableOrUnknown(
              data['custom_reminder_hour']!, _customReminderHourMeta));
    }
    if (data.containsKey('custom_reminder_minute')) {
      context.handle(
          _customReminderMinuteMeta,
          customReminderMinute.isAcceptableOrUnknown(
              data['custom_reminder_minute']!, _customReminderMinuteMeta));
    }
    if (data.containsKey('notifications_enabled')) {
      context.handle(
          _notificationsEnabledMeta,
          notificationsEnabled.isAcceptableOrUnknown(
              data['notifications_enabled']!, _notificationsEnabledMeta));
    }
    if (data.containsKey('theme_mode_index')) {
      context.handle(
          _themeModeIndexMeta,
          themeModeIndex.isAcceptableOrUnknown(
              data['theme_mode_index']!, _themeModeIndexMeta));
    }
    if (data.containsKey('reduced_motion')) {
      context.handle(
          _reducedMotionMeta,
          reducedMotion.isAcceptableOrUnknown(
              data['reduced_motion']!, _reducedMotionMeta));
    }
    if (data.containsKey('haptics_enabled')) {
      context.handle(
          _hapticsEnabledMeta,
          hapticsEnabled.isAcceptableOrUnknown(
              data['haptics_enabled']!, _hapticsEnabledMeta));
    }
    if (data.containsKey('onboarding_completed')) {
      context.handle(
          _onboardingCompletedMeta,
          onboardingCompleted.isAcceptableOrUnknown(
              data['onboarding_completed']!, _onboardingCompletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserPreferencesTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserPreferencesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      firstName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}first_name'])!,
      goals: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}goals'])!,
      preferredDurationSeconds: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}preferred_duration_seconds'])!,
      preferredTimeOfDayIndex: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}preferred_time_of_day_index'])!,
      customReminderHour: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}custom_reminder_hour'])!,
      customReminderMinute: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}custom_reminder_minute'])!,
      notificationsEnabled: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}notifications_enabled'])!,
      themeModeIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}theme_mode_index'])!,
      reducedMotion: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}reduced_motion'])!,
      hapticsEnabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}haptics_enabled'])!,
      onboardingCompleted: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}onboarding_completed'])!,
    );
  }

  @override
  $UserPreferencesTableTable createAlias(String alias) {
    return $UserPreferencesTableTable(attachedDatabase, alias);
  }
}

class UserPreferencesTableData extends DataClass
    implements Insertable<UserPreferencesTableData> {
  final String id;
  final String firstName;
  final String goals;
  final int preferredDurationSeconds;
  final int preferredTimeOfDayIndex;
  final int customReminderHour;
  final int customReminderMinute;
  final bool notificationsEnabled;
  final int themeModeIndex;
  final bool reducedMotion;
  final bool hapticsEnabled;
  final bool onboardingCompleted;
  const UserPreferencesTableData(
      {required this.id,
      required this.firstName,
      required this.goals,
      required this.preferredDurationSeconds,
      required this.preferredTimeOfDayIndex,
      required this.customReminderHour,
      required this.customReminderMinute,
      required this.notificationsEnabled,
      required this.themeModeIndex,
      required this.reducedMotion,
      required this.hapticsEnabled,
      required this.onboardingCompleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['first_name'] = Variable<String>(firstName);
    map['goals'] = Variable<String>(goals);
    map['preferred_duration_seconds'] = Variable<int>(preferredDurationSeconds);
    map['preferred_time_of_day_index'] = Variable<int>(preferredTimeOfDayIndex);
    map['custom_reminder_hour'] = Variable<int>(customReminderHour);
    map['custom_reminder_minute'] = Variable<int>(customReminderMinute);
    map['notifications_enabled'] = Variable<bool>(notificationsEnabled);
    map['theme_mode_index'] = Variable<int>(themeModeIndex);
    map['reduced_motion'] = Variable<bool>(reducedMotion);
    map['haptics_enabled'] = Variable<bool>(hapticsEnabled);
    map['onboarding_completed'] = Variable<bool>(onboardingCompleted);
    return map;
  }

  UserPreferencesTableCompanion toCompanion(bool nullToAbsent) {
    return UserPreferencesTableCompanion(
      id: Value(id),
      firstName: Value(firstName),
      goals: Value(goals),
      preferredDurationSeconds: Value(preferredDurationSeconds),
      preferredTimeOfDayIndex: Value(preferredTimeOfDayIndex),
      customReminderHour: Value(customReminderHour),
      customReminderMinute: Value(customReminderMinute),
      notificationsEnabled: Value(notificationsEnabled),
      themeModeIndex: Value(themeModeIndex),
      reducedMotion: Value(reducedMotion),
      hapticsEnabled: Value(hapticsEnabled),
      onboardingCompleted: Value(onboardingCompleted),
    );
  }

  factory UserPreferencesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserPreferencesTableData(
      id: serializer.fromJson<String>(json['id']),
      firstName: serializer.fromJson<String>(json['firstName']),
      goals: serializer.fromJson<String>(json['goals']),
      preferredDurationSeconds:
          serializer.fromJson<int>(json['preferredDurationSeconds']),
      preferredTimeOfDayIndex:
          serializer.fromJson<int>(json['preferredTimeOfDayIndex']),
      customReminderHour: serializer.fromJson<int>(json['customReminderHour']),
      customReminderMinute:
          serializer.fromJson<int>(json['customReminderMinute']),
      notificationsEnabled:
          serializer.fromJson<bool>(json['notificationsEnabled']),
      themeModeIndex: serializer.fromJson<int>(json['themeModeIndex']),
      reducedMotion: serializer.fromJson<bool>(json['reducedMotion']),
      hapticsEnabled: serializer.fromJson<bool>(json['hapticsEnabled']),
      onboardingCompleted:
          serializer.fromJson<bool>(json['onboardingCompleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'firstName': serializer.toJson<String>(firstName),
      'goals': serializer.toJson<String>(goals),
      'preferredDurationSeconds':
          serializer.toJson<int>(preferredDurationSeconds),
      'preferredTimeOfDayIndex':
          serializer.toJson<int>(preferredTimeOfDayIndex),
      'customReminderHour': serializer.toJson<int>(customReminderHour),
      'customReminderMinute': serializer.toJson<int>(customReminderMinute),
      'notificationsEnabled': serializer.toJson<bool>(notificationsEnabled),
      'themeModeIndex': serializer.toJson<int>(themeModeIndex),
      'reducedMotion': serializer.toJson<bool>(reducedMotion),
      'hapticsEnabled': serializer.toJson<bool>(hapticsEnabled),
      'onboardingCompleted': serializer.toJson<bool>(onboardingCompleted),
    };
  }

  UserPreferencesTableData copyWith(
          {String? id,
          String? firstName,
          String? goals,
          int? preferredDurationSeconds,
          int? preferredTimeOfDayIndex,
          int? customReminderHour,
          int? customReminderMinute,
          bool? notificationsEnabled,
          int? themeModeIndex,
          bool? reducedMotion,
          bool? hapticsEnabled,
          bool? onboardingCompleted}) =>
      UserPreferencesTableData(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        goals: goals ?? this.goals,
        preferredDurationSeconds:
            preferredDurationSeconds ?? this.preferredDurationSeconds,
        preferredTimeOfDayIndex:
            preferredTimeOfDayIndex ?? this.preferredTimeOfDayIndex,
        customReminderHour: customReminderHour ?? this.customReminderHour,
        customReminderMinute: customReminderMinute ?? this.customReminderMinute,
        notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
        themeModeIndex: themeModeIndex ?? this.themeModeIndex,
        reducedMotion: reducedMotion ?? this.reducedMotion,
        hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
        onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      );
  UserPreferencesTableData copyWithCompanion(
      UserPreferencesTableCompanion data) {
    return UserPreferencesTableData(
      id: data.id.present ? data.id.value : this.id,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      goals: data.goals.present ? data.goals.value : this.goals,
      preferredDurationSeconds: data.preferredDurationSeconds.present
          ? data.preferredDurationSeconds.value
          : this.preferredDurationSeconds,
      preferredTimeOfDayIndex: data.preferredTimeOfDayIndex.present
          ? data.preferredTimeOfDayIndex.value
          : this.preferredTimeOfDayIndex,
      customReminderHour: data.customReminderHour.present
          ? data.customReminderHour.value
          : this.customReminderHour,
      customReminderMinute: data.customReminderMinute.present
          ? data.customReminderMinute.value
          : this.customReminderMinute,
      notificationsEnabled: data.notificationsEnabled.present
          ? data.notificationsEnabled.value
          : this.notificationsEnabled,
      themeModeIndex: data.themeModeIndex.present
          ? data.themeModeIndex.value
          : this.themeModeIndex,
      reducedMotion: data.reducedMotion.present
          ? data.reducedMotion.value
          : this.reducedMotion,
      hapticsEnabled: data.hapticsEnabled.present
          ? data.hapticsEnabled.value
          : this.hapticsEnabled,
      onboardingCompleted: data.onboardingCompleted.present
          ? data.onboardingCompleted.value
          : this.onboardingCompleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserPreferencesTableData(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('goals: $goals, ')
          ..write('preferredDurationSeconds: $preferredDurationSeconds, ')
          ..write('preferredTimeOfDayIndex: $preferredTimeOfDayIndex, ')
          ..write('customReminderHour: $customReminderHour, ')
          ..write('customReminderMinute: $customReminderMinute, ')
          ..write('notificationsEnabled: $notificationsEnabled, ')
          ..write('themeModeIndex: $themeModeIndex, ')
          ..write('reducedMotion: $reducedMotion, ')
          ..write('hapticsEnabled: $hapticsEnabled, ')
          ..write('onboardingCompleted: $onboardingCompleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      firstName,
      goals,
      preferredDurationSeconds,
      preferredTimeOfDayIndex,
      customReminderHour,
      customReminderMinute,
      notificationsEnabled,
      themeModeIndex,
      reducedMotion,
      hapticsEnabled,
      onboardingCompleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserPreferencesTableData &&
          other.id == this.id &&
          other.firstName == this.firstName &&
          other.goals == this.goals &&
          other.preferredDurationSeconds == this.preferredDurationSeconds &&
          other.preferredTimeOfDayIndex == this.preferredTimeOfDayIndex &&
          other.customReminderHour == this.customReminderHour &&
          other.customReminderMinute == this.customReminderMinute &&
          other.notificationsEnabled == this.notificationsEnabled &&
          other.themeModeIndex == this.themeModeIndex &&
          other.reducedMotion == this.reducedMotion &&
          other.hapticsEnabled == this.hapticsEnabled &&
          other.onboardingCompleted == this.onboardingCompleted);
}

class UserPreferencesTableCompanion
    extends UpdateCompanion<UserPreferencesTableData> {
  final Value<String> id;
  final Value<String> firstName;
  final Value<String> goals;
  final Value<int> preferredDurationSeconds;
  final Value<int> preferredTimeOfDayIndex;
  final Value<int> customReminderHour;
  final Value<int> customReminderMinute;
  final Value<bool> notificationsEnabled;
  final Value<int> themeModeIndex;
  final Value<bool> reducedMotion;
  final Value<bool> hapticsEnabled;
  final Value<bool> onboardingCompleted;
  final Value<int> rowid;
  const UserPreferencesTableCompanion({
    this.id = const Value.absent(),
    this.firstName = const Value.absent(),
    this.goals = const Value.absent(),
    this.preferredDurationSeconds = const Value.absent(),
    this.preferredTimeOfDayIndex = const Value.absent(),
    this.customReminderHour = const Value.absent(),
    this.customReminderMinute = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
    this.themeModeIndex = const Value.absent(),
    this.reducedMotion = const Value.absent(),
    this.hapticsEnabled = const Value.absent(),
    this.onboardingCompleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserPreferencesTableCompanion.insert({
    required String id,
    this.firstName = const Value.absent(),
    this.goals = const Value.absent(),
    this.preferredDurationSeconds = const Value.absent(),
    this.preferredTimeOfDayIndex = const Value.absent(),
    this.customReminderHour = const Value.absent(),
    this.customReminderMinute = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
    this.themeModeIndex = const Value.absent(),
    this.reducedMotion = const Value.absent(),
    this.hapticsEnabled = const Value.absent(),
    this.onboardingCompleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<UserPreferencesTableData> custom({
    Expression<String>? id,
    Expression<String>? firstName,
    Expression<String>? goals,
    Expression<int>? preferredDurationSeconds,
    Expression<int>? preferredTimeOfDayIndex,
    Expression<int>? customReminderHour,
    Expression<int>? customReminderMinute,
    Expression<bool>? notificationsEnabled,
    Expression<int>? themeModeIndex,
    Expression<bool>? reducedMotion,
    Expression<bool>? hapticsEnabled,
    Expression<bool>? onboardingCompleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (firstName != null) 'first_name': firstName,
      if (goals != null) 'goals': goals,
      if (preferredDurationSeconds != null)
        'preferred_duration_seconds': preferredDurationSeconds,
      if (preferredTimeOfDayIndex != null)
        'preferred_time_of_day_index': preferredTimeOfDayIndex,
      if (customReminderHour != null)
        'custom_reminder_hour': customReminderHour,
      if (customReminderMinute != null)
        'custom_reminder_minute': customReminderMinute,
      if (notificationsEnabled != null)
        'notifications_enabled': notificationsEnabled,
      if (themeModeIndex != null) 'theme_mode_index': themeModeIndex,
      if (reducedMotion != null) 'reduced_motion': reducedMotion,
      if (hapticsEnabled != null) 'haptics_enabled': hapticsEnabled,
      if (onboardingCompleted != null)
        'onboarding_completed': onboardingCompleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserPreferencesTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? firstName,
      Value<String>? goals,
      Value<int>? preferredDurationSeconds,
      Value<int>? preferredTimeOfDayIndex,
      Value<int>? customReminderHour,
      Value<int>? customReminderMinute,
      Value<bool>? notificationsEnabled,
      Value<int>? themeModeIndex,
      Value<bool>? reducedMotion,
      Value<bool>? hapticsEnabled,
      Value<bool>? onboardingCompleted,
      Value<int>? rowid}) {
    return UserPreferencesTableCompanion(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      goals: goals ?? this.goals,
      preferredDurationSeconds:
          preferredDurationSeconds ?? this.preferredDurationSeconds,
      preferredTimeOfDayIndex:
          preferredTimeOfDayIndex ?? this.preferredTimeOfDayIndex,
      customReminderHour: customReminderHour ?? this.customReminderHour,
      customReminderMinute: customReminderMinute ?? this.customReminderMinute,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      themeModeIndex: themeModeIndex ?? this.themeModeIndex,
      reducedMotion: reducedMotion ?? this.reducedMotion,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (goals.present) {
      map['goals'] = Variable<String>(goals.value);
    }
    if (preferredDurationSeconds.present) {
      map['preferred_duration_seconds'] =
          Variable<int>(preferredDurationSeconds.value);
    }
    if (preferredTimeOfDayIndex.present) {
      map['preferred_time_of_day_index'] =
          Variable<int>(preferredTimeOfDayIndex.value);
    }
    if (customReminderHour.present) {
      map['custom_reminder_hour'] = Variable<int>(customReminderHour.value);
    }
    if (customReminderMinute.present) {
      map['custom_reminder_minute'] = Variable<int>(customReminderMinute.value);
    }
    if (notificationsEnabled.present) {
      map['notifications_enabled'] = Variable<bool>(notificationsEnabled.value);
    }
    if (themeModeIndex.present) {
      map['theme_mode_index'] = Variable<int>(themeModeIndex.value);
    }
    if (reducedMotion.present) {
      map['reduced_motion'] = Variable<bool>(reducedMotion.value);
    }
    if (hapticsEnabled.present) {
      map['haptics_enabled'] = Variable<bool>(hapticsEnabled.value);
    }
    if (onboardingCompleted.present) {
      map['onboarding_completed'] = Variable<bool>(onboardingCompleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserPreferencesTableCompanion(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('goals: $goals, ')
          ..write('preferredDurationSeconds: $preferredDurationSeconds, ')
          ..write('preferredTimeOfDayIndex: $preferredTimeOfDayIndex, ')
          ..write('customReminderHour: $customReminderHour, ')
          ..write('customReminderMinute: $customReminderMinute, ')
          ..write('notificationsEnabled: $notificationsEnabled, ')
          ..write('themeModeIndex: $themeModeIndex, ')
          ..write('reducedMotion: $reducedMotion, ')
          ..write('hapticsEnabled: $hapticsEnabled, ')
          ..write('onboardingCompleted: $onboardingCompleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MoodEntriesTableTable extends MoodEntriesTable
    with TableInfo<$MoodEntriesTableTable, MoodEntriesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MoodEntriesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _moodMeta = const VerificationMeta('mood');
  @override
  late final GeneratedColumn<String> mood = GeneratedColumn<String>(
      'mood', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, timestamp, mood, note];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mood_entries_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<MoodEntriesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('mood')) {
      context.handle(
          _moodMeta, mood.isAcceptableOrUnknown(data['mood']!, _moodMeta));
    } else if (isInserting) {
      context.missing(_moodMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MoodEntriesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MoodEntriesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
      mood: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mood'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
    );
  }

  @override
  $MoodEntriesTableTable createAlias(String alias) {
    return $MoodEntriesTableTable(attachedDatabase, alias);
  }
}

class MoodEntriesTableData extends DataClass
    implements Insertable<MoodEntriesTableData> {
  final String id;
  final DateTime timestamp;
  final String mood;
  final String? note;
  const MoodEntriesTableData(
      {required this.id,
      required this.timestamp,
      required this.mood,
      this.note});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['mood'] = Variable<String>(mood);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  MoodEntriesTableCompanion toCompanion(bool nullToAbsent) {
    return MoodEntriesTableCompanion(
      id: Value(id),
      timestamp: Value(timestamp),
      mood: Value(mood),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory MoodEntriesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MoodEntriesTableData(
      id: serializer.fromJson<String>(json['id']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      mood: serializer.fromJson<String>(json['mood']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'mood': serializer.toJson<String>(mood),
      'note': serializer.toJson<String?>(note),
    };
  }

  MoodEntriesTableData copyWith(
          {String? id,
          DateTime? timestamp,
          String? mood,
          Value<String?> note = const Value.absent()}) =>
      MoodEntriesTableData(
        id: id ?? this.id,
        timestamp: timestamp ?? this.timestamp,
        mood: mood ?? this.mood,
        note: note.present ? note.value : this.note,
      );
  MoodEntriesTableData copyWithCompanion(MoodEntriesTableCompanion data) {
    return MoodEntriesTableData(
      id: data.id.present ? data.id.value : this.id,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      mood: data.mood.present ? data.mood.value : this.mood,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MoodEntriesTableData(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('mood: $mood, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, timestamp, mood, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MoodEntriesTableData &&
          other.id == this.id &&
          other.timestamp == this.timestamp &&
          other.mood == this.mood &&
          other.note == this.note);
}

class MoodEntriesTableCompanion extends UpdateCompanion<MoodEntriesTableData> {
  final Value<String> id;
  final Value<DateTime> timestamp;
  final Value<String> mood;
  final Value<String?> note;
  final Value<int> rowid;
  const MoodEntriesTableCompanion({
    this.id = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.mood = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MoodEntriesTableCompanion.insert({
    required String id,
    required DateTime timestamp,
    required String mood,
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        timestamp = Value(timestamp),
        mood = Value(mood);
  static Insertable<MoodEntriesTableData> custom({
    Expression<String>? id,
    Expression<DateTime>? timestamp,
    Expression<String>? mood,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (timestamp != null) 'timestamp': timestamp,
      if (mood != null) 'mood': mood,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MoodEntriesTableCompanion copyWith(
      {Value<String>? id,
      Value<DateTime>? timestamp,
      Value<String>? mood,
      Value<String?>? note,
      Value<int>? rowid}) {
    return MoodEntriesTableCompanion(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      mood: mood ?? this.mood,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (mood.present) {
      map['mood'] = Variable<String>(mood.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MoodEntriesTableCompanion(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('mood: $mood, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SessionsTableTable extends SessionsTable
    with TableInfo<$SessionsTableTable, SessionsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _durationSecondsMeta =
      const VerificationMeta('durationSeconds');
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
      'duration_seconds', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _difficultyMeta =
      const VerificationMeta('difficulty');
  @override
  late final GeneratedColumn<String> difficulty = GeneratedColumn<String>(
      'difficulty', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
      'tags', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _audioAssetMeta =
      const VerificationMeta('audioAsset');
  @override
  late final GeneratedColumn<String> audioAsset = GeneratedColumn<String>(
      'audio_asset', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _backgroundSoundAssetMeta =
      const VerificationMeta('backgroundSoundAsset');
  @override
  late final GeneratedColumn<String> backgroundSoundAsset =
      GeneratedColumn<String>('background_sound_asset', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isPremiumMeta =
      const VerificationMeta('isPremium');
  @override
  late final GeneratedColumn<bool> isPremium = GeneratedColumn<bool>(
      'is_premium', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_premium" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        description,
        category,
        type,
        durationSeconds,
        difficulty,
        tags,
        audioAsset,
        backgroundSoundAsset,
        isPremium,
        sortOrder
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions_table';
  @override
  VerificationContext validateIntegrity(Insertable<SessionsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
          _durationSecondsMeta,
          durationSeconds.isAcceptableOrUnknown(
              data['duration_seconds']!, _durationSecondsMeta));
    } else if (isInserting) {
      context.missing(_durationSecondsMeta);
    }
    if (data.containsKey('difficulty')) {
      context.handle(
          _difficultyMeta,
          difficulty.isAcceptableOrUnknown(
              data['difficulty']!, _difficultyMeta));
    } else if (isInserting) {
      context.missing(_difficultyMeta);
    }
    if (data.containsKey('tags')) {
      context.handle(
          _tagsMeta, tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta));
    }
    if (data.containsKey('audio_asset')) {
      context.handle(
          _audioAssetMeta,
          audioAsset.isAcceptableOrUnknown(
              data['audio_asset']!, _audioAssetMeta));
    }
    if (data.containsKey('background_sound_asset')) {
      context.handle(
          _backgroundSoundAssetMeta,
          backgroundSoundAsset.isAcceptableOrUnknown(
              data['background_sound_asset']!, _backgroundSoundAssetMeta));
    }
    if (data.containsKey('is_premium')) {
      context.handle(_isPremiumMeta,
          isPremium.isAcceptableOrUnknown(data['is_premium']!, _isPremiumMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SessionsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      durationSeconds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_seconds'])!,
      difficulty: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}difficulty'])!,
      tags: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags'])!,
      audioAsset: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}audio_asset']),
      backgroundSoundAsset: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}background_sound_asset']),
      isPremium: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_premium'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
    );
  }

  @override
  $SessionsTableTable createAlias(String alias) {
    return $SessionsTableTable(attachedDatabase, alias);
  }
}

class SessionsTableData extends DataClass
    implements Insertable<SessionsTableData> {
  final String id;
  final String title;
  final String description;
  final String category;
  final String type;
  final int durationSeconds;
  final String difficulty;
  final String tags;
  final String? audioAsset;
  final String? backgroundSoundAsset;
  final bool isPremium;
  final int sortOrder;
  const SessionsTableData(
      {required this.id,
      required this.title,
      required this.description,
      required this.category,
      required this.type,
      required this.durationSeconds,
      required this.difficulty,
      required this.tags,
      this.audioAsset,
      this.backgroundSoundAsset,
      required this.isPremium,
      required this.sortOrder});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['category'] = Variable<String>(category);
    map['type'] = Variable<String>(type);
    map['duration_seconds'] = Variable<int>(durationSeconds);
    map['difficulty'] = Variable<String>(difficulty);
    map['tags'] = Variable<String>(tags);
    if (!nullToAbsent || audioAsset != null) {
      map['audio_asset'] = Variable<String>(audioAsset);
    }
    if (!nullToAbsent || backgroundSoundAsset != null) {
      map['background_sound_asset'] = Variable<String>(backgroundSoundAsset);
    }
    map['is_premium'] = Variable<bool>(isPremium);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  SessionsTableCompanion toCompanion(bool nullToAbsent) {
    return SessionsTableCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      category: Value(category),
      type: Value(type),
      durationSeconds: Value(durationSeconds),
      difficulty: Value(difficulty),
      tags: Value(tags),
      audioAsset: audioAsset == null && nullToAbsent
          ? const Value.absent()
          : Value(audioAsset),
      backgroundSoundAsset: backgroundSoundAsset == null && nullToAbsent
          ? const Value.absent()
          : Value(backgroundSoundAsset),
      isPremium: Value(isPremium),
      sortOrder: Value(sortOrder),
    );
  }

  factory SessionsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionsTableData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      category: serializer.fromJson<String>(json['category']),
      type: serializer.fromJson<String>(json['type']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
      difficulty: serializer.fromJson<String>(json['difficulty']),
      tags: serializer.fromJson<String>(json['tags']),
      audioAsset: serializer.fromJson<String?>(json['audioAsset']),
      backgroundSoundAsset:
          serializer.fromJson<String?>(json['backgroundSoundAsset']),
      isPremium: serializer.fromJson<bool>(json['isPremium']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'category': serializer.toJson<String>(category),
      'type': serializer.toJson<String>(type),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
      'difficulty': serializer.toJson<String>(difficulty),
      'tags': serializer.toJson<String>(tags),
      'audioAsset': serializer.toJson<String?>(audioAsset),
      'backgroundSoundAsset': serializer.toJson<String?>(backgroundSoundAsset),
      'isPremium': serializer.toJson<bool>(isPremium),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  SessionsTableData copyWith(
          {String? id,
          String? title,
          String? description,
          String? category,
          String? type,
          int? durationSeconds,
          String? difficulty,
          String? tags,
          Value<String?> audioAsset = const Value.absent(),
          Value<String?> backgroundSoundAsset = const Value.absent(),
          bool? isPremium,
          int? sortOrder}) =>
      SessionsTableData(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        category: category ?? this.category,
        type: type ?? this.type,
        durationSeconds: durationSeconds ?? this.durationSeconds,
        difficulty: difficulty ?? this.difficulty,
        tags: tags ?? this.tags,
        audioAsset: audioAsset.present ? audioAsset.value : this.audioAsset,
        backgroundSoundAsset: backgroundSoundAsset.present
            ? backgroundSoundAsset.value
            : this.backgroundSoundAsset,
        isPremium: isPremium ?? this.isPremium,
        sortOrder: sortOrder ?? this.sortOrder,
      );
  SessionsTableData copyWithCompanion(SessionsTableCompanion data) {
    return SessionsTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      category: data.category.present ? data.category.value : this.category,
      type: data.type.present ? data.type.value : this.type,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      difficulty:
          data.difficulty.present ? data.difficulty.value : this.difficulty,
      tags: data.tags.present ? data.tags.value : this.tags,
      audioAsset:
          data.audioAsset.present ? data.audioAsset.value : this.audioAsset,
      backgroundSoundAsset: data.backgroundSoundAsset.present
          ? data.backgroundSoundAsset.value
          : this.backgroundSoundAsset,
      isPremium: data.isPremium.present ? data.isPremium.value : this.isPremium,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionsTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('type: $type, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('difficulty: $difficulty, ')
          ..write('tags: $tags, ')
          ..write('audioAsset: $audioAsset, ')
          ..write('backgroundSoundAsset: $backgroundSoundAsset, ')
          ..write('isPremium: $isPremium, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      title,
      description,
      category,
      type,
      durationSeconds,
      difficulty,
      tags,
      audioAsset,
      backgroundSoundAsset,
      isPremium,
      sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionsTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.category == this.category &&
          other.type == this.type &&
          other.durationSeconds == this.durationSeconds &&
          other.difficulty == this.difficulty &&
          other.tags == this.tags &&
          other.audioAsset == this.audioAsset &&
          other.backgroundSoundAsset == this.backgroundSoundAsset &&
          other.isPremium == this.isPremium &&
          other.sortOrder == this.sortOrder);
}

class SessionsTableCompanion extends UpdateCompanion<SessionsTableData> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> description;
  final Value<String> category;
  final Value<String> type;
  final Value<int> durationSeconds;
  final Value<String> difficulty;
  final Value<String> tags;
  final Value<String?> audioAsset;
  final Value<String?> backgroundSoundAsset;
  final Value<bool> isPremium;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const SessionsTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.category = const Value.absent(),
    this.type = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.tags = const Value.absent(),
    this.audioAsset = const Value.absent(),
    this.backgroundSoundAsset = const Value.absent(),
    this.isPremium = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SessionsTableCompanion.insert({
    required String id,
    required String title,
    required String description,
    required String category,
    required String type,
    required int durationSeconds,
    required String difficulty,
    this.tags = const Value.absent(),
    this.audioAsset = const Value.absent(),
    this.backgroundSoundAsset = const Value.absent(),
    this.isPremium = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        description = Value(description),
        category = Value(category),
        type = Value(type),
        durationSeconds = Value(durationSeconds),
        difficulty = Value(difficulty);
  static Insertable<SessionsTableData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? category,
    Expression<String>? type,
    Expression<int>? durationSeconds,
    Expression<String>? difficulty,
    Expression<String>? tags,
    Expression<String>? audioAsset,
    Expression<String>? backgroundSoundAsset,
    Expression<bool>? isPremium,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (category != null) 'category': category,
      if (type != null) 'type': type,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (difficulty != null) 'difficulty': difficulty,
      if (tags != null) 'tags': tags,
      if (audioAsset != null) 'audio_asset': audioAsset,
      if (backgroundSoundAsset != null)
        'background_sound_asset': backgroundSoundAsset,
      if (isPremium != null) 'is_premium': isPremium,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SessionsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? description,
      Value<String>? category,
      Value<String>? type,
      Value<int>? durationSeconds,
      Value<String>? difficulty,
      Value<String>? tags,
      Value<String?>? audioAsset,
      Value<String?>? backgroundSoundAsset,
      Value<bool>? isPremium,
      Value<int>? sortOrder,
      Value<int>? rowid}) {
    return SessionsTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      type: type ?? this.type,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      difficulty: difficulty ?? this.difficulty,
      tags: tags ?? this.tags,
      audioAsset: audioAsset ?? this.audioAsset,
      backgroundSoundAsset: backgroundSoundAsset ?? this.backgroundSoundAsset,
      isPremium: isPremium ?? this.isPremium,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<String>(difficulty.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (audioAsset.present) {
      map['audio_asset'] = Variable<String>(audioAsset.value);
    }
    if (backgroundSoundAsset.present) {
      map['background_sound_asset'] =
          Variable<String>(backgroundSoundAsset.value);
    }
    if (isPremium.present) {
      map['is_premium'] = Variable<bool>(isPremium.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('type: $type, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('difficulty: $difficulty, ')
          ..write('tags: $tags, ')
          ..write('audioAsset: $audioAsset, ')
          ..write('backgroundSoundAsset: $backgroundSoundAsset, ')
          ..write('isPremium: $isPremium, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SessionRecordsTableTable extends SessionRecordsTable
    with TableInfo<$SessionRecordsTableTable, SessionRecordsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionRecordsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sessionIdMeta =
      const VerificationMeta('sessionId');
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
      'session_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sessionTitleMeta =
      const VerificationMeta('sessionTitle');
  @override
  late final GeneratedColumn<String> sessionTitle = GeneratedColumn<String>(
      'session_title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sessionTypeMeta =
      const VerificationMeta('sessionType');
  @override
  late final GeneratedColumn<String> sessionType = GeneratedColumn<String>(
      'session_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startedAtMeta =
      const VerificationMeta('startedAt');
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
      'started_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _durationCompletedSecondsMeta =
      const VerificationMeta('durationCompletedSeconds');
  @override
  late final GeneratedColumn<int> durationCompletedSeconds =
      GeneratedColumn<int>('duration_completed_seconds', aliasedName, false,
          type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _wasCompletedMeta =
      const VerificationMeta('wasCompleted');
  @override
  late final GeneratedColumn<bool> wasCompleted = GeneratedColumn<bool>(
      'was_completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("was_completed" IN (0, 1))'));
  static const VerificationMeta _moodBeforeMeta =
      const VerificationMeta('moodBefore');
  @override
  late final GeneratedColumn<String> moodBefore = GeneratedColumn<String>(
      'mood_before', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _moodAfterMeta =
      const VerificationMeta('moodAfter');
  @override
  late final GeneratedColumn<String> moodAfter = GeneratedColumn<String>(
      'mood_after', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        sessionId,
        sessionTitle,
        sessionType,
        startedAt,
        completedAt,
        durationCompletedSeconds,
        wasCompleted,
        moodBefore,
        moodAfter
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'session_records_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<SessionRecordsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(_sessionIdMeta,
          sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta));
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('session_title')) {
      context.handle(
          _sessionTitleMeta,
          sessionTitle.isAcceptableOrUnknown(
              data['session_title']!, _sessionTitleMeta));
    } else if (isInserting) {
      context.missing(_sessionTitleMeta);
    }
    if (data.containsKey('session_type')) {
      context.handle(
          _sessionTypeMeta,
          sessionType.isAcceptableOrUnknown(
              data['session_type']!, _sessionTypeMeta));
    } else if (isInserting) {
      context.missing(_sessionTypeMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(_startedAtMeta,
          startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta));
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    } else if (isInserting) {
      context.missing(_completedAtMeta);
    }
    if (data.containsKey('duration_completed_seconds')) {
      context.handle(
          _durationCompletedSecondsMeta,
          durationCompletedSeconds.isAcceptableOrUnknown(
              data['duration_completed_seconds']!,
              _durationCompletedSecondsMeta));
    } else if (isInserting) {
      context.missing(_durationCompletedSecondsMeta);
    }
    if (data.containsKey('was_completed')) {
      context.handle(
          _wasCompletedMeta,
          wasCompleted.isAcceptableOrUnknown(
              data['was_completed']!, _wasCompletedMeta));
    } else if (isInserting) {
      context.missing(_wasCompletedMeta);
    }
    if (data.containsKey('mood_before')) {
      context.handle(
          _moodBeforeMeta,
          moodBefore.isAcceptableOrUnknown(
              data['mood_before']!, _moodBeforeMeta));
    }
    if (data.containsKey('mood_after')) {
      context.handle(_moodAfterMeta,
          moodAfter.isAcceptableOrUnknown(data['mood_after']!, _moodAfterMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SessionRecordsTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionRecordsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      sessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}session_id'])!,
      sessionTitle: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}session_title'])!,
      sessionType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}session_type'])!,
      startedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}started_at'])!,
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at'])!,
      durationCompletedSeconds: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}duration_completed_seconds'])!,
      wasCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}was_completed'])!,
      moodBefore: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mood_before']),
      moodAfter: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mood_after']),
    );
  }

  @override
  $SessionRecordsTableTable createAlias(String alias) {
    return $SessionRecordsTableTable(attachedDatabase, alias);
  }
}

class SessionRecordsTableData extends DataClass
    implements Insertable<SessionRecordsTableData> {
  final String id;
  final String sessionId;
  final String sessionTitle;
  final String sessionType;
  final DateTime startedAt;
  final DateTime completedAt;
  final int durationCompletedSeconds;
  final bool wasCompleted;
  final String? moodBefore;
  final String? moodAfter;
  const SessionRecordsTableData(
      {required this.id,
      required this.sessionId,
      required this.sessionTitle,
      required this.sessionType,
      required this.startedAt,
      required this.completedAt,
      required this.durationCompletedSeconds,
      required this.wasCompleted,
      this.moodBefore,
      this.moodAfter});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['session_title'] = Variable<String>(sessionTitle);
    map['session_type'] = Variable<String>(sessionType);
    map['started_at'] = Variable<DateTime>(startedAt);
    map['completed_at'] = Variable<DateTime>(completedAt);
    map['duration_completed_seconds'] = Variable<int>(durationCompletedSeconds);
    map['was_completed'] = Variable<bool>(wasCompleted);
    if (!nullToAbsent || moodBefore != null) {
      map['mood_before'] = Variable<String>(moodBefore);
    }
    if (!nullToAbsent || moodAfter != null) {
      map['mood_after'] = Variable<String>(moodAfter);
    }
    return map;
  }

  SessionRecordsTableCompanion toCompanion(bool nullToAbsent) {
    return SessionRecordsTableCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      sessionTitle: Value(sessionTitle),
      sessionType: Value(sessionType),
      startedAt: Value(startedAt),
      completedAt: Value(completedAt),
      durationCompletedSeconds: Value(durationCompletedSeconds),
      wasCompleted: Value(wasCompleted),
      moodBefore: moodBefore == null && nullToAbsent
          ? const Value.absent()
          : Value(moodBefore),
      moodAfter: moodAfter == null && nullToAbsent
          ? const Value.absent()
          : Value(moodAfter),
    );
  }

  factory SessionRecordsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionRecordsTableData(
      id: serializer.fromJson<String>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      sessionTitle: serializer.fromJson<String>(json['sessionTitle']),
      sessionType: serializer.fromJson<String>(json['sessionType']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime>(json['completedAt']),
      durationCompletedSeconds:
          serializer.fromJson<int>(json['durationCompletedSeconds']),
      wasCompleted: serializer.fromJson<bool>(json['wasCompleted']),
      moodBefore: serializer.fromJson<String?>(json['moodBefore']),
      moodAfter: serializer.fromJson<String?>(json['moodAfter']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'sessionTitle': serializer.toJson<String>(sessionTitle),
      'sessionType': serializer.toJson<String>(sessionType),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'completedAt': serializer.toJson<DateTime>(completedAt),
      'durationCompletedSeconds':
          serializer.toJson<int>(durationCompletedSeconds),
      'wasCompleted': serializer.toJson<bool>(wasCompleted),
      'moodBefore': serializer.toJson<String?>(moodBefore),
      'moodAfter': serializer.toJson<String?>(moodAfter),
    };
  }

  SessionRecordsTableData copyWith(
          {String? id,
          String? sessionId,
          String? sessionTitle,
          String? sessionType,
          DateTime? startedAt,
          DateTime? completedAt,
          int? durationCompletedSeconds,
          bool? wasCompleted,
          Value<String?> moodBefore = const Value.absent(),
          Value<String?> moodAfter = const Value.absent()}) =>
      SessionRecordsTableData(
        id: id ?? this.id,
        sessionId: sessionId ?? this.sessionId,
        sessionTitle: sessionTitle ?? this.sessionTitle,
        sessionType: sessionType ?? this.sessionType,
        startedAt: startedAt ?? this.startedAt,
        completedAt: completedAt ?? this.completedAt,
        durationCompletedSeconds:
            durationCompletedSeconds ?? this.durationCompletedSeconds,
        wasCompleted: wasCompleted ?? this.wasCompleted,
        moodBefore: moodBefore.present ? moodBefore.value : this.moodBefore,
        moodAfter: moodAfter.present ? moodAfter.value : this.moodAfter,
      );
  SessionRecordsTableData copyWithCompanion(SessionRecordsTableCompanion data) {
    return SessionRecordsTableData(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      sessionTitle: data.sessionTitle.present
          ? data.sessionTitle.value
          : this.sessionTitle,
      sessionType:
          data.sessionType.present ? data.sessionType.value : this.sessionType,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
      durationCompletedSeconds: data.durationCompletedSeconds.present
          ? data.durationCompletedSeconds.value
          : this.durationCompletedSeconds,
      wasCompleted: data.wasCompleted.present
          ? data.wasCompleted.value
          : this.wasCompleted,
      moodBefore:
          data.moodBefore.present ? data.moodBefore.value : this.moodBefore,
      moodAfter: data.moodAfter.present ? data.moodAfter.value : this.moodAfter,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionRecordsTableData(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('sessionTitle: $sessionTitle, ')
          ..write('sessionType: $sessionType, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('durationCompletedSeconds: $durationCompletedSeconds, ')
          ..write('wasCompleted: $wasCompleted, ')
          ..write('moodBefore: $moodBefore, ')
          ..write('moodAfter: $moodAfter')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      sessionId,
      sessionTitle,
      sessionType,
      startedAt,
      completedAt,
      durationCompletedSeconds,
      wasCompleted,
      moodBefore,
      moodAfter);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionRecordsTableData &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.sessionTitle == this.sessionTitle &&
          other.sessionType == this.sessionType &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.durationCompletedSeconds == this.durationCompletedSeconds &&
          other.wasCompleted == this.wasCompleted &&
          other.moodBefore == this.moodBefore &&
          other.moodAfter == this.moodAfter);
}

class SessionRecordsTableCompanion
    extends UpdateCompanion<SessionRecordsTableData> {
  final Value<String> id;
  final Value<String> sessionId;
  final Value<String> sessionTitle;
  final Value<String> sessionType;
  final Value<DateTime> startedAt;
  final Value<DateTime> completedAt;
  final Value<int> durationCompletedSeconds;
  final Value<bool> wasCompleted;
  final Value<String?> moodBefore;
  final Value<String?> moodAfter;
  final Value<int> rowid;
  const SessionRecordsTableCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.sessionTitle = const Value.absent(),
    this.sessionType = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.durationCompletedSeconds = const Value.absent(),
    this.wasCompleted = const Value.absent(),
    this.moodBefore = const Value.absent(),
    this.moodAfter = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SessionRecordsTableCompanion.insert({
    required String id,
    required String sessionId,
    required String sessionTitle,
    required String sessionType,
    required DateTime startedAt,
    required DateTime completedAt,
    required int durationCompletedSeconds,
    required bool wasCompleted,
    this.moodBefore = const Value.absent(),
    this.moodAfter = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        sessionId = Value(sessionId),
        sessionTitle = Value(sessionTitle),
        sessionType = Value(sessionType),
        startedAt = Value(startedAt),
        completedAt = Value(completedAt),
        durationCompletedSeconds = Value(durationCompletedSeconds),
        wasCompleted = Value(wasCompleted);
  static Insertable<SessionRecordsTableData> custom({
    Expression<String>? id,
    Expression<String>? sessionId,
    Expression<String>? sessionTitle,
    Expression<String>? sessionType,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<int>? durationCompletedSeconds,
    Expression<bool>? wasCompleted,
    Expression<String>? moodBefore,
    Expression<String>? moodAfter,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (sessionTitle != null) 'session_title': sessionTitle,
      if (sessionType != null) 'session_type': sessionType,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (durationCompletedSeconds != null)
        'duration_completed_seconds': durationCompletedSeconds,
      if (wasCompleted != null) 'was_completed': wasCompleted,
      if (moodBefore != null) 'mood_before': moodBefore,
      if (moodAfter != null) 'mood_after': moodAfter,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SessionRecordsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? sessionId,
      Value<String>? sessionTitle,
      Value<String>? sessionType,
      Value<DateTime>? startedAt,
      Value<DateTime>? completedAt,
      Value<int>? durationCompletedSeconds,
      Value<bool>? wasCompleted,
      Value<String?>? moodBefore,
      Value<String?>? moodAfter,
      Value<int>? rowid}) {
    return SessionRecordsTableCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      sessionTitle: sessionTitle ?? this.sessionTitle,
      sessionType: sessionType ?? this.sessionType,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      durationCompletedSeconds:
          durationCompletedSeconds ?? this.durationCompletedSeconds,
      wasCompleted: wasCompleted ?? this.wasCompleted,
      moodBefore: moodBefore ?? this.moodBefore,
      moodAfter: moodAfter ?? this.moodAfter,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (sessionTitle.present) {
      map['session_title'] = Variable<String>(sessionTitle.value);
    }
    if (sessionType.present) {
      map['session_type'] = Variable<String>(sessionType.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (durationCompletedSeconds.present) {
      map['duration_completed_seconds'] =
          Variable<int>(durationCompletedSeconds.value);
    }
    if (wasCompleted.present) {
      map['was_completed'] = Variable<bool>(wasCompleted.value);
    }
    if (moodBefore.present) {
      map['mood_before'] = Variable<String>(moodBefore.value);
    }
    if (moodAfter.present) {
      map['mood_after'] = Variable<String>(moodAfter.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionRecordsTableCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('sessionTitle: $sessionTitle, ')
          ..write('sessionType: $sessionType, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('durationCompletedSeconds: $durationCompletedSeconds, ')
          ..write('wasCompleted: $wasCompleted, ')
          ..write('moodBefore: $moodBefore, ')
          ..write('moodAfter: $moodAfter, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RemindersTableTable extends RemindersTable
    with TableInfo<$RemindersTableTable, RemindersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemindersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _slotMeta = const VerificationMeta('slot');
  @override
  late final GeneratedColumn<String> slot = GeneratedColumn<String>(
      'slot', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _hourMeta = const VerificationMeta('hour');
  @override
  late final GeneratedColumn<int> hour = GeneratedColumn<int>(
      'hour', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _minuteMeta = const VerificationMeta('minute');
  @override
  late final GeneratedColumn<int> minute = GeneratedColumn<int>(
      'minute', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _daysOfWeekMeta =
      const VerificationMeta('daysOfWeek');
  @override
  late final GeneratedColumn<String> daysOfWeek = GeneratedColumn<String>(
      'days_of_week', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isEnabledMeta =
      const VerificationMeta('isEnabled');
  @override
  late final GeneratedColumn<bool> isEnabled = GeneratedColumn<bool>(
      'is_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _soundEnabledMeta =
      const VerificationMeta('soundEnabled');
  @override
  late final GeneratedColumn<bool> soundEnabled = GeneratedColumn<bool>(
      'sound_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("sound_enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _vibrationEnabledMeta =
      const VerificationMeta('vibrationEnabled');
  @override
  late final GeneratedColumn<bool> vibrationEnabled = GeneratedColumn<bool>(
      'vibration_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("vibration_enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _customMessageMeta =
      const VerificationMeta('customMessage');
  @override
  late final GeneratedColumn<String> customMessage = GeneratedColumn<String>(
      'custom_message', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        slot,
        hour,
        minute,
        daysOfWeek,
        isEnabled,
        soundEnabled,
        vibrationEnabled,
        customMessage
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders_table';
  @override
  VerificationContext validateIntegrity(Insertable<RemindersTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('slot')) {
      context.handle(
          _slotMeta, slot.isAcceptableOrUnknown(data['slot']!, _slotMeta));
    } else if (isInserting) {
      context.missing(_slotMeta);
    }
    if (data.containsKey('hour')) {
      context.handle(
          _hourMeta, hour.isAcceptableOrUnknown(data['hour']!, _hourMeta));
    } else if (isInserting) {
      context.missing(_hourMeta);
    }
    if (data.containsKey('minute')) {
      context.handle(_minuteMeta,
          minute.isAcceptableOrUnknown(data['minute']!, _minuteMeta));
    } else if (isInserting) {
      context.missing(_minuteMeta);
    }
    if (data.containsKey('days_of_week')) {
      context.handle(
          _daysOfWeekMeta,
          daysOfWeek.isAcceptableOrUnknown(
              data['days_of_week']!, _daysOfWeekMeta));
    } else if (isInserting) {
      context.missing(_daysOfWeekMeta);
    }
    if (data.containsKey('is_enabled')) {
      context.handle(_isEnabledMeta,
          isEnabled.isAcceptableOrUnknown(data['is_enabled']!, _isEnabledMeta));
    }
    if (data.containsKey('sound_enabled')) {
      context.handle(
          _soundEnabledMeta,
          soundEnabled.isAcceptableOrUnknown(
              data['sound_enabled']!, _soundEnabledMeta));
    }
    if (data.containsKey('vibration_enabled')) {
      context.handle(
          _vibrationEnabledMeta,
          vibrationEnabled.isAcceptableOrUnknown(
              data['vibration_enabled']!, _vibrationEnabledMeta));
    }
    if (data.containsKey('custom_message')) {
      context.handle(
          _customMessageMeta,
          customMessage.isAcceptableOrUnknown(
              data['custom_message']!, _customMessageMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RemindersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RemindersTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      slot: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}slot'])!,
      hour: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}hour'])!,
      minute: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}minute'])!,
      daysOfWeek: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}days_of_week'])!,
      isEnabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_enabled'])!,
      soundEnabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}sound_enabled'])!,
      vibrationEnabled: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}vibration_enabled'])!,
      customMessage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}custom_message']),
    );
  }

  @override
  $RemindersTableTable createAlias(String alias) {
    return $RemindersTableTable(attachedDatabase, alias);
  }
}

class RemindersTableData extends DataClass
    implements Insertable<RemindersTableData> {
  final String id;
  final String slot;
  final int hour;
  final int minute;
  final String daysOfWeek;
  final bool isEnabled;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final String? customMessage;
  const RemindersTableData(
      {required this.id,
      required this.slot,
      required this.hour,
      required this.minute,
      required this.daysOfWeek,
      required this.isEnabled,
      required this.soundEnabled,
      required this.vibrationEnabled,
      this.customMessage});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['slot'] = Variable<String>(slot);
    map['hour'] = Variable<int>(hour);
    map['minute'] = Variable<int>(minute);
    map['days_of_week'] = Variable<String>(daysOfWeek);
    map['is_enabled'] = Variable<bool>(isEnabled);
    map['sound_enabled'] = Variable<bool>(soundEnabled);
    map['vibration_enabled'] = Variable<bool>(vibrationEnabled);
    if (!nullToAbsent || customMessage != null) {
      map['custom_message'] = Variable<String>(customMessage);
    }
    return map;
  }

  RemindersTableCompanion toCompanion(bool nullToAbsent) {
    return RemindersTableCompanion(
      id: Value(id),
      slot: Value(slot),
      hour: Value(hour),
      minute: Value(minute),
      daysOfWeek: Value(daysOfWeek),
      isEnabled: Value(isEnabled),
      soundEnabled: Value(soundEnabled),
      vibrationEnabled: Value(vibrationEnabled),
      customMessage: customMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(customMessage),
    );
  }

  factory RemindersTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RemindersTableData(
      id: serializer.fromJson<String>(json['id']),
      slot: serializer.fromJson<String>(json['slot']),
      hour: serializer.fromJson<int>(json['hour']),
      minute: serializer.fromJson<int>(json['minute']),
      daysOfWeek: serializer.fromJson<String>(json['daysOfWeek']),
      isEnabled: serializer.fromJson<bool>(json['isEnabled']),
      soundEnabled: serializer.fromJson<bool>(json['soundEnabled']),
      vibrationEnabled: serializer.fromJson<bool>(json['vibrationEnabled']),
      customMessage: serializer.fromJson<String?>(json['customMessage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'slot': serializer.toJson<String>(slot),
      'hour': serializer.toJson<int>(hour),
      'minute': serializer.toJson<int>(minute),
      'daysOfWeek': serializer.toJson<String>(daysOfWeek),
      'isEnabled': serializer.toJson<bool>(isEnabled),
      'soundEnabled': serializer.toJson<bool>(soundEnabled),
      'vibrationEnabled': serializer.toJson<bool>(vibrationEnabled),
      'customMessage': serializer.toJson<String?>(customMessage),
    };
  }

  RemindersTableData copyWith(
          {String? id,
          String? slot,
          int? hour,
          int? minute,
          String? daysOfWeek,
          bool? isEnabled,
          bool? soundEnabled,
          bool? vibrationEnabled,
          Value<String?> customMessage = const Value.absent()}) =>
      RemindersTableData(
        id: id ?? this.id,
        slot: slot ?? this.slot,
        hour: hour ?? this.hour,
        minute: minute ?? this.minute,
        daysOfWeek: daysOfWeek ?? this.daysOfWeek,
        isEnabled: isEnabled ?? this.isEnabled,
        soundEnabled: soundEnabled ?? this.soundEnabled,
        vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
        customMessage:
            customMessage.present ? customMessage.value : this.customMessage,
      );
  RemindersTableData copyWithCompanion(RemindersTableCompanion data) {
    return RemindersTableData(
      id: data.id.present ? data.id.value : this.id,
      slot: data.slot.present ? data.slot.value : this.slot,
      hour: data.hour.present ? data.hour.value : this.hour,
      minute: data.minute.present ? data.minute.value : this.minute,
      daysOfWeek:
          data.daysOfWeek.present ? data.daysOfWeek.value : this.daysOfWeek,
      isEnabled: data.isEnabled.present ? data.isEnabled.value : this.isEnabled,
      soundEnabled: data.soundEnabled.present
          ? data.soundEnabled.value
          : this.soundEnabled,
      vibrationEnabled: data.vibrationEnabled.present
          ? data.vibrationEnabled.value
          : this.vibrationEnabled,
      customMessage: data.customMessage.present
          ? data.customMessage.value
          : this.customMessage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RemindersTableData(')
          ..write('id: $id, ')
          ..write('slot: $slot, ')
          ..write('hour: $hour, ')
          ..write('minute: $minute, ')
          ..write('daysOfWeek: $daysOfWeek, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('soundEnabled: $soundEnabled, ')
          ..write('vibrationEnabled: $vibrationEnabled, ')
          ..write('customMessage: $customMessage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, slot, hour, minute, daysOfWeek, isEnabled,
      soundEnabled, vibrationEnabled, customMessage);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RemindersTableData &&
          other.id == this.id &&
          other.slot == this.slot &&
          other.hour == this.hour &&
          other.minute == this.minute &&
          other.daysOfWeek == this.daysOfWeek &&
          other.isEnabled == this.isEnabled &&
          other.soundEnabled == this.soundEnabled &&
          other.vibrationEnabled == this.vibrationEnabled &&
          other.customMessage == this.customMessage);
}

class RemindersTableCompanion extends UpdateCompanion<RemindersTableData> {
  final Value<String> id;
  final Value<String> slot;
  final Value<int> hour;
  final Value<int> minute;
  final Value<String> daysOfWeek;
  final Value<bool> isEnabled;
  final Value<bool> soundEnabled;
  final Value<bool> vibrationEnabled;
  final Value<String?> customMessage;
  final Value<int> rowid;
  const RemindersTableCompanion({
    this.id = const Value.absent(),
    this.slot = const Value.absent(),
    this.hour = const Value.absent(),
    this.minute = const Value.absent(),
    this.daysOfWeek = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.soundEnabled = const Value.absent(),
    this.vibrationEnabled = const Value.absent(),
    this.customMessage = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RemindersTableCompanion.insert({
    required String id,
    required String slot,
    required int hour,
    required int minute,
    required String daysOfWeek,
    this.isEnabled = const Value.absent(),
    this.soundEnabled = const Value.absent(),
    this.vibrationEnabled = const Value.absent(),
    this.customMessage = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        slot = Value(slot),
        hour = Value(hour),
        minute = Value(minute),
        daysOfWeek = Value(daysOfWeek);
  static Insertable<RemindersTableData> custom({
    Expression<String>? id,
    Expression<String>? slot,
    Expression<int>? hour,
    Expression<int>? minute,
    Expression<String>? daysOfWeek,
    Expression<bool>? isEnabled,
    Expression<bool>? soundEnabled,
    Expression<bool>? vibrationEnabled,
    Expression<String>? customMessage,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (slot != null) 'slot': slot,
      if (hour != null) 'hour': hour,
      if (minute != null) 'minute': minute,
      if (daysOfWeek != null) 'days_of_week': daysOfWeek,
      if (isEnabled != null) 'is_enabled': isEnabled,
      if (soundEnabled != null) 'sound_enabled': soundEnabled,
      if (vibrationEnabled != null) 'vibration_enabled': vibrationEnabled,
      if (customMessage != null) 'custom_message': customMessage,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RemindersTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? slot,
      Value<int>? hour,
      Value<int>? minute,
      Value<String>? daysOfWeek,
      Value<bool>? isEnabled,
      Value<bool>? soundEnabled,
      Value<bool>? vibrationEnabled,
      Value<String?>? customMessage,
      Value<int>? rowid}) {
    return RemindersTableCompanion(
      id: id ?? this.id,
      slot: slot ?? this.slot,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      isEnabled: isEnabled ?? this.isEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      customMessage: customMessage ?? this.customMessage,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (slot.present) {
      map['slot'] = Variable<String>(slot.value);
    }
    if (hour.present) {
      map['hour'] = Variable<int>(hour.value);
    }
    if (minute.present) {
      map['minute'] = Variable<int>(minute.value);
    }
    if (daysOfWeek.present) {
      map['days_of_week'] = Variable<String>(daysOfWeek.value);
    }
    if (isEnabled.present) {
      map['is_enabled'] = Variable<bool>(isEnabled.value);
    }
    if (soundEnabled.present) {
      map['sound_enabled'] = Variable<bool>(soundEnabled.value);
    }
    if (vibrationEnabled.present) {
      map['vibration_enabled'] = Variable<bool>(vibrationEnabled.value);
    }
    if (customMessage.present) {
      map['custom_message'] = Variable<String>(customMessage.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemindersTableCompanion(')
          ..write('id: $id, ')
          ..write('slot: $slot, ')
          ..write('hour: $hour, ')
          ..write('minute: $minute, ')
          ..write('daysOfWeek: $daysOfWeek, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('soundEnabled: $soundEnabled, ')
          ..write('vibrationEnabled: $vibrationEnabled, ')
          ..write('customMessage: $customMessage, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FavoritesTableTable extends FavoritesTable
    with TableInfo<$FavoritesTableTable, FavoritesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FavoritesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sessionIdMeta =
      const VerificationMeta('sessionId');
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
      'session_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [sessionId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'favorites_table';
  @override
  VerificationContext validateIntegrity(Insertable<FavoritesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('session_id')) {
      context.handle(_sessionIdMeta,
          sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta));
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {sessionId};
  @override
  FavoritesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FavoritesTableData(
      sessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}session_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $FavoritesTableTable createAlias(String alias) {
    return $FavoritesTableTable(attachedDatabase, alias);
  }
}

class FavoritesTableData extends DataClass
    implements Insertable<FavoritesTableData> {
  final String sessionId;
  final DateTime createdAt;
  const FavoritesTableData({required this.sessionId, required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['session_id'] = Variable<String>(sessionId);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  FavoritesTableCompanion toCompanion(bool nullToAbsent) {
    return FavoritesTableCompanion(
      sessionId: Value(sessionId),
      createdAt: Value(createdAt),
    );
  }

  factory FavoritesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FavoritesTableData(
      sessionId: serializer.fromJson<String>(json['sessionId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'sessionId': serializer.toJson<String>(sessionId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  FavoritesTableData copyWith({String? sessionId, DateTime? createdAt}) =>
      FavoritesTableData(
        sessionId: sessionId ?? this.sessionId,
        createdAt: createdAt ?? this.createdAt,
      );
  FavoritesTableData copyWithCompanion(FavoritesTableCompanion data) {
    return FavoritesTableData(
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FavoritesTableData(')
          ..write('sessionId: $sessionId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(sessionId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FavoritesTableData &&
          other.sessionId == this.sessionId &&
          other.createdAt == this.createdAt);
}

class FavoritesTableCompanion extends UpdateCompanion<FavoritesTableData> {
  final Value<String> sessionId;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const FavoritesTableCompanion({
    this.sessionId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FavoritesTableCompanion.insert({
    required String sessionId,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : sessionId = Value(sessionId),
        createdAt = Value(createdAt);
  static Insertable<FavoritesTableData> custom({
    Expression<String>? sessionId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (sessionId != null) 'session_id': sessionId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FavoritesTableCompanion copyWith(
      {Value<String>? sessionId,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return FavoritesTableCompanion(
      sessionId: sessionId ?? this.sessionId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavoritesTableCompanion(')
          ..write('sessionId: $sessionId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BreathingPatternsTableTable extends BreathingPatternsTable
    with TableInfo<$BreathingPatternsTableTable, BreathingPatternsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BreathingPatternsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _inhaleSecondsMeta =
      const VerificationMeta('inhaleSeconds');
  @override
  late final GeneratedColumn<int> inhaleSeconds = GeneratedColumn<int>(
      'inhale_seconds', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _holdAfterInhaleSecondsMeta =
      const VerificationMeta('holdAfterInhaleSeconds');
  @override
  late final GeneratedColumn<int> holdAfterInhaleSeconds = GeneratedColumn<int>(
      'hold_after_inhale_seconds', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _exhaleSecondsMeta =
      const VerificationMeta('exhaleSeconds');
  @override
  late final GeneratedColumn<int> exhaleSeconds = GeneratedColumn<int>(
      'exhale_seconds', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _holdAfterExhaleSecondsMeta =
      const VerificationMeta('holdAfterExhaleSeconds');
  @override
  late final GeneratedColumn<int> holdAfterExhaleSeconds = GeneratedColumn<int>(
      'hold_after_exhale_seconds', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _totalCyclesMeta =
      const VerificationMeta('totalCycles');
  @override
  late final GeneratedColumn<int> totalCycles = GeneratedColumn<int>(
      'total_cycles', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(4));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        description,
        inhaleSeconds,
        holdAfterInhaleSeconds,
        exhaleSeconds,
        holdAfterExhaleSeconds,
        totalCycles
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'breathing_patterns_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<BreathingPatternsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('inhale_seconds')) {
      context.handle(
          _inhaleSecondsMeta,
          inhaleSeconds.isAcceptableOrUnknown(
              data['inhale_seconds']!, _inhaleSecondsMeta));
    } else if (isInserting) {
      context.missing(_inhaleSecondsMeta);
    }
    if (data.containsKey('hold_after_inhale_seconds')) {
      context.handle(
          _holdAfterInhaleSecondsMeta,
          holdAfterInhaleSeconds.isAcceptableOrUnknown(
              data['hold_after_inhale_seconds']!, _holdAfterInhaleSecondsMeta));
    } else if (isInserting) {
      context.missing(_holdAfterInhaleSecondsMeta);
    }
    if (data.containsKey('exhale_seconds')) {
      context.handle(
          _exhaleSecondsMeta,
          exhaleSeconds.isAcceptableOrUnknown(
              data['exhale_seconds']!, _exhaleSecondsMeta));
    } else if (isInserting) {
      context.missing(_exhaleSecondsMeta);
    }
    if (data.containsKey('hold_after_exhale_seconds')) {
      context.handle(
          _holdAfterExhaleSecondsMeta,
          holdAfterExhaleSeconds.isAcceptableOrUnknown(
              data['hold_after_exhale_seconds']!, _holdAfterExhaleSecondsMeta));
    } else if (isInserting) {
      context.missing(_holdAfterExhaleSecondsMeta);
    }
    if (data.containsKey('total_cycles')) {
      context.handle(
          _totalCyclesMeta,
          totalCycles.isAcceptableOrUnknown(
              data['total_cycles']!, _totalCyclesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BreathingPatternsTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BreathingPatternsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      inhaleSeconds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}inhale_seconds'])!,
      holdAfterInhaleSeconds: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}hold_after_inhale_seconds'])!,
      exhaleSeconds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}exhale_seconds'])!,
      holdAfterExhaleSeconds: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}hold_after_exhale_seconds'])!,
      totalCycles: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_cycles'])!,
    );
  }

  @override
  $BreathingPatternsTableTable createAlias(String alias) {
    return $BreathingPatternsTableTable(attachedDatabase, alias);
  }
}

class BreathingPatternsTableData extends DataClass
    implements Insertable<BreathingPatternsTableData> {
  final String id;
  final String name;
  final String description;
  final int inhaleSeconds;
  final int holdAfterInhaleSeconds;
  final int exhaleSeconds;
  final int holdAfterExhaleSeconds;
  final int totalCycles;
  const BreathingPatternsTableData(
      {required this.id,
      required this.name,
      required this.description,
      required this.inhaleSeconds,
      required this.holdAfterInhaleSeconds,
      required this.exhaleSeconds,
      required this.holdAfterExhaleSeconds,
      required this.totalCycles});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['inhale_seconds'] = Variable<int>(inhaleSeconds);
    map['hold_after_inhale_seconds'] = Variable<int>(holdAfterInhaleSeconds);
    map['exhale_seconds'] = Variable<int>(exhaleSeconds);
    map['hold_after_exhale_seconds'] = Variable<int>(holdAfterExhaleSeconds);
    map['total_cycles'] = Variable<int>(totalCycles);
    return map;
  }

  BreathingPatternsTableCompanion toCompanion(bool nullToAbsent) {
    return BreathingPatternsTableCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
      inhaleSeconds: Value(inhaleSeconds),
      holdAfterInhaleSeconds: Value(holdAfterInhaleSeconds),
      exhaleSeconds: Value(exhaleSeconds),
      holdAfterExhaleSeconds: Value(holdAfterExhaleSeconds),
      totalCycles: Value(totalCycles),
    );
  }

  factory BreathingPatternsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BreathingPatternsTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      inhaleSeconds: serializer.fromJson<int>(json['inhaleSeconds']),
      holdAfterInhaleSeconds:
          serializer.fromJson<int>(json['holdAfterInhaleSeconds']),
      exhaleSeconds: serializer.fromJson<int>(json['exhaleSeconds']),
      holdAfterExhaleSeconds:
          serializer.fromJson<int>(json['holdAfterExhaleSeconds']),
      totalCycles: serializer.fromJson<int>(json['totalCycles']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'inhaleSeconds': serializer.toJson<int>(inhaleSeconds),
      'holdAfterInhaleSeconds': serializer.toJson<int>(holdAfterInhaleSeconds),
      'exhaleSeconds': serializer.toJson<int>(exhaleSeconds),
      'holdAfterExhaleSeconds': serializer.toJson<int>(holdAfterExhaleSeconds),
      'totalCycles': serializer.toJson<int>(totalCycles),
    };
  }

  BreathingPatternsTableData copyWith(
          {String? id,
          String? name,
          String? description,
          int? inhaleSeconds,
          int? holdAfterInhaleSeconds,
          int? exhaleSeconds,
          int? holdAfterExhaleSeconds,
          int? totalCycles}) =>
      BreathingPatternsTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        inhaleSeconds: inhaleSeconds ?? this.inhaleSeconds,
        holdAfterInhaleSeconds:
            holdAfterInhaleSeconds ?? this.holdAfterInhaleSeconds,
        exhaleSeconds: exhaleSeconds ?? this.exhaleSeconds,
        holdAfterExhaleSeconds:
            holdAfterExhaleSeconds ?? this.holdAfterExhaleSeconds,
        totalCycles: totalCycles ?? this.totalCycles,
      );
  BreathingPatternsTableData copyWithCompanion(
      BreathingPatternsTableCompanion data) {
    return BreathingPatternsTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      inhaleSeconds: data.inhaleSeconds.present
          ? data.inhaleSeconds.value
          : this.inhaleSeconds,
      holdAfterInhaleSeconds: data.holdAfterInhaleSeconds.present
          ? data.holdAfterInhaleSeconds.value
          : this.holdAfterInhaleSeconds,
      exhaleSeconds: data.exhaleSeconds.present
          ? data.exhaleSeconds.value
          : this.exhaleSeconds,
      holdAfterExhaleSeconds: data.holdAfterExhaleSeconds.present
          ? data.holdAfterExhaleSeconds.value
          : this.holdAfterExhaleSeconds,
      totalCycles:
          data.totalCycles.present ? data.totalCycles.value : this.totalCycles,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BreathingPatternsTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('inhaleSeconds: $inhaleSeconds, ')
          ..write('holdAfterInhaleSeconds: $holdAfterInhaleSeconds, ')
          ..write('exhaleSeconds: $exhaleSeconds, ')
          ..write('holdAfterExhaleSeconds: $holdAfterExhaleSeconds, ')
          ..write('totalCycles: $totalCycles')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      description,
      inhaleSeconds,
      holdAfterInhaleSeconds,
      exhaleSeconds,
      holdAfterExhaleSeconds,
      totalCycles);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BreathingPatternsTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.inhaleSeconds == this.inhaleSeconds &&
          other.holdAfterInhaleSeconds == this.holdAfterInhaleSeconds &&
          other.exhaleSeconds == this.exhaleSeconds &&
          other.holdAfterExhaleSeconds == this.holdAfterExhaleSeconds &&
          other.totalCycles == this.totalCycles);
}

class BreathingPatternsTableCompanion
    extends UpdateCompanion<BreathingPatternsTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> description;
  final Value<int> inhaleSeconds;
  final Value<int> holdAfterInhaleSeconds;
  final Value<int> exhaleSeconds;
  final Value<int> holdAfterExhaleSeconds;
  final Value<int> totalCycles;
  final Value<int> rowid;
  const BreathingPatternsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.inhaleSeconds = const Value.absent(),
    this.holdAfterInhaleSeconds = const Value.absent(),
    this.exhaleSeconds = const Value.absent(),
    this.holdAfterExhaleSeconds = const Value.absent(),
    this.totalCycles = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BreathingPatternsTableCompanion.insert({
    required String id,
    required String name,
    required String description,
    required int inhaleSeconds,
    required int holdAfterInhaleSeconds,
    required int exhaleSeconds,
    required int holdAfterExhaleSeconds,
    this.totalCycles = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        description = Value(description),
        inhaleSeconds = Value(inhaleSeconds),
        holdAfterInhaleSeconds = Value(holdAfterInhaleSeconds),
        exhaleSeconds = Value(exhaleSeconds),
        holdAfterExhaleSeconds = Value(holdAfterExhaleSeconds);
  static Insertable<BreathingPatternsTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<int>? inhaleSeconds,
    Expression<int>? holdAfterInhaleSeconds,
    Expression<int>? exhaleSeconds,
    Expression<int>? holdAfterExhaleSeconds,
    Expression<int>? totalCycles,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (inhaleSeconds != null) 'inhale_seconds': inhaleSeconds,
      if (holdAfterInhaleSeconds != null)
        'hold_after_inhale_seconds': holdAfterInhaleSeconds,
      if (exhaleSeconds != null) 'exhale_seconds': exhaleSeconds,
      if (holdAfterExhaleSeconds != null)
        'hold_after_exhale_seconds': holdAfterExhaleSeconds,
      if (totalCycles != null) 'total_cycles': totalCycles,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BreathingPatternsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? description,
      Value<int>? inhaleSeconds,
      Value<int>? holdAfterInhaleSeconds,
      Value<int>? exhaleSeconds,
      Value<int>? holdAfterExhaleSeconds,
      Value<int>? totalCycles,
      Value<int>? rowid}) {
    return BreathingPatternsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      inhaleSeconds: inhaleSeconds ?? this.inhaleSeconds,
      holdAfterInhaleSeconds:
          holdAfterInhaleSeconds ?? this.holdAfterInhaleSeconds,
      exhaleSeconds: exhaleSeconds ?? this.exhaleSeconds,
      holdAfterExhaleSeconds:
          holdAfterExhaleSeconds ?? this.holdAfterExhaleSeconds,
      totalCycles: totalCycles ?? this.totalCycles,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (inhaleSeconds.present) {
      map['inhale_seconds'] = Variable<int>(inhaleSeconds.value);
    }
    if (holdAfterInhaleSeconds.present) {
      map['hold_after_inhale_seconds'] =
          Variable<int>(holdAfterInhaleSeconds.value);
    }
    if (exhaleSeconds.present) {
      map['exhale_seconds'] = Variable<int>(exhaleSeconds.value);
    }
    if (holdAfterExhaleSeconds.present) {
      map['hold_after_exhale_seconds'] =
          Variable<int>(holdAfterExhaleSeconds.value);
    }
    if (totalCycles.present) {
      map['total_cycles'] = Variable<int>(totalCycles.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BreathingPatternsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('inhaleSeconds: $inhaleSeconds, ')
          ..write('holdAfterInhaleSeconds: $holdAfterInhaleSeconds, ')
          ..write('exhaleSeconds: $exhaleSeconds, ')
          ..write('holdAfterExhaleSeconds: $holdAfterExhaleSeconds, ')
          ..write('totalCycles: $totalCycles, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTableTable extends AppSettingsTable
    with TableInfo<$AppSettingsTableTable, AppSettingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _offlineAudioCachedMeta =
      const VerificationMeta('offlineAudioCached');
  @override
  late final GeneratedColumn<bool> offlineAudioCached = GeneratedColumn<bool>(
      'offline_audio_cached', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("offline_audio_cached" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _backgroundAudioEnabledMeta =
      const VerificationMeta('backgroundAudioEnabled');
  @override
  late final GeneratedColumn<bool> backgroundAudioEnabled =
      GeneratedColumn<bool>('background_audio_enabled', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'CHECK ("background_audio_enabled" IN (0, 1))'),
          defaultValue: const Constant(true));
  static const VerificationMeta _analyticsOptInMeta =
      const VerificationMeta('analyticsOptIn');
  @override
  late final GeneratedColumn<bool> analyticsOptIn = GeneratedColumn<bool>(
      'analytics_opt_in', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("analytics_opt_in" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _lastBackupTimestampMeta =
      const VerificationMeta('lastBackupTimestamp');
  @override
  late final GeneratedColumn<DateTime> lastBackupTimestamp =
      GeneratedColumn<DateTime>('last_backup_timestamp', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _databaseVersionMeta =
      const VerificationMeta('databaseVersion');
  @override
  late final GeneratedColumn<int> databaseVersion = GeneratedColumn<int>(
      'database_version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        offlineAudioCached,
        backgroundAudioEnabled,
        analyticsOptIn,
        lastBackupTimestamp,
        databaseVersion
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<AppSettingsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('offline_audio_cached')) {
      context.handle(
          _offlineAudioCachedMeta,
          offlineAudioCached.isAcceptableOrUnknown(
              data['offline_audio_cached']!, _offlineAudioCachedMeta));
    }
    if (data.containsKey('background_audio_enabled')) {
      context.handle(
          _backgroundAudioEnabledMeta,
          backgroundAudioEnabled.isAcceptableOrUnknown(
              data['background_audio_enabled']!, _backgroundAudioEnabledMeta));
    }
    if (data.containsKey('analytics_opt_in')) {
      context.handle(
          _analyticsOptInMeta,
          analyticsOptIn.isAcceptableOrUnknown(
              data['analytics_opt_in']!, _analyticsOptInMeta));
    }
    if (data.containsKey('last_backup_timestamp')) {
      context.handle(
          _lastBackupTimestampMeta,
          lastBackupTimestamp.isAcceptableOrUnknown(
              data['last_backup_timestamp']!, _lastBackupTimestampMeta));
    }
    if (data.containsKey('database_version')) {
      context.handle(
          _databaseVersionMeta,
          databaseVersion.isAcceptableOrUnknown(
              data['database_version']!, _databaseVersionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSettingsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSettingsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      offlineAudioCached: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}offline_audio_cached'])!,
      backgroundAudioEnabled: attachedDatabase.typeMapping.read(
          DriftSqlType.bool,
          data['${effectivePrefix}background_audio_enabled'])!,
      analyticsOptIn: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}analytics_opt_in'])!,
      lastBackupTimestamp: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}last_backup_timestamp']),
      databaseVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}database_version'])!,
    );
  }

  @override
  $AppSettingsTableTable createAlias(String alias) {
    return $AppSettingsTableTable(attachedDatabase, alias);
  }
}

class AppSettingsTableData extends DataClass
    implements Insertable<AppSettingsTableData> {
  final String id;
  final bool offlineAudioCached;
  final bool backgroundAudioEnabled;
  final bool analyticsOptIn;
  final DateTime? lastBackupTimestamp;
  final int databaseVersion;
  const AppSettingsTableData(
      {required this.id,
      required this.offlineAudioCached,
      required this.backgroundAudioEnabled,
      required this.analyticsOptIn,
      this.lastBackupTimestamp,
      required this.databaseVersion});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['offline_audio_cached'] = Variable<bool>(offlineAudioCached);
    map['background_audio_enabled'] = Variable<bool>(backgroundAudioEnabled);
    map['analytics_opt_in'] = Variable<bool>(analyticsOptIn);
    if (!nullToAbsent || lastBackupTimestamp != null) {
      map['last_backup_timestamp'] = Variable<DateTime>(lastBackupTimestamp);
    }
    map['database_version'] = Variable<int>(databaseVersion);
    return map;
  }

  AppSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsTableCompanion(
      id: Value(id),
      offlineAudioCached: Value(offlineAudioCached),
      backgroundAudioEnabled: Value(backgroundAudioEnabled),
      analyticsOptIn: Value(analyticsOptIn),
      lastBackupTimestamp: lastBackupTimestamp == null && nullToAbsent
          ? const Value.absent()
          : Value(lastBackupTimestamp),
      databaseVersion: Value(databaseVersion),
    );
  }

  factory AppSettingsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSettingsTableData(
      id: serializer.fromJson<String>(json['id']),
      offlineAudioCached: serializer.fromJson<bool>(json['offlineAudioCached']),
      backgroundAudioEnabled:
          serializer.fromJson<bool>(json['backgroundAudioEnabled']),
      analyticsOptIn: serializer.fromJson<bool>(json['analyticsOptIn']),
      lastBackupTimestamp:
          serializer.fromJson<DateTime?>(json['lastBackupTimestamp']),
      databaseVersion: serializer.fromJson<int>(json['databaseVersion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'offlineAudioCached': serializer.toJson<bool>(offlineAudioCached),
      'backgroundAudioEnabled': serializer.toJson<bool>(backgroundAudioEnabled),
      'analyticsOptIn': serializer.toJson<bool>(analyticsOptIn),
      'lastBackupTimestamp': serializer.toJson<DateTime?>(lastBackupTimestamp),
      'databaseVersion': serializer.toJson<int>(databaseVersion),
    };
  }

  AppSettingsTableData copyWith(
          {String? id,
          bool? offlineAudioCached,
          bool? backgroundAudioEnabled,
          bool? analyticsOptIn,
          Value<DateTime?> lastBackupTimestamp = const Value.absent(),
          int? databaseVersion}) =>
      AppSettingsTableData(
        id: id ?? this.id,
        offlineAudioCached: offlineAudioCached ?? this.offlineAudioCached,
        backgroundAudioEnabled:
            backgroundAudioEnabled ?? this.backgroundAudioEnabled,
        analyticsOptIn: analyticsOptIn ?? this.analyticsOptIn,
        lastBackupTimestamp: lastBackupTimestamp.present
            ? lastBackupTimestamp.value
            : this.lastBackupTimestamp,
        databaseVersion: databaseVersion ?? this.databaseVersion,
      );
  AppSettingsTableData copyWithCompanion(AppSettingsTableCompanion data) {
    return AppSettingsTableData(
      id: data.id.present ? data.id.value : this.id,
      offlineAudioCached: data.offlineAudioCached.present
          ? data.offlineAudioCached.value
          : this.offlineAudioCached,
      backgroundAudioEnabled: data.backgroundAudioEnabled.present
          ? data.backgroundAudioEnabled.value
          : this.backgroundAudioEnabled,
      analyticsOptIn: data.analyticsOptIn.present
          ? data.analyticsOptIn.value
          : this.analyticsOptIn,
      lastBackupTimestamp: data.lastBackupTimestamp.present
          ? data.lastBackupTimestamp.value
          : this.lastBackupTimestamp,
      databaseVersion: data.databaseVersion.present
          ? data.databaseVersion.value
          : this.databaseVersion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsTableData(')
          ..write('id: $id, ')
          ..write('offlineAudioCached: $offlineAudioCached, ')
          ..write('backgroundAudioEnabled: $backgroundAudioEnabled, ')
          ..write('analyticsOptIn: $analyticsOptIn, ')
          ..write('lastBackupTimestamp: $lastBackupTimestamp, ')
          ..write('databaseVersion: $databaseVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      offlineAudioCached,
      backgroundAudioEnabled,
      analyticsOptIn,
      lastBackupTimestamp,
      databaseVersion);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSettingsTableData &&
          other.id == this.id &&
          other.offlineAudioCached == this.offlineAudioCached &&
          other.backgroundAudioEnabled == this.backgroundAudioEnabled &&
          other.analyticsOptIn == this.analyticsOptIn &&
          other.lastBackupTimestamp == this.lastBackupTimestamp &&
          other.databaseVersion == this.databaseVersion);
}

class AppSettingsTableCompanion extends UpdateCompanion<AppSettingsTableData> {
  final Value<String> id;
  final Value<bool> offlineAudioCached;
  final Value<bool> backgroundAudioEnabled;
  final Value<bool> analyticsOptIn;
  final Value<DateTime?> lastBackupTimestamp;
  final Value<int> databaseVersion;
  final Value<int> rowid;
  const AppSettingsTableCompanion({
    this.id = const Value.absent(),
    this.offlineAudioCached = const Value.absent(),
    this.backgroundAudioEnabled = const Value.absent(),
    this.analyticsOptIn = const Value.absent(),
    this.lastBackupTimestamp = const Value.absent(),
    this.databaseVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsTableCompanion.insert({
    required String id,
    this.offlineAudioCached = const Value.absent(),
    this.backgroundAudioEnabled = const Value.absent(),
    this.analyticsOptIn = const Value.absent(),
    this.lastBackupTimestamp = const Value.absent(),
    this.databaseVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<AppSettingsTableData> custom({
    Expression<String>? id,
    Expression<bool>? offlineAudioCached,
    Expression<bool>? backgroundAudioEnabled,
    Expression<bool>? analyticsOptIn,
    Expression<DateTime>? lastBackupTimestamp,
    Expression<int>? databaseVersion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (offlineAudioCached != null)
        'offline_audio_cached': offlineAudioCached,
      if (backgroundAudioEnabled != null)
        'background_audio_enabled': backgroundAudioEnabled,
      if (analyticsOptIn != null) 'analytics_opt_in': analyticsOptIn,
      if (lastBackupTimestamp != null)
        'last_backup_timestamp': lastBackupTimestamp,
      if (databaseVersion != null) 'database_version': databaseVersion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsTableCompanion copyWith(
      {Value<String>? id,
      Value<bool>? offlineAudioCached,
      Value<bool>? backgroundAudioEnabled,
      Value<bool>? analyticsOptIn,
      Value<DateTime?>? lastBackupTimestamp,
      Value<int>? databaseVersion,
      Value<int>? rowid}) {
    return AppSettingsTableCompanion(
      id: id ?? this.id,
      offlineAudioCached: offlineAudioCached ?? this.offlineAudioCached,
      backgroundAudioEnabled:
          backgroundAudioEnabled ?? this.backgroundAudioEnabled,
      analyticsOptIn: analyticsOptIn ?? this.analyticsOptIn,
      lastBackupTimestamp: lastBackupTimestamp ?? this.lastBackupTimestamp,
      databaseVersion: databaseVersion ?? this.databaseVersion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (offlineAudioCached.present) {
      map['offline_audio_cached'] = Variable<bool>(offlineAudioCached.value);
    }
    if (backgroundAudioEnabled.present) {
      map['background_audio_enabled'] =
          Variable<bool>(backgroundAudioEnabled.value);
    }
    if (analyticsOptIn.present) {
      map['analytics_opt_in'] = Variable<bool>(analyticsOptIn.value);
    }
    if (lastBackupTimestamp.present) {
      map['last_backup_timestamp'] =
          Variable<DateTime>(lastBackupTimestamp.value);
    }
    if (databaseVersion.present) {
      map['database_version'] = Variable<int>(databaseVersion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('offlineAudioCached: $offlineAudioCached, ')
          ..write('backgroundAudioEnabled: $backgroundAudioEnabled, ')
          ..write('analyticsOptIn: $analyticsOptIn, ')
          ..write('lastBackupTimestamp: $lastBackupTimestamp, ')
          ..write('databaseVersion: $databaseVersion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserPreferencesTableTable userPreferencesTable =
      $UserPreferencesTableTable(this);
  late final $MoodEntriesTableTable moodEntriesTable =
      $MoodEntriesTableTable(this);
  late final $SessionsTableTable sessionsTable = $SessionsTableTable(this);
  late final $SessionRecordsTableTable sessionRecordsTable =
      $SessionRecordsTableTable(this);
  late final $RemindersTableTable remindersTable = $RemindersTableTable(this);
  late final $FavoritesTableTable favoritesTable = $FavoritesTableTable(this);
  late final $BreathingPatternsTableTable breathingPatternsTable =
      $BreathingPatternsTableTable(this);
  late final $AppSettingsTableTable appSettingsTable =
      $AppSettingsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        userPreferencesTable,
        moodEntriesTable,
        sessionsTable,
        sessionRecordsTable,
        remindersTable,
        favoritesTable,
        breathingPatternsTable,
        appSettingsTable
      ];
}

typedef $$UserPreferencesTableTableCreateCompanionBuilder
    = UserPreferencesTableCompanion Function({
  required String id,
  Value<String> firstName,
  Value<String> goals,
  Value<int> preferredDurationSeconds,
  Value<int> preferredTimeOfDayIndex,
  Value<int> customReminderHour,
  Value<int> customReminderMinute,
  Value<bool> notificationsEnabled,
  Value<int> themeModeIndex,
  Value<bool> reducedMotion,
  Value<bool> hapticsEnabled,
  Value<bool> onboardingCompleted,
  Value<int> rowid,
});
typedef $$UserPreferencesTableTableUpdateCompanionBuilder
    = UserPreferencesTableCompanion Function({
  Value<String> id,
  Value<String> firstName,
  Value<String> goals,
  Value<int> preferredDurationSeconds,
  Value<int> preferredTimeOfDayIndex,
  Value<int> customReminderHour,
  Value<int> customReminderMinute,
  Value<bool> notificationsEnabled,
  Value<int> themeModeIndex,
  Value<bool> reducedMotion,
  Value<bool> hapticsEnabled,
  Value<bool> onboardingCompleted,
  Value<int> rowid,
});

class $$UserPreferencesTableTableFilterComposer
    extends Composer<_$AppDatabase, $UserPreferencesTableTable> {
  $$UserPreferencesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get firstName => $composableBuilder(
      column: $table.firstName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get goals => $composableBuilder(
      column: $table.goals, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get preferredDurationSeconds => $composableBuilder(
      column: $table.preferredDurationSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get preferredTimeOfDayIndex => $composableBuilder(
      column: $table.preferredTimeOfDayIndex,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get customReminderHour => $composableBuilder(
      column: $table.customReminderHour,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get customReminderMinute => $composableBuilder(
      column: $table.customReminderMinute,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get notificationsEnabled => $composableBuilder(
      column: $table.notificationsEnabled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get themeModeIndex => $composableBuilder(
      column: $table.themeModeIndex,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get reducedMotion => $composableBuilder(
      column: $table.reducedMotion, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get hapticsEnabled => $composableBuilder(
      column: $table.hapticsEnabled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get onboardingCompleted => $composableBuilder(
      column: $table.onboardingCompleted,
      builder: (column) => ColumnFilters(column));
}

class $$UserPreferencesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UserPreferencesTableTable> {
  $$UserPreferencesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get firstName => $composableBuilder(
      column: $table.firstName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get goals => $composableBuilder(
      column: $table.goals, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get preferredDurationSeconds => $composableBuilder(
      column: $table.preferredDurationSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get preferredTimeOfDayIndex => $composableBuilder(
      column: $table.preferredTimeOfDayIndex,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get customReminderHour => $composableBuilder(
      column: $table.customReminderHour,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get customReminderMinute => $composableBuilder(
      column: $table.customReminderMinute,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get notificationsEnabled => $composableBuilder(
      column: $table.notificationsEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get themeModeIndex => $composableBuilder(
      column: $table.themeModeIndex,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get reducedMotion => $composableBuilder(
      column: $table.reducedMotion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get hapticsEnabled => $composableBuilder(
      column: $table.hapticsEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get onboardingCompleted => $composableBuilder(
      column: $table.onboardingCompleted,
      builder: (column) => ColumnOrderings(column));
}

class $$UserPreferencesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserPreferencesTableTable> {
  $$UserPreferencesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get goals =>
      $composableBuilder(column: $table.goals, builder: (column) => column);

  GeneratedColumn<int> get preferredDurationSeconds => $composableBuilder(
      column: $table.preferredDurationSeconds, builder: (column) => column);

  GeneratedColumn<int> get preferredTimeOfDayIndex => $composableBuilder(
      column: $table.preferredTimeOfDayIndex, builder: (column) => column);

  GeneratedColumn<int> get customReminderHour => $composableBuilder(
      column: $table.customReminderHour, builder: (column) => column);

  GeneratedColumn<int> get customReminderMinute => $composableBuilder(
      column: $table.customReminderMinute, builder: (column) => column);

  GeneratedColumn<bool> get notificationsEnabled => $composableBuilder(
      column: $table.notificationsEnabled, builder: (column) => column);

  GeneratedColumn<int> get themeModeIndex => $composableBuilder(
      column: $table.themeModeIndex, builder: (column) => column);

  GeneratedColumn<bool> get reducedMotion => $composableBuilder(
      column: $table.reducedMotion, builder: (column) => column);

  GeneratedColumn<bool> get hapticsEnabled => $composableBuilder(
      column: $table.hapticsEnabled, builder: (column) => column);

  GeneratedColumn<bool> get onboardingCompleted => $composableBuilder(
      column: $table.onboardingCompleted, builder: (column) => column);
}

class $$UserPreferencesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserPreferencesTableTable,
    UserPreferencesTableData,
    $$UserPreferencesTableTableFilterComposer,
    $$UserPreferencesTableTableOrderingComposer,
    $$UserPreferencesTableTableAnnotationComposer,
    $$UserPreferencesTableTableCreateCompanionBuilder,
    $$UserPreferencesTableTableUpdateCompanionBuilder,
    (
      UserPreferencesTableData,
      BaseReferences<_$AppDatabase, $UserPreferencesTableTable,
          UserPreferencesTableData>
    ),
    UserPreferencesTableData,
    PrefetchHooks Function()> {
  $$UserPreferencesTableTableTableManager(
      _$AppDatabase db, $UserPreferencesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserPreferencesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserPreferencesTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserPreferencesTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> firstName = const Value.absent(),
            Value<String> goals = const Value.absent(),
            Value<int> preferredDurationSeconds = const Value.absent(),
            Value<int> preferredTimeOfDayIndex = const Value.absent(),
            Value<int> customReminderHour = const Value.absent(),
            Value<int> customReminderMinute = const Value.absent(),
            Value<bool> notificationsEnabled = const Value.absent(),
            Value<int> themeModeIndex = const Value.absent(),
            Value<bool> reducedMotion = const Value.absent(),
            Value<bool> hapticsEnabled = const Value.absent(),
            Value<bool> onboardingCompleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UserPreferencesTableCompanion(
            id: id,
            firstName: firstName,
            goals: goals,
            preferredDurationSeconds: preferredDurationSeconds,
            preferredTimeOfDayIndex: preferredTimeOfDayIndex,
            customReminderHour: customReminderHour,
            customReminderMinute: customReminderMinute,
            notificationsEnabled: notificationsEnabled,
            themeModeIndex: themeModeIndex,
            reducedMotion: reducedMotion,
            hapticsEnabled: hapticsEnabled,
            onboardingCompleted: onboardingCompleted,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String> firstName = const Value.absent(),
            Value<String> goals = const Value.absent(),
            Value<int> preferredDurationSeconds = const Value.absent(),
            Value<int> preferredTimeOfDayIndex = const Value.absent(),
            Value<int> customReminderHour = const Value.absent(),
            Value<int> customReminderMinute = const Value.absent(),
            Value<bool> notificationsEnabled = const Value.absent(),
            Value<int> themeModeIndex = const Value.absent(),
            Value<bool> reducedMotion = const Value.absent(),
            Value<bool> hapticsEnabled = const Value.absent(),
            Value<bool> onboardingCompleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UserPreferencesTableCompanion.insert(
            id: id,
            firstName: firstName,
            goals: goals,
            preferredDurationSeconds: preferredDurationSeconds,
            preferredTimeOfDayIndex: preferredTimeOfDayIndex,
            customReminderHour: customReminderHour,
            customReminderMinute: customReminderMinute,
            notificationsEnabled: notificationsEnabled,
            themeModeIndex: themeModeIndex,
            reducedMotion: reducedMotion,
            hapticsEnabled: hapticsEnabled,
            onboardingCompleted: onboardingCompleted,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$UserPreferencesTableTable,
                        UserPreferencesTableData>(table),
                    BaseReferences<_$AppDatabase, $UserPreferencesTableTable,
                        UserPreferencesTableData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserPreferencesTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $UserPreferencesTableTable,
        UserPreferencesTableData,
        $$UserPreferencesTableTableFilterComposer,
        $$UserPreferencesTableTableOrderingComposer,
        $$UserPreferencesTableTableAnnotationComposer,
        $$UserPreferencesTableTableCreateCompanionBuilder,
        $$UserPreferencesTableTableUpdateCompanionBuilder,
        (
          UserPreferencesTableData,
          BaseReferences<_$AppDatabase, $UserPreferencesTableTable,
              UserPreferencesTableData>
        ),
        UserPreferencesTableData,
        PrefetchHooks Function()>;
typedef $$MoodEntriesTableTableCreateCompanionBuilder
    = MoodEntriesTableCompanion Function({
  required String id,
  required DateTime timestamp,
  required String mood,
  Value<String?> note,
  Value<int> rowid,
});
typedef $$MoodEntriesTableTableUpdateCompanionBuilder
    = MoodEntriesTableCompanion Function({
  Value<String> id,
  Value<DateTime> timestamp,
  Value<String> mood,
  Value<String?> note,
  Value<int> rowid,
});

class $$MoodEntriesTableTableFilterComposer
    extends Composer<_$AppDatabase, $MoodEntriesTableTable> {
  $$MoodEntriesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mood => $composableBuilder(
      column: $table.mood, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));
}

class $$MoodEntriesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MoodEntriesTableTable> {
  $$MoodEntriesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mood => $composableBuilder(
      column: $table.mood, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));
}

class $$MoodEntriesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MoodEntriesTableTable> {
  $$MoodEntriesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get mood =>
      $composableBuilder(column: $table.mood, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$MoodEntriesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MoodEntriesTableTable,
    MoodEntriesTableData,
    $$MoodEntriesTableTableFilterComposer,
    $$MoodEntriesTableTableOrderingComposer,
    $$MoodEntriesTableTableAnnotationComposer,
    $$MoodEntriesTableTableCreateCompanionBuilder,
    $$MoodEntriesTableTableUpdateCompanionBuilder,
    (
      MoodEntriesTableData,
      BaseReferences<_$AppDatabase, $MoodEntriesTableTable,
          MoodEntriesTableData>
    ),
    MoodEntriesTableData,
    PrefetchHooks Function()> {
  $$MoodEntriesTableTableTableManager(
      _$AppDatabase db, $MoodEntriesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MoodEntriesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MoodEntriesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MoodEntriesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> timestamp = const Value.absent(),
            Value<String> mood = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MoodEntriesTableCompanion(
            id: id,
            timestamp: timestamp,
            mood: mood,
            note: note,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required DateTime timestamp,
            required String mood,
            Value<String?> note = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MoodEntriesTableCompanion.insert(
            id: id,
            timestamp: timestamp,
            mood: mood,
            note: note,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$MoodEntriesTableTable, MoodEntriesTableData>(
                        table),
                    BaseReferences<_$AppDatabase, $MoodEntriesTableTable,
                        MoodEntriesTableData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MoodEntriesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MoodEntriesTableTable,
    MoodEntriesTableData,
    $$MoodEntriesTableTableFilterComposer,
    $$MoodEntriesTableTableOrderingComposer,
    $$MoodEntriesTableTableAnnotationComposer,
    $$MoodEntriesTableTableCreateCompanionBuilder,
    $$MoodEntriesTableTableUpdateCompanionBuilder,
    (
      MoodEntriesTableData,
      BaseReferences<_$AppDatabase, $MoodEntriesTableTable,
          MoodEntriesTableData>
    ),
    MoodEntriesTableData,
    PrefetchHooks Function()>;
typedef $$SessionsTableTableCreateCompanionBuilder = SessionsTableCompanion
    Function({
  required String id,
  required String title,
  required String description,
  required String category,
  required String type,
  required int durationSeconds,
  required String difficulty,
  Value<String> tags,
  Value<String?> audioAsset,
  Value<String?> backgroundSoundAsset,
  Value<bool> isPremium,
  Value<int> sortOrder,
  Value<int> rowid,
});
typedef $$SessionsTableTableUpdateCompanionBuilder = SessionsTableCompanion
    Function({
  Value<String> id,
  Value<String> title,
  Value<String> description,
  Value<String> category,
  Value<String> type,
  Value<int> durationSeconds,
  Value<String> difficulty,
  Value<String> tags,
  Value<String?> audioAsset,
  Value<String?> backgroundSoundAsset,
  Value<bool> isPremium,
  Value<int> sortOrder,
  Value<int> rowid,
});

class $$SessionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SessionsTableTable> {
  $$SessionsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get audioAsset => $composableBuilder(
      column: $table.audioAsset, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get backgroundSoundAsset => $composableBuilder(
      column: $table.backgroundSoundAsset,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isPremium => $composableBuilder(
      column: $table.isPremium, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));
}

class $$SessionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionsTableTable> {
  $$SessionsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get audioAsset => $composableBuilder(
      column: $table.audioAsset, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get backgroundSoundAsset => $composableBuilder(
      column: $table.backgroundSoundAsset,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isPremium => $composableBuilder(
      column: $table.isPremium, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));
}

class $$SessionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionsTableTable> {
  $$SessionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds, builder: (column) => column);

  GeneratedColumn<String> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<String> get audioAsset => $composableBuilder(
      column: $table.audioAsset, builder: (column) => column);

  GeneratedColumn<String> get backgroundSoundAsset => $composableBuilder(
      column: $table.backgroundSoundAsset, builder: (column) => column);

  GeneratedColumn<bool> get isPremium =>
      $composableBuilder(column: $table.isPremium, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$SessionsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SessionsTableTable,
    SessionsTableData,
    $$SessionsTableTableFilterComposer,
    $$SessionsTableTableOrderingComposer,
    $$SessionsTableTableAnnotationComposer,
    $$SessionsTableTableCreateCompanionBuilder,
    $$SessionsTableTableUpdateCompanionBuilder,
    (
      SessionsTableData,
      BaseReferences<_$AppDatabase, $SessionsTableTable, SessionsTableData>
    ),
    SessionsTableData,
    PrefetchHooks Function()> {
  $$SessionsTableTableTableManager(_$AppDatabase db, $SessionsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<int> durationSeconds = const Value.absent(),
            Value<String> difficulty = const Value.absent(),
            Value<String> tags = const Value.absent(),
            Value<String?> audioAsset = const Value.absent(),
            Value<String?> backgroundSoundAsset = const Value.absent(),
            Value<bool> isPremium = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SessionsTableCompanion(
            id: id,
            title: title,
            description: description,
            category: category,
            type: type,
            durationSeconds: durationSeconds,
            difficulty: difficulty,
            tags: tags,
            audioAsset: audioAsset,
            backgroundSoundAsset: backgroundSoundAsset,
            isPremium: isPremium,
            sortOrder: sortOrder,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            required String description,
            required String category,
            required String type,
            required int durationSeconds,
            required String difficulty,
            Value<String> tags = const Value.absent(),
            Value<String?> audioAsset = const Value.absent(),
            Value<String?> backgroundSoundAsset = const Value.absent(),
            Value<bool> isPremium = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SessionsTableCompanion.insert(
            id: id,
            title: title,
            description: description,
            category: category,
            type: type,
            durationSeconds: durationSeconds,
            difficulty: difficulty,
            tags: tags,
            audioAsset: audioAsset,
            backgroundSoundAsset: backgroundSoundAsset,
            isPremium: isPremium,
            sortOrder: sortOrder,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$SessionsTableTable, SessionsTableData>(table),
                    BaseReferences<_$AppDatabase, $SessionsTableTable,
                        SessionsTableData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SessionsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SessionsTableTable,
    SessionsTableData,
    $$SessionsTableTableFilterComposer,
    $$SessionsTableTableOrderingComposer,
    $$SessionsTableTableAnnotationComposer,
    $$SessionsTableTableCreateCompanionBuilder,
    $$SessionsTableTableUpdateCompanionBuilder,
    (
      SessionsTableData,
      BaseReferences<_$AppDatabase, $SessionsTableTable, SessionsTableData>
    ),
    SessionsTableData,
    PrefetchHooks Function()>;
typedef $$SessionRecordsTableTableCreateCompanionBuilder
    = SessionRecordsTableCompanion Function({
  required String id,
  required String sessionId,
  required String sessionTitle,
  required String sessionType,
  required DateTime startedAt,
  required DateTime completedAt,
  required int durationCompletedSeconds,
  required bool wasCompleted,
  Value<String?> moodBefore,
  Value<String?> moodAfter,
  Value<int> rowid,
});
typedef $$SessionRecordsTableTableUpdateCompanionBuilder
    = SessionRecordsTableCompanion Function({
  Value<String> id,
  Value<String> sessionId,
  Value<String> sessionTitle,
  Value<String> sessionType,
  Value<DateTime> startedAt,
  Value<DateTime> completedAt,
  Value<int> durationCompletedSeconds,
  Value<bool> wasCompleted,
  Value<String?> moodBefore,
  Value<String?> moodAfter,
  Value<int> rowid,
});

class $$SessionRecordsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SessionRecordsTableTable> {
  $$SessionRecordsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sessionTitle => $composableBuilder(
      column: $table.sessionTitle, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sessionType => $composableBuilder(
      column: $table.sessionType, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationCompletedSeconds => $composableBuilder(
      column: $table.durationCompletedSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get wasCompleted => $composableBuilder(
      column: $table.wasCompleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get moodBefore => $composableBuilder(
      column: $table.moodBefore, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get moodAfter => $composableBuilder(
      column: $table.moodAfter, builder: (column) => ColumnFilters(column));
}

class $$SessionRecordsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionRecordsTableTable> {
  $$SessionRecordsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sessionTitle => $composableBuilder(
      column: $table.sessionTitle,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sessionType => $composableBuilder(
      column: $table.sessionType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationCompletedSeconds => $composableBuilder(
      column: $table.durationCompletedSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get wasCompleted => $composableBuilder(
      column: $table.wasCompleted,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get moodBefore => $composableBuilder(
      column: $table.moodBefore, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get moodAfter => $composableBuilder(
      column: $table.moodAfter, builder: (column) => ColumnOrderings(column));
}

class $$SessionRecordsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionRecordsTableTable> {
  $$SessionRecordsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<String> get sessionTitle => $composableBuilder(
      column: $table.sessionTitle, builder: (column) => column);

  GeneratedColumn<String> get sessionType => $composableBuilder(
      column: $table.sessionType, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  GeneratedColumn<int> get durationCompletedSeconds => $composableBuilder(
      column: $table.durationCompletedSeconds, builder: (column) => column);

  GeneratedColumn<bool> get wasCompleted => $composableBuilder(
      column: $table.wasCompleted, builder: (column) => column);

  GeneratedColumn<String> get moodBefore => $composableBuilder(
      column: $table.moodBefore, builder: (column) => column);

  GeneratedColumn<String> get moodAfter =>
      $composableBuilder(column: $table.moodAfter, builder: (column) => column);
}

class $$SessionRecordsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SessionRecordsTableTable,
    SessionRecordsTableData,
    $$SessionRecordsTableTableFilterComposer,
    $$SessionRecordsTableTableOrderingComposer,
    $$SessionRecordsTableTableAnnotationComposer,
    $$SessionRecordsTableTableCreateCompanionBuilder,
    $$SessionRecordsTableTableUpdateCompanionBuilder,
    (
      SessionRecordsTableData,
      BaseReferences<_$AppDatabase, $SessionRecordsTableTable,
          SessionRecordsTableData>
    ),
    SessionRecordsTableData,
    PrefetchHooks Function()> {
  $$SessionRecordsTableTableTableManager(
      _$AppDatabase db, $SessionRecordsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionRecordsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionRecordsTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionRecordsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> sessionId = const Value.absent(),
            Value<String> sessionTitle = const Value.absent(),
            Value<String> sessionType = const Value.absent(),
            Value<DateTime> startedAt = const Value.absent(),
            Value<DateTime> completedAt = const Value.absent(),
            Value<int> durationCompletedSeconds = const Value.absent(),
            Value<bool> wasCompleted = const Value.absent(),
            Value<String?> moodBefore = const Value.absent(),
            Value<String?> moodAfter = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SessionRecordsTableCompanion(
            id: id,
            sessionId: sessionId,
            sessionTitle: sessionTitle,
            sessionType: sessionType,
            startedAt: startedAt,
            completedAt: completedAt,
            durationCompletedSeconds: durationCompletedSeconds,
            wasCompleted: wasCompleted,
            moodBefore: moodBefore,
            moodAfter: moodAfter,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String sessionId,
            required String sessionTitle,
            required String sessionType,
            required DateTime startedAt,
            required DateTime completedAt,
            required int durationCompletedSeconds,
            required bool wasCompleted,
            Value<String?> moodBefore = const Value.absent(),
            Value<String?> moodAfter = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SessionRecordsTableCompanion.insert(
            id: id,
            sessionId: sessionId,
            sessionTitle: sessionTitle,
            sessionType: sessionType,
            startedAt: startedAt,
            completedAt: completedAt,
            durationCompletedSeconds: durationCompletedSeconds,
            wasCompleted: wasCompleted,
            moodBefore: moodBefore,
            moodAfter: moodAfter,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$SessionRecordsTableTable,
                        SessionRecordsTableData>(table),
                    BaseReferences<_$AppDatabase, $SessionRecordsTableTable,
                        SessionRecordsTableData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SessionRecordsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SessionRecordsTableTable,
    SessionRecordsTableData,
    $$SessionRecordsTableTableFilterComposer,
    $$SessionRecordsTableTableOrderingComposer,
    $$SessionRecordsTableTableAnnotationComposer,
    $$SessionRecordsTableTableCreateCompanionBuilder,
    $$SessionRecordsTableTableUpdateCompanionBuilder,
    (
      SessionRecordsTableData,
      BaseReferences<_$AppDatabase, $SessionRecordsTableTable,
          SessionRecordsTableData>
    ),
    SessionRecordsTableData,
    PrefetchHooks Function()>;
typedef $$RemindersTableTableCreateCompanionBuilder = RemindersTableCompanion
    Function({
  required String id,
  required String slot,
  required int hour,
  required int minute,
  required String daysOfWeek,
  Value<bool> isEnabled,
  Value<bool> soundEnabled,
  Value<bool> vibrationEnabled,
  Value<String?> customMessage,
  Value<int> rowid,
});
typedef $$RemindersTableTableUpdateCompanionBuilder = RemindersTableCompanion
    Function({
  Value<String> id,
  Value<String> slot,
  Value<int> hour,
  Value<int> minute,
  Value<String> daysOfWeek,
  Value<bool> isEnabled,
  Value<bool> soundEnabled,
  Value<bool> vibrationEnabled,
  Value<String?> customMessage,
  Value<int> rowid,
});

class $$RemindersTableTableFilterComposer
    extends Composer<_$AppDatabase, $RemindersTableTable> {
  $$RemindersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get slot => $composableBuilder(
      column: $table.slot, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get hour => $composableBuilder(
      column: $table.hour, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get minute => $composableBuilder(
      column: $table.minute, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get daysOfWeek => $composableBuilder(
      column: $table.daysOfWeek, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isEnabled => $composableBuilder(
      column: $table.isEnabled, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get soundEnabled => $composableBuilder(
      column: $table.soundEnabled, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get vibrationEnabled => $composableBuilder(
      column: $table.vibrationEnabled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customMessage => $composableBuilder(
      column: $table.customMessage, builder: (column) => ColumnFilters(column));
}

class $$RemindersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RemindersTableTable> {
  $$RemindersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get slot => $composableBuilder(
      column: $table.slot, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get hour => $composableBuilder(
      column: $table.hour, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get minute => $composableBuilder(
      column: $table.minute, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get daysOfWeek => $composableBuilder(
      column: $table.daysOfWeek, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isEnabled => $composableBuilder(
      column: $table.isEnabled, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get soundEnabled => $composableBuilder(
      column: $table.soundEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get vibrationEnabled => $composableBuilder(
      column: $table.vibrationEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customMessage => $composableBuilder(
      column: $table.customMessage,
      builder: (column) => ColumnOrderings(column));
}

class $$RemindersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RemindersTableTable> {
  $$RemindersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get slot =>
      $composableBuilder(column: $table.slot, builder: (column) => column);

  GeneratedColumn<int> get hour =>
      $composableBuilder(column: $table.hour, builder: (column) => column);

  GeneratedColumn<int> get minute =>
      $composableBuilder(column: $table.minute, builder: (column) => column);

  GeneratedColumn<String> get daysOfWeek => $composableBuilder(
      column: $table.daysOfWeek, builder: (column) => column);

  GeneratedColumn<bool> get isEnabled =>
      $composableBuilder(column: $table.isEnabled, builder: (column) => column);

  GeneratedColumn<bool> get soundEnabled => $composableBuilder(
      column: $table.soundEnabled, builder: (column) => column);

  GeneratedColumn<bool> get vibrationEnabled => $composableBuilder(
      column: $table.vibrationEnabled, builder: (column) => column);

  GeneratedColumn<String> get customMessage => $composableBuilder(
      column: $table.customMessage, builder: (column) => column);
}

class $$RemindersTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RemindersTableTable,
    RemindersTableData,
    $$RemindersTableTableFilterComposer,
    $$RemindersTableTableOrderingComposer,
    $$RemindersTableTableAnnotationComposer,
    $$RemindersTableTableCreateCompanionBuilder,
    $$RemindersTableTableUpdateCompanionBuilder,
    (
      RemindersTableData,
      BaseReferences<_$AppDatabase, $RemindersTableTable, RemindersTableData>
    ),
    RemindersTableData,
    PrefetchHooks Function()> {
  $$RemindersTableTableTableManager(
      _$AppDatabase db, $RemindersTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemindersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemindersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemindersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> slot = const Value.absent(),
            Value<int> hour = const Value.absent(),
            Value<int> minute = const Value.absent(),
            Value<String> daysOfWeek = const Value.absent(),
            Value<bool> isEnabled = const Value.absent(),
            Value<bool> soundEnabled = const Value.absent(),
            Value<bool> vibrationEnabled = const Value.absent(),
            Value<String?> customMessage = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RemindersTableCompanion(
            id: id,
            slot: slot,
            hour: hour,
            minute: minute,
            daysOfWeek: daysOfWeek,
            isEnabled: isEnabled,
            soundEnabled: soundEnabled,
            vibrationEnabled: vibrationEnabled,
            customMessage: customMessage,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String slot,
            required int hour,
            required int minute,
            required String daysOfWeek,
            Value<bool> isEnabled = const Value.absent(),
            Value<bool> soundEnabled = const Value.absent(),
            Value<bool> vibrationEnabled = const Value.absent(),
            Value<String?> customMessage = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RemindersTableCompanion.insert(
            id: id,
            slot: slot,
            hour: hour,
            minute: minute,
            daysOfWeek: daysOfWeek,
            isEnabled: isEnabled,
            soundEnabled: soundEnabled,
            vibrationEnabled: vibrationEnabled,
            customMessage: customMessage,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$RemindersTableTable, RemindersTableData>(
                        table),
                    BaseReferences<_$AppDatabase, $RemindersTableTable,
                        RemindersTableData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RemindersTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RemindersTableTable,
    RemindersTableData,
    $$RemindersTableTableFilterComposer,
    $$RemindersTableTableOrderingComposer,
    $$RemindersTableTableAnnotationComposer,
    $$RemindersTableTableCreateCompanionBuilder,
    $$RemindersTableTableUpdateCompanionBuilder,
    (
      RemindersTableData,
      BaseReferences<_$AppDatabase, $RemindersTableTable, RemindersTableData>
    ),
    RemindersTableData,
    PrefetchHooks Function()>;
typedef $$FavoritesTableTableCreateCompanionBuilder = FavoritesTableCompanion
    Function({
  required String sessionId,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$FavoritesTableTableUpdateCompanionBuilder = FavoritesTableCompanion
    Function({
  Value<String> sessionId,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$FavoritesTableTableFilterComposer
    extends Composer<_$AppDatabase, $FavoritesTableTable> {
  $$FavoritesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$FavoritesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $FavoritesTableTable> {
  $$FavoritesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$FavoritesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $FavoritesTableTable> {
  $$FavoritesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$FavoritesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FavoritesTableTable,
    FavoritesTableData,
    $$FavoritesTableTableFilterComposer,
    $$FavoritesTableTableOrderingComposer,
    $$FavoritesTableTableAnnotationComposer,
    $$FavoritesTableTableCreateCompanionBuilder,
    $$FavoritesTableTableUpdateCompanionBuilder,
    (
      FavoritesTableData,
      BaseReferences<_$AppDatabase, $FavoritesTableTable, FavoritesTableData>
    ),
    FavoritesTableData,
    PrefetchHooks Function()> {
  $$FavoritesTableTableTableManager(
      _$AppDatabase db, $FavoritesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FavoritesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FavoritesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FavoritesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> sessionId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FavoritesTableCompanion(
            sessionId: sessionId,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String sessionId,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              FavoritesTableCompanion.insert(
            sessionId: sessionId,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$FavoritesTableTable, FavoritesTableData>(
                        table),
                    BaseReferences<_$AppDatabase, $FavoritesTableTable,
                        FavoritesTableData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FavoritesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FavoritesTableTable,
    FavoritesTableData,
    $$FavoritesTableTableFilterComposer,
    $$FavoritesTableTableOrderingComposer,
    $$FavoritesTableTableAnnotationComposer,
    $$FavoritesTableTableCreateCompanionBuilder,
    $$FavoritesTableTableUpdateCompanionBuilder,
    (
      FavoritesTableData,
      BaseReferences<_$AppDatabase, $FavoritesTableTable, FavoritesTableData>
    ),
    FavoritesTableData,
    PrefetchHooks Function()>;
typedef $$BreathingPatternsTableTableCreateCompanionBuilder
    = BreathingPatternsTableCompanion Function({
  required String id,
  required String name,
  required String description,
  required int inhaleSeconds,
  required int holdAfterInhaleSeconds,
  required int exhaleSeconds,
  required int holdAfterExhaleSeconds,
  Value<int> totalCycles,
  Value<int> rowid,
});
typedef $$BreathingPatternsTableTableUpdateCompanionBuilder
    = BreathingPatternsTableCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> description,
  Value<int> inhaleSeconds,
  Value<int> holdAfterInhaleSeconds,
  Value<int> exhaleSeconds,
  Value<int> holdAfterExhaleSeconds,
  Value<int> totalCycles,
  Value<int> rowid,
});

class $$BreathingPatternsTableTableFilterComposer
    extends Composer<_$AppDatabase, $BreathingPatternsTableTable> {
  $$BreathingPatternsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get inhaleSeconds => $composableBuilder(
      column: $table.inhaleSeconds, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get holdAfterInhaleSeconds => $composableBuilder(
      column: $table.holdAfterInhaleSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get exhaleSeconds => $composableBuilder(
      column: $table.exhaleSeconds, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get holdAfterExhaleSeconds => $composableBuilder(
      column: $table.holdAfterExhaleSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalCycles => $composableBuilder(
      column: $table.totalCycles, builder: (column) => ColumnFilters(column));
}

class $$BreathingPatternsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BreathingPatternsTableTable> {
  $$BreathingPatternsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get inhaleSeconds => $composableBuilder(
      column: $table.inhaleSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get holdAfterInhaleSeconds => $composableBuilder(
      column: $table.holdAfterInhaleSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get exhaleSeconds => $composableBuilder(
      column: $table.exhaleSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get holdAfterExhaleSeconds => $composableBuilder(
      column: $table.holdAfterExhaleSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalCycles => $composableBuilder(
      column: $table.totalCycles, builder: (column) => ColumnOrderings(column));
}

class $$BreathingPatternsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BreathingPatternsTableTable> {
  $$BreathingPatternsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<int> get inhaleSeconds => $composableBuilder(
      column: $table.inhaleSeconds, builder: (column) => column);

  GeneratedColumn<int> get holdAfterInhaleSeconds => $composableBuilder(
      column: $table.holdAfterInhaleSeconds, builder: (column) => column);

  GeneratedColumn<int> get exhaleSeconds => $composableBuilder(
      column: $table.exhaleSeconds, builder: (column) => column);

  GeneratedColumn<int> get holdAfterExhaleSeconds => $composableBuilder(
      column: $table.holdAfterExhaleSeconds, builder: (column) => column);

  GeneratedColumn<int> get totalCycles => $composableBuilder(
      column: $table.totalCycles, builder: (column) => column);
}

class $$BreathingPatternsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BreathingPatternsTableTable,
    BreathingPatternsTableData,
    $$BreathingPatternsTableTableFilterComposer,
    $$BreathingPatternsTableTableOrderingComposer,
    $$BreathingPatternsTableTableAnnotationComposer,
    $$BreathingPatternsTableTableCreateCompanionBuilder,
    $$BreathingPatternsTableTableUpdateCompanionBuilder,
    (
      BreathingPatternsTableData,
      BaseReferences<_$AppDatabase, $BreathingPatternsTableTable,
          BreathingPatternsTableData>
    ),
    BreathingPatternsTableData,
    PrefetchHooks Function()> {
  $$BreathingPatternsTableTableTableManager(
      _$AppDatabase db, $BreathingPatternsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BreathingPatternsTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$BreathingPatternsTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BreathingPatternsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<int> inhaleSeconds = const Value.absent(),
            Value<int> holdAfterInhaleSeconds = const Value.absent(),
            Value<int> exhaleSeconds = const Value.absent(),
            Value<int> holdAfterExhaleSeconds = const Value.absent(),
            Value<int> totalCycles = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BreathingPatternsTableCompanion(
            id: id,
            name: name,
            description: description,
            inhaleSeconds: inhaleSeconds,
            holdAfterInhaleSeconds: holdAfterInhaleSeconds,
            exhaleSeconds: exhaleSeconds,
            holdAfterExhaleSeconds: holdAfterExhaleSeconds,
            totalCycles: totalCycles,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String description,
            required int inhaleSeconds,
            required int holdAfterInhaleSeconds,
            required int exhaleSeconds,
            required int holdAfterExhaleSeconds,
            Value<int> totalCycles = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BreathingPatternsTableCompanion.insert(
            id: id,
            name: name,
            description: description,
            inhaleSeconds: inhaleSeconds,
            holdAfterInhaleSeconds: holdAfterInhaleSeconds,
            exhaleSeconds: exhaleSeconds,
            holdAfterExhaleSeconds: holdAfterExhaleSeconds,
            totalCycles: totalCycles,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$BreathingPatternsTableTable,
                        BreathingPatternsTableData>(table),
                    BaseReferences<_$AppDatabase, $BreathingPatternsTableTable,
                        BreathingPatternsTableData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BreathingPatternsTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $BreathingPatternsTableTable,
        BreathingPatternsTableData,
        $$BreathingPatternsTableTableFilterComposer,
        $$BreathingPatternsTableTableOrderingComposer,
        $$BreathingPatternsTableTableAnnotationComposer,
        $$BreathingPatternsTableTableCreateCompanionBuilder,
        $$BreathingPatternsTableTableUpdateCompanionBuilder,
        (
          BreathingPatternsTableData,
          BaseReferences<_$AppDatabase, $BreathingPatternsTableTable,
              BreathingPatternsTableData>
        ),
        BreathingPatternsTableData,
        PrefetchHooks Function()>;
typedef $$AppSettingsTableTableCreateCompanionBuilder
    = AppSettingsTableCompanion Function({
  required String id,
  Value<bool> offlineAudioCached,
  Value<bool> backgroundAudioEnabled,
  Value<bool> analyticsOptIn,
  Value<DateTime?> lastBackupTimestamp,
  Value<int> databaseVersion,
  Value<int> rowid,
});
typedef $$AppSettingsTableTableUpdateCompanionBuilder
    = AppSettingsTableCompanion Function({
  Value<String> id,
  Value<bool> offlineAudioCached,
  Value<bool> backgroundAudioEnabled,
  Value<bool> analyticsOptIn,
  Value<DateTime?> lastBackupTimestamp,
  Value<int> databaseVersion,
  Value<int> rowid,
});

class $$AppSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get offlineAudioCached => $composableBuilder(
      column: $table.offlineAudioCached,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get backgroundAudioEnabled => $composableBuilder(
      column: $table.backgroundAudioEnabled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get analyticsOptIn => $composableBuilder(
      column: $table.analyticsOptIn,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastBackupTimestamp => $composableBuilder(
      column: $table.lastBackupTimestamp,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get databaseVersion => $composableBuilder(
      column: $table.databaseVersion,
      builder: (column) => ColumnFilters(column));
}

class $$AppSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get offlineAudioCached => $composableBuilder(
      column: $table.offlineAudioCached,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get backgroundAudioEnabled => $composableBuilder(
      column: $table.backgroundAudioEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get analyticsOptIn => $composableBuilder(
      column: $table.analyticsOptIn,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastBackupTimestamp => $composableBuilder(
      column: $table.lastBackupTimestamp,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get databaseVersion => $composableBuilder(
      column: $table.databaseVersion,
      builder: (column) => ColumnOrderings(column));
}

class $$AppSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get offlineAudioCached => $composableBuilder(
      column: $table.offlineAudioCached, builder: (column) => column);

  GeneratedColumn<bool> get backgroundAudioEnabled => $composableBuilder(
      column: $table.backgroundAudioEnabled, builder: (column) => column);

  GeneratedColumn<bool> get analyticsOptIn => $composableBuilder(
      column: $table.analyticsOptIn, builder: (column) => column);

  GeneratedColumn<DateTime> get lastBackupTimestamp => $composableBuilder(
      column: $table.lastBackupTimestamp, builder: (column) => column);

  GeneratedColumn<int> get databaseVersion => $composableBuilder(
      column: $table.databaseVersion, builder: (column) => column);
}

class $$AppSettingsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AppSettingsTableTable,
    AppSettingsTableData,
    $$AppSettingsTableTableFilterComposer,
    $$AppSettingsTableTableOrderingComposer,
    $$AppSettingsTableTableAnnotationComposer,
    $$AppSettingsTableTableCreateCompanionBuilder,
    $$AppSettingsTableTableUpdateCompanionBuilder,
    (
      AppSettingsTableData,
      BaseReferences<_$AppDatabase, $AppSettingsTableTable,
          AppSettingsTableData>
    ),
    AppSettingsTableData,
    PrefetchHooks Function()> {
  $$AppSettingsTableTableTableManager(
      _$AppDatabase db, $AppSettingsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<bool> offlineAudioCached = const Value.absent(),
            Value<bool> backgroundAudioEnabled = const Value.absent(),
            Value<bool> analyticsOptIn = const Value.absent(),
            Value<DateTime?> lastBackupTimestamp = const Value.absent(),
            Value<int> databaseVersion = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AppSettingsTableCompanion(
            id: id,
            offlineAudioCached: offlineAudioCached,
            backgroundAudioEnabled: backgroundAudioEnabled,
            analyticsOptIn: analyticsOptIn,
            lastBackupTimestamp: lastBackupTimestamp,
            databaseVersion: databaseVersion,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<bool> offlineAudioCached = const Value.absent(),
            Value<bool> backgroundAudioEnabled = const Value.absent(),
            Value<bool> analyticsOptIn = const Value.absent(),
            Value<DateTime?> lastBackupTimestamp = const Value.absent(),
            Value<int> databaseVersion = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AppSettingsTableCompanion.insert(
            id: id,
            offlineAudioCached: offlineAudioCached,
            backgroundAudioEnabled: backgroundAudioEnabled,
            analyticsOptIn: analyticsOptIn,
            lastBackupTimestamp: lastBackupTimestamp,
            databaseVersion: databaseVersion,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$AppSettingsTableTable, AppSettingsTableData>(
                        table),
                    BaseReferences<_$AppDatabase, $AppSettingsTableTable,
                        AppSettingsTableData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AppSettingsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AppSettingsTableTable,
    AppSettingsTableData,
    $$AppSettingsTableTableFilterComposer,
    $$AppSettingsTableTableOrderingComposer,
    $$AppSettingsTableTableAnnotationComposer,
    $$AppSettingsTableTableCreateCompanionBuilder,
    $$AppSettingsTableTableUpdateCompanionBuilder,
    (
      AppSettingsTableData,
      BaseReferences<_$AppDatabase, $AppSettingsTableTable,
          AppSettingsTableData>
    ),
    AppSettingsTableData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UserPreferencesTableTableTableManager get userPreferencesTable =>
      $$UserPreferencesTableTableTableManager(_db, _db.userPreferencesTable);
  $$MoodEntriesTableTableTableManager get moodEntriesTable =>
      $$MoodEntriesTableTableTableManager(_db, _db.moodEntriesTable);
  $$SessionsTableTableTableManager get sessionsTable =>
      $$SessionsTableTableTableManager(_db, _db.sessionsTable);
  $$SessionRecordsTableTableTableManager get sessionRecordsTable =>
      $$SessionRecordsTableTableTableManager(_db, _db.sessionRecordsTable);
  $$RemindersTableTableTableManager get remindersTable =>
      $$RemindersTableTableTableManager(_db, _db.remindersTable);
  $$FavoritesTableTableTableManager get favoritesTable =>
      $$FavoritesTableTableTableManager(_db, _db.favoritesTable);
  $$BreathingPatternsTableTableTableManager get breathingPatternsTable =>
      $$BreathingPatternsTableTableTableManager(
          _db, _db.breathingPatternsTable);
  $$AppSettingsTableTableTableManager get appSettingsTable =>
      $$AppSettingsTableTableTableManager(_db, _db.appSettingsTable);
}
