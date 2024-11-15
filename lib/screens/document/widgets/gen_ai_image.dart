import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:shimmer/shimmer.dart';

class _GenAIImageDisplayContainer extends StatelessWidget {
  const _GenAIImageDisplayContainer({
    required this.width,
    required this.height,
    required this.child,
  });

  final double width;
  final double height;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }
}

class _GenAIImageDisplayLoader extends StatelessWidget {
  const _GenAIImageDisplayLoader();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: const _GenAIImageDisplayContainer(
        width: 200,
        height: 200,
        child: null,
      ),
    );
  }
}

class _ShowGenAIImage extends StatelessWidget {
  const _ShowGenAIImage({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      httpHeaders: const <String, String>{
        'mode': 'no-cors',
      },
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (BuildContext context, String url) {
        return const _GenAIImageDisplayLoader();
      },
      imageBuilder: (_, ImageProvider imageProvider) {
        return _GenAIImageDisplayContainer(
          width: 200,
          height: 200,
          child: Image(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        );
      },
      errorWidget: (BuildContext context, String url, dynamic error) {
        return const _GenAIImageDisplayContainer(
          width: 200,
          height: 200,
          child: Center(
            child: Icon(
              Icons.error,
              color: Colors.red,
            ),
          ),
        );
      },
    );
  }
}

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
    print(result);
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
              child: _GenAIImageDisplayLoader(),
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
                          child: _ShowGenAIImage(
                            url: e,
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
