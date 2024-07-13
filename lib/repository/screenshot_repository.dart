import 'dart:typed_data';

import 'package:docs_ai/models/document_model.dart';
import 'package:docs_ai/screens/document/document_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screenshot/screenshot.dart';

/// Allow to store the screenshotRepository inside the provider and access them globaly
final Provider<ScreenshotRepository> screenshotRepositoryProvider =
    Provider<ScreenshotRepository>(
  (ProviderRef<ScreenshotRepository> ref) => ScreenshotRepository(),
);

/// Contains the functions used to take a screenshot of a widget
class ScreenshotRepository {
  final ScreenshotController _screenShotController = ScreenshotController();

  /// A function to capture the image of a widget
  Future<Uint8List> captureFromAWidget(
    DocumentModel document,
    BuildContext context,
  ) async {
    final QuillController controller = QuillController.basic()
      ..document = document.content.isEmpty
          ? Document()
          : Document.fromDelta(
              Delta.fromJson(document.content),
            );
    final Uint8List capturedImage =
        await _screenShotController.captureFromWidget(
      MediaQuery(
        data: MediaQuery.of(context),
        child: MaterialApp(
          home: SizedBox(
            width: 208,
            height: 263,
            child: DocumentBody(controller: controller),
          ),
        ),
      ),
    );

    return capturedImage;
  }
}
