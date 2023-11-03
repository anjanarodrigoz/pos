class Store {
  static const companyNameKey = 'company_name';
  static const abnKey = 'abn';
  static const faxKey = 'fax';
  static const streetKey = 'street';
  static const sloganKey = 'slogan';
  static const cityKey = 'city';
  static const stateKey = 'state';
  static const postalcodeKey = 'postalcode';
  static const mobileNumber1Key = 'mobileNumber1';
  static const emailKey = 'email';
  static const email2Key = 'email2'; // Added another email field
  static const passwordKey = 'password';
  static const smtpKeyKey = 'smtp';

  String companyName;
  String slogan;
  String abn;
  String fax;
  String street;
  String city;
  String state;
  String postalcode;
  String mobileNumber1;
  String email;
  String email2; // Added another email field
  String password;
  String smtpServer;

  Store({
    this.fax = '',
    this.slogan = '',
    required this.companyName,
    required this.abn,
    required this.street,
    required this.city,
    required this.state,
    required this.postalcode,
    required this.mobileNumber1,
    required this.email,
    required this.email2, // Added another email field
    required this.password,
    required this.smtpServer,
  });

  // Named constructor to create a Store object from a JSON map
  Store.fromJson(Map<String, dynamic> json)
      : companyName = json[companyNameKey] ?? '',
        abn = json[abnKey] ?? '',
        slogan = json[sloganKey] ?? '',
        street = json[streetKey] ?? '',
        fax = json[faxKey] ?? '',
        city = json[cityKey] ?? '',
        state = json[stateKey] ?? '',
        postalcode = json[postalcodeKey] ?? '',
        mobileNumber1 = json[mobileNumber1Key] ?? '',
        email = json[emailKey] ?? '',
        email2 = json[email2Key] ?? '', // Added another email field
        password = json[passwordKey] ?? '',
        smtpServer = json[smtpKeyKey] ?? '';

  // Convert the Store object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      companyNameKey: companyName,
      abnKey: abn,
      streetKey: street,
      cityKey: city,
      sloganKey: slogan,
      fax: fax,
      stateKey: state,
      postalcodeKey: postalcode,
      mobileNumber1Key: mobileNumber1,
      emailKey: email,
      email2Key: email2, // Added another email field
      passwordKey: password,
      smtpKeyKey: smtpServer,
    };
  }

  // Copy constructor to create a copy of the Store object
  Store copy() {
    return Store(
      companyName: companyName,
      abn: abn,
      street: street,
      city: city,
      slogan: slogan,
      state: state,
      fax: fax,
      postalcode: postalcode,
      mobileNumber1: mobileNumber1,
      email: email,
      email2: email2,
      password: password,
      smtpServer: smtpServer,
    );
  }
}
