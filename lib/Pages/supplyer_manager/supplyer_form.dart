import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/database/pos_database.dart';
import 'package:pos/repositories/supplier_repository.dart';
import 'package:pos/theme/app_theme.dart';
import 'package:pos/utils/alert_message.dart';
import 'package:pos/utils/id_generator.dart';

/// Modern supplier creation form with shadcn-style design
class SupplyerFormPage extends StatefulWidget {
  const SupplyerFormPage({Key? key}) : super(key: key);

  @override
  State<SupplyerFormPage> createState() => _SupplyerFormPageState();
}

class _SupplyerFormPageState extends State<SupplyerFormPage> {
  final _formKey = GlobalKey<FormState>();
  final SupplierRepository _repository = Get.find<SupplierRepository>();

  // Basic Details Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _commentController = TextEditingController();

  // Business Details Controllers
  final _faxController = TextEditingController();
  final _webController = TextEditingController();
  final _abnController = TextEditingController();
  final _acnController = TextEditingController();

  // Address Controllers
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _areaCodeController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _countryController = TextEditingController();

  bool _isSaving = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _commentController.dispose();
    _faxController.dispose();
    _webController.dispose();
    _abnController.dispose();
    _acnController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _areaCodeController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  Future<void> _saveSupplier() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      final result = await _repository.createSupplier(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        mobileNumber: _mobileController.text.trim(),
        email: _emailController.text.trim().isEmpty
            ? null
            : _emailController.text.trim(),
        fax: _faxController.text.trim().isEmpty
            ? null
            : _faxController.text.trim(),
        web: _webController.text.trim().isEmpty
            ? null
            : _webController.text.trim(),
        abn: _abnController.text.trim().isEmpty
            ? null
            : _abnController.text.trim(),
        acn: _acnController.text.trim().isEmpty
            ? null
            : _acnController.text.trim(),
        comment: _commentController.text.trim().isEmpty
            ? null
            : _commentController.text.trim(),
        street: _streetController.text.trim().isEmpty
            ? null
            : _streetController.text.trim(),
        city: _cityController.text.trim().isEmpty
            ? null
            : _cityController.text.trim(),
        state: _stateController.text.trim().isEmpty
            ? null
            : _stateController.text.trim(),
        areaCode: _areaCodeController.text.trim().isEmpty
            ? null
            : _areaCodeController.text.trim(),
        postalCode: _postalCodeController.text.trim().isEmpty
            ? null
            : _postalCodeController.text.trim(),
        country: _countryController.text.trim().isEmpty
            ? null
            : _countryController.text.trim(),
      );

