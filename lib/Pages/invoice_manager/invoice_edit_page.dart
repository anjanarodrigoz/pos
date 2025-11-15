import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/Pages/invoice_draft_manager/invoice_item_select_page.dart';
import 'package:pos/Pages/invoice_manager/invoice_edit_view.dart';
import 'package:pos/Pages/invoice_manager/invoice_page.dart';
import 'package:pos/controllers/invoice_edit_controller.dart';
import 'package:pos/database/cart_db_service.dart';
import 'package:pos/models/extra_charges.dart';
import 'package:pos/theme/app_theme.dart';
import '../../widgets/comments_widget.dart';
import '../../widgets/extra_charge_widget.dart';

/// Modern invoice edit page with sidebar actions
class InvoiceEditPage extends StatelessWidget {
  final InvoiceEditController controller;
  late BuildContext context;

  InvoiceEditPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      appBar: _buildAppBar(),
      body: Row(
        children: [
          // Sidebar with action buttons
          _buildSidebar(),
          // Main content area with invoice edit view
          Expanded(
            child: InvoiceEditView(
              invoiceController: controller,
            ),
          ),
        ],
      ),
    );
  }

  /// Build modern app bar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () async {
          await back();
        },
        tooltip: 'Cancel and go back',
      ),
      title: Row(
        children: [
          const Icon(Icons.edit_document, size: 24),
          const SizedBox(width: AppTheme.spacingMd),
          Text(
            'Edit Invoice - #${controller.invoice.invoiceId}',
            style: AppTheme.headlineMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Build sidebar with action buttons
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
            title: 'EDIT ITEMS',
            children: [
              _buildSidebarButton(
                icon: Icons.add_circle_outline,
                label: 'Add Item',
                color: AppTheme.primaryColor,
                onPressed: _addItem,
              ),
              _buildSidebarButton(
                icon: Icons.attach_money,
                label: 'Add Extra',
                onPressed: _addExtraCharges,
              ),
              _buildSidebarButton(
                icon: Icons.comment_outlined,
                label: 'Comments',
                onPressed: _addComments,
              ),
            ],
          ),
          const Divider(height: 32),
          _buildSidebarSection(
            title: 'ACTIONS',
            children: [
              _buildSidebarButton(
                icon: Icons.save_outlined,
                label: 'Update Invoice',
                color: AppTheme.successColor,
                onPressed: _updateInvoice,
              ),
              _buildSidebarButton(
                icon: Icons.close,
                label: 'Close',
                color: AppTheme.errorColor,
                onPressed: () async {
                  await back();
                },
              ),
            ],
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            child: Container(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              decoration: BoxDecoration(
                color: AppTheme.infoColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        size: 16,
                        color: AppTheme.infoColor,
                      ),
                      const SizedBox(width: AppTheme.spacingSm),
                      Text(
                        'Quick Tips',
                        style: AppTheme.labelMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.infoColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingSm),
                  Text(
                    'Double-click on any item to edit or delete',
                    style: AppTheme.bodySmall,
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

  /// Build sidebar section with title
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
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  /// Build sidebar button
  Widget _buildSidebarButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingSm,
        vertical: AppTheme.spacingXs,
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingMd,
            vertical: AppTheme.spacingMd,
          ),
          alignment: Alignment.centerLeft,
          foregroundColor: color ?? AppTheme.textPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color ?? AppTheme.textPrimary),
            const SizedBox(width: AppTheme.spacingMd),
            Expanded(
              child: Text(
                label,
                style: AppTheme.bodyMedium.copyWith(
                  color: color ?? AppTheme.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Add item dialog
  void _addItem() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: InvoiceItemSelectPage(
          invoiceEditController: controller,
        ),
      ),
    );
  }

  /// Add extra charges dialog
  Future<void> _addExtraCharges() async {
    showDialog(
      context: context,
      builder: (context) {
        return ExtraChargeDialog(
          onPressed: (ExtraCharges extraCharges) {
            controller.addExtraCharges(extraCharges);
          },
          showSavedCharges: () {
            showDialog(
              context: context,
              builder: (context) => ExtraChargeSavedDialog(
                onPressedSavedExtra: (ExtraCharges extraCharges) {
                  showDialog(
                    context: context,
                    builder: (context) => ExtraChargeDialog(
                      name: extraCharges.name,
                      comment: extraCharges.comment,
                      netPrice: extraCharges.price,
                      onPressed: (ExtraCharges extraCharges) {
                        controller.addExtraCharges(extraCharges);
                      },
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  /// Add comments dialog
  Future<void> _addComments() async {
    String oldComment = '';
    if (controller.comments.isNotEmpty) {
      for (String comment in controller.comments) {
        oldComment += comment;
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return CommentsDialog(
          oldComment: oldComment,
          onPressed: (comment) {
            if (comment.isNotEmpty) {
              controller.addComments(comment);
              controller.close();
            } else {
              controller.comments.clear();
              controller.close();
            }
          },
        );
      },
    );
  }

  /// Update invoice
  Future<void> _updateInvoice() async {
    await controller.updateInvoice();
    Get.offAll(
      () => InvoicePage(searchInvoiceId: controller.invoice.invoiceId),
    );
  }

  /// Go back and clean up
  Future<void> back() async {
    final storage = CartDB();
    await storage.resetCart();

    if (!controller.isClosed) {
      Get.delete<InvoiceEditController>();
    }
    Get.back();
  }
}
