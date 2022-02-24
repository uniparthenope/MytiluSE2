import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String apiBase= 'https://api.meteo.uniparthenope.it';

class Weather_Item {
  String? urlMap;
  String? urlMap2;
  String? curDir;
  String? curVal;
  String? temperature;
  String? rain;
  String? status;
  String? statusName;

  Weather_Item({this.urlMap, this.urlMap2, this.curDir, this.curVal, this.temperature, this.rain, this.status, this.statusName});
}

class Sea_Item {
  String? urlWcm3;
  String? urlSal;
  String? urlTemp;
  String? urlRms;
  String? curDir;
  String? curVal;
  String? T_Sup;
  String? S_Sup;

  Sea_Item({this.urlWcm3, this.urlSal, this.urlTemp, this.urlRms, this.curDir, this.curVal, this.T_Sup, this.S_Sup});
}

Future<Weather_Item> getItemWeather(id) async {

    String urlMap = "https://api.meteo.uniparthenope.it/products/wrf5/forecast/" +
        id + "/plot/image"; //?date="
    String urlMap2 = "https://api.meteo.uniparthenope.it/products/wrf5/forecast/" +
        id + "/plot/image?output=wn1"; //?date="
    String url = "https://api.meteo.uniparthenope.it/products/wrf5/forecast/" +
        id; //"?date="

    var element = Weather_Item(urlMap: '', urlMap2: '');


    // final response = await http.get(Uri.parse(apiBase + "http://api.meteo.uniparthenope.it/products/rms3/forecast/" + id + "?date=" + formattedDate + "&opt=place"));
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data["result"] == "ok") {
        // String curDir = data["forecast"]["ws10n"] + " nodi";
        // String curVal = "resources/arrow/" + data["forecast"]["winds"] + ".jpg";

        element = Weather_Item(urlMap: urlMap, urlMap2: urlMap2);
      }

    }
  return element;
}

Future<Sea_Item> getItemSea(id) async {

  String urlWcm3 = "https://api.meteo.uniparthenope.it/products/wcm3/forecast/" +
      id + "/plot/image"; //?date="
  String urlSal = "https://api.meteo.uniparthenope.it/products/rms3/forecast/" +
      id + "/plot/image?output=sss"; //?date="
  String urlTemp = "https://api.meteo.uniparthenope.it/products/rms3/forecast/" +
      id + "/plot/image?output=sst"; //?date="
  String urlRms = "https://api.meteo.uniparthenope.it/products/rms3/forecast/" +
      id + "/plot/image?"; //?date="
  String url = "https://api.meteo.uniparthenope.it/products/rms3/forecast/" +
      id; //"?date="

  var element = Sea_Item(urlWcm3: urlWcm3, urlSal: urlSal, urlTemp:urlTemp,urlRms:urlRms);
  print(urlWcm3);


  // final response = await http.get(Uri.parse(apiBase + "http://api.meteo.uniparthenope.it/products/rms3/forecast/" + id + "?date=" + formattedDate + "&opt=place"));
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    if (data["result"] == "ok") {
      // String curDir = data["forecast"]["ws10n"] + " nodi";
      // String curVal = "resources/arrow/" + data["forecast"]["winds"] + ".jpg";

      element = Sea_Item(urlWcm3: urlWcm3, urlSal: urlSal, urlTemp: urlTemp, urlRms: urlRms);
    }

  }
  return element;
}


class PlacePage extends StatefulWidget{
  final int state;
  final String id;

