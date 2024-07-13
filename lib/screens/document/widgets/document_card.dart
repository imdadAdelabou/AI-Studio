import 'package:docs_ai/models/document_model.dart';
import 'package:docs_ai/utils/app_assets.dart';
import 'package:docs_ai/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:routemaster/routemaster.dart';

/// Display a summary of a document data
class DocumentCard extends StatelessWidget {
  /// Creates [DocumentCard] widget
  const DocumentCard({
    required this.document,
    super.key,
  });

  /// Contains the value of the document to display
  final DocumentModel document;

  void _goToDocument(BuildContext context, String documentId) {
    Routemaster.of(context).push('/document/$documentId');
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _goToDocument(context, document.id),
      child: Card(
        color: kWhiteColor,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 170,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: kGreyColor.withOpacity(0.2),
                  ),
                  child: Image.asset(
                    AppAssets.googleDocsIcon,
                    key: const Key('document-card-image'),
                  ),
                ),
              ),
            ),
            DocumentDetails(
              title: document.title,
              createdAt: document.createdAt,
            ),
          ],
        ),
      ),
    );
  }
}

/// Display the title and the creation date of a document
class DocumentDetails extends StatelessWidget {
  /// Creates a [DocumentDetails] widget
  const DocumentDetails({
    required this.title,
    required this.createdAt,
    super.key,
  });

  /// The title of the document
  final String title;

  /// The date the document was created
  final DateTime createdAt;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Gap(4),
          Text(
            title,
            style: GoogleFonts.lato(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          Text(
            DateFormat('yyyy/MM/dd').format(createdAt),
            style: GoogleFonts.lato(
              color: kGreyColorPure,
            ),
          ),
          const Gap(8),
        ],
      ),
    );
  }
}
