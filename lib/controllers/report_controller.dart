import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/database/credit_db_serive.dart';
import 'package:pos/database/customer_db_service.dart';
import 'package:pos/database/invoice_db_service.dart';
import 'package:pos/database/item_db_service.dart';
import 'package:pos/database/quatation_db_serive.dart';
import 'package:pos/database/supplyer_invoice_db_service.dart';
import 'package:pos/enums/enums.dart';
import 'package:pos/models/customer.dart';
import 'package:pos/models/extra_charges.dart';
import 'package:pos/models/invoice_item.dart';
import 'package:pos/models/payment.dart';
import 'package:pos/models/supply_invoice.dart';
import 'package:pos/utils/my_format.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../models/invoice.dart';
import '../models/item.dart';

class ReportController extends GetxController {
  late DateTimeRange dateTimeRange =
      DateTimeRange(start: DateTime(0), end: DateTime(0));
  ReportPaymentFilter paidStatus = ReportPaymentFilter.all;
  bool isrecordAvaliable = false;
  RxList<GridColumn> columns = <GridColumn>[].obs;
  RxList<DataGridRow> rows = <DataGridRow>[].obs;
  RxMap<String, String> title = <String, String>{}.obs;
  bool isRequiredTableSummery = false;

  static const createdDateKey = "Date";
  static const invoiceIdKey = "Invoice Id";
  static const customerNameKey = "Customer Name";
  static const customerIdKey = "Customer ID";
  static const customerMobileKey = "Customer Mobile";
  static const supplyerNameKey = "Supplyer Name";
  static const supplyerIdKey = "Supplyer ID";
  static const supplyerMobileKey = "Supplyer Mobile";
  static const netKey = "Net Total";
  static const gstKey = "GST Total";
  static const totalKey = "Total";
  static const paykey = "To Pay";
  static const extraTotalKey = "Ex.Charges";
  static const itemTotalKey = "Itm.Charges";
  static const customerSaleKey = "Customer Sale";
  static const receiptsPriceKey = "Receipt Price";
  static const salepriceKey = "Sales Price";
  static const receiptsKey = "Receipts";
  static const itemIdKey = "Item ID";
  static const nameKey = "Item Name";
  static const quantityKey = "Quantity";
  static const soldKey = "Stock Sold";
  static const requireKey = "Stock Required";
  static const itempriceKey = "Item Net Price";
  static const priceKey = "Price";
  static const price2Key = "Price 2";
  static const price3Key = "Price 3";
  static const cityKey = "City";
  static const stateKey = "State";
  static const streetKey = "Street";
  static const outstanigKey = "Days";
  static const postalCodeKey = "Postal Code";

  Future<void> generateReport(
      {required DateTimeRange dateTimeRange,
      required ReportPaymentFilter paidStatus,
      required Map<String, String> title,
      required ReportType reportType}) async {
    this.dateTimeRange = dateTimeRange;
    this.paidStatus = paidStatus;
    this.title.value = title;
    this.paidStatus = paidStatus;

    switch (reportType) {
      case ReportType.invoice:
        await generateInvoiceReport(reportType);
      case ReportType.creditNote:
        await generateInvoiceReport(reportType);
      case ReportType.quote:
        await generateInvoiceReport(reportType);
      case ReportType.summery:
        await generateSummeryReport();
      case ReportType.itemInvoice:
        await generateItemsSummeryReport(reportType);
      case ReportType.itemCreditNote:
        await generateItemsSummeryReport(reportType);
      case ReportType.itemQuote:
        await generateItemsSummeryReport(reportType);
      case ReportType.itemInvoicedItem:
      case ReportType.supplyInvoice:
        await generateSupplyInvoiceReport();
      case ReportType.supplyItem:
        await generateItemsSummeryReport(reportType);
      case ReportType.stockRequired:
        await generateStockRequiredReport();
      case ReportType.stockQuantity:
        await generateStockQuantityReport();
      case ReportType.customerDetails:
        await generateCustomerDetailsReport();
      case ReportType.outstanding:
        await generateCustomerOutstandingReport();
      case ReportType.stockValue:
        await generateStockValueReport();
    }
  }