  PlacePage({required this.state, required this.id});

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
    var state = widget.state;
    var id = widget.id;
    if (state == 1){
      return Scaffold(
          body: Center(
            child: FutureBuilder(
                future: getItemWeather(id),
                builder: (BuildContext context, AsyncSnapshot<Weather_Item> snapshot) {
                  var data = snapshot.data;
                  String? urlMap = data?.urlMap;
                  String? urlMap2 = data?.urlMap2;

                  return Container(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 10.0, top: 10.0),
                              child: Column(

                                children: [
                                  Text('Informations', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
                                  const Divider(height: 20, thickness: 0,),

                                  // Località
                                  Row(
                                    children: [
                                      Expanded(child:  Text('Location: ',
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)), flex: 1,),
                                      Expanded(child:  Text('LOC '), flex: 1,),
                                    ],
                                  ),
                                  // Vento 10m
                                  Row(
                                    children: [
                                      Expanded(child:  Text('Wind 10m: ',
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)), flex: 1,),
                                      Expanded(child:  Text('VENTO '), flex: 1,),
                                    ],
                                  ),
                                  // Temperatura
                                  Row(
                                    children: [
                                      Expanded(child:  Text('Temperature: ',
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)), flex: 1,),
                                      Expanded(child:  Text('80* '), flex: 1,),
                                    ],
                                  ),
                                  // Pioggia
                                  Row(
                                    children: [
                                      Expanded(child:  Text('Rain: ',
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)), flex: 1,),
                                      Expanded(child:  Text('VENTO '), flex: 1,),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 20, thickness: 0),

                            Container(
                              child: Column(
                                children: [
                                  Text('Map', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),

                                  Image.network(urlMap2!,fit: BoxFit.fill,
                                    loadingBuilder: (BuildContext context, Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress.expectedTotalBytes != null
                                              ? loadingProgress.cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },
                                  ),
                                  Image.asset('resources/colorbar/bar_pioggia.png'),
                                  Image.asset('resources/colorbar/bar_nuvole.png'),
                                  Image.asset('resources/colorbar/bar_neve.png'),
                                  const Divider(height: 20, thickness: 0),
                              Text('Wind Speed', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),

                            Image.network(urlMap!,
                              loadingBuilder: (BuildContext context, Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },),
                                  Image.asset('resources/colorbar/bar_vento.png'),

                                ],
                              ),
                            )
                          ],
                        ),
                      )
                  );
                }
            ),
          )
      );

    } else {
      return Scaffold(
          body: Center(
            child: FutureBuilder(
                future: getItemSea(id),
                builder: (BuildContext context, AsyncSnapshot<Sea_Item> snapshot) {
                  var data = snapshot.data;
                  String? urlWcm3 = data?.urlWcm3;
                  String? urlSal = data?.urlSal;
                  String? urlTemp = data?.urlTemp;
                  String? urlRms = data?.urlRms;

                  return Container(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 10.0, top: 10.0),
                              child: Column(

                                children: [
                                  Text('Informations', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
                                  const Divider(height: 20, thickness: 0,),

                                  // Località
                                  Row(
                                    children: [
                                      Expanded(child:  Text('Location: ',
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)), flex: 1,),
                                      Expanded(child:  Text('LOC '), flex: 1,),
                                    ],
                                  ),
                                  // Corrente Sup.
                                  Row(
                                    children: [
                                      Expanded(child:  Text('Current: ',
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)), flex: 1,),
                                      Expanded(child:  Text('10 m/s '), flex: 1,),
                                    ],
                                  ),
                                  // Temperatura Sup
                                  Row(
                                    children: [
                                      Expanded(child:  Text('Surface Temperature: ',
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)), flex: 1,),
                                      Expanded(child:  Text('80* '), flex: 1,),
                                    ],
                                  ),
                                  // Surface Salinity
                                  Row(
                                    children: [
                                      Expanded(child:  Text('Surface Salinity: ',
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)), flex: 1,),
                                      Expanded(child:  Text('VENTO '), flex: 1,),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 20, thickness: 0),

                            Container(
                              child: Column(
                                children: [
                                  Text('RMS3 Map', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),

                                  Image.network(urlWcm3!,fit: BoxFit.fill,
                                    loadingBuilder: (BuildContext context, Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress.expectedTotalBytes != null
                                              ? loadingProgress.cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },
                                  ),
                                  Image.asset('resources/colorbar/bar_corr.png'),
                                  const Divider(height: 20, thickness: 0),
                                  Text('Salinity Map', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),

                                  Image.network(urlSal!,
                                    loadingBuilder: (BuildContext context, Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress.expectedTotalBytes != null
                                              ? loadingProgress.cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },),
                                  Image.asset('resources/colorbar/bar_sss.png'),

                                  const Divider(height: 20, thickness: 0),
                                  Text('Temperature Map', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),

                                  Image.network(urlTemp!,
                                    loadingBuilder: (BuildContext context, Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress.expectedTotalBytes != null
                                              ? loadingProgress.cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },),
                                  Image.asset('resources/colorbar/bar_sst.png'),

                                  const Divider(height: 20, thickness: 0),
                                  Text('WCM3 Map', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),

                                  Image.network(urlRms!,
                                    loadingBuilder: (BuildContext context, Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress.expectedTotalBytes != null
                                              ? loadingProgress.cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },),
                                  Image.asset('resources/colorbar/bar_concentrazion.png'),

                                ],
                              ),
                            )
                          ],
                        ),
                      )
                  );
                }
            ),
          )
      );

    }
  }

}