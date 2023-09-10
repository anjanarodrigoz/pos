import 'dart:async';

import 'package:get_storage/get_storage.dart';
import 'package:pos/database/item_db_service.dart';
import 'package:pos/models/payment.dart';
import 'package:pos/utils/val.dart';
import '../models/cart.dart';
import '../models/invoice.dart'; // Assuming you have an Invoice model

class SupplyerInvoiceDB {
  final _storage = GetStorage(DBVal.supplyerInvoice);
  static final SupplyerInvoiceDB _instance = SupplyerInvoiceDB._internal();

  factory SupplyerInvoiceDB() {
    return _instance;
  }

  SupplyerInvoiceDB._internal();

  Future<List<Invoice>> getAllInvoices() async {
    final List invoiceData = await _storage.getValues().toList() ?? [];
    return invoiceData.map((data) => Invoice.fromJson(data)).toList();
  }

  Invoice getInvoice(String invoiceId) {
    Invoice invoice = Invoice.fromJson(_storage.read(invoiceId));
    return invoice;
  }

  Future<void> addInvoice(Invoice invoice) async {
    List<Cart> cartList =
        invoice.itemList.map((item) => Cart.fromInvoiceItem(item)).toList();
    await ItemDB().returnFromCart(cartList);
    await _storage.write(invoice.invoiceId, invoice.toJson());
  }

  Future<void> updateInvoice(Invoice updatedInvoice) async {
    await _storage.write(updatedInvoice.invoiceId, updatedInvoice.toJson());
  }

  Future<void> deleteInvoice(Invoice invoice) async {
    List<Cart> cartList =
        invoice.itemList.map((item) => Cart.fromInvoiceItem(item)).toList();
    await ItemDB().copyItemsInInvoice(cartList);
    await _storage.remove(invoice.invoiceId);
  }

  Future<void> eraseAllSupplyInvoices() async {
    await _storage.erase();
    await GetStorage().remove(DBVal.supplyerId);
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
}