  /*




    Calculate invoice,Credit note,Quatation reports
  
  
  
  
  */

  Future<void> generateInvoiceReport(ReportType reportType) async {
    List<Invoice> searchInvoiceList = [];

    isRequiredTableSummery = true;

    if (reportType == ReportType.invoice) {
      searchInvoiceList =
          await InvoiceDB().searchInvoiceByDate(dateTimeRange, paidStatus);
    } else if (reportType == ReportType.creditNote) {
      searchInvoiceList =
          await CreditNoteDB().searchInvoiceByDate(dateTimeRange, paidStatus);
    } else {
      searchInvoiceList =
          await QuotationDB().searchInvoiceByDate(dateTimeRange, paidStatus);
    }

    if (searchInvoiceList.isEmpty) {
      isrecordAvaliable = false;
      return;
    }

    isrecordAvaliable = true;

    columns.value = {
      createdDateKey: 'Date',
      invoiceIdKey: 'Invoice Id',
      customerNameKey: 'Customer Name',
      customerIdKey: 'Customer ID',
      customerMobileKey: 'Customer Mobile',
      netKey: 'Net Total',
      gstKey: 'Gst Total',
      totalKey: 'Total',
      paykey: 'To Pay',
    }.entries.map(
      (e) {
        if (e.key == customerIdKey || e.key == customerNameKey) {
          return GridColumn(
              allowFiltering: true,
              columnName: e.key,
              label: Center(child: Text(e.value)));
        }

        if (e.key == netKey ||
            e.key == gstKey ||
            e.key == totalKey ||
            e.key == paykey) {
          return GridColumn(
              width: 100.0,
              allowFiltering: false,
              columnName: e.key,
              label: Center(child: Text(e.value)));
        }

        return GridColumn(
            allowFiltering: false,
            columnName: e.key,
            label: Center(child: Text(e.value)));
      },
    ).toList();

    rows.value = searchInvoiceList
        .map((invoice) => {
              createdDateKey: invoice.createdDate,
              invoiceIdKey: invoice.invoiceId,
              customerNameKey: invoice.customerName,
              customerIdKey: invoice.customerId,
              customerMobileKey: invoice.customerMobile,
              netKey: invoice.totalNetPrice,
              gstKey: invoice.totalGstPrice,
              totalKey: invoice.total,
              paykey: invoice.toPay,
            })
        .toList()
        .map((e) => DataGridRow(
                cells: e.entries.map((cell) {
              if (cell.key == netKey) {
                return DataGridCell<double>(
                    columnName: cell.key,
                    value: double.parse(
                        (cell.value as double).toStringAsFixed(2)));
              }

              if (cell.value is DateTime) {
                return DataGridCell(
                    columnName: cell.key,
                    value: MyFormat.formatDateTwo(cell.value as DateTime));
              }
              return DataGridCell(columnName: cell.key, value: cell.value);
            }).toList()))
        .toList();
  }

  /*
  
  
  
   Calculate turnover summery report in given date
  
  
  
  */

