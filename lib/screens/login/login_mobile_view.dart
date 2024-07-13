import 'dart:async';
import 'package:docs_ai/screens/login/login.dart';
import 'package:docs_ai/screens/login/loginWithEmail/login_with_email.dart';
import 'package:docs_ai/screens/login/login_large_view.dart';
import 'package:docs_ai/utils/colors.dart';
import 'package:docs_ai/viewModels/login_viewmodel.dart';
import 'package:docs_ai/widgets/signin_with_google_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

/// Display a screen with a login with google button
class LoginViewWithBtn extends ConsumerStatefulWidget {
  /// Creates a [LoginViewWithBtn] widget
  const LoginViewWithBtn({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LoginViewWithBtnState();
}

class _LoginViewWithBtnState extends ConsumerState<LoginViewWithBtn>
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
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Gap(40),
                LoginWithEmail(
                  controller: _controller,
                  animation: _animation,
                  width: double.infinity,
                ),
                SignInWithGoogleBtn(
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
        ),
      ),
    );
  }
}

///  Contains the login view to display on a Mobile device
class LoginMobileView extends ConsumerWidget {
  /// Creates a [LoginMobileView] widget
  const LoginMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const ColoredBox(
      color: kBlueColor,
      child: OnBoardingForMobile(),
    );
  }
}
