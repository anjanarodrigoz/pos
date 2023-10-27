import 'address.dart';

class Supplyer {
  static const String idKey = 'id';
  static const String firstNameKey = 'firstName';
  static const String lastNameKey = 'lastName';
  static const String mobileNumberKey = 'mobileNumber';
  static const String addressKey = 'deliveryAddress';
  static const String faxKey = 'fax';
  static const String emailKey = 'email';
  static const String webKey = 'web';
  static const String commentKey = 'comment';
  static const String abnKey = 'abn';
  static const String acnKey = 'acn';

  final String id;
  String firstName;
  String lastName;
  String mobileNumber;
  Address? address;
  String? fax;
  String? email;
  String? web;
  String? comment;
  String? abn;
  String? acn;

  Supplyer({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.mobileNumber,
    this.address,
    this.fax,
    this.email,
    this.web,
    this.comment,
    this.abn,
    this.acn,
  });

  Supplyer copyWith({
    String? firstName,
    String? lastName,
    String? mobileNumber,
    Address? deliveryAddress,
    String? fax,
    String? email,
    String? web,
    String? comment,
    String? abn,
    String? acn,
  }) {
    return Supplyer(
      id: id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      address: deliveryAddress ?? this.address,
      fax: fax ?? this.fax,
      email: email ?? this.email,
      web: web ?? this.web,
      comment: comment ?? this.comment,
      abn: abn ?? this.abn,
      acn: acn ?? this.acn,
    );
  }

  factory Supplyer.fromJson(Map<String, dynamic> json) {
    return Supplyer(
      id: json[idKey] as String,
      firstName: json[firstNameKey] as String,
      lastName: json[lastNameKey] as String,
      mobileNumber: json[mobileNumberKey] as String,
      address: json[addressKey] != null
          ? Address.fromJson(json[addressKey] as Map<String, dynamic>)
          : null,
      fax: json[faxKey] as String?,
      email: json[emailKey] as String?,
      web: json[webKey] as String?,
      comment: json[commentKey] as String?,
      abn: json[abnKey] as String?,
      acn: json[acnKey] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      idKey: id,
      firstNameKey: firstName,
      lastNameKey: lastName,
      mobileNumberKey: mobileNumber,
      addressKey: address?.toJson(),
      faxKey: fax,
      emailKey: email,
      webKey: web,
      commentKey: comment,
      abnKey: abn,
      acnKey: acn,
    };
  }
}
