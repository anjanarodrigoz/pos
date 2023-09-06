import 'package:get_storage/get_storage.dart';
import 'package:pos/models/extra_charges.dart';
import 'package:pos/utils/val.dart';

class ExtraChargeDB {
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
}
