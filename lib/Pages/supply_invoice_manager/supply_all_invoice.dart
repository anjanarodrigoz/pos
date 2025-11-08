import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/database/pos_database.dart';
import 'package:pos/repositories/supplier_invoice_repository.dart';
import 'package:pos/theme/app_theme.dart';
import 'package:pos/utils/my_format.dart';
import 'package:pos/Pages/supply_invoice_manager/supply_invoice_create_page.dart';
import 'package:pos/Pages/supply_invoice_manager/supply_invoice_view.dart';

/// Modern supplier invoice list page with professional table view
class SupplyAllInvoice extends StatefulWidget {
  final bool isReturnManager;

  const SupplyAllInvoice({
    Key? key,
    this.isReturnManager = false,
  }) : super(key: key);

  @override
  State<SupplyAllInvoice> createState() => _SupplyAllInvoiceState();
}

class _SupplyAllInvoiceState extends State<SupplyAllInvoice> {
  final SupplierInvoiceRepository _repository = Get.find<SupplierInvoiceRepository>();
  String _searchQuery = '';
  String _filterStatus = 'all'; // all, paid, unpaid

  void _navigateToCreateInvoice() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SupplyInvoiceCreatePage(
          isReturnNote: widget.isReturnManager,
        ),
      ),
    );

    if (result == true) {
      // Refresh handled by StreamBuilder
    }
  }

  void _navigateToInvoiceDetail(String invoiceId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SupplyInvoiceView(
          invoiceId: invoiceId,
          isReturnNote: widget.isReturnManager,
        ),
      ),
    );
  }

  List<SupplierInvoice> _filterInvoices(List<SupplierInvoice> invoices) {
    var filtered = invoices;

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((invoice) {
        final query = _searchQuery.toLowerCase();
        return invoice.invoiceId.toLowerCase().contains(query) ||
            invoice.supplierName.toLowerCase().contains(query) ||
            (invoice.referenceId?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    // Filter by payment status
    if (_filterStatus == 'paid') {
      filtered = filtered.where((i) => i.isPaid).toList();
    } else if (_filterStatus == 'unpaid') {
      filtered = filtered.where((i) => !i.isPaid).toList();
    }

    // Filter by return note status
    if (widget.isReturnManager) {
      filtered = filtered.where((i) => i.isReturnNote).toList();
    } else {
      filtered = filtered.where((i) => !i.isReturnNote).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.isReturnManager ? 'Return Notes' : 'Supplier Invoices',
          style: AppTheme.headlineMedium.copyWith(color: AppTheme.textPrimary),
        ),
        backgroundColor: AppTheme.cardBackground,
        elevation: 0,
        iconTheme: IconThemeData(color: AppTheme.textPrimary),
        actions: [
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingSm),
            child: ElevatedButton.icon(
              onPressed: _navigateToCreateInvoice,
              icon: const Icon(Icons.add, size: 18),
              label: Text(widget.isReturnManager ? 'New Return Note' : 'New Invoice'),
              style: AppTheme.primaryButtonStyle(),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppTheme.borderColor),
        ),
      ),
      body: Column(
        children: [
          // Search and Filters
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            color: AppTheme.cardBackground,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (value) => setState(() => _searchQuery = value),
                        style: AppTheme.bodyMedium.copyWith(color: AppTheme.textPrimary),
                        decoration: AppTheme.inputDecoration(
                          labelText: 'Search invoices...',
                          prefixIcon: const Icon(Icons.search),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingMd),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingMd,
                        vertical: AppTheme.spacingSm,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundGrey,
                        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                        border: Border.all(color: AppTheme.borderColor),
                      ),
                      child: DropdownButton<String>(
                        value: _filterStatus,
                        onChanged: (value) => setState(() => _filterStatus = value!),
                        underline: const SizedBox(),
                        isDense: true,
                        items: const [
                          DropdownMenuItem(value: 'all', child: Text('All Invoices')),
                          DropdownMenuItem(value: 'paid', child: Text('Paid')),
                          DropdownMenuItem(value: 'unpaid', child: Text('Unpaid')),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 1),

          // Invoice List
          Expanded(
            child: StreamBuilder<List<SupplierInvoice>>(
              stream: _repository.watchAllInvoices(activeOnly: true),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error loading invoices: ${snapshot.error}',
                      style: AppTheme.bodyMedium.copyWith(color: AppTheme.errorColor),
                    ),
                  );
                }

                final allInvoices = snapshot.data ?? [];
                final invoices = _filterInvoices(allInvoices);

                if (invoices.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          widget.isReturnManager
                              ? Icons.assignment_return_outlined
                              : Icons.receipt_long_outlined,
                          size: 64,
                          color: AppTheme.textSecondary.withOpacity(0.3),
                        ),
                        const SizedBox(height: AppTheme.spacingMd),
                        Text(
                          _searchQuery.isEmpty
                              ? (widget.isReturnManager
                                  ? 'No return notes yet'
                                  : 'No supplier invoices yet')
                              : 'No invoices match your search',
                          style: AppTheme.bodyLarge.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingSm),
                        Text(
                          'Click the button above to create one',
                          style: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.textSecondary.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Container(
                  color: AppTheme.cardBackground,
                  child: Column(
                    children: [
                      // Table Header
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingLg,
                          vertical: AppTheme.spacingMd,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.backgroundGrey,
                          border: Border(
                            bottom: BorderSide(color: AppTheme.borderColor),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Invoice ID',
                                style: AppTheme.bodySmall.copyWith(
                                  color: AppTheme.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Supplier ID',
                                style: AppTheme.bodySmall.copyWith(
                                  color: AppTheme.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                'Supplier',
                                style: AppTheme.bodySmall.copyWith(
                                  color: AppTheme.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Date',
                                style: AppTheme.bodySmall.copyWith(
                                  color: AppTheme.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Total',
                                textAlign: TextAlign.right,
                                style: AppTheme.bodySmall.copyWith(
                                  color: AppTheme.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                'Status',
                                textAlign: TextAlign.center,
                                style: AppTheme.bodySmall.copyWith(
                                  color: AppTheme.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Table Rows
                      Expanded(
                        child: ListView.builder(
                          itemCount: invoices.length,
                          itemBuilder: (context, index) {
                            final invoice = invoices[index];
                            return InkWell(
                              onTap: () => _navigateToInvoiceDetail(invoice.invoiceId),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppTheme.spacingLg,
                                  vertical: AppTheme.spacingMd,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: AppTheme.borderColor.withOpacity(0.5),
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        invoice.invoiceId,
                                        style: AppTheme.bodySmall.copyWith(
                                          color: AppTheme.primaryColor,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'monospace',
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        invoice.supplierId,
                                        style: AppTheme.bodySmall.copyWith(
                                          color: AppTheme.textSecondary,
                                          fontFamily: 'monospace',
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        invoice.supplierName,
                                        style: AppTheme.bodySmall.copyWith(
                                          color: AppTheme.textPrimary,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        MyFormat.formatDate(invoice.createdDate),
                                        style: AppTheme.bodySmall.copyWith(
                                          color: AppTheme.textSecondary,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        MyFormat.formatCurrency(invoice.total),
                                        textAlign: TextAlign.right,
                                        style: AppTheme.bodySmall.copyWith(
                                          color: AppTheme.textPrimary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Center(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: AppTheme.spacingSm,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: invoice.isPaid
                                                ? AppTheme.successColor.withOpacity(0.1)
                                                : AppTheme.warningColor.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                                          ),
                                          child: Text(
                                            invoice.isPaid ? 'Paid' : 'Unpaid',
                                            style: AppTheme.bodyXSmall.copyWith(
                                              color: invoice.isPaid
                                                  ? AppTheme.successColor
                                                  : AppTheme.warningColor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
