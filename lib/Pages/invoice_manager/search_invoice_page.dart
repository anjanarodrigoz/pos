import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/Pages/invoice_manager/invoice_page.dart';
import 'package:pos/models/invoice.dart';
import 'package:pos/repositories/invoice_repository.dart';
import 'package:pos/theme/app_theme.dart';
import 'package:pos/utils/constant.dart';
import 'package:pos/utils/invoice_converter.dart';
import 'package:pos/utils/my_format.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Modern invoice search page with filtering and sorting
class InvoiceSearchPage extends StatefulWidget {
  const InvoiceSearchPage({super.key});

  @override
  State<InvoiceSearchPage> createState() => _InvoiceSearchPageState();
}

class _InvoiceSearchPageState extends State<InvoiceSearchPage> {
  final InvoiceRepository _invoiceRepo = Get.find<InvoiceRepository>();

  InvoiceDataSource invoiceDataSource = InvoiceDataSource(invoiceData: []);
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInvoices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  /// Build modern app bar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Get.offAll(() => InvoicePage()),
        icon: const Icon(Icons.arrow_back_outlined),
        tooltip: 'Back to Invoices',
      ),
      title: Row(
        children: [
          const Icon(Icons.search, size: 24),
          const SizedBox(width: AppTheme.spacingMd),
          Text(
            'Search Invoices',
            style: AppTheme.headlineMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: _refreshInvoices,
          icon: const Icon(Icons.refresh),
          tooltip: 'Refresh',
        ),
        const SizedBox(width: AppTheme.spacingSm),
      ],
    );
  }

  /// Build page body
  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      child: Column(
        children: [
          // Info card
          _buildInfoCard(),
          const SizedBox(height: AppTheme.spacingLg),
          // Search results grid
          Expanded(
            child: _buildSearchGrid(),
          ),
        ],
      ),
    );
  }

  /// Build info card with instructions
  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: AppTheme.infoColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(
          color: AppTheme.infoColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline,
            color: AppTheme.infoColor,
            size: 20,
          ),
          const SizedBox(width: AppTheme.spacingMd),
          Expanded(
            child: Text(
              'Click on the filter icon in column headers to search. Click on any row to view invoice details.',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          Text(
            '${invoiceDataSource.rows.length} invoices',
            style: AppTheme.labelLarge.copyWith(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// Build search data grid
  Widget _buildSearchGrid() {
    return Container(
      decoration: AppTheme.cardDecoration,
      child: SfDataGrid(
        gridLinesVisibility: GridLinesVisibility.both,
        headerGridLinesVisibility: GridLinesVisibility.both,
        allowFiltering: true,
        rowHeight: Const.tableRowHeight,
        allowColumnsResizing: true,
        showFilterIconOnHover: true,
        columnWidthMode: ColumnWidthMode.auto,
        source: invoiceDataSource,
        headerRowHeight: 48,
        onCellTap: _handleCellTap,
        columns: [
          GridColumn(
            width: 120.0,
            columnName: Invoice.invoiceIdKey,
            label: _buildColumnHeader('Invoice ID'),
          ),
          GridColumn(
            columnWidthMode: ColumnWidthMode.fitByCellValue,
            columnName: Invoice.customerNameKey,
            label: _buildColumnHeader('Customer Name'),
          ),
          GridColumn(
            width: 100.0,
            columnName: Invoice.customerIdKey,
            label: _buildColumnHeader('Customer ID'),
          ),
          GridColumn(
            width: 180,
            columnName: Invoice.createdDateKey,
            label: _buildColumnHeader('Date'),
          ),
          GridColumn(
            columnName: Invoice.netKey,
            label: _buildColumnHeader('Net Total'),
          ),
          GridColumn(
            columnName: Invoice.gstKey,
            label: _buildColumnHeader('GST Total'),
          ),
          GridColumn(
            columnName: Invoice.totalKey,
            label: _buildColumnHeader('Total'),
          ),
          GridColumn(
            columnName: Invoice.paykey,
            label: _buildColumnHeader('Outstanding'),
          ),
          GridColumn(
            width: 100,
            columnName: 'status',
            label: _buildColumnHeader('Status'),
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

  /// Handle cell tap to navigate to invoice
  void _handleCellTap(DataGridCellTapDetails details) {
    if (details.rowColumnIndex.rowIndex != 0) {
      int selectedRowIndex = details.rowColumnIndex.rowIndex - 1;
      var row = invoiceDataSource.effectiveRows.elementAt(selectedRowIndex);
      String invoiceId = row.getCells()[0].value;

      Get.offAll(
        () => InvoicePage(
          searchInvoiceId: invoiceId,
        ),
      );
    }
  }

  /// Load invoices from repository
  Future<void> _loadInvoices() async {
    setState(() => _isLoading = true);

    try {
      // Get all invoices from repository
      final result = await _invoiceRepo.getAllInvoices();

      if (result.isSuccess) {
        final driftInvoices = result.data ?? [];

        // Convert Drift invoices to domain invoices
        List<Invoice> domainInvoices = [];
        for (var driftInvoice in driftInvoices) {
          final fullDataResult = await _invoiceRepo.getFullInvoiceData(
            driftInvoice.invoiceId,
          );

          if (fullDataResult.isSuccess) {
            final domainInvoice = InvoiceConverter.fromFullInvoiceData(
              fullDataResult.data!,
            );
            domainInvoices.add(domainInvoice);
          }
        }

        invoiceDataSource = InvoiceDataSource(
          invoiceData: domainInvoices.reversed.toList(),
        );
      }
    } catch (e) {
      debugPrint('Error loading invoices: $e');
      _showMessage('Failed to load invoices: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Refresh invoices
  Future<void> _refreshInvoices() async {
    await _loadInvoices();
    _showMessage('Invoices refreshed', isSuccess: true);
  }

  /// Show message to user
  void _showMessage(String message, {bool isSuccess = false}) {
    Get.snackbar(
      isSuccess ? 'Success' : 'Info',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isSuccess
          ? AppTheme.successColor.withOpacity(0.9)
          : AppTheme.infoColor.withOpacity(0.9),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(AppTheme.spacingMd),
      borderRadius: AppTheme.radiusMd,
    );
  }
}

/// Data source for invoice search grid
class InvoiceDataSource extends DataGridSource {
  List<DataGridRow> _customersData = [];

  InvoiceDataSource({required List<Invoice> invoiceData}) {
    _customersData = invoiceData
        .map<DataGridRow>(
          (e) => DataGridRow(
            cells: [
              DataGridCell(
                columnName: Invoice.invoiceIdKey,
                value: e.invoiceId,
              ),
              DataGridCell(
                columnName: Invoice.customerNameKey,
                value: e.customerName,
              ),
              DataGridCell(
                columnName: Invoice.customerIdKey,
                value: e.customerId,
              ),
              DataGridCell(
                columnName: Invoice.createdDateKey,
                value: e.createdDate,
              ),
              DataGridCell(
                columnName: Invoice.netKey,
                value: e.totalNetPrice,
              ),
              DataGridCell(
                columnName: Invoice.gstKey,
                value: e.totalGstPrice,
              ),
              DataGridCell(
                columnName: Invoice.totalKey,
                value: e.total,
              ),
              DataGridCell(
                columnName: Invoice.paykey,
                value: e.toPay,
              ),
              DataGridCell(
                columnName: 'status',
                value: e.isPaid ? 'Paid' : 'Unpaid',
              ),
            ],
          ),
        )
        .toList();
  }

  @override
  List<DataGridRow> get rows => _customersData;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((e) {
        // Date column
        if (e.columnName == Invoice.createdDateKey) {
          return Container(
            alignment: Alignment.center,
            padding: Const.tableValuesPadding,
            child: Text(
              MyFormat.formatDate(e.value),
              style: AppTheme.bodyMedium,
            ),
          );
        }

        // Currency columns
        if (e.columnName == Invoice.netKey ||
            e.columnName == Invoice.gstKey ||
            e.columnName == Invoice.totalKey ||
            e.columnName == Invoice.paykey) {
          // Color-code outstanding amount
          Color? textColor;
          if (e.columnName == Invoice.paykey) {
            textColor = e.value > 0 ? AppTheme.errorColor : AppTheme.successColor;
          }

          return Container(
            alignment: Alignment.centerRight,
            padding: Const.tableValuesPadding,
            child: Text(
              MyFormat.formatCurrency(e.value),
              style: AppTheme.bodyMedium.copyWith(
                color: textColor,
                fontWeight: textColor != null ? FontWeight.w600 : null,
              ),
            ),
          );
        }

        // Status column
        if (e.columnName == 'status') {
          final isPaid = e.value == 'Paid';
          return Container(
            alignment: Alignment.center,
            padding: Const.tableValuesPadding,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingSm,
                vertical: AppTheme.spacingXs,
              ),
              decoration: BoxDecoration(
                color: isPaid
                    ? AppTheme.successColor.withOpacity(0.1)
                    : AppTheme.errorColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                border: Border.all(
                  color: isPaid ? AppTheme.successColor : AppTheme.errorColor,
                  width: 1,
                ),
              ),
              child: Text(
                e.value.toString(),
                style: AppTheme.labelSmall.copyWith(
                  color: isPaid ? AppTheme.successColor : AppTheme.errorColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }

        // Default cell
        return Container(
          alignment: Alignment.center,
          padding: Const.tableValuesPadding,
          child: Text(
            e.value.toString(),
            style: AppTheme.bodyMedium,
          ),
        );
      }).toList(),
    );
  }
}
