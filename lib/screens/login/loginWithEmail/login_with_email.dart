import 'package:docs_ai/screens/login/loginWithEmail/register_with_email.dart';
import 'package:docs_ai/utils/app_text.dart';
import 'package:docs_ai/utils/colors.dart';
import 'package:docs_ai/utils/constant.dart';
import 'package:docs_ai/viewModels/login_viewmodel.dart';
import 'package:docs_ai/widgets/custom_btn.dart';
import 'package:docs_ai/widgets/custom_text_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:routemaster/routemaster.dart';

/// Contains the visual aspect of the login with email
class LoginWithEmail extends ConsumerStatefulWidget {
  /// Creates a [LoginWithEmail] widget
  const LoginWithEmail({
    required this.width,
    required this.controller,
    required this.animation,
    super.key,
  });

  /// The width of the widget
  final double width;

  /// The animation controller
  final AnimationController controller;

  /// The animation
  final Animation<double> animation;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginWithEmailState();
}

class _LoginWithEmailState extends ConsumerState<LoginWithEmail> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Stack(
        children: <Widget>[
          SlideTransition(
            position:
                Tween<Offset>(begin: Offset.zero, end: const Offset(-1, 0))
                    .animate(widget.controller),
            child: FadeTransition(
              opacity:
                  Tween<double>(begin: 1, end: 0).animate(widget.controller),
              child: Form(
                key: _key,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      AppText.login,
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.w900,
                        fontSize: 24,
                      ),
                    ),
                    const Gap(20),
                    CustomTextFormField(
                      hintText: 'johndoe@gmail.com',
                      validators: <FieldValidator<dynamic>>[
                        RequiredValidator(errorText: 'This field is required'),
                        EmailValidator(
                          errorText: 'Enter a valid email address',
                        ),
                      ],
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const Gap(15),
                    CustomTextFormField(
                      hintText: '********',
                      validators: <FieldValidator<dynamic>>[
                        RequiredValidator(errorText: 'This field is required'),
                      ],
                      controller: _passwordController,
                      keyboardType: TextInputType.text,
                      type: TextFormFieldType.password,
                    ),
                    const Gap(30),
                    CustomBtn(
                      width: widget.width,
                      label: AppText.signIn,
                      isLoading: _isLoading,
                      onPressed: () async {
                        final Routemaster navigator = Routemaster.of(context);
                        if (_key.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });
                          final bool result = await const LoginViewModel()
                              .loginWithEmailAndPassword(
                            ref,
                            context,
                            email: _emailController.text,
                            password: _passwordController.text,
                          );
                          setState(() {
                            _isLoading = false;
                          });

                          if (result) {
                            navigator.replace('/');
                          }
                        }
                      },
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
            ),
          ),
          SlideTransition(
            position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                .animate(widget.controller),
            child: FadeTransition(
              opacity: widget.animation,
              child: RegisterWithEmail(
                width: widget.width,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
