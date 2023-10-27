class Address {
  static const String streetKey = 'street';
  static const String cityKey = 'city';
  static const String stateKey = 'state';
  static const String areaCodeKey = 'areaCode';
  static const String postalCodeKey = 'postalCode';
  static const String countyKey = 'county';

  String? street;
  String? city;
  String? state;
  String? areaCode;
  String? postalCode;
  String? county;

  Address({
    this.street,
    this.city,
    this.state,
    this.areaCode,
    this.postalCode,
    this.county,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json[streetKey] as String?,
      city: json[cityKey] as String?,
      state: json[stateKey] as String?,
      areaCode: json[areaCodeKey] as String?,
      postalCode: json[postalCodeKey] as String?,
      county: json[countyKey] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      streetKey: street,
      cityKey: city,
      stateKey: state,
      areaCodeKey: areaCode,
      postalCodeKey: postalCode,
      countyKey: county,
    };
  }
}
