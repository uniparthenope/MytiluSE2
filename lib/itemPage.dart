import 'package:flutter/material.dart';
import 'package:mytiluse/place.dart';

class Item extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ItemPage(title: 'Mytiluse'),
    );
  }
}

class ItemPage extends StatefulWidget{
  final String title;

  const ItemPage({required this.title});

  @override
  ItemPageState createState() => ItemPageState();

}

class ItemPageState extends State<ItemPage>{
  int _selectedIndex = 0;

  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  final List<Widget> _widgetOptions = <Widget>[
    PlacePage(),
    PlacePage()
  ];

  @override
  void initState() {
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
            label: 'Meteo',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_week),
            label: 'Mare',
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