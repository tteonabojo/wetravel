import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? _appleUserName;
  String? _googleUserName;

  void changeUserName(String? name, {required bool isApple}) {
    setState(() {
      if (isApple) {
        _appleUserName = name;
      } else {
        _googleUserName = name;
      }
    });
  }

  Future<UserCredential> signInWithProvider({required String provider}) async {
    print('signInWith$provider');
    try {
      if (provider == 'Google') {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        print(googleUser);
        changeUserName(googleUser?.displayName, isApple: false);

        final GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        return await FirebaseAuth.instance.signInWithCredential(credential);
      } else if (provider == 'Apple') {
        final appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          webAuthenticationOptions: WebAuthenticationOptions(
            clientId: 'com.tteonabojo.weetravel.service',
            redirectUri: kIsWeb
                ? Uri.parse('https://wetravel-bebad.web.app/__/auth/handler')
                : Uri.parse(
                    'https://wetravel-bebad.firebaseapp.com/__/auth/handler',
                  ),
          ),
        );

        print(appleCredential.authorizationCode);

        final oAuthProvider = OAuthProvider('apple.com');
        final credential = oAuthProvider.credential(
          idToken: appleCredential.identityToken,
          accessToken: appleCredential.authorizationCode,
        );

        final userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        final user = userCredential.user;
        print('User: ${user}');
        print('Email: ${user?.email}');

        changeUserName(user?.email, isApple: true);

        return userCredential;
      } else {
        throw Exception('Unsupported provider: $provider');
      }
    } catch (e) {
      print('Error during $provider sign in: $e');
      throw Exception('$provider Sign-In failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                signInWithProvider(provider: 'Apple');
              },
              child: Text("Sign in with Apple"),
            ),
          ),
          Text(
            _appleUserName != null ? "$_appleUserName" : "apple 유저 정보:",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                signInWithProvider(provider: 'Google');
              },
              child: Text("Sign in with google"),
            ),
          ),
          Text(
            _googleUserName != null ? "$_googleUserName" : "google 유저 정보:",
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
