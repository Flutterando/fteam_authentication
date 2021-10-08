class EmailCredencials {
  final String email;
  final String password;

  EmailCredencials({required this.email, required this.password});

  factory EmailCredencials.onlyEmail(String email) =>
      EmailCredencials(email: email, password: '**');
}
