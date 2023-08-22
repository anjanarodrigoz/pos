import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:window_manager/window_manager.dart';
import '../models/invoice.dart';

import '../theme/t_colors.dart';
import 'invoice_view.dart';
import 'main_window.dart';

class InvoicePage extends StatelessWidget {
  List<Invoice> invoiceList = [];

  // late InvoiceDataSource _invoiceDataSource;

  InvoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    WindowOptions windowOptions = const WindowOptions(
        minimumSize: Size(1300, 800), size: Size(1300, 800), center: true);

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
    });

    // _invoiceDataSource = InvoiceDataSource(invoiceList: invoiceList.toList());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColors.blue,
        title: const Text('Invoice Page'),
        leading: IconButton(
            onPressed: () {
              Get.offAll(const MainWindow());
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Row(
        children: [
          /*
            // Menu items
            */

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                menuItem(() => openNewInvoice(), '+ New Invoice'),
                menuItem(() => {}, 'Search Invoice'),
                menuItem(() => {}, 'Edit '),
                menuItem(() => {}, 'Remove '),
                menuItem(() => {}, 'Pay '),
                SizedBox(
                  height: 50,
                ),
                menuItem(() => {}, 'Customers'),
                menuItem(() => {}, 'Stock'),
                menuItem(() => {}, 'Paymnets'),
              ],
            ),
          ),
          Column(
            children: [
              Expanded(child: InvoiceView()),
              SizedBox(
                  height: 50.0,
                  width: 980.0,
                  child: Card(
                    color: Colors.grey.shade300,
                    elevation: 5.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.keyboard_arrow_left_rounded),
                            Icon(Icons.keyboard_arrow_right_rounded)
                          ],
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ],
      ),
    );
  }

  Widget menuItem(Function() onPressed, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: Size(180, 50.0),
          backgroundColor: TColors.blue,
        ),
        child: Text(text),
      ),
    );
  }

  openNewInvoice() {
    // final box = GetStorage('Customer');
    // print(box.getKeys());
  }
}




//  Flexible(
//             child: Column(
//               children: [
//                 const SizedBox(
//                   height: 40.0,
//                 ),
//                 Card(
//                   elevation: 2,
//                   child: TextField(
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: Colors.white,
//                       hintText: 'Search...',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: BorderSide.none,
//                       ),
//                       suffixIcon: IconButton(
//                         splashRadius: 5.0,
//                         icon: const Icon(Icons.search),
//                         onPressed: () {},
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 20.0,
//                 ),
//                 Flexible(
//                   child: SfDataGridTheme(
//                     data: SfDataGridThemeData(),
//                     child: SfDataGrid(
//                       gridLinesVisibility: GridLinesVisibility.none,
//                       headerGridLinesVisibility: GridLinesVisibility.none,
//                       columnWidthMode: ColumnWidthMode.fill,
//                       source: _invoiceDataSource,
//                       columns: [
//                         GridColumn(
//                             columnName: Ref.invoiceId,
//                             label: Container(
//                                 padding: const EdgeInsets.all(16.0),
//                                 alignment: Alignment.center,
//                                 child: const Text(
//                                   'Invoice Id',
//                                 ))),
//                         GridColumn(
//                             columnName: Ref.date,
//                             label: Container(
//                                 padding: const EdgeInsets.all(8.0),
//                                 alignment: Alignment.center,
//                                 child: const Text('Date'))),
//                         GridColumn(
//                             columnName: Ref.customerName,
//                             label: Container(
//                                 padding: const EdgeInsets.all(8.0),
//                                 alignment: Alignment.center,
//                                 child: const Text(
//                                   'Customer Name',
//                                   overflow: TextOverflow.ellipsis,
//                                 ))),
//                         GridColumn(
//                             columnName: Ref.amount,
//                             label: Container(
//                                 padding: const EdgeInsets.all(8.0),
//                                 alignment: Alignment.center,
//                                 child: const Text('Amount'))),
//                         GridColumn(
//                             columnName: Ref.status,
//                             label: Container(
//                                 padding: const EdgeInsets.all(8.0),
//                                 alignment: Alignment.center,
//                                 child: const Text('Status'))),
//                       ],
//                     ),
//                   ),
//                 ),
//                 if (invoiceList.isNotEmpty)
//                   Card(
//                     child: SfDataPager(
//                       pageCount: (invoiceList.length / 10).ceilToDouble(),
//                       visibleItemsCount: 10,
//                       delegate: _invoiceDataSource,
//                     ),
//                   ),
//               ],
//             ),
//           ),
