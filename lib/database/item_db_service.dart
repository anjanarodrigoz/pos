import 'package:get_storage/get_storage.dart';
import 'package:pos/database/cart_db_service.dart';
import 'package:pos/utils/val.dart';

import '../models/cart.dart';
import '../models/item.dart';
import 'abstract_db.dart';

class ItemDB implements AbstractDB {
  final _storage = GetStorage(DBVal.items);
  static final ItemDB _instance = ItemDB._internal();

  factory ItemDB() {
    return _instance;
  }

  ItemDB._internal();

  Future<List<Item>> getAllItems() async {
    final List itemData = await _storage.getValues().toList() ?? [];

    return itemData.map((data) => Item.fromJson(data)).toList();
  }

  Item? getItem(String itemId) {
    Item? item = Item.fromJson(_storage.read(itemId));
    return item;
  }

  Future<void> addItem(Item item) async {
    await _storage.write(item.id, item.toJson());
  }

  Future<void> updateItem(Item updatedItem) async {
    await _storage.write(updatedItem.id, updatedItem.toJson());
  }

  Future<void> deleteItem(String itemId) async {
    await _storage.remove(itemId);
  }

  Future<bool> isItemIdAvaliable(String itemId) async {
    final box = GetStorage();
    List itemIds = box.read(DBVal.itemId) ?? [];
    return !itemIds.contains(itemId);
  }

  Future<void> saveItemId(String itemId) async {
    final box = GetStorage();
    List itemIds = box.read(DBVal.itemId) ?? [];
    itemIds.add(itemId);
    await box.write(DBVal.itemId, itemIds);
  }

  Future<void> getItemFromStock(String itemId, int qty) async {
    Item itme = getItem(itemId) ??
        Item(
            id: itemId,
            price: 0.00,
            name: 'Deleted Item',
            description: 'Deleted item return from invoice');
    final updatedItem = itme.copyWith(qty: itme.qty - qty);
    await updateItem(updatedItem);
  }

  Future<bool> returnFromCart(List<Cart> cartList) async {
    cartList.forEach((cart) async {
      Item itme = getItem(cart.itemId) ??
          Item(
              id: cart.itemId,
              price: 0.00,
              name: cart.name,
              description: 'Deleted item return from invoice');
      final updatedItem = itme.copyWith(qty: itme.qty + cart.qty);
      await updateItem(updatedItem);
    });
    return true;
  }

  Future<bool> copyItemsInInvoice(List<Cart> cartList) async {
    cartList.forEach((cart) async {
      Item itme = getItem(cart.itemId) ??
          Item(
              id: cart.itemId,
              price: 0.00,
              name: cart.name,
              description: 'Deleted item return from invoice');
      final updatedItem = itme.copyWith(qty: itme.qty - cart.qty);
      await updateItem(updatedItem);
    });
    return true;
  }

  @override
  Future<void> deleteDB() async {
    await _storage.erase();
    await GetStorage().remove(DBVal.itemId);
  }

  @override
  Future<Map> backupData() async {
    final List itemData = await _storage.getValues().toList() ?? [];
    final lastId = GetStorage().read(DBVal.itemId) ?? '1000';

    return {DBVal.items: itemData, DBVal.itemId: lastId};
  }

  @override
  Future<void> insertData(Map json) async {
    final List itemData = json[DBVal.items];
    final lastId = json[DBVal.itemId];

    for (var data in itemData) {
      await addItem(Item.fromJson(data));
    }

    saveItemId(lastId);
  }

  @override
  getName() {
    // TODO: implement getName
    return DBVal.items;
  }
}
