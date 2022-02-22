import 'dart:developer';
import 'dart:math';
import 'dart:developer' as l;

import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'about.dart';
import 'package:http/http.dart' as http;

const String apiBase= 'https://api.meteo.uniparthenope.it';

const users = const {
  'dribbble@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
};

class LoginScreen extends StatelessWidget {
  String test;

  Duration get loginTime => Duration(milliseconds: 2250);

  LoginScreen(this.test, {Key? key}) : super(key: key);

  Future<String?> _authUser(LoginData data) async{
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    final response = await http
        .post(Uri.parse(apiBase + "/user/login"), body: {'name':data.name, 'pass':data.password});

    if (response.statusCode == 200) {
      l.log(response.body);
    }
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(data.name)) {
        return 'User not exists';
      }
      if (users[data.name] != data.password) {
        return 'Password does not match';
      }
      return null;
    });
  }

  Future<String?> _signupUser(SignupData data) {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  Future<String> _recoverPassword(String name) {
    debugPrint('Name: $name');
    debugPrint('Test: ${test}');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User not exists';
      }
      return "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'MytiluSE',
      logo: AssetImage('resources/logo_mytiluse.png'),
      onLogin: _authUser,
      onSignup: _signupUser,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => AboutPage(),
        ));
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}