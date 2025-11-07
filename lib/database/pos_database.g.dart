// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pos_database.dart';

// ignore_for_file: type=lint
class $CustomersTable extends Customers
    with TableInfo<$CustomersTable, Customer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTable(this.attachedDatabase, [this._alias]);
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
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastNameMeta =
      const VerificationMeta('lastName');
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
      'last_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _mobileNumberMeta =
      const VerificationMeta('mobileNumber');
  @override
  late final GeneratedColumn<String> mobileNumber = GeneratedColumn<String>(
      'mobile_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _faxMeta = const VerificationMeta('fax');
  @override
  late final GeneratedColumn<String> fax = GeneratedColumn<String>(
      'fax', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _webMeta = const VerificationMeta('web');
  @override
  late final GeneratedColumn<String> web = GeneratedColumn<String>(
      'web', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _abnMeta = const VerificationMeta('abn');
  @override
  late final GeneratedColumn<String> abn = GeneratedColumn<String>(
      'abn', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _acnMeta = const VerificationMeta('acn');
  @override
  late final GeneratedColumn<String> acn = GeneratedColumn<String>(
      'acn', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _commentMeta =
      const VerificationMeta('comment');
  @override
  late final GeneratedColumn<String> comment = GeneratedColumn<String>(
      'comment', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _billingStreetMeta =
      const VerificationMeta('billingStreet');
  @override
  late final GeneratedColumn<String> billingStreet = GeneratedColumn<String>(
      'billing_street', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _billingCityMeta =
      const VerificationMeta('billingCity');
  @override
  late final GeneratedColumn<String> billingCity = GeneratedColumn<String>(
      'billing_city', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _billingStateMeta =
      const VerificationMeta('billingState');
  @override
  late final GeneratedColumn<String> billingState = GeneratedColumn<String>(
      'billing_state', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _billingAreaCodeMeta =
      const VerificationMeta('billingAreaCode');
  @override
  late final GeneratedColumn<String> billingAreaCode = GeneratedColumn<String>(
      'billing_area_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _billingPostalCodeMeta =
      const VerificationMeta('billingPostalCode');
  @override
  late final GeneratedColumn<String> billingPostalCode =
      GeneratedColumn<String>('billing_postal_code', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _billingCountryMeta =
      const VerificationMeta('billingCountry');
  @override
  late final GeneratedColumn<String> billingCountry = GeneratedColumn<String>(
      'billing_country', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _postalStreetMeta =
      const VerificationMeta('postalStreet');
  @override
  late final GeneratedColumn<String> postalStreet = GeneratedColumn<String>(
      'postal_street', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _postalCityMeta =
      const VerificationMeta('postalCity');
  @override
  late final GeneratedColumn<String> postalCity = GeneratedColumn<String>(
      'postal_city', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _postalStateMeta =
      const VerificationMeta('postalState');
  @override
  late final GeneratedColumn<String> postalState = GeneratedColumn<String>(
      'postal_state', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _postalAreaCodeMeta =
      const VerificationMeta('postalAreaCode');
  @override
  late final GeneratedColumn<String> postalAreaCode = GeneratedColumn<String>(
      'postal_area_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _postalPostalCodeMeta =
      const VerificationMeta('postalPostalCode');
  @override
  late final GeneratedColumn<String> postalPostalCode = GeneratedColumn<String>(
      'postal_postal_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _postalCountryMeta =
      const VerificationMeta('postalCountry');
  @override
  late final GeneratedColumn<String> postalCountry = GeneratedColumn<String>(
      'postal_country', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _encryptedDataMeta =
      const VerificationMeta('encryptedData');
  @override
  late final GeneratedColumn<String> encryptedData = GeneratedColumn<String>(
      'encrypted_data', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        firstName,
        lastName,
        email,
        mobileNumber,
        fax,
        web,
        abn,
        acn,
        comment,
        billingStreet,
        billingCity,
        billingState,
        billingAreaCode,
        billingPostalCode,
        billingCountry,
        postalStreet,
        postalCity,
        postalState,
        postalAreaCode,
        postalPostalCode,
        postalCountry,
        encryptedData,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customers';
  @override
  VerificationContext validateIntegrity(Insertable<Customer> instance,
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
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(_lastNameMeta,
          lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta));
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('mobile_number')) {
      context.handle(
          _mobileNumberMeta,
          mobileNumber.isAcceptableOrUnknown(
              data['mobile_number']!, _mobileNumberMeta));
    }
    if (data.containsKey('fax')) {
      context.handle(
          _faxMeta, fax.isAcceptableOrUnknown(data['fax']!, _faxMeta));
    }
    if (data.containsKey('web')) {
      context.handle(
          _webMeta, web.isAcceptableOrUnknown(data['web']!, _webMeta));
    }
    if (data.containsKey('abn')) {
      context.handle(
          _abnMeta, abn.isAcceptableOrUnknown(data['abn']!, _abnMeta));
    }
    if (data.containsKey('acn')) {
      context.handle(
          _acnMeta, acn.isAcceptableOrUnknown(data['acn']!, _acnMeta));
    }
    if (data.containsKey('comment')) {
      context.handle(_commentMeta,
          comment.isAcceptableOrUnknown(data['comment']!, _commentMeta));
    }
    if (data.containsKey('billing_street')) {
      context.handle(
          _billingStreetMeta,
          billingStreet.isAcceptableOrUnknown(
              data['billing_street']!, _billingStreetMeta));
    }
    if (data.containsKey('billing_city')) {
      context.handle(
          _billingCityMeta,
          billingCity.isAcceptableOrUnknown(
              data['billing_city']!, _billingCityMeta));
    }
    if (data.containsKey('billing_state')) {
      context.handle(
          _billingStateMeta,
          billingState.isAcceptableOrUnknown(
              data['billing_state']!, _billingStateMeta));
    }
    if (data.containsKey('billing_area_code')) {
      context.handle(
          _billingAreaCodeMeta,
          billingAreaCode.isAcceptableOrUnknown(
              data['billing_area_code']!, _billingAreaCodeMeta));
    }
    if (data.containsKey('billing_postal_code')) {
      context.handle(
          _billingPostalCodeMeta,
          billingPostalCode.isAcceptableOrUnknown(
              data['billing_postal_code']!, _billingPostalCodeMeta));
    }
    if (data.containsKey('billing_country')) {
      context.handle(
          _billingCountryMeta,
          billingCountry.isAcceptableOrUnknown(
              data['billing_country']!, _billingCountryMeta));
    }
    if (data.containsKey('postal_street')) {
      context.handle(
          _postalStreetMeta,
          postalStreet.isAcceptableOrUnknown(
              data['postal_street']!, _postalStreetMeta));
    }
    if (data.containsKey('postal_city')) {
      context.handle(
          _postalCityMeta,
          postalCity.isAcceptableOrUnknown(
              data['postal_city']!, _postalCityMeta));
    }
    if (data.containsKey('postal_state')) {
      context.handle(
          _postalStateMeta,
          postalState.isAcceptableOrUnknown(
              data['postal_state']!, _postalStateMeta));
    }
    if (data.containsKey('postal_area_code')) {
      context.handle(
          _postalAreaCodeMeta,
          postalAreaCode.isAcceptableOrUnknown(
              data['postal_area_code']!, _postalAreaCodeMeta));
    }
    if (data.containsKey('postal_postal_code')) {
      context.handle(
          _postalPostalCodeMeta,
          postalPostalCode.isAcceptableOrUnknown(
              data['postal_postal_code']!, _postalPostalCodeMeta));
    }
    if (data.containsKey('postal_country')) {
      context.handle(
          _postalCountryMeta,
          postalCountry.isAcceptableOrUnknown(
              data['postal_country']!, _postalCountryMeta));
    }
    if (data.containsKey('encrypted_data')) {
      context.handle(
          _encryptedDataMeta,
          encryptedData.isAcceptableOrUnknown(
              data['encrypted_data']!, _encryptedDataMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Customer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Customer(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      firstName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}first_name'])!,
      lastName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_name'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      mobileNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mobile_number']),
      fax: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}fax']),
      web: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}web']),
      abn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}abn']),
      acn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}acn']),
      comment: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}comment']),
      billingStreet: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}billing_street']),
      billingCity: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}billing_city']),
      billingState: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}billing_state']),
      billingAreaCode: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}billing_area_code']),
      billingPostalCode: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}billing_postal_code']),
      billingCountry: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}billing_country']),
      postalStreet: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}postal_street']),
      postalCity: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}postal_city']),
      postalState: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}postal_state']),
      postalAreaCode: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}postal_area_code']),
      postalPostalCode: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}postal_postal_code']),
      postalCountry: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}postal_country']),
      encryptedData: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}encrypted_data']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $CustomersTable createAlias(String alias) {
    return $CustomersTable(attachedDatabase, alias);
  }
}

