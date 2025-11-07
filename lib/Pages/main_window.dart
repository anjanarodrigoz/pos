import 'dart:io';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:pos/Pages/credit_note_manager/all_credit_note_page.dart';
import 'package:pos/pages/customer_page.dart';
import 'package:pos/pages/item_page.dart';
import 'package:pos/Pages/payment_manager/payment_pdage.dart';
import 'package:pos/Pages/quotation_manager/all_quotation_invoice.dart';
import 'package:pos/Pages/setup/setup_home_page.dart';
import 'package:pos/Pages/supplyer_manager/supplyer_page.dart';
import 'package:pos/controllers/size_controller.dart';
import 'package:pos/theme/app_theme.dart';
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
        size: Size(800, 650),
        center: true,
        skipTaskbar: false,
      );
      windowManager.waitUntilReadyToShow(windowOptions, () async {
        await windowManager.show();
        await windowManager.focus();
      });
    }
    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: AppTheme.borderColor),
                ),
              ),
              padding: const EdgeInsets.all(AppTheme.spacingXl),
              child: Column(
                children: [
                  Icon(
                    Icons.storefront_rounded,
                    size: 48,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(height: AppTheme.spacingMd),
                  Text(
                    'POS System',
                    style: AppTheme.headlineLarge.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingSm),
                  Text(
                    'Select a module to continue',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Menu Grid
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingXl),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                mainAxisSpacing: AppTheme.spacingMd,
                crossAxisSpacing: AppTheme.spacingMd,
                childAspectRatio: 1.2,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _menuCard(
                    icon: Icons.receipt_long_outlined,
                    title: 'Invoice',
                    subtitle: 'Create & manage invoices',
                    onTap: () => openNewWindow(),
                  ),
                  _menuCard(
                    icon: Icons.inventory_2_outlined,
                    title: 'Stock',
                    subtitle: 'Manage inventory',
                    onTap: () => openStockManager(),
                  ),
                  _menuCard(
                    icon: Icons.people_outline,
                    title: 'Customers',
                    subtitle: 'Customer management',
                    onTap: () => openCustomerManager(),
                  ),
                  _menuCard(
                    icon: Icons.local_shipping_outlined,
                    title: 'Suppliers',
                    subtitle: 'Supplier management',
                    onTap: () => openSupplyerManager(),
                  ),
                  _menuCard(
                    icon: Icons.request_quote_outlined,
                    title: 'Quotation',
                    subtitle: 'Create quotes',
                    onTap: () => openQuoteManager(),
                  ),
                  _menuCard(
                    icon: Icons.shopping_cart_outlined,
                    title: 'Supply Invoice',
                    subtitle: 'Purchase management',
                    onTap: () => openSupplyInvoiceManager(),
                  ),
                  _menuCard(
                    icon: Icons.assignment_return_outlined,
                    title: 'Return Notes',
                    subtitle: 'Manage returns',
                    onTap: () => openReturnNoteManager(),
                  ),
                  _menuCard(
                    icon: Icons.note_outlined,
                    title: 'Credit Note',
                    subtitle: 'Credit management',
                    onTap: () => openCreditNoteManager(),
                  ),
                  _menuCard(
                    icon: Icons.payments_outlined,
                    title: 'Payments',
                    subtitle: 'Payment tracking',
                    onTap: () => openPaymentManager(),
                  ),
                  _menuCard(
                    icon: Icons.assessment_outlined,
                    title: 'Reports',
                    subtitle: 'Business analytics',
                    onTap: () => openReport(),
                  ),
                  _menuCard(
                    icon: Icons.settings_outlined,
                    title: 'Setup',
                    subtitle: 'System configuration',
                    onTap: () => backupFile(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          border: Border.all(color: AppTheme.borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: AppTheme.primaryDark,
                ),
              ),
              const SizedBox(height: AppTheme.spacingMd),
              Text(
                title,
                style: AppTheme.headlineSmall.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacingXs),
              Text(
                subtitle,
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
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

    Get.offAll(() => const ItemPage());
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
