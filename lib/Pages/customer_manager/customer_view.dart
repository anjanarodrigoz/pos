import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pos/database/pos_database.dart';
import 'package:pos/repositories/customer_repository.dart';
import 'package:pos/theme/app_theme.dart';
import 'package:pos/utils/result.dart';

/// Customer detail/edit page with stats and actions
class CustomerViewPage extends StatefulWidget {
  final String customerId;

  const CustomerViewPage({Key? key, required this.customerId}) : super(key: key);

  @override
  State<CustomerViewPage> createState() => _CustomerViewPageState();
}

class _CustomerViewPageState extends State<CustomerViewPage> {
  final CustomerRepository _repository = Get.find<CustomerRepository>();
  bool _isEditMode = false;
  bool _isLoading = false;

  // Edit controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _faxController = TextEditingController();
  final _webController = TextEditingController();
  final _abnController = TextEditingController();
  final _acnController = TextEditingController();
  final _commentController = TextEditingController();
  final _billingStreetController = TextEditingController();
  final _billingCityController = TextEditingController();
  final _billingStateController = TextEditingController();
  final _billingAreaCodeController = TextEditingController();
  final _billingPostalCodeController = TextEditingController();
  final _billingCountryController = TextEditingController();
  final _postalStreetController = TextEditingController();
  final _postalCityController = TextEditingController();
  final _postalStateController = TextEditingController();
  final _postalAreaCodeController = TextEditingController();
  final _postalPostalCodeController = TextEditingController();
  final _postalCountryController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _faxController.dispose();
    _webController.dispose();
    _abnController.dispose();
    _acnController.dispose();
    _commentController.dispose();
    _billingStreetController.dispose();
    _billingCityController.dispose();
    _billingStateController.dispose();
    _billingAreaCodeController.dispose();
    _billingPostalCodeController.dispose();
    _billingCountryController.dispose();
    _postalStreetController.dispose();
    _postalCityController.dispose();
    _postalStateController.dispose();
    _postalAreaCodeController.dispose();
    _postalPostalCodeController.dispose();
    _postalCountryController.dispose();
    super.dispose();
  }

  void _populateControllers(Customer customer) {
    _firstNameController.text = customer.firstName;
    _lastNameController.text = customer.lastName;
    _mobileController.text = customer.mobileNumber ?? '';
    _emailController.text = customer.email ?? '';
    _faxController.text = customer.fax ?? '';
    _webController.text = customer.web ?? '';
    _abnController.text = customer.abn ?? '';
    _acnController.text = customer.acn ?? '';
    _commentController.text = customer.comment ?? '';
    _billingStreetController.text = customer.billingStreet ?? '';
    _billingCityController.text = customer.billingCity ?? '';
    _billingStateController.text = customer.billingState ?? '';
    _billingAreaCodeController.text = customer.billingAreaCode ?? '';
    _billingPostalCodeController.text = customer.billingPostalCode ?? '';
    _billingCountryController.text = customer.billingCountry ?? '';
    _postalStreetController.text = customer.postalStreet ?? '';
    _postalCityController.text = customer.postalCity ?? '';
    _postalStateController.text = customer.postalState ?? '';
    _postalAreaCodeController.text = customer.postalAreaCode ?? '';
    _postalPostalCodeController.text = customer.postalPostalCode ?? '';
    _postalCountryController.text = customer.postalCountry ?? '';
  }

  Future<void> _saveChanges(Customer originalCustomer) async {
    setState(() {
      _isLoading = true;
    });

    final updatedCustomer = Customer(
      id: originalCustomer.id,
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      mobileNumber: _mobileController.text.trim().isEmpty
          ? null
          : _mobileController.text.trim(),
      email: _emailController.text.trim().isEmpty
          ? null
          : _emailController.text.trim(),
      fax: _faxController.text.trim().isEmpty ? null : _faxController.text.trim(),
      web: _webController.text.trim().isEmpty ? null : _webController.text.trim(),
      abn: _abnController.text.trim().isEmpty ? null : _abnController.text.trim(),
      acn: _acnController.text.trim().isEmpty ? null : _acnController.text.trim(),
      comment: _commentController.text.trim().isEmpty
          ? null
          : _commentController.text.trim(),
      billingStreet: _billingStreetController.text.trim().isEmpty
          ? null
          : _billingStreetController.text.trim(),
      billingCity: _billingCityController.text.trim().isEmpty
          ? null
          : _billingCityController.text.trim(),
      billingState: _billingStateController.text.trim().isEmpty
          ? null
          : _billingStateController.text.trim(),
      billingAreaCode: _billingAreaCodeController.text.trim().isEmpty
          ? null
          : _billingAreaCodeController.text.trim(),
      billingPostalCode: _billingPostalCodeController.text.trim().isEmpty
          ? null
          : _billingPostalCodeController.text.trim(),
      billingCountry: _billingCountryController.text.trim().isEmpty
          ? null
          : _billingCountryController.text.trim(),
      postalStreet: _postalStreetController.text.trim().isEmpty
          ? null
          : _postalStreetController.text.trim(),
      postalCity: _postalCityController.text.trim().isEmpty
          ? null
          : _postalCityController.text.trim(),
      postalState: _postalStateController.text.trim().isEmpty
          ? null
          : _postalStateController.text.trim(),
      postalAreaCode: _postalAreaCodeController.text.trim().isEmpty
          ? null
          : _postalAreaCodeController.text.trim(),
      postalPostalCode: _postalPostalCodeController.text.trim().isEmpty
          ? null
          : _postalPostalCodeController.text.trim(),
      postalCountry: _postalCountryController.text.trim().isEmpty
          ? null
          : _postalCountryController.text.trim(),
      encryptedData: originalCustomer.encryptedData,
      createdAt: originalCustomer.createdAt,
      updatedAt: DateTime.now(),
    );

    final result = await _repository.updateCustomer(updatedCustomer);

    setState(() {
      _isLoading = false;
    });

    if (result.isSuccess) {
      setState(() {
        _isEditMode = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Customer updated successfully'),
            backgroundColor: AppTheme.successColor,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.error?.message ?? 'Failed to update customer'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  Future<void> _deleteCustomer() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Customer'),
        content: const Text(
          'Are you sure you want to delete this customer? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: AppTheme.errorButtonStyle(),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isLoading = true;
    });

    final result = await _repository.deleteCustomer(widget.customerId);

    setState(() {
      _isLoading = false;
    });

    if (result.isSuccess) {
      if (mounted) {
        Navigator.pop(context, 'deleted');
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.error?.message ?? 'Failed to delete customer'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Customer>(
      stream: _repository.watchCustomer(widget.customerId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: const Text('Customer Details')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(title: const Text('Customer Details')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: AppTheme.errorColor,
                  ),
                  const SizedBox(height: AppTheme.spacingMd),
                  Text(
                    'Customer not found',
                    style: AppTheme.headlineSmall,
                  ),
                ],
              ),
            ),
          );
        }

        final customer = snapshot.data!;

        // Populate controllers when entering edit mode
        if (_isEditMode && _firstNameController.text.isEmpty) {
          _populateControllers(customer);
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Customer Details'),
            elevation: 0,
            actions: [
              if (!_isEditMode)
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      _isEditMode = true;
                      _populateControllers(customer);
                    });
                  },
                  tooltip: 'Edit',
                ),
              if (!_isEditMode)
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: _deleteCustomer,
                  tooltip: 'Delete',
                ),
              if (_isEditMode)
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _isEditMode = false;
                    });
                  },
                  tooltip: 'Cancel',
                ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            children: [
              // Customer Header
              _buildHeaderCard(customer),

              const SizedBox(height: AppTheme.spacingMd),

              // Customer Statistics
              _buildStatsCard(),

              const SizedBox(height: AppTheme.spacingLg),

              // Customer Details
              _buildDetailsCard(customer),

              const SizedBox(height: AppTheme.spacingLg),

              // Billing Address
              _buildBillingAddressCard(customer),

              const SizedBox(height: AppTheme.spacingLg),

              // Postal Address
              _buildPostalAddressCard(customer),

              if (_isEditMode) ...[
                const SizedBox(height: AppTheme.spacingXl),
                SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : () => _saveChanges(customer),
                    icon: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.save),
                    label: Text(_isLoading ? 'Saving...' : 'Save Changes'),
                    style: AppTheme.successButtonStyle(),
                  ),
                ),
              ],

              const SizedBox(height: AppTheme.spacingMd),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeaderCard(Customer customer) {
    return Container(
      decoration: AppTheme.cardDecoration.copyWith(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      child: Row(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: Colors.white,
            child: Text(
              '${customer.firstName[0]}${customer.lastName[0]}'.toUpperCase(),
              style: AppTheme.displaySmall.copyWith(
                color: AppTheme.primaryColor,
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${customer.firstName} ${customer.lastName}',
                  style: AppTheme.headlineLarge.copyWith(color: Colors.white),
                ),
                const SizedBox(height: AppTheme.spacingXs),
                Text(
                  customer.id,
                  style: AppTheme.bodyMedium.copyWith(
                    color: Colors.white70,
                    fontFamily: 'monospace',
                  ),
                ),
                if (customer.email != null) ...[
                  const SizedBox(height: AppTheme.spacingXs),
                  Text(
                    customer.email!,
                    style: AppTheme.bodyMedium.copyWith(color: Colors.white70),
                  ),
                ],
                if (customer.mobileNumber != null) ...[
                  const SizedBox(height: AppTheme.spacingXs),
                  Text(
                    customer.mobileNumber!,
                    style: AppTheme.bodyMedium.copyWith(color: Colors.white70),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
    return FutureBuilder<Result<CustomerStats>>(
      future: _repository.getCustomerStats(widget.customerId),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!.isSuccess) {
          return const SizedBox.shrink();
        }

        final stats = snapshot.data!.data!;
        final currencyFormat = NumberFormat.currency(symbol: '\$');

        return Container(
          decoration: AppTheme.cardDecoration,
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Total Invoices',
                  stats.totalInvoices.toString(),
                  Icons.receipt_long,
                  AppTheme.primaryColor,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: AppTheme.dividerColor,
              ),
              Expanded(
                child: _buildStatItem(
                  'Total Spent',
                  currencyFormat.format(stats.totalSpent),
                  Icons.payments,
                  AppTheme.successColor,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: AppTheme.dividerColor,
              ),
              Expanded(
                child: _buildStatItem(
                  'Outstanding',
                  currencyFormat.format(stats.outstandingBalance),
                  Icons.account_balance_wallet,
                  stats.outstandingBalance > 0
                      ? AppTheme.warningColor
                      : AppTheme.successColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: AppTheme.spacingXs),
        Text(
          value,
          style: AppTheme.headlineSmall.copyWith(color: color),
        ),
        Text(
          label,
          style: AppTheme.labelSmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDetailsCard(Customer customer) {
    return Container(
      decoration: AppTheme.cardDecoration,
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.person_outline, color: AppTheme.primaryColor),
              const SizedBox(width: AppTheme.spacingSm),
              Text('Customer Details', style: AppTheme.headlineSmall),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMd),
          const Divider(),
          const SizedBox(height: AppTheme.spacingMd),
          if (_isEditMode) ...[
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _firstNameController,
                    decoration: AppTheme.inputDecoration(labelText: 'First Name'),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingMd),
                Expanded(
                  child: TextField(
                    controller: _lastNameController,
                    decoration: AppTheme.inputDecoration(labelText: 'Last Name'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMd),
            TextField(
              controller: _mobileController,
              decoration: AppTheme.inputDecoration(labelText: 'Mobile'),
            ),
            const SizedBox(height: AppTheme.spacingMd),
            TextField(
              controller: _emailController,
              decoration: AppTheme.inputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _faxController,
                    decoration: AppTheme.inputDecoration(labelText: 'Fax'),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingMd),
                Expanded(
                  child: TextField(
                    controller: _webController,
                    decoration: AppTheme.inputDecoration(labelText: 'Website'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _abnController,
                    decoration: AppTheme.inputDecoration(labelText: 'ABN'),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingMd),
                Expanded(
                  child: TextField(
                    controller: _acnController,
                    decoration: AppTheme.inputDecoration(labelText: 'ACN'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMd),
            TextField(
              controller: _commentController,
              decoration: AppTheme.inputDecoration(labelText: 'Comments'),
              maxLines: 3,
            ),
          ] else ...[
            _buildDetailRow('Mobile', customer.mobileNumber),
            _buildDetailRow('Email', customer.email),
            _buildDetailRow('Fax', customer.fax),
            _buildDetailRow('Website', customer.web),
            _buildDetailRow('ABN', customer.abn),
            _buildDetailRow('ACN', customer.acn),
            _buildDetailRow('Comments', customer.comment),
          ],
        ],
      ),
    );
  }

  Widget _buildBillingAddressCard(Customer customer) {
    return Container(
      decoration: AppTheme.cardDecoration,
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.home_outlined, color: AppTheme.primaryColor),
              const SizedBox(width: AppTheme.spacingSm),
              Text('Billing/Delivery Address', style: AppTheme.headlineSmall),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMd),
          const Divider(),
          const SizedBox(height: AppTheme.spacingMd),
          if (_isEditMode) ...[
            TextField(
              controller: _billingStreetController,
              decoration: AppTheme.inputDecoration(labelText: 'Street'),
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _billingCityController,
                    decoration: AppTheme.inputDecoration(labelText: 'City'),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingMd),
                Expanded(
                  child: TextField(
                    controller: _billingStateController,
                    decoration: AppTheme.inputDecoration(labelText: 'State'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _billingAreaCodeController,
                    decoration: AppTheme.inputDecoration(labelText: 'Area Code'),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingMd),
                Expanded(
                  child: TextField(
                    controller: _billingPostalCodeController,
                    decoration: AppTheme.inputDecoration(labelText: 'Postal Code'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMd),
            TextField(
              controller: _billingCountryController,
              decoration: AppTheme.inputDecoration(labelText: 'Country'),
            ),
          ] else ...[
            _buildDetailRow('Street', customer.billingStreet),
            _buildDetailRow('City', customer.billingCity),
            _buildDetailRow('State', customer.billingState),
            _buildDetailRow('Area Code', customer.billingAreaCode),
            _buildDetailRow('Postal Code', customer.billingPostalCode),
            _buildDetailRow('Country', customer.billingCountry),
          ],
        ],
      ),
    );
  }

  Widget _buildPostalAddressCard(Customer customer) {
    return Container(
      decoration: AppTheme.cardDecoration,
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.mail_outline, color: AppTheme.primaryColor),
              const SizedBox(width: AppTheme.spacingSm),
              Text('Postal Address', style: AppTheme.headlineSmall),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMd),
          const Divider(),
          const SizedBox(height: AppTheme.spacingMd),
          if (_isEditMode) ...[
            TextField(
              controller: _postalStreetController,
              decoration: AppTheme.inputDecoration(labelText: 'Street'),
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _postalCityController,
                    decoration: AppTheme.inputDecoration(labelText: 'City'),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingMd),
                Expanded(
                  child: TextField(
                    controller: _postalStateController,
                    decoration: AppTheme.inputDecoration(labelText: 'State'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _postalAreaCodeController,
                    decoration: AppTheme.inputDecoration(labelText: 'Area Code'),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingMd),
                Expanded(
                  child: TextField(
                    controller: _postalPostalCodeController,
                    decoration: AppTheme.inputDecoration(labelText: 'Postal Code'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMd),
            TextField(
              controller: _postalCountryController,
              decoration: AppTheme.inputDecoration(labelText: 'Country'),
            ),
          ] else ...[
            _buildDetailRow('Street', customer.postalStreet),
            _buildDetailRow('City', customer.postalCity),
            _buildDetailRow('State', customer.postalState),
            _buildDetailRow('Area Code', customer.postalAreaCode),
            _buildDetailRow('Postal Code', customer.postalPostalCode),
            _buildDetailRow('Country', customer.postalCountry),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    if (value == null || value.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: AppTheme.labelMedium,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
