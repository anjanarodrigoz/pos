import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pos/database/item_db_service.dart';
import 'package:pos/utils/val.dart';
import '../models/cart.dart';
import '../models/invoice.dart';
import '../models/supply_invoice.dart';
import 'abstract_db.dart'; // Assuming you have an Invoice model

class SupplyerInvoiceDB implements AbstractDB {
  final _storage = GetStorage(DBVal.supplyerInvoice);
  static final SupplyerInvoiceDB _instance = SupplyerInvoiceDB._internal();

  factory SupplyerInvoiceDB() {
    return _instance;
  }

  SupplyerInvoiceDB._internal();

  Future<List<SupplyInvoice>> getAllInvoices() async {
    final List invoiceData = await _storage.getValues().toList() ?? [];
    return invoiceData.map((data) => SupplyInvoice.fromJson(data)).toList();
  }

  Future<List<SupplyInvoice>> getReturnNotes() async {
    final List invoiceData = await _storage.getValues().toList() ?? [];

    List<SupplyInvoice> returnNotes = [];

    for (var data in invoiceData) {
      SupplyInvoice invoice = SupplyInvoice.fromJson(data);
      if (invoice.isReturnNote) {
        returnNotes.add(invoice);
      }
    }

    return returnNotes;
  }

  Future<List<SupplyInvoice>> getNormalInvoice() async {
    final List invoiceData = await _storage.getValues().toList() ?? [];

    List<SupplyInvoice> returnNotes = [];

    for (var data in invoiceData) {
      SupplyInvoice invoice = SupplyInvoice.fromJson(data);
      if (!invoice.isReturnNote) {
        returnNotes.add(invoice);
      }
    }

    return returnNotes;
  }

  SupplyInvoice getInvoice(String invoiceId) {
    SupplyInvoice invoice = SupplyInvoice.fromJson(_storage.read(invoiceId));
    return invoice;
  }

  Future<void> addInvoice(SupplyInvoice invoice) async {
    List<Cart> cartList =
        invoice.itemList.map((item) => Cart.fromInvoiceItem(item)).toList();
    await ItemDB().returnFromCart(cartList);
    await _storage.write(invoice.invoiceId, invoice.toJson());
  }

  Future<void> updateInvoice(SupplyInvoice updatedInvoice) async {
    await _storage.write(updatedInvoice.invoiceId, updatedInvoice.toJson());
  }

  Future<void> deleteInvoice(SupplyInvoice invoice) async {
    List<Cart> cartList =
        invoice.itemList.map((item) => Cart.fromInvoiceItem(item)).toList();
    await ItemDB().copyItemsInInvoice(cartList);
    await updateInvoice(invoice.copyWith(
        extraCharges: [],
        itemList: [],
        comments: ['This invoice has been deleted']));
  }

  Future<List<SupplyInvoice>> searchInvoiceByDate(DateTimeRange dateTimeRange,
      {bool isReturnNote = false}) async {
    List<SupplyInvoice> allInvoice =
        isReturnNote ? await getReturnNotes() : await getAllInvoices();

    return allInvoice
        .where((element) =>
            element.createdDate.isAfter(dateTimeRange.start) &&
            element.createdDate.isBefore(dateTimeRange.end))
        .toList();
  }

  @override
  Future<void> deleteDB() async {
    await _storage.erase();
    await GetStorage().remove(DBVal.supplyerInvoiceId);
  }

  String generateInvoiceId() {
    final storage = GetStorage();
    final lastId = storage.read(DBVal.supplyerInvoiceId) ?? '0';
    final lastNumber = int.tryParse(lastId) ?? 0;

    final nextNumber = lastNumber + 1;
    return '$nextNumber';
  }

  Future<void> saveLastId(String newId) async {
    final storage = GetStorage();
    await storage.write(DBVal.supplyerInvoiceId, newId);
  }

  String generateReturnNoteId() {
    final storage = GetStorage();
    String lastId = storage.read(DBVal.returnNoteId) ?? '0';
    lastId = lastId.replaceAll('R', '');
    final lastNumber = int.tryParse(lastId.trim()) ?? 0;

    final nextNumber = lastNumber + 1;
    return 'R$nextNumber';
  }

  Future<void> saveReturnNoteId(String newId) async {
    final storage = GetStorage();
    await storage.write(DBVal.returnNoteId, newId);
  }

  Stream<List<SupplyInvoice>> getStreamInvoice() async* {
    StreamController<List<SupplyInvoice>> streamController =
        StreamController<List<SupplyInvoice>>();
    List<SupplyInvoice> invoiceList = await getAllInvoices();
    streamController.add(invoiceList);
    _storage.listen(() async {
      invoiceList.clear();

      invoiceList = await getAllInvoices();
      streamController.add(invoiceList);
    });

    yield* streamController.stream;
  }

  @override
  Future<Map> backupData() async {
    final List supplyerInvoiceData = await _storage.getValues().toList() ?? [];
    final lastId = GetStorage().read(DBVal.supplyerInvoiceId) ?? '0';
    final returnNoteId = GetStorage().read(DBVal.returnNoteId) ?? '0';

    return {
      DBVal.supplyerInvoice: supplyerInvoiceData,
      DBVal.supplyerInvoiceId: lastId,
      DBVal.returnNoteId: returnNoteId
    };
  }

  @override
  Future<void> insertData(Map json) async {
    final List supplyerInvoiceData = json[DBVal.supplyerInvoice];
    final lastId = json[DBVal.supplyerInvoiceId];
    final returnNoteId = json[DBVal.returnNoteId];

    for (var data in supplyerInvoiceData) {
      await addInvoice(SupplyInvoice.fromJson(data));
    }

    saveLastId(lastId);
    saveReturnNoteId(returnNoteId);
  }

  @override
  getName() {
    // TODO: implement getName
    return DBVal.supplyerInvoice;
  }
}
