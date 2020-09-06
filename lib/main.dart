// Flutter code sample for BottomNavigationBar

// This example shows a [BottomNavigationBar] as it is used within a [Scaffold]
// widget. The [BottomNavigationBar] has three [BottomNavigationBarItem]
// widgets and the [currentIndex] is set to index 0. The selected item is
// amber. The `_onItemTapped` function changes the selected item's index
// and displays a corresponding message in the center of the [Scaffold].
//
// ![A scaffold with a bottom navigation bar containing three bottom navigation
// bar items. The first one is selected.](https://flutter.github.io/assets-for-api-docs/assets/material/bottom_navigation_bar.png)

import 'package:beans/value/gradient.dart';
import 'package:beans/value/styles.dart';
import 'package:beans/widget/bar/sliding_menu.dart';
import 'package:beans/widget/registration/registration.dart';
import 'package:beans/widget/tab/home_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

import 'generated/r.dart';

void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Registration(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      endDrawer: SlidingMenu(),
      bottomNavigationBar: createBottomNavigationBar(),
    );
  }

  GradientAppBar createAppbar() {
    return GradientAppBar(
      centerTitle: false,
      titleSpacing: 0.0,
      title: Container(
        margin: EdgeInsets.only(left: 16),
        child: SvgPicture.asset(
          R.ic_snowman,
          width: 99,
          height: 43,
        ),
      ),
      gradient: GradientApp.gradientAppbar,
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

  BottomNavigationBar createBottomNavigationBar() {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon:
              SvgPicture.asset(R.ic_home, height: 24, color: Color(0xff8e8e93)),
          activeIcon: SvgPicture.asset(
            R.ic_home,
            height: 24,
            color: Color(0xff9b3790),
          ),
          title: Text('Nhà', style: Styles.bottomBarText),
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(R.ic_calendar,
              height: 24, color: Color(0xff8e8e93)),
          activeIcon: SvgPicture.asset(
            R.ic_calendar,
            height: 24,
            color: Color(0xff9b3790),
          ),
          title: Text('Lời nhắc', style: Styles.bottomBarText),
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(R.ic_confession,
              height: 24, color: Color(0xff8e8e93)),
          activeIcon: SvgPicture.asset(
            R.ic_confession,
            height: 24,
            color: Color(0xff9b3790),
          ),
          title: Text('Bản xét mình', style: Styles.bottomBarText),
        ),
        BottomNavigationBarItem(
          icon:
          SvgPicture.asset(R.ic_bean, height: 24, color: Color(0xff8e8e93)),
          activeIcon: SvgPicture.asset(
            R.ic_bean,
            height: 24,
            color: Color(0xff9b3790),
          ),
          title: Text('Đậu', style: Styles.bottomBarText),
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Color(0xff9b3790),
      unselectedItemColor: Color(0xff8e8e93),
      showUnselectedLabels: true,
      showSelectedLabels: true,
      type: BottomNavigationBarType.fixed,
      onTap: _onItemTapped,
    );
  }
}
