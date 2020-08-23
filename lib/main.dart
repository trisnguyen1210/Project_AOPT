// Flutter code sample for BottomNavigationBar

// This example shows a [BottomNavigationBar] as it is used within a [Scaffold]
// widget. The [BottomNavigationBar] has three [BottomNavigationBarItem]
// widgets and the [currentIndex] is set to index 0. The selected item is
// amber. The `_onItemTapped` function changes the selected item's index
// and displays a corresponding message in the center of the [Scaffold].
//
// ![A scaffold with a bottom navigation bar containing three bottom navigation
// bar items. The first one is selected.](https://flutter.github.io/assets-for-api-docs/assets/material/bottom_navigation_bar.png)

import 'package:beans/value/res.dart';
import 'package:beans/value/styles.dart';
import 'package:beans/widget/tab/home_tab.dart';
import 'package:beans/widget/bar/sliding_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    HomeTab(),
    Text(
      'Lời nhắc',
      style: optionStyle,
    ),
    Text(
      'Bản xét mình',
      style: optionStyle,
    ),
    Text(
      'Đậu',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: createAppbar(),
      body: Container(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      endDrawer:SlidingMenu(),
      bottomNavigationBar: createBottomNavigationBar(),
    );
  }

  AppBar createAppbar()
  {
    return AppBar(
      title: const Text('Beans'),
      automaticallyImplyLeading: false,
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
          onPressed: () {
            _scaffoldKey.currentState.openEndDrawer();
          },
        )
      ],
    );
  }


  BottomNavigationBar createBottomNavigationBar()
  {
    return  BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon:
          SvgPicture.asset(Res.document, height: 24, color: Colors.blueGrey[400]),
          activeIcon: SvgPicture.asset(
            Res.document,
            height: 24,
            color: Colors.amber[800],
          ),
          title: Text('Nhà', style: Styles.textStyleSmall),
        ),
        BottomNavigationBarItem(
          icon:
          SvgPicture.asset(Res.internet, height: 24, color: Colors.blueGrey[400]),
          activeIcon: SvgPicture.asset(
            Res.internet,
            height: 24,
            color: Colors.amber[800],
          ),
          title: Text('Lời nhắc', style: Styles.textStyleSmall),
        ),
        BottomNavigationBarItem(
          icon:
          SvgPicture.asset(Res.internet, height: 24, color: Colors.blueGrey[400]),
          activeIcon: SvgPicture.asset(
            Res.internet,
            height: 24,
            color: Colors.amber[800],
          ),
          title: Text('Bản xét mình', style: Styles.textStyleSmall),
        ),
        BottomNavigationBarItem(
          icon:
          SvgPicture.asset(Res.internet, height: 24, color: Colors.blueGrey[400]),
          activeIcon: SvgPicture.asset(
            Res.internet,
            height: 24,
            color: Colors.amber[800],
          ),
          title: Text('Đậu', style: Styles.textStyleSmall),
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.amber[800],
      unselectedItemColor: Colors.blueGrey[400],
      showUnselectedLabels: true,
      showSelectedLabels: true,
      type: BottomNavigationBarType.fixed,
      onTap: _onItemTapped,
    );
  }
}
