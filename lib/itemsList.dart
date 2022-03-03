import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mytiluse/itemPage.dart';

const String apiBase= 'https://api.meteo.uniparthenope.it';
//const List<String> locations = ["VET0130", "VET0020", "VET0021", "VET0072", "VET0071", "VET0100", "VET0062", "VET0150", "VET0055", "VET0054", "VET0056", "VET0051", "VET0050", "VET0053", "VET0052", "VET0121", "VET0123", "VET0122", "VET0125", "VET0124", "VET0000", "VET0031", "VET0030", "VET0140", "VET0061", "VET0063", "VET0064", "VET0110", "VET0010", "VET0160", "VET0057", "VET0042", "VET0041"];

class Row {
  String? id;
  String? name;
  String? curDir;
  String? curVal;
  String? status;
  String? dt;

  Row({this.id, this.name, this.curDir, this.curVal, this.status});
}


Future<List> getItems(bool isLogged, String date, locations) async {
  List<Row> list = <Row>[];

  for (int i=0; i < locations.length; i++){
    final response = await http.get(Uri.parse(apiBase + "/products/rms3/forecast/" + locations[i] + "?date=" + date + "&opt=place"));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data["result"] == "ok"){
        var id = data["place"]["id"].toString();
        var scs = 'resources/arrow/' + data["forecast"]["scs"].toString() + '.jpg';
        var scm = data["forecast"]["scm"].toString();
        var name = data["place"]["long_name"]["it"].toString();
        var status = 'resources/status/none.png'.toString();

        // Check if user has permission to see status
        if (isLogged){
          final response2 = await http.get(Uri.parse(apiBase + "/products/wcm3/forecast/" + id + "?date=" + date));
          if (response2.statusCode == 200) {
            var data2 = jsonDecode(response2.body);

            if (data2["result"] == "ok"){
              status = 'resources/status/' + data2["forecast"]["sts"].toString() + '.png';
            }
          }
        }

        var item = Row(id: id, name: name, curDir: scs, curVal: scm, status: status);
        list.add(item);
      }
    }
  }

  return list;
}

class ListLayout extends StatefulWidget {
  final bool isLogged;
  final String date;
  final List<String> locations;

  ListLayout({required this.isLogged, required this.date, required this.locations});

  @override
  _ListLayoutState createState() => _ListLayoutState();
}

class _ListLayoutState extends State<ListLayout> {
  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var date = formatData(widget.date);
    var locations = widget.locations;
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: getItems(widget.isLogged, date, locations),
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            if (snapshot.hasData){
              var items = snapshot.data;
              return ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  var item = items![index];
                  return Card(
                    child: ListTile(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ItemPage(title: item.name, id: item.id, date: date)),
                        );
                      },
                      title: Text(item.name),
                      subtitle: Text(item.curVal + " m/s"),
                      leading: Image(image: AssetImage(item.curDir),height: 50,),
                      trailing: Image(image: AssetImage(item.status),height: 25,),
                    ),
                  );
                },
                itemCount: items == null ? 0 : items.length,
              );
            }
            else if (snapshot.hasError){
              return Text("${snapshot.error}");
            }
            // By default, show a loading spinner
            return CircularProgressIndicator();
          }
        ),
      )
    );
  }

  String formatData(data){
    final _date = DateTime.parse(data);
    final DateFormat formatter = DateFormat('yyyyMMdd HH00');
    final String formattedDate = formatter.format(_date).replaceAll(" ", "Z");

    return formattedDate;
  }
}