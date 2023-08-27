import 'package:get_storage/get_storage.dart';
import 'package:pos/utils/val.dart';
import '../models/invoice.dart'; // Assuming you have an Invoice model

class InvoiceDB {
  final _storage = GetStorage('Invoices');
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

  Future<void> deleteInvoice(String invoiceId) async {
    await _storage.remove(invoiceId);
  }

  String generateInvoiceId() {
    final storage = GetStorage();
    final lastId = storage.read(DBVal.invoiceId) ?? '1000';
    final lastNumber = int.tryParse(lastId) ?? 1000;

    final nextNumber = lastNumber + 1;
    return '$nextNumber';
  }

  Future<void> saveLastId(String newId) async {
    final storage = GetStorage();
    await storage.write(DBVal.invoiceId, newId);
  }

  Future<void> eraseAllInvoices() async {
    await _storage.erase();
    await GetStorage().remove(DBVal.invoiceId);
  }
}
