import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/repositories/customer_repository.dart';
import 'package:pos/theme/app_theme.dart';
import 'package:pos/utils/result.dart';

/// Beautiful customer creation/edit form with all fields
class CustomerFormPage extends StatefulWidget {
  final String? customerId; // If provided, edit mode; else create mode

  const CustomerFormPage({Key? key, this.customerId}) : super(key: key);

  @override
  State<CustomerFormPage> createState() => _CustomerFormPageState();
}

class _CustomerFormPageState extends State<CustomerFormPage> {
  final CustomerRepository _repository = Get.find<CustomerRepository>();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Customer Details
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _faxController = TextEditingController();
  final _webController = TextEditingController();
  final _abnController = TextEditingController();
  final _acnController = TextEditingController();
  final _commentController = TextEditingController();

  // Billing Address
  final _billingStreetController = TextEditingController();
  final _billingCityController = TextEditingController();
  final _billingStateController = TextEditingController();
  final _billingAreaCodeController = TextEditingController();
  final _billingPostalCodeController = TextEditingController();
  final _billingCountryController = TextEditingController();

  // Postal Address
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

  void _copyBillingToPostal() {
    setState(() {
      _postalStreetController.text = _billingStreetController.text;
      _postalCityController.text = _billingCityController.text;
      _postalStateController.text = _billingStateController.text;
      _postalAreaCodeController.text = _billingAreaCodeController.text;
      _postalPostalCodeController.text = _billingPostalCodeController.text;
      _postalCountryController.text = _billingCountryController.text;
    });
  }

  Future<void> _saveCustomer() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = await _repository.createCustomer(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      mobileNumber: _mobileController.text.trim(),
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
      // Billing address
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
      // Postal address
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
    );

    setState(() {
      _isLoading = false;
    });

