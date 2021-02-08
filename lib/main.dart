import 'package:cockpit_devolo/generated/l10n.dart';
import 'package:cockpit_devolo/services/handleSocket.dart';
import 'package:cockpit_devolo/shared/app_colors.dart';
import 'package:cockpit_devolo/shared/helpers.dart';
import 'package:cockpit_devolo/views/addScreen.dart';
import 'package:cockpit_devolo/views/settingsScreen.dart';
import 'package:cockpit_devolo/views/updateScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:cockpit_devolo/models/networkListModel.dart';
import 'package:cockpit_devolo/views/overviewNetworksScreen.dart';
import 'package:cockpit_devolo/views/overviewScreen.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  //debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<dataHand>(create: (_) => dataHand()),
        ChangeNotifierProvider<NetworkList>(create: (_) => NetworkList()),
      ],
      child: Consumer<dataHand>(
        builder: (context, counter, _) {
          return MaterialApp(
            title: 'Devolo Cockpit',
            theme: ThemeData(
              //primarySwatch: Colors.white,
              backgroundColor: backgroundColor,
              canvasColor: Colors.white,
              //highlightColor: Colors.green,
              textTheme: Theme.of(context).textTheme.apply(
                fontSizeFactor: fontSizeFactor,
                fontSizeDelta: fontSizeDelta,
                displayColor: fontColorDark,
                bodyColor: fontColorDark,
                decorationColor: fontColorDark,
              ),
            ),
            localizationsDelegates: [
              // ... app-specific localization delegate[s] here
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              S.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            /*supportedLocales: [
              const Locale('en', ''), // English
              const Locale('de', ''), // Deutsch
              // ... other locales the app supports
            ],*/
            home: MyHomePage(title: 'devolo Cockpit'),
          );
        },
      ),
    );
  }
}

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
    _menuItemStyle = TextStyle(color: mainColor, fontFamily: 'Roboto', decorationColor: mainColor);
    loadAllDeviceIcons();
  }

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: S.of(context).settings,),
      BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: S.of(context).overview),
      BottomNavigationBarItem(icon: Icon(Icons.download_rounded), label: S.of(context).update,),
      BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: S.of(context).add),
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
        SettingsScreen(
          title: S.of(context).settings,
        ),
        showNetwork?OverviewNetworksScreen(): OverviewScreen(),
        UpdateScreen(
          title: S.of(context).update,
        ),
        AddDeviceScreen(),

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

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Spacer(), InkWell(child: SvgPicture.asset('assets/logo.svg', height: 24, color: drawingColor)), Spacer(), SizedBox(width: 56)],
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.workspaces_filled),
            tooltip: S.of(context).changeNetworkview,
            onPressed: () {
              setState(() {
                showNetwork = !showNetwork;
              });
              },
          ),
        ],
      ),
      drawer: Drawer(
        semanticLabel: "menu",
          child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
        DrawerHeader(
          child: Text(
            S.of(context).homeNetworkDesktop,
            style: TextStyle(fontSize: 23, color: drawingColor),
          ),
          decoration: BoxDecoration(
            color: mainColor,
          ),
        ),
        ListTile(
            leading: Icon(Icons.workspaces_filled, color: mainColor), //miscellaneous_services
            title: Text(S.of(context).networkoverview, style: _menuItemStyle),
            //tileColor: devoloBlue,
            onTap: () {
              bottomTapped(1);
              Navigator.pop(context); //close drawer
            }),
        ListTile(
            leading: Icon(Icons.download_rounded, color: mainColor),
            title: Text(S.of(context).updates, style: _menuItemStyle),
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
            leading: Icon(Icons.add_circle, color: mainColor),
            title: Text(S.of(context).addDevice, style: _menuItemStyle),
            onTap: () {
              bottomTapped(3);
              Navigator.pop(context); //close drawer
            }),
        ListTile(
            leading: Icon(Icons.miscellaneous_services, color: mainColor),
            title: Text(S.of(context).settings, style: _menuItemStyle),
            onTap: () {
              bottomTapped(0);
              Navigator.pop(context); //close drawer
            }),
        ListTile(
            leading: Icon(Icons.info_outline_rounded, color: mainColor),
            title: Text(S.of(context).appInfo, style: _menuItemStyle),
            onTap: () {
              Navigator.pop(context); //close drawer
              _appInfoAlert(context);
            }),
      ])),
      body: buildPageView(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: mainColor,
        unselectedItemColor: secondColor,
        selectedItemColor: fontColorLight,
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

  void _appInfoAlert(context) {
    //ToDo not working yet, switch _index and rebuild
    showDialog<void>(
        context: context,
        barrierDismissible: true, // user doesn't need to tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(S.of(context).appInformation),
            content: Container(
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.center,
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/logo.svg', height: 24, color: drawingColor),
                  Text("Version 0 01.01.2021\n"), // ToDo
                  //launch("https://www.devolo.de/"),
                  GestureDetector(
                      child: Text("\nwww.devolo.de", style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue)),
                      onTap: () {
                        launch("https://www.devolo.de/");
                      })
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Icon(
                  Icons.check_circle_outline,
                  size: 35,
                  color: mainColor,
                ), //Text('Bestätigen'),
                onPressed: () {
                  // Critical things happening here

                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
