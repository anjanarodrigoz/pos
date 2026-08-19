import 'package:drift/drift.dart';
import 'package:pos/database/pos_database.dart';
import 'package:pos/services/logger_service.dart';
import 'package:pos/utils/result.dart';

/// Repository for comment template operations using Drift database
/// Replaces GetStorage-based CommentsDB
class CommentTemplateRepository {
  final POSDatabase _database;

  CommentTemplateRepository(this._database);

  // ==================== READ OPERATIONS ====================

  /// Get all comment templates
  Future<Result<List<CommentTemplate>>> getAllTemplates() async {
    try {
      final templates = await _database.select(_database.commentTemplates).get();
      return Result.success(templates);
    } catch (e, stack) {
      AppLogger.error('Failed to get comment templates', e, stack);
      return Result.failure(AppError.generic('Failed to load comment templates'));
    }
  }

  /// Get single comment template by ID
  Future<Result<CommentTemplate>> getTemplate(String id) async {
    try {
      final template = await (_database.select(_database.commentTemplates)
            ..where((t) => t.id.equals(id)))
          .getSingle();

      return Result.success(template);
    } catch (e, stack) {
      AppLogger.error('Failed to get comment template $id', e, stack);
      return Result.failure(AppError.notFound('Comment template not found'));
    }
  }

  /// Search templates by name or comment content
  Future<Result<List<CommentTemplate>>> searchTemplates(String query) async {
    try {
      final templates = await (_database.select(_database.commentTemplates)
            ..where((t) => t.name.like('%$query%') | t.comment.like('%$query%'))
            ..orderBy([(t) => OrderingTerm.asc(t.name)]))
          .get();

      return Result.success(templates);
    } catch (e, stack) {
      AppLogger.error('Failed to search comment templates', e, stack);
      return Result.failure(AppError.generic('Failed to search templates'));
    }
  }

  // ==================== WRITE OPERATIONS ====================

  /// Create new comment template
  Future<Result<CommentTemplate>> createTemplate({
    required String name,
    required String comment,
  }) async {
    try {
      // Use name as ID (like the old GetStorage implementation)
      final id = name;

      final companion = CommentTemplatesCompanion.insert(
        id: id,
        name: name,
        comment: comment,
      );

      await _database.into(_database.commentTemplates).insert(
            companion,
            mode: InsertMode.replace, // Replace if exists
          );

      final template = await getTemplate(id);
      AppLogger.info('Comment template created: $id');

      return template;
    } catch (e, stack) {
      AppLogger.error('Failed to create comment template', e, stack);
      return Result.failure(AppError.generic('Failed to create template'));
    }
  }

  /// Update comment template
  Future<Result<CommentTemplate>> updateTemplate({
    required String id,
    String? name,
    String? comment,
  }) async {
    try {
      await (_database.update(_database.commentTemplates)
            ..where((t) => t.id.equals(id)))
          .write(CommentTemplatesCompanion(
        name: name != null ? Value(name) : const Value.absent(),
        comment: comment != null ? Value(comment) : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      ));

      final updated = await getTemplate(id);
      AppLogger.info('Comment template updated: $id');

      return updated;
    } catch (e, stack) {
      AppLogger.error('Failed to update comment template $id', e, stack);
      return Result.failure(AppError.generic('Failed to update template'));
    }
  }

  /// Delete comment template
  Future<Result<void>> deleteTemplate(String id) async {
    try {
      await (_database.delete(_database.commentTemplates)
            ..where((t) => t.id.equals(id)))
          .go();

      AppLogger.info('Comment template deleted: $id');
      return Result.success(null);
    } catch (e, stack) {
      AppLogger.error('Failed to delete comment template $id', e, stack);
      return Result.failure(AppError.generic('Failed to delete template'));
    }
  }

  // ==================== REACTIVE OPERATIONS ====================

  /// Watch all comment templates (reactive)
  Stream<List<CommentTemplate>> watchAllTemplates() {
    return (_database.select(_database.commentTemplates)
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  /// Watch single template
  Stream<CommentTemplate> watchTemplate(String id) {
    return (_database.select(_database.commentTemplates)
          ..where((t) => t.id.equals(id)))
        .watchSingle();
  }
}
