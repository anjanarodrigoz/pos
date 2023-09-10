import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pos/Pages/main_window.dart';
import 'package:pos/Pages/stock_manager.dart/item_form.dart';
import 'package:pos/Pages/stock_manager.dart/item_view.dart';
import 'package:pos/Pages/stock_manager.dart/supply_invoice_page.dart';
import 'package:pos/theme/t_colors.dart';
import 'package:pos/widgets/pos_button.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:window_manager/window_manager.dart';

import '../../database/item_db_service.dart';
import '../../models/item.dart';
import '../../utils/my_format.dart';

class StockPage extends StatefulWidget {
  const StockPage({super.key});

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  late final _databaseService; // Use your DatabaseService class

  List<Item> _item = [];
  ItemDataSource itemDataSource = ItemDataSource(itemData: []);
  Function? disposeListen;

  @override
  void initState() {
    super.initState();
    _databaseService = ItemDB();

    disposeListen = GetStorage('Items').listen(() {
      getItemData();
    });
    getItemData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    disposeListen?.call();
  }

  @override
  Widget build(BuildContext context) {
    WindowOptions windowOptions = const WindowOptions(
        minimumSize: Size(1150, 800), size: Size(1150, 800), center: true);

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
    });
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Get.offAll(const MainWindow());
              },
              icon: const Icon(Icons.arrow_back_outlined)),
          backgroundColor: TColors.blue,
          title: Text(
            'Stock Page',
            style: TStyle.titleBarStyle,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  PosButton(
                      text: '+ Add Item',
                      onPressed: () {
                        Get.to(ItemFormPage());
                      }),
                  // PosButton(
                  //     text: 'Supplyer Invoice',
                  //     onPressed: () {
                  //       Get.to(SupplyInvoicePage());
                  //     })
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Expanded(
                child: SfDataGrid(
                  gridLinesVisibility: GridLinesVisibility.both,
                  headerGridLinesVisibility: GridLinesVisibility.both,
                  allowFiltering: true,
                  allowColumnsResizing: true,
                  showFilterIconOnHover: true,
                  columnWidthMode: ColumnWidthMode.auto,
                  source: itemDataSource,
                  onCellTap: ((details) {
                    if (details.rowColumnIndex.rowIndex != 0) {
                      int selectedRowIndex =
                          details.rowColumnIndex.rowIndex - 1;
                      var row = itemDataSource.effectiveRows
                          .elementAt(selectedRowIndex);

                      Get.to(ItemViewPage(
                          itemId: row.getCells()[0].value.toString()));
                    }
                  }),
                  columns: [
                    GridColumn(
                        columnName: Item.idKey,
                        label: Center(child: const Text('Item ID'))),
                    GridColumn(
                        columnName: Item.nameKey,
                        label: Center(child: const Text('Item Name'))),
                    GridColumn(
                        columnName: Item.qtyKey,
                        label: Center(child: const Text('Qty'))),
                    GridColumn(
                        columnName: Item.priceKey,
                        label: Center(child: const Text('Price'))),
                    GridColumn(
                        columnName: Item.priceTwoKey,
                        label: Center(child: const Text('Price 02'))),
                    GridColumn(
                        columnName: Item.priceThreeKey,
                        label: Center(child: const Text('Price 03'))),
                    GridColumn(
                        columnName: Item.priceFourKey,
                        label: Center(child: const Text('Price 04'))),
                    GridColumn(
                        columnName: Item.priceFiveKey,
                        label: Center(child: const Text('Price 05'))),
                    GridColumn(
                        columnName: Item.lastInDateKey,
                        label: Center(child: const Text('Last In Date'))),
                    GridColumn(
                        columnName: Item.lastOutDateKey,
                        label: Center(child: const Text('Last Out Date'))),

                    // Add more columns as needed
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Future<void> getItemData() async {
    _item = await _databaseService.getAllItems();
    itemDataSource = ItemDataSource(itemData: _item);
    setState(() {});
  }
}

class ItemDataSource extends DataGridSource {
  List<DataGridRow> _itemData = [];

  ItemDataSource({required List<Item> itemData}) {
    _itemData = itemData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell(columnName: Item.idKey, value: e.id),
              DataGridCell(columnName: Item.nameKey, value: e.name),
              DataGridCell(columnName: Item.qtyKey, value: e.qty),
              DataGridCell(
                  columnName: Item.priceKey,
                  value: MyFormat.formatCurrency(e.price)),
              DataGridCell(
                  columnName: Item.priceTwoKey,
                  value: MyFormat.formatCurrency(e.priceTwo)),
              DataGridCell(
                  columnName: Item.priceThreeKey,
                  value: MyFormat.formatCurrency(e.priceThree)),
              DataGridCell(
                  columnName: Item.priceFourKey,
                  value: MyFormat.formatCurrency(e.priceFour)),
              DataGridCell(
                  columnName: Item.priceFiveKey,
                  value: MyFormat.formatCurrency(e.priceFive)),
              DataGridCell(
                  columnName: Item.lastInDateKey,
                  value: e.lastInDate == null
                      ? ''
                      : MyFormat.formatDate(e.lastInDate!)),
              DataGridCell(
                  columnName: Item.lastOutDateKey,
                  value: e.lastOutDate == null
                      ? ''
                      : MyFormat.formatDate(e.lastOutDate!)),
            ]))
        .toList();
  }

  @override
  List<DataGridRow> get rows => _itemData;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    // TODO: implement buildRow
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Text(e.value.toString()),
      );
    }).toList());
  }
}
