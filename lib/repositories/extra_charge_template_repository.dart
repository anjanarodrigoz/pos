import 'package:drift/drift.dart';
import 'package:pos/database/pos_database.dart';
import 'package:pos/services/logger_service.dart';
import 'package:pos/utils/result.dart';

/// Repository for extra charge template operations using Drift database
/// Replaces GetStorage-based ExtraChargeDB
class ExtraChargeTemplateRepository {
  final POSDatabase _database;

  ExtraChargeTemplateRepository(this._database);

  // ==================== READ OPERATIONS ====================

  /// Get all extra charge templates
  Future<Result<List<ExtraChargeTemplate>>> getAllTemplates() async {
    try {
      final templates = await _database.select(_database.extraChargeTemplates).get();
      return Result.success(templates);
    } catch (e, stack) {
      AppLogger.error('Failed to get extra charge templates', e, stack);
      return Result.failure(AppError.generic('Failed to load extra charge templates'));
    }
  }

  /// Get single extra charge template by ID
  Future<Result<ExtraChargeTemplate>> getTemplate(String id) async {
    try {
      final template = await (_database.select(_database.extraChargeTemplates)
            ..where((t) => t.id.equals(id)))
          .getSingle();

      return Result.success(template);
    } catch (e, stack) {
      AppLogger.error('Failed to get extra charge template $id', e, stack);
      return Result.failure(AppError.notFound('Extra charge template not found'));
    }
  }

  /// Search templates by name
  Future<Result<List<ExtraChargeTemplate>>> searchTemplates(String query) async {
    try {
      final templates = await (_database.select(_database.extraChargeTemplates)
            ..where((t) => t.name.like('%$query%'))
            ..orderBy([(t) => OrderingTerm.asc(t.name)]))
          .get();

      return Result.success(templates);
    } catch (e, stack) {
      AppLogger.error('Failed to search extra charge templates', e, stack);
      return Result.failure(AppError.generic('Failed to search templates'));
    }
  }

  // ==================== WRITE OPERATIONS ====================

  /// Create new extra charge template
  Future<Result<ExtraChargeTemplate>> createTemplate({
    required String name,
    required double price,
    int quantity = 1,
    String? comment,
  }) async {
    try {
      // Use name as ID (like the old GetStorage implementation)
      final id = name;

      final companion = ExtraChargeTemplatesCompanion.insert(
        id: id,
        name: name,
        price: price,
        quantity: Value(quantity),
        comment: Value(comment),
      );

      await _database.into(_database.extraChargeTemplates).insert(
            companion,
            mode: InsertMode.replace, // Replace if exists
          );

      final template = await getTemplate(id);
      AppLogger.info('Extra charge template created: $id');

      return template;
    } catch (e, stack) {
      AppLogger.error('Failed to create extra charge template', e, stack);
      return Result.failure(AppError.generic('Failed to create template'));
    }
  }

  /// Update extra charge template
  Future<Result<ExtraChargeTemplate>> updateTemplate({
    required String id,
    String? name,
    double? price,
    int? quantity,
    String? comment,
  }) async {
    try {
      await (_database.update(_database.extraChargeTemplates)
            ..where((t) => t.id.equals(id)))
          .write(ExtraChargeTemplatesCompanion(
        name: name != null ? Value(name) : const Value.absent(),
        price: price != null ? Value(price) : const Value.absent(),
        quantity: quantity != null ? Value(quantity) : const Value.absent(),
        comment: comment != null ? Value(comment) : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      ));

      final updated = await getTemplate(id);
      AppLogger.info('Extra charge template updated: $id');

      return updated;
    } catch (e, stack) {
      AppLogger.error('Failed to update extra charge template $id', e, stack);
      return Result.failure(AppError.generic('Failed to update template'));
    }
  }

  /// Delete extra charge template
  Future<Result<void>> deleteTemplate(String id) async {
    try {
      await (_database.delete(_database.extraChargeTemplates)
            ..where((t) => t.id.equals(id)))
          .go();

      AppLogger.info('Extra charge template deleted: $id');
      return Result.success(null);
    } catch (e, stack) {
      AppLogger.error('Failed to delete extra charge template $id', e, stack);
      return Result.failure(AppError.generic('Failed to delete template'));
    }
  }

  // ==================== REACTIVE OPERATIONS ====================

  /// Watch all extra charge templates (reactive)
  Stream<List<ExtraChargeTemplate>> watchAllTemplates() {
    return (_database.select(_database.extraChargeTemplates)
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  /// Watch single template
  Stream<ExtraChargeTemplate> watchTemplate(String id) {
    return (_database.select(_database.extraChargeTemplates)
          ..where((t) => t.id.equals(id)))
        .watchSingle();
  }
}
