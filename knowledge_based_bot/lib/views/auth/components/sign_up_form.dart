// lib/views/auth/components/sign_up_form.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rive/rive.dart' as rive;
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../store/sign_up_store.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SignUpStore _signUpStore = SignUpStore();
  bool _obscureText = true;

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  late rive.SMITrigger check;
  late rive.SMITrigger error;
  late rive.SMITrigger reset;
  late rive.SMITrigger confetti;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  rive.StateMachineController getRiveController(rive.Artboard artboard) {
    rive.StateMachineController? controller =
        rive.StateMachineController.fromArtboard(artboard, "State Machine 1");
    if (controller != null) {
      artboard.addController(controller);
      return controller;
    } else {
      throw Exception("Couldn't find a State Machine Controller");
    }
  }

  void _handleSignUp() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _signUpStore.signUp(context);
    } else {
      // Optionally, handle form validation errors
      // For example, trigger error animation
      error.fire();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Username",
                    style: TextStyle(color: Colors.black54),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Username can't be empty";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _signUpStore.setUsername(value!);
                      },
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Image.asset(
                            "assets/icons/user_n.png",
                            width: 24,
                            height: 24,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
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
                        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                        if (!emailRegex.hasMatch(value)) {
                          return "Email is invalid";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _signUpStore.setEmail(value!);
                      },
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Image.asset(
                            "assets/icons/email_n.png",
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
                  const Text(
                    "Password",
                    style: TextStyle(color: Colors.black54),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                    child: TextFormField(
                      controller: _passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password can't be empty";
                        }
                        if (value.length < 6) {
                          return "Password must be at least 6 characters";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _signUpStore.setPassword(value!);
                      },
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Image.asset(
                            "assets/icons/password_n.png",
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
                  const Text(
                    "Confirm Password",
                    style: TextStyle(color: Colors.black54),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                    child: TextFormField(
                      controller: _confirmPasswordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please confirm your password";
                        }
                        if (value != _passwordController.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _signUpStore.setConfirmPassword(value!);
                      },
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Image.asset(
                            "assets/icons/password_n.png",
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
                  Observer(
                    builder: (_) {
                      if (_signUpStore.errorMessage.isNotEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Text(
                            _signUpStore.errorMessage,
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 24),
                    child: ElevatedButton.icon(
                      onPressed: _handleSignUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 107, 99, 246),
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
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
          ),
        ),
        Observer(
          builder: (_) {
            if (_signUpStore.isShowError) {
              return CustomPositioned(
                child: rive.RiveAnimation.asset(
                  "assets/RiveAssets/error.riv",
                  onInit: (artboard) {
                    rive.StateMachineController controller =
                        getRiveController(artboard);
                    error = controller.findSMI("Error") as rive.SMITrigger;
                    reset = controller.findSMI("Reset") as rive.SMITrigger;
                    error.fire();
                  },
                  fit: BoxFit.contain,
                ),
              );
            }
            return const SizedBox();
          },
        ),
        Observer(
          builder: (_) => _signUpStore.isShowSuccess
              ? CustomPositioned(
                  child: rive.RiveAnimation.asset(
                    "assets/RiveAssets/check.riv",
                    onInit: (artboard) {
                      rive.StateMachineController controller =
                          getRiveController(artboard);
                      check = controller.findSMI("Check") as rive.SMITrigger;
                      check.fire();
                    },
                    fit: BoxFit.contain,
                  ),
                )
              : const SizedBox(),
        ),
        Observer(
          builder: (_) => _signUpStore.isShowConfetti
              ? CustomPositioned(
                  child: Transform.scale(
                    scale: 6,
                    child: rive.RiveAnimation.asset(
                      "assets/RiveAssets/confetti.riv",
                      onInit: (artboard) {
                        rive.StateMachineController controller =
                            getRiveController(artboard);
                        confetti = controller.findSMI("Trigger explosion")
                            as rive.SMITrigger;
                        confetti.fire();
                      },
                      fit: BoxFit.contain,
                    ),
                  ),
                )
              : const SizedBox(),
        ),
        Observer(
          builder: (_) => _signUpStore.isShowLoading
              ? CustomPositioned(
                  child: rive.RiveAnimation.asset(
                    "assets/RiveAssets/loading.riv",
                    onInit: (artboard) {
                      // Initialize loading animation if you have one
                      // Example:
                      // rive.StateMachineController controller =
                      //     getRiveController(artboard);
                      // loading = controller.findSMI("Loading") as rive.SMITrigger;
                      // loading.fire();
                    },
                    fit: BoxFit.contain,
                  ),
                )
              : const SizedBox(),
        ),
      ],
    );
  }
}

class CustomPositioned extends StatelessWidget {
  const CustomPositioned({
    Key? key,
    required this.child,
    this.size = 100,
  }) : super(key: key);

  final Widget child;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Column(
        children: [
          const Spacer(),
          SizedBox(
            height: size,
            width: size,
            child: child,
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
