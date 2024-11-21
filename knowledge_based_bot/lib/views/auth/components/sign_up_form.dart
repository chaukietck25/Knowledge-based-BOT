// lib/Views/auth/components/sign_up_form.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rive/rive.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../store/sign_up_store.dart';
// import '../../home_screen.dart'; // Import HomePage
import '../../auth/onboarding_screen.dart'; // Import the OnboardingScreen;

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    super.key,
  });

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SignUpStore _signUpStore = SignUpStore();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  late SMITrigger check;
  late SMITrigger error;
  late SMITrigger reset;

  late SMITrigger confetti;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  StateMachineController getRiveController(Artboard artboard) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, "State Machine 1");
    if (controller != null) {
      artboard.addController(controller);
      return controller;
    } else {
      throw Exception("Couldn't find a State Machine Controller");
    }
  }

  Future<void> signUp(BuildContext context) async {
    _signUpStore.setShowError(false);
    _signUpStore.setErrorMessage('');
    print("Starting sign up process...");

    try {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        print("Form validated successfully.");
        print('POST to: https://api.dev.jarvis.cx/api/v1/auth/sign-up');
        print('Payload: ${jsonEncode(<String, String>{
              'email': _signUpStore.email!,
              'password': _signUpStore.password!,
              'username': _signUpStore.username!,
            })}');

        final response = await http.post(
          Uri.parse('https://api.dev.jarvis.cx/api/v1/auth/sign-up'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'email': _signUpStore.email!,
            'password': _signUpStore.password!,
            'username': _signUpStore.username!,
          }),
        );

        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          print("Sign up successful with status: ${response.statusCode}");
          _signUpStore.setShowSuccess(true);

          // Show the success toast message here
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sign Up Success'),
              duration: Duration(seconds: 2),
            ),
          );
          
          
          // Navigate to HomePage after showing confetti
          await Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const OnboardingScreen()),
            );
          });
        } else {
          final responseBody = jsonDecode(response.body);
          String errorMsg = 'Sign up failed.';
          if (responseBody['details'] != null &&
              responseBody['details'].isNotEmpty) {
            errorMsg = responseBody['details'][0]['issue'];
          } else if (responseBody['message'] != null) {
            errorMsg = responseBody['message'];
          }

          print('Error ${response.statusCode}: $errorMsg');
          _signUpStore.setShowError(true);
          _signUpStore.setErrorMessage(errorMsg);
          error.fire();

          await Future.delayed(const Duration(seconds: 2));
          reset.fire();
        }
      } else {
        print("Form validation failed.");
        _signUpStore.setShowError(true);
        error.fire();

        await Future.delayed(const Duration(seconds: 2));
        reset.fire();
      }
    } catch (e) {
      print("An error occurred during sign up: $e");
      _signUpStore.setShowError(true);
      error.fire();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Tên đăng nhập",
                    style: TextStyle(color: Colors.black54),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Tên đăng nhập không được để trống";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _signUpStore.setUsername(value!);
                      },
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: SvgPicture.asset("assets/icons/user.svg"),
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
                          return "Email không được để trống";
                        }
                        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                        if (!emailRegex.hasMatch(value)) {
                          return "Định dạng email không hợp lệ";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _signUpStore.setEmail(value!);
                      },
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
                      controller: _passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Mật khẩu không được để trống";
                        }
                        if (value.length < 6) {
                          return "Mật khẩu phải ít nhất 6 ký tự";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _signUpStore.setPassword(value!);
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: SvgPicture.asset("assets/icons/password.svg"),
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    "Xác nhận mật khẩu",
                    style: TextStyle(color: Colors.black54),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                    child: TextFormField(
                      controller: _confirmPasswordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Vui lòng xác nhận mật khẩu";
                        }
                        if (value != _passwordController.text) {
                          return "Mật khẩu không khớp";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _signUpStore.setConfirmPassword(value!);
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: SvgPicture.asset("assets/icons/password.svg"),
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
                      onPressed: () {
                        signUp(context);
                      },
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
                      label: const Text("Đăng ký"),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
          ),
          Observer(
            builder: (_) {
              if (_signUpStore.isShowError) {
                return CustomPositioned(
                  child: RiveAnimation.asset(
                    "assets/RiveAssets/error.riv",
                    onInit: (artboard) {
                      StateMachineController controller =
                          getRiveController(artboard);
                      error = controller.findSMI("Error") as SMITrigger;
                      reset = controller.findSMI("Reset") as SMITrigger;
                      error.fire();
                    },
                  ),
                );
              }
              return const SizedBox();
            },
          ),
          Observer(
            builder: (_) => _signUpStore.isShowSuccess
                ? CustomPositioned(
                    child: RiveAnimation.asset(
                      "assets/RiveAssets/check.riv",
                      onInit: (artboard) {
                        StateMachineController controller =
                            getRiveController(artboard);
                        check = controller.findSMI("Check") as SMITrigger;
                        check.fire();
                      },
                    ),
                  )
                : const SizedBox(),
          ),
          Observer(
            builder: (_) => _signUpStore.isShowConfetti
                ? CustomPositioned(
                    child: Transform.scale(
                      scale: 6,
                      child: RiveAnimation.asset(
                        "assets/RiveAssets/confetti.riv",
                        onInit: (artboard) {
                          StateMachineController controller =
                              getRiveController(artboard);
                          confetti = controller.findSMI("Trigger explosion")
                              as SMITrigger;
                          confetti.fire();
                        },
                      ),
                    ),
                  )
                : const SizedBox(),
          ),
        ],
      ),
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
