import 'dart:convert';
import 'package:pos/database/pos_database.dart' as drift;
import 'package:pos/models/supply_invoice.dart' as domain;
import 'package:pos/models/address.dart';
import 'package:pos/models/extra_charges.dart';
import 'package:pos/models/invoice_item.dart';

/// Helper class to convert between Drift database SupplierInvoice and domain SupplyInvoice model
class SupplierInvoiceConverter {
  /// Convert Drift SupplierInvoice to domain SupplyInvoice model
  static domain.SupplyInvoice toDomain({
    required drift.SupplierInvoice driftInvoice,
    List<drift.SupplierInvoiceItem> items = const [],
  }) {
    // Convert items
    List<InvoicedItem> itemList = items
        .map((driftItem) => InvoicedItem(
              itemId: driftItem.itemId,
              name: driftItem.itemName,
              netPrice: driftItem.buyingPrice,
              qty: driftItem.quantity,
              comment: driftItem.comment,
              isPostedItem: false,
            ))
        .toList();

    // Decode extra charges from JSON
    List<ExtraCharges>? extraCharges;
    if (driftInvoice.extraChargesJson != null) {
      try {
        final chargesJson = jsonDecode(driftInvoice.extraChargesJson!) as List;
        extraCharges = chargesJson
            .map((charge) => ExtraCharges(
                  name: charge['description'] ?? '',
                  price: (charge['amount'] ?? 0.0).toDouble(),
                  qty: 1,
                ))
            .toList();
      } catch (e) {
        extraCharges = null;
      }
    }

    // Decode comments from JSON
    List<String>? comments;
    if (driftInvoice.commentsJson != null) {
      try {
        comments = (jsonDecode(driftInvoice.commentsJson!) as List)
            .map((c) => c.toString())
            .toList();
      } catch (e) {
        comments = null;
      }
    }

    // Decode billing address from JSON
    Address? billingAddress;
    if (driftInvoice.billingAddressJson != null) {
      try {
        final addressJson =
            jsonDecode(driftInvoice.billingAddressJson!) as Map<String, dynamic>;
        billingAddress = Address.fromJson(addressJson);
      } catch (e) {
        billingAddress = null;
      }
    }

    return domain.SupplyInvoice(
      invoiceId: driftInvoice.invoiceId,
      createdDate: driftInvoice.createdDate,
      supplyerId: driftInvoice.supplierId,
      supplyerName: driftInvoice.supplierName,
      supplyerMobile: driftInvoice.supplierMobile ?? '',
      email: driftInvoice.supplierEmail ?? '',
      gstPrecentage: driftInvoice.gstPercentage,
      itemList: itemList,
      referenceId: driftInvoice.referenceId,
      isReturnNote: driftInvoice.isReturnNote,
      extraCharges: extraCharges,
      comments: comments,
      billingAddress: billingAddress,
    );
  }

  /// Convert list of Drift SupplierInvoices to list of domain SupplyInvoices
  static List<domain.SupplyInvoice> toDomainList(
      List<drift.SupplierInvoice> driftInvoices) {
    return driftInvoices
        .map((driftInvoice) => toDomain(driftInvoice: driftInvoice))
        .toList();
  }
}
