import 'package:docs_ai/models/document_model.dart';
import 'package:docs_ai/screens/document/widgets/document_card.dart';
import 'package:docs_ai/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late DocumentModel document;
  setUp(() {
    document = DocumentModel(
      id: '1',
      uid: 'imdad96',
      createdAt: DateTime(2024, 12, 12),
      title: 'New Document',
      content: <dynamic>[],
      image: null,
    );
  });

  testWidgets(
    'DocumentCard should display the basic information of a document',
    (WidgetTester widgetTester) async {
      await widgetTester.pumpWidget(
        Material(
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: DocumentCard(document: document),
          ),
        ),
      );
      final Finder placeHolederDocumentCardFinder =
          find.byKey(const Key('document-card-image'));
      final Finder titleDocumentFinder = find.text(document.title);
      final Finder createdAtDocumentFinder =
          find.text(formatDate(document.createdAt));

      expect(titleDocumentFinder, findsOneWidget);
      expect(createdAtDocumentFinder, findsOneWidget);
      expect(placeHolederDocumentCardFinder, findsOneWidget);
    },
  );
}
