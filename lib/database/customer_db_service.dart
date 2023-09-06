import 'package:get_storage/get_storage.dart';
import 'package:pos/utils/val.dart';

import '../models/customer.dart';

class CustomerDB {
  final _storage = GetStorage(DBVal.customers);
  static final CustomerDB _instance = CustomerDB._internal();

  factory CustomerDB() {
    return _instance;
  }

  CustomerDB._internal();

  Future<List<Customer>> getAllCustomers() async {
    final List customerData = await _storage.getValues().toList() ?? [];

    return customerData.map((data) => Customer.fromJson(data)).toList();
  }

  Customer getCustomer(String cutomerId) {
    Customer customer = Customer.fromJson(_storage.read(cutomerId));
    return customer;
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

  static String generateCustomerId() {
    final storage = GetStorage();
    final lastId = storage.read(DBVal.customerId) ?? '1000';
    final lastNumber = int.tryParse(lastId) ?? 1000;

    final nextNumber = lastNumber + 1;
    return '$nextNumber';
  }

  Future<void> saveLastId(String newId) async {
    final storage = GetStorage();
    await storage.write(DBVal.customerId, newId);
  }

  Future<void> eraseAllCustomers() async {
    await _storage.erase();
    await GetStorage().remove(DBVal.customerId);
  }
}
