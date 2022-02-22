import 'package:flutter/material.dart';
import 'package:fteam_authentication_firebase/fteam_authentication_firebase.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  startFirebaseDatasource(
    ProviderOptions(
      appleClientId: 'br.com.example',
      appleRedirectUri: Uri.parse('https://exemplo.com'),
    ),
    firebaseOptions: const FirebaseOption(
      appId: '1:129988387330:android:7d91933792f199ca67fd1b',
      apiKey: 'AIzaSyBb4GGgu92h43QoOAl9xOksbykMwR_kbxg',
      projectId: 'gymsy-9529b',
      messagingSenderId: '129988387330',
    ),

    //firebaseOptions: const FirebaseOption(
    //  appId: 'your appId',
    //  apiKey: 'you apiKey',
    //  projectId: 'your projectId',
    //  messagingSenderId: 'your messagingSenderId',
    //),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthPage(),
    );
  }
}

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  var store = Store();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            alignment: WrapAlignment.center,
            runSpacing: 16,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: FlutterLogo(
                  size: 60,
                ),
              ),
              const TextField(
                decoration: InputDecoration(label: Text('E-mail'), border: OutlineInputBorder()),
              ),
              const TextField(
                decoration: InputDecoration(label: Text('Password'), border: OutlineInputBorder()),
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Login'),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                    onPressed: () {
                      store.signInGoogle();
                    },
                    child: const Text('Login Google'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      store.signInFacebook();
                    },
                    child: const Text('Login Facebook'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.black),
                    onPressed: () {
                      store.signInApple();
                    },
                    child: const Text('Login Apple'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Store extends ValueNotifier<bool> {
  Store() : super(false);

  Future<bool> save(String email, String password) async {
    return true;
  }

  Future signInGoogle() async {
    final result = await FTeamAuth.login(ProviderLogin.google);
    result.fold((l) {
      debugPrint(l.toString());
    }, (r) {
      if (r == null) {
        debugPrint('Fail to login');
        return null;
      }
      debugPrint(r.token);
      return r.email;
    });
  }

  Future signInFacebook() async {
    final result = await FTeamAuth.login(ProviderLogin.facebook);
    result.fold((l) {
      debugPrint(l.toString());
    }, (r) {
      return r?.email;
    });
  }

  Future signInApple() async {
    final result = await FTeamAuth.login(ProviderLogin.appleId);
    result.fold((l) {
      debugPrint(l.toString());
    }, (r) {
      return r?.email;
    });
  }
}

class User {
  final String email;
  final String password;

  User(this.email, this.password);
}
