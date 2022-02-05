import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'provider_options.dart';

class ProviderService {
  final ProviderOptions options;
  final googleSignIn = GoogleSignIn();
  final facebookSignIn = FacebookAuth.instance;

  ProviderService(this.options);

  Future<GoogleSignInAuthentication?> googleAuth() async {
    final googleUser = await googleSignIn.signIn();
    return await googleUser?.authentication;
  }

  Future<FacebookAuthCredential?> facebookAuth() async {
    final result = await facebookSignIn.login();
    if (result.accessToken == null) return null;

    final facebookAuthCredential =
        FacebookAuthProvider.credential(result.accessToken!.token)
            as FacebookAuthCredential;
    return facebookAuthCredential;
  }

  Future<AuthorizationCredentialAppleID> appleAuth() async {
    return await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      webAuthenticationOptions: WebAuthenticationOptions(
        clientId: options.appleClientId,
        redirectUri: options.appleRedirectUri,
      ),
    );
  }
}
