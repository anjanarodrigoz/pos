/// Result pattern for handling success and failure cases
/// Provides type-safe error handling without exceptions
class Result<T> {
  final T? data;
  final AppError? error;
  final bool isSuccess;

  Result.success(this.data)
      : error = null,
        isSuccess = true;

  Result.failure(this.error)
      : data = null,
        isSuccess = false;

  /// Check if result is a failure
  bool get isFailure => !isSuccess;

  /// Get data or throw if failed
  T get dataOrThrow {
    if (isSuccess) {
      return data as T;
    }
    throw error!;
  }

  /// Get data or return default value
  T getOrDefault(T defaultValue) {
    return isSuccess ? data as T : defaultValue;
  }

  /// Map result to another type
  Result<R> map<R>(R Function(T data) mapper) {
    if (isSuccess) {
      try {
        return Result.success(mapper(data as T));
      } catch (e) {
        return Result.failure(AppError(
          code: 'MAPPING_ERROR',
          message: 'Error mapping result: $e',
        ));
      }
    }
    return Result.failure(error!);
  }

  /// Handle result with callbacks
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(AppError error) onFailure,
  }) {
    if (isSuccess) {
      return onSuccess(data as T);
    }
    return onFailure(error!);
  }
}

/// Application error with code and message
class AppError implements Exception {
  final String message;
  final String code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  AppError({
    required this.message,
    required this.code,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() => 'AppError($code): $message';

  /// Create error from exception
  factory AppError.fromException(Exception e, String code) {
    return AppError(
      code: code,
      message: e.toString(),
      originalError: e,
    );
  }

  /// Create generic error
  factory AppError.generic(String message) {
    return AppError(
      code: 'GENERIC_ERROR',
      message: message,
    );
  }

  /// Create not found error
  factory AppError.notFound(String resource) {
    return AppError(
      code: 'NOT_FOUND',
      message: '$resource not found',
    );
  }

  /// Create validation error
  factory AppError.validation(String message) {
    return AppError(
      code: 'VALIDATION_ERROR',
      message: message,
    );
  }

  /// Create unauthorized error
  factory AppError.unauthorized(String message) {
    return AppError(
      code: 'UNAUTHORIZED',
      message: message,
    );
  }

  /// Create network error
  factory AppError.network(String message) {
    return AppError(
      code: 'NETWORK_ERROR',
      message: message,
    );
  }
}