  Future<void> generateSummeryReport() async {
    isRequiredTableSummery = false;
    List<Invoice> searchInvoiceList =
        await InvoiceDB().searchInvoiceByDate(dateTimeRange, paidStatus);
    if (searchInvoiceList.isEmpty) {
      isrecordAvaliable = false;
      return;
    }

    isrecordAvaliable = true;
    double invoiceNet = 0.00;
    double invoiceGst = 0.00;
    double creditNotesNet = 0.00;
    double creditNotesGst = 0.00;
    double totalSale = 0.00;

    double chaques = 0.00;
    double cash = 0.00;
    double creditCard = 0.00;
    double bankTrnasfer = 0.00;
    double totalReceipts = 0.00;

    for (Invoice invoice in searchInvoiceList) {
      invoiceNet += double.parse(invoice.totalNetPrice.toStringAsFixed(2));
      invoiceGst += invoice.totalGstPrice;
      totalSale += invoice.total;

      for (Payment payment in invoice.payments ?? []) {
        switch (payment.paymethod) {
          case Paymethod.cash:
            cash += payment.amount;

          case Paymethod.card:
            creditCard += payment.amount;

          case Paymethod.bankTransfer:
            bankTrnasfer += payment.amount;

          case Paymethod.cheque:
            chaques += payment.amount;

          case Paymethod.pdCash:
            chaques += payment.amount;
        }
      }
    }

    totalReceipts = cash + creditCard + chaques + bankTrnasfer;

    columns.value = {
      customerSaleKey: 'Customer Sale',
      salepriceKey: '',
      receiptsKey: 'Receipts',
      receiptsPriceKey: '',
    }
        .entries
        .map(
          (e) => GridColumn(
              allowFiltering: false,
              columnName: e.key,
              label: Center(child: Text(e.value))),
        )
        .toList();

    rows.value = [
      ["Invoice Net", invoiceNet, "Cheques", chaques],
      ["Invoice GST", invoiceGst, "Cash", cash],
      ["Credit Note Net", creditNotesNet, "Credit Card", creditCard],
      ["Credit Note GST", creditNotesGst, "Bank Transfer", bankTrnasfer],
      ["Total Sale", totalSale, "Total Receipts", totalReceipts],
    ]
        .map((item) => {
              customerSaleKey: item[0],
              salepriceKey: item[1],
              receiptsKey: item[2],
              receiptsPriceKey: item[3]
            })
        .toList()
        .map((e) => DataGridRow(
                cells: e.entries.map((cell) {
              if (cell.value is double) {
                return DataGridCell(
                    columnName: cell.key,
                    value: MyFormat.formatCurrency(cell.value as double));
              }
              return DataGridCell(columnName: cell.key, value: cell.value);
            }).toList()))
        .toList();
  }

  /* 



  caculate Items report invoice,credit note and quatation
  
  
  
  
  */

  Future<void> generateItemsSummeryReport(reportType) async {
    List searchInvoiceList = [];

    isRequiredTableSummery = true;

    if (reportType == ReportType.itemInvoice) {
      searchInvoiceList =
          await InvoiceDB().searchInvoiceByDate(dateTimeRange, paidStatus);
    } else if (reportType == ReportType.itemCreditNote) {
      searchInvoiceList =
          await CreditNoteDB().searchInvoiceByDate(dateTimeRange, paidStatus);
    } else if (reportType == ReportType.quote) {
      searchInvoiceList =
          await QuotationDB().searchInvoiceByDate(dateTimeRange, paidStatus);
    } else {
      searchInvoiceList =
          await SupplyerInvoiceDB().searchInvoiceByDate(dateTimeRange);
    }

    if (searchInvoiceList.isEmpty) {
      isrecordAvaliable = false;
      return;
    }

    isrecordAvaliable = true;
    Map<String, InvoicedItem> itemMap = {};
    Map<String, ExtraCharges> extraMap = {};

    for (var invoice in searchInvoiceList) {
      for (InvoicedItem item in invoice.itemList) {
        String itemkey = item.itemId + item.netPrice.toStringAsFixed(2);

        itemMap[itemkey] == null
            ? itemMap[itemkey] = item
            : itemMap[itemkey] =
                itemMap[itemkey]!.updateQuantity(qty: item.qty);
      }

      for (ExtraCharges extraItem in invoice.extraCharges ?? []) {
        String itemkey = extraItem.name + extraItem.price.toStringAsFixed(2);
        extraMap[itemkey] == null
            ? extraMap[itemkey] = extraItem
            : extraMap[itemkey] =
                extraMap[itemkey]!.updateQuantity(qty: extraItem.qty);
      }
    }

    columns.value = {
      itemIdKey: itemIdKey,
      nameKey: nameKey,
      itempriceKey: itempriceKey,
      quantityKey: quantityKey,
      netKey: netKey,
      gstKey: gstKey,
      totalKey: totalKey
    }
        .entries
        .map(
          (e) => e.key == itemIdKey
              ? GridColumn(
                  allowFiltering: true,
                  columnName: e.key,
                  label: Center(child: Text(e.value)))
              : (e.key == netKey || e.key == gstKey || e.key == totalKey)
                  ? GridColumn(
                      width: 120.0,
                      allowFiltering: false,
                      columnName: e.key,
                      label: Center(child: Text(e.value)))
                  : GridColumn(
                      allowFiltering: false,
                      columnName: e.key,
                      label: Center(child: Text(e.value))),
        )
        .toList();

    rows.clear();

    itemMap.forEach((key, value) {
      rows.add(DataGridRow(
          cells: {
        itemIdKey: value.itemId,
        nameKey: value.name,
        itempriceKey: value.netPrice,
        quantityKey: value.qty,
        netKey: value.netTotal,
        gstKey: value.gstTotal,
        totalKey: value.total
      }.entries.map((cell) {
        if (cell.key == netKey || cell.key == itempriceKey) {
          return DataGridCell<double>(
              columnName: cell.key,
              value: double.parse((cell.value as double).toStringAsFixed(2)));
        }
        return DataGridCell(columnName: cell.key, value: cell.value);
      }).toList()));
    });

    extraMap.forEach((key, value) {
      rows.add(DataGridRow(
          cells: {
        itemIdKey: '',
        nameKey: value.name,
        itempriceKey: value.price,
        quantityKey: value.qty,
        netKey: value.netTotal,
        gstKey: value.totalGst,
        totalKey: value.totalPrice
      }.entries.map((cell) {
        if (cell.key == netKey || cell.key == itempriceKey) {
          return DataGridCell<double>(
              columnName: cell.key,
              value: double.parse((cell.value as double).toStringAsFixed(2)));
        }
        return DataGridCell(columnName: cell.key, value: cell.value);
      }).toList()));
    });
  }

