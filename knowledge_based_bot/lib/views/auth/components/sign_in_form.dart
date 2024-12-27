// lib/views/auth/components/sign_in_form.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Only for SVG assets
import 'package:rive/rive.dart' as rive; // Aliased Rive import

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



  // SMITriggers for Rive animation
  late rive.SMITrigger check;
  late rive.SMITrigger error;
  late rive.SMITrigger reset;
  late rive.SMITrigger confetti;


  rive.StateMachineController getRiveController(rive.Artboard artboard) {
    // "State Machine 1" depends on your Rive file
    final controller =
        rive.StateMachineController.fromArtboard(artboard, "State Machine 1");
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
                // Email Field
                const Text(
                  "Email",
                  style: TextStyle(color: Colors.black54),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email can't be empty";
                      }
                      // Optionally, add more email validation here
                      return null;
                    },
                    onSaved: (value) => _signInStore.setEmail(value!),
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Image.asset(
                          "assets/icons/email_n.png", // Use Image.asset for PNG
                          width: 24,
                          height: 24,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),

                // Password Field
                const Text(
                  "Password",
                  style: TextStyle(color: Colors.black54),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password cannot be empty";
                      }
                      if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                    onSaved: (value) => _signInStore.setPassword(value!),
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Image.asset(
                          "assets/icons/password_n.png", // Use Image.asset for PNG
                          width: 24,
                          height: 24,
                        ),
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
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),

                // **Sign In Button**
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                  child: ElevatedButton.icon(
                    onPressed: _handleSignIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 107, 99, 246),
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
                      color: Color.fromARGB(255, 223, 208, 211),
                    ),
                    label: const Text(
                      "Sign In",
                      style: TextStyle(
                        color: Color.fromARGB(255, 223, 208, 211),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // **Added "OR" Separator Below**
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.grey[400],
                          thickness: 1,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "OR",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Colors.grey[400],
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                // **End of "OR" Separator**

                // **Sign In with Google Button**
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
                      "assets/icons/google_icon.svg", // Ensure this is a valid SVG file
                      height: 24,
                      width: 24,
                    ),
                    label: const Text(
                      "Sign In with Google",
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // **Rive Animations**

        // Loading Animation
        Observer(
          builder: (_) => _signInStore.isShowLoading

              ? const CustomPositioned(
                  child: RiveCheckAnimation(),

                )
              : const SizedBox(),
        ),

        // Confetti Animation
        Observer(
          builder: (_) => _signInStore.isShowConfetti
              ? const CustomPositioned(
                  child: RiveConfettiAnimation(),
                )
              : const SizedBox(),
        ),
      ],
    );
  }
}

class RiveCheckAnimation extends StatefulWidget {
  const RiveCheckAnimation({super.key});

  @override
  State<RiveCheckAnimation> createState() => _RiveCheckAnimationState();
}

class _RiveCheckAnimationState extends State<RiveCheckAnimation> {
  late rive.SMITrigger check;
  late rive.SMITrigger error;
  late rive.SMITrigger reset;
  late rive.SMITrigger? confetti;

  rive.StateMachineController? _controller;

  void _onInit(rive.Artboard artboard) {
    _controller =
        rive.StateMachineController.fromArtboard(artboard, "State Machine 1");
    if (_controller != null) {
      artboard.addController(_controller!);
      check = _controller!.findSMI("Check") as rive.SMITrigger;
      error = _controller!.findSMI("Error") as rive.SMITrigger;
      reset = _controller!.findSMI("Reset") as rive.SMITrigger;
      confetti = _controller!.findSMI("Confetti") as rive.SMITrigger?;

      // Trigger the check animation
      check.fire();
    }
  }

  @override
  Widget build(BuildContext context) {
    return rive.RiveAnimation.asset(
      "assets/RiveAssets/check.riv",
      onInit: _onInit,
      fit: BoxFit.contain,
    );
  }
}

class RiveConfettiAnimation extends StatefulWidget {
  const RiveConfettiAnimation({super.key});

  @override
  State<RiveConfettiAnimation> createState() => _RiveConfettiAnimationState();
}

class _RiveConfettiAnimationState extends State<RiveConfettiAnimation> {
  late rive.SMITrigger triggerExplosion;
  rive.StateMachineController? _controller;

  void _onInit(rive.Artboard artboard) {
    _controller =
        rive.StateMachineController.fromArtboard(artboard, "State Machine 1");
    if (_controller != null) {
      artboard.addController(_controller!);
      triggerExplosion =
          _controller!.findSMI("Trigger explosion") as rive.SMITrigger;
      // Trigger the confetti animation
      triggerExplosion.fire();
    }
  }

  @override
  Widget build(BuildContext context) {
    return rive.RiveAnimation.asset(
      "assets/RiveAssets/confetti.riv",
      onInit: _onInit,
      fit: BoxFit.contain,
    );
  }
}

class CustomPositioned extends StatelessWidget {
  const CustomPositioned({
    super.key,
    required this.child,
    this.size = 100,
  });
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
