import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:pos/Pages/credit_note_manager/all_credit_note_page.dart';
import 'package:pos/Pages/customer_manager/customer_form.dart';
import 'package:pos/Pages/customer_manager/customer_page.dart';
import 'package:pos/Pages/payment_manager/payment_pdage.dart';
import 'package:pos/Pages/quotation_manager/all_quotation_invoice.dart';
import 'package:pos/Pages/setup/setup_home_page.dart';
import 'package:pos/Pages/stock_manager.dart/stock_page.dart';
import 'package:pos/Pages/supplyer_manager/supplyer_page.dart';
import 'package:pos/database/customer_db_service.dart';
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
    WindowOptions windowOptions = const WindowOptions(
        size: Size(460, 380),
        minimumSize: Size(460, 380),
        maximumSize: Size(460, 380),
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
                        menuItem(() => backupFile(), 'Setup')
                      ],
                    ),
                    Column(
                      children: [
                        menuItem(() => openPaymentManager(), 'Payments'),
                        menuItem(() => openStockManager(), 'Stock'),
                        menuItem(() => openCustomerManager(), 'Customers'),
                        menuItem(() => openSupplyerManager(), 'Supplyers'),
                        menuItem(() => openReport(), 'Reports'),
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

  openSupplyerManager() {
    Get.offAll(() => SupplyerPage());
  }

  openPaymentManager() {
    Get.offAll(() => const PaymentPage());
  }

  openSupplyInvoiceManager() {
    Get.offAll(() => SupplyAllInvoice());
  }

  openQuoteManager() {
    Get.offAll(() => AllQuotesPage());
  }

  openCreditNoteManager() {
    Get.offAll(() => AllCreditNotePage());
  }

  backupFile() {
    Get.offAll(() => const SetupHomePage());
  }

  openReport() {
    Get.offAll(() => ReportHomePage());
  }
}
