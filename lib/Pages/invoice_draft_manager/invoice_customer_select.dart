import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/Pages/customer_manager/customer_page.dart';
import 'package:pos/Pages/invoice_draft_manager/invoice_customer_view.dart';
import 'package:pos/database/customer_db_service.dart';
import 'package:pos/theme/t_colors.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../models/address.dart';
import '../../models/customer.dart';
import '../../models/invoice.dart';

class InvoiceCustomerSelectPage extends StatelessWidget {
  final DataGridController _dataGridController = DataGridController();
  late List<Customer> customerList;
  Invoice? invoice;

  InvoiceCustomerSelectPage({super.key, this.invoice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Customer',
          style: TStyle.titleBarStyle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FutureBuilder(
                future: CustomerDB().getAllCustomers(),
                builder: (context, snapshot) {
                  customerList = snapshot.data ?? [];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 620.0,
                        child: SfDataGrid(
                          selectionMode: SelectionMode.single,
                          controller: _dataGridController,
                          gridLinesVisibility: GridLinesVisibility.both,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          allowFiltering: true,
                          allowColumnsResizing: true,
                          showFilterIconOnHover: true,
                          columnWidthMode: ColumnWidthMode.auto,
                          source:
                              CustomerDataSource(customersData: customerList),
                          columns: [
                            GridColumn(
                                columnName: Customer.idKey,
                                label: Center(child: const Text('ID'))),
                            GridColumn(
                                columnName: Customer.firstNameKey,
                                label: Center(child: const Text('First Name'))),
                            GridColumn(
                                columnName: Customer.lastNameKey,
                                label: Center(child: const Text('Last Name'))),
                            GridColumn(
                                columnName: Customer.mobileNumberKey,
                                label:
                                    Center(child: const Text('Mobile Number'))),
                            GridColumn(
                                columnName: Customer.emailKey,
                                label: Center(child: const Text('Email'))),
                            GridColumn(
                                columnName: Address.areaCodeKey,
                                label: Center(child: const Text('Area Code'))),
                            GridColumn(
                                columnName: Address.cityKey,
                                label: Center(child: const Text('City'))),
                            GridColumn(
                                columnName: Address.postalCodeKey,
                                label:
                                    Center(child: const Text('Postal Code'))),

                            // Add more columns as needed
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(right: 30.0, bottom: 10.0),
                        child: IconButton(
                            icon: Icon(
                              Icons.arrow_circle_right_rounded,
                              size: 45,
                            ),
                            color: Colors.blue,
                            splashRadius: 20.0,
                            onPressed: () {
                              Get.to(InvoiceCustomerViewPage(
                                cusId: _dataGridController.selectedRow
                                    ?.getCells()[0]
                                    .value,
                                invoice: invoice,
                              ));
                            }),
                      )
                    ],
                  );
                }),
          ],
        ),
      ),
    );
  }
}
