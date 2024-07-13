import 'package:docs_ai/utils/app_text.dart';
import 'package:docs_ai/viewModels/ai_viewmodel.dart';
import 'package:docs_ai/widgets/custom_btn.dart';
import 'package:docs_ai/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

/// Contains the visual aspect of the AI image generation
class GenAiImage extends ConsumerStatefulWidget {
  /// Creates [GenAiImage] widget
  const GenAiImage({
    required this.controller,
    super.key,
  });

  /// Contains the controller of the Quill editor
  final QuillController controller;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GenAiImageState();
}

class _GenAiImageState extends ConsumerState<GenAiImage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  List<String> _urlImage = <String>[];
  final TextEditingController _promptController = TextEditingController();

  Future<void> _generateImage() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    final List<String> result = await AIViewModel().genAiImage(
      ref: ref,
      prompt: _promptController.text,
    );
    setState(() {
      _isLoading = false;
      if (result.isNotEmpty) {
        _urlImage = result;
      }
    });
  }

  void _addToDocument() {
    widget.controller.document.insert(
      widget.controller.document.toDelta().length - 1,
      Embeddable('image', _urlImage[0]),
    );
    _promptController.clear();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CustomTextFormField(
            controller: _promptController,
            maxLines: 5,
            hintText: 'Prompt',
            validators: <FieldValidator<dynamic>>[
              RequiredValidator(
                errorText: 'Your prompt is required',
              ),
            ],
          ),
          const Gap(10),
          CustomBtn(
            label: AppText.generate,
            onPressed: _generateImage,
          ),
          const Gap(20),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          Visibility(
            visible: _urlImage.isNotEmpty && !_isLoading,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppText.result,
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(4),
                Row(
                  children: _urlImage
                      .map<Widget>(
                        (String e) => Expanded(
                          child: Image.network(
                            e,
                            height: 100,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      )
                      .toList(),
                ),
                const Gap(8),
                CustomBtn(
                  label: AppText.addToDocument,
                  onPressed: _addToDocument,
                ),
                const Gap(8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
