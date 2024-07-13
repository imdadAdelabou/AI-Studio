import 'package:docs_ai/models/error_model.dart';
import 'package:docs_ai/repository/ai_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A view model that summarize the text
class AIViewModel {
  /// Summarize the text
  Future<String?> summarize({
    required WidgetRef ref,
    required String text,
  }) async {
    final ErrorModel result =
        await ref.read(aiRepositoryProvider).summarizeText(text);
    return result.data;
  }

  /// Generate an AI image
  Future<List<String>> genAiImage({
    required WidgetRef ref,
    required String prompt,
  }) async {
    final ErrorModel result =
        await ref.read(aiRepositoryProvider).generateAImage(prompt);

    return result.data as List<String>;
  }
}
