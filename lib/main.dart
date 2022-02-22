import 'dart:convert';
import 'package:flutter/material.dart';
import 'about.dart';
import 'login.dart';
import 'mytiluse.dart';
import 'dart:async';

import 'package:http/http.dart' as http;

var isLogged = false;
const String apiBase= 'https://api.meteo.uniparthenope.it';

Future<String> getMessage() async {
  final response = await http
      .get(Uri.parse(apiBase + "/legal/disclaimer"));

  if (response.statusCode == 200) {
    //log(response.body);
    var message = jsonDecode(response.body);

    return message['i18n']['en-US']['disclaimer'].toString();

  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    return "".toString();
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'MytiluSE',
        theme: ThemeData(
        primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
            future: getMessage(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot){

              final message = snapshot.data.toString();
              return Scaffold(
                  appBar: AppBar(
                    title: Text("MytiluSE"),
                    actions: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.info),
                        tooltip: 'About',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AboutPage()),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.account_circle),
                        tooltip: 'Login Page',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen("Ma che bello!")),
                          );
                        },
                      ),
                    ],
                  ),
                  body: Container(
                      padding: EdgeInsets.only(left: 10,top: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image(image: AssetImage('resources/logo_mytiluse.png')),
                          Text(message),
                          Container(
                            margin: const EdgeInsets.only(top: 10.0),
                            child :  ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => MytiluSE()),
                                );
                              },
                              child: Text('Accept and Continue'),
                            ),
                          )
                        ],
                      )
                  )
              );
            }
        )
    );
  }
}