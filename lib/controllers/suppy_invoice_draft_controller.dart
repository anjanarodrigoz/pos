import 'package:get/get.dart';
import 'package:pos/repositories/supplier_invoice_repository.dart';
import '../models/cart.dart';
import '../models/extra_charges.dart';
import '../models/invoice_item.dart';
import '../models/supply_invoice.dart';
import '../models/supplyer.dart';
import '../utils/val.dart';

class SupplyInvoiceDraftController extends GetxController {
  final SupplierInvoiceRepository _supplierInvoiceRepo =
      Get.find<SupplierInvoiceRepository>();

  final Supplyer supplyer;
  RxString invoiceId = ''.obs;
  RxString referenceId = ''.obs;
  RxList<ExtraCharges> extraList = <ExtraCharges>[].obs;
  RxList<String> comments = <String>[].obs;
  RxList<Cart> cartList = <Cart>[].obs;
  SupplyInvoice? copyInvoice;
  final bool isReturnManager;

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
    // Generate invoice ID using repository
    invoiceId.value =
        await _supplierInvoiceRepo.generateNextInvoiceId(isReturnNote: isReturnManager);
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
      {required this.supplyer,
      this.copyInvoice,
      required this.isReturnManager});

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
    // Convert Cart items to InvoiceItemData (using cart.price as buyingPrice)
    List<InvoiceItemData> items = cartList
        .map((cart) => InvoiceItemData(
              itemId: cart.itemId,
              itemName: cart.name,
              quantity: cart.qty,
              buyingPrice: cart.price,
              comment: cart.comment,
            ))
        .toList();

    // Convert ExtraCharges to ExtraChargeData
    List<ExtraChargeData> charges = extraList
        .map((extra) => ExtraChargeData(
              description: extra.name,
              amount: extra.netTotal,
            ))
        .toList();

    // Create invoice using repository
    final result = await _supplierInvoiceRepo.createInvoice(
      invoiceId: invoiceId.value,
      supplierId: supplyer.id,
      supplierName: '${supplyer.firstName} ${supplyer.lastName}',
      supplierMobile: supplyer.mobileNumber,
      supplierEmail: supplyer.email,
      referenceId: referenceId.value.isNotEmpty ? referenceId.value : null,
      items: items,
      extraCharges: charges.isNotEmpty ? charges : null,
      comments: comments.isNotEmpty ? comments : null,
      billingAddress: supplyer.address?.toJson(),
      gstPercentage: Val.gstPrecentage,
      isReturnNote: isReturnManager,
    );

    if (result.isSuccess) {
      Get.delete<SupplyInvoiceDraftController>();
    } else {
      // Handle error - could show snackbar or dialog
      print('Error creating supplier invoice: ${result.error}');
    }
  }
}
