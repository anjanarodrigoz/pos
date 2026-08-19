import 'package:flutter/material.dart';
import 'package:pos/models/invoice_item.dart';
import 'package:pos/utils/constant.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../data_sources/invoiceDataSource.dart';
import '../../enums/enums.dart';
import '../../models/extra_charges.dart';
import '../../models/invoice.dart';
import '../../models/invoice_row.dart';
import '../../theme/app_theme.dart';
import '../../utils/my_format.dart';
import '../../utils/val.dart';

/// Modern invoice detail view page showing invoice summary and items
class SaveInvoiceViewPage extends StatefulWidget {
  final Invoice invoice;

  const SaveInvoiceViewPage({super.key, required this.invoice});

  @override
  State<SaveInvoiceViewPage> createState() => _SaveInvoiceViewPageState();
}

class _SaveInvoiceViewPageState extends State<SaveInvoiceViewPage> {
  final ScrollController controller = ScrollController();
  final ScrollController controller2 = ScrollController();

  List<ExtraCharges> extraList = [];
  List<String> comments = [];
  double gstPrecentage = Val.gstPrecentage;
  List<InvoicedItem> invoicedItemList = [];
  double totalNetPrice = 0;
  double totalGstPrice = 0;
  double total = 0;
  InvoiceDataSource invoiceDataSource = InvoiceDataSource(invoiceData: []);

