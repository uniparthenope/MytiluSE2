import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String apiBase= 'https://api.meteo.uniparthenope.it';

class Element {
  String? urlMap;
  String? urlMap2;
  String? curDir;
  String? curVal;
  String? temperature;
  String? rain;
  String? status;
  String? statusName;

  Element({this.urlMap, this.urlMap2, this.curDir, this.curVal, this.temperature, this.rain, this.status, this.statusName});
}

Future<Element> getItem(id) async {
  var element;

  String urlMap = "http://api.meteo.uniparthenope.it/products/wrf5/forecast/" + id + "/plot/image"; //?date="
  String urlMap2 = "http://api.meteo.uniparthenope.it/products/wrf5/forecast/" + id + "/plot/image?output=wn1"; //?date="
  String url = "http://api.meteo.uniparthenope.it/products/wrf5/forecast/" + id; //"?date="


  // final response = await http.get(Uri.parse(apiBase + "http://api.meteo.uniparthenope.it/products/rms3/forecast/" + id + "?date=" + formattedDate + "&opt=place"));
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    if (data["result"] == "ok"){
      // String curDir = data["forecast"]["ws10n"] + " nodi";
      // String curVal = "resources/arrow/" + data["forecast"]["winds"] + ".jpg";

      element = Element(urlMap: urlMap, urlMap2: urlMap2);
    }
  }

  return element;
}

class PlacePage extends StatefulWidget{
  PlacePage();

  @override
  PlacePageState createState() => PlacePageState();
}

class PlacePageState extends State<PlacePage>{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: FutureBuilder(
              future: getItem("VET0130"),
              builder: (BuildContext context, AsyncSnapshot<Element> snapshot) {
                var data = snapshot.data;
                String? urlMap = data?.urlMap;
                String? urlMap2 = data?.urlMap2;

                return Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.network(urlMap!),
                        const SizedBox(height: 10),
                        Image.network(urlMap2!),
                      ],
                    )
                );
              }
          ),
        )
    );
  }

}