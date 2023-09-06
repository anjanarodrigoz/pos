import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pos/Pages/supplyer_manager/supplyer_form.dart';
import 'package:pos/Pages/main_window.dart';
import 'package:pos/database/supplyer_db_service.dart';
import 'package:pos/models/address.dart';
import 'package:pos/theme/t_colors.dart';
import 'package:pos/utils/val.dart';
import 'package:pos/widgets/pos_button.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:window_manager/window_manager.dart';

import '../../database/supplyer_db_service.dart';
import '../../models/supplyer.dart';
import '../../models/supplyer.dart';
import 'supplyer_view.dart';

class SupplyerPage extends StatefulWidget {
  const SupplyerPage({super.key});

  @override
  State<SupplyerPage> createState() => _SupplyerPageState();
}

class _SupplyerPageState extends State<SupplyerPage> {
  late final _databaseService; // Use your DatabaseService class

  List<Supplyer> _supplyer = [];
  SupplyerDataSource supplyerDataSource = SupplyerDataSource(supplyersData: []);
  Function? disposeListen;

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
    WindowOptions windowOptions = const WindowOptions(
        minimumSize: Size(1150, 800), size: Size(1150, 800), center: true);

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColors.blue,
        leading: IconButton(
            onPressed: () {
              Get.offAll(const MainWindow());
            },
            icon: Icon(Icons.arrow_back_outlined)),
        title: Text(
          'Supplyers',
          style: TStyle.titleBarStyle,
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          PosButton(
              text: '+ New Supplyer',
              onPressed: () {
                Get.to(const SupplyerFormPage());
              }),
          SizedBox(
            height: 30.0,
          ),
          Expanded(
            child: SfDataGrid(
              gridLinesVisibility: GridLinesVisibility.both,
              headerGridLinesVisibility: GridLinesVisibility.both,
              allowFiltering: true,
              allowColumnsResizing: true,
              showFilterIconOnHover: true,
              columnWidthMode: ColumnWidthMode.auto,
              source: supplyerDataSource,
              onCellTap: ((details) {
                if (details.rowColumnIndex.rowIndex != 0) {
                  int selectedRowIndex = details.rowColumnIndex.rowIndex - 1;
                  var row = supplyerDataSource.effectiveRows
                      .elementAt(selectedRowIndex);

                  Get.to(SupplyerViewPage(
                      cusId: row.getCells()[0].value.toString()));
                }
              }),
              columns: [
                GridColumn(
                    columnName: Supplyer.idKey,
                    label: Center(child: const Text('ID'))),
                GridColumn(
                    columnName: Supplyer.firstNameKey,
                    label: Center(child: const Text('First Name'))),
                GridColumn(
                    columnName: Supplyer.lastNameKey,
                    label: Center(child: const Text('Last Name'))),
                GridColumn(
                    columnName: Supplyer.mobileNumberKey,
                    label: Center(child: const Text('Mobile Number'))),
                GridColumn(
                    columnName: Supplyer.emailKey,
                    label: Center(child: const Text('Email'))),
                GridColumn(
                    columnName: Address.areaCodeKey,
                    label: Center(child: const Text('Area Code'))),
                GridColumn(
                    columnName: Address.cityKey,
                    label: Center(child: const Text('City'))),
                GridColumn(
                    columnName: Address.postalCodeKey,
                    label: Center(child: const Text('Postal Code'))),

                // Add more columns as needed
              ],
            ),
          )
        ]),
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
        padding: EdgeInsets.all(8.0),
        child: Text(e.value.toString()),
      );
    }).toList());
  }
}
