import 'package:pos/database/pos_database.dart' as drift;
import 'package:pos/models/item.dart' as domain;

/// Helper class to convert between Drift database Item model and domain Item model
/// The domain model has additional fields (multiple prices, buying price, etc.)
/// that may not be present in the Drift database
class ItemConverter {
  /// Convert Drift Item to domain Item model
  static domain.Item toDomain(drift.Item driftItem) {
    return domain.Item(
      id: driftItem.id,
      name: driftItem.name,
      description: driftItem.description,
      price: driftItem.price,
      qty: driftItem.quantity,
      // Fields not in Drift - use defaults
      comment: null,
      buyingPrice: 0.0,
      priceTwo: 0.0,
      priceThree: 0.0,
      priceFour: 0.0,
      priceFive: 0.0,
      lastInDate: null,
      lastOutDate: null,
    );
  }

  /// Convert list of Drift Items to list of domain Items
  static List<domain.Item> toDomainList(List<drift.Item> driftItems) {
    return driftItems.map((driftItem) => toDomain(driftItem)).toList();
  }
}
