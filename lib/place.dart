//TODO Aggiornare barre di scala

import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;

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
  String? weathIcon;
  String? weathLabel;

  Weather_Item({this.urlMap, this.urlMap2, this.curDir, this.curVal, this.temperature,
    this.rain, this.status, this.statusName, this.weathIcon, this.weathLabel});
}

class Sea_Item {
  String? urlWcm3;
  String? urlWw3;
  String? urlAiquam;
  String? urlRms;
  String? curDir;
  String? curVal;
  String? T_Sup;
  String? S_Sup;
  List<DataPoint>? dataPoints;

  Sea_Item({this.urlWcm3, this.urlAiquam, this.urlWw3, this.urlRms, this.curDir, this.curVal, this.T_Sup, this.S_Sup, this.dataPoints});
}

Future<Weather_Item> getItemWeather(id, date) async {

    String urlMap = "https://api.meteo.uniparthenope.it/products/wrf5/forecast/" +
        id + "/plot/image?date=" + date;
    String urlMap2 = "https://api.meteo.uniparthenope.it/products/wrf5/forecast/" +
        id + "/plot/image?output=wn1&date=" + date;
    String url = "https://api.meteo.uniparthenope.it/products/wrf5/forecast/" +
        id + "?date=" + date;

    var element = Weather_Item(urlMap: '', urlMap2: '');

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data["result"] == "ok") {
        String curDir = data["forecast"]["ws10n"].toString() + " nodes";
        String temp = data["forecast"]["t2c"].toString() + " °C";
        String rain = data["forecast"]["crh"].toString() + " mm";

        String curVal = "resources/arrow/" + data["forecast"]["winds"] + ".jpg";
        String weath = "resources/meteo_icon/" + data["forecast"]["icon"];
        String wLabel = data["forecast"]["text"]['en'];

        element = Weather_Item(urlMap: urlMap, urlMap2: urlMap2, curDir: curDir,
            curVal: curVal, temperature: temp, rain: rain, weathIcon: weath, weathLabel: wLabel);
      }

    }
  return element;
}

Future<Sea_Item> getItemSea(id, date) async {

  String urlWcm3 = "https://api.meteo.uniparthenope.it/products/wcm3/forecast/" +
      id + "/plot/image?date=" + date;
  String urlWw3 = "https://api.meteo.uniparthenope.it/products/ww33/forecast/" +
      id + "/plot/image?output=hsd&date=" + date;
  String urlAiquam = "https://api.meteo.uniparthenope.it/products/aiq3/forecast/" +
      id + "/plot/image?output=gen&date=" + date;
  String urlRms = "https://api.meteo.uniparthenope.it/products/rms3/forecast/" +
      id + "/plot/image?date=" + date;
  String url = "https://api.meteo.uniparthenope.it/products/rms3/forecast/" +
      id + "?date=" + date;

  var element = Sea_Item(urlWcm3: urlWcm3, urlWw3: urlWw3, urlAiquam:urlAiquam,urlRms:urlRms);

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    if (data["result"] == "ok") {
      String curDir = data["forecast"]["scm"].toString() + " m/sec";
      String curVal = "resources/arrow/" + data["forecast"]["scs"] + ".jpg";

      String TSup = data["forecast"]["sst"].toString() + ' °C';
      String SSup = data["forecast"]["sss"].toString() + ' [1/1000]';

      Future<List<DataPoint>> dataPointsFuture = getTimeSeriesAIQ(id);
      List<DataPoint> dataPoints = await dataPointsFuture;

      element = Sea_Item(urlWcm3: urlWcm3, urlWw3: urlWw3, urlAiquam: urlAiquam, urlRms: urlRms,
      curVal: curVal, curDir: curDir, T_Sup: TSup, S_Sup: SSup, dataPoints: dataPoints);
    }
  }
  return element;
}

class DataPoint {
  final DateTime timestamp;
  final double value;

  DataPoint({required this.timestamp, required this.value});
}

