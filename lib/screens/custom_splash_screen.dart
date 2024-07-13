import 'dart:async';

import 'package:docs_ai/repository/auth_repository.dart';
import 'package:docs_ai/utils/app_assets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

/// A custom splash screen widget
class CustomSplashScreen extends ConsumerStatefulWidget {
  /// Creates a [CustomSplashScreen] widget
  const CustomSplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomSplashScreenState();
}

class _CustomSplashScreenState extends ConsumerState<CustomSplashScreen> {
  late Timer timer;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      timer = Timer(const Duration(seconds: 2), () {
        final String? token = ref.read(userProvider)?.token;
        if (token == null || token.isEmpty) {
          if (kIsWeb) {
            Routemaster.of(context).replace('/login');
          } else {
            Routemaster.of(context).replace('/login-mobile');
          }
        }
      });
    });

    return Scaffold(
      body: Center(
        child: Image.asset(
          AppAssets.googleDocsIcon,
          height: 170,
          fit: BoxFit.scaleDown,
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
