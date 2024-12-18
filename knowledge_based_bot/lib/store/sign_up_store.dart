import 'package:mobx/mobx.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Views/auth/onboarding_screen.dart'; // Import OnboardingScreen
import 'package:flutter/material.dart';

part 'sign_up_store.g.dart';

class SignUpStore = SignUpStoreBase with _$SignUpStore;

abstract class SignUpStoreBase with Store {
  @observable
  bool isShowLoading = false;

  @observable
  bool isShowSuccess = false;

  @observable
  bool isShowError = false;

  @observable
  bool isShowConfetti = false;

  @observable
  String? email;

  @observable
  String? password;

  @observable
  String? confirmPassword;

  @observable
  String? username;

  @observable
  String errorMessage = '';

  @action
  void setShowLoading(bool value) {
    isShowLoading = value;
  }

  @action
  void setShowSuccess(bool value) {
    isShowSuccess = value;
  }

  @action
  void setShowError(bool value) {
    isShowError = value;
  }

  @action
  void setShowConfetti(bool value) {
    isShowConfetti = value;
  }

  @action
  void setEmail(String value) {
    email = value;
  }

  @action
  void setPassword(String value) {
    password = value;
  }

  @action
  void setConfirmPassword(String value) {
    confirmPassword = value;
  }

  @action
  void setUsername(String value) {
    username = value;
  }

  @action
  void setErrorMessage(String message) {
    errorMessage = message;
  }

  // New action to handle sign-up
  @action
  Future<void> signUp(BuildContext context) async {
    setShowLoading(true);
    setShowError(false);
    setErrorMessage('');
    setShowSuccess(false);
    setShowConfetti(false);

    // Log thông tin trước khi gửi yêu cầu (Consider removing in production)
    print('POST đến: https://api.dev.jarvis.cx/api/v1/auth/sign-up');
    print('Payload: ${jsonEncode(<String, String>{
          'email': email!,
          'password': password!,
          'username': username!,
        })}');

    try {
      final response = await http.post(
        Uri.parse('https://api.dev.jarvis.cx/api/v1/auth/sign-up'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email!,
          'password': password!,
          'username': username!,
        }),
      );

      // Log thông tin phản hồi từ máy chủ (Consider removing in production)
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        setShowSuccess(true);

        // Optionally, you can set tokens or other state variables here
        // For example, if the sign-up response includes tokens

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đăng ký thành công'),
            duration: Duration(seconds: 2),
          ),
        );

        // Trigger success animation
        setShowConfetti(true);

        // Navigate to OnboardingScreen after a short delay
        await Future.delayed(const Duration(seconds: 2));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      } else {
        final responseBody = jsonDecode(response.body);
        String errorMsg = 'Đăng ký thất bại.';
        if (responseBody['details'] != null &&
            responseBody['details'].isNotEmpty) {
          errorMsg = responseBody['details'][0]['issue'];
        } else if (responseBody['message'] != null) {
          errorMsg = responseBody['message'];
        }

        print('Error ${response.statusCode}: $errorMsg');
        setShowError(true);
        setErrorMessage(errorMsg);

        // Optionally, handle specific error animations or states here

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng ký thất bại: $errorMsg')),
        );
      }
    } catch (e) {
      // Handle network or other errors
      print('Lỗi đăng ký: $e');
      setShowError(true);
      setErrorMessage('Đã xảy ra lỗi. Vui lòng thử lại.');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setShowLoading(false);
    }
  }
}
