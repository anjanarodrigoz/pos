import 'package:flutter/material.dart';
import 'package:pos/enums/enums.dart';
import 'package:pos/models/invoice_row.dart';
import 'package:pos/theme/t_colors.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class InvoiceListDataSource extends DataGridSource {
  List<DataGridRow> _invoiceData = [];

  InvoiceListDataSource({required List<InvoiceRow> invoiceData}) {
    _invoiceData = invoiceData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell(columnName: InvoiceRow.itemIdKey, value: e.itemId),
              DataGridCell(columnName: InvoiceRow.nameKey, value: e.itemName),
              DataGridCell(columnName: InvoiceRow.qtyKey, value: e.qty),
              DataGridCell(
                  columnName: InvoiceRow.netPriceKey, value: (e.netPrice)),
              DataGridCell(columnName: InvoiceRow.gstKey, value: (e.gst)),
              DataGridCell(
                  columnName: InvoiceRow.itemPriceKey, value: (e.itemPrice)),
              DataGridCell(columnName: InvoiceRow.totalKey, value: (e.total)),
            ]))
        .toList();
  }

  @override
  List<DataGridRow> get rows => _invoiceData;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    // TODO: implement buildRow
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      if (e.columnName == InvoiceRow.itemIdKey) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          alignment: Alignment.center,
          child: Text(
            e.value.values.toList()[0].toString(),
            style: const TextStyle(fontSize: 13.0),
          ),
        );
      }
      if (e.columnName == InvoiceRow.nameKey) {
        String value = e.value.values.toList()[0].toString();
        InvoiceItemCategory itemCategory = e.value.keys.toList()[0];
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          alignment: Alignment.centerLeft,
          child: Text(
            itemCategory == InvoiceItemCategory.empty ? '' : value,
            style: TextStyle(
                fontSize:
                    itemCategory == InvoiceItemCategory.comment ? 12.0 : 13.0,
                fontWeight: itemCategory == InvoiceItemCategory.comment
                    ? FontWeight.w500
                    : FontWeight.w700,
                color: itemCategory == InvoiceItemCategory.comment
                    ? TColors.blue
                    : Colors.black),
          ),
        );
      }

      if (e.columnName == InvoiceRow.gstKey ||
          e.columnName == InvoiceRow.netPriceKey ||
          e.columnName == InvoiceRow.totalKey ||
          e.columnName == InvoiceRow.itemPriceKey) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          alignment: Alignment.centerRight,
          child: Text(
            e.value.toString(),
            style: const TextStyle(fontSize: 13.0),
          ),
        );
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        alignment: Alignment.center,
        child: Text(
          e.value.toString(),
          style: const TextStyle(fontSize: 13.0),
        ),
      );
    }).toList());
  }
}
