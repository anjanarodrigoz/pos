import 'package:get/get.dart';
import 'package:pos/repositories/invoice_repository.dart';
import '../models/cart.dart';
import '../models/customer.dart';
import '../models/extra_charges.dart';
import '../models/invoice.dart';
import '../models/invoice_item.dart';
import '../utils/id_generator.dart';
import '../utils/val.dart';

/// Controller for credit note draft creation with Drift database
class CreditDraftController extends GetxController {
  final Customer customer;
  final InvoiceRepository _invoiceRepo = Get.find<InvoiceRepository>();

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
      // Generate credit note ID using IDGenerator
      invoiceId.value = IDGenerator.generateCreditNoteId();
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

  /// Update existing credit note using InvoiceRepository (Drift database)
  Future<void> updateInvoice() async {
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

    // Update credit note using InvoiceRepository (stored as Invoice with CN- prefix)
    await _invoiceRepo.updateInvoice(
      invoiceId: invoiceId.value,
      customerName: '${customer.firstName} ${customer.lastName}',
      customerMobile: customer.mobileNumber,
      email: customer.email,
      billingAddress: customer.deliveryAddress?.toJson(),
      shippingAddress: customer.postalAddress?.toJson(),
      comments: comments.isNotEmpty ? comments : null,
    );

    Get.delete<CreditDraftController>();
  }

  /// Save new credit note using InvoiceRepository (Drift database)
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

    // Save credit note using InvoiceRepository (Drift database)
    // Credit notes are stored as invoices with CN- prefix
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
      throw Exception(result.error?.message ?? 'Failed to save credit note');
    }

    Get.delete<CreditDraftController>();
  }
}
