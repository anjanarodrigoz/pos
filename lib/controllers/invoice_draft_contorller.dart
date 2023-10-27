import 'package:get/get.dart';
import '../database/cart_db_service.dart';
import '../database/invoice_db_service.dart';
import '../models/cart.dart';
import '../models/customer.dart';
import '../models/extra_charges.dart';
import '../models/invoice.dart';
import '../models/invoice_item.dart';
import '../utils/val.dart';

class InvoiceDraftController extends GetxController {
  final Customer customer;
  RxString invoiceId = ''.obs;
  RxList<ExtraCharges> extraList = <ExtraCharges>[].obs;
  RxList<String> comments = <String>[].obs;
  RxList<Cart> cartList = <Cart>[].obs;
  Function? disposeListen;
  Invoice? copyInvoice;
  var netTotal = 0.0.obs;
  var gstTotal = 0.0.obs;
  var cartTotal = 0.0;
  var extraTotal = 0.0;
  var total = 0.0.obs;

  @override
  void onInit() async {
    super.onInit();
    invoiceId.value = InvoiceDB().generateInvoiceId();
    if (copyInvoice != null) {
      extraList.value = copyInvoice!.extraCharges ?? [];
      comments.value = copyInvoice!.comments ?? [];
      cartList.value = copyInvoice!.itemList
          .map((invoiceItem) => Cart.fromInvoiceItem(invoiceItem))
          .toList();
      await CartDB().copyInvoiceItem(cartList);
      updateExtraTotal();
      updateCart();
    }
  }

  @override
  void onClose() {
    // Dispose of resources, close streams, etc.
    super.onClose();
  }

  InvoiceDraftController({required this.customer, this.copyInvoice});

  void addExtraCharges(ExtraCharges extraCharges) {
    extraList.add(extraCharges);
    updateExtraTotal();
  }

  void addComments(String comment) {
    comments.clear();
    comments.add(comment);
  }

  Future<void> updateCart() async {
    cartTotal = 0;
    cartList.value = await CartDB().getCartItems();
    for (Cart cart in cartList) {
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

  Future<void> saveInvoice() async {
    final db = InvoiceDB();

    List<InvoicedItem> itemList = cartList
        .map((cart) => InvoicedItem(
            itemId: cart.itemId,
            name: cart.name,
            netPrice: cart.netPrice,
            qty: cart.qty,
            comment: cart.comment,
            isPostedItem: cart.isPostedItem))
        .toList();

    Invoice invoice = Invoice(
        customerMobile: customer.mobileNumber,
        invoiceId: invoiceId.value,
        createdDate: DateTime.now(),
        customerId: customer.id,
        gstPrecentage: Val.gstPrecentage,
        customerName: '${customer.firstName} ${customer.lastName}',
        billingAddress: customer.deliveryAddress,
        shippingAddress: customer.postalAddress,
        comments: comments,
        extraCharges: extraList,
        itemList: itemList);

    await db.addInvoice(invoice);
    await db.saveLastId(invoiceId.value);
    await CartDB().clearCart();
  }
}
