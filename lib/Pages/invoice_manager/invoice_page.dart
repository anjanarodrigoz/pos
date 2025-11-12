import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/Pages/invoice_draft_manager/invoice_customer_select.dart';
import 'package:pos/Pages/invoice_manager/invoice_edit_page.dart';
import 'package:pos/Pages/invoice_manager/save_invoice_page.dart';
import 'package:pos/Pages/invoice_manager/search_invoice_page.dart';
import 'package:pos/api/email_sender.dart';
import 'package:pos/api/pdf_api.dart';
import 'package:pos/repositories/invoice_repository.dart';
import 'package:pos/enums/enums.dart';
import 'package:pos/models/payment.dart';
import 'package:pos/utils/invoice_converter.dart';
import 'package:pos/theme/app_theme.dart';
import 'package:printing/printing.dart';

import '../../api/pdf_invoice_api.dart';
import '../../controllers/invoice_edit_controller.dart';
import '../../models/invoice.dart';

class InvoicePage extends StatefulWidget {
  String? searchInvoiceId;
  InvoicePage({super.key, this.searchInvoiceId});

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  final InvoiceRepository _invoiceRepo = Get.find<InvoiceRepository>();
  List<Invoice> invoiceList = [];
  Invoice? currentInvoice;
  final RxInt currentIndex = 0.obs;
  String? searchInvoiceId;

  @override
  void initState() {
    searchInvoiceId = widget.searchInvoiceId;
    super.initState();
  }

  Future<List<Invoice>> _loadFullInvoices(List<dynamic> driftInvoices) async {
    List<Invoice> domainInvoices = [];

    for (var driftInvoice in driftInvoices) {
      try {
        final fullDataResult =
            await _invoiceRepo.getFullInvoiceData(driftInvoice.invoiceId);

        if (fullDataResult.isSuccess) {
          final domainInvoice =
              InvoiceConverter.fromFullInvoiceData(fullDataResult.data!);
          domainInvoices.add(domainInvoice);
        }
      } catch (e) {
        continue;
      }
    }

    return domainInvoices;
  }

