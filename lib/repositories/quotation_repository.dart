import 'package:drift/drift.dart';
import 'package:pos/database/pos_database.dart';
import 'package:pos/services/logger_service.dart';
import 'package:pos/utils/id_generator.dart';
import 'package:pos/utils/result.dart';

class QuotationRepository {
  final POSDatabase _database;
  QuotationRepository(this._database);

  Future<Result<List<Quotation>>> getAllQuotations() async {
    try {
      final quotations = await (_database.select(_database.quotations)
            ..orderBy([(q) => OrderingTerm.desc(q.createdDate)])).get();
      return Result.success(quotations);
    } catch (e, stack) {
      AppLogger.error('Failed to get quotations', e, stack);
      return Result.failure(AppError.generic('Failed to load quotations'));
    }
  }

  Future<Result<Quotation>> getQuotation(String quotationId) async {
    try {
      final quotation = await (_database.select(_database.quotations)
            ..where((q) => q.quotationId.equals(quotationId))).getSingle();
      return Result.success(quotation);
    } catch (e, stack) {
      AppLogger.error('Failed to get quotation $quotationId', e, stack);
      return Result.failure(AppError.notFound('Quotation not found'));
    }
  }

  Future<Result<String>> createQuotation({
    required String customerId,
    required String customerName,
    required double total,
    String status = 'draft',
    DateTime? expiryDate,
  }) async {
    try {
      final quotationId = IDGenerator.generateQuotationId();
      final companion = QuotationsCompanion.insert(
        quotationId: quotationId,
        customerId: customerId,
        createdDate: DateTime.now(),
        total: total,
        status: status,
        customerName: customerName,
        expiryDate: Value(expiryDate),
      );
      await _database.into(_database.quotations).insert(companion);
      AppLogger.info('Quotation created: $quotationId');
      return Result.success(quotationId);
    } catch (e, stack) {
      AppLogger.error('Failed to create quotation', e, stack);
      return Result.failure(AppError.generic('Failed to create quotation'));
    }
  }

  Future<Result<void>> updateQuotationStatus(String quotationId, String status) async {
    try {
      await (_database.update(_database.quotations)
            ..where((q) => q.quotationId.equals(quotationId)))
          .write(QuotationsCompanion(status: Value(status)));
      return Result.success(null);
    } catch (e, stack) {
      AppLogger.error('Failed to update quotation status', e, stack);
      return Result.failure(AppError.generic('Failed to update status'));
    }
  }

  Future<Result<void>> deleteQuotation(String quotationId) async {
    try {
      await (_database.delete(_database.quotations)
            ..where((q) => q.quotationId.equals(quotationId))).go();
      AppLogger.info('Quotation deleted: $quotationId');
      return Result.success(null);
    } catch (e, stack) {
      AppLogger.error('Failed to delete quotation', e, stack);
      return Result.failure(AppError.generic('Failed to delete quotation'));
    }
  }

  Stream<List<Quotation>> watchAllQuotations() {
    return (_database.select(_database.quotations)
          ..orderBy([(q) => OrderingTerm.desc(q.createdDate)])).watch();
  }
}
