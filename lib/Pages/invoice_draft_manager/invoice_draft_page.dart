import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/Pages/invoice_draft_manager/invoice_item_select_page.dart';
import 'package:pos/Pages/invoice_manager/invoice_page.dart';
import 'package:pos/controllers/invoice_draft_contorller.dart';
import 'package:pos/database/cart_db_service.dart';
import 'package:pos/models/extra_charges.dart';
import 'package:pos/theme/app_theme.dart';
import 'package:pos/widgets/comments_widget.dart';
import 'package:pos/widgets/extra_charge_widget.dart';
import '../../widgets/invoice_draft_widget.dart';

/// Modern invoice draft page for creating new invoices
class InvoiceDraftPage extends StatelessWidget {
  InvoiceDraftPage({super.key});

  final InvoiceDraftController _controller = Get.find<InvoiceDraftController>();
  late BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      appBar: _buildAppBar(),
      body: Row(
        children: [
          // Modern sidebar
          _buildSidebar(),
          // Main content area
          Expanded(
            child: InvoiceDraftWidget(
              invoiceController: _controller,
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
      title: Obx(() => Row(
            children: [
              const Icon(Icons.receipt_long, size: 24),
              const SizedBox(width: AppTheme.spacingMd),
              Text(
                'Draft Invoice - #${_controller.invoiceId.value}',
                style: AppTheme.headlineMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          )),
    );
  }

  /// Build modern sidebar
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
            title: 'ADD ITEMS',
            children: [
              _buildSidebarButton(
                icon: Icons.add_shopping_cart,
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
                label: 'Save Invoice',
                color: AppTheme.successColor,
                onPressed: _saveDraftInvoice,
              ),
              _buildSidebarButton(
                icon: Icons.close,
                label: 'Close Draft',
                color: AppTheme.errorColor,
                onPressed: _closeDraft,
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
                    'Double-click items to edit. Save when ready.',
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

  /// Build sidebar section
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
          invoiceController: _controller,
        ),
      ),
    );
  }

  /// Add extra charges
  Future<void> _addExtraCharges() async {
    showDialog(
      context: context,
      builder: (context) {
        return ExtraChargeDialog(
          onPressed: (ExtraCharges extraCharges) {
            _controller.addExtraCharges(extraCharges);
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
                        _controller.addExtraCharges(extraCharges);
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

  /// Add comments
  Future<void> _addComments() async {
    String oldComment = '';
    if (_controller.comments.isNotEmpty) {
      for (String comment in _controller.comments) {
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
              _controller.addComments(comment);
            } else {
              _controller.comments.clear();
            }
          },
        );
      },
    );
  }

  /// Save draft invoice
  Future<void> _saveDraftInvoice() async {
    // Show loading dialog
    Get.dialog(
      const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(AppTheme.spacingLg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: AppTheme.spacingMd),
                Text('Saving invoice...'),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );

    try {
      await _controller.saveInvoice();
      Get.back(); // Close loading dialog

      // Show success message
      Get.snackbar(
        'Success',
        'Invoice saved successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.successColor.withOpacity(0.9),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(AppTheme.spacingMd),
        borderRadius: AppTheme.radiusMd,
      );

      Get.offAll(() => InvoicePage());
    } catch (e) {
      Get.back(); // Close loading dialog

      // Show error message
      Get.snackbar(
        'Error',
        'Failed to save invoice: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorColor.withOpacity(0.9),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(AppTheme.spacingMd),
        borderRadius: AppTheme.radiusMd,
      );
    }
  }

  /// Close draft
  Future<void> _closeDraft() async {
    final storage = CartDB();
    await storage.resetCart();
    Get.offAll(() => InvoicePage());
  }
}
