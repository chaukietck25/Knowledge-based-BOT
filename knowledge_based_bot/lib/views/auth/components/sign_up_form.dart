// lib/Views/auth/components/sign_up_form.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rive/rive.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../store/sign_up_store.dart';

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

  late SMITrigger check;
  late SMITrigger error;
  late SMITrigger reset;

  late SMITrigger confetti;

  StateMachineController getRiveController(Artboard artboard) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, "State Machine 1");
    artboard.addController(controller!);
    return controller;
  }

  Future<void> signUp(BuildContext context) async {
    _signUpStore.setShowLoading(true);
    _signUpStore.setShowConfetti(true);

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // In ra URL và payload để xác nhận
      print('POST đến: https://api.dev.jarvis.cx/api/v1/auth/sign-up');
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
          'username': _signUpStore.username!, // Thêm username vào payload
        }),
      );

      if (response.statusCode == 200) {
        // Hiển thị thành công
        check.fire();
        Future.delayed(const Duration(seconds: 2), () {
          _signUpStore.setShowLoading(false);
          confetti.fire();
        });
      } else {
        // In ra lỗi từ máy chủ
        print('Lỗi ${response.statusCode}: ${response.body}');
        // Hiển thị lỗi
        error.fire();
        Future.delayed(const Duration(seconds: 2), () {
          _signUpStore.setShowLoading(false);
        });
      }
    } else {
      error.fire();
      Future.delayed(const Duration(seconds: 2), () {
        _signUpStore.setShowLoading(false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Form(
            key: _formKey,
            child: Column(
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
                      if (value!.isEmpty) {
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
                    )),
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
                      if (value!.isEmpty) {
                        return "Email không được để trống";
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
                    )),
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
                      if (value!.isEmpty) {
                        return "Mật khẩu không được để trống";
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
                    )),
                  ),
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
                                  bottomLeft: Radius.circular(25)))),
                      icon: const Icon(
                        CupertinoIcons.arrow_right,
                        color: Color(0xFFFE0037),
                      ),
                      label: const Text("Đăng ký")),
                ),
                const SizedBox(
                  height: 50,
                )
              ],
            )),
        Observer(
          builder: (_) => _signUpStore.isShowLoading
              ? CustomPositioned(
                  child: RiveAnimation.asset(
                  "assets/RiveAssets/check.riv",
                  onInit: (artboard) {
                    StateMachineController controller =
                        getRiveController(artboard);
                    check = controller.findSMI("Check") as SMITrigger;
                    error = controller.findSMI("Error") as SMITrigger;
                    reset = controller.findSMI("Reset") as SMITrigger;
                  },
                ))
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
                    },
                  ),
                ))
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