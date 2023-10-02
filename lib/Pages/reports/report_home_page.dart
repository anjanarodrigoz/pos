import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/Pages/main_window.dart';
import 'package:pos/enums/enums.dart';
import 'package:pos/theme/t_colors.dart';
import 'package:pos/widgets/alert_dialog.dart';
import 'package:pos/widgets/filter_dialog.dart';
import 'package:pos/widgets/pos_button.dart';
import 'package:window_manager/window_manager.dart';

class ReportHomePage extends StatelessWidget {
  ReportHomePage({super.key});
  late BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;

    WindowOptions windowOptions = const WindowOptions(
        size: Size(600, 500),
        minimumSize: Size(600, 500),
        maximumSize: Size(600, 500),
        center: true,
        titleBarStyle: TitleBarStyle.hidden,
        windowButtonVisibility: false);

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
        child: Wrap(children: [
          PosButton(
              text: 'Transcation Summary',
              onPressed: () {
                showReportTypes({
                  'Invoice Report': () {
                    Get.off(FilterDialog(
                      title: const {'Transcation Summary': 'Invoice'},
                    ));
                  },
                  'Credit Note Report': () {
                    print('Credit Note');
                  },
                  'Quote Report': () {
                    print('Quote');
                  },
                  'Turnover Summery Report': () {
                    print('Turnover Summery');
                  }
                });
              }),
          PosButton(text: 'Transcation Items', onPressed: () {}),
          PosButton(text: 'Stock', onPressed: () {}),
          PosButton(text: 'Supplyer', onPressed: () {}),
          PosButton(text: 'Customer', onPressed: () {}),
          PosButton(text: 'GST Report', onPressed: () {})
        ]),
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
                                  onPressed: type.value,
                                  child: Text(
                                    type.key,
                                    style: TextStyle(color: TColors.blue),
                                  )),
                            ))
                        .toList()),
              ),
            ));
  }
}
