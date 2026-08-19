import 'package:flutter/material.dart';
import 'package:pos/models/address.dart';
import 'package:pos/models/customer.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// DataSource for Syncfusion DataGrid to display customers
class CustomerDataSource extends DataGridSource {
  List<Customer> customersData;

  CustomerDataSource({required this.customersData}) {
    buildDataGridRows();
  }

  List<DataGridRow> dataGridRows = [];

  void buildDataGridRows() {
    dataGridRows = customersData.map<DataGridRow>((customer) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: Customer.idKey, value: customer.id),
        DataGridCell<String>(
            columnName: Customer.firstNameKey, value: customer.firstName),
        DataGridCell<String>(
            columnName: Customer.lastNameKey, value: customer.lastName),
        DataGridCell<String>(
            columnName: Customer.mobileNumberKey, value: customer.mobileNumber),
        DataGridCell<String>(
            columnName: Customer.emailKey, value: customer.email ?? ''),
        DataGridCell<String>(
            columnName: Address.areaCodeKey,
            value: customer.deliveryAddress?.areaCode ?? ''),
        DataGridCell<String>(
            columnName: Address.cityKey,
            value: customer.deliveryAddress?.city ?? ''),
        DataGridCell<String>(
            columnName: Address.postalCodeKey,
            value: customer.deliveryAddress?.postalCode ?? ''),
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
          alignment: Alignment.centerLeft,
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
