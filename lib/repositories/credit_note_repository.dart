import 'package:drift/drift.dart';
import 'package:pos/database/pos_database.dart';
import 'package:pos/services/logger_service.dart';
import 'package:pos/utils/id_generator.dart';
import 'package:pos/utils/result.dart';

class CreditNoteRepository {
  final POSDatabase _database;
  CreditNoteRepository(this._database);

  Future<Result<List<CreditNote>>> getAllCreditNotes() async {
    try {
      final creditNotes = await (_database.select(_database.creditNotes)
            ..orderBy([(c) => OrderingTerm.desc(c.createdDate)])).get();
      return Result.success(creditNotes);
    } catch (e, stack) {
      AppLogger.error('Failed to get credit notes', e, stack);
      return Result.failure(AppError.generic('Failed to load credit notes'));
    }
  }

  Future<Result<CreditNote>> getCreditNote(String creditNoteId) async {
    try {
      final creditNote = await (_database.select(_database.creditNotes)
            ..where((c) => c.creditNoteId.equals(creditNoteId))).getSingle();
      return Result.success(creditNote);
    } catch (e, stack) {
      AppLogger.error('Failed to get credit note $creditNoteId', e, stack);
      return Result.failure(AppError.notFound('Credit note not found'));
    }
  }

  Future<Result<String>> createCreditNote({
    required String invoiceId,
    required String customerId,
    required String customerName,
    required double amount,
    String? reason,
  }) async {
    try {
      final creditNoteId = IDGenerator.generateCreditNoteId();
      final companion = CreditNotesCompanion.insert(
        creditNoteId: creditNoteId,
        invoiceId: invoiceId,
        customerId: customerId,
        createdDate: DateTime.now(),
        amount: amount,
        reason: Value(reason),
        customerName: customerName,
      );
      await _database.into(_database.creditNotes).insert(companion);
      AppLogger.info('Credit note created: $creditNoteId');
      return Result.success(creditNoteId);
    } catch (e, stack) {
      AppLogger.error('Failed to create credit note', e, stack);
      return Result.failure(AppError.generic('Failed to create credit note'));
    }
  }

  Future<Result<List<CreditNote>>> getCreditNotesByInvoice(String invoiceId) async {
    try {
      final creditNotes = await (_database.select(_database.creditNotes)
            ..where((c) => c.invoiceId.equals(invoiceId))).get();
      return Result.success(creditNotes);
    } catch (e, stack) {
      AppLogger.error('Failed to get credit notes for invoice', e, stack);
      return Result.failure(AppError.generic('Failed to load credit notes'));
    }
  }

  Future<Result<void>> deleteCreditNote(String creditNoteId) async {
    try {
      await (_database.delete(_database.creditNotes)
            ..where((c) => c.creditNoteId.equals(creditNoteId))).go();
      AppLogger.info('Credit note deleted: $creditNoteId');
      return Result.success(null);
    } catch (e, stack) {
      AppLogger.error('Failed to delete credit note', e, stack);
      return Result.failure(AppError.generic('Failed to delete credit note'));
    }
  }

  Stream<List<CreditNote>> watchAllCreditNotes() {
    return (_database.select(_database.creditNotes)
          ..orderBy([(c) => OrderingTerm.desc(c.createdDate)])).watch();
  }
}
