import 'package:get/get.dart';
import '../database/Cart_db_service.dart';
import '../database/invoice_db_service.dart';
import '../models/cart.dart';
import '../models/extra_charges.dart';
import '../models/invoice.dart';
import '../models/invoice_item.dart';
import '../utils/val.dart';

class InvoiceEditController extends GetxController {
  final Invoice invoice;
  RxList<ExtraCharges> extraList = <ExtraCharges>[].obs;
  RxList<String> comments = <String>[].obs;
  List<Cart> oldCartList = <Cart>[];
  RxList<Cart> newCartList = <Cart>[].obs;
  var netTotal = 0.0.obs;
  var gstTotal = 0.0.obs;
  var cartTotal = 0.0;
  var extraTotal = 0.0;
  var total = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    extraList.value = invoice.extraCharges ?? [];
    for (InvoicedItem item in invoice.itemList) {
      oldCartList.add(Cart(
          itemId: item.itemId,
          name: item.name,
          netPrice: item.netPrice,
          qty: item.qty,
          isPostedItem: item.isPostedItem,
          comment: item.comment,
          cartId: CartDB.generateUniqueItemId()));
    }
    newCartList.value = oldCartList;
    comments.value = invoice.comments ?? [];
    updateCart();
    updateExtraTotal();
  }

  @override
  void onClose() {
    // Dispose of resources, close streams, etc.
    super.onClose();
  }

  InvoiceEditController({required this.invoice});

  void addComments(String comment) {
    comments.clear();
    comments.add(comment);
  }

  void addExtraCharges(ExtraCharges extraCharges) {
    extraList.add(extraCharges);
    updateExtraTotal();
  }

  Future<void> updateCart() async {
    cartTotal = 0;
    var cartList = await CartDB().getCartItems();

    for (Cart cart in cartList) {
      Cart? oldCart = isItemExsits(cart.cartId!);
      if (oldCart != null) {
        print('old item');
        print(cart.cartId);
        print(cart.qty);
        print(oldCart.qty);
        int qty = oldCart.qty + cart.qty;
        newCartList.remove(oldCart);

        if (qty != 0) {
          newCartList.add(cart.copyWith(qty: oldCart.qty + cart.qty));
        }
      } else {
        print('new Item');
        newCartList.add(cart);
      }
    }

    for (Cart cart in newCartList) {
      cartTotal += cart.netTotal;
    }
    updateTotals();
  }

  void updateExtraTotal() {
    extraTotal = 0;
    for (ExtraCharges extra in extraList) {
      extraTotal += extra.netTotal;
    }
    updateTotals();
  }

  void updateTotals() {
    netTotal.value = extraTotal + cartTotal;
    gstTotal.value = netTotal.value * Val.gstPrecentage;
    total.value = netTotal.value * Val.gstTotalPrecentage;
  }

  Cart? isItemExsits(String id) {
    for (Cart cart in oldCartList) {
      if (cart.cartId == id) {
        return cart;
      }
    }
    return null;
  }

  Future<void> updateInvoice() async {
    final db = InvoiceDB();

    List<InvoicedItem> itemList = newCartList
        .map((cart) => InvoicedItem(
            itemId: cart.itemId,
            name: cart.name,
            netPrice: cart.netPrice,
            qty: cart.qty,
            comment: cart.comment,
            isPostedItem: cart.isPostedItem))
        .toList();

    Invoice newInvoice = invoice.copyWith(
      customerMobile: invoice.customerMobile,
      customerId: invoice.customerId,
      gstPrecentage: Val.gstPrecentage,
      customerName: invoice.customerName,
      billingAddress: invoice.billingAddress,
      shippingAddress: invoice.shippingAddress,
      comments: comments,
      extraCharges: extraList,
      itemList: itemList,
    );

    await db.updateInvoice(newInvoice);
    await CartDB().clearCart();
  }
}
