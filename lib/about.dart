import 'package:flutter/material.dart';
import 'main.dart';

//TODO Improve About

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('About Page'),
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 20,top: 150),
                  child:  Column(
                    children: const [
                      Text('MytiluSE',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Aleo',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.bold,
                              fontSize: 25.0,
                              color: Colors.black
                          )
                      ),
                      Text("https://meteo.uniparthenope.it", style: TextStyle(
                          fontSize: 16.0
                      ),
                      ),
                      Text(""),
                      Text("Dipartimento di Scienze e Tecnologie", style: TextStyle(
                          fontSize: 16.0
                      ),
                      ),
                      Text("Università degli Studi di Napoli 'Parthenope'", style: TextStyle(
                          fontSize: 16.0
                      ),
                      )
                    ],
                  )

              ),

              Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 20,top: 150),
                  child:  const Text('Team',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Aleo',
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                          color: Colors.black
                      )
                  )
              )
            ],
          ),

        )


    );
  }
}
