// lib/Views/auth/components/sign_in_form.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rive/rive.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../home_screen.dart'; // Import HomePage
import '../../../provider_state.dart';

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

  Future<void> signIn(BuildContext context) async {
    _signInStore.setShowLoading(true);

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Log thông tin trước khi gửi yêu cầu (Consider removing in production)
      print('POST đến: https://api.dev.jarvis.cx/api/v1/auth/sign-in');
      print('Payload: ${jsonEncode(<String, String>{
            'email': _signInStore.email!,
            'password': _signInStore.password!,
          })}');

      try {
        final response = await http.post(
          Uri.parse('https://api.dev.jarvis.cx/api/v1/auth/sign-in'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'email': _signInStore.email!,
            'password': _signInStore.password!,
          }),
        );

        // Log thông tin phản hồi từ máy chủ (Consider removing in production)
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          final responseData = jsonDecode(response.body);
          // Lưu primary tokens vào SignInStore và ProviderState
          _signInStore.setAccessToken(responseData['token']['accessToken']);
          _signInStore.setRefreshToken(responseData['token']['refreshToken']);
          ProviderState providerState = ProviderState();
          providerState.setAccessToken(_signInStore.accessToken!);
          providerState.setRefreshToken(_signInStore.refreshToken!);
          String primaryAccessToken = responseData['token']['refreshToken'];

          print('POST đến: https://knowledge-api.dev.jarvis.cx/kb-core/v1/auth/external-sign-in');
          print('Payload: ${jsonEncode(<String, String>{
                'token': primaryAccessToken,
              })}');

          final externalResponse = await http.post(
            Uri.parse('https://knowledge-api.dev.jarvis.cx/kb-core/v1/auth/external-sign-in'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              // 'Authorization': 'Bearer $primaryAccessToken', // Uncomment if required
            },
            body: jsonEncode(<String, String>{
              'token': primaryAccessToken,
            }),
          );

          // Log phản hồi từ máy chủ phụ (Consider removing in production)
          print('External Response status: ${externalResponse.statusCode}');
          print('External Response body: ${externalResponse.body}');

          if (externalResponse.statusCode == 200 || externalResponse.statusCode == 201) {
            final externalData = jsonDecode(externalResponse.body);
            String externalAccessToken = externalData['token']['accessToken'];
            String externalRefreshToken = externalData['token']['refreshToken'];

            // Store External Tokens
            providerState.setExternalAccessToken(externalAccessToken);
            providerState.setExternalRefreshToken(externalRefreshToken);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Sign In Success'),
                duration: Duration(seconds: 2),
              ),
            );
            // Trigger success animation
            check.fire();
            Future.delayed(const Duration(seconds: 2), () {
              _signInStore.setShowLoading(false);
              // Navigate to HomePage without confetti
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            });
          } else {
            // Log error from external server (Consider removing in production)
            print('Lỗi ${externalResponse.statusCode}: ${externalResponse.body}');
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('External Sign-In Failed: ${externalResponse.body}')),
            );
            // Trigger error animation
            error.fire();
            Future.delayed(const Duration(seconds: 2), () {
              _signInStore.setShowLoading(false);
            });
          }
        } else {
          // Log error from primary server (Consider removing in production)
          print('Lỗi ${response.statusCode}: ${response.body}');
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sign-In Failed: ${response.body}')),
          );
          // Trigger error animation
          error.fire();
          Future.delayed(const Duration(seconds: 2), () {
            _signInStore.setShowLoading(false);
          });
        }
      } catch (e) {
        // Handle network or other errors
        print('Lỗi đăng nhập: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
        // Trigger error animation
        error.fire();
        Future.delayed(const Duration(seconds: 2), () {
          _signInStore.setShowLoading(false);
        });
      }
    } else {
      // Form validation failed
      error.fire();
      Future.delayed(const Duration(seconds: 2), () {
        _signInStore.setShowLoading(false);
      });
    }
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
                      // Add more email validation if necessary
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
                      // Add more password validation if necessary
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
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 24),
                  child: ElevatedButton.icon(
                    onPressed: () => signIn(context),
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
              ],
            ),
          ),
        ),
        Observer(
          builder: (_) => _signInStore.isShowLoading
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
                  ),
                )
              : const SizedBox(),
        ),
        Observer(
          builder: (_) => _signInStore.isShowConfetti
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