Future<List<DataPoint>> getTimeSeriesAIQ(id) async {
  String url = "https://api.meteo.uniparthenope.it/products/aiq3/timeseries/" + id;
  List<DataPoint> dataPoints = [];

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    if (data["result"] == "ok") {
      for (var data in data["timeseries"]) {
        String dateString = data["dateTime"];
        int year = int.parse(dateString.substring(0, 4));
        int month = int.parse(dateString.substring(4, 6));
        int day = int.parse(dateString.substring(6, 8));
        int hour = int.parse(dateString.substring(9, 11));
        int minute = int.parse(dateString.substring(11, 13));

        DateTime parsedDate = DateTime.utc(year, month, day, hour, minute);

        dataPoints.add(DataPoint(
          timestamp: parsedDate,
          value: data["mci"],
        ));
      }
    }
  } else {
    throw Exception('Failed to load data from API');
  }

  return dataPoints;
}

class PlacePage extends StatefulWidget{
  final int state;
  final String id;
  final String date;

  PlacePage({required this.state, required this.id, required this.date});

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
    var date = widget.date;

    if (state == 1){
      return Scaffold(
          body: Center(
            child: FutureBuilder(
                future: getItemWeather(id, date),
                builder: (BuildContext context, AsyncSnapshot<Weather_Item> snapshot) {
                  var data = snapshot.data;
                  String? urlMap = data?.urlMap;
                  String? urlMap2 = data?.urlMap2;
                  String? w10 = data?.curDir;
                  String? t = data?.temperature;
                  String? r = data?.rain;
                  String? w = data?.weathIcon;
                  String? wL = data?.weathLabel;

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
                                  const Text('Informazioni', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
                                  const Divider(height: 20, thickness: 0,),

                                  // Località
                                  Row(
                                    children: [
                                      const Expanded(child:  Text('Meteo: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)), flex: 2,),
                                      Expanded(child:  Text(wL ?? ''), flex: 1,),
                                      Expanded(child:  Image.asset(w ?? '', height: 50,), flex: 1,),

                                    ],
                                  ),
                                  // Vento 10m
                                  Row(
                                    children: [
                                      const Expanded(child:  Text('Vento 10m: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)), flex: 1,),
                                      Expanded(child:  Text(w10 ?? ''), flex: 1,),
                                    ],
                                  ),
                                  // Temperatura
                                  Row(
                                    children: [
                                      const Expanded(child:  Text('Temperatura: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)), flex: 1,),
                                      Expanded(child:  Text(t ?? ''), flex: 1,),
                                    ],
                                  ),
                                  // Pioggia
                                  Row(
                                    children: [
                                      const Expanded(child:  Text('Pioggia: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)), flex: 1,),
                                      Expanded(child:  Text(r ?? ''), flex: 1,),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 20, thickness: 0),

                            Column(
                              children: [
                                const Text('Mappa', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
                                Image.network(urlMap2 ?? '',fit: BoxFit.fill,
                                  errorBuilder: (context, error, stackTrace){
                                    return Container(
                                    color: Colors.redAccent,
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'Map not available!',

                                      style: TextStyle(fontSize: 30, color: Colors.white),
                                    ),
                                  );
                                  },
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
                                Image.asset('resources/colorbar/it-IT/bar_pioggia.jpg'),
                                Image.asset('resources/colorbar/it-IT/bar_nuvole.jpg'),
                                Image.asset('resources/colorbar/it-IT/bar_neve.jpg'),
                                const Divider(height: 20, thickness: 0),
                                const Text('Velocità del Vento', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),

                            Image.network(urlMap ?? '',
                            errorBuilder: (context, error, stackTrace){
                              return Container(
                                color: Colors.redAccent,
                                alignment: Alignment.center,
                                child: const Text(
                                  'Map not available!',

                                  style: TextStyle(fontSize: 30, color: Colors.white),
                                ),
                              );
                            },
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
                                Image.asset('resources/colorbar/it-IT/bar_vento.jpg'),

                              ],
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
                future: getItemSea(id, date),
                builder: (BuildContext context, AsyncSnapshot<Sea_Item> snapshot) {
                  var data = snapshot.data;
                  String? urlWcm3 = data?.urlWcm3;
                  String? urlAiquam = data?.urlAiquam;
                  String? urlWw3 = data?.urlWw3;
                  String? urlRms = data?.urlRms;

                  String? curDir = data?.curDir;
                  String? curVal = data?.curVal;
                  String? t_sup = data?.T_Sup;
                  String? s_sup = data?.S_Sup;

                  List<DataPoint>? dataPoints = data?.dataPoints;

                  var series = [
                    charts.Series<DataPoint, DateTime>(
                      id: 'Value',
                      colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
                      domainFn: (DataPoint data, _) => data.timestamp,
                      measureFn: (DataPoint data, _) => data.value,
                      data: dataPoints ?? [],
                    )
                  ];

                  var chart = charts.TimeSeriesChart(
                    series,
                    animate: true,
                    behaviors: [
                      charts.ChartTitle('Mussels contamination index'),
                    ],
                    defaultRenderer: charts.BarRendererConfig<DateTime>(
                        groupingType: charts.BarGroupingType.stacked,
                    ),
                  );

                  var chartWidget = Padding(
                    padding: new EdgeInsets.all(32.0),
                    child: SizedBox(
                      height: 200.0,
                      child: chart,
                    ),
                  );

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
                                  Text('Informazioni', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
                                  const Divider(height: 20, thickness: 0,),

                                  Row(
                                    children: [
                                      Expanded(child:  Text('Corrente superficiale: ',
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)), flex: 2,),
                                      Expanded(child:  Text(curDir ?? ''), flex: 1,),
                                      Expanded(child:  Image.asset(curVal ?? '', height: 50,), flex: 1,),

                                    ],
                                  ),

                                  // Temperatura Sup
                                  Row(
                                    children: [
                                      Expanded(child:  Text('Temperatura superficiale: ',
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)), flex: 1,),
                                      Expanded(child:  Text(t_sup ?? ''), flex: 1,),
                                    ],
                                  ),
                                  // Surface Salinity
                                  Row(
                                    children: [
                                      Expanded(child:  Text('Salinità superficiale: ',
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)), flex: 1,),
                                      Expanded(child:  Text(s_sup ?? ''), flex: 1,),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 20, thickness: 0),

                            Container(
                              child: Column(
                                children: [
                                  const Divider(height: 20, thickness: 0),
                                  Text('AIQUAM', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),

                                  chartWidget,

                                  Image.network(urlAiquam ?? '',
                                    errorBuilder: (context, error, stackTrace){
                                      return Container(
                                        color: Colors.redAccent,
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'Map not available!',

                                          style: TextStyle(fontSize: 30, color: Colors.white),
                                        ),
                                      );
                                    },
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
                                  Image.asset('resources/colorbar/it-IT/bar_aiquam.jpg'),

                                  const Divider(height: 20, thickness: 0),
                                  Text('WCM3', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
                                  Image.network(urlWcm3 ?? '',
                                    errorBuilder: (context, error, stackTrace){
                                      return Container(
                                        color: Colors.redAccent,
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'Map not available!',

                                          style: TextStyle(fontSize: 30, color: Colors.white),
                                        ),
                                      );
                                    },
                                    loadingBuilder: (BuildContext context, Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress != null
                                              ? (loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!)
                                              : 0,
                                        ),
                                      );
                                    },),
                                  Image.asset('resources/colorbar/it-IT/bar_concentrazion.jpg'),

                                  const Divider(height: 20, thickness: 0),
                                  Text('RMS3', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),

                                  Image.network(urlRms ?? '',fit: BoxFit.fill,
                                    errorBuilder: (context, error, stackTrace){
                                      return Container(
                                        color: Colors.redAccent,
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'Map not available!',

                                          style: TextStyle(fontSize: 30, color: Colors.white),
                                        ),
                                      );
                                    },
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
                                  Image.asset('resources/colorbar/it-IT/bar_corr.jpg'),

                                  const Divider(height: 20, thickness: 0),
                                  Text('Altezza Onde', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),

                                  Image.network(urlWw3 ?? '',
                                    errorBuilder: (context, error, stackTrace){
                                      return Container(
                                        color: Colors.redAccent,
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'Map not available!',

                                          style: TextStyle(fontSize: 30, color: Colors.white),
                                        ),
                                      );
                                    },
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
                                  Image.asset('resources/colorbar/it-IT/bar_ww3.jpg'),
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