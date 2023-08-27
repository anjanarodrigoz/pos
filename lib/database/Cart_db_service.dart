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

  String _generateUniqueItemId() {
    final random = Random();
    return '${DateTime.now().millisecondsSinceEpoch}_${random.nextInt(10000)}';
  }

  Future<void> addItemToCart(Cart cart) async {
    String cartId = _generateUniqueItemId();
    Cart finalCart = cart.copyWith(cartId: cartId);
    await _storage.write(cartId, finalCart.toJson());
  }

  Future<void> updateCart(Cart cart) async {
    await _storage.write(cart.cartId!, cart.toJson());
  }

  Future<void> removeItemFromCart(String cartId) async {
    await _storage.remove(cartId);
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
