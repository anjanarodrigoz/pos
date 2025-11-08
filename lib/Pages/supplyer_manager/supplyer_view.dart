import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/database/pos_database.dart';
import 'package:pos/repositories/supplier_repository.dart';
import 'package:pos/theme/app_theme.dart';
import 'package:pos/utils/alert_message.dart';

/// Modern supplier view/edit page with shadcn-style design
class SupplyerViewPage extends StatefulWidget {
  final String supplierId;

  const SupplyerViewPage({Key? key, required this.supplierId})
      : super(key: key);

  @override
  State<SupplyerViewPage> createState() => _SupplyerViewPageState();
}

class _SupplyerViewPageState extends State<SupplyerViewPage> {
  final _formKey = GlobalKey<FormState>();
  final SupplierRepository _repository = Get.find<SupplierRepository>();

  // Edit controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _commentController = TextEditingController();
  final _faxController = TextEditingController();
  final _webController = TextEditingController();
  final _abnController = TextEditingController();
  final _acnController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _areaCodeController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _countryController = TextEditingController();

  bool _isEditMode = false;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadSupplier();
  }

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

  Future<void> _loadSupplier() async {
    final result = await _repository.getSupplier(widget.supplierId);

    if (result.isSuccess && mounted) {
      final supplier = result.data!;
      _populateControllers(supplier);
      setState(() => _isLoading = false);
    } else if (mounted) {
      setState(() => _isLoading = false);
      AlertMessage.snakMessage(
        'Failed to load supplier',
        context,
      );
      Navigator.of(context).pop();
    }
  }

  void _populateControllers(Supplier supplier) {
    _firstNameController.text = supplier.firstName;
    _lastNameController.text = supplier.lastName;
    _mobileController.text = supplier.mobileNumber ?? '';
    _emailController.text = supplier.email ?? '';
    _commentController.text = supplier.comment ?? '';
    _faxController.text = supplier.fax ?? '';
    _webController.text = supplier.web ?? '';
    _abnController.text = supplier.abn ?? '';
    _acnController.text = supplier.acn ?? '';
    _streetController.text = supplier.street ?? '';
    _cityController.text = supplier.city ?? '';
    _stateController.text = supplier.state ?? '';
    _areaCodeController.text = supplier.areaCode ?? '';
    _postalCodeController.text = supplier.postalCode ?? '';
    _countryController.text = supplier.country ?? '';
  }

  Future<void> _saveChanges(Supplier originalSupplier) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      // Create updated supplier
      final updatedSupplier = Supplier(
        id: originalSupplier.id,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        mobileNumber: _mobileController.text.trim().isEmpty
            ? null
            : _mobileController.text.trim(),
        email: _emailController.text.trim().isEmpty
            ? null
            : _emailController.text.trim(),
        comment: _commentController.text.trim().isEmpty
            ? null
            : _commentController.text.trim(),
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
        isActive: originalSupplier.isActive,
        createdAt: originalSupplier.createdAt,
        updatedAt: DateTime.now(),
      );

      final result = await _repository.updateSupplier(updatedSupplier);

      if (result.isSuccess && mounted) {
        setState(() {
          _isEditMode = false;
          _isSaving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Supplier updated successfully',
              style: AppTheme.bodyMedium.copyWith(color: Colors.white),
            ),
            backgroundColor: AppTheme.successColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            ),
          ),
        );
      } else if (mounted) {
        setState(() => _isSaving = false);
        AlertMessage.snakMessage(
          result.error?.message ?? 'Failed to update supplier',
          context,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        AlertMessage.snakMessage('An error occurred', context);
      }
    }
  }

  Future<void> _deleteSupplier() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Supplier',
          style: AppTheme.headlineSmall.copyWith(color: AppTheme.textPrimary),
        ),
        content: Text(
          'Are you sure you want to delete this supplier? This action cannot be undone.',
          style: AppTheme.bodyMedium.copyWith(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final result = await _repository.deleteSupplier(widget.supplierId);

      if (result.isSuccess && mounted) {
        Navigator.of(context).pop('deleted');
      } else if (mounted) {
        AlertMessage.snakMessage(
          result.error?.message ?? 'Failed to delete supplier',
          context,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      appBar: AppBar(
        title: StreamBuilder<Supplier>(
          stream: _repository.watchSupplier(widget.supplierId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final supplier = snapshot.data!;
              return Text(
                '${supplier.firstName} ${supplier.lastName}',
                style: AppTheme.headlineMedium.copyWith(
                  color: AppTheme.textPrimary,
                ),
              );
            }
            return Text(
              'Supplier Details',
              style: AppTheme.headlineMedium.copyWith(
                color: AppTheme.textPrimary,
              ),
            );
          },
        ),
        backgroundColor: AppTheme.cardBackground,
        elevation: 0,
        iconTheme: IconThemeData(color: AppTheme.textPrimary),
        actions: [
          if (!_isEditMode)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => setState(() => _isEditMode = true),
              tooltip: 'Edit',
            ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _deleteSupplier,
            tooltip: 'Delete',
          ),
          const SizedBox(width: AppTheme.spacingSm),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppTheme.borderColor),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<Supplier>(
              stream: _repository.watchSupplier(widget.supplierId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final supplier = snapshot.data!;
                if (!_isEditMode) {
                  _populateControllers(supplier);
                }

                return Form(
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
                              _buildDetailsCard(supplier),
                              const SizedBox(height: AppTheme.spacingLg),

                              // Business Details Section
                              _buildBusinessCard(supplier),
                              const SizedBox(height: AppTheme.spacingLg),

                              // Address Section
                              _buildAddressCard(supplier),
                            ],
                          ),
                        ),
                      ),

                      // Action Buttons (only in edit mode)
                      if (_isEditMode)
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
                                    : () {
                                        setState(() {
                                          _isEditMode = false;
                                          _populateControllers(supplier);
                                        });
                                      },
                                style: AppTheme.outlinedButtonStyle(),
                                child: const Text('Cancel'),
                              ),
                              const SizedBox(width: AppTheme.spacingMd),
                              ElevatedButton(
                                onPressed: _isSaving
                                    ? null
                                    : () => _saveChanges(supplier),
                                style: AppTheme.primaryButtonStyle(),
                                child: _isSaving
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Colors.white,
                                          ),
                                        ),
                                      )
                                    : const Text('Save Changes'),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildDetailsCard(Supplier supplier) {
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
              Icon(Icons.local_shipping_outlined, color: AppTheme.primaryColor),
              const SizedBox(width: AppTheme.spacingSm),
              Text(
                'Supplier Details',
                style: AppTheme.headlineSmall.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingLg),
          Divider(color: AppTheme.dividerColor),
          const SizedBox(height: AppTheme.spacingLg),

          if (_isEditMode) ...[
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
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Required';
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
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Required';
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
                      labelText: 'Mobile Number',
                    ),
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
                    ),
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
              ),
              maxLines: 3,
            ),
          ] else ...[
            _buildDetailRow('Supplier ID', supplier.id),
            _buildDetailRow(
              'Name',
              '${supplier.firstName} ${supplier.lastName}',
            ),
            _buildDetailRow('Mobile', supplier.mobileNumber),
            _buildDetailRow('Email', supplier.email),
            if (supplier.comment != null && supplier.comment!.isNotEmpty)
              _buildDetailRow('Comments', supplier.comment),
          ],
        ],
      ),
    );
  }

  Widget _buildBusinessCard(Supplier supplier) {
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
              Icon(Icons.business_outlined, color: AppTheme.primaryColor),
              const SizedBox(width: AppTheme.spacingSm),
              Text(
                'Business Details',
                style: AppTheme.headlineSmall.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingLg),
          Divider(color: AppTheme.dividerColor),
          const SizedBox(height: AppTheme.spacingLg),

          if (_isEditMode) ...[
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
                    controller: _abnController,
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textPrimary,
                    ),
                    decoration: AppTheme.inputDecoration(
                      labelText: 'ABN',
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
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            _buildDetailRow('Fax', supplier.fax),
            _buildDetailRow('Website', supplier.web),
            _buildDetailRow('ABN', supplier.abn),
            _buildDetailRow('ACN', supplier.acn),
          ],
        ],
      ),
    );
  }

  Widget _buildAddressCard(Supplier supplier) {
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
              Icon(Icons.location_on_outlined, color: AppTheme.primaryColor),
              const SizedBox(width: AppTheme.spacingSm),
              Text(
                'Address',
                style: AppTheme.headlineSmall.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingLg),
          Divider(color: AppTheme.dividerColor),
          const SizedBox(height: AppTheme.spacingLg),

          if (_isEditMode) ...[
            TextFormField(
              controller: _streetController,
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textPrimary,
              ),
              decoration: AppTheme.inputDecoration(
                labelText: 'Street',
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
          ] else ...[
            _buildDetailRow('Street', supplier.street),
            _buildDetailRow('City', supplier.city),
            _buildDetailRow('State', supplier.state),
            _buildDetailRow('Area Code', supplier.areaCode),
            _buildDetailRow('Postal Code', supplier.postalCode),
            _buildDetailRow('Country', supplier.country),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: AppTheme.labelMedium.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? '—',
              style: AppTheme.bodyMedium.copyWith(
                color: value != null ? AppTheme.textPrimary : AppTheme.textHint,
                fontFamily: label == 'Supplier ID' ? 'monospace' : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
