// lib/views/auth/onboarding_screen.dart
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;

import 'components/animated_btn.dart';
import 'components/custom_sign_in.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool isSignInDialogShown = false;
  late rive.RiveAnimationController _btnAnimationController;

  @override
  void initState() {
    _btnAnimationController = rive.OneShotAnimation("active", autoplay: false);
    super.initState();
  }

  // Hàm hiển thị CustomSignInDialog
  void customSigninDialog(BuildContext context, {required ValueChanged onClosed}) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Sign In",
      barrierDismissible: true,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, _, __) {
        return CustomSignInDialog(onClosed: onClosed);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Positioned(
            width: MediaQuery.of(context).size.width * 1.7,
            bottom: 200,
            left: 100,
            child: Image.asset('assets/Backgrounds/Spline.png'),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 10),
            ),
          ),
          const rive.RiveAnimation.asset('assets/RiveAssets/shapes.riv'),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 10),
              child: const SizedBox(),
            ),
          ),

          // Nội dung Onboarding
          AnimatedPositioned(
            duration: const Duration(milliseconds: 240),
            top: isSignInDialogShown ? -50 : 0,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    const SizedBox(
                      width: 260,
                      child: Column(
                        children: [
                          Text(
                            "ChatBOT",
                            style: TextStyle(
                              fontSize: 60,
                              fontFamily: "Poppins",
                              height: 1.2,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text("Công cụ hỗ trợ tư vấn và giải đáp thắc mắc của bạn"),
                        ],
                      ),
                    ),
                    const Spacer(flex: 2),
                    AnimatedBtn(
                      btnAnimationController: _btnAnimationController,
                      press: () {
                        // Nhấn button => bật animation, sau 0.8s thì mở dialog
                        _btnAnimationController.isActive = true;
                        Future.delayed(const Duration(milliseconds: 800), () {
                          setState(() {
                            isSignInDialogShown = true;
                          });
                          customSigninDialog(context, onClosed: (_) {
                            setState(() {
                              isSignInDialogShown = false;
                            });
                          });
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                  
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.0),
                      child: Text(
                        "HCMUS - nhóm",
                        style: TextStyle(),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
