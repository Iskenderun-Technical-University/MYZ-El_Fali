import 'package:flutter/material.dart';
import 'package:myz_el_fali_version_1_1/desing/context_extension.dart';
import 'package:myz_el_fali_version_1_1/view/login_s.dart';
import 'package:myz_el_fali_version_1_1/services/auth.dart';
import 'package:myz_el_fali_version_1_1/varaible/varaible.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('image/lgscreen.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.dynamicWidth(0.1)),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(flex: 0, child: buildTextname()),
                const SizedBox(
                  height: 20,
                ),
                Expanded(flex: 0, child: buildTextpass()),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  flex: 0,
                  child: buildRegisterButton(context),
                ),
              ]),
        ),
      ),
    );
  }

  Row buildRegisterButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            _authService
                .createPerson(_emailController.text, _passwordController.text)
                .then((value) {
              if (errl == "Hata") {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const AlertDialog(title: Text("Boş bırakılmaz"));
                    });
                errl = "";
              } else {
                return Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()));
              }
            });
          },
          child: const Text("Üye Ol"),
          style: ElevatedButton.styleFrom(
              onPrimary: const Color.fromRGBO(227, 179, 76, 1),
              shadowColor: Colors.transparent,
              primary: Colors.transparent,
              textStyle: const TextStyle(fontSize: 30)),
        ),
      ],
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
              labelText: 'Enter your mail',
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
}
