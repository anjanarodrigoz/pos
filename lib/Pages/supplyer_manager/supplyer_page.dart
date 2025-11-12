import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/Pages/supplyer_manager/supplyer_form.dart';
import 'package:pos/Pages/supplyer_manager/supplyer_view.dart';
import 'package:pos/Pages/main_window.dart';
import 'package:pos/database/pos_database.dart';
import 'package:pos/repositories/supplier_repository.dart';
import 'package:pos/theme/app_theme.dart';

/// Modern supplier management page with professional table view
class SupplyerPage extends StatefulWidget {
  const SupplyerPage({Key? key}) : super(key: key);

  @override
  State<SupplyerPage> createState() => _SupplyerPageState();
}

class _SupplyerPageState extends State<SupplyerPage> {
  final SupplierRepository _repository = Get.find<SupplierRepository>();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _showInactiveSuppliers = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToMainMenu() {
    Get.offAll(() => const MainWindow());
  }

  void _navigateToAddSupplier() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SupplyerFormPage()),
    );

    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Supplier created successfully',
            style: AppTheme.bodyMedium.copyWith(color: Colors.white),
          ),
          backgroundColor: AppTheme.successColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          ),
        ),
      );
    }
  }

  void _navigateToViewSupplier(Supplier supplier) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SupplyerViewPage(supplierId: supplier.id),
      ),
    );

    if (result == 'deleted' && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Supplier deleted successfully',
            style: AppTheme.bodyMedium.copyWith(color: Colors.white),
          ),
          backgroundColor: AppTheme.successColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      appBar: AppBar(
        title: Text(
          'Supplier Management',
          style: AppTheme.headlineMedium.copyWith(color: AppTheme.textPrimary),
        ),
        backgroundColor: AppTheme.cardBackground,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: _navigateToMainMenu,
          tooltip: 'Back to Main Menu',
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingMd,
              vertical: 8,
            ),
            child: ElevatedButton.icon(
              onPressed: _navigateToAddSupplier,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('New Supplier'),
              style: AppTheme.primaryButtonStyle(),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: AppTheme.borderColor,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar and Filters
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            color: AppTheme.cardBackground,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.backgroundGrey,
                          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                          border: Border.all(color: AppTheme.borderColor),
                        ),
                        child: TextField(
                          controller: _searchController,
                          style: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.textPrimary,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search suppliers by name, email, or mobile...',
                            hintStyle: AppTheme.bodyMedium.copyWith(
                              color: AppTheme.textHint,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: AppTheme.textSecondary,
                              size: 20,
                            ),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: Icon(
                                      Icons.clear,
                                      color: AppTheme.textSecondary,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _searchController.clear();
                                        _searchQuery = '';
                                      });
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spacingMd,
                              vertical: AppTheme.spacingSm,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingMd),
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.cardBackground,
                        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                        border: Border.all(color: AppTheme.borderColor),
                      ),
                      child: Row(
                        children: [
                          Checkbox(
                            value: _showInactiveSuppliers,
                            onChanged: (value) {
                              setState(() {
                                _showInactiveSuppliers = value ?? false;
                              });
                            },
                          ),
                          Text(
                            'Show Inactive',
                            style: AppTheme.bodySmall.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacingSm),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Supplier List
          Expanded(
            child: StreamBuilder<List<Supplier>>(
              stream: _repository.watchAllSuppliers(activeOnly: !_showInactiveSuppliers),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: AppTheme.errorColor,
                        ),
                        SizedBox(height: AppTheme.spacingMd),
                        Text(
                          'Error loading suppliers',
                          style: AppTheme.headlineSmall.copyWith(
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                var suppliers = snapshot.data ?? [];

                // Apply search filter
                if (_searchQuery.isNotEmpty) {
                  final query = _searchQuery.toLowerCase();
                  suppliers = suppliers.where((s) {
                    return s.firstName.toLowerCase().contains(query) ||
                        s.lastName.toLowerCase().contains(query) ||
                        (s.email?.toLowerCase().contains(query) ?? false) ||
                        (s.mobileNumber?.toLowerCase().contains(query) ?? false);
                  }).toList();
                }

                if (suppliers.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _searchQuery.isEmpty
                              ? Icons.local_shipping_outlined
                              : Icons.search_off,
                          size: 64,
                          color: AppTheme.textHint,
                        ),
                        SizedBox(height: AppTheme.spacingMd),
                        Text(
                          _searchQuery.isEmpty
                              ? 'No suppliers yet'
                              : 'No suppliers found',
                          style: AppTheme.headlineSmall.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        SizedBox(height: AppTheme.spacingSm),
                        Text(
                          _searchQuery.isEmpty
                              ? 'Click "New Supplier" to add your first supplier'
                              : 'Try a different search term',
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.textHint,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Container(
                  margin: const EdgeInsets.all(AppTheme.spacingLg),
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
                  child: Column(
                    children: [
                      // Table Header
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingMd,
                          vertical: AppTheme.spacingSm,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.backgroundGrey,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(AppTheme.radiusLg),
                            topRight: Radius.circular(AppTheme.radiusLg),
                          ),
                          border: Border(
                            bottom: BorderSide(color: AppTheme.borderColor),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Name',
                                style: AppTheme.labelLarge.copyWith(
                                  color: AppTheme.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Supplier ID',
                                style: AppTheme.labelLarge.copyWith(
                                  color: AppTheme.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Email',
                                style: AppTheme.labelLarge.copyWith(
                                  color: AppTheme.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                'Mobile',
                                style: AppTheme.labelLarge.copyWith(
                                  color: AppTheme.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'City',
                                style: AppTheme.labelLarge.copyWith(
                                  color: AppTheme.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(width: 60),
                          ],
                        ),
                      ),

                      // Table Body
                      Expanded(
                        child: ListView.builder(
                          itemCount: suppliers.length,
                          itemBuilder: (context, index) {
                            final supplier = suppliers[index];
                            final isLast = index == suppliers.length - 1;

                            return InkWell(
                              onTap: () => _navigateToViewSupplier(supplier),
                              hoverColor: AppTheme.backgroundGrey.withOpacity(0.5),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppTheme.spacingMd,
                                  vertical: AppTheme.spacingMd,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: isLast
                                        ? BorderSide.none
                                        : BorderSide(
                                            color: AppTheme.borderColor.withOpacity(0.5),
                                          ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    // Name with Avatar
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 16,
                                            backgroundColor: AppTheme.primaryLight,
                                            child: Text(
                                              '${supplier.firstName[0]}${supplier.lastName[0]}'
                                                  .toUpperCase(),
                                              style: AppTheme.labelSmall.copyWith(
                                                color: AppTheme.primaryDark,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: AppTheme.spacingSm),
                                          Expanded(
                                            child: Text(
                                              '${supplier.firstName} ${supplier.lastName}',
                                              style: AppTheme.bodyMedium.copyWith(
                                                color: supplier.isActive
                                                    ? AppTheme.textPrimary
                                                    : AppTheme.textHint,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Supplier ID
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        supplier.id,
                                        style: AppTheme.bodySmall.copyWith(
                                          color: AppTheme.textSecondary,
                                          fontFamily: 'monospace',
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),

                                    // Email
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        supplier.email ?? '—',
                                        style: AppTheme.bodySmall.copyWith(
                                          color: supplier.email != null
                                              ? AppTheme.textSecondary
                                              : AppTheme.textHint,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),

                                    // Mobile
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        supplier.mobileNumber ?? '—',
                                        style: AppTheme.bodySmall.copyWith(
                                          color: supplier.mobileNumber != null
                                              ? AppTheme.textSecondary
                                              : AppTheme.textHint,
                                        ),
                                      ),
                                    ),

                                    // City
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        supplier.city ?? '—',
                                        style: AppTheme.bodySmall.copyWith(
                                          color: supplier.city != null
                                              ? AppTheme.textSecondary
                                              : AppTheme.textHint,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),

                                    // Status Icon
                                    SizedBox(
                                      width: 60,
                                      child: Icon(
                                        Icons.chevron_right,
                                        color: AppTheme.textHint,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
