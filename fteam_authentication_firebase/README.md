# fteam_authentication_firebase

Fteam' Datasource Authentication using Firebase

## Install

Add in your pubspec.yaml
```yaml
dependencies:    
  fteam_authentication_firebase:


```

## Usage

Configure natives:
[firebase_core](https://pub.dev/packages/firebase_core)
[firebase_auth](https://pub.dev/packages/firebase_auth)
[google_sign_in](https://pub.dev/packages/google_sign_in)
[flutter_facebook_auth](https://pub.dev/packages/flutter_facebook_auth)
[sign_in_with_apple](https://pub.dev/packages/sign_in_with_apple)

```dart

main(){
	WidgetsFlutterBinding.ensureInitialized();

	//IMPORTANT iOS Auth Users
	startFirebaseDatasource(
		ProviderOptions(
			appleClientId: 'br.com.example',
			appleRedirectUri: Uri.parse('https://exemplo.com'),
		),
  );
  
   runApp(
   	...
    ),
  );
  ...
  
  //Utilize [Dartz](https://pub.dev/packages/dartz)
  Future signInGoogle() async {
    final result = await FTeamAuth.login(ProviderLogin.google);
    result.fold((l) => print(l.toString()), (r) => r?.email);
  }
}
```

# Dica

Se tiver error na versão do Kotlin vai em:
android/build.gradle 
na seção buildscript na chave ext.kotlin_version coloque o valor 1.6.10


