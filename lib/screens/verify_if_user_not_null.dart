import 'package:docs_ai/models/user.dart';
import 'package:docs_ai/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A widget that show a circularProgressindicator widget when the user data
/// is still getting from the server and display
/// a custom widget when all the data is loaded
class VerifyIfUserNotNull extends ConsumerWidget {
  /// Creates a [VerifyIfUserNotNull] widget
  const VerifyIfUserNotNull({
    required this.child,
    super.key,
  });

  /// Contains the child to display when user data is loaded
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserModel? user = ref.watch(userProvider);

    return user != null
        ? child
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
