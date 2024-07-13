import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

const String _kstripeSecret =
    'sk_test_51PEQdbDJoBHbjuPPkRWJSLzV1bnjrav90ZVraPQxbeMcjYb6B3NayflzZ4eluvHFivTeRFDTP9rY5uhj9VqICftd00xpCuPBuL';

/// Contains the provider for the [StripeRepository] access it globaly
final Provider<StripeRepository> stripeRepositoryProvider =
    Provider<StripeRepository>(
  (ProviderRef<Object?> ref) => StripeRepository(
    dioClient: Dio(
      BaseOptions(
        baseUrl: 'https://api.stripe.com/v1',
        headers: <String, dynamic>{
          'Authorization': 'Bearer $_kstripeSecret',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      ),
    ),
  ),
);

/// Contains the methods to interact with the Stripe API2
class StripeRepository {
  /// Creates a [StripeRepository] instance
  const StripeRepository({required Dio dioClient}) : _dioClient = dioClient;

  final Dio _dioClient;

  /// Make a payment using stripe
  Future<bool> stripeMakePayment({
    required int amount,
    required String currency,
  }) async {
    try {
      final Map<String, dynamic>? paymentIntent = await _createPaymentIntent(
        amount: amount,
        currency: currency,
      );
      if (paymentIntent == null) {
        return false;
      }
      final String clientSecret = paymentIntent['client_secret'] as String;

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          style: ThemeMode.light,
          merchantDisplayName: 'Docs AI',
        ),
      );
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<Map<String, dynamic>?> _createPaymentIntent({
    required int amount,
    required String currency,
  }) async {
    try {
      final Response<dynamic> response = await _dioClient.post(
        '/payment_intents',
        data: <String, dynamic>{
          'amount': amount,
          'currency': currency,
        },
      );

      return response.data as Map<String, dynamic>?;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
