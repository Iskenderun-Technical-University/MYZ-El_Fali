import 'package:firebase_auth/firebase_auth.dart';
import 'package:myz_el_fali_version_1_1/view/camera.dart';
import 'package:myz_el_fali_version_1_1/view/register.dart';
import 'package:flutter/material.dart';
import 'package:myz_el_fali_version_1_1/desing/context_extension.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myz_el_fali_version_1_1/varaible/varaible.dart';
import 'package:myz_el_fali_version_1_1/services/auth.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GoogleSignInAccount? _currentUser;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: buildBackImage(screenSize),
    );
  }

  Container buildBackImage(Size screenSize) {
    return Container(
      width: screenSize.width,
      height: screenSize.height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('image/lgscreen.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: context.dynamicWidth(0.6),
            horizontal: context.dynamicHeight(0.1)),
        child: Expanded(
          flex: 1,
          child: Column(
            children: [
              Expanded(flex: 0, child: buildTextname()),
              const SizedBox(
                height: 20,
              ),
              Expanded(flex: 0, child: buildTextpass()),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: Column(
                  children: [
                    buildSignButton(context),
                    buildGoogleLoginButton(),
                    buildRegisterButton(),
                    buildLogoutButton(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Center buildGoogleLoginButton() {
    return Center(
      child: TextButton(
          onPressed: () {
            signIn();
          },
          child: const Text("Google İle Giriş Yap"),
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(
                  const Color.fromRGBO(227, 179, 76, 1)),
              padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                  vertical: context.dynamicHeight(0.03),
                  horizontal: context.dynamicHeight(0.07))),
              textStyle:
                  MaterialStateProperty.all(const TextStyle(fontSize: 30)))),
    );
  }

  Center buildLogoutButton() {
    return Center(
      child: TextButton(
          onPressed: () {
            signOut();
          },
          child: const Text("Google çık"),
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(
                  const Color.fromRGBO(227, 179, 76, 1)),
              padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                  vertical: context.dynamicHeight(0.03),
                  horizontal: context.dynamicHeight(0.07))),
              textStyle:
                  MaterialStateProperty.all(const TextStyle(fontSize: 30)))),
    );
  }

  Row buildSignButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            _authService
                .signIn(_emailController.text, _passwordController.text)
                .then((value) {
              namemail = _emailController.text;
              if (errl == "Hata") {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const AlertDialog(title: Text("Yanlış giriş"));
                    });
                errl = "";
              } else {
                return Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Camera()));
              }
            });
          },
          child: const Text("Giriş Yap"),
          style: ElevatedButton.styleFrom(
              onPrimary: const Color.fromRGBO(227, 179, 76, 1),
              shadowColor: Colors.transparent,
              primary: Colors.transparent,
              textStyle: const TextStyle(fontSize: 30)),
        )
      ],
    );
  }

  Center buildRegisterButton() {
    return Center(
      child: TextButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Register()));

            // Alert(context: context, title: "İşlem", desc: cd).show();
            // Navigator.push(
            //     context, MaterialPageRoute(builder: (context) => Camera()));
          },
          child: const Text("Üye Ol"),
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(
                  const Color.fromRGBO(227, 179, 76, 1)),
              padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                  vertical: context.dynamicHeight(0.03),
                  horizontal: context.dynamicHeight(0.07))),
              textStyle:
                  MaterialStateProperty.all(const TextStyle(fontSize: 30)))),
    );
  }

  Row buildTextname() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Enter your username',
            ),
          ),
        )
      ],
    );
  }

  Row buildTextpass() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Enter your pass',
            ),
          ),
        )
      ],
    );
  }

  void signOut() {
    try {
      _googleSignIn.disconnect();
    } catch (e) {}
  }

  Future<void> signIn() async {
    try {
      await _googleSignIn.signIn();
      // if (googleUser.email != null) {
      //   Navigator.push(
      //       context, MaterialPageRoute(builder: (context) => const Camera()));
      // } else {
      //   namemail = googleUser.displayName.toString();
      // }
    } catch (e) {
      print('Error signing in $e');
    }
  }

  // Future<void> signInWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  //     final GoogleSignInAuthentication? googleAuth =
  //         await googleUser?.authentication;
  //     namemail = googleUser!.displayName.toString();
  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth?.accessToken,
  //       idToken: googleAuth?.idToken,
  //     );

  //     await FirebaseAuth.instance.signInWithCredential(credential);
  //   } catch (e) {
  //     throw Exception(e.toString());
  //   }
  // }
}
