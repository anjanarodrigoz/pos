import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/Pages/credit_note_manager/credit_draft_page.dart';
import 'package:pos/Pages/invoice_draft_manager/invoice_draft_page.dart';
import 'package:pos/controllers/credit_draft_controller.dart';
import 'package:pos/controllers/invoice_draft_contorller.dart';
import 'package:pos/controllers/quote_draft_controller.dart';
import 'package:pos/enums/enums.dart';
import 'package:pos/repositories/customer_repository.dart';
import 'package:pos/theme/app_theme.dart';
import '../../models/address.dart';
import '../../models/customer.dart';
import '../../models/invoice.dart';
import '../../widgets/pos_text_form_field.dart';
import '../quotation_manager/quatation_draft_page.dart';

/// Modern customer details view for invoice creation
class InvoiceCustomerViewPage extends StatefulWidget {
  final String cusId;
  final Invoice? invoice;
  final InvoiceType invoiceType;

  const InvoiceCustomerViewPage({
    super.key,
    required this.cusId,
    this.invoice,
    required this.invoiceType,
  });

  @override
  State<InvoiceCustomerViewPage> createState() =>
      _InvoiceCustomerViewPageState();
}

class _InvoiceCustomerViewPageState extends State<InvoiceCustomerViewPage> {
  late Customer _customer;
  final _formKey = GlobalKey<FormState>();
  final Address deliveryAddress = Address();
  final Address postalAddress = Address();
  final CustomerRepository _customerRepo = Get.find<CustomerRepository>();
  Invoice? invoice;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCustomer();
    invoice = widget.invoice;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: _buildAppBar(),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        color: AppTheme.backgroundColor,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.spacingLg),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCustomerDetailsCard(),
                        const SizedBox(width: AppTheme.spacingLg),
                        Column(
                          children: [
                            _buildAddressesRow(),
                            const SizedBox(height: AppTheme.spacingLg),
                            _buildCommentCard(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  /// Build modern app bar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      title: _isLoading
          ? const Text('Loading...')
          : Text(
              '${_customer.firstName} ${_customer.lastName} - #${_customer.id}',
              style: AppTheme.headlineSmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
    );
  }

  /// Build customer details card
  Widget _buildCustomerDetailsCard() {
    return Container(
      width: 400,
      decoration: AppTheme.cardDecoration,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CUSTOMER DETAILS',
              style: AppTheme.labelMedium.copyWith(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: AppTheme.spacingLg),
            PosTextFormField(
              initialValue: _customer.firstName,
              labelText: 'First Name',
              onSaved: (value) => _customer.firstName = value!,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter first name';
                }
                return null;
              },
            ),
            PosTextFormField(
              initialValue: _customer.lastName,
              labelText: 'Last Name',
              onSaved: (value) => _customer.lastName = value!,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter last name';
                }
                return null;
              },
            ),
            PosTextFormField(
              initialValue: _customer.mobileNumber,
              labelText: 'Mobile Number',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter mobile number';
                }
                return null;
              },
              onSaved: (value) => _customer.mobileNumber = value!,
            ),
            PosTextFormField(
              initialValue: _customer.email ?? '',
              labelText: 'Email',
              onSaved: (value) => _customer.email = value,
            ),
            PosTextFormField(
              initialValue: _customer.fax ?? '',
              labelText: 'Fax',
              onSaved: (value) => _customer.fax = value,
            ),
            PosTextFormField(
              initialValue: _customer.web ?? '',
              labelText: 'Web',
              onSaved: (value) => _customer.web = value,
            ),
            PosTextFormField(
              initialValue: _customer.abn ?? '',
              labelText: 'ABN',
              onSaved: (value) => _customer.abn = value,
            ),
            PosTextFormField(
              initialValue: _customer.acn ?? '',
              labelText: 'ACN',
              onSaved: (value) => _customer.acn = value,
            ),
          ],
        ),
      ),
    );
  }

  /// Build addresses row
  Widget _buildAddressesRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAddressCard(
          title: 'DELIVERY ADDRESS',
          initialAddress: _customer.deliveryAddress,
          address: deliveryAddress,
        ),
        const SizedBox(width: AppTheme.spacingLg),
        _buildAddressCard(
          title: 'POSTAL ADDRESS',
          initialAddress: _customer.postalAddress,
          address: postalAddress,
        ),
      ],
    );
  }

  /// Build address card
  Widget _buildAddressCard({
    required String title,
    Address? initialAddress,
    required Address address,
  }) {
    return Container(
      width: 320,
      decoration: AppTheme.cardDecoration,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTheme.labelMedium.copyWith(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: AppTheme.spacingLg),
            PosTextFormField(
              initialValue: initialAddress?.street ?? '',
              labelText: 'Street',
              onSaved: (value) => address.street = value,
            ),
            PosTextFormField(
              initialValue: initialAddress?.city ?? '',
              labelText: 'City',
              onSaved: (value) => address.city = value,
            ),
            PosTextFormField(
              initialValue: initialAddress?.state ?? '',
              labelText: 'State',
              onSaved: (value) => address.state = value,
            ),
            PosTextFormField(
              initialValue: initialAddress?.areaCode ?? '',
              labelText: 'Area Code',
              onSaved: (value) => address.areaCode = value,
            ),
            PosTextFormField(
              initialValue: initialAddress?.postalCode ?? '',
              labelText: 'Postal Code',
              onSaved: (value) => address.postalCode = value,
            ),
            PosTextFormField(
              initialValue: initialAddress?.county ?? '',
              labelText: 'Country',
              onSaved: (value) => address.county = value,
            ),
          ],
        ),
      ),
    );
  }

  /// Build comment card
  Widget _buildCommentCard() {
    return Container(
      width: 660,
      decoration: AppTheme.cardDecoration,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CUSTOMER COMMENT',
              style: AppTheme.labelMedium.copyWith(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: AppTheme.spacingLg),
            PosTextFormField(
              initialValue: _customer.comment ?? '',
              labelText: 'Comment',
              onSaved: (value) => _customer.comment = value,
              maxLines: 3,
              height: 100,
            ),
          ],
        ),
      ),
    );
  }

  /// Build bottom bar with continue button
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton.icon(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Back'),
            style: AppTheme.textButtonStyle(),
          ),
          const SizedBox(width: AppTheme.spacingMd),
          ElevatedButton.icon(
            onPressed: _updateCustomerDetails,
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Continue to Invoice'),
            style: AppTheme.primaryButtonStyle().copyWith(
              padding: const WidgetStatePropertyAll(
                EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingLg,
                  vertical: AppTheme.spacingMd,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Load customer from repository
  Future<void> _loadCustomer() async {
    try {
      final result = await _customerRepo.getCustomer(widget.cusId);

      if (result.isSuccess && result.data != null) {
        final driftCustomer = result.data!;

        setState(() {
          _customer = Customer(
            id: driftCustomer.id,
            firstName: driftCustomer.firstName,
            lastName: driftCustomer.lastName,
            mobileNumber: driftCustomer.mobileNumber??"",
            email: driftCustomer.email,
            fax: driftCustomer.fax,
            web: driftCustomer.web,
            abn: driftCustomer.abn,
            acn: driftCustomer.acn,
            comment: driftCustomer.comment,
            deliveryAddress: driftCustomer.postalStreet != null
                ? Address(
                    areaCode: driftCustomer.postalAreaCode,
                    city: driftCustomer.postalCity,
                    county: driftCustomer.postalCountry,
                    postalCode: driftCustomer.postalPostalCode,
                    state: driftCustomer.postalState,
                    street: driftCustomer.postalStreet,
                  )
                : null,
            postalAddress: driftCustomer.billingStreet != null
                ? Address(
                    areaCode: driftCustomer.billingAreaCode,
                    city: driftCustomer.billingCity,
                    county: driftCustomer.billingCountry,
                    postalCode: driftCustomer.billingPostalCode,
                    state: driftCustomer.billingState,
                    street: driftCustomer.billingStreet,
                  )
                : null,
          );
          _isLoading = false;
        });
      } else {
        _showMessage('Customer not found');
        Get.back();
      }
    } catch (e) {
      debugPrint('Error loading customer: $e');
      _showMessage('Failed to load customer: $e');
      Get.back();
    }
  }

  /// Update customer details and proceed to draft
  Future<void> _updateCustomerDetails() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      _customer.deliveryAddress = deliveryAddress;
      _customer.postalAddress = postalAddress;

      // Navigate to appropriate draft page based on invoice type
      switch (widget.invoiceType) {
        case InvoiceType.invoice:
          Get.put(InvoiceDraftController(
            customer: _customer,
            copyInvoice: invoice,
          ));
          Get.offAll(() => InvoiceDraftPage());
          break;
        case InvoiceType.quotation:
          Get.put(QuoteDraftController(
            customer: _customer,
            copyInvoice: invoice,
          ));
          Get.offAll(() => QuoteDraftPage());
          break;
        case InvoiceType.creditNote:
          Get.put(CreditDraftController(
            customer: _customer,
            copyInvoice: invoice,
          ));
          Get.offAll(() => const CreditDraftPage());
          break;
        case InvoiceType.supplyInvoice:
        case InvoiceType.returnNote:
          _showMessage('This invoice type is not yet implemented');
          break;
      }
    } else {
      _showMessage('Please fill all required fields');
    }
  }

  /// Show message to user
  void _showMessage(String message, {bool isSuccess = false}) {
    Get.snackbar(
      isSuccess ? 'Success' : 'Info',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isSuccess
          ? AppTheme.successColor.withOpacity(0.9)
          : AppTheme.errorColor.withOpacity(0.9),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(AppTheme.spacingMd),
      borderRadius: AppTheme.radiusMd,
    );
  }
}
