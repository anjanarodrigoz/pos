import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:pos/Pages/supplyer_manager/supplyer_form.dart';
import 'package:pos/Pages/main_window.dart';
import 'package:pos/database/supplyer_db_service.dart';
import 'package:pos/models/address.dart';
import 'package:pos/theme/t_colors.dart';
import 'package:pos/widgets/pos_appbar.dart';
import 'package:pos/widgets/pos_button.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../models/supplyer.dart';
import 'supplyer_view.dart';

class SupplyerPage extends StatelessWidget {
  SupplyerPage({super.key});

  List<Supplyer> _supplyer = [];
  SupplyerDataSource supplyerDataSource = SupplyerDataSource(supplyersData: []);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PosAppBar(title: 'Supplyers'),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          PosButton(
              text: '+ New Supplyer',
              onPressed: () {
                Get.to(const SupplyerFormPage());
              }),
          const SizedBox(
            height: 30.0,
          ),
          Expanded(
            child: StreamBuilder<List<Supplyer>>(
                stream: SupplyerDB().getStreamAllSupplyer(),
                builder: (context, snapshot) {
                  _supplyer.clear();
                  _supplyer = snapshot.data ?? [];
                  supplyerDataSource =
                      SupplyerDataSource(supplyersData: _supplyer);
                  return SfDataGrid(
                    gridLinesVisibility: GridLinesVisibility.both,
                    headerGridLinesVisibility: GridLinesVisibility.both,
                    allowFiltering: true,
                    allowColumnsResizing: true,
                    rowHeight: 30.0,
                    showFilterIconOnHover: true,
                    columnWidthMode: ColumnWidthMode.auto,
                    source: supplyerDataSource,
                    onCellDoubleTap: ((details) {}),
                    onCellTap: ((details) {
                      if (details.rowColumnIndex.rowIndex != 0) {
                        int selectedRowIndex =
                            details.rowColumnIndex.rowIndex - 1;
                        var row = supplyerDataSource.effectiveRows
                            .elementAt(selectedRowIndex);

                        Get.to(SupplyerViewPage(
                            supplyId: row.getCells()[0].value.toString()));
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
                          columnName: Address.streetKey,
                          label: Center(child: const Text('Street'))),

                      GridColumn(
                          columnName: Address.cityKey,
                          label: Center(child: const Text('City'))),
                      GridColumn(
                          columnName: Address.stateKey,
                          label: Center(child: const Text('State'))),
                      GridColumn(
                          columnName: Address.postalCodeKey,
                          label: Center(child: const Text('Postal Code'))),
                      GridColumn(
                          columnName: Address.areaCodeKey,
                          label: Center(child: const Text('Area Code'))),

                      // Add more columns as needed
                    ],
                  );
                }),
          )
        ]),
      ),
    );
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
                  columnName: Address.streetKey,
                  value: e.address?.street ?? ''),
              DataGridCell(
                  columnName: Address.cityKey, value: e.address?.city ?? ''),
              DataGridCell(
                  columnName: Address.stateKey, value: e.address?.state ?? ''),
              DataGridCell(
                  columnName: Address.postalCodeKey,
                  value: e.address?.postalCode ?? ''),
              DataGridCell(
                  columnName: Address.areaCodeKey,
                  value: e.address?.areaCode ?? ''),
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
        padding: const EdgeInsets.all(4.0),
        child: Text(
          e.value.toString(),
          style: const TextStyle(fontSize: 13.0),
        ),
      );
    }).toList());
  }
}