  void _navigateInvoice(int direction) {
    if (invoiceList.isEmpty) return;

    setState(() {
      if (direction == -1 && currentIndex.value > 0) {
        currentIndex.value--;
      } else if (direction == 1 &&
          currentIndex.value < invoiceList.length - 1) {
        currentIndex.value++;
      } else if (direction == -999) {
        currentIndex.value = 0;
      } else if (direction == 999) {
        currentIndex.value = invoiceList.length - 1;
      }
      searchInvoiceId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      appBar: AppBar(
        title: Text(
          'Invoice Management',
          style: AppTheme.headlineMedium.copyWith(color: Colors.white),
        ),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        actions: [
          StreamBuilder(
            stream: _invoiceRepo.watchInvoices(activeOnly: true),
            builder: (context, snapshot) {
              final count = snapshot.data?.length ?? 0;
              return Center(
                child: Container(
                  margin: const EdgeInsets.only(right: AppTheme.spacingLg),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingMd,
                    vertical: AppTheme.spacingSm,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  ),
                  child: Text(
                    '$count Invoices',
                    style: AppTheme.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSidebar(),
          Expanded(
            child: StreamBuilder(
              stream: _invoiceRepo.watchInvoices(activeOnly: false),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return _buildEmptyState();
                }

                final driftInvoices = snapshot.data!;

                return FutureBuilder(
                  future: _loadFullInvoices(driftInvoices),
                  builder:
                      (context, AsyncSnapshot<List<Invoice>> fullSnapshot) {
                    if (!fullSnapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    invoiceList = fullSnapshot.data!.reversed.toList();

                    if (invoiceList.isEmpty) {
                      return _buildEmptyState();
                    }

                    if (searchInvoiceId != null) {
                      try {
                        currentIndex.value = invoiceList.indexOf(
                          invoiceList.firstWhere(
                            (element) => element.invoiceId == searchInvoiceId,
                          ),
                        );
                        searchInvoiceId = null;
                      } catch (e) {
                        currentIndex.value = 0;
                      }
                    }

                    return Obx(() {
                      if (currentIndex.value >= invoiceList.length) {
                        currentIndex.value = invoiceList.length - 1;
                      }

                      currentInvoice = invoiceList[currentIndex.value];

                      return Column(
                        children: [
                          _buildNavigationBar(),
                          Expanded(
                            child:
                                SaveInvoiceViewPage(invoice: currentInvoice!),
                          ),
                        ],
                      );
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppTheme.spacingLg),
          _buildSidebarSection(
            title: 'ACTIONS',
            children: [
              _buildSidebarButton(
                icon: Icons.add_circle_outline,
                label: 'New Invoice',
                color: AppTheme.primaryColor,
                onPressed: () => _openNewInvoice(context),
              ),
              _buildSidebarButton(
                icon: Icons.search,
                label: 'Search',
                onPressed: _searchInvoices,
              ),
            ],
          ),
          const Divider(height: 32),
          _buildSidebarSection(
            title: 'INVOICE',
            children: [
              _buildSidebarButton(
                icon: Icons.edit_outlined,
                label: 'Edit',
                onPressed: _editInvoice,
              ),
              _buildSidebarButton(
                icon: Icons.copy_outlined,
                label: 'Copy',
                onPressed: _copyInvoice,
              ),
              _buildSidebarButton(
                icon: Icons.print_outlined,
                label: 'Print',
                onPressed: _printInvoice,
              ),
              _buildSidebarButton(
                icon: Icons.payment_outlined,
                label: 'Add Payment',
                color: AppTheme.successColor,
                onPressed: _addPayment,
              ),
            ],
          ),
          const Divider(height: 32),
          _buildSidebarSection(
            title: 'DANGER ZONE',
            children: [
              _buildSidebarButton(
                icon: Icons.delete_outline,
                label: 'Delete',
                color: AppTheme.errorColor,
                onPressed: _deleteInvoice,
              ),
            ],
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            child: Container(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              decoration: BoxDecoration(
                color: AppTheme.backgroundGrey,
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.lightbulb_outline,
                    color: AppTheme.primaryColor,
                    size: 20,
                  ),
                  const SizedBox(height: AppTheme.spacingSm),
                  Text(
                    'Tip',
                    style: AppTheme.labelLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingXs),
                  Text(
                    'Use navigation arrows to browse invoices',
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacingMd),
        ],
      ),
    );
  }

  Widget _buildSidebarSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingMd,
            vertical: AppTheme.spacingSm,
          ),
          child: Text(
            title,
            style: AppTheme.labelSmall.copyWith(
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildSidebarButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    Color? color,
  }) {
    final buttonColor = color ?? AppTheme.textPrimary;

    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingMd,
          vertical: AppTheme.spacingMd,
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: buttonColor),
            const SizedBox(width: AppTheme.spacingMd),
            Expanded(
              child: Text(
                label,
                style: AppTheme.bodyMedium.copyWith(
                  color: buttonColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationBar() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingMd,
              vertical: AppTheme.spacingSm,
            ),
            decoration: BoxDecoration(
              color: AppTheme.backgroundGrey,
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            ),
            child: Obx(() => Text(
                  'Invoice ${currentIndex.value + 1} of ${invoiceList.length}',
                  style: AppTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                )),
          ),
          const SizedBox(width: AppTheme.spacingLg),
          _buildNavButton(
            icon: Icons.first_page,
            onPressed: () => _navigateInvoice(-999),
            tooltip: 'First',
          ),
          const SizedBox(width: AppTheme.spacingSm),
          _buildNavButton(
            icon: Icons.chevron_left,
            onPressed: () => _navigateInvoice(-1),
            tooltip: 'Previous',
          ),
          const SizedBox(width: AppTheme.spacingSm),
          _buildNavButton(
            icon: Icons.chevron_right,
            onPressed: () => _navigateInvoice(1),
            tooltip: 'Next',
          ),
          const SizedBox(width: AppTheme.spacingSm),
          _buildNavButton(
            icon: Icons.last_page,
            onPressed: () => _navigateInvoice(999),
            tooltip: 'Last',
          ),
          const Spacer(),
          if (currentInvoice != null) ...[
            _buildQuickInfo(
              label: 'Total',
              value: '\$${currentInvoice!.total.toStringAsFixed(2)}',
              color: AppTheme.primaryColor,
            ),
            const SizedBox(width: AppTheme.spacingLg),
            _buildQuickInfo(
              label: 'Status',
              value: currentInvoice!.isPaid ? 'Paid' : 'Unpaid',
              color: currentInvoice!.isPaid
                  ? AppTheme.successColor
                  : AppTheme.warningColor,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: AppTheme.backgroundGrey,
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
          child: Container(
            padding: const EdgeInsets.all(AppTheme.spacingSm),
            child: Icon(icon, size: 20, color: AppTheme.textPrimary),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickInfo({
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppTheme.labelSmall.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTheme.bodyLarge.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 80,
            color: AppTheme.textSecondary.withOpacity(0.3),
          ),
          const SizedBox(height: AppTheme.spacingLg),
          Text(
            'No Invoices Yet',
            style: AppTheme.headlineMedium.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Text(
            'Create your first invoice to get started',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: AppTheme.spacingXl),
          ElevatedButton.icon(
            onPressed: () => _openNewInvoice(context),
            icon: const Icon(Icons.add),
            label: const Text('Create Invoice'),
            style: AppTheme.primaryButtonStyle(),
          ),
        ],
      ),
    );
  }

  void _openNewInvoice(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: InvoiceCustomerSelectPage(
            invoiceType: InvoiceType.invoice,
          ),
        );
      },
    );
  }

  void _searchInvoices() {
    Get.to(() => const InvoiceSearchPage());
  }

  void _editInvoice() {
    if (currentInvoice == null) return;

    if (currentInvoice!.isDeleted) {
      _showMessage('This invoice has been deleted and cannot be edited.');
      return;
    }
    if (currentInvoice!.isPaid) {
      _showMessage('This invoice has been paid and cannot be edited.');
      return;
    }

    final controller = Get.put(InvoiceEditController(invoice: currentInvoice!));
    Get.to(() => InvoiceEditPage(controller: controller));
  }

  Future<void> _copyInvoice() async {
    if (currentInvoice == null) return;

    if (currentInvoice!.isDeleted) {
      _showMessage('This invoice cannot be copied.');
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: InvoiceCustomerSelectPage(
              invoice: currentInvoice,
              invoiceType: InvoiceType.invoice,
            ),
          );
        },
      );
    }
  }

  void _printInvoice() {
    if (currentInvoice == null) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(AppTheme.spacingXl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.print_outlined,
                  size: 64,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(height: AppTheme.spacingLg),
                Text(
                  'Invoice #${currentInvoice!.invoiceId}',
                  style: AppTheme.headlineMedium,
                ),
                const SizedBox(height: AppTheme.spacingXl),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final printers = await Printing.listPrinters();
                      if (printers.isNotEmpty) {
                        await PdfInvoiceApi.printInvoice(
                          currentInvoice!,
                          printer: printers.first,
                          invoiceType: InvoiceType.invoice,
                        );
                        Get.back();
                      }
                    },
                    icon: const Icon(Icons.print),
                    label: const Text('Print'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      padding: const EdgeInsets.symmetric(
                          vertical: AppTheme.spacingMd),
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingMd),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await EmailSender.showEmailSendingDialog(
                        context,
                        currentInvoice!,
                        InvoiceType.invoice,
                      );
                      Get.back();
                    },
                    icon: const Icon(Icons.email_outlined),
                    label: const Text('Send Email'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentColor,
                      padding: const EdgeInsets.symmetric(
                          vertical: AppTheme.spacingMd),
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingMd),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final file = await PdfInvoiceApi.generateInvoicePDF(
                        currentInvoice!,
                        invoiceType: InvoiceType.invoice,
                      );
                      await PdfApi.openFile(file);
                      Get.back();
                    },
                    icon: const Icon(Icons.visibility_outlined),
                    label: const Text('Preview'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.textSecondary,
                      padding: const EdgeInsets.symmetric(
                          vertical: AppTheme.spacingMd),
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingLg),
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _addPayment() {
    if (currentInvoice == null) return;

    final amountController = TextEditingController(
      text: currentInvoice!.toPay.toStringAsFixed(2),
    );
    final commentController = TextEditingController();
    Rx<Paymethod> selectedMethod = Paymethod.cash.obs;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Payment'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Amount Due: \$${currentInvoice!.toPay.toStringAsFixed(2)}',
                style: AppTheme.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: AppTheme.spacingLg),
              TextField(
                controller: amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Payment Amount',
                  prefixText: '\$ ',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: AppTheme.backgroundGrey,
                ),
                onTap: () => amountController.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: amountController.text.length,
                ),
              ),
              const SizedBox(height: AppTheme.spacingMd),
              Obx(() => DropdownButtonFormField<Paymethod>(
                    value: selectedMethod.value,
                    decoration: const InputDecoration(
                      labelText: 'Payment Method',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: AppTheme.backgroundGrey,
                    ),
                    items: Paymethod.values.map((method) {
                      return DropdownMenuItem(
                        value: method,
                        child: Text(method.displayName),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) selectedMethod.value = value;
                    },
                  )),
              const SizedBox(height: AppTheme.spacingMd),
              TextField(
                controller: commentController,
                decoration: const InputDecoration(
                  labelText: 'Comment (Optional)',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: AppTheme.backgroundGrey,
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final amount = double.tryParse(amountController.text) ?? 0.0;

              if (amount <= 0 || amount > currentInvoice!.toPay) {
                _showMessage('Please enter a valid amount');
                return;
              }

              final result = await _invoiceRepo.addPayment(
                invoiceId: currentInvoice!.invoiceId,
                amount: amount,
                paymentMethod:
                    InvoiceConverter.paymethodToString(selectedMethod.value),
                comment: commentController.text.isNotEmpty
                    ? commentController.text
                    : null,
                date: DateTime.now(),
              );

              Get.back();

              if (result.isSuccess) {
                _showMessage('Payment added successfully', isSuccess: true);
              } else {
                _showMessage('Error: ${result.error?.message}');
              }
            },
            style: AppTheme.primaryButtonStyle(),
            child: const Text('Add Payment'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteInvoice() async {
    if (currentInvoice == null) return;

    if (currentInvoice!.isPaid) {
      _showMessage('Invoice has been paid and cannot be deleted.');
      return;
    }
    if ((currentInvoice!.payments ?? []).isNotEmpty) {
      _showMessage('This invoice has payments. Please remove them first.');
      return;
    }
    if (currentInvoice!.isDeleted) {
      _showMessage('This invoice has already been deleted.');
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Invoice'),
        content: Text(
          'Are you sure you want to delete invoice #${currentInvoice!.invoiceId}?\n\nThis action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final result = await _invoiceRepo.deleteInvoice(
                currentInvoice!.invoiceId,
              );

              Get.back();

              if (result.isSuccess) {
                _showMessage('Invoice deleted successfully', isSuccess: true);
              } else {
                _showMessage(
                    'Failed to delete invoice: ${result.error?.message}');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showMessage(String message, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            isSuccess ? AppTheme.successColor : AppTheme.errorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        ),
      ),
    );
  }
}
