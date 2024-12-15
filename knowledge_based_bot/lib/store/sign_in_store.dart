import 'package:mobx/mobx.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../provider_state.dart';
import '../views/home_screen.dart';
import 'package:flutter/material.dart';

part 'sign_in_store.g.dart';

class SignInStore = SignInStoreBase with _$SignInStore;

abstract class SignInStoreBase with Store {
  @observable
  bool isShowLoading = false;

  @observable 
  bool isShowConfetti = false;

  @observable
  String? email;

  @observable
  String? password;

  @observable
  String? accessToken;

  @observable
  String? refreshToken;

  @action
  void setShowLoading(bool value) {
    isShowLoading = value; 
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
  void setAccessToken(String value) {
    accessToken = value;
  }

  @action
  void setRefreshToken(String value) {
    refreshToken = value;
  }

  // New action to handle sign-in
  @action
  Future<void> signIn(BuildContext context) async {
    setShowLoading(true);

    // Assuming you have a FormState passed or managed elsewhere
    // For simplicity, validation is handled in the UI

    // Log thông tin trước khi gửi yêu cầu (Consider removing in production)
    print('POST đến: https://api.dev.jarvis.cx/api/v1/auth/sign-in');
    print('Payload: ${jsonEncode(<String, String>{
          'email': email!,
          'password': password!,
        })}');

    try {
      final response = await http.post(
        Uri.parse('https://api.dev.jarvis.cx/api/v1/auth/sign-in'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email!,
          'password': password!,
        }),
      );

      // Log thông tin phản hồi từ máy chủ (Consider removing in production)
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        // Lưu primary tokens vào SignInStore và ProviderState
        setAccessToken(responseData['token']['accessToken']);
        setRefreshToken(responseData['token']['refreshToken']);
        ProviderState.accessToken = accessToken!;
        ProviderState.refreshToken = refreshToken!;
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
          ProviderState.externalAccessToken=externalAccessToken;
          ProviderState.externalRefreshToken=externalRefreshToken;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sign In Success'),
              duration: Duration(seconds: 2),
            ),
          );
          // Trigger success animation
          setShowConfetti(true);
          Future.delayed(const Duration(seconds: 2), () {
            setShowLoading(false);
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
          setShowConfetti(false);
          Future.delayed(const Duration(seconds: 2), () {
            setShowLoading(false);
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
        setShowConfetti(false);
        Future.delayed(const Duration(seconds: 2), () {
          setShowLoading(false);
        });
      }
    } catch (e) {
      // Handle network or other errors
      print('Lỗi đăng nhập: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      // Trigger error animation
      setShowConfetti(false);
      Future.delayed(const Duration(seconds: 2), () {
        setShowLoading(false);
      });
    }
  }
}
