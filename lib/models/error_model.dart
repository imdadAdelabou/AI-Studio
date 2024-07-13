/// The model to manange API request result
class ErrorModel {
  /// Creates [ErrorModel] instance
  const ErrorModel({
    required this.data,
    this.error,
  });

  /// Contains the error when the API request fail
  final String? error;

  /// Contains the data when the API request succeeds
  final dynamic data;
}
