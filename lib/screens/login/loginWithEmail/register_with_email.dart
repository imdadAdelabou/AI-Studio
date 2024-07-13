import 'package:docs_ai/utils/app_text.dart';
import 'package:docs_ai/utils/colors.dart';
import 'package:docs_ai/utils/constant.dart';
import 'package:docs_ai/viewModels/login_viewmodel.dart';
import 'package:docs_ai/widgets/custom_btn.dart';
import 'package:docs_ai/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:routemaster/routemaster.dart';

/// Contains the visual aspect of the login with email
class RegisterWithEmail extends ConsumerStatefulWidget {
  /// Creates a [RegisterWithEmail] widget
  const RegisterWithEmail({
    required this.width,
    super.key,
  });

  ///  The width of the widget
  final double width;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RegisterWithEmailState();
}

class _RegisterWithEmailState extends ConsumerState<RegisterWithEmail> {
  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  bool isLoading = false;

  Future<void> _handleOnPressed() async {
    final Routemaster navigator = Routemaster.of(context);
    if (_key.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      // Do something
      final bool result =
          await const LoginViewModel().registerWithEmailAndPassword(
        ref,
        context,
        email: _emailController.text,
        name: _usernameController.text,
        password: _passwordController.text,
      );
      setState(() {
        isLoading = false;
      });
      if (result) {
        navigator.replace('/upload-picture');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Form(
        key: _key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              AppText.register,
              style: GoogleFonts.lato(
                fontWeight: FontWeight.w900,
                fontSize: 24,
              ),
            ),
            const Gap(20),
            CustomTextFormField(
              controller: _usernameController,
              hintText: 'johndoe',
              validators: <FieldValidator<dynamic>>[
                RequiredValidator(errorText: 'This field is required'),
              ],
              keyboardType: TextInputType.text,
            ),
            const Gap(15),
            CustomTextFormField(
              controller: _emailController,
              hintText: 'johndoe@gmail.com',
              validators: <FieldValidator<dynamic>>[
                RequiredValidator(errorText: 'This field is required'),
                EmailValidator(errorText: 'Enter a valid email address'),
              ],
              keyboardType: TextInputType.emailAddress,
            ),
            const Gap(15),
            CustomTextFormField(
              controller: _passwordController,
              hintText: '********',
              validators: <FieldValidator<dynamic>>[
                RequiredValidator(errorText: 'This field is required'),
                MinLengthValidator(
                  8,
                  errorText: 'Password must be at least 8 characters long',
                ),
                PatternValidator(
                  r'(?=.*?[#?!@$%^&*-])',
                  errorText:
                      'passwords must have at least one special character',
                ),
              ],
              keyboardType: TextInputType.text,
              type: TextFormFieldType.password,
            ),
            const Gap(30),
            CustomBtn(
              width: widget.width,
              label: AppText.signUp,
              onPressed: _handleOnPressed,
              isLoading: isLoading,
            ),
            const Gap(20),
            Center(
              child: Text(
                AppText.or,
                style: GoogleFonts.lato(
                  color: kGreyColorPure,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Gap(20),
          ],
        ),
      ),
    );
  }
}