    if (result.isSuccess) {
      if (mounted) {
        Navigator.pop(context, true); // Return true to indicate success
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.error?.message ?? 'Failed to save customer'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.customerId == null ? 'New Customer' : 'Edit Customer'),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          children: [
            // Customer Details Section
            _buildSectionCard(
              title: 'Customer Details',
              icon: Icons.person_outline,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _firstNameController,
                        decoration: AppTheme.inputDecoration(
                          labelText: 'First Name *',
                          prefixIcon: const Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'First name is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: AppTheme.spacingMd),
                    Expanded(
                      child: TextFormField(
                        controller: _lastNameController,
                        decoration: AppTheme.inputDecoration(
                          labelText: 'Last Name *',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Last name is required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppTheme.spacingMd),
                TextFormField(
                  controller: _mobileController,
                  decoration: AppTheme.inputDecoration(
                    labelText: 'Mobile Number *',
                    prefixIcon: const Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Mobile number is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppTheme.spacingMd),
                TextFormField(
                  controller: _emailController,
                  decoration: AppTheme.inputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value != null &&
                        value.isNotEmpty &&
                        !value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppTheme.spacingMd),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _faxController,
                        decoration: AppTheme.inputDecoration(
                          labelText: 'Fax',
                          prefixIcon: const Icon(Icons.fax),
                        ),
                      ),
                    ),
                    SizedBox(width: AppTheme.spacingMd),
                    Expanded(
                      child: TextFormField(
                        controller: _webController,
                        decoration: AppTheme.inputDecoration(
                          labelText: 'Website',
                          prefixIcon: const Icon(Icons.language),
                        ),
                        keyboardType: TextInputType.url,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppTheme.spacingMd),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _abnController,
                        decoration: AppTheme.inputDecoration(
                          labelText: 'ABN',
                          prefixIcon: const Icon(Icons.business),
                        ),
                      ),
                    ),
                    SizedBox(width: AppTheme.spacingMd),
                    Expanded(
                      child: TextFormField(
                        controller: _acnController,
                        decoration: AppTheme.inputDecoration(
                          labelText: 'ACN',
                          prefixIcon: const Icon(Icons.business_center),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppTheme.spacingMd),
                TextFormField(
                  controller: _commentController,
                  decoration: AppTheme.inputDecoration(
                    labelText: 'Comments',
                    prefixIcon: const Icon(Icons.notes),
                  ),
                  maxLines: 3,
                ),
              ],
            ),

            SizedBox(height: AppTheme.spacingLg),

            // Billing Address Section
            _buildSectionCard(
              title: 'Billing/Delivery Address',
              icon: Icons.home_outlined,
              children: [
                TextFormField(
                  controller: _billingStreetController,
                  decoration: AppTheme.inputDecoration(
                    labelText: 'Street',
                  ),
                ),
                SizedBox(height: AppTheme.spacingMd),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _billingCityController,
                        decoration: AppTheme.inputDecoration(
                          labelText: 'City',
                        ),
                      ),
                    ),
                    SizedBox(width: AppTheme.spacingMd),
                    Expanded(
                      child: TextFormField(
                        controller: _billingStateController,
                        decoration: AppTheme.inputDecoration(
                          labelText: 'State',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppTheme.spacingMd),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _billingAreaCodeController,
                        decoration: AppTheme.inputDecoration(
                          labelText: 'Area Code',
                        ),
                      ),
                    ),
                    SizedBox(width: AppTheme.spacingMd),
                    Expanded(
                      child: TextFormField(
                        controller: _billingPostalCodeController,
                        decoration: AppTheme.inputDecoration(
                          labelText: 'Postal Code',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppTheme.spacingMd),
                TextFormField(
                  controller: _billingCountryController,
                  decoration: AppTheme.inputDecoration(
                    labelText: 'Country',
                  ),
                ),
              ],
            ),

            SizedBox(height: AppTheme.spacingLg),

            // Postal Address Section
            _buildSectionCard(
              title: 'Postal Address',
              icon: Icons.mail_outline,
              trailing: TextButton.icon(
                onPressed: _copyBillingToPostal,
                icon: const Icon(Icons.copy_all, size: 18),
                label: const Text('Copy from Billing'),
                style: AppTheme.textButtonStyle(),
              ),
              children: [
                TextFormField(
                  controller: _postalStreetController,
                  decoration: AppTheme.inputDecoration(
                    labelText: 'Street',
                  ),
                ),
                SizedBox(height: AppTheme.spacingMd),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _postalCityController,
                        decoration: AppTheme.inputDecoration(
                          labelText: 'City',
                        ),
                      ),
                    ),
                    SizedBox(width: AppTheme.spacingMd),
                    Expanded(
                      child: TextFormField(
                        controller: _postalStateController,
                        decoration: AppTheme.inputDecoration(
                          labelText: 'State',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppTheme.spacingMd),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _postalAreaCodeController,
                        decoration: AppTheme.inputDecoration(
                          labelText: 'Area Code',
                        ),
                      ),
                    ),
                    SizedBox(width: AppTheme.spacingMd),
                    Expanded(
                      child: TextFormField(
                        controller: _postalPostalCodeController,
                        decoration: AppTheme.inputDecoration(
                          labelText: 'Postal Code',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppTheme.spacingMd),
                TextFormField(
                  controller: _postalCountryController,
                  decoration: AppTheme.inputDecoration(
                    labelText: 'Country',
                  ),
                ),
              ],
            ),

            SizedBox(height: AppTheme.spacingXl),

            // Save Button
            SizedBox(
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _saveCustomer,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.save),
                label: Text(_isLoading ? 'Saving...' : 'Save Customer'),
                style: AppTheme.successButtonStyle(),
              ),
            ),

            SizedBox(height: AppTheme.spacingMd),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
    Widget? trailing,
  }) {
    return Container(
      decoration: AppTheme.cardDecoration,
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.primaryColor, size: 24),
              SizedBox(width: AppTheme.spacingSm),
              Expanded(
                child: Text(
                  title,
                  style: AppTheme.headlineSmall,
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
          SizedBox(height: AppTheme.spacingMd),
          const Divider(),
          SizedBox(height: AppTheme.spacingMd),
          ...children,
        ],
      ),
    );
  }
}
