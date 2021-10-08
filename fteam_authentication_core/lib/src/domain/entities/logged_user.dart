class LoggedUser {
  final String name;
  final String email;
  final String uid;
  final String urlPhoto;
  final String token;
  final bool emailVerified;
  final List<ProviderLogin> providers;

  const LoggedUser({
    required this.uid,
    required this.token,
    required this.providers,
    this.name = '',
    this.email = '',
    this.urlPhoto = '',
    this.emailVerified = false,
  });

  LoggedUser copyWith({
    required String uid,
    required String token,
    required List<ProviderLogin> providers,
    String? name,
    String? email,
    String? urlPhoto,
    bool? emailVerified,
  }) {
    return LoggedUser(
      uid: uid,
      token: token,
      name: name ?? this.name,
      email: email ?? this.email,
      urlPhoto: urlPhoto ?? this.urlPhoto,
      emailVerified: emailVerified ?? this.emailVerified,
      providers: providers,
    );
  }
}

enum ProviderLogin { google, facebook, appleId, emailSignin }

Map<ProviderLogin, String> _nameProviderLogin = {};
Map<ProviderLogin, String> _emailProviderLogin = {};

extension ProviderLoginExtension on ProviderLogin {
  String get name => _nameProviderLogin[this] as String;
  set name(String value) => _nameProviderLogin[this] = value;

  String get email => _emailProviderLogin[this] as String;
  set email(String value) => _emailProviderLogin[this] = value;
}
