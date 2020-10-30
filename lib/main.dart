// Flutter code sample for BottomNavigationBar

// This example shows a [BottomNavigationBar] as it is used within a [Scaffold]
// widget. The [BottomNavigationBar] has three [BottomNavigationBarItem]
// widgets and the [currentIndex] is set to index 0. The selected item is
// amber. The `_onItemTapped` function changes the selected item's index
// and displays a corresponding message in the center of the [Scaffold].
//
// ![A scaffold with a bottom navigation bar containing three bottom navigation
// bar items. The first one is selected.](https://flutter.github.io/assets-for-api-docs/assets/material/bottom_navigation_bar.png)

import 'package:beans/provider/auth_provider.dart';
import 'package:beans/provider/registration_provider.dart';
import 'package:beans/utils/utils.dart';
import 'package:beans/value/styles.dart';
import 'package:beans/widget/bean/my_bean.dart';
import 'package:beans/widget/confess/pin_code/pin_code.dart';
import 'package:beans/widget/registration/registration.dart';
import 'package:beans/widget/registration/splash_screen.dart';
import 'package:beans/widget/tab/home_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'generated/r.dart';

void main() => runApp(MaterialApp(
      home: SplashScreen(),
    ));

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthProvider>(
      create: (context) => AuthProvider(),
      child: MaterialApp(
        home: AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          child: Consumer<AuthProvider>(
            builder: (context, auth, child) {
              switch (auth.state) {
                case ViewState.home:
                  return HomeScreen();
                case ViewState.register:
                  return ChangeNotifierProvider<RegistrationProvider>(
                    create: (context) => RegistrationProvider(auth),
                    child: Registration(),
                  );
                case ViewState.loading:
                  return loading();
                default:
                  return loading();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget loading() {
    return Material(
      child: CircularProgressIndicator(),
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
      'Lời Nhắc',
      style: optionStyle,
    ),
    PinCodeScreen(),
    MyBean(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    Utils.setColorStatubBar();
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: createBottomNavigationBar(),
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
            color: Color(0xff316beb),
          ),
          title: Text('Nhà', style: Styles.bottomBarText),
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(R.ic_calendar,
              height: 24, color: Colors.blueGrey[400]),
          activeIcon: SvgPicture.asset(
            R.ic_calendar,
            height: 24,
            color: Color(0xff316beb),
          ),
          title: Text('Lời nhắc', style: Styles.bottomBarText),
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(R.ic_confession,
              height: 24, color: Colors.blueGrey[400]),
          activeIcon: SvgPicture.asset(
            R.ic_confession,
            height: 24,
            color: Color(0xff316beb),
          ),
          title: Text('Bản xét mình', style: Styles.bottomBarText),
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(R.ic_bean,
              height: 24, color: Colors.blueGrey[400]),
          activeIcon: SvgPicture.asset(
            R.ic_bean,
            height: 24,
            color: Color(0xff316beb),
          ),
          title: Text('Đậu', style: Styles.bottomBarText),
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Color(0xff316beb),
      unselectedItemColor: Color(0xff8e8e93),
      showUnselectedLabels: true,
      showSelectedLabels: true,
      type: BottomNavigationBarType.fixed,
      onTap: _onItemTapped,
    );
  }
}
