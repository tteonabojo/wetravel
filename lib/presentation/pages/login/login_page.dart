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

  void changeAppleUserName(String? name) {
    setState(() {
      _appleUserName = name;
    });
  }

  void changeGoogleUserName(String? name) {
    setState(() {
      _googleUserName = name;
    });
  }

  Future<UserCredential> signInWithGoogle() async {
    print('signInWithGoogle');
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    print(googleUser);

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () async {
                print('press');
                final appleCredential =
                    await SignInWithApple.getAppleIDCredential(
                  scopes: [
                    AppleIDAuthorizationScopes.email,
                    AppleIDAuthorizationScopes.fullName,
                  ],
                  webAuthenticationOptions: WebAuthenticationOptions(
                    clientId: 'com.example.wetravel',
                    redirectUri: kIsWeb
                        ? Uri.parse(
                            'https://wetravel-bebad.web.app/__/auth/handler')
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

                try {
                  final userCredential = await FirebaseAuth.instance
                      .signInWithCredential(credential);
                  final user = userCredential.user;
                  print('User: ${user}');
                  print('Email: ${user?.email}');

                  changeAppleUserName(user?.email);
                } catch (e) {
                  print('Error during Firebase sign in: $e');
                }
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
                signInWithGoogle();
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
