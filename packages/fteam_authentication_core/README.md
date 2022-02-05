# fteam_authentication_core

## Install

Add in your pubspec.yaml
```yaml
dependencies:
  fteam_authentication_core:
```

## Dependency

You need implement a ```AuthDatasource``` and register with method ```IAtecAuth.registerAuthDatasource```.

```dart
class MyDatasource implements AuthDatasource {
    ...
}

...

IAtecAuth.registerAuthDatasource(MyDatasource());

```

OR use *fteam_authentication_firebase* package;

## Usage

```dart
import 'package:fteam_authentication_core/fteam_authentication_core.dart'

...

final result = await FTeamAuth.login(ProviderLogin.google);
result.fold((error){
    dispachError(error);
}, (user){
    print(user);
});


```


| Methods              | Return Success| Return Error   |   
|----------------------|---------------|----------------|
| login                | LoggedUser    |  AuthFailure   |  
| logout               | Unit          |  LogoutFailure |  
| getLoggedUser        | LoggedUser    |  AuthFailure   |  
| deleteAccount        | Unit          |  AuthFailure   |  
| linkAccount          | LoggedUser    |  AuthFailure   |  
| sendEmalVerification | Unit          |  AuthFailure   |  
| signupWithEmail      | LoggedUser    |  AuthFailure   |  
 