  /*


    Create supply invoices

  */

  Future<void> generateSupplyInvoiceReport() async {
    isRequiredTableSummery = true;
    List<SupplyInvoice> supplyInvoiceList =
        await SupplyerInvoiceDB().searchInvoiceByDate(dateTimeRange);

    if (supplyInvoiceList.isEmpty) {
      isrecordAvaliable = false;
      return;
    }

    isrecordAvaliable = true;

    columns.value = {
      createdDateKey: createdDateKey,
      invoiceIdKey: invoiceIdKey,
      supplyerNameKey: supplyerNameKey,
      supplyerIdKey: supplyerIdKey,
      supplyerMobileKey: supplyerMobileKey,
      netKey: netKey,
      gstKey: gstKey,
      totalKey: totalKey,
    }.entries.map(
      (e) {
        if (e.key == supplyerIdKey || e.key == supplyerNameKey) {
          return GridColumn(
              allowFiltering: true,
              columnName: e.key,
              label: Center(child: Text(e.value)));
        }

        if (e.key == netKey || e.key == gstKey || e.key == totalKey) {
          return GridColumn(
              width: 100.0,
              allowFiltering: false,
              columnName: e.key,
              label: Center(child: Text(e.value)));
        }

        return GridColumn(
            allowFiltering: false,
            columnName: e.key,
            label: Center(child: Text(e.value)));
      },
    ).toList();

    rows.value = supplyInvoiceList
        .map((invoice) => {
              createdDateKey: invoice.createdDate,
              invoiceIdKey: invoice.invoiceId,
              supplyerNameKey: invoice.supplyerName,
              supplyerIdKey: invoice.supplyerId,
              supplyerMobileKey: invoice.supplyerMobile,
              netKey: invoice.totalNetPrice,
              gstKey: invoice.totalGstPrice,
              totalKey: invoice.total,
            })
        .toList()
        .map((e) => DataGridRow(
                cells: e.entries.map((cell) {
              if (cell.key == netKey) {
                return DataGridCell<double>(
                    columnName: cell.key,
                    value: double.parse(
                        (cell.value as double).toStringAsFixed(2)));
              }

              if (cell.value is DateTime) {
                return DataGridCell(
                    columnName: cell.key,
                    value: MyFormat.formatDateTwo(cell.value as DateTime));
              }
              return DataGridCell(columnName: cell.key, value: cell.value);
            }).toList()))
        .toList();
  }

