import 'package:get/get.dart';
import 'package:pos/repositories/invoice_repository.dart';
import '../database/cart_db_service.dart';
import '../models/cart.dart';
import '../models/customer.dart';
import '../models/extra_charges.dart';
import '../models/invoice.dart';
import '../models/invoice_item.dart';
import '../utils/id_generator.dart';
import '../utils/val.dart';

/// Controller for invoice draft creation with Drift database
class InvoiceDraftController extends GetxController {
  final Customer customer;
  final InvoiceRepository _invoiceRepo = Get.find<InvoiceRepository>();

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
    // Generate new invoice ID using IDGenerator
    invoiceId.value = IDGenerator.generateInvoiceId();

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

  /// Save invoice to Drift database using InvoiceRepository
  Future<void> saveInvoice() async {
    // Convert cart items to InvoiceItemData for repository
    final items = cartList
        .map((cart) => InvoiceItemData(
              itemId: cart.itemId,
              itemName: cart.name,
              quantity: cart.qty,
              netPrice: cart.price,
              comment: cart.comment,
              isPostedItem: cart.isPostedItem,
            ))
        .toList();

    // Convert extra charges to ExtraChargeData for repository
    final charges = extraList
        .map((extra) => ExtraChargeData(
              description: extra.name,
              amount: extra.netTotal,
            ))
        .toList();

    // Save invoice using InvoiceRepository (Drift database)
    final result = await _invoiceRepo.createInvoice(
      invoiceId: invoiceId.value,
      customerId: customer.id,
      customerName: '${customer.firstName} ${customer.lastName}',
      customerMobile: customer.mobileNumber,
      email: customer.email,
      gstPercentage: Val.gstPrecentage,
      billingAddress: customer.deliveryAddress?.toJson(),
      shippingAddress: customer.postalAddress?.toJson(),
      items: items,
      extraCharges: charges,
      comments: comments.isNotEmpty ? comments : null,
    );

    if (result.isFailure) {
      throw Exception(result.error?.message ?? 'Failed to save invoice');
    }

    // Clear cart after successful save
    await CartDB().clearCart();
  }
}
