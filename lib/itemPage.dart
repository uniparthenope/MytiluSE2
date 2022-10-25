import 'package:flutter/material.dart';
import 'package:mytiluse/place.dart';

class ItemPage extends StatefulWidget{
  final String title;
  final String id;
  final String date;


  const ItemPage({required this.title, required this.id, required this.date});

  @override
  ItemPageState createState() => ItemPageState();

}
class ItemPageState extends State<ItemPage>{
  int _selectedIndex = 1;


  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  List<Widget> _widgetOptions = <Widget>[
    PlacePage(state: 1, id: '', date: ''),
    PlacePage(state: 2, id: '', date: '')
  ];

  @override
  void initState() {

    _widgetOptions = <Widget>[
      PlacePage(state: 1, id: widget.id, date: widget.date),
      PlacePage(state: 2, id: widget.id, date: widget.date)
    ];
    super.initState();
  }



  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,),
        backgroundColor: const Color.fromRGBO(0, 96, 160, 1.0),
      ),
      body: Center( child: _widgetOptions.elementAt(_selectedIndex),),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.filter_drama),
            label: 'Meteo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sailing),
            label: 'Mare',
          ),

        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color.fromRGBO(0, 96, 160, 1.0),
        onTap: _onItemTapped,
      ),
    );
  }
}