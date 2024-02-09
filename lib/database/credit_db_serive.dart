import 'dart:async';
import 'package:flutter/src/material/date.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pos/enums/enums.dart';
import 'package:pos/utils/val.dart';
import '../models/invoice.dart';
import 'abstract_db.dart'; // Assuming you have an Invoice model

class CreditNoteDB implements AbstractDB {
  final _storage = GetStorage(DBVal.creditNote);
  static final CreditNoteDB _instance = CreditNoteDB._internal();

  factory CreditNoteDB() {
    return _instance;
  }

  CreditNoteDB._internal();

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
    _storage.remove(invoice.invoiceId);
  }

  String generateInvoiceId() {
    final storage = GetStorage();
    final lastId = storage.read(DBVal.creditNoteId) ?? '0';
    final lastNumber = int.tryParse(lastId) ?? 0;

    final nextNumber = lastNumber + 1;
    return '$nextNumber';
  }

  Future<void> saveLastId(String newId) async {
    final storage = GetStorage();
    await storage.write(DBVal.creditNoteId, newId);
  }

  @override
  Future<void> deleteDB() async {
    await _storage.erase();
    await GetStorage().remove(DBVal.creditNoteId);
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

  @override
  Future<Map> backupData() async {
    final List creditData = await _storage.getValues().toList() ?? [];
    final lastId = GetStorage().read(DBVal.creditNoteId) ?? '1000';

    return {DBVal.creditNote: creditData, DBVal.creditNoteId: lastId};
  }

  @override
  Future<void> insertData(Map json) async {
    final List creditData = json[DBVal.creditNote];
    final lastId = json[DBVal.creditNoteId];

    for (var data in creditData) {
      await addInvoice(Invoice.fromJson(data));
    }

    saveLastId(lastId);
  }

  @override
  getName() {
    // TODO: implement getName
    return DBVal.creditNote;
  }

  Future<List<Invoice>> searchInvoiceByDate(
      DateTimeRange dateTimeRange, ReportPaymentFilter paidStatus) async {
    List<Invoice> allInvoice = await getAllInvoices();

    if (paidStatus != ReportPaymentFilter.all) {
      bool isPaid = paidStatus == ReportPaymentFilter.paid;
      return allInvoice
          .where((element) =>
              element.createdDate.isAfter(dateTimeRange.start) &&
              element.createdDate.isBefore(dateTimeRange.end) &&
              element.isPaid == isPaid)
          .toList();
    }

    return allInvoice
        .where((element) =>
            element.createdDate.isAfter(dateTimeRange.start) &&
            element.createdDate.isBefore(dateTimeRange.end))
        .toList();
  }
}
