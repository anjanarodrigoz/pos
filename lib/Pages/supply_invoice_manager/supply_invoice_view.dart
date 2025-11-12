import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/database/pos_database.dart';
import 'package:pos/repositories/supplier_invoice_repository.dart';
import 'package:pos/theme/app_theme.dart';
import 'package:pos/utils/my_format.dart';
import 'package:pos/utils/alert_message.dart';

/// Modern supplier invoice detail/view page
class SupplyInvoiceView extends StatefulWidget {
  final String invoiceId;
  final bool isReturnNote;

  const SupplyInvoiceView({
    Key? key,
    required this.invoiceId,
    this.isReturnNote = false,
  }) : super(key: key);

  @override
  State<SupplyInvoiceView> createState() => _SupplyInvoiceViewState();
}

class _SupplyInvoiceViewState extends State<SupplyInvoiceView> {
  final SupplierInvoiceRepository _repository =
      Get.find<SupplierInvoiceRepository>();

  Future<void> _togglePaidStatus(SupplierInvoice invoice) async {
    final result =
        await _repository.markAsPaid(invoice.invoiceId, !invoice.isPaid);

    if (mounted) {
      if (result.isSuccess) {
        AlertMessage.snakMessage(
          invoice.isPaid ? 'Marked as unpaid' : 'Marked as paid',
          context,
        );
      } else {
        AlertMessage.snakMessage(
          result.error?.message ?? 'Failed to update payment status',
          context,
        );
      }
    }
  }

