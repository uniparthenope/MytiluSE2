import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:date_time_picker/date_time_picker.dart';

import 'itemsList.dart';


class MytiluSE extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MytiluSEPage(title: 'Mytiluse'),
    );
  }
}

class MytiluSEPage extends StatefulWidget{
  final String title;

  const MytiluSEPage({required this.title});

  @override
  MytiluSEPageState createState() => MytiluSEPageState();

}

class MytiluSEPageState extends State<MytiluSEPage>{
  int _selectedIndex = 0;
  String text = "Update";
  List<String> vetLocations = ["VET0130", "VET0020", "VET0021", "VET0072", "VET0071", "VET0100", "VET0062", "VET0150", "VET0055", "VET0054", "VET0056", "VET0051", "VET0050", "VET0053", "VET0052", "VET0121", "VET0123", "VET0122", "VET0125", "VET0124", "VET0000", "VET0031", "VET0030", "VET0140", "VET0061", "VET0063", "VET0064", "VET0110", "VET0010", "VET0160", "VET0057", "VET0042", "VET0041"];
  List<String> vebLocations = ["VEB1500030", "VEB1500029", "VEB1500015", "VEB1500012", "VEB1500013", "VEB1500018", "VEB1500038", "VEB1500014","VEB1500022","VEB1500032", "VEB1500041", "VEB1500026", "VEB1500033", "VEB1500016"];

  var date = DateTime.now().toString();

  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  List<Widget> _widgetOptions = <Widget>[
    ListLayout(date: DateTime.now().toString(), locations: []),
    ListLayout(date: DateTime.now().toString(), locations: []),
  ];

  @override
  void initState() {
    _widgetOptions = <Widget>[
      ListLayout(date: DateTime.now().toString(), locations: vetLocations),
      ListLayout(date: DateTime.now().toString(), locations: vebLocations),
    ];
    super.initState();
  }

  void _handleRefresh(val) {
    print(val);
    setState(() {
      _widgetOptions = <Widget>[
        ListLayout(date: val, locations: vetLocations),
        ListLayout(date: val, locations: vebLocations),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic, fontFamily: 'Georgia'),),
        backgroundColor: Color.fromRGBO(0, 96, 160, 1.0),
      ),
      body: Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  flex: 1,
                  child: DateTimePicker(
                    type: DateTimePickerType.dateTimeSeparate,
                    dateMask: 'd MMM, yyyy',
                    initialValue: DateTime.now().toString(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    icon: const Icon(Icons.event),
                    dateLabelText: 'Date',
                    timeLabelText: "Hour",
                    onChanged: (val) => {
                      _handleRefresh(val),
                    },
                    validator: (val) {
                      return null;
                    },
                    onSaved: (val) => {
                      _handleRefresh(val),
                    },
                  )
              ),
              Expanded(
                flex: 10,
                child: Center( child: _widgetOptions.elementAt(_selectedIndex),),
              ),
            ]
        )
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.opacity),
            label: 'Docks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_week),
            label: 'Areas',
          ),

        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        backgroundColor: Color.fromRGBO(0, 96, 160, 1.0),
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}