      if (result.isSuccess) {
        Navigator.of(context).pop(true); // Return true to indicate success
      } else {
        if (mounted) {
          AlertMessage.snakMessage(
            result.error?.message ?? 'Failed to create supplier',
            context,
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      appBar: AppBar(
        title: Text(
          'New Supplier',
          style: AppTheme.headlineMedium.copyWith(color: AppTheme.textPrimary),
        ),
        backgroundColor: AppTheme.cardBackground,
        elevation: 0,
        iconTheme: IconThemeData(color: AppTheme.textPrimary),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppTheme.borderColor),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppTheme.spacingLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Supplier Details Section
                    _buildSection(
                      title: 'Supplier Details',
                      icon: Icons.local_shipping_outlined,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _firstNameController,
                                style: AppTheme.bodyMedium.copyWith(
                                  color: AppTheme.textPrimary,
                                ),
                                decoration: AppTheme.inputDecoration(
                                  labelText: 'First Name *',
                                  prefixIcon: const Icon(Icons.person_outline),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'First name is required';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: AppTheme.spacingMd),
                            Expanded(
                              child: TextFormField(
                                controller: _lastNameController,
                                style: AppTheme.bodyMedium.copyWith(
                                  color: AppTheme.textPrimary,
                                ),
                                decoration: AppTheme.inputDecoration(
                                  labelText: 'Last Name *',
                                  prefixIcon: const Icon(Icons.person_outline),
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
                        const SizedBox(height: AppTheme.spacingMd),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _mobileController,
                                style: AppTheme.bodyMedium.copyWith(
                                  color: AppTheme.textPrimary,
                                ),
                                decoration: AppTheme.inputDecoration(
                                  labelText: 'Mobile Number *',
                                  prefixIcon: const Icon(Icons.phone_outlined),
                                ),
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Mobile number is required';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: AppTheme.spacingMd),
                            Expanded(
                              child: TextFormField(
                                controller: _emailController,
                                style: AppTheme.bodyMedium.copyWith(
                                  color: AppTheme.textPrimary,
                                ),
                                decoration: AppTheme.inputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: const Icon(Icons.email_outlined),
                                ),
                                keyboardType: TextInputType.emailAddress,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppTheme.spacingMd),
                        TextFormField(
                          controller: _commentController,
                          style: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.textPrimary,
                          ),
                          decoration: AppTheme.inputDecoration(
                            labelText: 'Comments',
                            prefixIcon: const Icon(Icons.notes_outlined),
                          ),
                          maxLines: 3,
                        ),
                      ],
                    ),

                    const SizedBox(height: AppTheme.spacingLg),

                    // Business Details Section
                    _buildSection(
                      title: 'Business Details',
                      icon: Icons.business_outlined,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _faxController,
                                style: AppTheme.bodyMedium.copyWith(
                                  color: AppTheme.textPrimary,
                                ),
                                decoration: AppTheme.inputDecoration(
                                  labelText: 'Fax',
                                  prefixIcon: const Icon(Icons.print_outlined),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppTheme.spacingMd),
                            Expanded(
                              child: TextFormField(
                                controller: _webController,
                                style: AppTheme.bodyMedium.copyWith(
                                  color: AppTheme.textPrimary,
                                ),
                                decoration: AppTheme.inputDecoration(
                                  labelText: 'Website',
                                  prefixIcon: const Icon(Icons.language_outlined),
                                ),
                                keyboardType: TextInputType.url,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppTheme.spacingMd),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _abnController,
                                style: AppTheme.bodyMedium.copyWith(
                                  color: AppTheme.textPrimary,
                                ),
                                decoration: AppTheme.inputDecoration(
                                  labelText: 'ABN',
                                  prefixIcon: const Icon(Icons.badge_outlined),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppTheme.spacingMd),
                            Expanded(
                              child: TextFormField(
                                controller: _acnController,
                                style: AppTheme.bodyMedium.copyWith(
                                  color: AppTheme.textPrimary,
                                ),
                                decoration: AppTheme.inputDecoration(
                                  labelText: 'ACN',
                                  prefixIcon: const Icon(Icons.badge_outlined),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: AppTheme.spacingLg),

                    // Address Section
                    _buildSection(
                      title: 'Address',
                      icon: Icons.location_on_outlined,
                      children: [
                        TextFormField(
                          controller: _streetController,
                          style: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.textPrimary,
                          ),
                          decoration: AppTheme.inputDecoration(
                            labelText: 'Street',
                            prefixIcon: const Icon(Icons.home_outlined),
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingMd),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _cityController,
                                style: AppTheme.bodyMedium.copyWith(
                                  color: AppTheme.textPrimary,
                                ),
                                decoration: AppTheme.inputDecoration(
                                  labelText: 'City',
                                ),
                              ),
                            ),
                            const SizedBox(width: AppTheme.spacingMd),
                            Expanded(
                              child: TextFormField(
                                controller: _stateController,
                                style: AppTheme.bodyMedium.copyWith(
                                  color: AppTheme.textPrimary,
                                ),
                                decoration: AppTheme.inputDecoration(
                                  labelText: 'State',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppTheme.spacingMd),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _areaCodeController,
                                style: AppTheme.bodyMedium.copyWith(
                                  color: AppTheme.textPrimary,
                                ),
                                decoration: AppTheme.inputDecoration(
                                  labelText: 'Area Code',
                                ),
                              ),
                            ),
                            const SizedBox(width: AppTheme.spacingMd),
                            Expanded(
                              child: TextFormField(
                                controller: _postalCodeController,
                                style: AppTheme.bodyMedium.copyWith(
                                  color: AppTheme.textPrimary,
                                ),
                                decoration: AppTheme.inputDecoration(
                                  labelText: 'Postal Code',
                                ),
                              ),
                            ),
                            const SizedBox(width: AppTheme.spacingMd),
                            Expanded(
                              child: TextFormField(
                                controller: _countryController,
                                style: AppTheme.bodyMedium.copyWith(
                                  color: AppTheme.textPrimary,
                                ),
                                decoration: AppTheme.inputDecoration(
                                  labelText: 'Country',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Action Buttons
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              decoration: BoxDecoration(
                color: AppTheme.cardBackground,
                border: Border(
                  top: BorderSide(color: AppTheme.borderColor),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: _isSaving
                        ? null
                        : () => Navigator.of(context).pop(),
                    style: AppTheme.outlinedButtonStyle(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: AppTheme.spacingMd),
                  ElevatedButton(
                    onPressed: _isSaving ? null : _saveSupplier,
                    style: AppTheme.primaryButtonStyle(),
                    child: _isSaving
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text('Save Supplier'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
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
              Icon(icon, color: AppTheme.primaryColor),
              const SizedBox(width: AppTheme.spacingSm),
              Text(
                title,
                style: AppTheme.headlineSmall.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingLg),
          ...children,
        ],
      ),
    );
  }
}
