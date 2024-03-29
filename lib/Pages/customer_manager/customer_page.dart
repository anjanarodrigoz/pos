import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pos/Pages/customer_manager/customer_form.dart';
import 'package:pos/Pages/main_window.dart';
import 'package:pos/database/customer_db_service.dart';
import 'package:pos/models/address.dart';
import 'package:pos/theme/t_colors.dart';
import 'package:pos/utils/constant.dart';
import 'package:pos/utils/val.dart';
import 'package:pos/widgets/pos_button.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../models/customer.dart';
import 'customer_view.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  late final _databaseService; // Use your DatabaseService class

  List<Customer> _customers = [];
  CustomerDataSource customerDataSource = CustomerDataSource(customersData: []);
  Function? disposeListen;

  @override
  void initState() {
    super.initState();
    _databaseService = CustomerDB();

    disposeListen = GetStorage(DBVal.customers).listen(() {
      getCustomerData();
    });
    getCustomerData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    disposeListen?.call();
  }

  @override
  Widget build(BuildContext context) {
    // WindowOptions windowOptions = const WindowOptions(
    //     windowButtonVisibility: true,
    //     center: true,
    //     titleBarStyle: TitleBarStyle.normal);
    // windowManager.waitUntilReadyToShow(windowOptions, () async {
    //   await windowManager.show();
    //   await windowManager.maximize();
    // });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColors.blue,
        leading: IconButton(
            onPressed: () async {
              Get.offAll(const MainWindow());
            },
            icon: const Icon(Icons.arrow_back_outlined)),
        title: Text(
          'Customers',
          style: TStyle.titleBarStyle,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          PosButton(
              text: '+ New Customer',
              onPressed: () {
                Get.to(const CustomerFormPage());
              }),
          const SizedBox(
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
              rowHeight: Const.tableRowHeight,
              source: customerDataSource,
              onCellTap: ((details) {
                if (details.rowColumnIndex.rowIndex != 0) {
                  int selectedRowIndex = details.rowColumnIndex.rowIndex - 1;
                  var row = customerDataSource.effectiveRows
                      .elementAt(selectedRowIndex);

                  Get.to(CustomerViewPage(
                      cusId: row.getCells()[0].value.toString()));
                }
              }),
              columns: [
                GridColumn(
                    columnName: Customer.idKey,
                    label: const Center(child: Text('ID'))),
                GridColumn(
                    columnName: Customer.firstNameKey,
                    label: const Center(child: Text('First Name'))),
                GridColumn(
                    columnName: Customer.lastNameKey,
                    label: const Center(child: Text('Last Name'))),
                GridColumn(
                    columnName: Customer.mobileNumberKey,
                    label: const Center(child: Text('Mobile Number'))),
                GridColumn(
                    columnName: Customer.emailKey,
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
          )
        ]),
      ),
    );
  }

  Future<void> getCustomerData() async {
    _customers = await _databaseService.getAllCustomers();
    customerDataSource = CustomerDataSource(customersData: _customers);
    setState(() {});
  }
}

class CustomerDataSource extends DataGridSource {
  List<DataGridRow> _customersData = [];

  CustomerDataSource({required List<Customer> customersData}) {
    _customersData = customersData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell(columnName: Customer.idKey, value: e.id),
              DataGridCell(
                  columnName: Customer.firstNameKey, value: e.firstName),
              DataGridCell(columnName: Customer.lastNameKey, value: e.lastName),
              DataGridCell(
                  columnName: Customer.mobileNumberKey, value: e.mobileNumber),
              DataGridCell(columnName: Customer.emailKey, value: e.email),
              DataGridCell(
                  columnName: Address.areaCodeKey,
                  value: e.deliveryAddress?.areaCode ?? ''),
              DataGridCell(
                  columnName: Address.cityKey,
                  value: e.deliveryAddress?.city ?? ''),
              DataGridCell(
                  columnName: Address.postalCodeKey,
                  value: e.deliveryAddress?.postalCode ?? ''),
            ]))
        .toList();
  }

  @override
  List<DataGridRow> get rows => _customersData;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
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
