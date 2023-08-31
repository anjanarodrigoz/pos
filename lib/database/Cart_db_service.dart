import 'package:get_storage/get_storage.dart';
import '../database/item_db_service.dart';
import '../utils/val.dart';
import 'dart:math';

import '../models/cart.dart';

class CartDB {
  final _storage = GetStorage(DBVal.cart);
  static final CartDB _instance = CartDB._internal();

  factory CartDB() {
    return _instance;
  }

  CartDB._internal();

  Future<List<Cart>> getCartItems() async {
    final List cartList = await _storage.getValues().toList() ?? [];
    return cartList.map((data) => Cart.fromJson(data)).toList();
  }

  static String generateUniqueItemId() {
    final random = Random();
    return '${DateTime.now().millisecondsSinceEpoch}_${random.nextInt(10000)}';
  }

  Future<void> addItemToCart(Cart cart) async {
    ItemDB itemDB = ItemDB();
    await itemDB.getItemFromStock(cart.itemId, cart.qty);
    String cartId = generateUniqueItemId();
    Cart finalCart = cart.copyWith(cartId: cartId);
    await _storage.write(cartId, finalCart.toJson());
  }

  Future<void> updateCart(Cart oldCart, Cart newCart) async {
    ItemDB itemDB = ItemDB();
    int qty = newCart.qty - oldCart.qty;
    await itemDB.getItemFromStock(oldCart.itemId, qty);
    await _storage.write(oldCart.cartId!, newCart.toJson());
  }

  Future<void> updateSavedItem(Cart oldCart, Cart newCart) async {
    ItemDB itemDb = ItemDB();
    int qty = newCart.qty - oldCart.qty;
    await itemDb.getItemFromStock(oldCart.itemId, qty);
    await _storage.write(oldCart.cartId!, newCart.copyWith(qty: qty).toJson());
  }

  Future<void> removeSavedItem(Cart cart) async {
    ItemDB itemDB = ItemDB();
    await itemDB.getItemFromStock(cart.itemId, -(cart.qty));
    await _storage.write(
        cart.cartId!, cart.copyWith(qty: -(cart.qty)).toJson());
  }

  Future<void> removeItemFromCart(Cart cart) async {
    ItemDB itemDB = ItemDB();
    await itemDB.getItemFromStock(cart.itemId, -(cart.qty));
    await _storage.remove(cart.cartId!);
  }

  Future<void> resetCart() async {
    final itemDb = ItemDB();
    final cartList = await getCartItems();
    await itemDb.returnFromCart(cartList);
    clearCart();
  }

  Future<void> clearCart() async {
    await _storage.erase();
  }
}
