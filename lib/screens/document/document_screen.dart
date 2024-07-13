import 'dart:async';

import 'package:docs_ai/models/document_model.dart';
import 'package:docs_ai/models/error_model.dart';
import 'package:docs_ai/repository/auth_repository.dart';
import 'package:docs_ai/repository/document_repository.dart';
import 'package:docs_ai/repository/socket_repository.dart';
import 'package:docs_ai/screens/document/studio/ai_studio.dart';
import 'package:docs_ai/screens/document/widgets/document_screen_app_bar.dart';
import 'package:docs_ai/screens/document/widgets/gen_ai_image.dart';
import 'package:docs_ai/screens/document/widgets/summarize_text.dart';
import 'package:docs_ai/utils/app_text.dart';
import 'package:docs_ai/utils/colors.dart';
import 'package:docs_ai/widgets/close_dialog_icon.dart';
import 'package:docs_ai/widgets/custom_snack_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class _FloatingAIActionButton extends StatelessWidget {
  const _FloatingAIActionButton({
    required this.icon,
    required this.onPressed,
    super.key,
  });

  final IconData icon;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: null,
      key: key,
      backgroundColor: kBlueColorVariant,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      onPressed: onPressed,
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }
}

//Snippet : stfl
/// Contains the visual aspect of the document screen
class DocumentScreen extends ConsumerStatefulWidget {
  /// Creates [DocumentScreen] widget
  const DocumentScreen({
    required this.id,
    super.key,
  });

  /// Contains the unique id of the document to display
  final String id;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends ConsumerState<DocumentScreen> {
  final TextEditingController titleCtrl = TextEditingController(
    text: 'Untitled Document',
  );
  final QuillController _controller = QuillController.basic();
  late ErrorModel _errorModel;
  SocketRespository socketRespository = SocketRespository();
  late StreamSubscription<DocChange> _subscriptionToDoc;
  late Timer timerAutoSave;

  Future<void> _fetchDocumentData() async {
    _errorModel = await ref.read(documentRepositoryProvider).getDocumentById(
          docId: widget.id,
          token: ref.read(userProvider)!.token,
        );

    if (_errorModel.data != null) {
      final DocumentModel document = _errorModel.data;
      titleCtrl.text = document.title;

      _controller.document = document.content.isEmpty
          ? Document()
          : Document.fromDelta(
              Delta.fromJson(document.content),
            );
      setState(() {});
    }
    _subscriptionToDoc = _controller.document.changes.listen(
      (DocChange event) {
        if (event.source == ChangeSource.local) {
          final Map<String, dynamic> map = <String, dynamic>{
            'delta': event.change,
            'room': widget.id,
          };

          socketRespository.typing(map);
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    socketRespository.joinRoom(widget.id);
    unawaited(_fetchDocumentData());

    socketRespository.changeListener(
      (Map<String, dynamic> data) {
        _controller.compose(
          Delta.fromJson(data['delta']),
          const TextSelection.collapsed(offset: 0),
          ChangeSource.remote,
        );
      },
    );

    Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      socketRespository.save(
        <String, dynamic>{
          'id': widget.id,
          'delta': _controller.document.toDelta(),
        },
      );
    });
  }

  Future<void> _showAIFeatureDialog({
    required BuildContext context,
    required String dialogTitle,
    required Widget child,
  }) async {
    final double maxWidth = MediaQuery.of(context).size.width;

    unawaited(
      showDialog<dynamic>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            icon: const CloseDialogIcon(),
            backgroundColor: kWhiteColor,
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text(
              dialogTitle,
              style: GoogleFonts.lato(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.start,
            ),
            content: SizedBox(
              width: maxWidth > 480 ? maxWidth * .5 : maxWidth,
              child: child,
            ),
          );
        },
      ),
    );
  }

  void _showSummaryDialog({
    required BuildContext context,
    required String dialogTitle,
  }) {
    unawaited(
      _showAIFeatureDialog(
        context: context,
        dialogTitle: 'Summarize a text using AI',
        child: SummarizeText(controller: _controller),
      ),
    );
  }

  void _showEngineStudio({
    required BuildContext context,
    required String dialogTitle,
  }) {
    unawaited(
      _showAIFeatureDialog(
        context: context,
        dialogTitle: dialogTitle,
        child: AiStudio(),
      ),
    );
  }

  void _showGenAiImageDialog({
    required BuildContext context,
    required String dialogTitle,
  }) {
    unawaited(
      _showAIFeatureDialog(
        context: context,
        dialogTitle: 'Generate an image using AI',
        child: GenAiImage(
          controller: _controller,
        ),
      ),
    );
  }

  void _saved() {
    unawaited(
      ref
          .read(documentRepositoryProvider)
          .updateContentDocument(
            docId: widget.id,
            token: ref.read(userProvider)!.token,
            content: _controller.document.toDelta().toJson(),
          )
          .then(
            (ErrorModel value) => ScaffoldMessenger.of(context).showSnackBar(
              customSnackBar(
                content: 'Saved',
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DocumentScreenAppBar(
        titleCtrl: titleCtrl,
        id: widget.id,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              const Gap(10),
              QuillToolbar.simple(
                configurations: QuillSimpleToolbarConfigurations(
                  controller: _controller,
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 750,
                  minHeight: MediaQuery.of(context).size.height - 100,
                ),
                child: DocumentBody(
                  controller: _controller,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _FloatingAIActionButton(
            icon: Icons.build,
            onPressed: () => _showEngineStudio(
              context: context,
              dialogTitle: AppText.aiStudio,
            ),
          ),
          _FloatingAIActionButton(
            icon: Icons.summarize,
            onPressed: () => _showSummaryDialog(
              context: context,
              dialogTitle: 'Summarize a text using AI',
            ),
          ),
          Visibility(
            visible: ref.watch(userProvider)!.pricing!.label == 'Pro',
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: _FloatingAIActionButton(
                key: const Key('gen_image_ai_button'),
                icon: Icons.image,
                onPressed: () => _showGenAiImageDialog(
                  context: context,
                  dialogTitle: 'Generate an image using AI',
                ),
              ),
            ),
          ),
          const Gap(8),
          _FloatingAIActionButton(
            icon: Icons.save,
            onPressed: _saved,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    titleCtrl.dispose();
    // timerAutoSave.cancel();
    _controller.dispose();
    unawaited(_subscriptionToDoc.cancel());
  }
}

/// Represents the body of the document screen without the app bar
class DocumentBody extends StatelessWidget {
  /// Creates a [DocumentBody] widget
  const DocumentBody({
    required QuillController controller,
    super.key,
  }) : _controller = controller;

  final QuillController _controller;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kWhiteColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(1),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: QuillEditor.basic(
          configurations: QuillEditorConfigurations(
            controller: _controller,
            embedBuilders: kIsWeb
                ? FlutterQuillEmbeds.editorWebBuilders()
                : FlutterQuillEmbeds.editorBuilders(),
          ),
        ),
      ),
    );
  }
}
