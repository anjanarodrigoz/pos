import 'package:get/get.dart';
import '../database/cart_db_service.dart';
import '../repositories/invoice_repository.dart';
import '../models/cart.dart';
import '../models/extra_charges.dart';
import '../models/invoice.dart';
import '../utils/val.dart';

class InvoiceEditController extends GetxController {
  final InvoiceRepository _invoiceRepo = Get.find<InvoiceRepository>();

  late Invoice _invoice;
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

    extraList.value = RxList<ExtraCharges>.from(_invoice.extraCharges ?? []);
    comments.value = RxList<String>.from(_invoice.comments ?? []);

    oldCartList =
        _invoice.itemList.map((item) => Cart.fromInvoiceItem(item)).toList();

    updateCart();
    updateExtraTotal();
  }

  Invoice get invoice => _invoice;

  @override
  void onClose() {
    // Dispose of resources, close streams, etc.
    super.onClose();
  }

  InvoiceEditController({required Invoice invoice}) {
    _invoice = invoice;
  }

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
    newCartList.clear();
    List<Cart> cartList = await CartDB().getCartItems();

    for (Cart oldCart in oldCartList) {
      var list = cartList
          .where((cart) => cart.cartId.toString() == oldCart.cartId.toString())
          .toList();

      if (list.isNotEmpty) {
        Cart cart = list[0];
        int qty = oldCart.qty + cart.qty;
        cart = cart.copyWith(qty: qty);
        if (qty != 0) {
          newCartList.add(cart);
        }
        cartList.removeWhere((element) => element.cartId == cart.cartId);
      } else {
        newCartList.add(oldCart);
      }
    }

    for (Cart cart in cartList) {
      newCartList.add(cart);
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

  Future<void> updateInvoice() async {
    // Convert Cart items to InvoiceItemData
    List<InvoiceItemData> items = newCartList
        .map((cart) => InvoiceItemData(
            
              itemId: cart.itemId,
              itemName: cart.name,
              quantity: cart.qty,
              netPrice: cart.price,
              comment: cart.comment,
              isPostedItem: cart.isPostedItem,
            ))
        .toList();

    // Convert ExtraCharges to ExtraChargeData
    List<ExtraChargeData> charges = extraList
        .map((extra) => ExtraChargeData(
              amount: extra.price,
              description: extra.name,
            ))
        .toList();

    // Update invoice using repository
    final result = await _invoiceRepo.updateInvoiceWithItems(
      invoiceId: _invoice.invoiceId,
      items: items,
      extraCharges: charges,
      comments: comments.isNotEmpty ? comments : null,
      customerMobile: _invoice.customerMobile,
      customerId: _invoice.customerId,
      customerName: _invoice.customerName,
      billingAddress: _invoice.billingAddress?.toJson(),
      shippingAddress: _invoice.shippingAddress?.toJson(),
      gstPercentage: Val.gstPrecentage,
    );

    if (result.isSuccess) {
      await CartDB().clearCart();
    } else {
      // Handle error - could show snackbar or dialog
      print('Error updating invoice: ${result.error}');
    }
  }

  Future<void> close() async {
    print('Invoice: ${_invoice.comments}');
    print('New Comments :$comments');
  }
}