  Future<void> _deleteInvoice() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Invoice'),
        content: const Text(
            'Are you sure you want to delete this invoice? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.errorColor),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final result = await _repository.deleteInvoice(widget.invoiceId);
      if (mounted) {
        if (result.isSuccess) {
          Navigator.pop(context);
        } else {
          AlertMessage.snakMessage(
            result.error?.message ?? 'Failed to delete invoice',
            context,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      appBar: AppBar(
        title: StreamBuilder<SupplierInvoice>(
          stream: _repository.watchInvoice(widget.invoiceId),
          builder: (context, snapshot) {
            final invoice = snapshot.data;
            return Text(
              widget.isReturnNote
                  ? 'Return Note ${invoice?.invoiceId ?? ""}'
                  : 'Invoice ${invoice?.invoiceId ?? ""}',
              style:
                  AppTheme.headlineMedium.copyWith(color: AppTheme.textPrimary),
            );
          },
        ),
        backgroundColor: AppTheme.cardBackground,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.textPrimary),
        actions: [
          StreamBuilder<SupplierInvoice>(
            stream: _repository.watchInvoice(widget.invoiceId),
            builder: (context, snapshot) {
              final invoice = snapshot.data;
              if (invoice == null) return const SizedBox();

              return Row(
                children: [
                  IconButton(
                    icon: Icon(
                      invoice.isPaid
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                      color: invoice.isPaid
                          ? AppTheme.successColor
                          : AppTheme.textSecondary,
                    ),
                    onPressed: () => _togglePaidStatus(invoice),
                    tooltip: invoice.isPaid ? 'Mark as unpaid' : 'Mark as paid',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: _deleteInvoice,
                    tooltip: 'Delete invoice',
                  ),
                  const SizedBox(width: AppTheme.spacingSm),
                ],
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppTheme.borderColor),
        ),
      ),
      body: StreamBuilder<SupplierInvoice>(
        stream: _repository.watchInvoice(widget.invoiceId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Text(
                'Invoice not found',
                style: AppTheme.bodyMedium.copyWith(color: AppTheme.errorColor),
              ),
            );
          }

          final invoice = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Invoice Header Card
                _buildInvoiceHeaderCard(invoice),

                const SizedBox(height: AppTheme.spacingLg),

                // Invoice Items
                _buildInvoiceItemsCard(invoice),

                const SizedBox(height: AppTheme.spacingLg),

                // Extra Charges (if any)
                if (invoice.extraChargesJson != null)
                  _buildExtraChargesCard(invoice),

                const SizedBox(height: AppTheme.spacingLg),

                // Comments (if any)
                if (invoice.commentsJson != null) _buildCommentsCard(invoice),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInvoiceHeaderCard(SupplierInvoice invoice) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(color: AppTheme.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      invoice.supplierName,
                      style: AppTheme.headlineSmall.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingXs),
                    _buildDetailRow('Supplier ID', invoice.supplierId),
                    if (invoice.supplierMobile != null)
                      _buildDetailRow('Mobile', invoice.supplierMobile!),
                    if (invoice.supplierEmail != null)
                      _buildDetailRow('Email', invoice.supplierEmail!),
                    if (invoice.referenceId != null)
                      _buildDetailRow('Reference ID', invoice.referenceId!),
                    _buildDetailRow(
                        'Date', MyFormat.formatDate(invoice.createdDate)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingMd,
                      vertical: AppTheme.spacingSm,
                    ),
                    decoration: BoxDecoration(
                      color: invoice.isPaid
                          ? AppTheme.successColor.withOpacity(0.1)
                          : AppTheme.warningColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                    ),
                    child: Text(
                      invoice.isPaid ? 'PAID' : 'UNPAID',
                      style: AppTheme.bodySmall.copyWith(
                        color: invoice.isPaid
                            ? AppTheme.successColor
                            : AppTheme.warningColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingMd),
                  _buildTotalRow('Net Total', invoice.totalNet),
                  _buildTotalRow(
                      'GST (${(invoice.gstPercentage * 100).toStringAsFixed(1)}%)',
                      invoice.totalGst),
                  const Divider(),
                  _buildTotalRow('Total', invoice.total, isTotal: true),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceItemsCard(SupplierInvoice invoice) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(color: AppTheme.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            child: Row(
              children: [
                const Icon(Icons.inventory_2_outlined,
                    color: AppTheme.primaryColor),
                const SizedBox(width: AppTheme.spacingSm),
                Text(
                  'Invoice Items',
                  style: AppTheme.headlineSmall.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          StreamBuilder<List<SupplierInvoiceItem>>(
            stream: _repository.watchInvoiceItems(invoice.invoiceId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(AppTheme.spacingLg),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final items = snapshot.data ?? [];

              if (items.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingLg),
                  child: Text(
                    'No items in this invoice',
                    style: AppTheme.bodyMedium
                        .copyWith(color: AppTheme.textSecondary),
                  ),
                );
              }

              return Column(
                children: [
                  // Table Header
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingLg,
                      vertical: AppTheme.spacingMd,
                    ),
                    decoration: const BoxDecoration(
                      color: AppTheme.backgroundGrey,
                      border: Border(
                        top: BorderSide(color: AppTheme.borderColor),
                        bottom: BorderSide(color: AppTheme.borderColor),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Item',
                            style: AppTheme.bodySmall.copyWith(
                              color: AppTheme.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Qty',
                            textAlign: TextAlign.center,
                            style: AppTheme.bodySmall.copyWith(
                              color: AppTheme.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Buying Price',
                            textAlign: TextAlign.right,
                            style: AppTheme.bodySmall.copyWith(
                              color: AppTheme.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Net Total',
                            textAlign: TextAlign.right,
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
                  ...items
                      .map((item) => Container(
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        item.itemName,
                                        style: AppTheme.bodySmall.copyWith(
                                          color: AppTheme.textPrimary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        item.quantity.toString(),
                                        textAlign: TextAlign.center,
                                        style: AppTheme.bodySmall.copyWith(
                                          color: AppTheme.textPrimary,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        MyFormat.formatCurrency(
                                            item.buyingPrice),
                                        textAlign: TextAlign.right,
                                        style: AppTheme.bodySmall.copyWith(
                                          color: AppTheme.textSecondary,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        MyFormat.formatCurrency(item.netPrice),
                                        textAlign: TextAlign.right,
                                        style: AppTheme.bodySmall.copyWith(
                                          color: AppTheme.textPrimary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (item.comment != null &&
                                    item.comment!.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: AppTheme.spacingSm),
                                    child: Text(
                                      item.comment!,
                                      style: AppTheme.bodySmall.copyWith(
                                        color: AppTheme.textSecondary,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ))
                      .toList(),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildExtraChargesCard(SupplierInvoice invoice) {
    try {
      final extraCharges = jsonDecode(invoice.extraChargesJson!) as List;

      if (extraCharges.isEmpty) return const SizedBox();

      return Container(
        decoration: BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          border: Border.all(color: AppTheme.borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.add_circle_outline,
                    color: AppTheme.primaryColor),
                const SizedBox(width: AppTheme.spacingSm),
                Text(
                  'Extra Charges',
                  style: AppTheme.headlineSmall.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMd),
            ...extraCharges.map((charge) {
              final description = charge['description'] ?? '';
              final amount = charge['amount'] ?? 0.0;

              return Padding(
                padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      description,
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      MyFormat.formatCurrency(amount),
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      );
    } catch (e) {
      return const SizedBox();
    }
  }

  Widget _buildCommentsCard(SupplierInvoice invoice) {
    try {
      final comments = jsonDecode(invoice.commentsJson!) as List;

      if (comments.isEmpty) return const SizedBox();

      return Container(
        decoration: BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          border: Border.all(color: AppTheme.borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.comment_outlined,
                    color: AppTheme.primaryColor),
                const SizedBox(width: AppTheme.spacingSm),
                Text(
                  'Comments',
                  style: AppTheme.headlineSmall.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMd),
            ...comments.map((comment) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
                child: Text(
                  comment.toString(),
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      );
    } catch (e) {
      return const SizedBox();
    }
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingXs),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          Text(
            value,
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingXs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style:
                (isTotal ? AppTheme.bodyMedium : AppTheme.bodySmall).copyWith(
              color: AppTheme.textSecondary,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          const SizedBox(width: AppTheme.spacingMd),
          Text(
            MyFormat.formatCurrency(amount),
            style:
                (isTotal ? AppTheme.bodyLarge : AppTheme.bodyMedium).copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
