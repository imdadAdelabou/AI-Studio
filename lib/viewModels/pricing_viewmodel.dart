import 'package:docs_ai/models/error_model.dart';
import 'package:docs_ai/models/pricing.dart';
import 'package:docs_ai/models/user.dart';
import 'package:docs_ai/repository/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// [PricingViewModel] is a class that contains the logic for the pricing screen.
class PricingViewModel {
  /// Creates a [PricingViewModel] instance.
  Future<bool> updateUserPricing({
    required String pricingId,
    required WidgetRef ref,
  }) async {
    final ErrorModel errorModel = await ref
        .read(authRepositoryProvider)
        .updateUserPricing(pricingId: pricingId);
    if (errorModel.error != null) {
      return false;
    }
    final Pricing? newPricing = (errorModel.data as UserModel).pricing;
    final UserModel? currentUser = ref.read(userProvider);

    final UserModel userWithNewPricing =
        currentUser!.changePricing(newPricing!);
    ref.read(userProvider.notifier).update(
          (UserModel? state) => userWithNewPricing,
        );

    return true;
  }
}
