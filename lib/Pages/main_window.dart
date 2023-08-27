import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:get/get.dart';
import 'package:pos/Pages/customer_manager/customer_form.dart';
import 'package:pos/Pages/customer_manager/customer_page.dart';
import 'package:pos/Pages/stock_manager.dart/stock_page.dart';

import 'package:window_manager/window_manager.dart';

import '../theme/t_colors.dart';
import 'invoice_manager/invoice_page.dart';

class MainWindow extends StatefulWidget {
  const MainWindow({super.key});

  @override
  State<MainWindow> createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    WindowOptions windowOptions = const WindowOptions(
        size: Size(200, 466),
        minimumSize: Size(200, 466),
        maximumSize: Size(200, 466),
        center: true,
        titleBarStyle: TitleBarStyle.hidden,
        windowButtonVisibility: false);

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
    });
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      key: _scaffoldKey,
      body: Column(
        children: [
          Container(
            color: TColors.blue,
            height: 40.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                menuItem(() => openNewWindow(), 'Invoice'),
                menuItem(() => {}, 'Credit Note'),
                menuItem(() => {}, 'Quatation'),
                menuItem(() => openCustomerManager(), 'Customers'),
                menuItem(() => openStockManager(), 'Stock'),
                menuItem(() => {}, 'Payments'),
                menuItem(() => {}, 'Setup')
              ],
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(),
      ),
    );
  }

  Widget menuItem(Function() onPressed, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: Size(200, 50.0),
          backgroundColor: TColors.blue,
        ),
        child: Text(text),
      ),
    );
  }

  Future<void> openNewWindow() async {
    Get.offAll(() => InvoicePage());
  }

  openCustomerManager() {
    Get.offAll(() => const CustomerPage());
  }

  openStockManager() {
    Get.offAll(() => const StockPage());
  }
}
