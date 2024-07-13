import 'package:docs_ai/utils/app_text.dart';
import 'package:docs_ai/viewModels/ai_viewmodel.dart';
import 'package:docs_ai/widgets/custom_btn.dart';
import 'package:docs_ai/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

/// A widget that summarize the text
class SummarizeText extends ConsumerStatefulWidget {
  /// Creates a [SummarizeText] widget
  const SummarizeText({
    required this.controller,
    super.key,
  });

  /// Contains the controller of the Quill editor
  final QuillController controller;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SummarizeTextState();
}

class _SummarizeTextState extends ConsumerState<SummarizeText> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _textController = TextEditingController();
  String _summarizeTextResult = '';
  bool _isLoading = false;

  Future<void> _summarizeText() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      setState(() {
        _isLoading = true;
      });
      final String? result = await AIViewModel().summarize(
        ref: ref,
        text: _textController.text,
      );
      setState(() {
        _isLoading = false;
        _summarizeTextResult = result ?? '';
      });
    }
  }

  void _handleAddToDocument() {
    if (_summarizeTextResult.isNotEmpty) {
      final Delta newContent = Delta.fromJson(
        <Map<String, dynamic>>[
          <String, String>{
            'insert': '$_summarizeTextResult\n',
          }
        ],
      );
      final Delta currentContent = widget.controller.document.toDelta();
      final Delta combinedContent = currentContent.concat(newContent);
      widget.controller.setContents(
        combinedContent,
      );
      _textController.clear();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CustomTextFormField(
            controller: _textController,
            validators: <FieldValidator<dynamic>>[
              RequiredValidator(
                errorText: 'This field is required',
              ),
            ],
            minLines: 5,
            maxLines: null,
          ),
          const Gap(20),
          CustomBtn(
            isLoading: _isLoading,
            label: AppText.summarize,
            onPressed: _summarizeText,
          ),
          const Gap(20),
          Text(
            AppText.result,
            style: GoogleFonts.lato(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Visibility(
            visible: _summarizeTextResult.isNotEmpty,
            child: Column(
              children: <Widget>[
                const Gap(4),
                Text(
                  _summarizeTextResult,
                  style: GoogleFonts.lato(
                    fontSize: 16,
                  ),
                ),
                const Gap(8),
                CustomBtn(
                  label: AppText.addToDocument,
                  onPressed: _handleAddToDocument,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
