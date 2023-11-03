import 'package:get_storage/get_storage.dart';

import '../models/store.dart';
import '../utils/val.dart';

class StoreDB {
  final _storage = GetStorage(DBVal.store);
  static final StoreDB _instance = StoreDB._internal();

  factory StoreDB() {
    return _instance;
  }

  StoreDB._internal();

  Future<void> addStore(Store store) async {
    await _storage.write(DBVal.store, store.toJson());
  }

  Store getStore() {
    var data = _storage.read(DBVal.store);

    if (data == null) {
      return Store(
          companyName: '',
          abn: '',
          street: '',
          city: '',
          state: '',
          postalcode: '',
          mobileNumber1: '',
          email: '',
          email2: '',
          password: '',
          smtpServer: '');
    } else {
      return Store.fromJson(data);
    }
  }
}