class Customer extends DataClass implements Insertable<Customer> {
  final String id;
  final String firstName;
  final String lastName;
  final String? email;
  final String? mobileNumber;
  final String? fax;
  final String? web;
  final String? abn;
  final String? acn;
  final String? comment;
  final String? billingStreet;
  final String? billingCity;
  final String? billingState;
  final String? billingAreaCode;
  final String? billingPostalCode;
  final String? billingCountry;
  final String? postalStreet;
  final String? postalCity;
  final String? postalState;
  final String? postalAreaCode;
  final String? postalPostalCode;
  final String? postalCountry;
  final String? encryptedData;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Customer(
      {required this.id,
      required this.firstName,
      required this.lastName,
      this.email,
      this.mobileNumber,
      this.fax,
      this.web,
      this.abn,
      this.acn,
      this.comment,
      this.billingStreet,
      this.billingCity,
      this.billingState,
      this.billingAreaCode,
      this.billingPostalCode,
      this.billingCountry,
      this.postalStreet,
      this.postalCity,
      this.postalState,
      this.postalAreaCode,
      this.postalPostalCode,
      this.postalCountry,
      this.encryptedData,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['first_name'] = Variable<String>(firstName);
    map['last_name'] = Variable<String>(lastName);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || mobileNumber != null) {
      map['mobile_number'] = Variable<String>(mobileNumber);
    }
    if (!nullToAbsent || fax != null) {
      map['fax'] = Variable<String>(fax);
    }
    if (!nullToAbsent || web != null) {
      map['web'] = Variable<String>(web);
    }
    if (!nullToAbsent || abn != null) {
      map['abn'] = Variable<String>(abn);
    }
    if (!nullToAbsent || acn != null) {
      map['acn'] = Variable<String>(acn);
    }
    if (!nullToAbsent || comment != null) {
      map['comment'] = Variable<String>(comment);
    }
    if (!nullToAbsent || billingStreet != null) {
      map['billing_street'] = Variable<String>(billingStreet);
    }
    if (!nullToAbsent || billingCity != null) {
      map['billing_city'] = Variable<String>(billingCity);
    }
    if (!nullToAbsent || billingState != null) {
      map['billing_state'] = Variable<String>(billingState);
    }
    if (!nullToAbsent || billingAreaCode != null) {
      map['billing_area_code'] = Variable<String>(billingAreaCode);
    }
    if (!nullToAbsent || billingPostalCode != null) {
      map['billing_postal_code'] = Variable<String>(billingPostalCode);
    }
    if (!nullToAbsent || billingCountry != null) {
      map['billing_country'] = Variable<String>(billingCountry);
    }
    if (!nullToAbsent || postalStreet != null) {
      map['postal_street'] = Variable<String>(postalStreet);
    }
    if (!nullToAbsent || postalCity != null) {
      map['postal_city'] = Variable<String>(postalCity);
    }
    if (!nullToAbsent || postalState != null) {
      map['postal_state'] = Variable<String>(postalState);
    }
    if (!nullToAbsent || postalAreaCode != null) {
      map['postal_area_code'] = Variable<String>(postalAreaCode);
    }
    if (!nullToAbsent || postalPostalCode != null) {
      map['postal_postal_code'] = Variable<String>(postalPostalCode);
    }
    if (!nullToAbsent || postalCountry != null) {
      map['postal_country'] = Variable<String>(postalCountry);
    }
    if (!nullToAbsent || encryptedData != null) {
      map['encrypted_data'] = Variable<String>(encryptedData);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CustomersCompanion toCompanion(bool nullToAbsent) {
    return CustomersCompanion(
      id: Value(id),
      firstName: Value(firstName),
      lastName: Value(lastName),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      mobileNumber: mobileNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(mobileNumber),
      fax: fax == null && nullToAbsent ? const Value.absent() : Value(fax),
      web: web == null && nullToAbsent ? const Value.absent() : Value(web),
      abn: abn == null && nullToAbsent ? const Value.absent() : Value(abn),
      acn: acn == null && nullToAbsent ? const Value.absent() : Value(acn),
      comment: comment == null && nullToAbsent
          ? const Value.absent()
          : Value(comment),
      billingStreet: billingStreet == null && nullToAbsent
          ? const Value.absent()
          : Value(billingStreet),
      billingCity: billingCity == null && nullToAbsent
          ? const Value.absent()
          : Value(billingCity),
      billingState: billingState == null && nullToAbsent
          ? const Value.absent()
          : Value(billingState),
      billingAreaCode: billingAreaCode == null && nullToAbsent
          ? const Value.absent()
          : Value(billingAreaCode),
      billingPostalCode: billingPostalCode == null && nullToAbsent
          ? const Value.absent()
          : Value(billingPostalCode),
      billingCountry: billingCountry == null && nullToAbsent
          ? const Value.absent()
          : Value(billingCountry),
      postalStreet: postalStreet == null && nullToAbsent
          ? const Value.absent()
          : Value(postalStreet),
      postalCity: postalCity == null && nullToAbsent
          ? const Value.absent()
          : Value(postalCity),
      postalState: postalState == null && nullToAbsent
          ? const Value.absent()
          : Value(postalState),
      postalAreaCode: postalAreaCode == null && nullToAbsent
          ? const Value.absent()
          : Value(postalAreaCode),
      postalPostalCode: postalPostalCode == null && nullToAbsent
          ? const Value.absent()
          : Value(postalPostalCode),
      postalCountry: postalCountry == null && nullToAbsent
          ? const Value.absent()
          : Value(postalCountry),
      encryptedData: encryptedData == null && nullToAbsent
          ? const Value.absent()
          : Value(encryptedData),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Customer.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Customer(
      id: serializer.fromJson<String>(json['id']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String>(json['lastName']),
      email: serializer.fromJson<String?>(json['email']),
      mobileNumber: serializer.fromJson<String?>(json['mobileNumber']),
      fax: serializer.fromJson<String?>(json['fax']),
      web: serializer.fromJson<String?>(json['web']),
      abn: serializer.fromJson<String?>(json['abn']),
      acn: serializer.fromJson<String?>(json['acn']),
      comment: serializer.fromJson<String?>(json['comment']),
      billingStreet: serializer.fromJson<String?>(json['billingStreet']),
      billingCity: serializer.fromJson<String?>(json['billingCity']),
      billingState: serializer.fromJson<String?>(json['billingState']),
      billingAreaCode: serializer.fromJson<String?>(json['billingAreaCode']),
      billingPostalCode:
          serializer.fromJson<String?>(json['billingPostalCode']),
      billingCountry: serializer.fromJson<String?>(json['billingCountry']),
      postalStreet: serializer.fromJson<String?>(json['postalStreet']),
      postalCity: serializer.fromJson<String?>(json['postalCity']),
      postalState: serializer.fromJson<String?>(json['postalState']),
      postalAreaCode: serializer.fromJson<String?>(json['postalAreaCode']),
      postalPostalCode: serializer.fromJson<String?>(json['postalPostalCode']),
      postalCountry: serializer.fromJson<String?>(json['postalCountry']),
      encryptedData: serializer.fromJson<String?>(json['encryptedData']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String>(lastName),
      'email': serializer.toJson<String?>(email),
      'mobileNumber': serializer.toJson<String?>(mobileNumber),
      'fax': serializer.toJson<String?>(fax),
      'web': serializer.toJson<String?>(web),
      'abn': serializer.toJson<String?>(abn),
      'acn': serializer.toJson<String?>(acn),
      'comment': serializer.toJson<String?>(comment),
      'billingStreet': serializer.toJson<String?>(billingStreet),
      'billingCity': serializer.toJson<String?>(billingCity),
      'billingState': serializer.toJson<String?>(billingState),
      'billingAreaCode': serializer.toJson<String?>(billingAreaCode),
      'billingPostalCode': serializer.toJson<String?>(billingPostalCode),
      'billingCountry': serializer.toJson<String?>(billingCountry),
      'postalStreet': serializer.toJson<String?>(postalStreet),
      'postalCity': serializer.toJson<String?>(postalCity),
      'postalState': serializer.toJson<String?>(postalState),
      'postalAreaCode': serializer.toJson<String?>(postalAreaCode),
      'postalPostalCode': serializer.toJson<String?>(postalPostalCode),
      'postalCountry': serializer.toJson<String?>(postalCountry),
      'encryptedData': serializer.toJson<String?>(encryptedData),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Customer copyWith(
          {String? id,
          String? firstName,
          String? lastName,
          Value<String?> email = const Value.absent(),
          Value<String?> mobileNumber = const Value.absent(),
          Value<String?> fax = const Value.absent(),
          Value<String?> web = const Value.absent(),
          Value<String?> abn = const Value.absent(),
          Value<String?> acn = const Value.absent(),
          Value<String?> comment = const Value.absent(),
          Value<String?> billingStreet = const Value.absent(),
          Value<String?> billingCity = const Value.absent(),
          Value<String?> billingState = const Value.absent(),
          Value<String?> billingAreaCode = const Value.absent(),
          Value<String?> billingPostalCode = const Value.absent(),
          Value<String?> billingCountry = const Value.absent(),
          Value<String?> postalStreet = const Value.absent(),
          Value<String?> postalCity = const Value.absent(),
          Value<String?> postalState = const Value.absent(),
          Value<String?> postalAreaCode = const Value.absent(),
          Value<String?> postalPostalCode = const Value.absent(),
          Value<String?> postalCountry = const Value.absent(),
          Value<String?> encryptedData = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Customer(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email.present ? email.value : this.email,
        mobileNumber:
            mobileNumber.present ? mobileNumber.value : this.mobileNumber,
        fax: fax.present ? fax.value : this.fax,
        web: web.present ? web.value : this.web,
        abn: abn.present ? abn.value : this.abn,
        acn: acn.present ? acn.value : this.acn,
        comment: comment.present ? comment.value : this.comment,
        billingStreet:
            billingStreet.present ? billingStreet.value : this.billingStreet,
        billingCity: billingCity.present ? billingCity.value : this.billingCity,
        billingState:
            billingState.present ? billingState.value : this.billingState,
        billingAreaCode: billingAreaCode.present
            ? billingAreaCode.value
            : this.billingAreaCode,
        billingPostalCode: billingPostalCode.present
            ? billingPostalCode.value
            : this.billingPostalCode,
        billingCountry:
            billingCountry.present ? billingCountry.value : this.billingCountry,
        postalStreet:
            postalStreet.present ? postalStreet.value : this.postalStreet,
        postalCity: postalCity.present ? postalCity.value : this.postalCity,
        postalState: postalState.present ? postalState.value : this.postalState,
        postalAreaCode:
            postalAreaCode.present ? postalAreaCode.value : this.postalAreaCode,
        postalPostalCode: postalPostalCode.present
            ? postalPostalCode.value
            : this.postalPostalCode,
        postalCountry:
            postalCountry.present ? postalCountry.value : this.postalCountry,
        encryptedData:
            encryptedData.present ? encryptedData.value : this.encryptedData,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Customer copyWithCompanion(CustomersCompanion data) {
    return Customer(
      id: data.id.present ? data.id.value : this.id,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      email: data.email.present ? data.email.value : this.email,
      mobileNumber: data.mobileNumber.present
          ? data.mobileNumber.value
          : this.mobileNumber,
      fax: data.fax.present ? data.fax.value : this.fax,
      web: data.web.present ? data.web.value : this.web,
      abn: data.abn.present ? data.abn.value : this.abn,
      acn: data.acn.present ? data.acn.value : this.acn,
      comment: data.comment.present ? data.comment.value : this.comment,
      billingStreet: data.billingStreet.present
          ? data.billingStreet.value
          : this.billingStreet,
      billingCity:
          data.billingCity.present ? data.billingCity.value : this.billingCity,
      billingState: data.billingState.present
          ? data.billingState.value
          : this.billingState,
      billingAreaCode: data.billingAreaCode.present
          ? data.billingAreaCode.value
          : this.billingAreaCode,
      billingPostalCode: data.billingPostalCode.present
          ? data.billingPostalCode.value
          : this.billingPostalCode,
      billingCountry: data.billingCountry.present
          ? data.billingCountry.value
          : this.billingCountry,
      postalStreet: data.postalStreet.present
          ? data.postalStreet.value
          : this.postalStreet,
      postalCity:
          data.postalCity.present ? data.postalCity.value : this.postalCity,
      postalState:
          data.postalState.present ? data.postalState.value : this.postalState,
      postalAreaCode: data.postalAreaCode.present
          ? data.postalAreaCode.value
          : this.postalAreaCode,
      postalPostalCode: data.postalPostalCode.present
          ? data.postalPostalCode.value
          : this.postalPostalCode,
      postalCountry: data.postalCountry.present
          ? data.postalCountry.value
          : this.postalCountry,
      encryptedData: data.encryptedData.present
          ? data.encryptedData.value
          : this.encryptedData,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Customer(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('email: $email, ')
          ..write('mobileNumber: $mobileNumber, ')
          ..write('fax: $fax, ')
          ..write('web: $web, ')
          ..write('abn: $abn, ')
          ..write('acn: $acn, ')
          ..write('comment: $comment, ')
          ..write('billingStreet: $billingStreet, ')
          ..write('billingCity: $billingCity, ')
          ..write('billingState: $billingState, ')
          ..write('billingAreaCode: $billingAreaCode, ')
          ..write('billingPostalCode: $billingPostalCode, ')
          ..write('billingCountry: $billingCountry, ')
          ..write('postalStreet: $postalStreet, ')
          ..write('postalCity: $postalCity, ')
          ..write('postalState: $postalState, ')
          ..write('postalAreaCode: $postalAreaCode, ')
          ..write('postalPostalCode: $postalPostalCode, ')
          ..write('postalCountry: $postalCountry, ')
          ..write('encryptedData: $encryptedData, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        firstName,
        lastName,
        email,
        mobileNumber,
        fax,
        web,
        abn,
        acn,
        comment,
        billingStreet,
        billingCity,
        billingState,
        billingAreaCode,
        billingPostalCode,
        billingCountry,
        postalStreet,
        postalCity,
        postalState,
        postalAreaCode,
        postalPostalCode,
        postalCountry,
        encryptedData,
        createdAt,
        updatedAt
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Customer &&
          other.id == this.id &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.email == this.email &&
          other.mobileNumber == this.mobileNumber &&
          other.fax == this.fax &&
          other.web == this.web &&
          other.abn == this.abn &&
          other.acn == this.acn &&
          other.comment == this.comment &&
          other.billingStreet == this.billingStreet &&
          other.billingCity == this.billingCity &&
          other.billingState == this.billingState &&
          other.billingAreaCode == this.billingAreaCode &&
          other.billingPostalCode == this.billingPostalCode &&
          other.billingCountry == this.billingCountry &&
          other.postalStreet == this.postalStreet &&
          other.postalCity == this.postalCity &&
          other.postalState == this.postalState &&
          other.postalAreaCode == this.postalAreaCode &&
          other.postalPostalCode == this.postalPostalCode &&
          other.postalCountry == this.postalCountry &&
          other.encryptedData == this.encryptedData &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CustomersCompanion extends UpdateCompanion<Customer> {
  final Value<String> id;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<String?> email;
  final Value<String?> mobileNumber;
  final Value<String?> fax;
  final Value<String?> web;
  final Value<String?> abn;
  final Value<String?> acn;
  final Value<String?> comment;
  final Value<String?> billingStreet;
  final Value<String?> billingCity;
  final Value<String?> billingState;
  final Value<String?> billingAreaCode;
  final Value<String?> billingPostalCode;
  final Value<String?> billingCountry;
  final Value<String?> postalStreet;
  final Value<String?> postalCity;
  final Value<String?> postalState;
  final Value<String?> postalAreaCode;
  final Value<String?> postalPostalCode;
  final Value<String?> postalCountry;
  final Value<String?> encryptedData;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CustomersCompanion({
    this.id = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.email = const Value.absent(),
    this.mobileNumber = const Value.absent(),
    this.fax = const Value.absent(),
    this.web = const Value.absent(),
    this.abn = const Value.absent(),
    this.acn = const Value.absent(),
    this.comment = const Value.absent(),
    this.billingStreet = const Value.absent(),
    this.billingCity = const Value.absent(),
    this.billingState = const Value.absent(),
    this.billingAreaCode = const Value.absent(),
    this.billingPostalCode = const Value.absent(),
    this.billingCountry = const Value.absent(),
    this.postalStreet = const Value.absent(),
    this.postalCity = const Value.absent(),
    this.postalState = const Value.absent(),
    this.postalAreaCode = const Value.absent(),
    this.postalPostalCode = const Value.absent(),
    this.postalCountry = const Value.absent(),
    this.encryptedData = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomersCompanion.insert({
    required String id,
    required String firstName,
    required String lastName,
    this.email = const Value.absent(),
    this.mobileNumber = const Value.absent(),
    this.fax = const Value.absent(),
    this.web = const Value.absent(),
    this.abn = const Value.absent(),
    this.acn = const Value.absent(),
    this.comment = const Value.absent(),
    this.billingStreet = const Value.absent(),
    this.billingCity = const Value.absent(),
    this.billingState = const Value.absent(),
    this.billingAreaCode = const Value.absent(),
    this.billingPostalCode = const Value.absent(),
    this.billingCountry = const Value.absent(),
    this.postalStreet = const Value.absent(),
    this.postalCity = const Value.absent(),
    this.postalState = const Value.absent(),
    this.postalAreaCode = const Value.absent(),
    this.postalPostalCode = const Value.absent(),
    this.postalCountry = const Value.absent(),
    this.encryptedData = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        firstName = Value(firstName),
        lastName = Value(lastName);
  static Insertable<Customer> custom({
    Expression<String>? id,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<String>? email,
    Expression<String>? mobileNumber,
    Expression<String>? fax,
    Expression<String>? web,
    Expression<String>? abn,
    Expression<String>? acn,
    Expression<String>? comment,
    Expression<String>? billingStreet,
    Expression<String>? billingCity,
    Expression<String>? billingState,
    Expression<String>? billingAreaCode,
    Expression<String>? billingPostalCode,
    Expression<String>? billingCountry,
    Expression<String>? postalStreet,
    Expression<String>? postalCity,
    Expression<String>? postalState,
    Expression<String>? postalAreaCode,
    Expression<String>? postalPostalCode,
    Expression<String>? postalCountry,
    Expression<String>? encryptedData,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (email != null) 'email': email,
      if (mobileNumber != null) 'mobile_number': mobileNumber,
      if (fax != null) 'fax': fax,
      if (web != null) 'web': web,
      if (abn != null) 'abn': abn,
      if (acn != null) 'acn': acn,
      if (comment != null) 'comment': comment,
      if (billingStreet != null) 'billing_street': billingStreet,
      if (billingCity != null) 'billing_city': billingCity,
      if (billingState != null) 'billing_state': billingState,
      if (billingAreaCode != null) 'billing_area_code': billingAreaCode,
      if (billingPostalCode != null) 'billing_postal_code': billingPostalCode,
      if (billingCountry != null) 'billing_country': billingCountry,
      if (postalStreet != null) 'postal_street': postalStreet,
      if (postalCity != null) 'postal_city': postalCity,
      if (postalState != null) 'postal_state': postalState,
      if (postalAreaCode != null) 'postal_area_code': postalAreaCode,
      if (postalPostalCode != null) 'postal_postal_code': postalPostalCode,
      if (postalCountry != null) 'postal_country': postalCountry,
      if (encryptedData != null) 'encrypted_data': encryptedData,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomersCompanion copyWith(
      {Value<String>? id,
      Value<String>? firstName,
      Value<String>? lastName,
      Value<String?>? email,
      Value<String?>? mobileNumber,
      Value<String?>? fax,
      Value<String?>? web,
      Value<String?>? abn,
      Value<String?>? acn,
      Value<String?>? comment,
      Value<String?>? billingStreet,
      Value<String?>? billingCity,
      Value<String?>? billingState,
      Value<String?>? billingAreaCode,
      Value<String?>? billingPostalCode,
      Value<String?>? billingCountry,
      Value<String?>? postalStreet,
      Value<String?>? postalCity,
      Value<String?>? postalState,
      Value<String?>? postalAreaCode,
      Value<String?>? postalPostalCode,
      Value<String?>? postalCountry,
      Value<String?>? encryptedData,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return CustomersCompanion(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      fax: fax ?? this.fax,
      web: web ?? this.web,
      abn: abn ?? this.abn,
      acn: acn ?? this.acn,
      comment: comment ?? this.comment,
      billingStreet: billingStreet ?? this.billingStreet,
      billingCity: billingCity ?? this.billingCity,
      billingState: billingState ?? this.billingState,
      billingAreaCode: billingAreaCode ?? this.billingAreaCode,
      billingPostalCode: billingPostalCode ?? this.billingPostalCode,
      billingCountry: billingCountry ?? this.billingCountry,
      postalStreet: postalStreet ?? this.postalStreet,
      postalCity: postalCity ?? this.postalCity,
      postalState: postalState ?? this.postalState,
      postalAreaCode: postalAreaCode ?? this.postalAreaCode,
      postalPostalCode: postalPostalCode ?? this.postalPostalCode,
      postalCountry: postalCountry ?? this.postalCountry,
      encryptedData: encryptedData ?? this.encryptedData,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (mobileNumber.present) {
      map['mobile_number'] = Variable<String>(mobileNumber.value);
    }
    if (fax.present) {
      map['fax'] = Variable<String>(fax.value);
    }
    if (web.present) {
      map['web'] = Variable<String>(web.value);
    }
    if (abn.present) {
      map['abn'] = Variable<String>(abn.value);
    }
    if (acn.present) {
      map['acn'] = Variable<String>(acn.value);
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
    }
    if (billingStreet.present) {
      map['billing_street'] = Variable<String>(billingStreet.value);
    }
    if (billingCity.present) {
      map['billing_city'] = Variable<String>(billingCity.value);
    }
    if (billingState.present) {
      map['billing_state'] = Variable<String>(billingState.value);
    }
    if (billingAreaCode.present) {
      map['billing_area_code'] = Variable<String>(billingAreaCode.value);
    }
    if (billingPostalCode.present) {
      map['billing_postal_code'] = Variable<String>(billingPostalCode.value);
    }
    if (billingCountry.present) {
      map['billing_country'] = Variable<String>(billingCountry.value);
    }
    if (postalStreet.present) {
      map['postal_street'] = Variable<String>(postalStreet.value);
    }
    if (postalCity.present) {
      map['postal_city'] = Variable<String>(postalCity.value);
    }
    if (postalState.present) {
      map['postal_state'] = Variable<String>(postalState.value);
    }
    if (postalAreaCode.present) {
      map['postal_area_code'] = Variable<String>(postalAreaCode.value);
    }
    if (postalPostalCode.present) {
      map['postal_postal_code'] = Variable<String>(postalPostalCode.value);
    }
    if (postalCountry.present) {
      map['postal_country'] = Variable<String>(postalCountry.value);
    }
    if (encryptedData.present) {
      map['encrypted_data'] = Variable<String>(encryptedData.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomersCompanion(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('email: $email, ')
          ..write('mobileNumber: $mobileNumber, ')
          ..write('fax: $fax, ')
          ..write('web: $web, ')
          ..write('abn: $abn, ')
          ..write('acn: $acn, ')
          ..write('comment: $comment, ')
          ..write('billingStreet: $billingStreet, ')
          ..write('billingCity: $billingCity, ')
          ..write('billingState: $billingState, ')
          ..write('billingAreaCode: $billingAreaCode, ')
          ..write('billingPostalCode: $billingPostalCode, ')
          ..write('billingCountry: $billingCountry, ')
          ..write('postalStreet: $postalStreet, ')
          ..write('postalCity: $postalCity, ')
          ..write('postalState: $postalState, ')
          ..write('postalAreaCode: $postalAreaCode, ')
          ..write('postalPostalCode: $postalPostalCode, ')
          ..write('postalCountry: $postalCountry, ')
          ..write('encryptedData: $encryptedData, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ItemsTable extends Items with TableInfo<$ItemsTable, Item> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemsTable(this.attachedDatabase, [this._alias]);
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
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _itemCodeMeta =
      const VerificationMeta('itemCode');
  @override
  late final GeneratedColumn<String> itemCode = GeneratedColumn<String>(
      'item_code', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        description,
        itemCode,
        price,
        quantity,
        category,
        isActive,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'items';
  @override
  VerificationContext validateIntegrity(Insertable<Item> instance,
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
    }
    if (data.containsKey('item_code')) {
      context.handle(_itemCodeMeta,
          itemCode.isAcceptableOrUnknown(data['item_code']!, _itemCodeMeta));
    } else if (isInserting) {
      context.missing(_itemCodeMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Item map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Item(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      itemCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_code'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ItemsTable createAlias(String alias) {
    return $ItemsTable(attachedDatabase, alias);
  }
}

class Item extends DataClass implements Insertable<Item> {
  final String id;
  final String name;
  final String? description;
  final String itemCode;
  final double price;
  final int quantity;
  final String? category;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Item(
      {required this.id,
      required this.name,
      this.description,
      required this.itemCode,
      required this.price,
      required this.quantity,
      this.category,
      required this.isActive,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['item_code'] = Variable<String>(itemCode);
    map['price'] = Variable<double>(price);
    map['quantity'] = Variable<int>(quantity);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ItemsCompanion toCompanion(bool nullToAbsent) {
    return ItemsCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      itemCode: Value(itemCode),
      price: Value(price),
      quantity: Value(quantity),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Item.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Item(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      itemCode: serializer.fromJson<String>(json['itemCode']),
      price: serializer.fromJson<double>(json['price']),
      quantity: serializer.fromJson<int>(json['quantity']),
      category: serializer.fromJson<String?>(json['category']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'itemCode': serializer.toJson<String>(itemCode),
      'price': serializer.toJson<double>(price),
      'quantity': serializer.toJson<int>(quantity),
      'category': serializer.toJson<String?>(category),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Item copyWith(
          {String? id,
          String? name,
          Value<String?> description = const Value.absent(),
          String? itemCode,
          double? price,
          int? quantity,
          Value<String?> category = const Value.absent(),
          bool? isActive,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Item(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        itemCode: itemCode ?? this.itemCode,
        price: price ?? this.price,
        quantity: quantity ?? this.quantity,
        category: category.present ? category.value : this.category,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Item copyWithCompanion(ItemsCompanion data) {
    return Item(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      itemCode: data.itemCode.present ? data.itemCode.value : this.itemCode,
      price: data.price.present ? data.price.value : this.price,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      category: data.category.present ? data.category.value : this.category,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Item(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('itemCode: $itemCode, ')
          ..write('price: $price, ')
          ..write('quantity: $quantity, ')
          ..write('category: $category, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, itemCode, price,
      quantity, category, isActive, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Item &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.itemCode == this.itemCode &&
          other.price == this.price &&
          other.quantity == this.quantity &&
          other.category == this.category &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ItemsCompanion extends UpdateCompanion<Item> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<String> itemCode;
  final Value<double> price;
  final Value<int> quantity;
  final Value<String?> category;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ItemsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.itemCode = const Value.absent(),
    this.price = const Value.absent(),
    this.quantity = const Value.absent(),
    this.category = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ItemsCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    required String itemCode,
    required double price,
    this.quantity = const Value.absent(),
    this.category = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        itemCode = Value(itemCode),
        price = Value(price);
  static Insertable<Item> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? itemCode,
    Expression<double>? price,
    Expression<int>? quantity,
    Expression<String>? category,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (itemCode != null) 'item_code': itemCode,
      if (price != null) 'price': price,
      if (quantity != null) 'quantity': quantity,
      if (category != null) 'category': category,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ItemsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? description,
      Value<String>? itemCode,
      Value<double>? price,
      Value<int>? quantity,
      Value<String?>? category,
      Value<bool>? isActive,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return ItemsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      itemCode: itemCode ?? this.itemCode,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (itemCode.present) {
      map['item_code'] = Variable<String>(itemCode.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('itemCode: $itemCode, ')
          ..write('price: $price, ')
          ..write('quantity: $quantity, ')
          ..write('category: $category, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InvoicesTable extends Invoices with TableInfo<$InvoicesTable, Invoice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvoicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _invoiceIdMeta =
      const VerificationMeta('invoiceId');
  @override
  late final GeneratedColumn<String> invoiceId = GeneratedColumn<String>(
      'invoice_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _customerIdMeta =
      const VerificationMeta('customerId');
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
      'customer_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES customers (id)'));
  static const VerificationMeta _createdDateMeta =
      const VerificationMeta('createdDate');
  @override
  late final GeneratedColumn<DateTime> createdDate = GeneratedColumn<DateTime>(
      'created_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _closeDateMeta =
      const VerificationMeta('closeDate');
  @override
  late final GeneratedColumn<DateTime> closeDate = GeneratedColumn<DateTime>(
      'close_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isPaidMeta = const VerificationMeta('isPaid');
  @override
  late final GeneratedColumn<bool> isPaid = GeneratedColumn<bool>(
      'is_paid', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_paid" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _totalNetMeta =
      const VerificationMeta('totalNet');
  @override
  late final GeneratedColumn<double> totalNet = GeneratedColumn<double>(
      'total_net', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _totalGstMeta =
      const VerificationMeta('totalGst');
  @override
  late final GeneratedColumn<double> totalGst = GeneratedColumn<double>(
      'total_gst', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<double> total = GeneratedColumn<double>(
      'total', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _paidAmountMeta =
      const VerificationMeta('paidAmount');
  @override
  late final GeneratedColumn<double> paidAmount = GeneratedColumn<double>(
      'paid_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _gstPercentageMeta =
      const VerificationMeta('gstPercentage');
  @override
  late final GeneratedColumn<double> gstPercentage = GeneratedColumn<double>(
      'gst_percentage', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _billingAddressJsonMeta =
      const VerificationMeta('billingAddressJson');
  @override
  late final GeneratedColumn<String> billingAddressJson =
      GeneratedColumn<String>('billing_address_json', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _shippingAddressJsonMeta =
      const VerificationMeta('shippingAddressJson');
  @override
  late final GeneratedColumn<String> shippingAddressJson =
      GeneratedColumn<String>('shipping_address_json', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _customerNameMeta =
      const VerificationMeta('customerName');
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
      'customer_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _customerMobileMeta =
      const VerificationMeta('customerMobile');
  @override
  late final GeneratedColumn<String> customerMobile = GeneratedColumn<String>(
      'customer_mobile', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _commentsJsonMeta =
      const VerificationMeta('commentsJson');
  @override
  late final GeneratedColumn<String> commentsJson = GeneratedColumn<String>(
      'comments_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        invoiceId,
        customerId,
        createdDate,
        closeDate,
        isPaid,
        isDeleted,
        totalNet,
        totalGst,
        total,
        paidAmount,
        gstPercentage,
        billingAddressJson,
        shippingAddressJson,
        customerName,
        customerMobile,
        email,
        commentsJson
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'invoices';
  @override
  VerificationContext validateIntegrity(Insertable<Invoice> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('invoice_id')) {
      context.handle(_invoiceIdMeta,
          invoiceId.isAcceptableOrUnknown(data['invoice_id']!, _invoiceIdMeta));
    } else if (isInserting) {
      context.missing(_invoiceIdMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
          _customerIdMeta,
          customerId.isAcceptableOrUnknown(
              data['customer_id']!, _customerIdMeta));
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('created_date')) {
      context.handle(
          _createdDateMeta,
          createdDate.isAcceptableOrUnknown(
              data['created_date']!, _createdDateMeta));
    } else if (isInserting) {
      context.missing(_createdDateMeta);
    }
    if (data.containsKey('close_date')) {
      context.handle(_closeDateMeta,
          closeDate.isAcceptableOrUnknown(data['close_date']!, _closeDateMeta));
    }
    if (data.containsKey('is_paid')) {
      context.handle(_isPaidMeta,
          isPaid.isAcceptableOrUnknown(data['is_paid']!, _isPaidMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('total_net')) {
      context.handle(_totalNetMeta,
          totalNet.isAcceptableOrUnknown(data['total_net']!, _totalNetMeta));
    } else if (isInserting) {
      context.missing(_totalNetMeta);
    }
    if (data.containsKey('total_gst')) {
      context.handle(_totalGstMeta,
          totalGst.isAcceptableOrUnknown(data['total_gst']!, _totalGstMeta));
    } else if (isInserting) {
      context.missing(_totalGstMeta);
    }
    if (data.containsKey('total')) {
      context.handle(
          _totalMeta, total.isAcceptableOrUnknown(data['total']!, _totalMeta));
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    if (data.containsKey('paid_amount')) {
      context.handle(
          _paidAmountMeta,
          paidAmount.isAcceptableOrUnknown(
              data['paid_amount']!, _paidAmountMeta));
    }
    if (data.containsKey('gst_percentage')) {
      context.handle(
          _gstPercentageMeta,
          gstPercentage.isAcceptableOrUnknown(
              data['gst_percentage']!, _gstPercentageMeta));
    } else if (isInserting) {
      context.missing(_gstPercentageMeta);
    }
    if (data.containsKey('billing_address_json')) {
      context.handle(
          _billingAddressJsonMeta,
          billingAddressJson.isAcceptableOrUnknown(
              data['billing_address_json']!, _billingAddressJsonMeta));
    }
    if (data.containsKey('shipping_address_json')) {
      context.handle(
          _shippingAddressJsonMeta,
          shippingAddressJson.isAcceptableOrUnknown(
              data['shipping_address_json']!, _shippingAddressJsonMeta));
    }
    if (data.containsKey('customer_name')) {
      context.handle(
          _customerNameMeta,
          customerName.isAcceptableOrUnknown(
              data['customer_name']!, _customerNameMeta));
    } else if (isInserting) {
      context.missing(_customerNameMeta);
    }
    if (data.containsKey('customer_mobile')) {
      context.handle(
          _customerMobileMeta,
          customerMobile.isAcceptableOrUnknown(
              data['customer_mobile']!, _customerMobileMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('comments_json')) {
      context.handle(
          _commentsJsonMeta,
          commentsJson.isAcceptableOrUnknown(
              data['comments_json']!, _commentsJsonMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {invoiceId};
  @override
  Invoice map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Invoice(
      invoiceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}invoice_id'])!,
      customerId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_id'])!,
      createdDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_date'])!,
      closeDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}close_date']),
      isPaid: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_paid'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      totalNet: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_net'])!,
      totalGst: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_gst'])!,
      total: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total'])!,
      paidAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}paid_amount'])!,
      gstPercentage: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}gst_percentage'])!,
      billingAddressJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}billing_address_json']),
      shippingAddressJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}shipping_address_json']),
      customerName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_name'])!,
      customerMobile: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_mobile']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      commentsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}comments_json']),
    );
  }

  @override
  $InvoicesTable createAlias(String alias) {
    return $InvoicesTable(attachedDatabase, alias);
  }
}

class Invoice extends DataClass implements Insertable<Invoice> {
  final String invoiceId;
  final String customerId;
  final DateTime createdDate;
  final DateTime? closeDate;
  final bool isPaid;
  final bool isDeleted;
  final double totalNet;
  final double totalGst;
  final double total;
  final double paidAmount;
  final double gstPercentage;
  final String? billingAddressJson;
  final String? shippingAddressJson;
  final String customerName;
  final String? customerMobile;
  final String? email;
  final String? commentsJson;
  const Invoice(
      {required this.invoiceId,
      required this.customerId,
      required this.createdDate,
      this.closeDate,
      required this.isPaid,
      required this.isDeleted,
      required this.totalNet,
      required this.totalGst,
      required this.total,
      required this.paidAmount,
      required this.gstPercentage,
      this.billingAddressJson,
      this.shippingAddressJson,
      required this.customerName,
      this.customerMobile,
      this.email,
      this.commentsJson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['invoice_id'] = Variable<String>(invoiceId);
    map['customer_id'] = Variable<String>(customerId);
    map['created_date'] = Variable<DateTime>(createdDate);
    if (!nullToAbsent || closeDate != null) {
      map['close_date'] = Variable<DateTime>(closeDate);
    }
    map['is_paid'] = Variable<bool>(isPaid);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['total_net'] = Variable<double>(totalNet);
    map['total_gst'] = Variable<double>(totalGst);
    map['total'] = Variable<double>(total);
    map['paid_amount'] = Variable<double>(paidAmount);
    map['gst_percentage'] = Variable<double>(gstPercentage);
    if (!nullToAbsent || billingAddressJson != null) {
      map['billing_address_json'] = Variable<String>(billingAddressJson);
    }
    if (!nullToAbsent || shippingAddressJson != null) {
      map['shipping_address_json'] = Variable<String>(shippingAddressJson);
    }
    map['customer_name'] = Variable<String>(customerName);
    if (!nullToAbsent || customerMobile != null) {
      map['customer_mobile'] = Variable<String>(customerMobile);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || commentsJson != null) {
      map['comments_json'] = Variable<String>(commentsJson);
    }
    return map;
  }

  InvoicesCompanion toCompanion(bool nullToAbsent) {
    return InvoicesCompanion(
      invoiceId: Value(invoiceId),
      customerId: Value(customerId),
      createdDate: Value(createdDate),
      closeDate: closeDate == null && nullToAbsent
          ? const Value.absent()
          : Value(closeDate),
      isPaid: Value(isPaid),
      isDeleted: Value(isDeleted),
      totalNet: Value(totalNet),
      totalGst: Value(totalGst),
      total: Value(total),
      paidAmount: Value(paidAmount),
      gstPercentage: Value(gstPercentage),
      billingAddressJson: billingAddressJson == null && nullToAbsent
          ? const Value.absent()
          : Value(billingAddressJson),
      shippingAddressJson: shippingAddressJson == null && nullToAbsent
          ? const Value.absent()
          : Value(shippingAddressJson),
      customerName: Value(customerName),
      customerMobile: customerMobile == null && nullToAbsent
          ? const Value.absent()
          : Value(customerMobile),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      commentsJson: commentsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(commentsJson),
    );
  }

  factory Invoice.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Invoice(
      invoiceId: serializer.fromJson<String>(json['invoiceId']),
      customerId: serializer.fromJson<String>(json['customerId']),
      createdDate: serializer.fromJson<DateTime>(json['createdDate']),
      closeDate: serializer.fromJson<DateTime?>(json['closeDate']),
      isPaid: serializer.fromJson<bool>(json['isPaid']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      totalNet: serializer.fromJson<double>(json['totalNet']),
      totalGst: serializer.fromJson<double>(json['totalGst']),
      total: serializer.fromJson<double>(json['total']),
      paidAmount: serializer.fromJson<double>(json['paidAmount']),
      gstPercentage: serializer.fromJson<double>(json['gstPercentage']),
      billingAddressJson:
          serializer.fromJson<String?>(json['billingAddressJson']),
      shippingAddressJson:
          serializer.fromJson<String?>(json['shippingAddressJson']),
      customerName: serializer.fromJson<String>(json['customerName']),
      customerMobile: serializer.fromJson<String?>(json['customerMobile']),
      email: serializer.fromJson<String?>(json['email']),
      commentsJson: serializer.fromJson<String?>(json['commentsJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'invoiceId': serializer.toJson<String>(invoiceId),
      'customerId': serializer.toJson<String>(customerId),
      'createdDate': serializer.toJson<DateTime>(createdDate),
      'closeDate': serializer.toJson<DateTime?>(closeDate),
      'isPaid': serializer.toJson<bool>(isPaid),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'totalNet': serializer.toJson<double>(totalNet),
      'totalGst': serializer.toJson<double>(totalGst),
      'total': serializer.toJson<double>(total),
      'paidAmount': serializer.toJson<double>(paidAmount),
      'gstPercentage': serializer.toJson<double>(gstPercentage),
      'billingAddressJson': serializer.toJson<String?>(billingAddressJson),
      'shippingAddressJson': serializer.toJson<String?>(shippingAddressJson),
      'customerName': serializer.toJson<String>(customerName),
      'customerMobile': serializer.toJson<String?>(customerMobile),
      'email': serializer.toJson<String?>(email),
      'commentsJson': serializer.toJson<String?>(commentsJson),
    };
  }

  Invoice copyWith(
          {String? invoiceId,
          String? customerId,
          DateTime? createdDate,
          Value<DateTime?> closeDate = const Value.absent(),
          bool? isPaid,
          bool? isDeleted,
          double? totalNet,
          double? totalGst,
          double? total,
          double? paidAmount,
          double? gstPercentage,
          Value<String?> billingAddressJson = const Value.absent(),
          Value<String?> shippingAddressJson = const Value.absent(),
          String? customerName,
          Value<String?> customerMobile = const Value.absent(),
          Value<String?> email = const Value.absent(),
          Value<String?> commentsJson = const Value.absent()}) =>
      Invoice(
        invoiceId: invoiceId ?? this.invoiceId,
        customerId: customerId ?? this.customerId,
        createdDate: createdDate ?? this.createdDate,
        closeDate: closeDate.present ? closeDate.value : this.closeDate,
        isPaid: isPaid ?? this.isPaid,
        isDeleted: isDeleted ?? this.isDeleted,
        totalNet: totalNet ?? this.totalNet,
        totalGst: totalGst ?? this.totalGst,
        total: total ?? this.total,
        paidAmount: paidAmount ?? this.paidAmount,
        gstPercentage: gstPercentage ?? this.gstPercentage,
        billingAddressJson: billingAddressJson.present
            ? billingAddressJson.value
            : this.billingAddressJson,
        shippingAddressJson: shippingAddressJson.present
            ? shippingAddressJson.value
            : this.shippingAddressJson,
        customerName: customerName ?? this.customerName,
        customerMobile:
            customerMobile.present ? customerMobile.value : this.customerMobile,
        email: email.present ? email.value : this.email,
        commentsJson:
            commentsJson.present ? commentsJson.value : this.commentsJson,
      );
  Invoice copyWithCompanion(InvoicesCompanion data) {
    return Invoice(
      invoiceId: data.invoiceId.present ? data.invoiceId.value : this.invoiceId,
      customerId:
          data.customerId.present ? data.customerId.value : this.customerId,
      createdDate:
          data.createdDate.present ? data.createdDate.value : this.createdDate,
      closeDate: data.closeDate.present ? data.closeDate.value : this.closeDate,
      isPaid: data.isPaid.present ? data.isPaid.value : this.isPaid,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      totalNet: data.totalNet.present ? data.totalNet.value : this.totalNet,
      totalGst: data.totalGst.present ? data.totalGst.value : this.totalGst,
      total: data.total.present ? data.total.value : this.total,
      paidAmount:
          data.paidAmount.present ? data.paidAmount.value : this.paidAmount,
      gstPercentage: data.gstPercentage.present
          ? data.gstPercentage.value
          : this.gstPercentage,
      billingAddressJson: data.billingAddressJson.present
          ? data.billingAddressJson.value
          : this.billingAddressJson,
      shippingAddressJson: data.shippingAddressJson.present
          ? data.shippingAddressJson.value
          : this.shippingAddressJson,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      customerMobile: data.customerMobile.present
          ? data.customerMobile.value
          : this.customerMobile,
      email: data.email.present ? data.email.value : this.email,
      commentsJson: data.commentsJson.present
          ? data.commentsJson.value
          : this.commentsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Invoice(')
          ..write('invoiceId: $invoiceId, ')
          ..write('customerId: $customerId, ')
          ..write('createdDate: $createdDate, ')
          ..write('closeDate: $closeDate, ')
          ..write('isPaid: $isPaid, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('totalNet: $totalNet, ')
          ..write('totalGst: $totalGst, ')
          ..write('total: $total, ')
          ..write('paidAmount: $paidAmount, ')
          ..write('gstPercentage: $gstPercentage, ')
          ..write('billingAddressJson: $billingAddressJson, ')
          ..write('shippingAddressJson: $shippingAddressJson, ')
          ..write('customerName: $customerName, ')
          ..write('customerMobile: $customerMobile, ')
          ..write('email: $email, ')
          ..write('commentsJson: $commentsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      invoiceId,
      customerId,
      createdDate,
      closeDate,
      isPaid,
      isDeleted,
      totalNet,
      totalGst,
      total,
      paidAmount,
      gstPercentage,
      billingAddressJson,
      shippingAddressJson,
      customerName,
      customerMobile,
      email,
      commentsJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Invoice &&
          other.invoiceId == this.invoiceId &&
          other.customerId == this.customerId &&
          other.createdDate == this.createdDate &&
          other.closeDate == this.closeDate &&
          other.isPaid == this.isPaid &&
          other.isDeleted == this.isDeleted &&
          other.totalNet == this.totalNet &&
          other.totalGst == this.totalGst &&
          other.total == this.total &&
          other.paidAmount == this.paidAmount &&
          other.gstPercentage == this.gstPercentage &&
          other.billingAddressJson == this.billingAddressJson &&
          other.shippingAddressJson == this.shippingAddressJson &&
          other.customerName == this.customerName &&
          other.customerMobile == this.customerMobile &&
          other.email == this.email &&
          other.commentsJson == this.commentsJson);
}

class InvoicesCompanion extends UpdateCompanion<Invoice> {
  final Value<String> invoiceId;
  final Value<String> customerId;
  final Value<DateTime> createdDate;
  final Value<DateTime?> closeDate;
  final Value<bool> isPaid;
  final Value<bool> isDeleted;
  final Value<double> totalNet;
  final Value<double> totalGst;
  final Value<double> total;
  final Value<double> paidAmount;
  final Value<double> gstPercentage;
  final Value<String?> billingAddressJson;
  final Value<String?> shippingAddressJson;
  final Value<String> customerName;
  final Value<String?> customerMobile;
  final Value<String?> email;
  final Value<String?> commentsJson;
  final Value<int> rowid;
  const InvoicesCompanion({
    this.invoiceId = const Value.absent(),
    this.customerId = const Value.absent(),
    this.createdDate = const Value.absent(),
    this.closeDate = const Value.absent(),
    this.isPaid = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.totalNet = const Value.absent(),
    this.totalGst = const Value.absent(),
    this.total = const Value.absent(),
    this.paidAmount = const Value.absent(),
    this.gstPercentage = const Value.absent(),
    this.billingAddressJson = const Value.absent(),
    this.shippingAddressJson = const Value.absent(),
    this.customerName = const Value.absent(),
    this.customerMobile = const Value.absent(),
    this.email = const Value.absent(),
    this.commentsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InvoicesCompanion.insert({
    required String invoiceId,
    required String customerId,
    required DateTime createdDate,
    this.closeDate = const Value.absent(),
    this.isPaid = const Value.absent(),
    this.isDeleted = const Value.absent(),
    required double totalNet,
    required double totalGst,
    required double total,
    this.paidAmount = const Value.absent(),
    required double gstPercentage,
    this.billingAddressJson = const Value.absent(),
    this.shippingAddressJson = const Value.absent(),
    required String customerName,
    this.customerMobile = const Value.absent(),
    this.email = const Value.absent(),
    this.commentsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : invoiceId = Value(invoiceId),
        customerId = Value(customerId),
        createdDate = Value(createdDate),
        totalNet = Value(totalNet),
        totalGst = Value(totalGst),
        total = Value(total),
        gstPercentage = Value(gstPercentage),
        customerName = Value(customerName);
  static Insertable<Invoice> custom({
    Expression<String>? invoiceId,
    Expression<String>? customerId,
    Expression<DateTime>? createdDate,
    Expression<DateTime>? closeDate,
    Expression<bool>? isPaid,
    Expression<bool>? isDeleted,
    Expression<double>? totalNet,
    Expression<double>? totalGst,
    Expression<double>? total,
    Expression<double>? paidAmount,
    Expression<double>? gstPercentage,
    Expression<String>? billingAddressJson,
    Expression<String>? shippingAddressJson,
    Expression<String>? customerName,
    Expression<String>? customerMobile,
    Expression<String>? email,
    Expression<String>? commentsJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (invoiceId != null) 'invoice_id': invoiceId,
      if (customerId != null) 'customer_id': customerId,
      if (createdDate != null) 'created_date': createdDate,
      if (closeDate != null) 'close_date': closeDate,
      if (isPaid != null) 'is_paid': isPaid,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (totalNet != null) 'total_net': totalNet,
      if (totalGst != null) 'total_gst': totalGst,
      if (total != null) 'total': total,
      if (paidAmount != null) 'paid_amount': paidAmount,
      if (gstPercentage != null) 'gst_percentage': gstPercentage,
      if (billingAddressJson != null)
        'billing_address_json': billingAddressJson,
      if (shippingAddressJson != null)
        'shipping_address_json': shippingAddressJson,
      if (customerName != null) 'customer_name': customerName,
      if (customerMobile != null) 'customer_mobile': customerMobile,
      if (email != null) 'email': email,
      if (commentsJson != null) 'comments_json': commentsJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InvoicesCompanion copyWith(
      {Value<String>? invoiceId,
      Value<String>? customerId,
      Value<DateTime>? createdDate,
      Value<DateTime?>? closeDate,
      Value<bool>? isPaid,
      Value<bool>? isDeleted,
      Value<double>? totalNet,
      Value<double>? totalGst,
      Value<double>? total,
      Value<double>? paidAmount,
      Value<double>? gstPercentage,
      Value<String?>? billingAddressJson,
      Value<String?>? shippingAddressJson,
      Value<String>? customerName,
      Value<String?>? customerMobile,
      Value<String?>? email,
      Value<String?>? commentsJson,
      Value<int>? rowid}) {
    return InvoicesCompanion(
      invoiceId: invoiceId ?? this.invoiceId,
      customerId: customerId ?? this.customerId,
      createdDate: createdDate ?? this.createdDate,
      closeDate: closeDate ?? this.closeDate,
      isPaid: isPaid ?? this.isPaid,
      isDeleted: isDeleted ?? this.isDeleted,
      totalNet: totalNet ?? this.totalNet,
      totalGst: totalGst ?? this.totalGst,
      total: total ?? this.total,
      paidAmount: paidAmount ?? this.paidAmount,
      gstPercentage: gstPercentage ?? this.gstPercentage,
      billingAddressJson: billingAddressJson ?? this.billingAddressJson,
      shippingAddressJson: shippingAddressJson ?? this.shippingAddressJson,
      customerName: customerName ?? this.customerName,
      customerMobile: customerMobile ?? this.customerMobile,
      email: email ?? this.email,
      commentsJson: commentsJson ?? this.commentsJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (invoiceId.present) {
      map['invoice_id'] = Variable<String>(invoiceId.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (createdDate.present) {
      map['created_date'] = Variable<DateTime>(createdDate.value);
    }
    if (closeDate.present) {
      map['close_date'] = Variable<DateTime>(closeDate.value);
    }
    if (isPaid.present) {
      map['is_paid'] = Variable<bool>(isPaid.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (totalNet.present) {
      map['total_net'] = Variable<double>(totalNet.value);
    }
    if (totalGst.present) {
      map['total_gst'] = Variable<double>(totalGst.value);
    }
    if (total.present) {
      map['total'] = Variable<double>(total.value);
    }
    if (paidAmount.present) {
      map['paid_amount'] = Variable<double>(paidAmount.value);
    }
    if (gstPercentage.present) {
      map['gst_percentage'] = Variable<double>(gstPercentage.value);
    }
    if (billingAddressJson.present) {
      map['billing_address_json'] = Variable<String>(billingAddressJson.value);
    }
    if (shippingAddressJson.present) {
      map['shipping_address_json'] =
          Variable<String>(shippingAddressJson.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (customerMobile.present) {
      map['customer_mobile'] = Variable<String>(customerMobile.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (commentsJson.present) {
      map['comments_json'] = Variable<String>(commentsJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvoicesCompanion(')
          ..write('invoiceId: $invoiceId, ')
          ..write('customerId: $customerId, ')
          ..write('createdDate: $createdDate, ')
          ..write('closeDate: $closeDate, ')
          ..write('isPaid: $isPaid, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('totalNet: $totalNet, ')
          ..write('totalGst: $totalGst, ')
          ..write('total: $total, ')
          ..write('paidAmount: $paidAmount, ')
          ..write('gstPercentage: $gstPercentage, ')
          ..write('billingAddressJson: $billingAddressJson, ')
          ..write('shippingAddressJson: $shippingAddressJson, ')
          ..write('customerName: $customerName, ')
          ..write('customerMobile: $customerMobile, ')
          ..write('email: $email, ')
          ..write('commentsJson: $commentsJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InvoiceItemsTable extends InvoiceItems
    with TableInfo<$InvoiceItemsTable, InvoiceItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvoiceItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _invoiceIdMeta =
      const VerificationMeta('invoiceId');
  @override
  late final GeneratedColumn<String> invoiceId = GeneratedColumn<String>(
      'invoice_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES invoices (invoice_id) ON DELETE CASCADE'));
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
      'item_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES items (id)'));
  static const VerificationMeta _itemNameMeta =
      const VerificationMeta('itemName');
  @override
  late final GeneratedColumn<String> itemName = GeneratedColumn<String>(
      'item_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _netPriceMeta =
      const VerificationMeta('netPrice');
  @override
  late final GeneratedColumn<double> netPrice = GeneratedColumn<double>(
      'net_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _commentMeta =
      const VerificationMeta('comment');
  @override
  late final GeneratedColumn<String> comment = GeneratedColumn<String>(
      'comment', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isPostedItemMeta =
      const VerificationMeta('isPostedItem');
  @override
  late final GeneratedColumn<bool> isPostedItem = GeneratedColumn<bool>(
      'is_posted_item', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_posted_item" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        invoiceId,
        itemId,
        itemName,
        quantity,
        netPrice,
        comment,
        isPostedItem,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'invoice_items';
  @override
  VerificationContext validateIntegrity(Insertable<InvoiceItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('invoice_id')) {
      context.handle(_invoiceIdMeta,
          invoiceId.isAcceptableOrUnknown(data['invoice_id']!, _invoiceIdMeta));
    } else if (isInserting) {
      context.missing(_invoiceIdMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('item_name')) {
      context.handle(_itemNameMeta,
          itemName.isAcceptableOrUnknown(data['item_name']!, _itemNameMeta));
    } else if (isInserting) {
      context.missing(_itemNameMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('net_price')) {
      context.handle(_netPriceMeta,
          netPrice.isAcceptableOrUnknown(data['net_price']!, _netPriceMeta));
    } else if (isInserting) {
      context.missing(_netPriceMeta);
    }
    if (data.containsKey('comment')) {
      context.handle(_commentMeta,
          comment.isAcceptableOrUnknown(data['comment']!, _commentMeta));
    }
    if (data.containsKey('is_posted_item')) {
      context.handle(
          _isPostedItemMeta,
          isPostedItem.isAcceptableOrUnknown(
              data['is_posted_item']!, _isPostedItemMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InvoiceItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InvoiceItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      invoiceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}invoice_id'])!,
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_id'])!,
      itemName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_name'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
      netPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}net_price'])!,
      comment: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}comment']),
      isPostedItem: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_posted_item'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $InvoiceItemsTable createAlias(String alias) {
    return $InvoiceItemsTable(attachedDatabase, alias);
  }
}

class InvoiceItem extends DataClass implements Insertable<InvoiceItem> {
  final int id;
  final String invoiceId;
  final String itemId;
  final String itemName;
  final int quantity;
  final double netPrice;
  final String? comment;
  final bool isPostedItem;
  final DateTime createdAt;
  const InvoiceItem(
      {required this.id,
      required this.invoiceId,
      required this.itemId,
      required this.itemName,
      required this.quantity,
      required this.netPrice,
      this.comment,
      required this.isPostedItem,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['invoice_id'] = Variable<String>(invoiceId);
    map['item_id'] = Variable<String>(itemId);
    map['item_name'] = Variable<String>(itemName);
    map['quantity'] = Variable<int>(quantity);
    map['net_price'] = Variable<double>(netPrice);
    if (!nullToAbsent || comment != null) {
      map['comment'] = Variable<String>(comment);
    }
    map['is_posted_item'] = Variable<bool>(isPostedItem);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  InvoiceItemsCompanion toCompanion(bool nullToAbsent) {
    return InvoiceItemsCompanion(
      id: Value(id),
      invoiceId: Value(invoiceId),
      itemId: Value(itemId),
      itemName: Value(itemName),
      quantity: Value(quantity),
      netPrice: Value(netPrice),
      comment: comment == null && nullToAbsent
          ? const Value.absent()
          : Value(comment),
      isPostedItem: Value(isPostedItem),
      createdAt: Value(createdAt),
    );
  }

  factory InvoiceItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InvoiceItem(
      id: serializer.fromJson<int>(json['id']),
      invoiceId: serializer.fromJson<String>(json['invoiceId']),
      itemId: serializer.fromJson<String>(json['itemId']),
      itemName: serializer.fromJson<String>(json['itemName']),
      quantity: serializer.fromJson<int>(json['quantity']),
      netPrice: serializer.fromJson<double>(json['netPrice']),
      comment: serializer.fromJson<String?>(json['comment']),
      isPostedItem: serializer.fromJson<bool>(json['isPostedItem']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'invoiceId': serializer.toJson<String>(invoiceId),
      'itemId': serializer.toJson<String>(itemId),
      'itemName': serializer.toJson<String>(itemName),
      'quantity': serializer.toJson<int>(quantity),
      'netPrice': serializer.toJson<double>(netPrice),
      'comment': serializer.toJson<String?>(comment),
      'isPostedItem': serializer.toJson<bool>(isPostedItem),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  InvoiceItem copyWith(
          {int? id,
          String? invoiceId,
          String? itemId,
          String? itemName,
          int? quantity,
          double? netPrice,
          Value<String?> comment = const Value.absent(),
          bool? isPostedItem,
          DateTime? createdAt}) =>
      InvoiceItem(
        id: id ?? this.id,
        invoiceId: invoiceId ?? this.invoiceId,
        itemId: itemId ?? this.itemId,
        itemName: itemName ?? this.itemName,
        quantity: quantity ?? this.quantity,
        netPrice: netPrice ?? this.netPrice,
        comment: comment.present ? comment.value : this.comment,
        isPostedItem: isPostedItem ?? this.isPostedItem,
        createdAt: createdAt ?? this.createdAt,
      );
  InvoiceItem copyWithCompanion(InvoiceItemsCompanion data) {
    return InvoiceItem(
      id: data.id.present ? data.id.value : this.id,
      invoiceId: data.invoiceId.present ? data.invoiceId.value : this.invoiceId,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      itemName: data.itemName.present ? data.itemName.value : this.itemName,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      netPrice: data.netPrice.present ? data.netPrice.value : this.netPrice,
      comment: data.comment.present ? data.comment.value : this.comment,
      isPostedItem: data.isPostedItem.present
          ? data.isPostedItem.value
          : this.isPostedItem,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InvoiceItem(')
          ..write('id: $id, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('itemId: $itemId, ')
          ..write('itemName: $itemName, ')
          ..write('quantity: $quantity, ')
          ..write('netPrice: $netPrice, ')
          ..write('comment: $comment, ')
          ..write('isPostedItem: $isPostedItem, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, invoiceId, itemId, itemName, quantity,
      netPrice, comment, isPostedItem, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InvoiceItem &&
          other.id == this.id &&
          other.invoiceId == this.invoiceId &&
          other.itemId == this.itemId &&
          other.itemName == this.itemName &&
          other.quantity == this.quantity &&
          other.netPrice == this.netPrice &&
          other.comment == this.comment &&
          other.isPostedItem == this.isPostedItem &&
          other.createdAt == this.createdAt);
}

class InvoiceItemsCompanion extends UpdateCompanion<InvoiceItem> {
  final Value<int> id;
  final Value<String> invoiceId;
  final Value<String> itemId;
  final Value<String> itemName;
  final Value<int> quantity;
  final Value<double> netPrice;
  final Value<String?> comment;
  final Value<bool> isPostedItem;
  final Value<DateTime> createdAt;
  const InvoiceItemsCompanion({
    this.id = const Value.absent(),
    this.invoiceId = const Value.absent(),
    this.itemId = const Value.absent(),
    this.itemName = const Value.absent(),
    this.quantity = const Value.absent(),
    this.netPrice = const Value.absent(),
    this.comment = const Value.absent(),
    this.isPostedItem = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  InvoiceItemsCompanion.insert({
    this.id = const Value.absent(),
    required String invoiceId,
    required String itemId,
    required String itemName,
    required int quantity,
    required double netPrice,
    this.comment = const Value.absent(),
    this.isPostedItem = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : invoiceId = Value(invoiceId),
        itemId = Value(itemId),
        itemName = Value(itemName),
        quantity = Value(quantity),
        netPrice = Value(netPrice);
  static Insertable<InvoiceItem> custom({
    Expression<int>? id,
    Expression<String>? invoiceId,
    Expression<String>? itemId,
    Expression<String>? itemName,
    Expression<int>? quantity,
    Expression<double>? netPrice,
    Expression<String>? comment,
    Expression<bool>? isPostedItem,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (invoiceId != null) 'invoice_id': invoiceId,
      if (itemId != null) 'item_id': itemId,
      if (itemName != null) 'item_name': itemName,
      if (quantity != null) 'quantity': quantity,
      if (netPrice != null) 'net_price': netPrice,
      if (comment != null) 'comment': comment,
      if (isPostedItem != null) 'is_posted_item': isPostedItem,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  InvoiceItemsCompanion copyWith(
      {Value<int>? id,
      Value<String>? invoiceId,
      Value<String>? itemId,
      Value<String>? itemName,
      Value<int>? quantity,
      Value<double>? netPrice,
      Value<String?>? comment,
      Value<bool>? isPostedItem,
      Value<DateTime>? createdAt}) {
    return InvoiceItemsCompanion(
      id: id ?? this.id,
      invoiceId: invoiceId ?? this.invoiceId,
      itemId: itemId ?? this.itemId,
      itemName: itemName ?? this.itemName,
      quantity: quantity ?? this.quantity,
      netPrice: netPrice ?? this.netPrice,
      comment: comment ?? this.comment,
      isPostedItem: isPostedItem ?? this.isPostedItem,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (invoiceId.present) {
      map['invoice_id'] = Variable<String>(invoiceId.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (itemName.present) {
      map['item_name'] = Variable<String>(itemName.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (netPrice.present) {
      map['net_price'] = Variable<double>(netPrice.value);
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
    }
    if (isPostedItem.present) {
      map['is_posted_item'] = Variable<bool>(isPostedItem.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvoiceItemsCompanion(')
          ..write('id: $id, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('itemId: $itemId, ')
          ..write('itemName: $itemName, ')
          ..write('quantity: $quantity, ')
          ..write('netPrice: $netPrice, ')
          ..write('comment: $comment, ')
          ..write('isPostedItem: $isPostedItem, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PaymentsTable extends Payments with TableInfo<$PaymentsTable, Payment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _payIdMeta = const VerificationMeta('payId');
  @override
  late final GeneratedColumn<String> payId = GeneratedColumn<String>(
      'pay_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _invoiceIdMeta =
      const VerificationMeta('invoiceId');
  @override
  late final GeneratedColumn<String> invoiceId = GeneratedColumn<String>(
      'invoice_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES invoices (invoice_id) ON DELETE CASCADE'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _paymentMethodMeta =
      const VerificationMeta('paymentMethod');
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
      'payment_method', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _commentMeta =
      const VerificationMeta('comment');
  @override
  late final GeneratedColumn<String> comment = GeneratedColumn<String>(
      'comment', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [payId, invoiceId, amount, date, paymentMethod, comment, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payments';
  @override
  VerificationContext validateIntegrity(Insertable<Payment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('pay_id')) {
      context.handle(
          _payIdMeta, payId.isAcceptableOrUnknown(data['pay_id']!, _payIdMeta));
    } else if (isInserting) {
      context.missing(_payIdMeta);
    }
    if (data.containsKey('invoice_id')) {
      context.handle(_invoiceIdMeta,
          invoiceId.isAcceptableOrUnknown(data['invoice_id']!, _invoiceIdMeta));
    } else if (isInserting) {
      context.missing(_invoiceIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('payment_method')) {
      context.handle(
          _paymentMethodMeta,
          paymentMethod.isAcceptableOrUnknown(
              data['payment_method']!, _paymentMethodMeta));
    } else if (isInserting) {
      context.missing(_paymentMethodMeta);
    }
    if (data.containsKey('comment')) {
      context.handle(_commentMeta,
          comment.isAcceptableOrUnknown(data['comment']!, _commentMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {payId};
  @override
  Payment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Payment(
      payId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pay_id'])!,
      invoiceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}invoice_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      paymentMethod: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_method'])!,
      comment: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}comment']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $PaymentsTable createAlias(String alias) {
    return $PaymentsTable(attachedDatabase, alias);
  }
}

class Payment extends DataClass implements Insertable<Payment> {
  final String payId;
  final String invoiceId;
  final double amount;
  final DateTime date;
  final String paymentMethod;
  final String? comment;
  final DateTime createdAt;
  const Payment(
      {required this.payId,
      required this.invoiceId,
      required this.amount,
      required this.date,
      required this.paymentMethod,
      this.comment,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['pay_id'] = Variable<String>(payId);
    map['invoice_id'] = Variable<String>(invoiceId);
    map['amount'] = Variable<double>(amount);
    map['date'] = Variable<DateTime>(date);
    map['payment_method'] = Variable<String>(paymentMethod);
    if (!nullToAbsent || comment != null) {
      map['comment'] = Variable<String>(comment);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PaymentsCompanion toCompanion(bool nullToAbsent) {
    return PaymentsCompanion(
      payId: Value(payId),
      invoiceId: Value(invoiceId),
      amount: Value(amount),
      date: Value(date),
      paymentMethod: Value(paymentMethod),
      comment: comment == null && nullToAbsent
          ? const Value.absent()
          : Value(comment),
      createdAt: Value(createdAt),
    );
  }

  factory Payment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Payment(
      payId: serializer.fromJson<String>(json['payId']),
      invoiceId: serializer.fromJson<String>(json['invoiceId']),
      amount: serializer.fromJson<double>(json['amount']),
      date: serializer.fromJson<DateTime>(json['date']),
      paymentMethod: serializer.fromJson<String>(json['paymentMethod']),
      comment: serializer.fromJson<String?>(json['comment']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'payId': serializer.toJson<String>(payId),
      'invoiceId': serializer.toJson<String>(invoiceId),
      'amount': serializer.toJson<double>(amount),
      'date': serializer.toJson<DateTime>(date),
      'paymentMethod': serializer.toJson<String>(paymentMethod),
      'comment': serializer.toJson<String?>(comment),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Payment copyWith(
          {String? payId,
          String? invoiceId,
          double? amount,
          DateTime? date,
          String? paymentMethod,
          Value<String?> comment = const Value.absent(),
          DateTime? createdAt}) =>
      Payment(
        payId: payId ?? this.payId,
        invoiceId: invoiceId ?? this.invoiceId,
        amount: amount ?? this.amount,
        date: date ?? this.date,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        comment: comment.present ? comment.value : this.comment,
        createdAt: createdAt ?? this.createdAt,
      );
  Payment copyWithCompanion(PaymentsCompanion data) {
    return Payment(
      payId: data.payId.present ? data.payId.value : this.payId,
      invoiceId: data.invoiceId.present ? data.invoiceId.value : this.invoiceId,
      amount: data.amount.present ? data.amount.value : this.amount,
      date: data.date.present ? data.date.value : this.date,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      comment: data.comment.present ? data.comment.value : this.comment,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Payment(')
          ..write('payId: $payId, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('comment: $comment, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      payId, invoiceId, amount, date, paymentMethod, comment, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Payment &&
          other.payId == this.payId &&
          other.invoiceId == this.invoiceId &&
          other.amount == this.amount &&
          other.date == this.date &&
          other.paymentMethod == this.paymentMethod &&
          other.comment == this.comment &&
          other.createdAt == this.createdAt);
}

class PaymentsCompanion extends UpdateCompanion<Payment> {
  final Value<String> payId;
  final Value<String> invoiceId;
  final Value<double> amount;
  final Value<DateTime> date;
  final Value<String> paymentMethod;
  final Value<String?> comment;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PaymentsCompanion({
    this.payId = const Value.absent(),
    this.invoiceId = const Value.absent(),
    this.amount = const Value.absent(),
    this.date = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.comment = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PaymentsCompanion.insert({
    required String payId,
    required String invoiceId,
    required double amount,
    required DateTime date,
    required String paymentMethod,
    this.comment = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : payId = Value(payId),
        invoiceId = Value(invoiceId),
        amount = Value(amount),
        date = Value(date),
        paymentMethod = Value(paymentMethod);
  static Insertable<Payment> custom({
    Expression<String>? payId,
    Expression<String>? invoiceId,
    Expression<double>? amount,
    Expression<DateTime>? date,
    Expression<String>? paymentMethod,
    Expression<String>? comment,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (payId != null) 'pay_id': payId,
      if (invoiceId != null) 'invoice_id': invoiceId,
      if (amount != null) 'amount': amount,
      if (date != null) 'date': date,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (comment != null) 'comment': comment,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PaymentsCompanion copyWith(
      {Value<String>? payId,
      Value<String>? invoiceId,
      Value<double>? amount,
      Value<DateTime>? date,
      Value<String>? paymentMethod,
      Value<String?>? comment,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return PaymentsCompanion(
      payId: payId ?? this.payId,
      invoiceId: invoiceId ?? this.invoiceId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (payId.present) {
      map['pay_id'] = Variable<String>(payId.value);
    }
    if (invoiceId.present) {
      map['invoice_id'] = Variable<String>(invoiceId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
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
    return (StringBuffer('PaymentsCompanion(')
          ..write('payId: $payId, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('comment: $comment, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExtraChargesTable extends ExtraCharges
    with TableInfo<$ExtraChargesTable, ExtraCharge> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExtraChargesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _invoiceIdMeta =
      const VerificationMeta('invoiceId');
  @override
  late final GeneratedColumn<String> invoiceId = GeneratedColumn<String>(
      'invoice_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES invoices (invoice_id) ON DELETE CASCADE'));
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, invoiceId, description, amount, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'extra_charges';
  @override
  VerificationContext validateIntegrity(Insertable<ExtraCharge> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('invoice_id')) {
      context.handle(_invoiceIdMeta,
          invoiceId.isAcceptableOrUnknown(data['invoice_id']!, _invoiceIdMeta));
    } else if (isInserting) {
      context.missing(_invoiceIdMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExtraCharge map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExtraCharge(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      invoiceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}invoice_id'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ExtraChargesTable createAlias(String alias) {
    return $ExtraChargesTable(attachedDatabase, alias);
  }
}

class ExtraCharge extends DataClass implements Insertable<ExtraCharge> {
  final int id;
  final String invoiceId;
  final String description;
  final double amount;
  final DateTime createdAt;
  const ExtraCharge(
      {required this.id,
      required this.invoiceId,
      required this.description,
      required this.amount,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['invoice_id'] = Variable<String>(invoiceId);
    map['description'] = Variable<String>(description);
    map['amount'] = Variable<double>(amount);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ExtraChargesCompanion toCompanion(bool nullToAbsent) {
    return ExtraChargesCompanion(
      id: Value(id),
      invoiceId: Value(invoiceId),
      description: Value(description),
      amount: Value(amount),
      createdAt: Value(createdAt),
    );
  }

  factory ExtraCharge.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExtraCharge(
      id: serializer.fromJson<int>(json['id']),
      invoiceId: serializer.fromJson<String>(json['invoiceId']),
      description: serializer.fromJson<String>(json['description']),
      amount: serializer.fromJson<double>(json['amount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'invoiceId': serializer.toJson<String>(invoiceId),
      'description': serializer.toJson<String>(description),
      'amount': serializer.toJson<double>(amount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ExtraCharge copyWith(
          {int? id,
          String? invoiceId,
          String? description,
          double? amount,
          DateTime? createdAt}) =>
      ExtraCharge(
        id: id ?? this.id,
        invoiceId: invoiceId ?? this.invoiceId,
        description: description ?? this.description,
        amount: amount ?? this.amount,
        createdAt: createdAt ?? this.createdAt,
      );
  ExtraCharge copyWithCompanion(ExtraChargesCompanion data) {
    return ExtraCharge(
      id: data.id.present ? data.id.value : this.id,
      invoiceId: data.invoiceId.present ? data.invoiceId.value : this.invoiceId,
      description:
          data.description.present ? data.description.value : this.description,
      amount: data.amount.present ? data.amount.value : this.amount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExtraCharge(')
          ..write('id: $id, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('description: $description, ')
          ..write('amount: $amount, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, invoiceId, description, amount, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExtraCharge &&
          other.id == this.id &&
          other.invoiceId == this.invoiceId &&
          other.description == this.description &&
          other.amount == this.amount &&
          other.createdAt == this.createdAt);
}

class ExtraChargesCompanion extends UpdateCompanion<ExtraCharge> {
  final Value<int> id;
  final Value<String> invoiceId;
  final Value<String> description;
  final Value<double> amount;
  final Value<DateTime> createdAt;
  const ExtraChargesCompanion({
    this.id = const Value.absent(),
    this.invoiceId = const Value.absent(),
    this.description = const Value.absent(),
    this.amount = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ExtraChargesCompanion.insert({
    this.id = const Value.absent(),
    required String invoiceId,
    required String description,
    required double amount,
    this.createdAt = const Value.absent(),
  })  : invoiceId = Value(invoiceId),
        description = Value(description),
        amount = Value(amount);
  static Insertable<ExtraCharge> custom({
    Expression<int>? id,
    Expression<String>? invoiceId,
    Expression<String>? description,
    Expression<double>? amount,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (invoiceId != null) 'invoice_id': invoiceId,
      if (description != null) 'description': description,
      if (amount != null) 'amount': amount,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ExtraChargesCompanion copyWith(
      {Value<int>? id,
      Value<String>? invoiceId,
      Value<String>? description,
      Value<double>? amount,
      Value<DateTime>? createdAt}) {
    return ExtraChargesCompanion(
      id: id ?? this.id,
      invoiceId: invoiceId ?? this.invoiceId,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (invoiceId.present) {
      map['invoice_id'] = Variable<String>(invoiceId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExtraChargesCompanion(')
          ..write('id: $id, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('description: $description, ')
          ..write('amount: $amount, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SuppliersTable extends Suppliers
    with TableInfo<$SuppliersTable, Supplier> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SuppliersTable(this.attachedDatabase, [this._alias]);
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
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastNameMeta =
      const VerificationMeta('lastName');
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
      'last_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _mobileNumberMeta =
      const VerificationMeta('mobileNumber');
  @override
  late final GeneratedColumn<String> mobileNumber = GeneratedColumn<String>(
      'mobile_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _faxMeta = const VerificationMeta('fax');
  @override
  late final GeneratedColumn<String> fax = GeneratedColumn<String>(
      'fax', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _webMeta = const VerificationMeta('web');
  @override
  late final GeneratedColumn<String> web = GeneratedColumn<String>(
      'web', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _abnMeta = const VerificationMeta('abn');
  @override
  late final GeneratedColumn<String> abn = GeneratedColumn<String>(
      'abn', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _acnMeta = const VerificationMeta('acn');
  @override
  late final GeneratedColumn<String> acn = GeneratedColumn<String>(
      'acn', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _commentMeta =
      const VerificationMeta('comment');
  @override
  late final GeneratedColumn<String> comment = GeneratedColumn<String>(
      'comment', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _streetMeta = const VerificationMeta('street');
  @override
  late final GeneratedColumn<String> street = GeneratedColumn<String>(
      'street', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
      'city', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
      'state', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _areaCodeMeta =
      const VerificationMeta('areaCode');
  @override
  late final GeneratedColumn<String> areaCode = GeneratedColumn<String>(
      'area_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _postalCodeMeta =
      const VerificationMeta('postalCode');
  @override
  late final GeneratedColumn<String> postalCode = GeneratedColumn<String>(
      'postal_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _countryMeta =
      const VerificationMeta('country');
  @override
  late final GeneratedColumn<String> country = GeneratedColumn<String>(
      'country', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        firstName,
        lastName,
        mobileNumber,
        email,
        fax,
        web,
        abn,
        acn,
        comment,
        street,
        city,
        state,
        areaCode,
        postalCode,
        country,
        isActive,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'suppliers';
  @override
  VerificationContext validateIntegrity(Insertable<Supplier> instance,
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
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(_lastNameMeta,
          lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta));
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    if (data.containsKey('mobile_number')) {
      context.handle(
          _mobileNumberMeta,
          mobileNumber.isAcceptableOrUnknown(
              data['mobile_number']!, _mobileNumberMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('fax')) {
      context.handle(
          _faxMeta, fax.isAcceptableOrUnknown(data['fax']!, _faxMeta));
    }
    if (data.containsKey('web')) {
      context.handle(
          _webMeta, web.isAcceptableOrUnknown(data['web']!, _webMeta));
    }
    if (data.containsKey('abn')) {
      context.handle(
          _abnMeta, abn.isAcceptableOrUnknown(data['abn']!, _abnMeta));
    }
    if (data.containsKey('acn')) {
      context.handle(
          _acnMeta, acn.isAcceptableOrUnknown(data['acn']!, _acnMeta));
    }
    if (data.containsKey('comment')) {
      context.handle(_commentMeta,
          comment.isAcceptableOrUnknown(data['comment']!, _commentMeta));
    }
    if (data.containsKey('street')) {
      context.handle(_streetMeta,
          street.isAcceptableOrUnknown(data['street']!, _streetMeta));
    }
    if (data.containsKey('city')) {
      context.handle(
          _cityMeta, city.isAcceptableOrUnknown(data['city']!, _cityMeta));
    }
    if (data.containsKey('state')) {
      context.handle(
          _stateMeta, state.isAcceptableOrUnknown(data['state']!, _stateMeta));
    }
    if (data.containsKey('area_code')) {
      context.handle(_areaCodeMeta,
          areaCode.isAcceptableOrUnknown(data['area_code']!, _areaCodeMeta));
    }
    if (data.containsKey('postal_code')) {
      context.handle(
          _postalCodeMeta,
          postalCode.isAcceptableOrUnknown(
              data['postal_code']!, _postalCodeMeta));
    }
    if (data.containsKey('country')) {
      context.handle(_countryMeta,
          country.isAcceptableOrUnknown(data['country']!, _countryMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Supplier map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Supplier(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      firstName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}first_name'])!,
      lastName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_name'])!,
      mobileNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mobile_number']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      fax: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}fax']),
      web: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}web']),
      abn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}abn']),
      acn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}acn']),
      comment: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}comment']),
      street: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}street']),
      city: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}city']),
      state: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}state']),
      areaCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}area_code']),
      postalCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}postal_code']),
      country: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}country']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $SuppliersTable createAlias(String alias) {
    return $SuppliersTable(attachedDatabase, alias);
  }
}

class Supplier extends DataClass implements Insertable<Supplier> {
  final String id;
  final String firstName;
  final String lastName;
  final String? mobileNumber;
  final String? email;
  final String? fax;
  final String? web;
  final String? abn;
  final String? acn;
  final String? comment;
  final String? street;
  final String? city;
  final String? state;
  final String? areaCode;
  final String? postalCode;
  final String? country;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Supplier(
      {required this.id,
      required this.firstName,
      required this.lastName,
      this.mobileNumber,
      this.email,
      this.fax,
      this.web,
      this.abn,
      this.acn,
      this.comment,
      this.street,
      this.city,
      this.state,
      this.areaCode,
      this.postalCode,
      this.country,
      required this.isActive,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['first_name'] = Variable<String>(firstName);
    map['last_name'] = Variable<String>(lastName);
    if (!nullToAbsent || mobileNumber != null) {
      map['mobile_number'] = Variable<String>(mobileNumber);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || fax != null) {
      map['fax'] = Variable<String>(fax);
    }
    if (!nullToAbsent || web != null) {
      map['web'] = Variable<String>(web);
    }
    if (!nullToAbsent || abn != null) {
      map['abn'] = Variable<String>(abn);
    }
    if (!nullToAbsent || acn != null) {
      map['acn'] = Variable<String>(acn);
    }
    if (!nullToAbsent || comment != null) {
      map['comment'] = Variable<String>(comment);
    }
    if (!nullToAbsent || street != null) {
      map['street'] = Variable<String>(street);
    }
    if (!nullToAbsent || city != null) {
      map['city'] = Variable<String>(city);
    }
    if (!nullToAbsent || state != null) {
      map['state'] = Variable<String>(state);
    }
    if (!nullToAbsent || areaCode != null) {
      map['area_code'] = Variable<String>(areaCode);
    }
    if (!nullToAbsent || postalCode != null) {
      map['postal_code'] = Variable<String>(postalCode);
    }
    if (!nullToAbsent || country != null) {
      map['country'] = Variable<String>(country);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SuppliersCompanion toCompanion(bool nullToAbsent) {
    return SuppliersCompanion(
      id: Value(id),
      firstName: Value(firstName),
      lastName: Value(lastName),
      mobileNumber: mobileNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(mobileNumber),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      fax: fax == null && nullToAbsent ? const Value.absent() : Value(fax),
      web: web == null && nullToAbsent ? const Value.absent() : Value(web),
      abn: abn == null && nullToAbsent ? const Value.absent() : Value(abn),
      acn: acn == null && nullToAbsent ? const Value.absent() : Value(acn),
      comment: comment == null && nullToAbsent
          ? const Value.absent()
          : Value(comment),
      street:
          street == null && nullToAbsent ? const Value.absent() : Value(street),
      city: city == null && nullToAbsent ? const Value.absent() : Value(city),
      state:
          state == null && nullToAbsent ? const Value.absent() : Value(state),
      areaCode: areaCode == null && nullToAbsent
          ? const Value.absent()
          : Value(areaCode),
      postalCode: postalCode == null && nullToAbsent
          ? const Value.absent()
          : Value(postalCode),
      country: country == null && nullToAbsent
          ? const Value.absent()
          : Value(country),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Supplier.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Supplier(
      id: serializer.fromJson<String>(json['id']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String>(json['lastName']),
      mobileNumber: serializer.fromJson<String?>(json['mobileNumber']),
      email: serializer.fromJson<String?>(json['email']),
      fax: serializer.fromJson<String?>(json['fax']),
      web: serializer.fromJson<String?>(json['web']),
      abn: serializer.fromJson<String?>(json['abn']),
      acn: serializer.fromJson<String?>(json['acn']),
      comment: serializer.fromJson<String?>(json['comment']),
      street: serializer.fromJson<String?>(json['street']),
      city: serializer.fromJson<String?>(json['city']),
      state: serializer.fromJson<String?>(json['state']),
      areaCode: serializer.fromJson<String?>(json['areaCode']),
      postalCode: serializer.fromJson<String?>(json['postalCode']),
      country: serializer.fromJson<String?>(json['country']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String>(lastName),
      'mobileNumber': serializer.toJson<String?>(mobileNumber),
      'email': serializer.toJson<String?>(email),
      'fax': serializer.toJson<String?>(fax),
      'web': serializer.toJson<String?>(web),
      'abn': serializer.toJson<String?>(abn),
      'acn': serializer.toJson<String?>(acn),
      'comment': serializer.toJson<String?>(comment),
      'street': serializer.toJson<String?>(street),
      'city': serializer.toJson<String?>(city),
      'state': serializer.toJson<String?>(state),
      'areaCode': serializer.toJson<String?>(areaCode),
      'postalCode': serializer.toJson<String?>(postalCode),
      'country': serializer.toJson<String?>(country),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Supplier copyWith(
          {String? id,
          String? firstName,
          String? lastName,
          Value<String?> mobileNumber = const Value.absent(),
          Value<String?> email = const Value.absent(),
          Value<String?> fax = const Value.absent(),
          Value<String?> web = const Value.absent(),
          Value<String?> abn = const Value.absent(),
          Value<String?> acn = const Value.absent(),
          Value<String?> comment = const Value.absent(),
          Value<String?> street = const Value.absent(),
          Value<String?> city = const Value.absent(),
          Value<String?> state = const Value.absent(),
          Value<String?> areaCode = const Value.absent(),
          Value<String?> postalCode = const Value.absent(),
          Value<String?> country = const Value.absent(),
          bool? isActive,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Supplier(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        mobileNumber:
            mobileNumber.present ? mobileNumber.value : this.mobileNumber,
        email: email.present ? email.value : this.email,
        fax: fax.present ? fax.value : this.fax,
        web: web.present ? web.value : this.web,
        abn: abn.present ? abn.value : this.abn,
        acn: acn.present ? acn.value : this.acn,
        comment: comment.present ? comment.value : this.comment,
        street: street.present ? street.value : this.street,
        city: city.present ? city.value : this.city,
        state: state.present ? state.value : this.state,
        areaCode: areaCode.present ? areaCode.value : this.areaCode,
        postalCode: postalCode.present ? postalCode.value : this.postalCode,
        country: country.present ? country.value : this.country,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Supplier copyWithCompanion(SuppliersCompanion data) {
    return Supplier(
      id: data.id.present ? data.id.value : this.id,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      mobileNumber: data.mobileNumber.present
          ? data.mobileNumber.value
          : this.mobileNumber,
      email: data.email.present ? data.email.value : this.email,
      fax: data.fax.present ? data.fax.value : this.fax,
      web: data.web.present ? data.web.value : this.web,
      abn: data.abn.present ? data.abn.value : this.abn,
      acn: data.acn.present ? data.acn.value : this.acn,
      comment: data.comment.present ? data.comment.value : this.comment,
      street: data.street.present ? data.street.value : this.street,
      city: data.city.present ? data.city.value : this.city,
      state: data.state.present ? data.state.value : this.state,
      areaCode: data.areaCode.present ? data.areaCode.value : this.areaCode,
      postalCode:
          data.postalCode.present ? data.postalCode.value : this.postalCode,
      country: data.country.present ? data.country.value : this.country,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Supplier(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('mobileNumber: $mobileNumber, ')
          ..write('email: $email, ')
          ..write('fax: $fax, ')
          ..write('web: $web, ')
          ..write('abn: $abn, ')
          ..write('acn: $acn, ')
          ..write('comment: $comment, ')
          ..write('street: $street, ')
          ..write('city: $city, ')
          ..write('state: $state, ')
          ..write('areaCode: $areaCode, ')
          ..write('postalCode: $postalCode, ')
          ..write('country: $country, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      firstName,
      lastName,
      mobileNumber,
      email,
      fax,
      web,
      abn,
      acn,
      comment,
      street,
      city,
      state,
      areaCode,
      postalCode,
      country,
      isActive,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Supplier &&
          other.id == this.id &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.mobileNumber == this.mobileNumber &&
          other.email == this.email &&
          other.fax == this.fax &&
          other.web == this.web &&
          other.abn == this.abn &&
          other.acn == this.acn &&
          other.comment == this.comment &&
          other.street == this.street &&
          other.city == this.city &&
          other.state == this.state &&
          other.areaCode == this.areaCode &&
          other.postalCode == this.postalCode &&
          other.country == this.country &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SuppliersCompanion extends UpdateCompanion<Supplier> {
  final Value<String> id;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<String?> mobileNumber;
  final Value<String?> email;
  final Value<String?> fax;
  final Value<String?> web;
  final Value<String?> abn;
  final Value<String?> acn;
  final Value<String?> comment;
  final Value<String?> street;
  final Value<String?> city;
  final Value<String?> state;
  final Value<String?> areaCode;
  final Value<String?> postalCode;
  final Value<String?> country;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SuppliersCompanion({
    this.id = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.mobileNumber = const Value.absent(),
    this.email = const Value.absent(),
    this.fax = const Value.absent(),
    this.web = const Value.absent(),
    this.abn = const Value.absent(),
    this.acn = const Value.absent(),
    this.comment = const Value.absent(),
    this.street = const Value.absent(),
    this.city = const Value.absent(),
    this.state = const Value.absent(),
    this.areaCode = const Value.absent(),
    this.postalCode = const Value.absent(),
    this.country = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SuppliersCompanion.insert({
    required String id,
    required String firstName,
    required String lastName,
    this.mobileNumber = const Value.absent(),
    this.email = const Value.absent(),
    this.fax = const Value.absent(),
    this.web = const Value.absent(),
    this.abn = const Value.absent(),
    this.acn = const Value.absent(),
    this.comment = const Value.absent(),
    this.street = const Value.absent(),
    this.city = const Value.absent(),
    this.state = const Value.absent(),
    this.areaCode = const Value.absent(),
    this.postalCode = const Value.absent(),
    this.country = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        firstName = Value(firstName),
        lastName = Value(lastName);
  static Insertable<Supplier> custom({
    Expression<String>? id,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<String>? mobileNumber,
    Expression<String>? email,
    Expression<String>? fax,
    Expression<String>? web,
    Expression<String>? abn,
    Expression<String>? acn,
    Expression<String>? comment,
    Expression<String>? street,
    Expression<String>? city,
    Expression<String>? state,
    Expression<String>? areaCode,
    Expression<String>? postalCode,
    Expression<String>? country,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (mobileNumber != null) 'mobile_number': mobileNumber,
      if (email != null) 'email': email,
      if (fax != null) 'fax': fax,
      if (web != null) 'web': web,
      if (abn != null) 'abn': abn,
      if (acn != null) 'acn': acn,
      if (comment != null) 'comment': comment,
      if (street != null) 'street': street,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (areaCode != null) 'area_code': areaCode,
      if (postalCode != null) 'postal_code': postalCode,
      if (country != null) 'country': country,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SuppliersCompanion copyWith(
      {Value<String>? id,
      Value<String>? firstName,
      Value<String>? lastName,
      Value<String?>? mobileNumber,
      Value<String?>? email,
      Value<String?>? fax,
      Value<String?>? web,
      Value<String?>? abn,
      Value<String?>? acn,
      Value<String?>? comment,
      Value<String?>? street,
      Value<String?>? city,
      Value<String?>? state,
      Value<String?>? areaCode,
      Value<String?>? postalCode,
      Value<String?>? country,
      Value<bool>? isActive,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return SuppliersCompanion(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      email: email ?? this.email,
      fax: fax ?? this.fax,
      web: web ?? this.web,
      abn: abn ?? this.abn,
      acn: acn ?? this.acn,
      comment: comment ?? this.comment,
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      areaCode: areaCode ?? this.areaCode,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (mobileNumber.present) {
      map['mobile_number'] = Variable<String>(mobileNumber.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (fax.present) {
      map['fax'] = Variable<String>(fax.value);
    }
    if (web.present) {
      map['web'] = Variable<String>(web.value);
    }
    if (abn.present) {
      map['abn'] = Variable<String>(abn.value);
    }
    if (acn.present) {
      map['acn'] = Variable<String>(acn.value);
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
    }
    if (street.present) {
      map['street'] = Variable<String>(street.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (areaCode.present) {
      map['area_code'] = Variable<String>(areaCode.value);
    }
    if (postalCode.present) {
      map['postal_code'] = Variable<String>(postalCode.value);
    }
    if (country.present) {
      map['country'] = Variable<String>(country.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SuppliersCompanion(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('mobileNumber: $mobileNumber, ')
          ..write('email: $email, ')
          ..write('fax: $fax, ')
          ..write('web: $web, ')
          ..write('abn: $abn, ')
          ..write('acn: $acn, ')
          ..write('comment: $comment, ')
          ..write('street: $street, ')
          ..write('city: $city, ')
          ..write('state: $state, ')
          ..write('areaCode: $areaCode, ')
          ..write('postalCode: $postalCode, ')
          ..write('country: $country, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SupplierInvoicesTable extends SupplierInvoices
    with TableInfo<$SupplierInvoicesTable, SupplierInvoice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SupplierInvoicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _invoiceIdMeta =
      const VerificationMeta('invoiceId');
  @override
  late final GeneratedColumn<String> invoiceId = GeneratedColumn<String>(
      'invoice_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _supplierIdMeta =
      const VerificationMeta('supplierId');
  @override
  late final GeneratedColumn<String> supplierId = GeneratedColumn<String>(
      'supplier_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES suppliers (id)'));
  static const VerificationMeta _createdDateMeta =
      const VerificationMeta('createdDate');
  @override
  late final GeneratedColumn<DateTime> createdDate = GeneratedColumn<DateTime>(
      'created_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<double> total = GeneratedColumn<double>(
      'total', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _isPaidMeta = const VerificationMeta('isPaid');
  @override
  late final GeneratedColumn<bool> isPaid = GeneratedColumn<bool>(
      'is_paid', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_paid" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _supplierNameMeta =
      const VerificationMeta('supplierName');
  @override
  late final GeneratedColumn<String> supplierName = GeneratedColumn<String>(
      'supplier_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        invoiceId,
        supplierId,
        createdDate,
        total,
        isPaid,
        isDeleted,
        supplierName,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'supplier_invoices';
  @override
  VerificationContext validateIntegrity(Insertable<SupplierInvoice> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('invoice_id')) {
      context.handle(_invoiceIdMeta,
          invoiceId.isAcceptableOrUnknown(data['invoice_id']!, _invoiceIdMeta));
    } else if (isInserting) {
      context.missing(_invoiceIdMeta);
    }
    if (data.containsKey('supplier_id')) {
      context.handle(
          _supplierIdMeta,
          supplierId.isAcceptableOrUnknown(
              data['supplier_id']!, _supplierIdMeta));
    } else if (isInserting) {
      context.missing(_supplierIdMeta);
    }
    if (data.containsKey('created_date')) {
      context.handle(
          _createdDateMeta,
          createdDate.isAcceptableOrUnknown(
              data['created_date']!, _createdDateMeta));
    } else if (isInserting) {
      context.missing(_createdDateMeta);
    }
    if (data.containsKey('total')) {
      context.handle(
          _totalMeta, total.isAcceptableOrUnknown(data['total']!, _totalMeta));
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    if (data.containsKey('is_paid')) {
      context.handle(_isPaidMeta,
          isPaid.isAcceptableOrUnknown(data['is_paid']!, _isPaidMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('supplier_name')) {
      context.handle(
          _supplierNameMeta,
          supplierName.isAcceptableOrUnknown(
              data['supplier_name']!, _supplierNameMeta));
    } else if (isInserting) {
      context.missing(_supplierNameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {invoiceId};
  @override
  SupplierInvoice map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SupplierInvoice(
      invoiceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}invoice_id'])!,
      supplierId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}supplier_id'])!,
      createdDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_date'])!,
      total: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total'])!,
      isPaid: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_paid'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      supplierName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}supplier_name'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SupplierInvoicesTable createAlias(String alias) {
    return $SupplierInvoicesTable(attachedDatabase, alias);
  }
}

class SupplierInvoice extends DataClass implements Insertable<SupplierInvoice> {
  final String invoiceId;
  final String supplierId;
  final DateTime createdDate;
  final double total;
  final bool isPaid;
  final bool isDeleted;
  final String supplierName;
  final DateTime createdAt;
  const SupplierInvoice(
      {required this.invoiceId,
      required this.supplierId,
      required this.createdDate,
      required this.total,
      required this.isPaid,
      required this.isDeleted,
      required this.supplierName,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['invoice_id'] = Variable<String>(invoiceId);
    map['supplier_id'] = Variable<String>(supplierId);
    map['created_date'] = Variable<DateTime>(createdDate);
    map['total'] = Variable<double>(total);
    map['is_paid'] = Variable<bool>(isPaid);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['supplier_name'] = Variable<String>(supplierName);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SupplierInvoicesCompanion toCompanion(bool nullToAbsent) {
    return SupplierInvoicesCompanion(
      invoiceId: Value(invoiceId),
      supplierId: Value(supplierId),
      createdDate: Value(createdDate),
      total: Value(total),
      isPaid: Value(isPaid),
      isDeleted: Value(isDeleted),
      supplierName: Value(supplierName),
      createdAt: Value(createdAt),
    );
  }

  factory SupplierInvoice.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SupplierInvoice(
      invoiceId: serializer.fromJson<String>(json['invoiceId']),
      supplierId: serializer.fromJson<String>(json['supplierId']),
      createdDate: serializer.fromJson<DateTime>(json['createdDate']),
      total: serializer.fromJson<double>(json['total']),
      isPaid: serializer.fromJson<bool>(json['isPaid']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      supplierName: serializer.fromJson<String>(json['supplierName']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'invoiceId': serializer.toJson<String>(invoiceId),
      'supplierId': serializer.toJson<String>(supplierId),
      'createdDate': serializer.toJson<DateTime>(createdDate),
      'total': serializer.toJson<double>(total),
      'isPaid': serializer.toJson<bool>(isPaid),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'supplierName': serializer.toJson<String>(supplierName),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SupplierInvoice copyWith(
          {String? invoiceId,
          String? supplierId,
          DateTime? createdDate,
          double? total,
          bool? isPaid,
          bool? isDeleted,
          String? supplierName,
          DateTime? createdAt}) =>
      SupplierInvoice(
        invoiceId: invoiceId ?? this.invoiceId,
        supplierId: supplierId ?? this.supplierId,
        createdDate: createdDate ?? this.createdDate,
        total: total ?? this.total,
        isPaid: isPaid ?? this.isPaid,
        isDeleted: isDeleted ?? this.isDeleted,
        supplierName: supplierName ?? this.supplierName,
        createdAt: createdAt ?? this.createdAt,
      );
  SupplierInvoice copyWithCompanion(SupplierInvoicesCompanion data) {
    return SupplierInvoice(
      invoiceId: data.invoiceId.present ? data.invoiceId.value : this.invoiceId,
      supplierId:
          data.supplierId.present ? data.supplierId.value : this.supplierId,
      createdDate:
          data.createdDate.present ? data.createdDate.value : this.createdDate,
      total: data.total.present ? data.total.value : this.total,
      isPaid: data.isPaid.present ? data.isPaid.value : this.isPaid,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      supplierName: data.supplierName.present
          ? data.supplierName.value
          : this.supplierName,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SupplierInvoice(')
          ..write('invoiceId: $invoiceId, ')
          ..write('supplierId: $supplierId, ')
          ..write('createdDate: $createdDate, ')
          ..write('total: $total, ')
          ..write('isPaid: $isPaid, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('supplierName: $supplierName, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(invoiceId, supplierId, createdDate, total,
      isPaid, isDeleted, supplierName, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SupplierInvoice &&
          other.invoiceId == this.invoiceId &&
          other.supplierId == this.supplierId &&
          other.createdDate == this.createdDate &&
          other.total == this.total &&
          other.isPaid == this.isPaid &&
          other.isDeleted == this.isDeleted &&
          other.supplierName == this.supplierName &&
          other.createdAt == this.createdAt);
}

class SupplierInvoicesCompanion extends UpdateCompanion<SupplierInvoice> {
  final Value<String> invoiceId;
  final Value<String> supplierId;
  final Value<DateTime> createdDate;
  final Value<double> total;
  final Value<bool> isPaid;
  final Value<bool> isDeleted;
  final Value<String> supplierName;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const SupplierInvoicesCompanion({
    this.invoiceId = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.createdDate = const Value.absent(),
    this.total = const Value.absent(),
    this.isPaid = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.supplierName = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SupplierInvoicesCompanion.insert({
    required String invoiceId,
    required String supplierId,
    required DateTime createdDate,
    required double total,
    this.isPaid = const Value.absent(),
    this.isDeleted = const Value.absent(),
    required String supplierName,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : invoiceId = Value(invoiceId),
        supplierId = Value(supplierId),
        createdDate = Value(createdDate),
        total = Value(total),
        supplierName = Value(supplierName);
  static Insertable<SupplierInvoice> custom({
    Expression<String>? invoiceId,
    Expression<String>? supplierId,
    Expression<DateTime>? createdDate,
    Expression<double>? total,
    Expression<bool>? isPaid,
    Expression<bool>? isDeleted,
    Expression<String>? supplierName,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (invoiceId != null) 'invoice_id': invoiceId,
      if (supplierId != null) 'supplier_id': supplierId,
      if (createdDate != null) 'created_date': createdDate,
      if (total != null) 'total': total,
      if (isPaid != null) 'is_paid': isPaid,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (supplierName != null) 'supplier_name': supplierName,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SupplierInvoicesCompanion copyWith(
      {Value<String>? invoiceId,
      Value<String>? supplierId,
      Value<DateTime>? createdDate,
      Value<double>? total,
      Value<bool>? isPaid,
      Value<bool>? isDeleted,
      Value<String>? supplierName,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return SupplierInvoicesCompanion(
      invoiceId: invoiceId ?? this.invoiceId,
      supplierId: supplierId ?? this.supplierId,
      createdDate: createdDate ?? this.createdDate,
      total: total ?? this.total,
      isPaid: isPaid ?? this.isPaid,
      isDeleted: isDeleted ?? this.isDeleted,
      supplierName: supplierName ?? this.supplierName,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (invoiceId.present) {
      map['invoice_id'] = Variable<String>(invoiceId.value);
    }
    if (supplierId.present) {
      map['supplier_id'] = Variable<String>(supplierId.value);
    }
    if (createdDate.present) {
      map['created_date'] = Variable<DateTime>(createdDate.value);
    }
    if (total.present) {
      map['total'] = Variable<double>(total.value);
    }
    if (isPaid.present) {
      map['is_paid'] = Variable<bool>(isPaid.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (supplierName.present) {
      map['supplier_name'] = Variable<String>(supplierName.value);
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
    return (StringBuffer('SupplierInvoicesCompanion(')
          ..write('invoiceId: $invoiceId, ')
          ..write('supplierId: $supplierId, ')
          ..write('createdDate: $createdDate, ')
          ..write('total: $total, ')
          ..write('isPaid: $isPaid, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('supplierName: $supplierName, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuotationsTable extends Quotations
    with TableInfo<$QuotationsTable, Quotation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuotationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _quotationIdMeta =
      const VerificationMeta('quotationId');
  @override
  late final GeneratedColumn<String> quotationId = GeneratedColumn<String>(
      'quotation_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _customerIdMeta =
      const VerificationMeta('customerId');
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
      'customer_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES customers (id)'));
  static const VerificationMeta _createdDateMeta =
      const VerificationMeta('createdDate');
  @override
  late final GeneratedColumn<DateTime> createdDate = GeneratedColumn<DateTime>(
      'created_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<double> total = GeneratedColumn<double>(
      'total', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _customerNameMeta =
      const VerificationMeta('customerName');
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
      'customer_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _expiryDateMeta =
      const VerificationMeta('expiryDate');
  @override
  late final GeneratedColumn<DateTime> expiryDate = GeneratedColumn<DateTime>(
      'expiry_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        quotationId,
        customerId,
        createdDate,
        total,
        status,
        customerName,
        expiryDate,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quotations';
  @override
  VerificationContext validateIntegrity(Insertable<Quotation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('quotation_id')) {
      context.handle(
          _quotationIdMeta,
          quotationId.isAcceptableOrUnknown(
              data['quotation_id']!, _quotationIdMeta));
    } else if (isInserting) {
      context.missing(_quotationIdMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
          _customerIdMeta,
          customerId.isAcceptableOrUnknown(
              data['customer_id']!, _customerIdMeta));
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('created_date')) {
      context.handle(
          _createdDateMeta,
          createdDate.isAcceptableOrUnknown(
              data['created_date']!, _createdDateMeta));
    } else if (isInserting) {
      context.missing(_createdDateMeta);
    }
    if (data.containsKey('total')) {
      context.handle(
          _totalMeta, total.isAcceptableOrUnknown(data['total']!, _totalMeta));
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('customer_name')) {
      context.handle(
          _customerNameMeta,
          customerName.isAcceptableOrUnknown(
              data['customer_name']!, _customerNameMeta));
    } else if (isInserting) {
      context.missing(_customerNameMeta);
    }
    if (data.containsKey('expiry_date')) {
      context.handle(
          _expiryDateMeta,
          expiryDate.isAcceptableOrUnknown(
              data['expiry_date']!, _expiryDateMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {quotationId};
  @override
  Quotation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Quotation(
      quotationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}quotation_id'])!,
      customerId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_id'])!,
      createdDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_date'])!,
      total: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      customerName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_name'])!,
      expiryDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}expiry_date']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $QuotationsTable createAlias(String alias) {
    return $QuotationsTable(attachedDatabase, alias);
  }
}

class Quotation extends DataClass implements Insertable<Quotation> {
  final String quotationId;
  final String customerId;
  final DateTime createdDate;
  final double total;
  final String status;
  final String customerName;
  final DateTime? expiryDate;
  final DateTime createdAt;
  const Quotation(
      {required this.quotationId,
      required this.customerId,
      required this.createdDate,
      required this.total,
      required this.status,
      required this.customerName,
      this.expiryDate,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['quotation_id'] = Variable<String>(quotationId);
    map['customer_id'] = Variable<String>(customerId);
    map['created_date'] = Variable<DateTime>(createdDate);
    map['total'] = Variable<double>(total);
    map['status'] = Variable<String>(status);
    map['customer_name'] = Variable<String>(customerName);
    if (!nullToAbsent || expiryDate != null) {
      map['expiry_date'] = Variable<DateTime>(expiryDate);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  QuotationsCompanion toCompanion(bool nullToAbsent) {
    return QuotationsCompanion(
      quotationId: Value(quotationId),
      customerId: Value(customerId),
      createdDate: Value(createdDate),
      total: Value(total),
      status: Value(status),
      customerName: Value(customerName),
      expiryDate: expiryDate == null && nullToAbsent
          ? const Value.absent()
          : Value(expiryDate),
      createdAt: Value(createdAt),
    );
  }

  factory Quotation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Quotation(
      quotationId: serializer.fromJson<String>(json['quotationId']),
      customerId: serializer.fromJson<String>(json['customerId']),
      createdDate: serializer.fromJson<DateTime>(json['createdDate']),
      total: serializer.fromJson<double>(json['total']),
      status: serializer.fromJson<String>(json['status']),
      customerName: serializer.fromJson<String>(json['customerName']),
      expiryDate: serializer.fromJson<DateTime?>(json['expiryDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'quotationId': serializer.toJson<String>(quotationId),
      'customerId': serializer.toJson<String>(customerId),
      'createdDate': serializer.toJson<DateTime>(createdDate),
      'total': serializer.toJson<double>(total),
      'status': serializer.toJson<String>(status),
      'customerName': serializer.toJson<String>(customerName),
      'expiryDate': serializer.toJson<DateTime?>(expiryDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Quotation copyWith(
          {String? quotationId,
          String? customerId,
          DateTime? createdDate,
          double? total,
          String? status,
          String? customerName,
          Value<DateTime?> expiryDate = const Value.absent(),
          DateTime? createdAt}) =>
      Quotation(
        quotationId: quotationId ?? this.quotationId,
        customerId: customerId ?? this.customerId,
        createdDate: createdDate ?? this.createdDate,
        total: total ?? this.total,
        status: status ?? this.status,
        customerName: customerName ?? this.customerName,
        expiryDate: expiryDate.present ? expiryDate.value : this.expiryDate,
        createdAt: createdAt ?? this.createdAt,
      );
  Quotation copyWithCompanion(QuotationsCompanion data) {
    return Quotation(
      quotationId:
          data.quotationId.present ? data.quotationId.value : this.quotationId,
      customerId:
          data.customerId.present ? data.customerId.value : this.customerId,
      createdDate:
          data.createdDate.present ? data.createdDate.value : this.createdDate,
      total: data.total.present ? data.total.value : this.total,
      status: data.status.present ? data.status.value : this.status,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      expiryDate:
          data.expiryDate.present ? data.expiryDate.value : this.expiryDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Quotation(')
          ..write('quotationId: $quotationId, ')
          ..write('customerId: $customerId, ')
          ..write('createdDate: $createdDate, ')
          ..write('total: $total, ')
          ..write('status: $status, ')
          ..write('customerName: $customerName, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(quotationId, customerId, createdDate, total,
      status, customerName, expiryDate, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Quotation &&
          other.quotationId == this.quotationId &&
          other.customerId == this.customerId &&
          other.createdDate == this.createdDate &&
          other.total == this.total &&
          other.status == this.status &&
          other.customerName == this.customerName &&
          other.expiryDate == this.expiryDate &&
          other.createdAt == this.createdAt);
}

class QuotationsCompanion extends UpdateCompanion<Quotation> {
  final Value<String> quotationId;
  final Value<String> customerId;
  final Value<DateTime> createdDate;
  final Value<double> total;
  final Value<String> status;
  final Value<String> customerName;
  final Value<DateTime?> expiryDate;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const QuotationsCompanion({
    this.quotationId = const Value.absent(),
    this.customerId = const Value.absent(),
    this.createdDate = const Value.absent(),
    this.total = const Value.absent(),
    this.status = const Value.absent(),
    this.customerName = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuotationsCompanion.insert({
    required String quotationId,
    required String customerId,
    required DateTime createdDate,
    required double total,
    required String status,
    required String customerName,
    this.expiryDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : quotationId = Value(quotationId),
        customerId = Value(customerId),
        createdDate = Value(createdDate),
        total = Value(total),
        status = Value(status),
        customerName = Value(customerName);
  static Insertable<Quotation> custom({
    Expression<String>? quotationId,
    Expression<String>? customerId,
    Expression<DateTime>? createdDate,
    Expression<double>? total,
    Expression<String>? status,
    Expression<String>? customerName,
    Expression<DateTime>? expiryDate,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (quotationId != null) 'quotation_id': quotationId,
      if (customerId != null) 'customer_id': customerId,
      if (createdDate != null) 'created_date': createdDate,
      if (total != null) 'total': total,
      if (status != null) 'status': status,
      if (customerName != null) 'customer_name': customerName,
      if (expiryDate != null) 'expiry_date': expiryDate,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuotationsCompanion copyWith(
      {Value<String>? quotationId,
      Value<String>? customerId,
      Value<DateTime>? createdDate,
      Value<double>? total,
      Value<String>? status,
      Value<String>? customerName,
      Value<DateTime?>? expiryDate,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return QuotationsCompanion(
      quotationId: quotationId ?? this.quotationId,
      customerId: customerId ?? this.customerId,
      createdDate: createdDate ?? this.createdDate,
      total: total ?? this.total,
      status: status ?? this.status,
      customerName: customerName ?? this.customerName,
      expiryDate: expiryDate ?? this.expiryDate,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (quotationId.present) {
      map['quotation_id'] = Variable<String>(quotationId.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (createdDate.present) {
      map['created_date'] = Variable<DateTime>(createdDate.value);
    }
    if (total.present) {
      map['total'] = Variable<double>(total.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (expiryDate.present) {
      map['expiry_date'] = Variable<DateTime>(expiryDate.value);
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
    return (StringBuffer('QuotationsCompanion(')
          ..write('quotationId: $quotationId, ')
          ..write('customerId: $customerId, ')
          ..write('createdDate: $createdDate, ')
          ..write('total: $total, ')
          ..write('status: $status, ')
          ..write('customerName: $customerName, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CreditNotesTable extends CreditNotes
    with TableInfo<$CreditNotesTable, CreditNote> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CreditNotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _creditNoteIdMeta =
      const VerificationMeta('creditNoteId');
  @override
  late final GeneratedColumn<String> creditNoteId = GeneratedColumn<String>(
      'credit_note_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _invoiceIdMeta =
      const VerificationMeta('invoiceId');
  @override
  late final GeneratedColumn<String> invoiceId = GeneratedColumn<String>(
      'invoice_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES invoices (invoice_id)'));
  static const VerificationMeta _customerIdMeta =
      const VerificationMeta('customerId');
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
      'customer_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES customers (id)'));
  static const VerificationMeta _createdDateMeta =
      const VerificationMeta('createdDate');
  @override
  late final GeneratedColumn<DateTime> createdDate = GeneratedColumn<DateTime>(
      'created_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
      'reason', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _customerNameMeta =
      const VerificationMeta('customerName');
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
      'customer_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        creditNoteId,
        invoiceId,
        customerId,
        createdDate,
        amount,
        reason,
        customerName,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'credit_notes';
  @override
  VerificationContext validateIntegrity(Insertable<CreditNote> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('credit_note_id')) {
      context.handle(
          _creditNoteIdMeta,
          creditNoteId.isAcceptableOrUnknown(
              data['credit_note_id']!, _creditNoteIdMeta));
    } else if (isInserting) {
      context.missing(_creditNoteIdMeta);
    }
    if (data.containsKey('invoice_id')) {
      context.handle(_invoiceIdMeta,
          invoiceId.isAcceptableOrUnknown(data['invoice_id']!, _invoiceIdMeta));
    } else if (isInserting) {
      context.missing(_invoiceIdMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
          _customerIdMeta,
          customerId.isAcceptableOrUnknown(
              data['customer_id']!, _customerIdMeta));
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('created_date')) {
      context.handle(
          _createdDateMeta,
          createdDate.isAcceptableOrUnknown(
              data['created_date']!, _createdDateMeta));
    } else if (isInserting) {
      context.missing(_createdDateMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(_reasonMeta,
          reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta));
    }
    if (data.containsKey('customer_name')) {
      context.handle(
          _customerNameMeta,
          customerName.isAcceptableOrUnknown(
              data['customer_name']!, _customerNameMeta));
    } else if (isInserting) {
      context.missing(_customerNameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {creditNoteId};
  @override
  CreditNote map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CreditNote(
      creditNoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}credit_note_id'])!,
      invoiceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}invoice_id'])!,
      customerId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_id'])!,
      createdDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_date'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      reason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reason']),
      customerName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_name'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $CreditNotesTable createAlias(String alias) {
    return $CreditNotesTable(attachedDatabase, alias);
  }
}

class CreditNote extends DataClass implements Insertable<CreditNote> {
  final String creditNoteId;
  final String invoiceId;
  final String customerId;
  final DateTime createdDate;
  final double amount;
  final String? reason;
  final String customerName;
  final DateTime createdAt;
  const CreditNote(
      {required this.creditNoteId,
      required this.invoiceId,
      required this.customerId,
      required this.createdDate,
      required this.amount,
      this.reason,
      required this.customerName,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['credit_note_id'] = Variable<String>(creditNoteId);
    map['invoice_id'] = Variable<String>(invoiceId);
    map['customer_id'] = Variable<String>(customerId);
    map['created_date'] = Variable<DateTime>(createdDate);
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || reason != null) {
      map['reason'] = Variable<String>(reason);
    }
    map['customer_name'] = Variable<String>(customerName);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CreditNotesCompanion toCompanion(bool nullToAbsent) {
    return CreditNotesCompanion(
      creditNoteId: Value(creditNoteId),
      invoiceId: Value(invoiceId),
      customerId: Value(customerId),
      createdDate: Value(createdDate),
      amount: Value(amount),
      reason:
          reason == null && nullToAbsent ? const Value.absent() : Value(reason),
      customerName: Value(customerName),
      createdAt: Value(createdAt),
    );
  }

  factory CreditNote.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CreditNote(
      creditNoteId: serializer.fromJson<String>(json['creditNoteId']),
      invoiceId: serializer.fromJson<String>(json['invoiceId']),
      customerId: serializer.fromJson<String>(json['customerId']),
      createdDate: serializer.fromJson<DateTime>(json['createdDate']),
      amount: serializer.fromJson<double>(json['amount']),
      reason: serializer.fromJson<String?>(json['reason']),
      customerName: serializer.fromJson<String>(json['customerName']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'creditNoteId': serializer.toJson<String>(creditNoteId),
      'invoiceId': serializer.toJson<String>(invoiceId),
      'customerId': serializer.toJson<String>(customerId),
      'createdDate': serializer.toJson<DateTime>(createdDate),
      'amount': serializer.toJson<double>(amount),
      'reason': serializer.toJson<String?>(reason),
      'customerName': serializer.toJson<String>(customerName),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CreditNote copyWith(
          {String? creditNoteId,
          String? invoiceId,
          String? customerId,
          DateTime? createdDate,
          double? amount,
          Value<String?> reason = const Value.absent(),
          String? customerName,
          DateTime? createdAt}) =>
      CreditNote(
        creditNoteId: creditNoteId ?? this.creditNoteId,
        invoiceId: invoiceId ?? this.invoiceId,
        customerId: customerId ?? this.customerId,
        createdDate: createdDate ?? this.createdDate,
        amount: amount ?? this.amount,
        reason: reason.present ? reason.value : this.reason,
        customerName: customerName ?? this.customerName,
        createdAt: createdAt ?? this.createdAt,
      );
  CreditNote copyWithCompanion(CreditNotesCompanion data) {
    return CreditNote(
      creditNoteId: data.creditNoteId.present
          ? data.creditNoteId.value
          : this.creditNoteId,
      invoiceId: data.invoiceId.present ? data.invoiceId.value : this.invoiceId,
      customerId:
          data.customerId.present ? data.customerId.value : this.customerId,
      createdDate:
          data.createdDate.present ? data.createdDate.value : this.createdDate,
      amount: data.amount.present ? data.amount.value : this.amount,
      reason: data.reason.present ? data.reason.value : this.reason,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CreditNote(')
          ..write('creditNoteId: $creditNoteId, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('customerId: $customerId, ')
          ..write('createdDate: $createdDate, ')
          ..write('amount: $amount, ')
          ..write('reason: $reason, ')
          ..write('customerName: $customerName, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(creditNoteId, invoiceId, customerId,
      createdDate, amount, reason, customerName, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CreditNote &&
          other.creditNoteId == this.creditNoteId &&
          other.invoiceId == this.invoiceId &&
          other.customerId == this.customerId &&
          other.createdDate == this.createdDate &&
          other.amount == this.amount &&
          other.reason == this.reason &&
          other.customerName == this.customerName &&
          other.createdAt == this.createdAt);
}

class CreditNotesCompanion extends UpdateCompanion<CreditNote> {
  final Value<String> creditNoteId;
  final Value<String> invoiceId;
  final Value<String> customerId;
  final Value<DateTime> createdDate;
  final Value<double> amount;
  final Value<String?> reason;
  final Value<String> customerName;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CreditNotesCompanion({
    this.creditNoteId = const Value.absent(),
    this.invoiceId = const Value.absent(),
    this.customerId = const Value.absent(),
    this.createdDate = const Value.absent(),
    this.amount = const Value.absent(),
    this.reason = const Value.absent(),
    this.customerName = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CreditNotesCompanion.insert({
    required String creditNoteId,
    required String invoiceId,
    required String customerId,
    required DateTime createdDate,
    required double amount,
    this.reason = const Value.absent(),
    required String customerName,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : creditNoteId = Value(creditNoteId),
        invoiceId = Value(invoiceId),
        customerId = Value(customerId),
        createdDate = Value(createdDate),
        amount = Value(amount),
        customerName = Value(customerName);
  static Insertable<CreditNote> custom({
    Expression<String>? creditNoteId,
    Expression<String>? invoiceId,
    Expression<String>? customerId,
    Expression<DateTime>? createdDate,
    Expression<double>? amount,
    Expression<String>? reason,
    Expression<String>? customerName,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (creditNoteId != null) 'credit_note_id': creditNoteId,
      if (invoiceId != null) 'invoice_id': invoiceId,
      if (customerId != null) 'customer_id': customerId,
      if (createdDate != null) 'created_date': createdDate,
      if (amount != null) 'amount': amount,
      if (reason != null) 'reason': reason,
      if (customerName != null) 'customer_name': customerName,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CreditNotesCompanion copyWith(
      {Value<String>? creditNoteId,
      Value<String>? invoiceId,
      Value<String>? customerId,
      Value<DateTime>? createdDate,
      Value<double>? amount,
      Value<String?>? reason,
      Value<String>? customerName,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return CreditNotesCompanion(
      creditNoteId: creditNoteId ?? this.creditNoteId,
      invoiceId: invoiceId ?? this.invoiceId,
      customerId: customerId ?? this.customerId,
      createdDate: createdDate ?? this.createdDate,
      amount: amount ?? this.amount,
      reason: reason ?? this.reason,
      customerName: customerName ?? this.customerName,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (creditNoteId.present) {
      map['credit_note_id'] = Variable<String>(creditNoteId.value);
    }
    if (invoiceId.present) {
      map['invoice_id'] = Variable<String>(invoiceId.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (createdDate.present) {
      map['created_date'] = Variable<DateTime>(createdDate.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
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
    return (StringBuffer('CreditNotesCompanion(')
          ..write('creditNoteId: $creditNoteId, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('customerId: $customerId, ')
          ..write('createdDate: $createdDate, ')
          ..write('amount: $amount, ')
          ..write('reason: $reason, ')
          ..write('customerName: $customerName, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$POSDatabase extends GeneratedDatabase {
  _$POSDatabase(QueryExecutor e) : super(e);
  $POSDatabaseManager get managers => $POSDatabaseManager(this);
  late final $CustomersTable customers = $CustomersTable(this);
  late final $ItemsTable items = $ItemsTable(this);
  late final $InvoicesTable invoices = $InvoicesTable(this);
  late final $InvoiceItemsTable invoiceItems = $InvoiceItemsTable(this);
  late final $PaymentsTable payments = $PaymentsTable(this);
  late final $ExtraChargesTable extraCharges = $ExtraChargesTable(this);
  late final $SuppliersTable suppliers = $SuppliersTable(this);
  late final $SupplierInvoicesTable supplierInvoices =
      $SupplierInvoicesTable(this);
  late final $QuotationsTable quotations = $QuotationsTable(this);
  late final $CreditNotesTable creditNotes = $CreditNotesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        customers,
        items,
        invoices,
        invoiceItems,
        payments,
        extraCharges,
        suppliers,
        supplierInvoices,
        quotations,
        creditNotes
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('invoices',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('invoice_items', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('invoices',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('payments', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('invoices',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('extra_charges', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$CustomersTableCreateCompanionBuilder = CustomersCompanion Function({
  required String id,
  required String firstName,
  required String lastName,
  Value<String?> email,
  Value<String?> mobileNumber,
  Value<String?> fax,
  Value<String?> web,
  Value<String?> abn,
  Value<String?> acn,
  Value<String?> comment,
  Value<String?> billingStreet,
  Value<String?> billingCity,
  Value<String?> billingState,
  Value<String?> billingAreaCode,
  Value<String?> billingPostalCode,
  Value<String?> billingCountry,
  Value<String?> postalStreet,
  Value<String?> postalCity,
  Value<String?> postalState,
  Value<String?> postalAreaCode,
  Value<String?> postalPostalCode,
  Value<String?> postalCountry,
  Value<String?> encryptedData,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$CustomersTableUpdateCompanionBuilder = CustomersCompanion Function({
  Value<String> id,
  Value<String> firstName,
  Value<String> lastName,
  Value<String?> email,
  Value<String?> mobileNumber,
  Value<String?> fax,
  Value<String?> web,
  Value<String?> abn,
  Value<String?> acn,
  Value<String?> comment,
  Value<String?> billingStreet,
  Value<String?> billingCity,
  Value<String?> billingState,
  Value<String?> billingAreaCode,
  Value<String?> billingPostalCode,
  Value<String?> billingCountry,
  Value<String?> postalStreet,
  Value<String?> postalCity,
  Value<String?> postalState,
  Value<String?> postalAreaCode,
  Value<String?> postalPostalCode,
  Value<String?> postalCountry,
  Value<String?> encryptedData,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$CustomersTableReferences
    extends BaseReferences<_$POSDatabase, $CustomersTable, Customer> {
  $$CustomersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$InvoicesTable, List<Invoice>> _invoicesRefsTable(
          _$POSDatabase db) =>
      MultiTypedResultKey.fromTable(db.invoices,
          aliasName:
              $_aliasNameGenerator(db.customers.id, db.invoices.customerId));

  $$InvoicesTableProcessedTableManager get invoicesRefs {
    final manager = $$InvoicesTableTableManager($_db, $_db.invoices)
        .filter((f) => f.customerId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_invoicesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$QuotationsTable, List<Quotation>>
      _quotationsRefsTable(_$POSDatabase db) => MultiTypedResultKey.fromTable(
          db.quotations,
          aliasName:
              $_aliasNameGenerator(db.customers.id, db.quotations.customerId));

  $$QuotationsTableProcessedTableManager get quotationsRefs {
    final manager = $$QuotationsTableTableManager($_db, $_db.quotations)
        .filter((f) => f.customerId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_quotationsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$CreditNotesTable, List<CreditNote>>
      _creditNotesRefsTable(_$POSDatabase db) => MultiTypedResultKey.fromTable(
          db.creditNotes,
          aliasName:
              $_aliasNameGenerator(db.customers.id, db.creditNotes.customerId));

  $$CreditNotesTableProcessedTableManager get creditNotesRefs {
    final manager = $$CreditNotesTableTableManager($_db, $_db.creditNotes)
        .filter((f) => f.customerId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_creditNotesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CustomersTableFilterComposer
    extends Composer<_$POSDatabase, $CustomersTable> {
  $$CustomersTableFilterComposer({
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

  ColumnFilters<String> get lastName => $composableBuilder(
      column: $table.lastName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mobileNumber => $composableBuilder(
      column: $table.mobileNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fax => $composableBuilder(
      column: $table.fax, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get web => $composableBuilder(
      column: $table.web, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get abn => $composableBuilder(
      column: $table.abn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get acn => $composableBuilder(
      column: $table.acn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get comment => $composableBuilder(
      column: $table.comment, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get billingStreet => $composableBuilder(
      column: $table.billingStreet, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get billingCity => $composableBuilder(
      column: $table.billingCity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get billingState => $composableBuilder(
      column: $table.billingState, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get billingAreaCode => $composableBuilder(
      column: $table.billingAreaCode,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get billingPostalCode => $composableBuilder(
      column: $table.billingPostalCode,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get billingCountry => $composableBuilder(
      column: $table.billingCountry,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get postalStreet => $composableBuilder(
      column: $table.postalStreet, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get postalCity => $composableBuilder(
      column: $table.postalCity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get postalState => $composableBuilder(
      column: $table.postalState, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get postalAreaCode => $composableBuilder(
      column: $table.postalAreaCode,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get postalPostalCode => $composableBuilder(
      column: $table.postalPostalCode,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get postalCountry => $composableBuilder(
      column: $table.postalCountry, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get encryptedData => $composableBuilder(
      column: $table.encryptedData, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> invoicesRefs(
      Expression<bool> Function($$InvoicesTableFilterComposer f) f) {
    final $$InvoicesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.invoices,
        getReferencedColumn: (t) => t.customerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InvoicesTableFilterComposer(
              $db: $db,
              $table: $db.invoices,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> quotationsRefs(
      Expression<bool> Function($$QuotationsTableFilterComposer f) f) {
    final $$QuotationsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.quotations,
        getReferencedColumn: (t) => t.customerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$QuotationsTableFilterComposer(
              $db: $db,
              $table: $db.quotations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> creditNotesRefs(
      Expression<bool> Function($$CreditNotesTableFilterComposer f) f) {
    final $$CreditNotesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.creditNotes,
        getReferencedColumn: (t) => t.customerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CreditNotesTableFilterComposer(
              $db: $db,
              $table: $db.creditNotes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CustomersTableOrderingComposer
    extends Composer<_$POSDatabase, $CustomersTable> {
  $$CustomersTableOrderingComposer({
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

  ColumnOrderings<String> get lastName => $composableBuilder(
      column: $table.lastName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mobileNumber => $composableBuilder(
      column: $table.mobileNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fax => $composableBuilder(
      column: $table.fax, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get web => $composableBuilder(
      column: $table.web, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get abn => $composableBuilder(
      column: $table.abn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get acn => $composableBuilder(
      column: $table.acn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get comment => $composableBuilder(
      column: $table.comment, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get billingStreet => $composableBuilder(
      column: $table.billingStreet,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get billingCity => $composableBuilder(
      column: $table.billingCity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get billingState => $composableBuilder(
      column: $table.billingState,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get billingAreaCode => $composableBuilder(
      column: $table.billingAreaCode,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get billingPostalCode => $composableBuilder(
      column: $table.billingPostalCode,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get billingCountry => $composableBuilder(
      column: $table.billingCountry,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get postalStreet => $composableBuilder(
      column: $table.postalStreet,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get postalCity => $composableBuilder(
      column: $table.postalCity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get postalState => $composableBuilder(
      column: $table.postalState, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get postalAreaCode => $composableBuilder(
      column: $table.postalAreaCode,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get postalPostalCode => $composableBuilder(
      column: $table.postalPostalCode,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get postalCountry => $composableBuilder(
      column: $table.postalCountry,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get encryptedData => $composableBuilder(
      column: $table.encryptedData,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$CustomersTableAnnotationComposer
    extends Composer<_$POSDatabase, $CustomersTable> {
  $$CustomersTableAnnotationComposer({
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

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get mobileNumber => $composableBuilder(
      column: $table.mobileNumber, builder: (column) => column);

  GeneratedColumn<String> get fax =>
      $composableBuilder(column: $table.fax, builder: (column) => column);

  GeneratedColumn<String> get web =>
      $composableBuilder(column: $table.web, builder: (column) => column);

  GeneratedColumn<String> get abn =>
      $composableBuilder(column: $table.abn, builder: (column) => column);

  GeneratedColumn<String> get acn =>
      $composableBuilder(column: $table.acn, builder: (column) => column);

  GeneratedColumn<String> get comment =>
      $composableBuilder(column: $table.comment, builder: (column) => column);

  GeneratedColumn<String> get billingStreet => $composableBuilder(
      column: $table.billingStreet, builder: (column) => column);

  GeneratedColumn<String> get billingCity => $composableBuilder(
      column: $table.billingCity, builder: (column) => column);

  GeneratedColumn<String> get billingState => $composableBuilder(
      column: $table.billingState, builder: (column) => column);

  GeneratedColumn<String> get billingAreaCode => $composableBuilder(
      column: $table.billingAreaCode, builder: (column) => column);

  GeneratedColumn<String> get billingPostalCode => $composableBuilder(
      column: $table.billingPostalCode, builder: (column) => column);

  GeneratedColumn<String> get billingCountry => $composableBuilder(
      column: $table.billingCountry, builder: (column) => column);

  GeneratedColumn<String> get postalStreet => $composableBuilder(
      column: $table.postalStreet, builder: (column) => column);

  GeneratedColumn<String> get postalCity => $composableBuilder(
      column: $table.postalCity, builder: (column) => column);

  GeneratedColumn<String> get postalState => $composableBuilder(
      column: $table.postalState, builder: (column) => column);

  GeneratedColumn<String> get postalAreaCode => $composableBuilder(
      column: $table.postalAreaCode, builder: (column) => column);

  GeneratedColumn<String> get postalPostalCode => $composableBuilder(
      column: $table.postalPostalCode, builder: (column) => column);

  GeneratedColumn<String> get postalCountry => $composableBuilder(
      column: $table.postalCountry, builder: (column) => column);

  GeneratedColumn<String> get encryptedData => $composableBuilder(
      column: $table.encryptedData, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> invoicesRefs<T extends Object>(
      Expression<T> Function($$InvoicesTableAnnotationComposer a) f) {
    final $$InvoicesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.invoices,
        getReferencedColumn: (t) => t.customerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InvoicesTableAnnotationComposer(
              $db: $db,
              $table: $db.invoices,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> quotationsRefs<T extends Object>(
      Expression<T> Function($$QuotationsTableAnnotationComposer a) f) {
    final $$QuotationsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.quotations,
        getReferencedColumn: (t) => t.customerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$QuotationsTableAnnotationComposer(
              $db: $db,
              $table: $db.quotations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> creditNotesRefs<T extends Object>(
      Expression<T> Function($$CreditNotesTableAnnotationComposer a) f) {
    final $$CreditNotesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.creditNotes,
        getReferencedColumn: (t) => t.customerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CreditNotesTableAnnotationComposer(
              $db: $db,
              $table: $db.creditNotes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CustomersTableTableManager extends RootTableManager<
    _$POSDatabase,
    $CustomersTable,
    Customer,
    $$CustomersTableFilterComposer,
    $$CustomersTableOrderingComposer,
    $$CustomersTableAnnotationComposer,
    $$CustomersTableCreateCompanionBuilder,
    $$CustomersTableUpdateCompanionBuilder,
    (Customer, $$CustomersTableReferences),
    Customer,
    PrefetchHooks Function(
        {bool invoicesRefs, bool quotationsRefs, bool creditNotesRefs})> {
  $$CustomersTableTableManager(_$POSDatabase db, $CustomersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> firstName = const Value.absent(),
            Value<String> lastName = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> mobileNumber = const Value.absent(),
            Value<String?> fax = const Value.absent(),
            Value<String?> web = const Value.absent(),
            Value<String?> abn = const Value.absent(),
            Value<String?> acn = const Value.absent(),
            Value<String?> comment = const Value.absent(),
            Value<String?> billingStreet = const Value.absent(),
            Value<String?> billingCity = const Value.absent(),
            Value<String?> billingState = const Value.absent(),
            Value<String?> billingAreaCode = const Value.absent(),
            Value<String?> billingPostalCode = const Value.absent(),
            Value<String?> billingCountry = const Value.absent(),
            Value<String?> postalStreet = const Value.absent(),
            Value<String?> postalCity = const Value.absent(),
            Value<String?> postalState = const Value.absent(),
            Value<String?> postalAreaCode = const Value.absent(),
            Value<String?> postalPostalCode = const Value.absent(),
            Value<String?> postalCountry = const Value.absent(),
            Value<String?> encryptedData = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CustomersCompanion(
            id: id,
            firstName: firstName,
            lastName: lastName,
            email: email,
            mobileNumber: mobileNumber,
            fax: fax,
            web: web,
            abn: abn,
            acn: acn,
            comment: comment,
            billingStreet: billingStreet,
            billingCity: billingCity,
            billingState: billingState,
            billingAreaCode: billingAreaCode,
            billingPostalCode: billingPostalCode,
            billingCountry: billingCountry,
            postalStreet: postalStreet,
            postalCity: postalCity,
            postalState: postalState,
            postalAreaCode: postalAreaCode,
            postalPostalCode: postalPostalCode,
            postalCountry: postalCountry,
            encryptedData: encryptedData,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String firstName,
            required String lastName,
            Value<String?> email = const Value.absent(),
            Value<String?> mobileNumber = const Value.absent(),
            Value<String?> fax = const Value.absent(),
            Value<String?> web = const Value.absent(),
            Value<String?> abn = const Value.absent(),
            Value<String?> acn = const Value.absent(),
            Value<String?> comment = const Value.absent(),
            Value<String?> billingStreet = const Value.absent(),
            Value<String?> billingCity = const Value.absent(),
            Value<String?> billingState = const Value.absent(),
            Value<String?> billingAreaCode = const Value.absent(),
            Value<String?> billingPostalCode = const Value.absent(),
            Value<String?> billingCountry = const Value.absent(),
            Value<String?> postalStreet = const Value.absent(),
            Value<String?> postalCity = const Value.absent(),
            Value<String?> postalState = const Value.absent(),
            Value<String?> postalAreaCode = const Value.absent(),
            Value<String?> postalPostalCode = const Value.absent(),
            Value<String?> postalCountry = const Value.absent(),
            Value<String?> encryptedData = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CustomersCompanion.insert(
            id: id,
            firstName: firstName,
            lastName: lastName,
            email: email,
            mobileNumber: mobileNumber,
            fax: fax,
            web: web,
            abn: abn,
            acn: acn,
            comment: comment,
            billingStreet: billingStreet,
            billingCity: billingCity,
            billingState: billingState,
            billingAreaCode: billingAreaCode,
            billingPostalCode: billingPostalCode,
            billingCountry: billingCountry,
            postalStreet: postalStreet,
            postalCity: postalCity,
            postalState: postalState,
            postalAreaCode: postalAreaCode,
            postalPostalCode: postalPostalCode,
            postalCountry: postalCountry,
            encryptedData: encryptedData,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CustomersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {invoicesRefs = false,
              quotationsRefs = false,
              creditNotesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (invoicesRefs) db.invoices,
                if (quotationsRefs) db.quotations,
                if (creditNotesRefs) db.creditNotes
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (invoicesRefs)
                    await $_getPrefetchedData<Customer, $CustomersTable,
                            Invoice>(
                        currentTable: table,
                        referencedTable:
                            $$CustomersTableReferences._invoicesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CustomersTableReferences(db, table, p0)
                                .invoicesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.customerId == item.id),
                        typedResults: items),
                  if (quotationsRefs)
                    await $_getPrefetchedData<Customer, $CustomersTable,
                            Quotation>(
                        currentTable: table,
                        referencedTable:
                            $$CustomersTableReferences._quotationsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CustomersTableReferences(db, table, p0)
                                .quotationsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.customerId == item.id),
                        typedResults: items),
                  if (creditNotesRefs)
                    await $_getPrefetchedData<Customer, $CustomersTable,
                            CreditNote>(
                        currentTable: table,
                        referencedTable: $$CustomersTableReferences
                            ._creditNotesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CustomersTableReferences(db, table, p0)
                                .creditNotesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.customerId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CustomersTableProcessedTableManager = ProcessedTableManager<
    _$POSDatabase,
    $CustomersTable,
    Customer,
    $$CustomersTableFilterComposer,
    $$CustomersTableOrderingComposer,
    $$CustomersTableAnnotationComposer,
    $$CustomersTableCreateCompanionBuilder,
    $$CustomersTableUpdateCompanionBuilder,
    (Customer, $$CustomersTableReferences),
    Customer,
    PrefetchHooks Function(
        {bool invoicesRefs, bool quotationsRefs, bool creditNotesRefs})>;
typedef $$ItemsTableCreateCompanionBuilder = ItemsCompanion Function({
  required String id,
  required String name,
  Value<String?> description,
  required String itemCode,
  required double price,
  Value<int> quantity,
  Value<String?> category,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$ItemsTableUpdateCompanionBuilder = ItemsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> description,
  Value<String> itemCode,
  Value<double> price,
  Value<int> quantity,
  Value<String?> category,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$ItemsTableReferences
    extends BaseReferences<_$POSDatabase, $ItemsTable, Item> {
  $$ItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$InvoiceItemsTable, List<InvoiceItem>>
      _invoiceItemsRefsTable(_$POSDatabase db) => MultiTypedResultKey.fromTable(
          db.invoiceItems,
          aliasName: $_aliasNameGenerator(db.items.id, db.invoiceItems.itemId));

  $$InvoiceItemsTableProcessedTableManager get invoiceItemsRefs {
    final manager = $$InvoiceItemsTableTableManager($_db, $_db.invoiceItems)
        .filter((f) => f.itemId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_invoiceItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ItemsTableFilterComposer extends Composer<_$POSDatabase, $ItemsTable> {
  $$ItemsTableFilterComposer({
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

  ColumnFilters<String> get itemCode => $composableBuilder(
      column: $table.itemCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> invoiceItemsRefs(
      Expression<bool> Function($$InvoiceItemsTableFilterComposer f) f) {
    final $$InvoiceItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.invoiceItems,
        getReferencedColumn: (t) => t.itemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InvoiceItemsTableFilterComposer(
              $db: $db,
              $table: $db.invoiceItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ItemsTableOrderingComposer
    extends Composer<_$POSDatabase, $ItemsTable> {
  $$ItemsTableOrderingComposer({
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

  ColumnOrderings<String> get itemCode => $composableBuilder(
      column: $table.itemCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ItemsTableAnnotationComposer
    extends Composer<_$POSDatabase, $ItemsTable> {
  $$ItemsTableAnnotationComposer({
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

  GeneratedColumn<String> get itemCode =>
      $composableBuilder(column: $table.itemCode, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> invoiceItemsRefs<T extends Object>(
      Expression<T> Function($$InvoiceItemsTableAnnotationComposer a) f) {
    final $$InvoiceItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.invoiceItems,
        getReferencedColumn: (t) => t.itemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InvoiceItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.invoiceItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ItemsTableTableManager extends RootTableManager<
    _$POSDatabase,
    $ItemsTable,
    Item,
    $$ItemsTableFilterComposer,
    $$ItemsTableOrderingComposer,
    $$ItemsTableAnnotationComposer,
    $$ItemsTableCreateCompanionBuilder,
    $$ItemsTableUpdateCompanionBuilder,
    (Item, $$ItemsTableReferences),
    Item,
    PrefetchHooks Function({bool invoiceItemsRefs})> {
  $$ItemsTableTableManager(_$POSDatabase db, $ItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String> itemCode = const Value.absent(),
            Value<double> price = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<String?> category = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ItemsCompanion(
            id: id,
            name: name,
            description: description,
            itemCode: itemCode,
            price: price,
            quantity: quantity,
            category: category,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> description = const Value.absent(),
            required String itemCode,
            required double price,
            Value<int> quantity = const Value.absent(),
            Value<String?> category = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ItemsCompanion.insert(
            id: id,
            name: name,
            description: description,
            itemCode: itemCode,
            price: price,
            quantity: quantity,
            category: category,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ItemsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({invoiceItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (invoiceItemsRefs) db.invoiceItems],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (invoiceItemsRefs)
                    await $_getPrefetchedData<Item, $ItemsTable, InvoiceItem>(
                        currentTable: table,
                        referencedTable:
                            $$ItemsTableReferences._invoiceItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ItemsTableReferences(db, table, p0)
                                .invoiceItemsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.itemId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ItemsTableProcessedTableManager = ProcessedTableManager<
    _$POSDatabase,
    $ItemsTable,
    Item,
    $$ItemsTableFilterComposer,
    $$ItemsTableOrderingComposer,
    $$ItemsTableAnnotationComposer,
    $$ItemsTableCreateCompanionBuilder,
    $$ItemsTableUpdateCompanionBuilder,
    (Item, $$ItemsTableReferences),
    Item,
    PrefetchHooks Function({bool invoiceItemsRefs})>;
typedef $$InvoicesTableCreateCompanionBuilder = InvoicesCompanion Function({
  required String invoiceId,
  required String customerId,
  required DateTime createdDate,
  Value<DateTime?> closeDate,
  Value<bool> isPaid,
  Value<bool> isDeleted,
  required double totalNet,
  required double totalGst,
  required double total,
  Value<double> paidAmount,
  required double gstPercentage,
  Value<String?> billingAddressJson,
  Value<String?> shippingAddressJson,
  required String customerName,
  Value<String?> customerMobile,
  Value<String?> email,
  Value<String?> commentsJson,
  Value<int> rowid,
});
typedef $$InvoicesTableUpdateCompanionBuilder = InvoicesCompanion Function({
  Value<String> invoiceId,
  Value<String> customerId,
  Value<DateTime> createdDate,
  Value<DateTime?> closeDate,
  Value<bool> isPaid,
  Value<bool> isDeleted,
  Value<double> totalNet,
  Value<double> totalGst,
  Value<double> total,
  Value<double> paidAmount,
  Value<double> gstPercentage,
  Value<String?> billingAddressJson,
  Value<String?> shippingAddressJson,
  Value<String> customerName,
  Value<String?> customerMobile,
  Value<String?> email,
  Value<String?> commentsJson,
  Value<int> rowid,
});

final class $$InvoicesTableReferences
    extends BaseReferences<_$POSDatabase, $InvoicesTable, Invoice> {
  $$InvoicesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CustomersTable _customerIdTable(_$POSDatabase db) =>
      db.customers.createAlias(
          $_aliasNameGenerator(db.invoices.customerId, db.customers.id));

  $$CustomersTableProcessedTableManager get customerId {
    final $_column = $_itemColumn<String>('customer_id')!;

    final manager = $$CustomersTableTableManager($_db, $_db.customers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$InvoiceItemsTable, List<InvoiceItem>>
      _invoiceItemsRefsTable(_$POSDatabase db) =>
          MultiTypedResultKey.fromTable(db.invoiceItems,
              aliasName: $_aliasNameGenerator(
                  db.invoices.invoiceId, db.invoiceItems.invoiceId));

  $$InvoiceItemsTableProcessedTableManager get invoiceItemsRefs {
    final manager = $$InvoiceItemsTableTableManager($_db, $_db.invoiceItems)
        .filter((f) => f.invoiceId.invoiceId
            .sqlEquals($_itemColumn<String>('invoice_id')!));

    final cache = $_typedResult.readTableOrNull(_invoiceItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PaymentsTable, List<Payment>> _paymentsRefsTable(
          _$POSDatabase db) =>
      MultiTypedResultKey.fromTable(db.payments,
          aliasName: $_aliasNameGenerator(
              db.invoices.invoiceId, db.payments.invoiceId));

  $$PaymentsTableProcessedTableManager get paymentsRefs {
    final manager = $$PaymentsTableTableManager($_db, $_db.payments).filter(
        (f) => f.invoiceId.invoiceId
            .sqlEquals($_itemColumn<String>('invoice_id')!));

    final cache = $_typedResult.readTableOrNull(_paymentsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ExtraChargesTable, List<ExtraCharge>>
      _extraChargesRefsTable(_$POSDatabase db) =>
          MultiTypedResultKey.fromTable(db.extraCharges,
              aliasName: $_aliasNameGenerator(
                  db.invoices.invoiceId, db.extraCharges.invoiceId));

  $$ExtraChargesTableProcessedTableManager get extraChargesRefs {
    final manager = $$ExtraChargesTableTableManager($_db, $_db.extraCharges)
        .filter((f) => f.invoiceId.invoiceId
            .sqlEquals($_itemColumn<String>('invoice_id')!));

    final cache = $_typedResult.readTableOrNull(_extraChargesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$CreditNotesTable, List<CreditNote>>
      _creditNotesRefsTable(_$POSDatabase db) =>
          MultiTypedResultKey.fromTable(db.creditNotes,
              aliasName: $_aliasNameGenerator(
                  db.invoices.invoiceId, db.creditNotes.invoiceId));

  $$CreditNotesTableProcessedTableManager get creditNotesRefs {
    final manager = $$CreditNotesTableTableManager($_db, $_db.creditNotes)
        .filter((f) => f.invoiceId.invoiceId
            .sqlEquals($_itemColumn<String>('invoice_id')!));

    final cache = $_typedResult.readTableOrNull(_creditNotesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$InvoicesTableFilterComposer
    extends Composer<_$POSDatabase, $InvoicesTable> {
  $$InvoicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get invoiceId => $composableBuilder(
      column: $table.invoiceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdDate => $composableBuilder(
      column: $table.createdDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get closeDate => $composableBuilder(
      column: $table.closeDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isPaid => $composableBuilder(
      column: $table.isPaid, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalNet => $composableBuilder(
      column: $table.totalNet, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalGst => $composableBuilder(
      column: $table.totalGst, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get total => $composableBuilder(
      column: $table.total, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get paidAmount => $composableBuilder(
      column: $table.paidAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get gstPercentage => $composableBuilder(
      column: $table.gstPercentage, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get billingAddressJson => $composableBuilder(
      column: $table.billingAddressJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get shippingAddressJson => $composableBuilder(
      column: $table.shippingAddressJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customerName => $composableBuilder(
      column: $table.customerName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customerMobile => $composableBuilder(
      column: $table.customerMobile,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get commentsJson => $composableBuilder(
      column: $table.commentsJson, builder: (column) => ColumnFilters(column));

  $$CustomersTableFilterComposer get customerId {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $db.customers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CustomersTableFilterComposer(
              $db: $db,
              $table: $db.customers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> invoiceItemsRefs(
      Expression<bool> Function($$InvoiceItemsTableFilterComposer f) f) {
    final $$InvoiceItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.invoiceId,
        referencedTable: $db.invoiceItems,
        getReferencedColumn: (t) => t.invoiceId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InvoiceItemsTableFilterComposer(
              $db: $db,
              $table: $db.invoiceItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> paymentsRefs(
      Expression<bool> Function($$PaymentsTableFilterComposer f) f) {
    final $$PaymentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.invoiceId,
        referencedTable: $db.payments,
        getReferencedColumn: (t) => t.invoiceId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PaymentsTableFilterComposer(
              $db: $db,
              $table: $db.payments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> extraChargesRefs(
      Expression<bool> Function($$ExtraChargesTableFilterComposer f) f) {
    final $$ExtraChargesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.invoiceId,
        referencedTable: $db.extraCharges,
        getReferencedColumn: (t) => t.invoiceId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExtraChargesTableFilterComposer(
              $db: $db,
              $table: $db.extraCharges,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> creditNotesRefs(
      Expression<bool> Function($$CreditNotesTableFilterComposer f) f) {
    final $$CreditNotesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.invoiceId,
        referencedTable: $db.creditNotes,
        getReferencedColumn: (t) => t.invoiceId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CreditNotesTableFilterComposer(
              $db: $db,
              $table: $db.creditNotes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$InvoicesTableOrderingComposer
    extends Composer<_$POSDatabase, $InvoicesTable> {
  $$InvoicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get invoiceId => $composableBuilder(
      column: $table.invoiceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdDate => $composableBuilder(
      column: $table.createdDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get closeDate => $composableBuilder(
      column: $table.closeDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isPaid => $composableBuilder(
      column: $table.isPaid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalNet => $composableBuilder(
      column: $table.totalNet, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalGst => $composableBuilder(
      column: $table.totalGst, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get total => $composableBuilder(
      column: $table.total, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get paidAmount => $composableBuilder(
      column: $table.paidAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get gstPercentage => $composableBuilder(
      column: $table.gstPercentage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get billingAddressJson => $composableBuilder(
      column: $table.billingAddressJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get shippingAddressJson => $composableBuilder(
      column: $table.shippingAddressJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customerName => $composableBuilder(
      column: $table.customerName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customerMobile => $composableBuilder(
      column: $table.customerMobile,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get commentsJson => $composableBuilder(
      column: $table.commentsJson,
      builder: (column) => ColumnOrderings(column));

  $$CustomersTableOrderingComposer get customerId {
    final $$CustomersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $db.customers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CustomersTableOrderingComposer(
              $db: $db,
              $table: $db.customers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$InvoicesTableAnnotationComposer
    extends Composer<_$POSDatabase, $InvoicesTable> {
  $$InvoicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get invoiceId =>
      $composableBuilder(column: $table.invoiceId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdDate => $composableBuilder(
      column: $table.createdDate, builder: (column) => column);

  GeneratedColumn<DateTime> get closeDate =>
      $composableBuilder(column: $table.closeDate, builder: (column) => column);

  GeneratedColumn<bool> get isPaid =>
      $composableBuilder(column: $table.isPaid, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<double> get totalNet =>
      $composableBuilder(column: $table.totalNet, builder: (column) => column);

  GeneratedColumn<double> get totalGst =>
      $composableBuilder(column: $table.totalGst, builder: (column) => column);

  GeneratedColumn<double> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<double> get paidAmount => $composableBuilder(
      column: $table.paidAmount, builder: (column) => column);

  GeneratedColumn<double> get gstPercentage => $composableBuilder(
      column: $table.gstPercentage, builder: (column) => column);

  GeneratedColumn<String> get billingAddressJson => $composableBuilder(
      column: $table.billingAddressJson, builder: (column) => column);

  GeneratedColumn<String> get shippingAddressJson => $composableBuilder(
      column: $table.shippingAddressJson, builder: (column) => column);

  GeneratedColumn<String> get customerName => $composableBuilder(
      column: $table.customerName, builder: (column) => column);

  GeneratedColumn<String> get customerMobile => $composableBuilder(
      column: $table.customerMobile, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get commentsJson => $composableBuilder(
      column: $table.commentsJson, builder: (column) => column);

  $$CustomersTableAnnotationComposer get customerId {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $db.customers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CustomersTableAnnotationComposer(
              $db: $db,
              $table: $db.customers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> invoiceItemsRefs<T extends Object>(
      Expression<T> Function($$InvoiceItemsTableAnnotationComposer a) f) {
    final $$InvoiceItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.invoiceId,
        referencedTable: $db.invoiceItems,
        getReferencedColumn: (t) => t.invoiceId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InvoiceItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.invoiceItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> paymentsRefs<T extends Object>(
      Expression<T> Function($$PaymentsTableAnnotationComposer a) f) {
    final $$PaymentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.invoiceId,
        referencedTable: $db.payments,
        getReferencedColumn: (t) => t.invoiceId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PaymentsTableAnnotationComposer(
              $db: $db,
              $table: $db.payments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> extraChargesRefs<T extends Object>(
      Expression<T> Function($$ExtraChargesTableAnnotationComposer a) f) {
    final $$ExtraChargesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.invoiceId,
        referencedTable: $db.extraCharges,
        getReferencedColumn: (t) => t.invoiceId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExtraChargesTableAnnotationComposer(
              $db: $db,
              $table: $db.extraCharges,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> creditNotesRefs<T extends Object>(
      Expression<T> Function($$CreditNotesTableAnnotationComposer a) f) {
    final $$CreditNotesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.invoiceId,
        referencedTable: $db.creditNotes,
        getReferencedColumn: (t) => t.invoiceId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CreditNotesTableAnnotationComposer(
              $db: $db,
              $table: $db.creditNotes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$InvoicesTableTableManager extends RootTableManager<
    _$POSDatabase,
    $InvoicesTable,
    Invoice,
    $$InvoicesTableFilterComposer,
    $$InvoicesTableOrderingComposer,
    $$InvoicesTableAnnotationComposer,
    $$InvoicesTableCreateCompanionBuilder,
    $$InvoicesTableUpdateCompanionBuilder,
    (Invoice, $$InvoicesTableReferences),
    Invoice,
    PrefetchHooks Function(
        {bool customerId,
        bool invoiceItemsRefs,
        bool paymentsRefs,
        bool extraChargesRefs,
        bool creditNotesRefs})> {
  $$InvoicesTableTableManager(_$POSDatabase db, $InvoicesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InvoicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InvoicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InvoicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> invoiceId = const Value.absent(),
            Value<String> customerId = const Value.absent(),
            Value<DateTime> createdDate = const Value.absent(),
            Value<DateTime?> closeDate = const Value.absent(),
            Value<bool> isPaid = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<double> totalNet = const Value.absent(),
            Value<double> totalGst = const Value.absent(),
            Value<double> total = const Value.absent(),
            Value<double> paidAmount = const Value.absent(),
            Value<double> gstPercentage = const Value.absent(),
            Value<String?> billingAddressJson = const Value.absent(),
            Value<String?> shippingAddressJson = const Value.absent(),
            Value<String> customerName = const Value.absent(),
            Value<String?> customerMobile = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> commentsJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              InvoicesCompanion(
            invoiceId: invoiceId,
            customerId: customerId,
            createdDate: createdDate,
            closeDate: closeDate,
            isPaid: isPaid,
            isDeleted: isDeleted,
            totalNet: totalNet,
            totalGst: totalGst,
            total: total,
            paidAmount: paidAmount,
            gstPercentage: gstPercentage,
            billingAddressJson: billingAddressJson,
            shippingAddressJson: shippingAddressJson,
            customerName: customerName,
            customerMobile: customerMobile,
            email: email,
            commentsJson: commentsJson,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String invoiceId,
            required String customerId,
            required DateTime createdDate,
            Value<DateTime?> closeDate = const Value.absent(),
            Value<bool> isPaid = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            required double totalNet,
            required double totalGst,
            required double total,
            Value<double> paidAmount = const Value.absent(),
            required double gstPercentage,
            Value<String?> billingAddressJson = const Value.absent(),
            Value<String?> shippingAddressJson = const Value.absent(),
            required String customerName,
            Value<String?> customerMobile = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> commentsJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              InvoicesCompanion.insert(
            invoiceId: invoiceId,
            customerId: customerId,
            createdDate: createdDate,
            closeDate: closeDate,
            isPaid: isPaid,
            isDeleted: isDeleted,
            totalNet: totalNet,
            totalGst: totalGst,
            total: total,
            paidAmount: paidAmount,
            gstPercentage: gstPercentage,
            billingAddressJson: billingAddressJson,
            shippingAddressJson: shippingAddressJson,
            customerName: customerName,
            customerMobile: customerMobile,
            email: email,
            commentsJson: commentsJson,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$InvoicesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {customerId = false,
              invoiceItemsRefs = false,
              paymentsRefs = false,
              extraChargesRefs = false,
              creditNotesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (invoiceItemsRefs) db.invoiceItems,
                if (paymentsRefs) db.payments,
                if (extraChargesRefs) db.extraCharges,
                if (creditNotesRefs) db.creditNotes
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (customerId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.customerId,
                    referencedTable:
                        $$InvoicesTableReferences._customerIdTable(db),
                    referencedColumn:
                        $$InvoicesTableReferences._customerIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (invoiceItemsRefs)
                    await $_getPrefetchedData<Invoice, $InvoicesTable,
                            InvoiceItem>(
                        currentTable: table,
                        referencedTable: $$InvoicesTableReferences
                            ._invoiceItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$InvoicesTableReferences(db, table, p0)
                                .invoiceItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.invoiceId == item.invoiceId),
                        typedResults: items),
                  if (paymentsRefs)
                    await $_getPrefetchedData<Invoice, $InvoicesTable, Payment>(
                        currentTable: table,
                        referencedTable:
                            $$InvoicesTableReferences._paymentsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$InvoicesTableReferences(db, table, p0)
                                .paymentsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.invoiceId == item.invoiceId),
                        typedResults: items),
                  if (extraChargesRefs)
                    await $_getPrefetchedData<Invoice, $InvoicesTable,
                            ExtraCharge>(
                        currentTable: table,
                        referencedTable: $$InvoicesTableReferences
                            ._extraChargesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$InvoicesTableReferences(db, table, p0)
                                .extraChargesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.invoiceId == item.invoiceId),
                        typedResults: items),
                  if (creditNotesRefs)
                    await $_getPrefetchedData<Invoice, $InvoicesTable,
                            CreditNote>(
                        currentTable: table,
                        referencedTable:
                            $$InvoicesTableReferences._creditNotesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$InvoicesTableReferences(db, table, p0)
                                .creditNotesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.invoiceId == item.invoiceId),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$InvoicesTableProcessedTableManager = ProcessedTableManager<
    _$POSDatabase,
    $InvoicesTable,
    Invoice,
    $$InvoicesTableFilterComposer,
    $$InvoicesTableOrderingComposer,
    $$InvoicesTableAnnotationComposer,
    $$InvoicesTableCreateCompanionBuilder,
    $$InvoicesTableUpdateCompanionBuilder,
    (Invoice, $$InvoicesTableReferences),
    Invoice,
    PrefetchHooks Function(
        {bool customerId,
        bool invoiceItemsRefs,
        bool paymentsRefs,
        bool extraChargesRefs,
        bool creditNotesRefs})>;
typedef $$InvoiceItemsTableCreateCompanionBuilder = InvoiceItemsCompanion
    Function({
  Value<int> id,
  required String invoiceId,
  required String itemId,
  required String itemName,
  required int quantity,
  required double netPrice,
  Value<String?> comment,
  Value<bool> isPostedItem,
  Value<DateTime> createdAt,
});
typedef $$InvoiceItemsTableUpdateCompanionBuilder = InvoiceItemsCompanion
    Function({
  Value<int> id,
  Value<String> invoiceId,
  Value<String> itemId,
  Value<String> itemName,
  Value<int> quantity,
  Value<double> netPrice,
  Value<String?> comment,
  Value<bool> isPostedItem,
  Value<DateTime> createdAt,
});

final class $$InvoiceItemsTableReferences
    extends BaseReferences<_$POSDatabase, $InvoiceItemsTable, InvoiceItem> {
  $$InvoiceItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $InvoicesTable _invoiceIdTable(_$POSDatabase db) =>
      db.invoices.createAlias($_aliasNameGenerator(
          db.invoiceItems.invoiceId, db.invoices.invoiceId));

  $$InvoicesTableProcessedTableManager get invoiceId {
    final $_column = $_itemColumn<String>('invoice_id')!;

    final manager = $$InvoicesTableTableManager($_db, $_db.invoices)
        .filter((f) => f.invoiceId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_invoiceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ItemsTable _itemIdTable(_$POSDatabase db) => db.items
      .createAlias($_aliasNameGenerator(db.invoiceItems.itemId, db.items.id));

  $$ItemsTableProcessedTableManager get itemId {
    final $_column = $_itemColumn<String>('item_id')!;

    final manager = $$ItemsTableTableManager($_db, $_db.items)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$InvoiceItemsTableFilterComposer
    extends Composer<_$POSDatabase, $InvoiceItemsTable> {
  $$InvoiceItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemName => $composableBuilder(
      column: $table.itemName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get netPrice => $composableBuilder(
      column: $table.netPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get comment => $composableBuilder(
      column: $table.comment, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isPostedItem => $composableBuilder(
      column: $table.isPostedItem, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$InvoicesTableFilterComposer get invoiceId {
    final $$InvoicesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.invoiceId,
        referencedTable: $db.invoices,
        getReferencedColumn: (t) => t.invoiceId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InvoicesTableFilterComposer(
              $db: $db,
              $table: $db.invoices,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ItemsTableFilterComposer get itemId {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $db.items,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemsTableFilterComposer(
              $db: $db,
              $table: $db.items,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$InvoiceItemsTableOrderingComposer
    extends Composer<_$POSDatabase, $InvoiceItemsTable> {
  $$InvoiceItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemName => $composableBuilder(
      column: $table.itemName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get netPrice => $composableBuilder(
      column: $table.netPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get comment => $composableBuilder(
      column: $table.comment, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isPostedItem => $composableBuilder(
      column: $table.isPostedItem,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$InvoicesTableOrderingComposer get invoiceId {
    final $$InvoicesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.invoiceId,
        referencedTable: $db.invoices,
        getReferencedColumn: (t) => t.invoiceId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InvoicesTableOrderingComposer(
              $db: $db,
              $table: $db.invoices,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ItemsTableOrderingComposer get itemId {
    final $$ItemsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $db.items,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemsTableOrderingComposer(
              $db: $db,
              $table: $db.items,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$InvoiceItemsTableAnnotationComposer
    extends Composer<_$POSDatabase, $InvoiceItemsTable> {
  $$InvoiceItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get itemName =>
      $composableBuilder(column: $table.itemName, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get netPrice =>
      $composableBuilder(column: $table.netPrice, builder: (column) => column);

  GeneratedColumn<String> get comment =>
      $composableBuilder(column: $table.comment, builder: (column) => column);

  GeneratedColumn<bool> get isPostedItem => $composableBuilder(
      column: $table.isPostedItem, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$InvoicesTableAnnotationComposer get invoiceId {
    final $$InvoicesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.invoiceId,
        referencedTable: $db.invoices,
        getReferencedColumn: (t) => t.invoiceId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InvoicesTableAnnotationComposer(
              $db: $db,
              $table: $db.invoices,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ItemsTableAnnotationComposer get itemId {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $db.items,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.items,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$InvoiceItemsTableTableManager extends RootTableManager<
    _$POSDatabase,
    $InvoiceItemsTable,
    InvoiceItem,
    $$InvoiceItemsTableFilterComposer,
    $$InvoiceItemsTableOrderingComposer,
    $$InvoiceItemsTableAnnotationComposer,
    $$InvoiceItemsTableCreateCompanionBuilder,
    $$InvoiceItemsTableUpdateCompanionBuilder,
    (InvoiceItem, $$InvoiceItemsTableReferences),
    InvoiceItem,
    PrefetchHooks Function({bool invoiceId, bool itemId})> {
  $$InvoiceItemsTableTableManager(_$POSDatabase db, $InvoiceItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InvoiceItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InvoiceItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InvoiceItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> invoiceId = const Value.absent(),
            Value<String> itemId = const Value.absent(),
            Value<String> itemName = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<double> netPrice = const Value.absent(),
            Value<String?> comment = const Value.absent(),
            Value<bool> isPostedItem = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              InvoiceItemsCompanion(
            id: id,
            invoiceId: invoiceId,
            itemId: itemId,
            itemName: itemName,
            quantity: quantity,
            netPrice: netPrice,
            comment: comment,
            isPostedItem: isPostedItem,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String invoiceId,
            required String itemId,
            required String itemName,
            required int quantity,
            required double netPrice,
            Value<String?> comment = const Value.absent(),
            Value<bool> isPostedItem = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              InvoiceItemsCompanion.insert(
            id: id,
            invoiceId: invoiceId,
            itemId: itemId,
            itemName: itemName,
            quantity: quantity,
            netPrice: netPrice,
            comment: comment,
            isPostedItem: isPostedItem,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$InvoiceItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({invoiceId = false, itemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (invoiceId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.invoiceId,
                    referencedTable:
                        $$InvoiceItemsTableReferences._invoiceIdTable(db),
                    referencedColumn: $$InvoiceItemsTableReferences
                        ._invoiceIdTable(db)
                        .invoiceId,
                  ) as T;
                }
                if (itemId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.itemId,
                    referencedTable:
                        $$InvoiceItemsTableReferences._itemIdTable(db),
                    referencedColumn:
                        $$InvoiceItemsTableReferences._itemIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$InvoiceItemsTableProcessedTableManager = ProcessedTableManager<
    _$POSDatabase,
    $InvoiceItemsTable,
    InvoiceItem,
    $$InvoiceItemsTableFilterComposer,
    $$InvoiceItemsTableOrderingComposer,
    $$InvoiceItemsTableAnnotationComposer,
    $$InvoiceItemsTableCreateCompanionBuilder,
    $$InvoiceItemsTableUpdateCompanionBuilder,
    (InvoiceItem, $$InvoiceItemsTableReferences),
    InvoiceItem,
    PrefetchHooks Function({bool invoiceId, bool itemId})>;
typedef $$PaymentsTableCreateCompanionBuilder = PaymentsCompanion Function({
  required String payId,
  required String invoiceId,
  required double amount,
  required DateTime date,
  required String paymentMethod,
  Value<String?> comment,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$PaymentsTableUpdateCompanionBuilder = PaymentsCompanion Function({
  Value<String> payId,
  Value<String> invoiceId,
  Value<double> amount,
  Value<DateTime> date,
  Value<String> paymentMethod,
  Value<String?> comment,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$PaymentsTableReferences
    extends BaseReferences<_$POSDatabase, $PaymentsTable, Payment> {
  $$PaymentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $InvoicesTable _invoiceIdTable(_$POSDatabase db) =>
      db.invoices.createAlias(
          $_aliasNameGenerator(db.payments.invoiceId, db.invoices.invoiceId));

  $$InvoicesTableProcessedTableManager get invoiceId {
    final $_column = $_itemColumn<String>('invoice_id')!;

    final manager = $$InvoicesTableTableManager($_db, $_db.invoices)
        .filter((f) => f.invoiceId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_invoiceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PaymentsTableFilterComposer
    extends Composer<_$POSDatabase, $PaymentsTable> {
  $$PaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get payId => $composableBuilder(
      column: $table.payId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get comment => $composableBuilder(
      column: $table.comment, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$InvoicesTableFilterComposer get invoiceId {
    final $$InvoicesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.invoiceId,
        referencedTable: $db.invoices,
        getReferencedColumn: (t) => t.invoiceId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InvoicesTableFilterComposer(
              $db: $db,
              $table: $db.invoices,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PaymentsTableOrderingComposer
    extends Composer<_$POSDatabase, $PaymentsTable> {
  $$PaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get payId => $composableBuilder(
      column: $table.payId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get comment => $composableBuilder(
      column: $table.comment, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$InvoicesTableOrderingComposer get invoiceId {
    final $$InvoicesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.invoiceId,
        referencedTable: $db.invoices,
        getReferencedColumn: (t) => t.invoiceId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InvoicesTableOrderingComposer(
              $db: $db,
              $table: $db.invoices,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PaymentsTableAnnotationComposer
    extends Composer<_$POSDatabase, $PaymentsTable> {
  $$PaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get payId =>
      $composableBuilder(column: $table.payId, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => column);

  GeneratedColumn<String> get comment =>
      $composableBuilder(column: $table.comment, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$InvoicesTableAnnotationComposer get invoiceId {
    final $$InvoicesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.invoiceId,
        referencedTable: $db.invoices,
        getReferencedColumn: (t) => t.invoiceId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InvoicesTableAnnotationComposer(
              $db: $db,
              $table: $db.invoices,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PaymentsTableTableManager extends RootTableManager<
    _$POSDatabase,
    $PaymentsTable,
    Payment,
    $$PaymentsTableFilterComposer,
    $$PaymentsTableOrderingComposer,
    $$PaymentsTableAnnotationComposer,
    $$PaymentsTableCreateCompanionBuilder,
    $$PaymentsTableUpdateCompanionBuilder,
    (Payment, $$PaymentsTableReferences),
    Payment,
    PrefetchHooks Function({bool invoiceId})> {
  $$PaymentsTableTableManager(_$POSDatabase db, $PaymentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> payId = const Value.absent(),
            Value<String> invoiceId = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> paymentMethod = const Value.absent(),
            Value<String?> comment = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PaymentsCompanion(
            payId: payId,
            invoiceId: invoiceId,
            amount: amount,
            date: date,
            paymentMethod: paymentMethod,
            comment: comment,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String payId,
            required String invoiceId,
            required double amount,
            required DateTime date,
            required String paymentMethod,
            Value<String?> comment = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PaymentsCompanion.insert(
            payId: payId,
            invoiceId: invoiceId,
            amount: amount,
            date: date,
            paymentMethod: paymentMethod,
            comment: comment,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$PaymentsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({invoiceId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (invoiceId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.invoiceId,
                    referencedTable:
                        $$PaymentsTableReferences._invoiceIdTable(db),
                    referencedColumn:
                        $$PaymentsTableReferences._invoiceIdTable(db).invoiceId,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$PaymentsTableProcessedTableManager = ProcessedTableManager<
    _$POSDatabase,
    $PaymentsTable,
    Payment,
    $$PaymentsTableFilterComposer,
    $$PaymentsTableOrderingComposer,
    $$PaymentsTableAnnotationComposer,
    $$PaymentsTableCreateCompanionBuilder,
    $$PaymentsTableUpdateCompanionBuilder,
    (Payment, $$PaymentsTableReferences),
    Payment,
    PrefetchHooks Function({bool invoiceId})>;
typedef $$ExtraChargesTableCreateCompanionBuilder = ExtraChargesCompanion
    Function({
  Value<int> id,
  required String invoiceId,
  required String description,
  required double amount,
  Value<DateTime> createdAt,
});
typedef $$ExtraChargesTableUpdateCompanionBuilder = ExtraChargesCompanion
    Function({
  Value<int> id,
  Value<String> invoiceId,
  Value<String> description,
  Value<double> amount,
  Value<DateTime> createdAt,
});

final class $$ExtraChargesTableReferences
    extends BaseReferences<_$POSDatabase, $ExtraChargesTable, ExtraCharge> {
  $$ExtraChargesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $InvoicesTable _invoiceIdTable(_$POSDatabase db) =>
      db.invoices.createAlias($_aliasNameGenerator(
          db.extraCharges.invoiceId, db.invoices.invoiceId));

  $$InvoicesTableProcessedTableManager get invoiceId {
    final $_column = $_itemColumn<String>('invoice_id')!;

    final manager = $$InvoicesTableTableManager($_db, $_db.invoices)
        .filter((f) => f.invoiceId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_invoiceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ExtraChargesTableFilterComposer
    extends Composer<_$POSDatabase, $ExtraChargesTable> {
  $$ExtraChargesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$InvoicesTableFilterComposer get invoiceId {
    final $$InvoicesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.invoiceId,
        referencedTable: $db.invoices,
        getReferencedColumn: (t) => t.invoiceId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InvoicesTableFilterComposer(
              $db: $db,
              $table: $db.invoices,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExtraChargesTableOrderingComposer
    extends Composer<_$POSDatabase, $ExtraChargesTable> {
  $$ExtraChargesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$InvoicesTableOrderingComposer get invoiceId {
    final $$InvoicesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.invoiceId,
        referencedTable: $db.invoices,
        getReferencedColumn: (t) => t.invoiceId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InvoicesTableOrderingComposer(
              $db: $db,
              $table: $db.invoices,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExtraChargesTableAnnotationComposer
    extends Composer<_$POSDatabase, $ExtraChargesTable> {
  $$ExtraChargesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$InvoicesTableAnnotationComposer get invoiceId {
    final $$InvoicesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.invoiceId,
        referencedTable: $db.invoices,
        getReferencedColumn: (t) => t.invoiceId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InvoicesTableAnnotationComposer(
              $db: $db,
              $table: $db.invoices,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExtraChargesTableTableManager extends RootTableManager<
    _$POSDatabase,
    $ExtraChargesTable,
    ExtraCharge,
    $$ExtraChargesTableFilterComposer,
    $$ExtraChargesTableOrderingComposer,
    $$ExtraChargesTableAnnotationComposer,
    $$ExtraChargesTableCreateCompanionBuilder,
    $$ExtraChargesTableUpdateCompanionBuilder,
    (ExtraCharge, $$ExtraChargesTableReferences),
    ExtraCharge,
    PrefetchHooks Function({bool invoiceId})> {
  $$ExtraChargesTableTableManager(_$POSDatabase db, $ExtraChargesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExtraChargesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExtraChargesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExtraChargesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> invoiceId = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              ExtraChargesCompanion(
            id: id,
            invoiceId: invoiceId,
            description: description,
            amount: amount,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String invoiceId,
            required String description,
            required double amount,
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              ExtraChargesCompanion.insert(
            id: id,
            invoiceId: invoiceId,
            description: description,
            amount: amount,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ExtraChargesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({invoiceId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (invoiceId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.invoiceId,
                    referencedTable:
                        $$ExtraChargesTableReferences._invoiceIdTable(db),
                    referencedColumn: $$ExtraChargesTableReferences
                        ._invoiceIdTable(db)
                        .invoiceId,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ExtraChargesTableProcessedTableManager = ProcessedTableManager<
    _$POSDatabase,
    $ExtraChargesTable,
    ExtraCharge,
    $$ExtraChargesTableFilterComposer,
    $$ExtraChargesTableOrderingComposer,
    $$ExtraChargesTableAnnotationComposer,
    $$ExtraChargesTableCreateCompanionBuilder,
    $$ExtraChargesTableUpdateCompanionBuilder,
    (ExtraCharge, $$ExtraChargesTableReferences),
    ExtraCharge,
    PrefetchHooks Function({bool invoiceId})>;
typedef $$SuppliersTableCreateCompanionBuilder = SuppliersCompanion Function({
  required String id,
  required String firstName,
  required String lastName,
  Value<String?> mobileNumber,
  Value<String?> email,
  Value<String?> fax,
  Value<String?> web,
  Value<String?> abn,
  Value<String?> acn,
  Value<String?> comment,
  Value<String?> street,
  Value<String?> city,
  Value<String?> state,
  Value<String?> areaCode,
  Value<String?> postalCode,
  Value<String?> country,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$SuppliersTableUpdateCompanionBuilder = SuppliersCompanion Function({
  Value<String> id,
  Value<String> firstName,
  Value<String> lastName,
  Value<String?> mobileNumber,
  Value<String?> email,
  Value<String?> fax,
  Value<String?> web,
  Value<String?> abn,
  Value<String?> acn,
  Value<String?> comment,
  Value<String?> street,
  Value<String?> city,
  Value<String?> state,
  Value<String?> areaCode,
  Value<String?> postalCode,
  Value<String?> country,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$SuppliersTableReferences
    extends BaseReferences<_$POSDatabase, $SuppliersTable, Supplier> {
  $$SuppliersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SupplierInvoicesTable, List<SupplierInvoice>>
      _supplierInvoicesRefsTable(_$POSDatabase db) =>
          MultiTypedResultKey.fromTable(db.supplierInvoices,
              aliasName: $_aliasNameGenerator(
                  db.suppliers.id, db.supplierInvoices.supplierId));

  $$SupplierInvoicesTableProcessedTableManager get supplierInvoicesRefs {
    final manager = $$SupplierInvoicesTableTableManager(
            $_db, $_db.supplierInvoices)
        .filter((f) => f.supplierId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_supplierInvoicesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$SuppliersTableFilterComposer
    extends Composer<_$POSDatabase, $SuppliersTable> {
  $$SuppliersTableFilterComposer({
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

  ColumnFilters<String> get lastName => $composableBuilder(
      column: $table.lastName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mobileNumber => $composableBuilder(
      column: $table.mobileNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fax => $composableBuilder(
      column: $table.fax, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get web => $composableBuilder(
      column: $table.web, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get abn => $composableBuilder(
      column: $table.abn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get acn => $composableBuilder(
      column: $table.acn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get comment => $composableBuilder(
      column: $table.comment, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get street => $composableBuilder(
      column: $table.street, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get city => $composableBuilder(
      column: $table.city, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get state => $composableBuilder(
      column: $table.state, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get areaCode => $composableBuilder(
      column: $table.areaCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get postalCode => $composableBuilder(
      column: $table.postalCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get country => $composableBuilder(
      column: $table.country, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> supplierInvoicesRefs(
      Expression<bool> Function($$SupplierInvoicesTableFilterComposer f) f) {
    final $$SupplierInvoicesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.supplierInvoices,
        getReferencedColumn: (t) => t.supplierId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SupplierInvoicesTableFilterComposer(
              $db: $db,
              $table: $db.supplierInvoices,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SuppliersTableOrderingComposer
    extends Composer<_$POSDatabase, $SuppliersTable> {
  $$SuppliersTableOrderingComposer({
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

  ColumnOrderings<String> get lastName => $composableBuilder(
      column: $table.lastName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mobileNumber => $composableBuilder(
      column: $table.mobileNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fax => $composableBuilder(
      column: $table.fax, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get web => $composableBuilder(
      column: $table.web, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get abn => $composableBuilder(
      column: $table.abn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get acn => $composableBuilder(
      column: $table.acn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get comment => $composableBuilder(
      column: $table.comment, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get street => $composableBuilder(
      column: $table.street, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get city => $composableBuilder(
      column: $table.city, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get state => $composableBuilder(
      column: $table.state, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get areaCode => $composableBuilder(
      column: $table.areaCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get postalCode => $composableBuilder(
      column: $table.postalCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get country => $composableBuilder(
      column: $table.country, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$SuppliersTableAnnotationComposer
    extends Composer<_$POSDatabase, $SuppliersTable> {
  $$SuppliersTableAnnotationComposer({
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

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get mobileNumber => $composableBuilder(
      column: $table.mobileNumber, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get fax =>
      $composableBuilder(column: $table.fax, builder: (column) => column);

  GeneratedColumn<String> get web =>
      $composableBuilder(column: $table.web, builder: (column) => column);

  GeneratedColumn<String> get abn =>
      $composableBuilder(column: $table.abn, builder: (column) => column);

  GeneratedColumn<String> get acn =>
      $composableBuilder(column: $table.acn, builder: (column) => column);

  GeneratedColumn<String> get comment =>
      $composableBuilder(column: $table.comment, builder: (column) => column);

  GeneratedColumn<String> get street =>
      $composableBuilder(column: $table.street, builder: (column) => column);

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get areaCode =>
      $composableBuilder(column: $table.areaCode, builder: (column) => column);

  GeneratedColumn<String> get postalCode => $composableBuilder(
      column: $table.postalCode, builder: (column) => column);

  GeneratedColumn<String> get country =>
      $composableBuilder(column: $table.country, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> supplierInvoicesRefs<T extends Object>(
      Expression<T> Function($$SupplierInvoicesTableAnnotationComposer a) f) {
    final $$SupplierInvoicesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.supplierInvoices,
        getReferencedColumn: (t) => t.supplierId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SupplierInvoicesTableAnnotationComposer(
              $db: $db,
              $table: $db.supplierInvoices,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SuppliersTableTableManager extends RootTableManager<
    _$POSDatabase,
    $SuppliersTable,
    Supplier,
    $$SuppliersTableFilterComposer,
    $$SuppliersTableOrderingComposer,
    $$SuppliersTableAnnotationComposer,
    $$SuppliersTableCreateCompanionBuilder,
    $$SuppliersTableUpdateCompanionBuilder,
    (Supplier, $$SuppliersTableReferences),
    Supplier,
    PrefetchHooks Function({bool supplierInvoicesRefs})> {
  $$SuppliersTableTableManager(_$POSDatabase db, $SuppliersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SuppliersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SuppliersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SuppliersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> firstName = const Value.absent(),
            Value<String> lastName = const Value.absent(),
            Value<String?> mobileNumber = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> fax = const Value.absent(),
            Value<String?> web = const Value.absent(),
            Value<String?> abn = const Value.absent(),
            Value<String?> acn = const Value.absent(),
            Value<String?> comment = const Value.absent(),
            Value<String?> street = const Value.absent(),
            Value<String?> city = const Value.absent(),
            Value<String?> state = const Value.absent(),
            Value<String?> areaCode = const Value.absent(),
            Value<String?> postalCode = const Value.absent(),
            Value<String?> country = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SuppliersCompanion(
            id: id,
            firstName: firstName,
            lastName: lastName,
            mobileNumber: mobileNumber,
            email: email,
            fax: fax,
            web: web,
            abn: abn,
            acn: acn,
            comment: comment,
            street: street,
            city: city,
            state: state,
            areaCode: areaCode,
            postalCode: postalCode,
            country: country,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String firstName,
            required String lastName,
            Value<String?> mobileNumber = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> fax = const Value.absent(),
            Value<String?> web = const Value.absent(),
            Value<String?> abn = const Value.absent(),
            Value<String?> acn = const Value.absent(),
            Value<String?> comment = const Value.absent(),
            Value<String?> street = const Value.absent(),
            Value<String?> city = const Value.absent(),
            Value<String?> state = const Value.absent(),
            Value<String?> areaCode = const Value.absent(),
            Value<String?> postalCode = const Value.absent(),
            Value<String?> country = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SuppliersCompanion.insert(
            id: id,
            firstName: firstName,
            lastName: lastName,
            mobileNumber: mobileNumber,
            email: email,
            fax: fax,
            web: web,
            abn: abn,
            acn: acn,
            comment: comment,
            street: street,
            city: city,
            state: state,
            areaCode: areaCode,
            postalCode: postalCode,
            country: country,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SuppliersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({supplierInvoicesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (supplierInvoicesRefs) db.supplierInvoices
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (supplierInvoicesRefs)
                    await $_getPrefetchedData<Supplier, $SuppliersTable,
                            SupplierInvoice>(
                        currentTable: table,
                        referencedTable: $$SuppliersTableReferences
                            ._supplierInvoicesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SuppliersTableReferences(db, table, p0)
                                .supplierInvoicesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.supplierId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$SuppliersTableProcessedTableManager = ProcessedTableManager<
    _$POSDatabase,
    $SuppliersTable,
    Supplier,
    $$SuppliersTableFilterComposer,
    $$SuppliersTableOrderingComposer,
    $$SuppliersTableAnnotationComposer,
    $$SuppliersTableCreateCompanionBuilder,
    $$SuppliersTableUpdateCompanionBuilder,
    (Supplier, $$SuppliersTableReferences),
    Supplier,
    PrefetchHooks Function({bool supplierInvoicesRefs})>;
typedef $$SupplierInvoicesTableCreateCompanionBuilder
    = SupplierInvoicesCompanion Function({
  required String invoiceId,
  required String supplierId,
  required DateTime createdDate,
  required double total,
  Value<bool> isPaid,
  Value<bool> isDeleted,
  required String supplierName,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$SupplierInvoicesTableUpdateCompanionBuilder
    = SupplierInvoicesCompanion Function({
  Value<String> invoiceId,
  Value<String> supplierId,
  Value<DateTime> createdDate,
  Value<double> total,
  Value<bool> isPaid,
  Value<bool> isDeleted,
  Value<String> supplierName,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$SupplierInvoicesTableReferences extends BaseReferences<
    _$POSDatabase, $SupplierInvoicesTable, SupplierInvoice> {
  $$SupplierInvoicesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $SuppliersTable _supplierIdTable(_$POSDatabase db) =>
      db.suppliers.createAlias($_aliasNameGenerator(
          db.supplierInvoices.supplierId, db.suppliers.id));

  $$SuppliersTableProcessedTableManager get supplierId {
    final $_column = $_itemColumn<String>('supplier_id')!;

    final manager = $$SuppliersTableTableManager($_db, $_db.suppliers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_supplierIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$SupplierInvoicesTableFilterComposer
    extends Composer<_$POSDatabase, $SupplierInvoicesTable> {
  $$SupplierInvoicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get invoiceId => $composableBuilder(
      column: $table.invoiceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdDate => $composableBuilder(
      column: $table.createdDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get total => $composableBuilder(
      column: $table.total, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isPaid => $composableBuilder(
      column: $table.isPaid, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get supplierName => $composableBuilder(
      column: $table.supplierName, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$SuppliersTableFilterComposer get supplierId {
    final $$SuppliersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.supplierId,
        referencedTable: $db.suppliers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SuppliersTableFilterComposer(
              $db: $db,
              $table: $db.suppliers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SupplierInvoicesTableOrderingComposer
    extends Composer<_$POSDatabase, $SupplierInvoicesTable> {
  $$SupplierInvoicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get invoiceId => $composableBuilder(
      column: $table.invoiceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdDate => $composableBuilder(
      column: $table.createdDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get total => $composableBuilder(
      column: $table.total, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isPaid => $composableBuilder(
      column: $table.isPaid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get supplierName => $composableBuilder(
      column: $table.supplierName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$SuppliersTableOrderingComposer get supplierId {
    final $$SuppliersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.supplierId,
        referencedTable: $db.suppliers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SuppliersTableOrderingComposer(
              $db: $db,
              $table: $db.suppliers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SupplierInvoicesTableAnnotationComposer
    extends Composer<_$POSDatabase, $SupplierInvoicesTable> {
  $$SupplierInvoicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get invoiceId =>
      $composableBuilder(column: $table.invoiceId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdDate => $composableBuilder(
      column: $table.createdDate, builder: (column) => column);

  GeneratedColumn<double> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<bool> get isPaid =>
      $composableBuilder(column: $table.isPaid, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<String> get supplierName => $composableBuilder(
      column: $table.supplierName, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$SuppliersTableAnnotationComposer get supplierId {
    final $$SuppliersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.supplierId,
        referencedTable: $db.suppliers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SuppliersTableAnnotationComposer(
              $db: $db,
              $table: $db.suppliers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SupplierInvoicesTableTableManager extends RootTableManager<
    _$POSDatabase,
    $SupplierInvoicesTable,
    SupplierInvoice,
    $$SupplierInvoicesTableFilterComposer,
    $$SupplierInvoicesTableOrderingComposer,
    $$SupplierInvoicesTableAnnotationComposer,
    $$SupplierInvoicesTableCreateCompanionBuilder,
    $$SupplierInvoicesTableUpdateCompanionBuilder,
    (SupplierInvoice, $$SupplierInvoicesTableReferences),
    SupplierInvoice,
    PrefetchHooks Function({bool supplierId})> {
  $$SupplierInvoicesTableTableManager(
      _$POSDatabase db, $SupplierInvoicesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SupplierInvoicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SupplierInvoicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SupplierInvoicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> invoiceId = const Value.absent(),
            Value<String> supplierId = const Value.absent(),
            Value<DateTime> createdDate = const Value.absent(),
            Value<double> total = const Value.absent(),
            Value<bool> isPaid = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<String> supplierName = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SupplierInvoicesCompanion(
            invoiceId: invoiceId,
            supplierId: supplierId,
            createdDate: createdDate,
            total: total,
            isPaid: isPaid,
            isDeleted: isDeleted,
            supplierName: supplierName,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String invoiceId,
            required String supplierId,
            required DateTime createdDate,
            required double total,
            Value<bool> isPaid = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            required String supplierName,
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SupplierInvoicesCompanion.insert(
            invoiceId: invoiceId,
            supplierId: supplierId,
            createdDate: createdDate,
            total: total,
            isPaid: isPaid,
            isDeleted: isDeleted,
            supplierName: supplierName,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SupplierInvoicesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({supplierId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (supplierId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.supplierId,
                    referencedTable:
                        $$SupplierInvoicesTableReferences._supplierIdTable(db),
                    referencedColumn: $$SupplierInvoicesTableReferences
                        ._supplierIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$SupplierInvoicesTableProcessedTableManager = ProcessedTableManager<
    _$POSDatabase,
    $SupplierInvoicesTable,
    SupplierInvoice,
    $$SupplierInvoicesTableFilterComposer,
    $$SupplierInvoicesTableOrderingComposer,
    $$SupplierInvoicesTableAnnotationComposer,
    $$SupplierInvoicesTableCreateCompanionBuilder,
    $$SupplierInvoicesTableUpdateCompanionBuilder,
    (SupplierInvoice, $$SupplierInvoicesTableReferences),
    SupplierInvoice,
    PrefetchHooks Function({bool supplierId})>;
typedef $$QuotationsTableCreateCompanionBuilder = QuotationsCompanion Function({
  required String quotationId,
  required String customerId,
  required DateTime createdDate,
  required double total,
  required String status,
  required String customerName,
  Value<DateTime?> expiryDate,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$QuotationsTableUpdateCompanionBuilder = QuotationsCompanion Function({
  Value<String> quotationId,
  Value<String> customerId,
  Value<DateTime> createdDate,
  Value<double> total,
  Value<String> status,
  Value<String> customerName,
  Value<DateTime?> expiryDate,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$QuotationsTableReferences
    extends BaseReferences<_$POSDatabase, $QuotationsTable, Quotation> {
  $$QuotationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CustomersTable _customerIdTable(_$POSDatabase db) =>
      db.customers.createAlias(
          $_aliasNameGenerator(db.quotations.customerId, db.customers.id));

  $$CustomersTableProcessedTableManager get customerId {
    final $_column = $_itemColumn<String>('customer_id')!;

    final manager = $$CustomersTableTableManager($_db, $_db.customers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$QuotationsTableFilterComposer
    extends Composer<_$POSDatabase, $QuotationsTable> {
  $$QuotationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get quotationId => $composableBuilder(
      column: $table.quotationId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdDate => $composableBuilder(
      column: $table.createdDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get total => $composableBuilder(
      column: $table.total, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customerName => $composableBuilder(
      column: $table.customerName, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get expiryDate => $composableBuilder(
      column: $table.expiryDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$CustomersTableFilterComposer get customerId {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $db.customers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CustomersTableFilterComposer(
              $db: $db,
              $table: $db.customers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$QuotationsTableOrderingComposer
    extends Composer<_$POSDatabase, $QuotationsTable> {
  $$QuotationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get quotationId => $composableBuilder(
      column: $table.quotationId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdDate => $composableBuilder(
      column: $table.createdDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get total => $composableBuilder(
      column: $table.total, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customerName => $composableBuilder(
      column: $table.customerName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get expiryDate => $composableBuilder(
      column: $table.expiryDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$CustomersTableOrderingComposer get customerId {
    final $$CustomersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $db.customers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CustomersTableOrderingComposer(
              $db: $db,
              $table: $db.customers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$QuotationsTableAnnotationComposer
    extends Composer<_$POSDatabase, $QuotationsTable> {
  $$QuotationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get quotationId => $composableBuilder(
      column: $table.quotationId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdDate => $composableBuilder(
      column: $table.createdDate, builder: (column) => column);

  GeneratedColumn<double> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get customerName => $composableBuilder(
      column: $table.customerName, builder: (column) => column);

  GeneratedColumn<DateTime> get expiryDate => $composableBuilder(
      column: $table.expiryDate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CustomersTableAnnotationComposer get customerId {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $db.customers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CustomersTableAnnotationComposer(
              $db: $db,
              $table: $db.customers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$QuotationsTableTableManager extends RootTableManager<
    _$POSDatabase,
    $QuotationsTable,
    Quotation,
    $$QuotationsTableFilterComposer,
    $$QuotationsTableOrderingComposer,
    $$QuotationsTableAnnotationComposer,
    $$QuotationsTableCreateCompanionBuilder,
    $$QuotationsTableUpdateCompanionBuilder,
    (Quotation, $$QuotationsTableReferences),
    Quotation,
    PrefetchHooks Function({bool customerId})> {
  $$QuotationsTableTableManager(_$POSDatabase db, $QuotationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuotationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuotationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuotationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> quotationId = const Value.absent(),
            Value<String> customerId = const Value.absent(),
            Value<DateTime> createdDate = const Value.absent(),
            Value<double> total = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> customerName = const Value.absent(),
            Value<DateTime?> expiryDate = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              QuotationsCompanion(
            quotationId: quotationId,
            customerId: customerId,
            createdDate: createdDate,
            total: total,
            status: status,
            customerName: customerName,
            expiryDate: expiryDate,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String quotationId,
            required String customerId,
            required DateTime createdDate,
            required double total,
            required String status,
            required String customerName,
            Value<DateTime?> expiryDate = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              QuotationsCompanion.insert(
            quotationId: quotationId,
            customerId: customerId,
            createdDate: createdDate,
            total: total,
            status: status,
            customerName: customerName,
            expiryDate: expiryDate,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$QuotationsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({customerId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (customerId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.customerId,
                    referencedTable:
                        $$QuotationsTableReferences._customerIdTable(db),
                    referencedColumn:
                        $$QuotationsTableReferences._customerIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$QuotationsTableProcessedTableManager = ProcessedTableManager<
    _$POSDatabase,
    $QuotationsTable,
    Quotation,
    $$QuotationsTableFilterComposer,
    $$QuotationsTableOrderingComposer,
    $$QuotationsTableAnnotationComposer,
    $$QuotationsTableCreateCompanionBuilder,
    $$QuotationsTableUpdateCompanionBuilder,
    (Quotation, $$QuotationsTableReferences),
    Quotation,
    PrefetchHooks Function({bool customerId})>;
typedef $$CreditNotesTableCreateCompanionBuilder = CreditNotesCompanion
    Function({
  required String creditNoteId,
  required String invoiceId,
  required String customerId,
  required DateTime createdDate,
  required double amount,
  Value<String?> reason,
  required String customerName,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$CreditNotesTableUpdateCompanionBuilder = CreditNotesCompanion
    Function({
  Value<String> creditNoteId,
  Value<String> invoiceId,
  Value<String> customerId,
  Value<DateTime> createdDate,
  Value<double> amount,
  Value<String?> reason,
  Value<String> customerName,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$CreditNotesTableReferences
    extends BaseReferences<_$POSDatabase, $CreditNotesTable, CreditNote> {
  $$CreditNotesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $InvoicesTable _invoiceIdTable(_$POSDatabase db) =>
      db.invoices.createAlias($_aliasNameGenerator(
          db.creditNotes.invoiceId, db.invoices.invoiceId));

  $$InvoicesTableProcessedTableManager get invoiceId {
    final $_column = $_itemColumn<String>('invoice_id')!;

    final manager = $$InvoicesTableTableManager($_db, $_db.invoices)
        .filter((f) => f.invoiceId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_invoiceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $CustomersTable _customerIdTable(_$POSDatabase db) =>
      db.customers.createAlias(
          $_aliasNameGenerator(db.creditNotes.customerId, db.customers.id));

  $$CustomersTableProcessedTableManager get customerId {
    final $_column = $_itemColumn<String>('customer_id')!;

    final manager = $$CustomersTableTableManager($_db, $_db.customers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$CreditNotesTableFilterComposer
    extends Composer<_$POSDatabase, $CreditNotesTable> {
  $$CreditNotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get creditNoteId => $composableBuilder(
      column: $table.creditNoteId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdDate => $composableBuilder(
      column: $table.createdDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customerName => $composableBuilder(
      column: $table.customerName, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$InvoicesTableFilterComposer get invoiceId {
    final $$InvoicesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.invoiceId,
        referencedTable: $db.invoices,
        getReferencedColumn: (t) => t.invoiceId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InvoicesTableFilterComposer(
              $db: $db,
              $table: $db.invoices,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CustomersTableFilterComposer get customerId {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $db.customers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CustomersTableFilterComposer(
              $db: $db,
              $table: $db.customers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CreditNotesTableOrderingComposer
    extends Composer<_$POSDatabase, $CreditNotesTable> {
  $$CreditNotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get creditNoteId => $composableBuilder(
      column: $table.creditNoteId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdDate => $composableBuilder(
      column: $table.createdDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customerName => $composableBuilder(
      column: $table.customerName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$InvoicesTableOrderingComposer get invoiceId {
    final $$InvoicesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.invoiceId,
        referencedTable: $db.invoices,
        getReferencedColumn: (t) => t.invoiceId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InvoicesTableOrderingComposer(
              $db: $db,
              $table: $db.invoices,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CustomersTableOrderingComposer get customerId {
    final $$CustomersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $db.customers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CustomersTableOrderingComposer(
              $db: $db,
              $table: $db.customers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CreditNotesTableAnnotationComposer
    extends Composer<_$POSDatabase, $CreditNotesTable> {
  $$CreditNotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get creditNoteId => $composableBuilder(
      column: $table.creditNoteId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdDate => $composableBuilder(
      column: $table.createdDate, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get customerName => $composableBuilder(
      column: $table.customerName, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$InvoicesTableAnnotationComposer get invoiceId {
    final $$InvoicesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.invoiceId,
        referencedTable: $db.invoices,
        getReferencedColumn: (t) => t.invoiceId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InvoicesTableAnnotationComposer(
              $db: $db,
              $table: $db.invoices,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CustomersTableAnnotationComposer get customerId {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $db.customers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CustomersTableAnnotationComposer(
              $db: $db,
              $table: $db.customers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CreditNotesTableTableManager extends RootTableManager<
    _$POSDatabase,
    $CreditNotesTable,
    CreditNote,
    $$CreditNotesTableFilterComposer,
    $$CreditNotesTableOrderingComposer,
    $$CreditNotesTableAnnotationComposer,
    $$CreditNotesTableCreateCompanionBuilder,
    $$CreditNotesTableUpdateCompanionBuilder,
    (CreditNote, $$CreditNotesTableReferences),
    CreditNote,
    PrefetchHooks Function({bool invoiceId, bool customerId})> {
  $$CreditNotesTableTableManager(_$POSDatabase db, $CreditNotesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CreditNotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CreditNotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CreditNotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> creditNoteId = const Value.absent(),
            Value<String> invoiceId = const Value.absent(),
            Value<String> customerId = const Value.absent(),
            Value<DateTime> createdDate = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String?> reason = const Value.absent(),
            Value<String> customerName = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CreditNotesCompanion(
            creditNoteId: creditNoteId,
            invoiceId: invoiceId,
            customerId: customerId,
            createdDate: createdDate,
            amount: amount,
            reason: reason,
            customerName: customerName,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String creditNoteId,
            required String invoiceId,
            required String customerId,
            required DateTime createdDate,
            required double amount,
            Value<String?> reason = const Value.absent(),
            required String customerName,
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CreditNotesCompanion.insert(
            creditNoteId: creditNoteId,
            invoiceId: invoiceId,
            customerId: customerId,
            createdDate: createdDate,
            amount: amount,
            reason: reason,
            customerName: customerName,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CreditNotesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({invoiceId = false, customerId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (invoiceId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.invoiceId,
                    referencedTable:
                        $$CreditNotesTableReferences._invoiceIdTable(db),
                    referencedColumn: $$CreditNotesTableReferences
                        ._invoiceIdTable(db)
                        .invoiceId,
                  ) as T;
                }
                if (customerId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.customerId,
                    referencedTable:
                        $$CreditNotesTableReferences._customerIdTable(db),
                    referencedColumn:
                        $$CreditNotesTableReferences._customerIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$CreditNotesTableProcessedTableManager = ProcessedTableManager<
    _$POSDatabase,
    $CreditNotesTable,
    CreditNote,
    $$CreditNotesTableFilterComposer,
    $$CreditNotesTableOrderingComposer,
    $$CreditNotesTableAnnotationComposer,
    $$CreditNotesTableCreateCompanionBuilder,
    $$CreditNotesTableUpdateCompanionBuilder,
    (CreditNote, $$CreditNotesTableReferences),
    CreditNote,
    PrefetchHooks Function({bool invoiceId, bool customerId})>;

class $POSDatabaseManager {
  final _$POSDatabase _db;
  $POSDatabaseManager(this._db);
  $$CustomersTableTableManager get customers =>
      $$CustomersTableTableManager(_db, _db.customers);
  $$ItemsTableTableManager get items =>
      $$ItemsTableTableManager(_db, _db.items);
  $$InvoicesTableTableManager get invoices =>
      $$InvoicesTableTableManager(_db, _db.invoices);
  $$InvoiceItemsTableTableManager get invoiceItems =>
      $$InvoiceItemsTableTableManager(_db, _db.invoiceItems);
  $$PaymentsTableTableManager get payments =>
      $$PaymentsTableTableManager(_db, _db.payments);
  $$ExtraChargesTableTableManager get extraCharges =>
      $$ExtraChargesTableTableManager(_db, _db.extraCharges);
  $$SuppliersTableTableManager get suppliers =>
      $$SuppliersTableTableManager(_db, _db.suppliers);
  $$SupplierInvoicesTableTableManager get supplierInvoices =>
      $$SupplierInvoicesTableTableManager(_db, _db.supplierInvoices);
  $$QuotationsTableTableManager get quotations =>
      $$QuotationsTableTableManager(_db, _db.quotations);
  $$CreditNotesTableTableManager get creditNotes =>
      $$CreditNotesTableTableManager(_db, _db.creditNotes);
}
