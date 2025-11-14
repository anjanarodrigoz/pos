import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/Pages/invoice_draft_manager/invoice_customer_view.dart';
import 'package:pos/datasources/customer_data_source.dart';
import 'package:pos/enums/enums.dart';
import 'package:pos/repositories/customer_repository.dart';
import 'package:pos/theme/app_theme.dart';
import 'package:pos/utils/constant.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../models/address.dart';
import '../../models/customer.dart';
import '../../models/invoice.dart';

/// Modern customer selection page for invoice creation
class InvoiceCustomerSelectPage extends StatefulWidget {
  final Invoice? invoice;
  final InvoiceType invoiceType;

  const InvoiceCustomerSelectPage({
    super.key,
    this.invoice,
    required this.invoiceType,
  });

  @override
  State<InvoiceCustomerSelectPage> createState() =>
      _InvoiceCustomerSelectPageState();
}

class _InvoiceCustomerSelectPageState
    extends State<InvoiceCustomerSelectPage> {
  final DataGridController _dataGridController = DataGridController();
  final CustomerRepository _customerRepo = Get.find<CustomerRepository>();

  CustomerDataSource customerDataSource =
      CustomerDataSource(customersData: []);
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCustomers();
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
      title: Row(
        children: [
          const Icon(Icons.person_search, size: 24),
          const SizedBox(width: AppTheme.spacingMd),
          Text(
            'Select Customer',
            style: AppTheme.headlineMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: _refreshCustomers,
          icon: const Icon(Icons.refresh),
          tooltip: 'Refresh customers',
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

    return Column(
      children: [
        _buildInfoCard(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            child: Container(
              decoration: AppTheme.cardDecoration,
              child: SfDataGrid(
                selectionMode: SelectionMode.single,
                controller: _dataGridController,
                gridLinesVisibility: GridLinesVisibility.both,
                headerGridLinesVisibility: GridLinesVisibility.both,
                allowFiltering: true,
                rowHeight: Const.tableRowHeight,
                allowColumnsResizing: true,
                showFilterIconOnHover: true,
                columnWidthMode: ColumnWidthMode.auto,
                headerRowHeight: 48,
                onCellDoubleTap: _handleCustomerSelect,
                source: customerDataSource,
                columns: [
                  GridColumn(
                    columnName: Customer.idKey,
                    label: _buildColumnHeader('ID'),
                  ),
                  GridColumn(
                    columnName: Customer.firstNameKey,
                    label: _buildColumnHeader('First Name'),
                  ),
                  GridColumn(
                    columnName: Customer.lastNameKey,
                    label: _buildColumnHeader('Last Name'),
                  ),
                  GridColumn(
                    columnName: Customer.mobileNumberKey,
                    label: _buildColumnHeader('Mobile'),
                  ),
                  GridColumn(
                    columnName: Customer.emailKey,
                    label: _buildColumnHeader('Email'),
                  ),
                  GridColumn(
                    columnName: Address.cityKey,
                    label: _buildColumnHeader('City'),
                  ),
                  GridColumn(
                    columnName: Address.postalCodeKey,
                    label: _buildColumnHeader('Postal Code'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Build info card
  Widget _buildInfoCard() {
    return Container(
      margin: const EdgeInsets.all(AppTheme.spacingLg),
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
              'Double-click on a customer to select and continue with invoice creation. Use column filters to search.',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          Text(
            '${customerDataSource.rows.length} customers',
            style: AppTheme.labelLarge.copyWith(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// Build column header
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

  /// Handle customer selection
  void _handleCustomerSelect(DataGridCellDoubleTapDetails details) {
    if (details.rowColumnIndex.rowIndex != 0) {
      String cusId = customerDataSource.effectiveRows
          .elementAt(details.rowColumnIndex.rowIndex - 1)
          .getCells()[0]
          .value;

      Get.to(() => InvoiceCustomerViewPage(
            invoiceType: widget.invoiceType,
            cusId: cusId,
            invoice: widget.invoice,
          ));
    }
  }

  /// Load customers from repository
  Future<void> _loadCustomers() async {
    setState(() => _isLoading = true);

    try {
      final result = await _customerRepo.getAllCustomers();

      if (result.isSuccess) {
        final driftCustomers = result.data ?? [];

        // Convert Drift customers to domain Customer models
        final List<Customer> domainCustomers =
            driftCustomers.map((driftCustomer) {
          return Customer(
            id: driftCustomer.customerId,
            firstName: driftCustomer.firstName,
            lastName: driftCustomer.lastName,
            mobileNumber: driftCustomer.mobileNumber,
            email: driftCustomer.email,
            fax: driftCustomer.fax,
            web: driftCustomer.web,
            abn: driftCustomer.abn,
            acn: driftCustomer.acn,
            comment: driftCustomer.comment,
            deliveryAddress: driftCustomer.deliveryAddress != null
                ? Address.fromJson(driftCustomer.deliveryAddress!)
                : null,
            postalAddress: driftCustomer.postalAddress != null
                ? Address.fromJson(driftCustomer.postalAddress!)
                : null,
          );
        }).toList();

        customerDataSource = CustomerDataSource(customersData: domainCustomers);
      }
    } catch (e) {
      debugPrint('Error loading customers: $e');
      _showMessage('Failed to load customers: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Refresh customers
  Future<void> _refreshCustomers() async {
    await _loadCustomers();
    _showMessage('Customers refreshed', isSuccess: true);
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
