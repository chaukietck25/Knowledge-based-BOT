// lib/views/auth/components/sign_in_form.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rive/rive.dart';

import '../../../store/sign_in_store.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SignInStore _signInStore = SignInStore();

  bool _obscureText = true;

  // Các biến SMITrigger cho Rive animation
  late SMITrigger check;
  late SMITrigger error;
  late SMITrigger reset;
  late SMITrigger confetti;

  StateMachineController getRiveController(Artboard artboard) {
    // "State Machine 1" tuỳ file Rive
    final controller =
        StateMachineController.fromArtboard(artboard, "State Machine 1");
    artboard.addController(controller!);
    return controller;
  }

  void _handleSignIn() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _signInStore.signIn(context);
    } else {
      // Trigger error animation
      error.fire();
      Future.delayed(const Duration(seconds: 2), () {
        _signInStore.setShowLoading(false);
      });
    }
  }

  void _handleGoogleSignIn() {
    _signInStore.signInWithGoogle(context);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Email",
                  style: TextStyle(color: Colors.black54),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email không được để trống";
                      }
                      return null;
                    },
                    onSaved: (value) => _signInStore.setEmail(value!),
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: SvgPicture.asset("assets/icons/email.svg"),
                      ),
                    ),
                  ),
                ),

                const Text(
                  "Mật khẩu",
                  style: TextStyle(color: Colors.black54),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Mật khẩu không được để trống";
                      }
                      return null;
                    },
                    onSaved: (value) => _signInStore.setPassword(value!),
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: SvgPicture.asset("assets/icons/password.svg"),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? CupertinoIcons.eye
                              : CupertinoIcons.eye_slash,
                          color: Colors.black54,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                  ),
                ),

                // Nút Đăng nhập (Email/Password)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                  child: ElevatedButton.icon(
                    onPressed: _handleSignIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF77D8E),
                      minimumSize: const Size(double.infinity, 56),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                          bottomLeft: Radius.circular(25),
                        ),
                      ),
                    ),
                    icon: const Icon(
                      CupertinoIcons.arrow_right,
                      color: Color(0xFFFE0037),
                    ),
                    label: const Text("Đăng nhập"),
                  ),
                ),

                // Nút Đăng nhập Google
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: ElevatedButton.icon(
                    onPressed: _handleGoogleSignIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 56),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                          bottomLeft: Radius.circular(25),
                        ),
                      ),
                      side: const BorderSide(color: Colors.grey),
                    ),
                    icon: SvgPicture.asset(
                      "assets/icons/google.png",
                      height: 24,
                    ),
                    label: const Text(
                      "Đăng nhập với Google",
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Nếu đang show loading => hiển thị Rive check animation
        Observer(
          builder: (_) => _signInStore.isShowLoading
              ? CustomPositioned(
                  child: RiveAnimation.asset(
                    "assets/RiveAssets/check.riv",
                    onInit: (artboard) {
                      final controller = getRiveController(artboard);
                      check = controller.findSMI("Check") as SMITrigger;
                      error = controller.findSMI("Error") as SMITrigger;
                      reset = controller.findSMI("Reset") as SMITrigger;
                      confetti = controller.findSMI("Confetti") as SMITrigger;
                    },
                  ),
                )
              : const SizedBox(),
        ),

        // Nếu showConfetti => hiển thị Confetti animation
        Observer(
          builder: (_) => _signInStore.isShowConfetti
              ? CustomPositioned(
                  child: Transform.scale(
                    scale: 6,
                    child: RiveAnimation.asset(
                      "assets/RiveAssets/confetti.riv",
                      onInit: (artboard) {
                        final controller = getRiveController(artboard);
                        final c = controller.findSMI("Trigger explosion");
                        if (c is SMITrigger) {
                          c.fire();
                        }
                      },
                    ),
                  ),
                )
              : const SizedBox(),
        ),
      ],
    );
  }
}

class CustomPositioned extends StatelessWidget {
  const CustomPositioned({super.key, required this.child, this.size = 100});
  final Widget child;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Column(
        children: [
          const Spacer(),
          SizedBox(width: size, height: size, child: child),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
