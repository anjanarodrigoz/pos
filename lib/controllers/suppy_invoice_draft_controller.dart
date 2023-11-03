import 'package:get/get.dart';
import 'package:pos/database/item_db_service.dart';
import 'package:pos/database/supplyer_invoice_db_service.dart';
import '../database/cart_db_service.dart';
import '../database/invoice_db_service.dart';
import '../models/cart.dart';
import '../models/customer.dart';
import '../models/extra_charges.dart';
import '../models/invoice.dart';
import '../models/invoice_item.dart';
import '../models/supply_invoice.dart';
import '../models/supplyer.dart';
import '../utils/val.dart';

class SupplyInvoiceDraftController extends GetxController {
  final Supplyer supplyer;
  RxString invoiceId = ''.obs;
  RxString referenceId = ''.obs;
  RxList<ExtraCharges> extraList = <ExtraCharges>[].obs;
  RxList<String> comments = <String>[].obs;
  RxList<Cart> cartList = <Cart>[].obs;
  SupplyInvoice? copyInvoice;
  final bool isRetunManager;

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
    invoiceId.value = isRetunManager
        ? SupplyerInvoiceDB().generateReturnNoteId()
        : SupplyerInvoiceDB().generateInvoiceId();
    if (copyInvoice != null) {
      extraList.value = copyInvoice!.extraCharges ?? [];
      cartList.value =
          (copyInvoice!.itemList).map((e) => Cart.fromInvoiceItem(e)).toList();
      comments.value = copyInvoice!.comments ?? [];
      updateCart();
      updateExtraTotal();
    }
  }

  SupplyInvoiceDraftController(
      {required this.supplyer, this.copyInvoice, required this.isRetunManager});

  void addExtraCharges(ExtraCharges extraCharges) {
    extraList.add(extraCharges);
    updateExtraTotal();
  }

  void addComments(String comment) {
    comments.clear();
    comments.add(comment);
  }

  void updateCart() async {
    cartTotal = 0;
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
    final db = SupplyerInvoiceDB();

    List<InvoicedItem> itemList = cartList
        .map((cart) => InvoicedItem(
            itemId: cart.itemId,
            name: cart.name,
            netPrice: cart.netPrice,
            qty: cart.qty,
            comment: cart.comment,
            isPostedItem: cart.isPostedItem))
        .toList();

    SupplyInvoice invoice = SupplyInvoice(
        email: supplyer.email ?? '',
        referenceId: referenceId.value,
        isReturnNote: isRetunManager,
        supplyerMobile: supplyer.mobileNumber,
        invoiceId: invoiceId.value,
        createdDate: DateTime.now(),
        supplyerId: supplyer.id,
        gstPrecentage: Val.gstPrecentage,
        supplyerName: '${supplyer.firstName} ${supplyer.lastName}',
        billingAddress: supplyer.address,
        comments: comments,
        extraCharges: extraList,
        itemList: itemList);

    isRetunManager
        ? await db.saveReturnNoteId(invoiceId.value)
        : await db.saveLastId(invoiceId.value);
    await db.addInvoice(invoice);
    Get.delete<SupplyInvoiceDraftController>();
  }
}
