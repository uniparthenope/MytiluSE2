import 'package:flutter/material.dart';
import 'package:mytiluse/place.dart';

class ItemPage extends StatefulWidget{
  final String title;
  final String id;


  const ItemPage({required this.title, required this.id});

  @override
  ItemPageState createState() => ItemPageState();

}
class ItemPageState extends State<ItemPage>{
  int _selectedIndex = 0;


  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  List<Widget> _widgetOptions = <Widget>[
    PlacePage(state: 1, id: ''),
    PlacePage(state: 2, id: '')
  ];

  @override
  void initState() {

    _widgetOptions = <Widget>[
      PlacePage(state: 1, id: widget.id),
      PlacePage(state: 2, id: widget.id)
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
        title: Text(widget.title),
      ),
      body: Container(
        child: Center( child: _widgetOptions.elementAt(_selectedIndex),),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.opacity),
            label: 'Weather',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_week),
            label: 'Sea',
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