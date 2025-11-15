import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/database/pos_database.dart';
import 'package:pos/repositories/customer_repository.dart';
import 'package:pos/pages/customer_form.dart';
import 'package:pos/pages/customer_view.dart';
import 'package:pos/Pages/main_window.dart';
import 'package:pos/theme/app_theme.dart';
import 'package:pos/utils/result.dart';

/// Modern customer list page with professional table view
class CustomerPage extends StatefulWidget {
  const CustomerPage({Key? key}) : super(key: key);

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  final CustomerRepository _repository = Get.find<CustomerRepository>();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToMainMenu() {
    Get.offAll(() => const MainWindow());
  }

  void _navigateToAddCustomer() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CustomerFormPage()),
    );

    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Customer created successfully',
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

  void _navigateToViewCustomer(Customer customer) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomerViewPage(customerId: customer.id),
      ),
    );

    if (result == 'deleted' && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Customer deleted successfully',
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
          'Customer Management',
          style: AppTheme.headlineMedium.copyWith(color: AppTheme.textPrimary),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
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
              onPressed: _navigateToAddCustomer,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('New Customer'),
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
          // Search Bar
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            color: Colors.white,
            child: Row(
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
                        hintText: 'Search customers by name, email, or mobile...',
                        hintStyle: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.textHint,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: AppTheme.textSecondary,
                          size: 20,
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(
                                  Icons.clear,
                                  color: AppTheme.textSecondary,
                                  size: 20,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingMd,
                          vertical: AppTheme.spacingMd,
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
              ],
            ),
          ),

          // Customer Table
          Expanded(
            child: StreamBuilder<List<Customer>>(
              stream: _repository.watchAllCustomers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.primaryColor,
                      ),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
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
                          'Failed to load customers',
                          style: AppTheme.headlineSmall.copyWith(
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingSm),
                        Text(
                          snapshot.error.toString(),
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                var customers = snapshot.data ?? [];

                // Apply search filter
                if (_searchQuery.isNotEmpty) {
                  final query = _searchQuery.toLowerCase();
                  customers = customers.where((c) {
                    return c.firstName.toLowerCase().contains(query) ||
                        c.lastName.toLowerCase().contains(query) ||
                        (c.email?.toLowerCase().contains(query) ?? false) ||
                        (c.mobileNumber?.toLowerCase().contains(query) ?? false);
                  }).toList();
                }

                if (customers.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _searchQuery.isEmpty
                              ? Icons.person_add_outlined
                              : Icons.search_off,
                          size: 64,
                          color: AppTheme.textHint,
                        ),
                        const SizedBox(height: AppTheme.spacingMd),
                        Text(
                          _searchQuery.isEmpty
                              ? 'No customers yet'
                              : 'No customers found',
                          style: AppTheme.headlineSmall.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingSm),
                        Text(
                          _searchQuery.isEmpty
                              ? 'Click "New Customer" to add your first customer'
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
                    color: Colors.white,
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
                        decoration: const BoxDecoration(
                          color: AppTheme.backgroundGrey,
                          borderRadius: BorderRadius.only(
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
                                'Customer ID',
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
                            const SizedBox(width: 60),
                          ],
                        ),
                      ),

                      // Table Body
                      Expanded(
                        child: ListView.builder(
                          itemCount: customers.length,
                          itemBuilder: (context, index) {
                            final customer = customers[index];
                            final isLast = index == customers.length - 1;

                            return InkWell(
                              onTap: () => _navigateToViewCustomer(customer),
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
                                              '${customer.firstName[0]}${customer.lastName[0]}'
                                                  .toUpperCase(),
                                              style: AppTheme.labelSmall.copyWith(
                                                color: AppTheme.primaryDark,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: AppTheme.spacingSm),
                                          Expanded(
                                            child: Text(
                                              '${customer.firstName} ${customer.lastName}',
                                              style: AppTheme.bodyMedium.copyWith(
                                                color: AppTheme.textPrimary,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Customer ID
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        customer.id,
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
                                        customer.email ?? '—',
                                        style: AppTheme.bodySmall.copyWith(
                                          color: customer.email != null
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
                                        customer.mobileNumber ?? '—',
                                        style: AppTheme.bodySmall.copyWith(
                                          color: customer.mobileNumber != null
                                              ? AppTheme.textSecondary
                                              : AppTheme.textHint,
                                        ),
                                      ),
                                    ),

                                    // City
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        customer.billingCity ?? '—',
                                        style: AppTheme.bodySmall.copyWith(
                                          color: customer.billingCity != null
                                              ? AppTheme.textSecondary
                                              : AppTheme.textHint,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),

                                    // Actions
                                    SizedBox(
                                      width: 60,
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.arrow_forward_ios,
                                          size: 16,
                                          color: AppTheme.textSecondary,
                                        ),
                                        onPressed: () =>
                                            _navigateToViewCustomer(customer),
                                        tooltip: 'View Details',
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