  @override
  Widget build(BuildContext context) {
    gstPrecentage = widget.invoice.gstPrecentage;
    extraList = widget.invoice.extraCharges ?? [];
    invoicedItemList = widget.invoice.itemList;
    comments = widget.invoice.comments ?? [];
    totalNetPrice = widget.invoice.totalNetPrice;
    totalGstPrice = widget.invoice.totalGstPrice;
    total = widget.invoice.total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Modern Invoice Summary Card
        Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: _buildInvoiceSummaryCard(),
        ),
        const SizedBox(height: AppTheme.spacingMd),
        // Invoice Items Data Grid
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
            child: _buildInvoiceItemsGrid(),
          ),
        ),
      ],
    );
  }

  /// Build modern invoice summary card
  Widget _buildInvoiceSummaryCard() {
    return Container(
      width: MediaQuery.of(context).size.width - 220,
      decoration: AppTheme.cardDecoration.copyWith(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        child: Column(
          children: [
            // Header Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Invoice Info Section
                Expanded(
                  flex: 2,
                  child: _buildInvoiceInfoSection(),
                ),
                _buildVerticalDivider(),
                // Customer Info Section
                Expanded(
                  flex: 3,
                  child: _buildCustomerInfoSection(),
                ),
                _buildVerticalDivider(),
                // Pricing Section
                Expanded(
                  flex: 2,
                  child: _buildPricingSection(),
                ),
                _buildVerticalDivider(),
                // Payment Section
                Expanded(
                  flex: 2,
                  child: _buildPaymentSection(),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMd),
            // Dates Row
            _buildDatesRow(),
          ],
        ),
      ),
    );
  }

  /// Invoice info section with ID and status
  Widget _buildInvoiceInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'INVOICE',
          style: AppTheme.labelSmall.copyWith(
            color: AppTheme.textSecondary,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: AppTheme.spacingSm),
        Text(
          '#${widget.invoice.invoiceId}',
          style: AppTheme.headlineMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: AppTheme.spacingMd),
        _buildStatusBadge(),
        if (!widget.invoice.isPaid) ...[
          const SizedBox(height: AppTheme.spacingSm),
          _buildOutstandingBadge(),
        ],
      ],
    );
  }

  /// Status badge (Paid/Unpaid)
  Widget _buildStatusBadge() {
    final isPaid = widget.invoice.isPaid;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical: AppTheme.spacingSm,
      ),
      decoration: BoxDecoration(
        color: isPaid
            ? AppTheme.successColor.withOpacity(0.1)
            : AppTheme.errorColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(
          color: isPaid ? AppTheme.successColor : AppTheme.errorColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPaid ? Icons.check_circle : Icons.cancel,
            size: 16,
            color: isPaid ? AppTheme.successColor : AppTheme.errorColor,
          ),
          const SizedBox(width: AppTheme.spacingXs),
          Text(
            isPaid ? 'PAID' : 'UNPAID',
            style: AppTheme.labelMedium.copyWith(
              color: isPaid ? AppTheme.successColor : AppTheme.errorColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// Outstanding badge showing days overdue
  Widget _buildOutstandingBadge() {
    final outstandingDays = widget.invoice.outStandingDates;
    if (outstandingDays <= const Duration(days: 0)) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical: AppTheme.spacingSm,
      ),
      decoration: BoxDecoration(
        color: AppTheme.warningColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.schedule,
            size: 16,
            color: AppTheme.warningColor,
          ),
          const SizedBox(width: AppTheme.spacingXs),
          Text(
            '$outstandingDays days overdue',
            style: AppTheme.labelSmall.copyWith(
              color: AppTheme.warningColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Customer info section
  Widget _buildCustomerInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CUSTOMER DETAILS',
          style: AppTheme.labelSmall.copyWith(
            color: AppTheme.textSecondary,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: AppTheme.spacingMd),
        _buildDetailRow(
          icon: Icons.badge_outlined,
          label: 'Customer ID',
          value: widget.invoice.customerId,
        ),
        const SizedBox(height: AppTheme.spacingSm),
        _buildDetailRow(
          icon: Icons.person_outline,
          label: 'Name',
          value: widget.invoice.customerName,
        ),
        const SizedBox(height: AppTheme.spacingSm),
        _buildDetailRow(
          icon: Icons.phone_outlined,
          label: 'Mobile',
          value: widget.invoice.customerMobile,
        ),
      ],
    );
  }

  /// Pricing section with net, GST, and total
  Widget _buildPricingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'PRICING',
          style: AppTheme.labelSmall.copyWith(
            color: AppTheme.textSecondary,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: AppTheme.spacingMd),
        _buildPriceRow(
          label: 'Net Total',
          value: totalNetPrice,
        ),
        const SizedBox(height: AppTheme.spacingSm),
        _buildPriceRow(
          label: 'GST Total',
          value: totalGstPrice,
          valueColor: AppTheme.textSecondary,
        ),
        const SizedBox(height: AppTheme.spacingSm),
        const Divider(height: 1),
        const SizedBox(height: AppTheme.spacingSm),
        _buildPriceRow(
          label: 'Total',
          value: total,
          isTotal: true,
        ),
      ],
    );
  }

  /// Payment section with paid and balance
  Widget _buildPaymentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'PAYMENT',
          style: AppTheme.labelSmall.copyWith(
            color: AppTheme.textSecondary,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: AppTheme.spacingMd),
        _buildPriceRow(
          label: 'Paid',
          value: widget.invoice.paidAmount,
          valueColor: AppTheme.successColor,
        ),
        const SizedBox(height: AppTheme.spacingSm),
        const Divider(height: 1),
        const SizedBox(height: AppTheme.spacingSm),
        _buildPriceRow(
          label: 'Balance',
          value: widget.invoice.toPay,
          valueColor: widget.invoice.toPay > 0
              ? AppTheme.errorColor
              : AppTheme.successColor,
          isTotal: true,
        ),
      ],
    );
  }

  /// Dates row showing created and closed dates
  Widget _buildDatesRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDateInfo(
          label: 'Created',
          date: widget.invoice.createdDate,
          icon: Icons.calendar_today_outlined,
        ),
        if (widget.invoice.closeDate != null)
          _buildDateInfo(
            label: 'Closed',
            date: widget.invoice.closeDate!,
            icon: Icons.event_available_outlined,
          ),
      ],
    );
  }

  /// Date info widget
  Widget _buildDateInfo({
    required String label,
    required DateTime date,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical: AppTheme.spacingSm,
      ),
      decoration: BoxDecoration(
        color: AppTheme.backgroundGrey,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: AppTheme.textSecondary,
          ),
          const SizedBox(width: AppTheme.spacingSm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTheme.labelSmall.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              Text(
                MyFormat.formatDate(date),
                style: AppTheme.labelMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Detail row with icon, label, and value
  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppTheme.textSecondary,
        ),
        const SizedBox(width: AppTheme.spacingSm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTheme.labelSmall.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              Text(
                value,
                style: AppTheme.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Price row with label and value
  Widget _buildPriceRow({
    required String label,
    required double value,
    Color? valueColor,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? AppTheme.labelLarge.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.bold,
                )
              : AppTheme.labelMedium.copyWith(
                  color: AppTheme.textSecondary,
                ),
        ),
        const SizedBox(width: AppTheme.spacingMd),
        Text(
          MyFormat.formatCurrency(value),
          style: isTotal
              ? AppTheme.headlineSmall.copyWith(
                  color: valueColor ?? AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                )
              : AppTheme.bodyMedium.copyWith(
                  color: valueColor ?? AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
        ),
      ],
    );
  }

  /// Vertical divider
  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 100,
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
      color: AppTheme.dividerColor,
    );
  }

  /// Build invoice items data grid
  Widget _buildInvoiceItemsGrid() {
    return Container(
      decoration: AppTheme.cardDecoration,
      child: SfDataGrid(
        gridLinesVisibility: GridLinesVisibility.both,
        headerGridLinesVisibility: GridLinesVisibility.both,
        allowColumnsResizing: true,
        rowHeight: Const.tableRowHeight,
        columnWidthMode: ColumnWidthMode.auto,
        allowSwiping: true,
        source: generateDataRowList(),
        headerRowHeight: 48,
        columns: [
          GridColumn(
            columnName: InvoiceRow.itemIdKey,
            label: _buildColumnHeader('Item ID'),
          ),
          GridColumn(
            columnName: InvoiceRow.nameKey,
            label: _buildColumnHeader('Item Name'),
          ),
          GridColumn(
            columnName: InvoiceRow.qtyKey,
            label: _buildColumnHeader('Qty'),
          ),
          GridColumn(
            columnName: InvoiceRow.netPriceKey,
            label: _buildColumnHeader('Net Price'),
          ),
          GridColumn(
            columnName: InvoiceRow.gstKey,
            label: _buildColumnHeader('GST'),
          ),
          GridColumn(
            columnName: InvoiceRow.itemPriceKey,
            label: _buildColumnHeader('Item Price'),
          ),
          GridColumn(
            columnName: InvoiceRow.totalKey,
            label: _buildColumnHeader('Total'),
          ),
        ],
      ),
    );
  }

  /// Build column header with modern styling
  Widget _buildColumnHeader(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical: AppTheme.spacingSm,
      ),
      alignment: Alignment.center,
      color: AppTheme.backgroundGrey,
      child: Text(
        text,
        style: AppTheme.labelLarge.copyWith(
          fontWeight: FontWeight.bold,
          color: AppTheme.textPrimary,
        ),
      ),
    );
  }

  /// Generate data row list for the data grid
  InvoiceDataSource generateDataRowList() {
    List<InvoiceRow> invoiceData = [];

    // Add invoice items
    for (InvoicedItem item in invoicedItemList) {
      String itemId = item.isPostedItem ? 'P ${item.itemId}' : item.itemId;
      invoiceData.add(InvoiceRow(
        itemId: {invoicedItemList.indexOf(item): itemId},
        itemName: {InvoiceItemCategory.item: item.name},
        gst: MyFormat.formatCurrency(
          item.netPrice * widget.invoice.gstPrecentage,
        ),
        netPrice: MyFormat.formatCurrency(item.netPrice),
        itemPrice: MyFormat.formatCurrency(
          item.netPrice * (1 + widget.invoice.gstPrecentage),
        ),
        total: MyFormat.formatCurrency(
          item.netTotal * (1 + widget.invoice.gstPrecentage),
        ),
        qty: item.qty.toString(),
      ));

      // Add item comments
      if (item.comment != null && item.comment!.isNotEmpty) {
        invoiceData += commentDataRow(item.comment!);
      }
    }

    // Add separator
    invoiceData += [
      InvoiceRow(
        itemId: {-1: ''},
        itemName: {InvoiceItemCategory.empty: ''},
      )
    ];

    // Add extra charges
    for (ExtraCharges charge in extraList) {
      double gstPrice = (charge.price * Val.gstPrecentage);
      double itemPrice = (charge.price * Val.gstTotalPrecentage);
      double totalPrice = (itemPrice * charge.qty);
      invoiceData.add(InvoiceRow(
        itemId: {
          extraList.indexOf(charge): '#${extraList.indexOf(charge) + 1}'
        },
        itemName: {InvoiceItemCategory.extraChrage: charge.name},
        gst: MyFormat.formatCurrency(gstPrice),
        netPrice: MyFormat.formatCurrency(charge.price),
        itemPrice: MyFormat.formatCurrency(itemPrice),
        total: MyFormat.formatCurrency(totalPrice),
        qty: charge.qty.toString(),
      ));

      // Add extra charge comments
      if (charge.comment != null && charge.comment!.isNotEmpty) {
        invoiceData += commentDataRow(charge.comment!);
      }
    }

    // Add separator
    invoiceData += [
      InvoiceRow(
        itemId: {-1: ''},
        itemName: {InvoiceItemCategory.empty: ''},
      )
    ];

    // Add general comments
    for (String comment in comments) {
      invoiceData += commentDataRow(comment);
    }

    // Add final separator
    invoiceData += [
      InvoiceRow(
        itemId: {-1: ''},
        itemName: {InvoiceItemCategory.empty: ''},
      )
    ];

    invoiceDataSource = InvoiceDataSource(invoiceData: invoiceData);
    return invoiceDataSource;
  }

  /// Create data rows for comments
  List<InvoiceRow> commentDataRow(String comment) {
    return comment
        .split('\n')
        .map((e) => InvoiceRow(
              itemId: {-1: ''},
              itemName: {InvoiceItemCategory.comment: e},
            ))
        .toList();
  }
}
