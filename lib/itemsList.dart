import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String apiBase= 'https://api.meteo.uniparthenope.it';
const List<String> locations = ["VET0130", "VET0020", "VET0021", "VET0072", "VET0071", "VET0100", "VET0062", "VET0150", "VET0055", "VET0054", "VET0056", "VET0051", "VET0050", "VET0053", "VET0052", "VET0121", "VET0123", "VET0122", "VET0125", "VET0124", "VET0000", "VET0031", "VET0030", "VET0140", "VET0061", "VET0063", "VET0064", "VET0110", "VET0010", "VET0160", "VET0057", "VET0042", "VET0041"];

class Item {
  String? id;
  String? name;
  String? curDir;
  String? curVal;
  String? status;

  Item({this.id, this.name, this.curDir, this.curVal, this.status});
}


Future<List> getItems() async {
  List<Item> list = <Item>[];

  for (int i=0; i < locations.length; i++){
    // final response = await http.get(Uri.parse(apiBase + "http://api.meteo.uniparthenope.it/products/rms3/forecast/" + locations[i] + "?date=" + search_data + "&opt=place"));
    final response = await http.get(Uri.parse(apiBase + "/products/rms3/forecast/" + locations[i] + "?opt=place"));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data["result"] == "ok"){
        var id = data["place"]["id"].toString();
        var scs = 'resources/arrow/' + data["forecast"]["scs"].toString() + '.jpg';
        var scm = data["forecast"]["scm"].toString();
        var name = data["place"]["long_name"]["it"].toString();
        var status = 'resources/status/0.png'.toString();

        // "?date=" + search_data
        final response2 = await http.get(Uri.parse(apiBase + "/products/wcm3/forecast/" + id));
        if (response2.statusCode == 200) {
          var data2 = jsonDecode(response2.body);

          if (data2["result"] == "ok"){
            status = 'resources/arrow/' + data2["forecast"]["sts"] + '.png';
          }
        }

        var item = Item(id: id, name: name, curDir: scs, curVal: scm, status: status);
        list.add(item);
      }
    }
  }

  return list;
}

class ItemsListPage extends StatefulWidget {
  const ItemsListPage({Key? key}) : super(key: key);

  @override
  ItemsListPageState createState() => ItemsListPageState();
}

class ItemsListPageState extends State<ItemsListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: FutureBuilder(
              future: getItems(),
              builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                var items = snapshot.data;

                return ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    var item = items![index];

                    return GestureDetector(
                      onTap: () {
                        print(item.id);
                      },
                      child: Card(
                        child: Column(
                          children: <Widget>[
                            Text("Name: " + item.name,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)
                            ),
                            Image(image: AssetImage(item.curDir)),
                            Text("Cur Dir: " + item.curVal,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)
                            ),
                            Image(image: AssetImage(item.status)),
                          ],
                        ),
                      )
                    );
                  },
                  itemCount: items == null ? 0 : items.length,
                );
              }),
        )
    );
  }
}