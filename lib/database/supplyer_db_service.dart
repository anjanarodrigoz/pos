import 'package:get_storage/get_storage.dart';
import 'package:pos/models/supplyer.dart';
import 'package:pos/utils/val.dart';

import '../models/supplyer.dart';

class SupplyerDB {
  final _storage = GetStorage(DBVal.supplyer);
  static final SupplyerDB _instance = SupplyerDB._internal();

  factory SupplyerDB() {
    return _instance;
  }

  SupplyerDB._internal();

  Future<List<Supplyer>> getAllSupplyers() async {
    final List supplyerData = await _storage.getValues().toList() ?? [];

    return supplyerData.map((data) => Supplyer.fromJson(data)).toList();
  }

  Stream<List<Supplyer>> getStreamAllSupplyer() async* {
    List supplyerData = await _storage.getValues().toList() ?? [];

    _storage.listen(() async {
      supplyerData.clear();
      supplyerData = await _storage.getValues().toList() ?? [];
    });

    yield supplyerData.map((data) => Supplyer.fromJson(data)).toList();
  }

  Supplyer getSupplyer(String supplyerId) {
    Supplyer supplyer = Supplyer.fromJson(_storage.read(supplyerId));
    return supplyer;
  }

  Future<void> addSupplyer(Supplyer supplyer) async {
    await _storage.write(supplyer.id, supplyer.toJson());
  }

  Future<void> updateSupplyer(Supplyer updatedSupplyer) async {
    await _storage.write(updatedSupplyer.id, updatedSupplyer.toJson());
  }

  Future<void> deleteSupplyer(String supplyerId) async {
    await _storage.remove(supplyerId);
  }

  static String generateSupplyerId() {
    final storage = GetStorage();
    final lastId = storage.read(DBVal.supplyerId) ?? '1000';
    final lastNumber = int.tryParse(lastId) ?? 1000;

    final nextNumber = lastNumber + 1;
    return '$nextNumber';
  }

  Future<void> saveLastId(String newId) async {
    final storage = GetStorage();
    await storage.write(DBVal.supplyerId, newId);
  }

  Future<void> eraseAllSupplyers() async {
    await _storage.erase();
    await GetStorage().remove(DBVal.supplyerId);
  }
}
