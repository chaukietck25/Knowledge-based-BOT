// lib/views/auth/components/custom_sign_in.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../store/sign_in_store.dart';
import 'sign_in_form.dart';
import 'sign_up_form.dart';

class CustomSignInDialog extends StatefulWidget {
  final ValueChanged onClosed;

  const CustomSignInDialog({super.key, required this.onClosed});

  @override
  _CustomSignInDialogState createState() => _CustomSignInDialogState();
}

class _CustomSignInDialogState extends State<CustomSignInDialog> {
  int _selectedIndex = 0;
  // Tạo instance Store
  final SignInStore _signInStore = SignInStore();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 697,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: const BorderRadius.all(Radius.circular(40)),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                children: [
                  // Tabs
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 0;
                          });
                        },
                        child: const Text(
                          "Đăng nhập",
                          style: TextStyle(fontSize: 34, fontFamily: "Poppins"),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 1;
                          });
                        },
                        child: const Text(
                          'Đăng ký',
                          style: TextStyle(fontSize: 34, fontFamily: "Poppins"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // SignInForm / SignUpForm
                  Expanded(
                    child: IndexedStack(
                      index: _selectedIndex,
                      children: const [
                        SignInForm(),
                        SignUpForm(),
                      ],
                    ),
                  ),

                  

                  // Bạn có thể giữ hoặc xóa đoạn "Hoặc" bên dưới nếu muốn
                 
                  // --- Google sign-in code has been removed here ---
                ],
              ),

              // Nút close
              Positioned(
                left: 0,
                right: 0,
                bottom: -48,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    widget.onClosed(true);
                  },
                  child: const CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.close, color: Colors.black),
                  ),
                ),
              ),

              // Nếu muốn show loading / confetti ở đây
              Observer(
                builder: (_) {
                  if (_signInStore.isShowLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