  /*
  
    Stock sold and stock required report
  
  
   */
  Future<void> generateStockRequiredReport() async {
    isRequiredTableSummery = false;
    List searchInvoiceList = [];

    searchInvoiceList =
        await InvoiceDB().searchInvoiceByDate(dateTimeRange, paidStatus);

    if (searchInvoiceList.isEmpty) {
      isrecordAvaliable = false;
      return;
    }

    isrecordAvaliable = true;
    Map<String, InvoicedItem> itemMap = {};

    for (var invoice in searchInvoiceList) {
      for (InvoicedItem item in invoice.itemList) {
        String itemkey = item.itemId;

        itemMap[itemkey] == null
            ? itemMap[itemkey] = item
            : itemMap[itemkey] =
                itemMap[itemkey]!.updateQuantity(qty: item.qty);
      }
    }

    columns.value = {
      itemIdKey: itemIdKey,
      nameKey: nameKey,
      soldKey: soldKey,
      requireKey: requireKey,
    }
        .entries
        .map(
          (e) => GridColumn(
              allowFiltering: false,
              columnName: e.key,
              label: Center(child: Text(e.value))),
        )
        .toList();

    rows.clear();

    itemMap.forEach((key, value) {
      rows.add(DataGridRow(
          cells: {
        itemIdKey: value.itemId,
        nameKey: value.name,
        soldKey: value.qty,
        requireKey: value.qty,
      }.entries.map((cell) {
        return DataGridCell(columnName: cell.key, value: cell.value);
      }).toList()));
    });
  }

/*
  
    Stock Quantity report
  
  
   */

  Future<void> generateStockQuantityReport() async {
    isRequiredTableSummery = false;
    List<Item> itemList = [];

    itemList = await ItemDB().getAllItems();

    if (itemList.isEmpty) {
      isrecordAvaliable = false;
      return;
    }

    isrecordAvaliable = true;

    columns.value = {
      itemIdKey: itemIdKey,
      nameKey: nameKey,
      quantityKey: quantityKey,
      priceKey: priceKey,
      price2Key: price2Key,
      price3Key: price3Key,
    }
        .entries
        .map(
          (e) => GridColumn(
              allowFiltering: false,
              columnName: e.key,
              label: Center(child: Text(e.value))),
        )
        .toList();

    rows.value = itemList
        .map((item) => DataGridRow(
                cells: {
              itemIdKey: item.id,
              nameKey: item.name,
              quantityKey: item.qty,
              priceKey: item.price,
              price2Key: item.priceTwo,
              price3Key: item.priceThree,
            }
                    .entries
                    .map((e) => DataGridCell(columnName: e.key, value: e.value))
                    .toList()))
        .toList();
  }

  /*
  
  
  
  
  
  
  
  
   */

  Future<void> generateCustomerDetailsReport() async {
    isRequiredTableSummery = false;
    List<Customer> customersList = await CustomerDB().getAllCustomers();

    if (customersList.isEmpty) {
      isrecordAvaliable = false;
      return;
    }

    isrecordAvaliable = true;

    columns.value = {
      customerIdKey: customerIdKey,
      customerNameKey: customerNameKey,
      customerMobileKey: customerMobileKey,
      streetKey: streetKey,
      cityKey: cityKey,
      stateKey: stateKey,
      postalCodeKey: postalCodeKey,
    }
        .entries
        .map((e) => GridColumn(
            allowFiltering: false,
            columnName: e.key,
            label: Center(child: Text(e.value))))
        .toList();

    rows.value = customersList
        .map((customer) => DataGridRow(
                cells: {
              customerIdKey: customer.id,
              customerNameKey: '${customer.firstName} ${customer.lastName}',
              customerMobileKey: customer.mobileNumber,
              streetKey: customer.deliveryAddress == null
                  ? " "
                  : customer.deliveryAddress!.street,
              cityKey: customer.deliveryAddress == null
                  ? " "
                  : customer.deliveryAddress!.city,
              stateKey: customer.deliveryAddress == null
                  ? " "
                  : customer.deliveryAddress!.state,
              postalCodeKey: customer.deliveryAddress == null
                  ? " "
                  : customer.deliveryAddress!.postalCode,
            }
                    .entries
                    .map((e) => DataGridCell(columnName: e.key, value: e.value))
                    .toList()))
        .toList();
  }

/*







 */

