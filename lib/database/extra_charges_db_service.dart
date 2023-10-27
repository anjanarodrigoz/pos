import 'package:get_storage/get_storage.dart';
import 'package:pos/models/extra_charges.dart';
import 'package:pos/utils/val.dart';

import 'abstract_db.dart';

class ExtraChargeDB implements AbstractDB {
  final _storage = GetStorage(DBVal.extraCharges);
  static final ExtraChargeDB _instance = ExtraChargeDB._internal();

  factory ExtraChargeDB() {
    return _instance;
  }

  ExtraChargeDB._internal();

  Future<void> addExtraCharge(ExtraCharges extraCharge) async {
    await _storage.write(extraCharge.name, extraCharge.toJson());
  }

  Future<List<ExtraCharges>> readAllExtraChrages() async {
    List extraList = await _storage.getValues().toList() ?? [];

    return extraList.map((extra) => ExtraCharges.fromJson(extra)).toList();
  }

  Future<ExtraCharges> getExtraCharge(String name) async {
    var json = await _storage.read(name);
    return ExtraCharges.fromJson(json);
  }

  Future<void> deleteExtraCharge(String name) async {
    await _storage.remove(name);
  }

  @override
  backupData() async {
    // TODO: implement backupData
    final List extraChargeData = await _storage.getValues().toList() ?? [];
    return {
      DBVal.extraCharges: extraChargeData,
    };
  }

  @override
  insertData(Map json) async {
    // TODO: implement insertData
    final List exatraChargesData = json[DBVal.extraCharges];

    for (var data in exatraChargesData) {
      await addExtraCharge(ExtraCharges.fromJson(data));
    }
  }

  @override
  getName() {
    // TODO: implement getName
    return DBVal.extraCharges;
  }

  @override
  deleteDB() async {
    // TODO: implement deleteDB
    await _storage.erase();
  }
}
