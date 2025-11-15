import 'dart:async';

import 'package:get_storage/get_storage.dart';
import 'package:pos/models/supplyer.dart';
import 'package:pos/utils/val.dart';

import 'abstract_db.dart';

class SupplyerDB implements AbstractDB {
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
    StreamController<List<Supplyer>> streamController =
        StreamController<List<Supplyer>>();
    List<Supplyer> supplyerList = await getAllSupplyers();
    streamController.add(supplyerList);
    _storage.listen(() async {
      supplyerList.clear();

      supplyerList = await getAllSupplyers();
      streamController.add(supplyerList);
    });

    yield* streamController.stream;
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
    final lastId = storage.read(DBVal.supplyerId) ?? '0';
    final lastNumber = int.tryParse(lastId) ?? 0;

    final nextNumber = lastNumber + 1;
    return '$nextNumber';
  }

  Future<void> saveLastId(String newId) async {
    final storage = GetStorage();
    await storage.write(DBVal.supplyerId, newId);
  }

  @override
  Future<void> deleteDB() async {
    await _storage.erase();
    await GetStorage().remove(DBVal.supplyerId);
  }

  @override
  Future<Map> backupData() async {
    final List supplyerData = await _storage.getValues().toList() ?? [];
    final lastId = GetStorage().read(DBVal.supplyerId) ?? '0';

    return {DBVal.supplyer: supplyerData, DBVal.supplyerId: lastId};
  }

  @override
  Future<void> insertData(Map json) async {
    final List supplyerData = json[DBVal.supplyer];
    final lastId = json[DBVal.supplyerId];

    for (var data in supplyerData) {
      await addSupplyer(Supplyer.fromJson(data));
    }

    saveLastId(lastId);
  }

  @override
  getName() {
    // TODO: implement getName
    return DBVal.supplyer;
  }
}