  Future<void> generateCustomerOutstandingReport() async {
    List<Invoice> searchInvoiceList = [];

    isRequiredTableSummery = true;

    searchInvoiceList = await InvoiceDB()
        .searchInvoiceByDate(dateTimeRange, ReportPaymentFilter.notPaid);

    if (searchInvoiceList.isEmpty) {
      isrecordAvaliable = false;
      return;
    }

    isrecordAvaliable = true;

    columns.value = {
      createdDateKey: createdDateKey,
      invoiceIdKey: invoiceIdKey,
      customerNameKey: customerNameKey,
      customerIdKey: customerIdKey,
      customerMobileKey: customerMobileKey,
      netKey: netKey,
      gstKey: gstKey,
      totalKey: totalKey,
      paykey: paykey,
      outstanigKey: outstanigKey
    }.entries.map(
      (e) {
        if (e.key == customerIdKey || e.key == customerNameKey) {
          return GridColumn(
              allowFiltering: true,
              columnName: e.key,
              label: Center(child: Text(e.value)));
        }

        if (e.key == netKey ||
            e.key == gstKey ||
            e.key == totalKey ||
            e.key == paykey) {
          return GridColumn(
              width: 100.0,
              allowFiltering: false,
              columnName: e.key,
              label: Center(child: Text(e.value)));
        }

        return GridColumn(
            allowFiltering: false,
            columnName: e.key,
            label: Center(child: Text(e.value)));
      },
    ).toList();

    rows.value = searchInvoiceList
        .map((invoice) => {
              createdDateKey: invoice.createdDate,
              invoiceIdKey: invoice.invoiceId,
              customerNameKey: invoice.customerName,
              customerIdKey: invoice.customerId,
              customerMobileKey: invoice.customerMobile,
              netKey: invoice.totalNetPrice,
              gstKey: invoice.totalGstPrice,
              totalKey: invoice.total,
              paykey: invoice.toPay,
              outstanigKey:
                  DateTime.now().difference(invoice.createdDate).inDays
            })
        .toList()
        .map((e) => DataGridRow(
                cells: e.entries.map((cell) {
              if (cell.key == netKey) {
                return DataGridCell<double>(
                    columnName: cell.key,
                    value: double.parse(
                        (cell.value as double).toStringAsFixed(2)));
              }

              if (cell.value is DateTime) {
                return DataGridCell(
                    columnName: cell.key,
                    value: MyFormat.formatDateTwo(cell.value as DateTime));
              }
              return DataGridCell(columnName: cell.key, value: cell.value);
            }).toList()))
        .toList();
  }

  Future<void> generateStockValueReport() async {
    isRequiredTableSummery = true;
    List<Item> itemList = [];

    itemList = await ItemDB().getAllItems();

    if (itemList.isEmpty) {
      isrecordAvaliable = false;
      return;
    }

    isrecordAvaliable = true;

    columns.value = {
      itemIdKey: itemIdKey,
      nameKey: nameKey,
      quantityKey: quantityKey,
      priceKey: priceKey,
      netKey: netKey,
      gstKey: gstKey,
      totalKey: totalKey,
    }
        .entries
        .map(
          (e) => GridColumn(
              allowFiltering: false,
              columnName: e.key,
              label: Center(child: Text(e.value))),
        )
        .toList();

    rows.value = itemList
        .map((item) => DataGridRow(
                cells: {
              itemIdKey: item.id,
              nameKey: item.name,
              quantityKey: item.qty,
              priceKey: item.price,
              netKey: item.netStock,
              gstKey: item.gstStock,
              totalKey: item.totalStock
            }
                    .entries
                    .map((e) => DataGridCell(columnName: e.key, value: e.value))
                    .toList()))
        .toList();
  }

  bool checkDate() {
    return (dateTimeRange.end.difference(dateTimeRange.start).inDays) == 1
        ? true
        : false;
  }
}
