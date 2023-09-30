import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pos/database/item_db_service.dart';
import 'package:pos/models/payment.dart';
import 'package:pos/utils/alert_message.dart';
import 'package:pos/utils/val.dart';
import '../models/cart.dart';
import '../models/invoice.dart';
import 'abstract_db.dart'; // Assuming you have an Invoice model

class InvoiceDB implements AbstractDB {
  final _storage = GetStorage(DBVal.invoice);
  static final InvoiceDB _instance = InvoiceDB._internal();

  factory InvoiceDB() {
    return _instance;
  }

  InvoiceDB._internal();

  Future<List<Invoice>> getAllInvoices() async {
    final List invoiceData = await _storage.getValues().toList() ?? [];
    return invoiceData.map((data) => Invoice.fromJson(data)).toList();
  }

  Invoice getInvoice(String invoiceId) {
    Invoice invoice = Invoice.fromJson(_storage.read(invoiceId));
    return invoice;
  }

  Future<void> addInvoice(Invoice invoice) async {
    await _storage.write(invoice.invoiceId, invoice.toJson());
  }

  Future<void> updateInvoice(Invoice updatedInvoice) async {
    await _storage.write(updatedInvoice.invoiceId, updatedInvoice.toJson());
  }

  Future<void> deleteInvoice(Invoice invoice) async {
    List<Cart> cartList =
        invoice.itemList.map((item) => Cart.fromInvoiceItem(item)).toList();
    await ItemDB().returnFromCart(cartList);
    await updateInvoice(invoice.copyWith(
        isDeleted: true,
        extraCharges: [],
        itemList: [],
        payments: [],
        comments: ['This invoice has been deleted']));
  }

  String generateInvoiceId() {
    final storage = GetStorage();
    final lastId = storage.read(DBVal.invoiceId) ?? '1000';
    final lastNumber = int.tryParse(lastId) ?? 1000;

    final nextNumber = lastNumber + 1;
    return '$nextNumber';
  }

  static String generatePayId() {
    final storage = GetStorage();
    final lastId = storage.read(DBVal.payId) ?? '1000';
    final lastNumber = int.tryParse(lastId) ?? 1000;

    final nextNumber = lastNumber + 1;
    return '$nextNumber';
  }

  static Future<void> saveLastPayId(String newId) async {
    final storage = GetStorage();
    await storage.write(DBVal.payId, newId);
  }

  Future<void> saveLastId(String newId) async {
    final storage = GetStorage();
    await storage.write(DBVal.invoiceId, newId);
  }

  @override
  Future<void> deleteDB() async {
    await _storage.erase();
    await GetStorage().remove(DBVal.invoiceId);
  }

  Stream<List<Invoice>> getStreamInvoice() async* {
    StreamController<List<Invoice>> streamController =
        StreamController<List<Invoice>>();
    List<Invoice> invoiceList = await getAllInvoices();
    streamController.add(invoiceList);
    _storage.listen(() async {
      invoiceList.clear();

      invoiceList = await getAllInvoices();
      streamController.add(invoiceList);
    });

    yield* streamController.stream;
  }

  Future<void> addInvoicePayment(Payment payment, Invoice invoice) async {
    String payId = generatePayId();

    payment = payment.copyWith(payId: 'P$payId');

    List<Payment> payments = invoice.payments ?? [];

    payments.add(payment);

    invoice = invoice.copyWith(payments: payments, closeDate: DateTime.now());

    if (invoice.toPay == 0.00) {
      invoice = invoice.copyWith(isPaid: true);
    }

    await updateInvoice(invoice);

    await saveLastPayId(payId);
  }

  Future<void> removeInvoicePayment(
      String invoiceId, String paymentId, BuildContext context) async {
    Invoice invoice = getInvoice(invoiceId);

    if (DateTime.now().difference(invoice.createdDate) >
        const Duration(days: 7)) {
      AlertMessage.snakMessage('Can not be deleteted', context);
    } else {
      List<Payment> payments = invoice.payments ?? [];

      for (Payment payment in payments) {
        if (payment.payId == paymentId) {
          payments.remove(payment);
          break;
        }
      }

      invoice.closeDate = null;
      invoice = invoice.copyWith(isPaid: false, payments: payments);

      await updateInvoice(invoice);
    }
  }

  @override
  Future<Map> backupData() async {
    final List invoiceData = await _storage.getValues().toList() ?? [];
    final lastId = GetStorage().read(DBVal.invoiceId) ?? '1000';

    return {DBVal.invoice: invoiceData, DBVal.invoiceId: lastId};
  }

  @override
  Future<void> insertData(Map json) async {
    final List invoiceData = json[DBVal.invoice];
    final lastId = json[DBVal.invoiceId];

    for (var data in invoiceData) {
      await addInvoice(Invoice.fromJson(data));
    }

    saveLastId(lastId);
  }

  @override
  String getName() {
    return DBVal.invoice;
  }
}
