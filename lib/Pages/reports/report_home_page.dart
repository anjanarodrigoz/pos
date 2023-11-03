import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/Pages/main_window.dart';
import 'package:pos/Pages/reports/report_page.dart';
import 'package:pos/enums/enums.dart';
import 'package:pos/theme/t_colors.dart';
import 'package:pos/widgets/filter_dialog.dart';
import 'package:pos/widgets/paid_status_widget.dart';
import 'package:pos/widgets/pos_button.dart';

class ReportHomePage extends StatefulWidget {
  const ReportHomePage({super.key});

  @override
  State<ReportHomePage> createState() => _ReportHomePageState();
}

class _ReportHomePageState extends State<ReportHomePage> {
  late final BuildContext context;
  final double width = 200.00;

  @override
  Widget build(BuildContext context) {
    this.context = context;

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
          onPressed: () async {
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
                  width: width,
                  text: 'Transcation Summary',
                  onPressed: () {
                    showReportTypes({
                      'Invoice Report': () {
                        showFilterDialog(ReportType.invoice,
                            {'Transcation Summary': 'Invoice'},
                            showPaidStatus: true);
                      },
                      'Turnover Summery Report': () {
                        showFilterDialog(
                            ReportType.summery, {'Transcation Summary': ''});
                      },
                      'Credit Note Report': () {
                        showFilterDialog(ReportType.creditNote,
                            {'Transcation Summary': 'Credit Note'});
                      },
                      'Quote Report': () {
                        showFilterDialog(ReportType.quote,
                            {'Transcation Summary': 'Quotation'});
                      },
                    });
                  }),
              PosButton(
                  width: width,
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
                  width: width,
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
                      'Stock value': () {
                        showFilterDialog(
                          ReportType.stockValue,
                          {'Stock': 'Stock Value'},
                        );
                      },
                    });
                  }),
              PosButton(
                  width: width,
                  text: 'Supply Transcation',
                  onPressed: () {
                    showReportTypes({
                      'Supply Invoice Report': () {
                        showFilterDialog(
                          ReportType.supplyInvoice,
                          {'Supply Transcation': 'Supply Invoice'},
                        );
                      },
                      'Supply Item Report': () {
                        showFilterDialog(
                          ReportType.supplyItem,
                          {'Supply Transcation': 'Supply Items'},
                        );
                      },
                      'Supply Return Report': () {
                        showFilterDialog(
                          ReportType.retrunNotes,
                          {'Supply Transcation': 'Return Notes'},
                        );
                      },
                    });
                  }),
              PosButton(
                  width: width,
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
            const SizedBox(
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
