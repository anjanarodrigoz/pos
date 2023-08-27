import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/Pages/invoice_draft_manager/invoice_customer_select.dart';
import 'package:pos/Pages/invoice_manager/save_invoice_page.dart';
import 'package:pos/database/invoice_db_service.dart';
import 'package:window_manager/window_manager.dart';
import '../../models/invoice.dart';

import '../../theme/t_colors.dart';
import '../invoice_draft_manager/invoice_view.dart';
import '../main_window.dart';

class InvoicePage extends StatelessWidget {
  List<Invoice> invoiceList = [];
  RxInt index = 0.obs;

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

          Container(
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  menuItem(() => openNewInvoice(context), '+ New Invoice'),
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
                  SizedBox(height: 150),
                  Card(
                    color: TColors.blue,
                    elevation: 5.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              color: Colors.white,
                              icon: Icon(
                                  Icons.keyboard_double_arrow_left_rounded),
                              onPressed: () {
                                index.value = invoiceList.length - 1;
                              },
                            ),
                            IconButton(
                              color: Colors.white,
                              icon: Icon(Icons.keyboard_arrow_left_rounded),
                              onPressed: () {
                                if (index.value < invoiceList.length - 1) {
                                  index.value += 1;
                                }
                              },
                            ),
                            IconButton(
                              color: Colors.white,
                              icon: Icon(Icons.keyboard_arrow_right_rounded),
                              onPressed: () {
                                if (index.value != 0) {
                                  index.value -= 1;
                                }
                              },
                            ),
                            IconButton(
                              color: Colors.white,
                              icon: Icon(
                                  Icons.keyboard_double_arrow_right_rounded),
                              onPressed: () {
                                index.value = 0;
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          FutureBuilder(
            future: InvoiceDB().getAllInvoices(),
            builder: (context, snapshot) {
              final list = snapshot.data ?? [];
              invoiceList = list.reversed.toList();
              return invoiceList.isNotEmpty
                  ? Column(
                      children: [
                        Expanded(child: Obx(() {
                          Invoice? invoice = invoiceList[index.value];
                          return SaveInvoiceViewPage(invoice: invoice);
                        })),
                      ],
                    )
                  : Expanded(
                      child: const Center(
                        child: Text('No invoices found'),
                      ),
                    );
            },
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

  openNewInvoice(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: InvoiceCustomerSelectPage(),
          );
        });
  }
}
