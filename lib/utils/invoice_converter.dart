import 'dart:convert';
import 'package:pos/database/pos_database.dart' as drift;
import 'package:pos/models/invoice.dart' as domain;
import 'package:pos/models/invoice_item.dart';
import 'package:pos/models/extra_charges.dart';
import 'package:pos/models/payment.dart';
import 'package:pos/models/address.dart';

/// Helper class to convert between Drift database models and domain models
/// This maintains backward compatibility with the existing UI code
class InvoiceConverter {
  /// Convert Drift Invoice to domain Invoice model with all related data
  static domain.Invoice toDomain({
    required drift.Invoice driftInvoice,
    List<drift.InvoiceItem>? items,
    List<drift.Payment>? payments,
    List<drift.ExtraCharge>? extraCharges,
  }) {
    // Convert invoice items
    final List<InvoicedItem> itemList = (items ?? []).map((item) {
      return InvoicedItem(
        itemId: item.itemId,
        name: item.itemName,
        netPrice: item.netPrice,
        qty: item.quantity,
        comment: item.comment,
        isPostedItem: item.isPostedItem,
      );
    }).toList();

    // Convert extra charges
    final List<ExtraCharges>? extraChargesList = extraCharges?.map((charge) {
      // Parse netPrice back to unit price and quantity
      // Assuming qty=1 for extra charges (since Drift doesn't store qty separately)
      return ExtraCharges(
        name: charge.description,
        qty: 1,
        price: charge.amount,
      );
    }).toList();

    // Convert payments
    final List<Payment>? paymentList = payments?.map((payment) {
      return Payment(
        payId: payment.payId,
        date: payment.date,
        amount: payment.amount,
        paymethod: _parsePaymethod(payment.paymentMethod),
        comment: payment.comment ?? '',
      );
    }).toList();

    // Parse addresses from JSON
    Address? billingAddress;
    if (driftInvoice.billingAddressJson != null) {
      try {
        billingAddress = Address.fromJson(
          jsonDecode(driftInvoice.billingAddressJson!),
        );
      } catch (e) {
        billingAddress = null;
      }
    }

    Address? shippingAddress;
    if (driftInvoice.shippingAddressJson != null) {
      try {
        shippingAddress = Address.fromJson(
          jsonDecode(driftInvoice.shippingAddressJson!),
        );
      } catch (e) {
        shippingAddress = null;
      }
    }

    // Parse comments from JSON
    List<String>? comments;
    if (driftInvoice.commentsJson != null) {
      try {
        comments = List<String>.from(jsonDecode(driftInvoice.commentsJson!));
      } catch (e) {
        comments = null;
      }
    }

    // Create domain invoice
    return domain.Invoice(
      invoiceId: driftInvoice.invoiceId,
      createdDate: driftInvoice.createdDate,
      isPaid: driftInvoice.isPaid,
      isDeleted: driftInvoice.isDeleted,
      customerId: driftInvoice.customerId,
      customerName: driftInvoice.customerName,
      customerMobile: driftInvoice.customerMobile ?? '',
      email: driftInvoice.email ?? '',
      gstPrecentage: driftInvoice.gstPercentage,
      itemList: itemList,
      extraCharges: extraChargesList,
      closeDate: driftInvoice.closeDate,
      comments: comments,
      payments: paymentList,
      billingAddress: billingAddress,
      shippingAddress: shippingAddress,
    );
  }

  /// Convert Drift FullInvoiceData to domain Invoice model
  static domain.Invoice fromFullInvoiceData(drift.FullInvoiceData data) {
    return toDomain(
      driftInvoice: data.invoice,
      items: data.items,
      payments: data.payments,
      extraCharges: data.extraCharges,
    );
  }

  /// Parse payment method string to Paymethod enum
  static Paymethod _parsePaymethod(String method) {
    try {
      return Paymethod.values.firstWhere(
        (e) => e.name == method,
        orElse: () => Paymethod.cash,
      );
    } catch (e) {
      return Paymethod.cash;
    }
  }

  /// Convert domain Payment to payment method string for Drift
  static String paymethodToString(Paymethod method) {
    return method.name;
  }

  /// Calculate toPay amount from drift invoice
  static double calculateToPay(drift.Invoice invoice) {
    if (invoice.isPaid) {
      return 0.0;
    }
    return invoice.total - invoice.paidAmount;
  }
}
