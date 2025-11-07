import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/database/pos_database.dart';
import 'package:pos/repositories/customer_repository.dart';
import 'package:pos/pages/customer_form.dart';
import 'package:pos/pages/customer_view.dart';
import 'package:pos/theme/app_theme.dart';
import 'package:pos/utils/result.dart';

/// Modern customer list page with search and reactive updates
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

  void _navigateToAddCustomer() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CustomerFormPage()),
    );

    if (result == true) {
      // Customer was created, list will auto-update via stream
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Customer created successfully'),
            backgroundColor: AppTheme.successColor,
          ),
        );
      }
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
          content: const Text('Customer deleted successfully'),
          backgroundColor: AppTheme.successColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            color: AppTheme.surfaceColor,
            child: TextField(
              controller: _searchController,
              decoration: AppTheme.inputDecoration(
                labelText: 'Search customers',
                hintText: 'Search by name, email, or mobile number',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Customer List
          Expanded(
            child: StreamBuilder<List<Customer>>(
              stream: _repository.watchAllCustomers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48,
                          color: AppTheme.errorColor,
                        ),
                        SizedBox(height: AppTheme.spacingMd),
                        Text(
                          'Failed to load customers',
                          style: AppTheme.bodyLarge,
                        ),
                        SizedBox(height: AppTheme.spacingSm),
                        Text(
                          snapshot.error.toString(),
                          style: AppTheme.bodySmall,
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
                        SizedBox(height: AppTheme.spacingMd),
                        Text(
                          _searchQuery.isEmpty
                              ? 'No customers yet'
                              : 'No customers found',
                          style: AppTheme.headlineSmall,
                        ),
                        SizedBox(height: AppTheme.spacingSm),
                        Text(
                          _searchQuery.isEmpty
                              ? 'Tap + to add your first customer'
                              : 'Try a different search term',
                          style: AppTheme.bodySmall,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(AppTheme.spacingMd),
                  itemCount: customers.length,
                  itemBuilder: (context, index) {
                    final customer = customers[index];
                    return _CustomerCard(
                      customer: customer,
                      onTap: () => _navigateToViewCustomer(customer),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAddCustomer,
        icon: const Icon(Icons.add),
        label: const Text('Add Customer'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }
}

/// Modern customer card widget
class _CustomerCard extends StatelessWidget {
  final Customer customer;
  final VoidCallback onTap;

  const _CustomerCard({
    required this.customer,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingMd),
      decoration: AppTheme.cardDecoration,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 28,
                backgroundColor: AppTheme.primaryLight,
                child: Text(
                  '${customer.firstName[0]}${customer.lastName[0]}'.toUpperCase(),
                  style: AppTheme.headlineSmall.copyWith(
                    color: AppTheme.primaryDark,
                  ),
                ),
              ),
              SizedBox(width: AppTheme.spacingMd),

              // Customer Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${customer.firstName} ${customer.lastName}',
                      style: AppTheme.headlineSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: AppTheme.spacingXs),
                    if (customer.email != null)
                      Row(
                        children: [
                          Icon(
                            Icons.email_outlined,
                            size: 14,
                            color: AppTheme.textSecondary,
                          ),
                          SizedBox(width: AppTheme.spacingXs),
                          Expanded(
                            child: Text(
                              customer.email!,
                              style: AppTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    if (customer.mobileNumber != null) ...[
                      SizedBox(height: AppTheme.spacingXs),
                      Row(
                        children: [
                          Icon(
                            Icons.phone_outlined,
                            size: 14,
                            color: AppTheme.textSecondary,
                          ),
                          SizedBox(width: AppTheme.spacingXs),
                          Text(
                            customer.mobileNumber!,
                            style: AppTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Arrow Icon
              Icon(
                Icons.chevron_right,
                color: AppTheme.textHint,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
