import 'package:docs_ai/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

void main() {
  patrolTest(
    'Verify if Sign in with google btn is avaible inside the widget tree',
    (PatrolIntegrationTester $) async {
      // Replace later with your app's main widget
      await $.pumpWidgetAndSettle(
        const ProviderScope(
          child: MainApp(),
        ),
      );
      const Key signInWithGoogleBtnKey = Key('sign-in-with-google-btn');

      final Finder signInWithGoogleBtn = find.byKey(signInWithGoogleBtnKey);

      expect(signInWithGoogleBtn, findsOneWidget);
    },
  );

  patrolTest(
    'Verify if Sign in with google work when the button is tapped',
    (PatrolIntegrationTester $) async {
      // Replace later with your app's main widget

      await $.pumpWidgetAndSettle(
        const ProviderScope(
          child: MainApp(),
        ),
      );
      const Key signInWithGoogleBtnKey = Key('sign-in-with-google-btn');
      final Finder signInWithGoogleBtn = find.byKey(signInWithGoogleBtnKey);

      await $.tap(signInWithGoogleBtn);
      await $.native.tap(Selector(text: 'imdad imdad'));
      await $.pumpAndSettle();
      final Finder emailTextWidget = find.text('imdad.tech.web3hub@gmail.com');
      expect(emailTextWidget, findsOneWidget);
    },
  );
}
