import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:leadoneattendance/dialogs/dialogs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('changepassword.title').tr(),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/LoginScreen');
                },
                icon: const Icon(Icons.save_outlined)),
          ],
        ),
        body: Card(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Image.asset(
                  'assets/leadone_logo.png',
                  width: 300,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'changepassword.title',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ).tr(),
                const SizedBox(
                  height: 2,
                ),
                const Text(
                  'changepassword.subtitle',
                  style: TextStyle(fontSize: 16),
                ).tr(),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.email)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Field is required.';
                    }
                    String pattern = r'\w+@\w+\.\w+';
                    if (!RegExp(pattern).hasMatch(value)) {
                      return 'Invalid Email address format.';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText:
                      true, // So that the text entered is only "--------".
                  decoration: const InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.password)),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: newPasswordController,
                  obscureText:
                      true, // So that the text entered is only "--------".
                  decoration: const InputDecoration(
                      labelText: "New Password",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.password)),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 39, 55, 146),
                        primary: Colors.white,
                        minimumSize: const Size(120, 50) //WH
                        ),
                    onPressed: () {
                      setState(() {
                        changepassword(
                            emailController.text,
                            passwordController.text,
                            newPasswordController.text);
                      });
                    },
                    child: const Text('changepassword.button').tr()),
              ],
            ),
          ),
        ));
  }

  Future<void> changepassword(email, password, newpassword) async {
    try {
      final response = await http.post(Uri.parse('https://174e-45-65-152-57.ngrok.io/password'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'Email': email,
            'Password': password,
            'NewPassword': newpassword
          }));
      if (response.statusCode == 201) {
        // Dialog box showing that the data is correct.
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AlertChangePasswordOk();
            });
        debugPrint('Correct user, changes made.');
      } else {
        // Dialog box indicating that the data is incorrect.
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AlertChangePasswordError();
            });
        debugPrint('Incorrect User');
      }
    } on TimeoutException {
      debugPrint('Process time exceeded.');
    }
  }
}
