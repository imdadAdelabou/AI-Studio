import 'dart:developer';

import 'package:docs_ai/models/error_model.dart';
import 'package:docs_ai/models/user.dart';
import 'package:docs_ai/repository/auth_repository.dart';
import 'package:docs_ai/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

/// Contains all the logics using inside and using by the LoginView
class LoginViewModel {
  /// Creates a [LoginViewModel] widget
  const LoginViewModel();

  /// A function that trigger the sign in with logger and redirect
  /// the user to the home screen if the sign in is succesded
  /// otherwise the function show a snackbar with an error
  Future<void> signinWithGoogle(WidgetRef ref, BuildContext context) async {
    final ScaffoldMessengerState sMessenger = ScaffoldMessenger.of(context);
    final Routemaster navigator = Routemaster.of(context);
    final ErrorModel result =
        await ref.read(authRepositoryProvider).signInWithGoogle();
    if (result.error != null) {
      sMessenger.showSnackBar(
        customSnackBar(content: result.error!, isError: true),
      );
      return;
    }
    //We need to update the state with a new value of user
    ref.read(userProvider.notifier).update((UserModel? state) => result.data);
    final UserModel user = result.data as UserModel;
    log('IsNewUser: ${user.isNewUser}');
    if (user.isNewUser != null && user.isNewUser!) {
      navigator.replace('/upload-picture');
    } else {
      navigator.replace('/');
    }
  }

  /// A function that trigger the register with email and password
  Future<bool> registerWithEmailAndPassword(
    WidgetRef ref,
    BuildContext context, {
    required String email,
    required String name,
    required String password,
  }) async {
    final ScaffoldMessengerState sMessenger = ScaffoldMessenger.of(context);
    final ErrorModel result =
        await ref.read(authRepositoryProvider).registerWithEmailAndPassword(
              email: email,
              name: name,
              password: password,
            );
    if (result.error != null) {
      sMessenger.showSnackBar(
        customSnackBar(content: result.error!, isError: true),
      );
      return false;
    }
    //We need to update the state with a new value of user
    ref.read(userProvider.notifier).update((UserModel? state) => result.data);

    return true;
  }

  /// A function that trigger the login with email and password
  Future<bool> loginWithEmailAndPassword(
    WidgetRef ref,
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    final ScaffoldMessengerState sMessenger = ScaffoldMessenger.of(context);
    final ErrorModel result =
        await ref.read(authRepositoryProvider).loginWithEmailAndPassword(
              email: email,
              password: password,
            );
    if (result.error != null) {
      sMessenger.showSnackBar(
        customSnackBar(content: result.error!, isError: true),
      );
      return false;
    }
    //We need to update the state with a new value of user
    ref.read(userProvider.notifier).update((UserModel? state) => result.data);

    return true;
  }
}
