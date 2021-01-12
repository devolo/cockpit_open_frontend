import 'package:cockpit_devolo/services/handleSocket.dart';
import 'package:cockpit_devolo/shared/app_colors.dart';
import 'package:cockpit_devolo/shared/helpers.dart';
import 'package:cockpit_devolo/views/emptyScreen.dart';
import 'package:cockpit_devolo/views/networkSettingsScreen.dart';
import 'package:cockpit_devolo/views/settingsScreen.dart';
import 'package:cockpit_devolo/views/updateScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:cockpit_devolo/models/deviceModel.dart';

import 'package:cockpit_devolo/views/overviewScreen.dart';

void main() {
  //debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  runApp(
      MyApp()
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<dataHand>(create: (_) => dataHand()),
      ChangeNotifierProvider<DeviceList>(create: (_) => DeviceList()),
    ],
      child: Consumer<dataHand>(
        builder: (context, counter, _) {
          return MaterialApp(
            home: MyHomePage(title: 'devolo Cockpit'),
          );
        },
      ),
    );
  }
}

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//
//     return MaterialApp(
//       title: 'Devolo Cockpit',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         backgroundColor: devoloBlue,
//         canvasColor: Colors.white,
//       ),
//       home: MultiProvider(providers: [
//       ChangeNotifierProvider<dataHand>(create: (_) => dataHand()),
//       ChangeNotifierProvider<DeviceList>(create: (_) => DeviceList()),
//     ],
//     child: MyHomePage(title: 'devolo Cockpit'),
//       ));
//   }
// }

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextStyle _menuItemStyle;
  int bottomSelectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _menuItemStyle = TextStyle(color: devoloBlue, fontFamily: 'Roboto', decorationColor: devoloBlue);
    loadAllDeviceIcons();
  }

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(
          icon: Icon(Icons.settings_rounded),
          label: "Settings"
      ),
      BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: "Home"
      ),
      BottomNavigationBarItem(
          icon: Icon(Icons.download_rounded),
          label: "Update"
      ),
      BottomNavigationBarItem(
          icon: Icon(Icons.add_circle),
          label: "Hinzufügen"
      ),
    ];
  }

  PageController pageController = PageController(
    initialPage: 1,
    keepPage: true,
  );

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        SettingsScreen(title: "Einstellungen",),
        OverviewScreen(),
        UpdateScreen(title: "Update",),
        UpdateScreen(),
      ],
    );
  }

  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceList = Provider.of<DeviceList>(context);
    final socket = Provider.of<dataHand>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: devoloBlue,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            InkWell(
                child: SvgPicture.asset('assets/logo.svg', height: 24, color: Colors.white)
            ),
            Spacer(),
            SizedBox(width: 56)
          ],
        ),
      ),
      drawer: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: <Widget>[
            DrawerHeader(
              child: Text('Home Network Desktop', style: TextStyle(fontSize: 23),),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
            ),
            ListTile(
                leading: Icon(Icons.workspaces_filled,color: devoloBlue), //miscellaneous_services
                title: Text('Network Overview', style: _menuItemStyle),
                onTap: () {
                  bottomTapped(1);
                  Navigator.pop(context); //close drawer
                }),
            ListTile(
                leading: Icon(Icons.download_rounded, color: devoloBlue),
                title: Text('Updates', style: _menuItemStyle),
                onTap: () {
                  bottomTapped(2);
                  Navigator.pop(context); //close drawer
                  // Navigator.push(
                  //   context,
                  //   new MaterialPageRoute(
                  //       builder: (context) => UpdateScreen(title: "Updates", deviceList: deviceList)),
                  // );
                }),
            ListTile(
                leading: Icon(Icons.wifi, color: devoloBlue),
                title: Text('Network Settings', style: _menuItemStyle),
                onTap: () {
                  Navigator.pop(context); //close drawer
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => NetworkSettingsScreen(title: "Network Settings")),
                  );
                }),
            ListTile(
                leading: Icon(Icons.miscellaneous_services, color: devoloBlue),
                title: Text('App Settings', style: _menuItemStyle),
                onTap: () {
                  bottomTapped(0);
                  Navigator.pop(context); //close drawer
                }),
          ])),
      body: buildPageView(),
      bottomNavigationBar: BottomNavigationBar(
        type : BottomNavigationBarType.fixed,
        backgroundColor: devoloBlue,
        unselectedItemColor: Colors.blue[200],
        selectedItemColor: Colors.white,
        selectedIconTheme: IconThemeData(size: 35),
        selectedFontSize: 15,
        currentIndex: bottomSelectedIndex,
        onTap: (index) {
          bottomTapped(index);
        },
        items: buildBottomNavBarItems(),
      ),
    );
  }
}
