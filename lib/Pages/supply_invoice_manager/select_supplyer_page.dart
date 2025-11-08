import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pos/Pages/supply_invoice_manager/supply_all_invoice.dart';
import 'package:pos/database/supplyer_db_service.dart';
import 'package:pos/models/address.dart';
import 'package:pos/models/supply_invoice.dart';
import 'package:pos/theme/t_colors.dart';
import 'package:pos/utils/constant.dart';
import 'package:pos/utils/val.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../controllers/suppy_invoice_draft_controller.dart';
import '../../models/supplyer.dart';
import 'supplyer_invoice_draft_page.dart';

class SelectSupplyerPage extends StatefulWidget {
  SupplyInvoice? supplyInvoice;
  bool isReturnManager;
  SelectSupplyerPage(
      {super.key, this.supplyInvoice, required this.isReturnManager});

  @override
  State<SelectSupplyerPage> createState() => _SelectSupplyerPageState();
}

class _SelectSupplyerPageState extends State<SelectSupplyerPage> {
  late final _databaseService; // Use your DatabaseService class
  late Supplyer supplyer;

  List<Supplyer> _supplyer = [];
  SupplyerDataSource supplyerDataSource = SupplyerDataSource(supplyersData: []);
  Function? disposeListen;
  final DataGridController _dataGridController = DataGridController();

  @override
  void initState() {
    super.initState();
    _databaseService = SupplyerDB();

    disposeListen = GetStorage(DBVal.supplyer).listen(() {
      getSupplyerData();
    });
    getSupplyerData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    disposeListen?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40.0,
        backgroundColor: TColors.blue,
        leading: IconButton(
            onPressed: () {
              Get.offAll(
                  SupplyAllInvoice(isReturnManager: widget.isReturnManager));
            },
            icon: const Icon(Icons.arrow_back_outlined)),
        title: Text(
          'Select Supplyer',
          style: TStyle.titleBarStyle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: SfDataGrid(
                controller: _dataGridController,
                gridLinesVisibility: GridLinesVisibility.both,
                headerGridLinesVisibility: GridLinesVisibility.both,
                allowFiltering: true,
                rowHeight: Const.tableRowHeight,
                allowColumnsResizing: true,
                showFilterIconOnHover: true,
                columnWidthMode: ColumnWidthMode.auto,
                source: supplyerDataSource,
                selectionMode: SelectionMode.single,
                onCellDoubleTap: ((details) async {
                  if (details.rowColumnIndex.rowIndex != 0) {
                    int selectedRowIndex = details.rowColumnIndex.rowIndex - 1;
                    var row = supplyerDataSource.effectiveRows
                        .elementAt(selectedRowIndex);

                    supplyer =
                        SupplyerDB().getSupplyer(row.getCells()[0].value);

                    Get.put(SupplyInvoiceDraftController(
                        supplyer: supplyer,
                        copyInvoice: widget.supplyInvoice,
                        isReturnManager: widget.isReturnManager));
                    Get.offAll(SupplyInvoiceDraftPage());
                  }
                }),
                columns: [
                  GridColumn(
                      columnName: Supplyer.idKey,
                      label: const Center(child: Text('ID'))),
                  GridColumn(
                      columnName: Supplyer.firstNameKey,
                      label: const Center(child: Text('First Name'))),
                  GridColumn(
                      columnName: Supplyer.lastNameKey,
                      label: const Center(child: Text('Last Name'))),
                  GridColumn(
                      columnName: Supplyer.mobileNumberKey,
                      label: const Center(child: Text('Mobile Number'))),
                  GridColumn(
                      columnName: Supplyer.emailKey,
                      label: const Center(child: Text('Email'))),
                  GridColumn(
                      columnName: Address.areaCodeKey,
                      label: const Center(child: Text('Area Code'))),
                  GridColumn(
                      columnName: Address.cityKey,
                      label: const Center(child: Text('City'))),
                  GridColumn(
                      columnName: Address.postalCodeKey,
                      label: const Center(child: Text('Postal Code'))),

                  // Add more columns as needed
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getSupplyerData() async {
    _supplyer = await _databaseService.getAllSupplyers();
    supplyerDataSource = SupplyerDataSource(supplyersData: _supplyer);
    setState(() {});
  }
}

class SupplyerDataSource extends DataGridSource {
  List<DataGridRow> _supplyerData = [];

  SupplyerDataSource({required List<Supplyer> supplyersData}) {
    _supplyerData = supplyersData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell(columnName: Supplyer.idKey, value: e.id),
              DataGridCell(
                  columnName: Supplyer.firstNameKey, value: e.firstName),
              DataGridCell(columnName: Supplyer.lastNameKey, value: e.lastName),
              DataGridCell(
                  columnName: Supplyer.mobileNumberKey, value: e.mobileNumber),
              DataGridCell(columnName: Supplyer.emailKey, value: e.email),
              DataGridCell(
                  columnName: Address.areaCodeKey,
                  value: e.address?.areaCode ?? ''),
              DataGridCell(
                  columnName: Address.cityKey, value: e.address?.city ?? ''),
              DataGridCell(
                  columnName: Address.postalCodeKey,
                  value: e.address?.postalCode ?? ''),
            ]))
        .toList();
  }

  @override
  List<DataGridRow> get rows => _supplyerData;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    // TODO: implement buildRow
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: Const.tableValuesPadding,
        child: Text(e.value.toString(), style: Const.tableValuesTextStyle),
      );
    }).toList());
  }
}
