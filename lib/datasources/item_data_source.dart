import 'package:flutter/material.dart';
import 'package:pos/database/pos_database.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// DataSource for Syncfusion DataGrid to display items in invoice selection
class ItemDataSource extends DataGridSource {
  List<Item> itemData;

  ItemDataSource({required this.itemData}) {
    buildDataGridRows();
  }

  List<DataGridRow> dataGridRows = [];

  void buildDataGridRows() {
    dataGridRows = itemData.map<DataGridRow>((item) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'id', value: item.id),
        DataGridCell<String>(columnName: 'itemCode', value: item.itemCode),
        DataGridCell<String>(columnName: 'name', value: item.name),
        DataGridCell<String>(
            columnName: 'description', value: item.description ?? ''),
        DataGridCell<double>(columnName: 'price', value: item.price),
        DataGridCell<int>(columnName: 'quantity', value: item.quantity),
        DataGridCell<String>(columnName: 'category', value: item.category ?? ''),
      ]);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataGridCell) {
        return Container(
          alignment: dataGridCell.columnName == 'quantity' ||
                  dataGridCell.columnName == 'price'
              ? Alignment.centerRight
              : Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            dataGridCell.value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
    );
  }

  void updateDataSource() {
    buildDataGridRows();
    notifyListeners();
  }
}
