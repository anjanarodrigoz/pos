import 'dart:io';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:pos/Pages/credit_note_manager/all_credit_note_page.dart';
import 'package:pos/pages/customer_page.dart';
import 'package:pos/Pages/payment_manager/payment_pdage.dart';
import 'package:pos/Pages/quotation_manager/all_quotation_invoice.dart';
import 'package:pos/Pages/setup/setup_home_page.dart';
import 'package:pos/Pages/stock_manager.dart/stock_page.dart';
import 'package:pos/Pages/supplyer_manager/supplyer_page.dart';
import 'package:pos/controllers/size_controller.dart';
import 'package:window_manager/window_manager.dart';
import '../theme/t_colors.dart';
import 'invoice_manager/invoice_page.dart';
import 'reports/report_home_page.dart';
import 'supply_invoice_manager/supply_all_invoice.dart';

class MainWindow extends StatefulWidget {
  const MainWindow({super.key});

  @override
  State<MainWindow> createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    if (Platform.isWindows || Platform.isMacOS) {
      WindowOptions windowOptions = const WindowOptions(
        size: Size(500, 400),
        center: true,
        skipTaskbar: false,
      );
      windowManager.waitUntilReadyToShow(windowOptions, () async {
        await windowManager.show();
        await windowManager.focus();
      });
    }
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      key: _scaffoldKey,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        menuItem(() => openNewWindow(), 'Invoice'),
                        menuItem(() => openCreditNoteManager(), 'Credit Note'),
                        menuItem(() => openQuoteManager(), 'Quatation'),
                        menuItem(
                            () => openSupplyInvoiceManager(), 'Supply Invoice'),
                        menuItem(() => openReturnNoteManager(), 'Return Notes'),
                        menuItem(() => openPaymentManager(), 'Payments'),
                      ],
                    ),
                    Column(
                      children: [
                        menuItem(() => openStockManager(), 'Stock'),
                        menuItem(() => openCustomerManager(), 'Customers'),
                        menuItem(() => openSupplyerManager(), 'Supplyers'),
                        menuItem(() => openReport(), 'Reports'),
                        menuItem(() => backupFile(), 'Setup'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
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
          fixedSize: const Size(200, 50.0),
          backgroundColor: TColors.blue,
        ),
        child: Text(text),
      ),
    );
  }

  Future<void> openNewWindow() async {
    await windowResizer();

    Get.offAll(() => InvoicePage());
  }

  openCustomerManager() async {
    await windowResizer();

    Get.offAll(() => const CustomerPage());
  }

  openStockManager() async {
    await windowResizer(width: 900, height: 750);

    Get.offAll(() => const StockPage());
  }

  openSupplyerManager() async {
    await windowResizer();

    Get.offAll(() => SupplyerPage());
  }

  openPaymentManager() async {
    await windowResizer();

    Get.offAll(() => const PaymentPage());
  }

  openSupplyInvoiceManager() async {
    await windowResizer();

    Get.offAll(() => SupplyAllInvoice());
  }

  openReturnNoteManager() async {
    await windowResizer();

    Get.offAll(() => SupplyAllInvoice(
          isRetunManager: true,
        ));
  }

  openQuoteManager() async {
    await windowResizer();

    Get.offAll(() => AllQuotesPage());
  }

  openCreditNoteManager() async {
    await windowResizer();

    Get.offAll(() => AllCreditNotePage());
  }

  backupFile() async {
    await windowResizer(width: 900, height: 600);

    Get.offAll(() => const SetupHomePage());
  }

  openReport() async {
    await windowResizer();
    Get.offAll(() => const ReportHomePage());
  }

  Future<void> windowResizer({double? width, double? height}) async {
    if (Platform.isWindows || Platform.isMacOS) {
      WindowOptions windowOptions = WindowOptions(
        size: Size(width ?? 1250, height ?? 750),
        center: true,
        skipTaskbar: false,
      );
      windowManager.waitUntilReadyToShow(windowOptions, () async {
        await windowManager.show();
        await windowManager.focus();
      });
    }
  }
}
