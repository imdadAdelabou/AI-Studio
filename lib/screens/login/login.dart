import 'dart:async';

import 'package:docs_ai/screens/login/loginWithEmail/login_with_email.dart';
import 'package:docs_ai/screens/login/login_large_view.dart';
import 'package:docs_ai/screens/login/login_mobile_view.dart';
import 'package:docs_ai/utils/app_text.dart';
import 'package:docs_ai/utils/colors.dart';
import 'package:docs_ai/viewModels/login_viewmodel.dart';
import 'package:docs_ai/widgets/signin_with_google_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

//ProviderRef is used to communicate with other provider
//WidgetRef is used to communicate with widget
//ref.watch when you are inside the build method
//ref.read when you are outside the build method
//routemaster to manage rooting on web

/// Contains the visual aspect of the login page
class Login extends ConsumerStatefulWidget {
  /// Creates a [Login] widget
  const Login({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isRegister = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  void _toggleScreen() {
    if (_controller.isDismissed) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() {
      _isRegister = !_isRegister;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > 480) {
            return Row(
              children: <Widget>[
                const Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: kBlueColor,
                    ),
                    child: LoginLargeView(),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      LoginWithEmail(
                        controller: _controller,
                        animation: _animation,
                        width: MediaQuery.sizeOf(context).width * .2 + 30,
                      ),
                      SignInWithGoogleBtn(
                        key: const Key('sign-in-with-google-btn'),
                        onPressed: () => unawaited(
                          const LoginViewModel().signinWithGoogle(ref, context),
                        ),
                      ),
                      const Gap(30),
                      AuthTextButton(
                        isRegister: _isRegister,
                        onPressed: _toggleScreen,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return const LoginMobileView();
        },
      ),
    );
  }
}

/// Contains the text button to display at the bottom of the login page
class AuthTextButton extends StatelessWidget {
  /// Creates a [AuthTextButton] widget
  const AuthTextButton({
    required this.isRegister,
    required this.onPressed,
    super.key,
  });

  /// Holds a value to know if the user is registering
  final bool isRegister;

  /// The function to execute when the button is pressed
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        !isRegister ? AppText.dontHaveAnAccount : AppText.haveAnAccount,
        style: GoogleFonts.lato(
          color: kGreyColorPure,
        ),
      ),
    );
  }
}
