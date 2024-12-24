// lib/store/sign_in_store.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// Dùng package google_sign_in
import 'package:google_sign_in/google_sign_in.dart';
// MobX
import 'package:mobx/mobx.dart';

// Your app-specific imports:
import '../views/home_screen.dart';
import '../provider_state.dart';

part 'sign_in_store.g.dart';

class SignInStore = SignInStoreBase with _$SignInStore;

abstract class SignInStoreBase with Store {
  // ---------------- OBSERVABLES ----------------
  @observable
  bool isShowLoading = false;

  @observable
  bool isShowConfetti = false;

  @observable
  String? email;

  @observable
  String? password;

  // Token do Jarvis trả về (nullable)
  @observable
  String? accessToken;

  @observable
  String? refreshToken;

  // ---------------- ACTIONS ----------------
  @action
  void setShowLoading(bool value) => isShowLoading = value;

  @action
  void setShowConfetti(bool value) => isShowConfetti = value;

  @action
  void setEmail(String value) => email = value;

  @action
  void setPassword(String value) => password = value;

  @action
  void setAccessToken(String? value) => accessToken = value;

  @action
  void setRefreshToken(String? value) => refreshToken = value;

  // ------------------------------------------------
  // 0) FETCH EXTERNAL TOKEN (Knowledge API)
  // ------------------------------------------------
  @action
  Future<void> fetchExternalToken(BuildContext context) async {
    try {
      if (refreshToken == null) {
        throw Exception("No Jarvis refresh token available. Cannot fetch external token.");
      }

      final externalResponse = await http.post(
        Uri.parse('https://knowledge-api.dev.jarvis.cx/kb-core/v1/auth/external-sign-in'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          "token": refreshToken, // Use the Jarvis refreshToken here
        }),
      );

      if (externalResponse.statusCode == 200 || externalResponse.statusCode == 201) {
        final externalData = jsonDecode(externalResponse.body);

        final externalAccessToken = externalData['token']['accessToken'];
        final externalRefreshToken = externalData['token']['refreshToken'];

        // Do something with these external tokens (e.g. store them)
        print("External Access Token: $externalAccessToken");
        print("External Refresh Token: $externalRefreshToken");

        ProviderState.externalAccessToken = externalAccessToken;
        ProviderState.externalRefreshToken = externalRefreshToken;

      } else {
        throw Exception("External sign-in failed: ${externalResponse.body}");
      }
    } catch (e) {
      debugPrint("Error while fetching external token: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error while fetching external token: $e')),
      );
    }
  }

  // -----------------------------------------
  // 1) Đăng nhập bằng Email/Password (nếu cần)
  // -----------------------------------------
  @action
  Future<void> signIn(BuildContext context) async {
    setShowLoading(true);

    try {
      final response = await http.post(
        Uri.parse('https://api.dev.jarvis.cx/api/v1/auth/sign-in'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'email': email ?? '',
          'password': password ?? '',
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        final jarvisAccessToken = data['token']['accessToken'];
        final jarvisRefreshToken = data['token']['refreshToken'];

        setAccessToken(jarvisAccessToken);
        setRefreshToken(jarvisRefreshToken);
        ProviderState.accessToken = jarvisAccessToken;
        ProviderState.refreshToken = jarvisRefreshToken;

        print("Jarvis Access Token: $jarvisAccessToken");
        print("Jarvis Refresh Token: $jarvisRefreshToken");

        // (A) Immediately fetch external token
        await fetchExternalToken(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign In Success')),
        );

        setShowConfetti(true);
        await Future.delayed(const Duration(seconds: 2));
        setShowLoading(false);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      } else {
        throw Exception('Sign-In Failed: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign In Error: $e')),
      );
      setShowConfetti(false);
      await Future.delayed(const Duration(seconds: 2));
      setShowLoading(false);
    }
  }

  // -----------------------------------------
  // 2) Đăng nhập Google (KHÔNG Firebase Auth)
  // -----------------------------------------
  @action
  Future<void> signInWithGoogle(BuildContext context) async {
    setShowLoading(true);

    try {
      // 1) Tạo GoogleSignIn instance với clientId bạn cung cấp
      final googleSignIn = GoogleSignIn(
        clientId: '599361404647-e74vpq6s2ab8q6r275s12sdhr36enq5l.apps.googleusercontent.com',
        scopes: [
          'email',
          'profile',
          'openid',
          'https://www.googleapis.com/auth/userinfo.email',
          'https://www.googleapis.com/auth/userinfo.profile',
        ],
      );

      // 2) signIn() -> Hiển thị màn hình đăng nhập Google
      final account = await googleSignIn.signIn();
      if (account == null) {
        // Người dùng hủy
        setShowLoading(false);
        return;
      }

      // 3) Lấy GoogleAuth => Lấy idToken
      final googleAuth = await account.authentication;
      final googleIdToken = googleAuth.idToken;
      print('Google ID Token: $googleIdToken');
      if (googleIdToken == null) {
        throw Exception('Không lấy được Google ID Token');
      }

      // 4) Gọi Jarvis endpoint => POST /auth/google-sign-in
      final response = await http.post(
        Uri.parse('https://api.dev.jarvis.cx/api/v1/auth/google-sign-in'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'token': googleIdToken,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        final jarvisAccessToken = data['token']['accessToken'];
        final jarvisRefreshToken = data['token']['refreshToken'];

        setAccessToken(jarvisAccessToken);
        setRefreshToken(jarvisRefreshToken);

        ProviderState.accessToken = jarvisAccessToken;
        ProviderState.refreshToken = jarvisRefreshToken;

        print("Jarvis Access Token: $jarvisAccessToken");
        print("Jarvis Refresh Token: $jarvisRefreshToken");

        // (B) Immediately fetch external token
        await fetchExternalToken(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google Sign In Success: $jarvisAccessToken')),
        );

        // Bắn confetti
        setShowConfetti(true);
        await Future.delayed(const Duration(seconds: 2));
        setShowLoading(false);

        // Chuyển sang Home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      } else {
        throw Exception(
          'Jarvis Google-Sign-In Error ${response.statusCode}: ${response.body}',
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In Error: $e')),
      );
      setShowConfetti(false);
      await Future.delayed(const Duration(seconds: 2));
      setShowLoading(false);
    }
  }
}
