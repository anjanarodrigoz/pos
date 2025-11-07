import 'package:flutter/material.dart';
import 'package:pos/models/item.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// DataSource for Syncfusion DataGrid to display items
class ItemDataSource extends DataGridSource {
  List<Item> itemData;

  ItemDataSource({required this.itemData}) {
    buildDataGridRows();
  }

  List<DataGridRow> dataGridRows = [];

  void buildDataGridRows() {
    dataGridRows = itemData.map<DataGridRow>((item) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: Item.idKey, value: item.id),
        DataGridCell<String>(columnName: Item.nameKey, value: item.name),
        DataGridCell<String>(
            columnName: Item.descriptionKey, value: item.description ?? ''),
        DataGridCell<double>(columnName: Item.priceKey, value: item.price),
        DataGridCell<double>(
            columnName: Item.buyingPriceKey, value: item.buyingPrice),
        DataGridCell<int>(columnName: Item.qtyKey, value: item.qty),
        DataGridCell<String>(
            columnName: Item.commentKey, value: item.comment ?? ''),
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
          alignment: dataGridCell.columnName == Item.qtyKey ||
                  dataGridCell.columnName == Item.priceKey ||
                  dataGridCell.columnName == Item.buyingPriceKey
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
