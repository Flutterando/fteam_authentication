library fteam_authentication_firebase;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fteam_authentication_core/fteam_authentication_core.dart';

import 'src/firebase_datasource.dart';
import 'src/providers/provider_options.dart';
import 'src/providers/provider_service.dart';

export 'package:fteam_authentication_core/fteam_authentication_core.dart';

export 'src/providers/provider_options.dart';

bool _isInitialized = false;

Future<void> startFirebaseDatasource(ProviderOptions options, {FirebaseOption? firebaseOptions}) async {
  if (!_isInitialized) {
    final provider = ProviderService(options);
    await Firebase.initializeApp(options: firebaseOptions);
    final datasource = FirebaseDatasource(provider: provider, firebaseAuth: FirebaseAuth.instance);
    FTeamAuth.registerAuthDatasource(datasource);
    _isInitialized = true;
  }
}

class FirebaseOption extends FirebaseOptions {
  const FirebaseOption({
    required String apiKey,
    required String appId,
    required String messagingSenderId,
    required String projectId,
    String? storageBucket,
    String? authDomain,
    String? databaseURL,
    String? measurementId,
    String? trackingId,
    String? deepLinkURLScheme,
    String? androidClientId,
    String? iosClientId,
    String? iosBundleId,
    String? appGroupId,
  }) : super(
          apiKey: apiKey,
          appId: appId,
          messagingSenderId: messagingSenderId,
          projectId: projectId,
          storageBucket: storageBucket,
          authDomain: authDomain,
          databaseURL: databaseURL,
          measurementId: measurementId,
          trackingId: trackingId,
          deepLinkURLScheme: deepLinkURLScheme,
          androidClientId: androidClientId,
          iosClientId: iosClientId,
          iosBundleId: iosBundleId,
          appGroupId: appGroupId,
        );
}
