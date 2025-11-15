import 'package:get_storage/get_storage.dart';
import 'package:pos/database/abstract_db.dart';
import 'package:pos/utils/val.dart';

import '../models/customer.dart';

class CustomerDB implements AbstractDB {
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
    final lastId = storage.read(DBVal.customerId) ?? '0';
    final lastNumber = int.tryParse(lastId) ?? 0;

    final nextNumber = lastNumber + 1;
    return '$nextNumber';
  }

  Future<void> saveLastId(String newId) async {
    final storage = GetStorage();
    await storage.write(DBVal.customerId, newId);
  }

  @override
  Future<void> deleteDB() async {
    await _storage.erase();
    await GetStorage().remove(DBVal.customerId);
  }

  @override
  Future<Map> backupData() async {
    final List customerData = await _storage.getValues().toList() ?? [];
    final lastId = GetStorage().read(DBVal.customerId) ?? '0';

    return {DBVal.customers: customerData, DBVal.customerId: lastId};
  }

  @override
  Future<void> insertData(Map json) async {
    final List customerData = json[DBVal.customers];
    final lastId = json[DBVal.customerId];

    for (var data in customerData) {
      await addCustomer(Customer.fromJson(data));
    }

    saveLastId(lastId);
  }

  @override
  getName() {
    // TODO: implement getName
    return DBVal.customers;
  }
}
