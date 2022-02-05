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

Future<void> startFirebaseDatasource(ProviderOptions options) async {
  if (!_isInitialized) {
    final provider = ProviderService(options);
    await Firebase.initializeApp();
    final datasource = FirebaseDatasource(
        provider: provider, firebaseAuth: FirebaseAuth.instance);
    FTeamAuth.registerAuthDatasource(datasource);
    _isInitialized = true;
  }
}
