import 'package:get_storage/get_storage.dart';

import '../models/customer.dart';

class CustomerDB {
  final _storage = GetStorage('Customers');
  static final CustomerDB _instance = CustomerDB._internal();

  factory CustomerDB() {
    return _instance;
  }

  CustomerDB._internal();

  Future<List<Customer>> getAllCustomers() async {
    final List<dynamic> customerData = await _storage.getValues() ?? [];
    return customerData.map((data) => Customer.fromJson(data)).toList();
  }

  Future<void> addCustomer(Customer customer) async {
    await _storage.write(customer.id, customer.toJson());
  }

  Future<void> updateCustomer(Customer updatedCustomer) async {
    await _storage.write(updatedCustomer.id, updatedCustomer.toJson());
  }

  Future<void> deleteCustomer(String customerId) async {
    await _storage.remove(customerId);
  }
}
