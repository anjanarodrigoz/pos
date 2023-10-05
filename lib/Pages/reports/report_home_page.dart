import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/Pages/main_window.dart';
import 'package:pos/Pages/reports/report_page.dart';
import 'package:pos/enums/enums.dart';
import 'package:pos/theme/t_colors.dart';
import 'package:pos/widgets/filter_dialog.dart';
import 'package:pos/widgets/paid_status_widget.dart';
import 'package:pos/widgets/pos_button.dart';
import 'package:window_manager/window_manager.dart';

class ReportHomePage extends StatelessWidget {
  ReportHomePage({super.key});
  late BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;

    WindowOptions windowOptions = const WindowOptions(
        minimumSize: Size(1300, 800), size: Size(1300, 800), center: true);

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reports',
          style: TextStyle(fontSize: 20.0),
        ),
        toolbarHeight: 50.0,
        backgroundColor: TColors.blue,
        leading: IconButton(
          iconSize: 20.0,
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Get.offAll(const MainWindow());
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(children: [
              PosButton(
                  text: 'Transcation Summary',
                  onPressed: () {
                    showReportTypes({
                      'Invoice Report': () {
                        showFilterDialog(ReportType.invoice,
                            {'Transcation Summary': 'Invoice'},
                            showPaidStatus: true);
                      },
                      'Credit Note Report': () {
                        showFilterDialog(ReportType.creditNote,
                            {'Transcation Summary': 'Credit Note'});
                      },
                      'Quote Report': () {
                        showFilterDialog(ReportType.quote,
                            {'Transcation Summary': 'Quotation'});
                      },
                      'Turnover Summery Report': () {
                        showFilterDialog(
                            ReportType.summery, {'Transcation Summary': ''});
                      }
                    });
                  }),
              PosButton(
                  text: 'Transcation Items',
                  onPressed: () {
                    showReportTypes({
                      'Invoice': () {
                        showFilterDialog(
                          ReportType.itemInvoice,
                          {'Transcation Items': 'Invoice'},
                        );
                      },
                      'Credit Note': () {
                        showFilterDialog(
                          ReportType.itemCreditNote,
                          {'Transcation Items': 'Credit Note'},
                        );
                      },
                      'Quote': () {
                        showFilterDialog(
                          ReportType.itemQuote,
                          {'Transcation Items': 'Quotation'},
                        );
                      },
                      'Invoiced  Items': () {
                        showFilterDialog(
                          ReportType.itemInvoicedItem,
                          {'Transcation Items': 'Invoiced Items'},
                        );
                      },
                    });
                  }),
              PosButton(
                  text: 'Stock',
                  onPressed: () {
                    showReportTypes({
                      'Stock Required Report': () {
                        showFilterDialog(
                          ReportType.stockRequired,
                          {'Stock': 'Stock Required'},
                        );
                      },
                      'Stock Quantity Report': () {
                        showFilterDialog(
                          ReportType.stockQuantity,
                          {'Stock': 'Stock Quantity'},
                        );
                      },
                    });
                  }),
              PosButton(
                  text: 'Supply Transcation',
                  onPressed: () {
                    showReportTypes({
                      'Supply Invoice Report': () {
                        showFilterDialog(
                          ReportType.supplyInvoice,
                          {'Supply Transcation': 'Invoice'},
                        );
                      },
                      'Supply Item Report': () {
                        showFilterDialog(
                          ReportType.supplyItem,
                          {'Supply Transcation': 'Items'},
                        );
                      },
                    });
                  }),
              PosButton(
                  text: 'Customer',
                  onPressed: () {
                    showReportTypes({
                      'Customer Details': () {
                        showFilterDialog(
                          ReportType.customerDetails,
                          {'Customer': 'Customer Details'},
                        );
                      },
                      'Customer Outstanding': () {
                        showFilterDialog(
                          ReportType.outstanding,
                          {'Customer': 'OutStanding'},
                        );
                      },
                    });
                  }),
            ]),
            SizedBox(
              width: 50.0,
            ),
            Expanded(child: ReportPage())
          ],
        ),
      ),
    );
  }

  showReportTypes(Map<String, Function> types) {
    List typesList = types.entries.toList();

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: typesList
                        .map((type) => Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.blue.shade100),
                                  onPressed: () {
                                    Get.back();
                                    type.value();
                                  },
                                  child: Text(
                                    type.key,
                                    style: TextStyle(color: TColors.blue),
                                  )),
                            ))
                        .toList()),
              ),
            ));
  }

  showFilterDialog(ReportType reportType, Map<String, String> title,
      {bool showPaidStatus = false}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title.keys.first,
                  style: TextStyle(fontSize: 15.0),
                ),
                Text(
                  title.values.first,
                  style: TextStyle(fontSize: 12.0),
                ),
              ],
            ),
            content: SizedBox(
              height: 400.0,
              width: 300.0,
              child: FilterDialog(
                showPaidStatus: showPaidStatus,
                reportType: reportType,
                title: title,
              ),
            )));
  }
}
