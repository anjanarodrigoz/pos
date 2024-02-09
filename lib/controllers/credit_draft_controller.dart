import 'package:get/get.dart';
import 'package:pos/database/credit_db_serive.dart';
import 'package:pos/database/quatation_db_serive.dart';
import '../models/cart.dart';
import '../models/customer.dart';
import '../models/extra_charges.dart';
import '../models/invoice.dart';
import '../models/invoice_item.dart';
import '../utils/val.dart';

class CreditDraftController extends GetxController {
  final Customer customer;
  RxString invoiceId = ''.obs;
  RxList<ExtraCharges> extraList = <ExtraCharges>[].obs;
  RxList<String> comments = <String>[].obs;
  RxList<Cart> cartList = <Cart>[].obs;
  Invoice? copyInvoice;
  bool wantToUpdate;

  var netTotal = 0.0.obs;
  var gstTotal = 0.0.obs;
  var cartTotal = 0.0;
  var extraTotal = 0.0;
  var total = 0.0.obs;

  @override
  void onClose() {
    // Dispose of resources, close streams, etc.
    super.onClose();
  }

  @override
  void onInit() async {
    super.onInit();

    if (wantToUpdate) {
      if (copyInvoice != null) {
        invoiceId.value = copyInvoice!.invoiceId;
        customer.deliveryAddress = copyInvoice!.billingAddress;
        customer.postalAddress = copyInvoice!.shippingAddress;
        customer.firstName = copyInvoice!.customerName;
        customer.lastName = '';
        customer.mobileNumber = copyInvoice!.customerMobile;
        extraList.value = copyInvoice!.extraCharges ?? [];
        cartList.value = (copyInvoice!.itemList)
            .map((e) => Cart.fromInvoiceItem(e))
            .toList();
        comments.value = copyInvoice!.comments ?? [];
      }
    } else {
      invoiceId.value = CreditNoteDB().generateInvoiceId();
      if (copyInvoice != null) {
        extraList.value = copyInvoice!.extraCharges ?? [];
        cartList.value = (copyInvoice!.itemList)
            .map((e) => Cart.fromInvoiceItem(e))
            .toList();
        comments.value = copyInvoice!.comments ?? [];
        updateCart();
        updateExtraTotal();
      }
    }
  }

  CreditDraftController(
      {required this.customer, this.copyInvoice, this.wantToUpdate = false});

  void addExtraCharges(ExtraCharges extraCharges) {
    extraList.add(extraCharges);
    updateExtraTotal();
  }

  void addComments(String comment) {
    comments.clear();
    comments.add(comment);
  }

  void updateCart({Cart? newCart}) async {
    cartTotal = 0;
    if (newCart != null && newCart.qty == 0) {
      cartList.remove(
          cartList.where((cart) => cart.cartId == newCart.cartId).first);
    }

    for (Cart cart in cartList) {
      if (newCart != null) {
        if (cart.cartId == newCart.cartId) {
          int index = cartList.indexOf(cart);
          cartList.remove(cart);
          cartList.insert(index, newCart);
          cartTotal += newCart.netTotal;
        }
      } else {
        cartTotal += cart.netTotal;
      }
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
    final db = CreditNoteDB();

    List<InvoicedItem> itemList = cartList
        .map((cart) => InvoicedItem(
            itemId: cart.itemId,
            name: cart.name,
            netPrice: cart.price,
            qty: cart.qty,
            comment: cart.comment,
            isPostedItem: cart.isPostedItem))
        .toList();

    Invoice invoice = Invoice(
        email: customer.email ?? '',
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
    await db.updateInvoice(invoice);
    Get.delete<CreditDraftController>();
  }

  Future<void> saveInvoice() async {
    final db = CreditNoteDB();

    List<InvoicedItem> itemList = cartList
        .map((cart) => InvoicedItem(
            itemId: cart.itemId,
            name: cart.name,
            netPrice: cart.price,
            qty: cart.qty,
            comment: cart.comment,
            isPostedItem: cart.isPostedItem))
        .toList();

    Invoice invoice = Invoice(
        email: customer.email ?? '',
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

    await db.saveLastId(invoiceId.value);
    await db.addInvoice(invoice);
    Get.delete<CreditDraftController>();
  }
}
