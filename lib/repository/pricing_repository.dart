import 'package:dio/dio.dart';
import 'package:docs_ai/models/error_model.dart';
import 'package:docs_ai/models/pricing.dart';
import 'package:docs_ai/utils/app_text.dart';
import 'package:docs_ai/utils/constant.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Contains the provider for the [PricingRepository]
final Provider<PricingRepository> pricingRepositoryProvider =
    Provider<PricingRepository>(
  (ProviderRef<Object?> ref) => PricingRepository(
    dioClient: dioClient,
  ),
);

/// Represents the repository to fetch pricing data
class PricingRepository {
  /// Creates a [PricingRepository] instance
  const PricingRepository({
    required Dio dioClient,
  }) : _dioClient = dioClient;

  final Dio _dioClient;

  /// A function to get all the available pricing
  Future<ErrorModel> getPricing() async {
    try {
      final Response<dynamic> res = await _dioClient.get(
        '/pricing',
      );
      if (res.statusCode == 200) {
        return ErrorModel(
          data: (res.data['pricing'] as List<dynamic>)
              .map<Pricing>(
                (dynamic e) => Pricing.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
      }

      return const ErrorModel(
        error: 'Bad request',
        data: null,
      );
    } on DioException catch (_) {
      return const ErrorModel(
        data: null,
        error: AppText.errorHappened,
      );
    }
  }
}

/// Get Pricing provider
Future<ErrorModel> getPricing(FutureProviderRef<Object?> ref) {
  return ref.watch(pricingRepositoryProvider).getPricing();
}

/// Get Pricing provider
final FutureProvider<ErrorModel> getPricingProvider =
    FutureProvider<ErrorModel>(getPricing);
