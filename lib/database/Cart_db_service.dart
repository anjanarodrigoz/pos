import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../repositories/item_repository.dart';
import '../utils/val.dart';
import 'dart:math';

import '../models/cart.dart';

class CartDB {
  final _storage = GetStorage(DBVal.cart);
  final ItemRepository _itemRepo = Get.find<ItemRepository>();
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
    // Decrease stock quantity (negative change)
    await _itemRepo.updateStock(cart.itemId, -cart.qty);
    String cartId = generateUniqueItemId();
    Cart finalCart = cart.copyWith(cartId: cartId);
    await _storage.write(cartId, finalCart.toJson());
  }

  Future<void> updateCart(Cart oldCart, Cart newCart) async {
    int qty = newCart.qty - oldCart.qty;
    // Adjust stock by the quantity difference (negative to decrease)
    await _itemRepo.updateStock(oldCart.itemId, -qty);
    if (newCart.qty != 0) {
      await _storage.write(oldCart.cartId!, newCart.toJson());
    }
  }

  Future<void> updateOldCart(Cart oldCart, Cart newCart) async {
    int qty = newCart.qty - oldCart.qty;
    // Adjust stock by the quantity difference (negative to decrease)
    await _itemRepo.updateStock(oldCart.itemId, -qty);
    await _storage.write(oldCart.cartId!, newCart.copyWith(qty: qty).toJson());
  }

  Future<void> removeOldItemFromCart(Cart oldCart, Cart newCart) async {
    // Return stock (positive change to increase)
    await _itemRepo.updateStock(oldCart.itemId, newCart.qty);
    await _storage.write(
        oldCart.cartId!, oldCart.copyWith(qty: -(oldCart.qty)).toJson());
  }

  Future<void> removeItemFromCart(Cart cart) async {
    // Return stock (positive change to increase)
    await _itemRepo.updateStock(cart.itemId, cart.qty);
    await _storage.remove(cart.cartId!);
  }

  Future<void> resetCart() async {
    final cartList = await getCartItems();
    // Return all items back to stock
    for (Cart cart in cartList) {
      await _itemRepo.updateStock(cart.itemId, cart.qty);
    }
    clearCart();
  }

  Future<void> copyInvoiceItem(List<Cart> cartList) async {
    for (Cart cart in cartList) {
      await _storage.write(cart.cartId!, cart.toJson());
      // Decrease stock quantity (negative change)
      await _itemRepo.updateStock(cart.itemId, -cart.qty);
    }
  }

  Future<void> clearCart() async {
    await _storage.erase();
  }
}
