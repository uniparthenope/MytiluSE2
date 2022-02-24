import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:date_time_picker/date_time_picker.dart';

import 'itemsList.dart';


String _selectedDateTime = '';

class MytiluSE extends StatefulWidget {

  const MytiluSE({Key? key}) : super(key: key);

  @override
  State<MytiluSE> createState() => _MytiluSE();
}

class _MytiluSE extends State<MytiluSE> {
  int _selectedIndex = 0;
  ItemsList listview = ItemsList(selDateTime: 'Hello');

  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static final List<Widget> _widgetOptions = <Widget>[
    ItemsList(selDateTime: _selectedDateTime),
    const Text( 'Index 1: Aree', style: optionStyle),
  ];


  get initialDate => DateTime.parse('2022-07-20 20:18:04Z');

  get lastDate => DateTime.parse('2022-07-20 20:18:04Z');

  get firstDate => DateTime.parse('1969-07-20 20:18:04Z');


  void _onItemTapped(int index) {
    print("ITEM_TAPPED!");
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MytiluSE'),
      ),

      body: Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
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
                    icon: Icon(Icons.event),
                    dateLabelText: 'Date',
                    timeLabelText: "Hour",
                    onChanged: (val) => {

                    setState(() {
                      _selectedIndex = 0;
                      new ItemsList(selDateTime: val);
                    }),
                      print("C" + _selectedDateTime),

                    },
                    validator: (val) {
                      print(val);
                      return null;
                    },
                    onSaved: (val) => print(val),
                  )
              ),
              Expanded(
                flex: 10,
                child: Center( child: _widgetOptions.elementAt(_selectedIndex),),
              ),
            ]
        ),
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
}
