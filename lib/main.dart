import 'dart:async';

import 'package:docs_ai/firebase_options.dart';
import 'package:docs_ai/models/error_model.dart';
import 'package:docs_ai/models/user.dart';
import 'package:docs_ai/repository/auth_repository.dart';
import 'package:docs_ai/router.dart';
import 'package:docs_ai/utils/constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'package:routemaster/routemaster.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = kStripePublishableKey;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (!kIsWeb) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
}

/// The first widget that is load when the application is launch for the first time
class MainApp extends ConsumerStatefulWidget {
  /// Creates a [MainApp] widget
  const MainApp({super.key});

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  bool isLoading = false;
  ErrorModel? errorModel;
  late Timer? _timer;

  Future<void> getUserData() async {
    errorModel = await ref.read(authRepositoryProvider).getUserData();
    if (errorModel != null && errorModel!.data != null) {
      ref.read(userProvider.notifier).update(
            (UserModel? state) => errorModel!.data,
          );
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(getUserData());
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerDelegate: RoutemasterDelegate(
        routesBuilder: (BuildContext context) {
          final UserModel? user = ref.watch(userProvider);
          if (user != null && user.token.isNotEmpty) {
            //User is connected root
            return loggedInRoute;
          }

          return loggedOutRoute;
        },
      ),
      routeInformationParser: const RoutemasterParser(),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

// //flutter run -d chrome --web-port 3000
// flutter run -d chrome --web-port 3000 --web-browser-flag "--disable-web-security"
