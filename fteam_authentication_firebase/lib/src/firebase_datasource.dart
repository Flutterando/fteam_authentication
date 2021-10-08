import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fteam_authentication_core/fteam_authentication_core.dart';
import 'package:fteam_authentication_core/src/domain/models/email_credencials.dart'
    show EmailCredencials;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'providers/provider_service.dart';

class FirebaseDatasource implements AuthDatasource {
  final FirebaseAuth firebaseAuth;
  final ProviderService provider;

  FirebaseDatasource({required this.provider, required this.firebaseAuth});

  @override
  Future<LoggedUser?> getLoggedUser() async {
    final user = firebaseAuth.currentUser;

    if (user == null) {
      return null;
    }

    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) return null;

    return _userFactory(
      currentUser,
      _getProviderLogin(user.providerData),
    );
  }

  List<ProviderLogin> _getProviderLogin(List<UserInfo> userInfos) {
    return userInfos.map((userInfo) {
      if (userInfo.providerId == 'google.com') {
        ProviderLogin.google.name = userInfo.displayName ?? '';
        ProviderLogin.google.email = userInfo.email ?? '';
        return ProviderLogin.google;
      } else if (userInfo.providerId == 'facebook.com') {
        ProviderLogin.facebook.name = userInfo.displayName ?? '';
        ProviderLogin.facebook.email = userInfo.email ?? '';
        return ProviderLogin.facebook;
      } else if (userInfo.providerId == 'apple.com') {
        ProviderLogin.appleId.name = userInfo.displayName ?? '';
        ProviderLogin.appleId.email = userInfo.email ?? '';
        return ProviderLogin.appleId;
      } else {
        ProviderLogin.emailSignin.name = userInfo.displayName ?? '';
        ProviderLogin.emailSignin.email = userInfo.email ?? '';
        return ProviderLogin.emailSignin;
      }
    }).toList();
  }

  @override
  Future<LoggedUser?> loginWithAppleId() async {
    AuthorizationCredentialAppleID credential;
    try {
      credential = await provider.appleAuth();
    } catch (e, st) {
      throw CredentialsError(
          message: 'firebaseDatasource.credentialError',
          mainException: e,
          stacktrace: st);
    }
    var oAuthProvider = OAuthProvider('apple.com');
    var cred = oAuthProvider.credential(
      idToken: credential.identityToken,
      accessToken: credential.authorizationCode,
    );

    var result = await firebaseAuth.signInWithCredential(cred);
    final user = result.user;
    if (user == null) return null;

    if (credential.email != null && credential.givenName != null) {
      await user.updateEmail(credential.email!);
      await user.updateDisplayName(
          '${credential.givenName} ${credential.familyName}');

      return LoggedUser(
        name: '${credential.givenName} ${credential.familyName}',
        uid: user.uid,
        email: user.email ?? '',
        providers: [ProviderLogin.appleId],
        token: await user.getIdToken(true),
      );
    }

    return _userFactory(user, _getProviderLogin(user.providerData));
  }

  @override
  Future<LoggedUser?> loginWithFacebook() async {
    FacebookAuthCredential? credential;
    try {
      credential = await provider.facebookAuth();
    } catch (e, st) {
      throw CredentialsError(
          message: 'firebaseDatasource.credentialError',
          mainException: e,
          stacktrace: st);
    }
    if (credential == null) throw CredentialsError(message: 'Null credential');
    await provider.facebookSignIn.logOut();
    var result = await FirebaseAuth.instance.signInWithCredential(credential);
    final user = result.user;
    if (user == null) return null;
    return _userFactory(user, _getProviderLogin(user.providerData));
  }

  @override
  Future<LoggedUser?> loginWithGoogle() async {
    GoogleSignInAuthentication? signInAuthenticationResult;
    try {
      signInAuthenticationResult = await provider.googleAuth();
    } catch (e, st) {
      throw CredentialsError(
          message: 'firebaseDatasource.credentialError',
          mainException: e,
          stacktrace: st);
    }
    if (signInAuthenticationResult == null) return null;
    final credential = GoogleAuthProvider.credential(
      accessToken: signInAuthenticationResult.accessToken,
      idToken: signInAuthenticationResult.idToken,
    );

    await provider.googleSignIn.signOut();
    var result = await FirebaseAuth.instance.signInWithCredential(credential);
    final user = result.user;
    if (user == null) return null;
    return _userFactory(user, _getProviderLogin(user.providerData));
  }

  Future<LoggedUser> _userFactory(
      User firebaseUser, List<ProviderLogin> providers) async {
    final token = await firebaseUser.getIdToken(true);
    return LoggedUser(
      email: firebaseUser.email ?? '',
      uid: firebaseUser.uid,
      name: firebaseUser.displayName ?? '',
      emailVerified: firebaseUser.emailVerified,
      urlPhoto: firebaseUser.photoURL ?? '',
      token: token,
      providers: providers,
    );
  }

  @override
  Future<int> logout() async {
    await firebaseAuth.signOut();
    return 0;
  }

  @override
  Future<LoggedUser?> unlinkAccount(ProviderLogin provider) async {
    var user = firebaseAuth.currentUser;
    if (user == null) {
      throw NotUserLogged();
    }
    switch (provider) {
      case ProviderLogin.google:
        user = await user.unlink('google.com');
        break;
      case ProviderLogin.facebook:
        user = await user.unlink('facebook.com');
        break;
      case ProviderLogin.appleId:
        user = await user.unlink('apple.com');
        break;
      case ProviderLogin.emailSignin:
        user = await user.unlink('email');
        break;
      default:
        return null;
    }

    return _userFactory(user, _getProviderLogin(user.providerData));
  }

  @override
  FutureOr<LoggedUser?> linkAccount(ProviderLogin providerLogin) {
    final user = firebaseAuth.currentUser;
    if (user == null) {
      throw NotUserLogged();
    }

    switch (providerLogin) {
      case ProviderLogin.google:
        return _linkGoogle(user);
      case ProviderLogin.facebook:
        return _linkFacebook(user);
      case ProviderLogin.appleId:
        return _linkAppleId(user);
      default:
        return null;
    }
  }

  Future<LoggedUser?> _linkGoogle(User user) async {
    GoogleSignInAuthentication? signInAuthenticationResult;
    try {
      signInAuthenticationResult = await provider.googleAuth();
    } catch (e, st) {
      throw CredentialsError(
          message: 'firebaseDatasource.credentialError',
          mainException: e,
          stacktrace: st);
    }
    if (signInAuthenticationResult == null) return null;
    final credential = GoogleAuthProvider.credential(
      accessToken: signInAuthenticationResult.accessToken,
      idToken: signInAuthenticationResult.idToken,
    );

    await provider.googleSignIn.signOut();
    UserCredential result;
    try {
      result = await user.linkWithCredential(credential);
    } on FirebaseAuthException catch (e, st) {
      if (e.code == 'credential-already-in-use') {
        throw DuplicatedAccountProviderError(
            message: 'firebaseDatasource.ErrorCredentialsMessage',
            mainException: e,
            stacktrace: st);
      }
      throw Exception();
    }
    final resultUser = result.user;
    if (resultUser == null) return null;

    return _userFactory(resultUser, _getProviderLogin(resultUser.providerData));
  }

  Future<LoggedUser?> _linkFacebook(User user) async {
    FacebookAuthCredential? credential;
    try {
      credential = await provider.facebookAuth();
    } catch (e, st) {
      throw CredentialsError(
          message: 'firebaseDatasource.credentialError',
          mainException: e,
          stacktrace: st);
    }
    if (credential == null) return null;
    await provider.facebookSignIn.logOut();
    UserCredential result;
    try {
      result = await user.linkWithCredential(credential);
    } on FirebaseAuthException catch (e, st) {
      if (e.code == 'credential-already-in-use') {
        throw DuplicatedAccountProviderError(
            message: 'firebaseDatasource.ErrorCredentialsMessage',
            mainException: e,
            stacktrace: st);
      }
      throw Exception();
    }

    final resultUser = result.user;
    if (resultUser == null) return null;

    return _userFactory(resultUser, _getProviderLogin(resultUser.providerData));
  }

  Future<LoggedUser?> _linkAppleId(User user) async {
    AuthorizationCredentialAppleID authorizationCredentialAppleID;
    try {
      authorizationCredentialAppleID = await provider.appleAuth();
    } catch (e, st) {
      throw CredentialsError(
          message: 'firebaseDatasource.credentialError',
          mainException: e,
          stacktrace: st);
    }
    var oAuthProvider = OAuthProvider('apple.com');
    final credential = oAuthProvider.credential(
      idToken: authorizationCredentialAppleID.identityToken,
      accessToken: authorizationCredentialAppleID.authorizationCode,
    );

    UserCredential result;
    try {
      result = await user.linkWithCredential(credential);
    } on FirebaseAuthException catch (e, st) {
      if (e.code == 'credential-already-in-use') {
        throw DuplicatedAccountProviderError(
            message: 'firebaseDatasource.ErrorCredentialsMessage',
            mainException: e,
            stacktrace: st);
      }
      throw Exception();
    }
    final resultUser = result.user;
    if (resultUser == null) return null;

    return _userFactory(resultUser, _getProviderLogin(resultUser.providerData));
  }

  @override
  Future<void> deleteAccount() async {
    try {
      await firebaseAuth.currentUser?.delete();
    } on FirebaseException catch (e, st) {
      if (e.code == 'requires-recent-login') {
        throw DeleteAccountError(
            message: 'firebaseDatasource.requiresRecentLogin',
            mainException: e,
            stacktrace: st);
      }
      rethrow;
    }
  }

  @override
  Future<LoggedUser?> signupWithEmail(EmailCredencials credencials) async {
    try {
      var userCredential = await firebaseAuth.createUserWithEmailAndPassword(
          email: credencials.email, password: credencials.password);
      final user = userCredential.user;
      if (user == null) return null;
      return _userFactory(user, _getProviderLogin(user.providerData));
    } on FirebaseAuthException catch (e, st) {
      if (e.code == 'weak-password') {
        throw EmailLoginError(
            message: 'The password provided is too weak.',
            mainException: e,
            stacktrace: st);
      } else if (e.code == 'email-already-in-use') {
        throw EmailLoginError(
            message: 'The account already exists for that email.',
            mainException: e,
            stacktrace: st);
      }
    } catch (e, st) {
      throw EmailLoginError(
          message: 'Datasource error', mainException: e, stacktrace: st);
    }
    throw EmailLoginError(message: 'Datasource error');
  }

  @override
  Future<void> sendEmailVerification() async {
    var user = firebaseAuth.currentUser;
    if (user == null) return;

    if (!user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  @override
  Future<LoggedUser?> loginWithEmail(EmailCredencials credencials) async {
    try {
      var userCredential = await firebaseAuth.signInWithEmailAndPassword(
          email: credencials.email, password: credencials.password);
      final user = userCredential.user;
      if (user == null) return null;
      return _userFactory(user, _getProviderLogin(user.providerData));
    } on FirebaseAuthException catch (e, st) {
      if (e.code == 'user-not-found') {
        throw EmailLoginError(
            message: 'No user found for that email',
            mainException: e,
            stacktrace: st);
      } else if (e.code == 'wrong-password') {
        throw EmailLoginError(
            message: 'Wrong password provided for that user.',
            mainException: e,
            stacktrace: st);
      } else if (e.code == 'invalid-email') {
        throw EmailLoginError(
            message: 'The email address is badly formatted.',
            mainException: e,
            stacktrace: st);
      }
    }
    throw EmailLoginError(message: 'Datasource error');
  }

  @override
  Future<void> recoveryPassword(String email) {
    return firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
