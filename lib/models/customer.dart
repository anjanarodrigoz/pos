import 'address.dart';

class Customer {
  static const String idKey = 'id';
  static const String firstNameKey = 'firstName';
  static const String lastNameKey = 'lastName';
  static const String mobileNumberKey = 'mobileNumber';
  static const String deliveryAddressKey = 'deliveryAddress';
  static const String postalAddressKey = 'postalAddress';
  static const String faxKey = 'fax';
  static const String emailKey = 'email';
  static const String webKey = 'web';
  static const String commentKey = 'comment';
  static const String abnKey = 'abn';
  static const String acnKey = 'acn';
  static const String onHoldKey = 'onHold';
  static const String limitKey = 'limit';
  static const String outStandingKey = 'outStanding';

  final String id;
  String firstName;
  String lastName;
  String mobileNumber;
  Address? deliveryAddress;
  Address? postalAddress;
  String? fax;
  String? email;
  String? web;
  String? comment;
  String? abn;
  String? acn;
  bool onHold;
  double? limit;
  double outStanding;

  Customer({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.mobileNumber,
    this.deliveryAddress,
    this.postalAddress,
    this.fax,
    this.email,
    this.web,
    this.comment,
    this.abn,
    this.acn,
    this.onHold = false,
    this.outStanding = 0,
    this.limit,
  });

  Customer copyWith(
      {String? firstName,
      String? lastName,
      String? mobileNumber,
      Address? deliveryAddress,
      Address? postalAddress,
      String? fax,
      String? email,
      String? web,
      String? comment,
      String? abn,
      String? acn,
      bool? onHold,
      double? limit,
      double? outStanding}) {
    return Customer(
      id: id,
      outStanding: outStanding ?? this.outStanding,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      postalAddress: postalAddress ?? this.postalAddress,
      fax: fax ?? this.fax,
      email: email ?? this.email,
      web: web ?? this.web,
      comment: comment ?? this.comment,
      abn: abn ?? this.abn,
      acn: acn ?? this.acn,
      onHold: onHold ?? this.onHold,
      limit: limit ?? this.limit,
    );
  }

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      outStanding: json[outStandingKey] as double,
      id: json[idKey] as String,
      firstName: json[firstNameKey] as String,
      lastName: json[lastNameKey] as String,
      mobileNumber: json[mobileNumberKey] as String,
      deliveryAddress: json[deliveryAddressKey] != null
          ? Address.fromJson(json[deliveryAddressKey] as Map<String, dynamic>)
          : null,
      postalAddress: json[postalAddressKey] != null
          ? Address.fromJson(json[postalAddressKey] as Map<String, dynamic>)
          : null,
      fax: json[faxKey] as String?,
      email: json[emailKey] as String?,
      web: json[webKey] as String?,
      comment: json[commentKey] as String?,
      abn: json[abnKey] as String?,
      acn: json[acnKey] as String?,
      onHold: json[onHoldKey],
      limit: json[limitKey] as double?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      outStandingKey: outStanding,
      idKey: id,
      firstNameKey: firstName,
      lastNameKey: lastName,
      mobileNumberKey: mobileNumber,
      deliveryAddressKey: deliveryAddress?.toJson(),
      postalAddressKey: postalAddress?.toJson(),
      faxKey: fax,
      emailKey: email,
      webKey: web,
      commentKey: comment,
      abnKey: abn,
      acnKey: acn,
      onHoldKey: onHold,
      limitKey: limit,
    };
  }
}
