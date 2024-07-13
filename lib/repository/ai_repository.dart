import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:docs_ai/models/error_model.dart';
import 'package:docs_ai/utils/app_text.dart';
import 'package:docs_ai/utils/constant.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The provider for the AI repository
final Provider<AIRepository> aiRepositoryProvider = Provider<AIRepository>(
  (ProviderRef<Object?> ref) => AIRepository(
    dioClient: dioClient,
  ),
);

/// A class that handles the AI repository
class AIRepository {
  /// Creates a [AIRepository] instance
  const AIRepository({required Dio dioClient}) : _dioClient = dioClient;

  final Dio _dioClient;

  /// Summarize the text
  Future<ErrorModel> summarizeText(String text) async {
    try {
      final Response<dynamic> response = await _dioClient.post(
        '/openai/summarize',
        data: <String, dynamic>{
          'text': text,
        },
      );
      if (response.statusCode == 200) {
        return ErrorModel(
          data: (response.data as Map<String, dynamic>)['data'] as String,
        );
      }

      return const ErrorModel(
        data: null,
        error: AppText.errorHappened,
      );
    } on DioException catch (e) {
      return ErrorModel(
        error: e.response!.statusMessage,
        data: null,
      );
    }
  }

  /// Generate an image using the prompt
  Future<ErrorModel> generateAImage(String prompt) async {
    try {
      final Response<dynamic> response = await _dioClient.post(
        '/openai/gen_image',
        data: <String, dynamic>{
          'prompt': prompt,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data as Map<String, dynamic>;

        return ErrorModel(
          data: (data['data'] as List<dynamic>)
              .map((dynamic e) => e['url'] as String)
              .toList(),
        );
      }

      return const ErrorModel(
        data: <String>[],
        error: AppText.errorHappened,
      );
    } on DioException catch (e) {
      log(e.toString());
      return ErrorModel(
        error: e.response!.statusMessage,
        data: <String>[],
      );
    }
  }
}
