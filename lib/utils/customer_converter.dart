import 'package:pos/database/pos_database.dart' as drift;
import 'package:pos/models/customer.dart' as domain;
import 'package:pos/models/address.dart';

/// Helper class to convert between Drift database Customer and domain Customer model
class CustomerConverter {
  /// Convert Drift Customer to domain Customer model
  static domain.Customer toDomain(drift.Customer driftCustomer) {
    // Build delivery address from billing fields
    Address? deliveryAddress;
    if (driftCustomer.billingStreet != null ||
        driftCustomer.billingCity != null ||
        driftCustomer.billingState != null) {
      deliveryAddress = Address(
        street: driftCustomer.billingStreet ?? '',
        city: driftCustomer.billingCity ?? '',
        state: driftCustomer.billingState ?? '',
        postalCode: driftCustomer.billingPostalCode ?? '',
        areaCode: driftCustomer.billingAreaCode ?? '',
        county: driftCustomer.billingCountry ?? '',
      );
    }

    // Build postal address from postal fields
    Address? postalAddress;
    if (driftCustomer.postalStreet != null ||
        driftCustomer.postalCity != null ||
        driftCustomer.postalState != null) {
      postalAddress = Address(
        street: driftCustomer.postalStreet ?? '',
        city: driftCustomer.postalCity ?? '',
        state: driftCustomer.postalState ?? '',
        postalCode: driftCustomer.postalPostalCode ?? '',
        areaCode: driftCustomer.postalAreaCode ?? '',
        county: driftCustomer.postalCountry ?? '',
      );
    }

    return domain.Customer(
      id: driftCustomer.id,
      firstName: driftCustomer.firstName,
      lastName: driftCustomer.lastName,
      mobileNumber: driftCustomer.mobileNumber ?? '',
      deliveryAddress: deliveryAddress,
      postalAddress: postalAddress,
      fax: driftCustomer.fax,
      email: driftCustomer.email,
      web: driftCustomer.web,
      comment: driftCustomer.comment,
      abn: driftCustomer.abn,
      acn: driftCustomer.acn,
      onHold: false, // TODO: Add onHold field to Drift table if needed
      outStanding: 0.0, // TODO: Calculate from invoices if needed
      limit: null, // TODO: Add limit field to Drift table if needed
    );
  }

  /// Convert list of Drift Customers to list of domain Customers
  static List<domain.Customer> toDomainList(List<drift.Customer> driftCustomers) {
    return driftCustomers.map((driftCustomer) => toDomain(driftCustomer)).toList();
  }
}
