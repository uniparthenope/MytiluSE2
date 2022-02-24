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
  var date = DateTime.now().toString();

  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  List<Widget> _widgetOptions = <Widget>[
    ListLayout(date: DateTime.now().toString()),
    const Text( 'Index 1: Aree', style: optionStyle)
  ];

  @override
  void initState() {
    super.initState();
  }

  void _handleRefresh(val) {
    setState(() {
      _widgetOptions = <Widget>[
        ListLayout(date: val),
        const Text('Update', style: optionStyle)
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
            label: 'Banchi',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_week),
            label: 'Aree',
            backgroundColor: Colors.green,
          ),

        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[800],
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