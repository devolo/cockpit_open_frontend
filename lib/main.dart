/*
Copyright (c) 2021, devolo AG
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree.
*/

import 'package:cockpit_devolo/generated/l10n.dart';
import 'package:cockpit_devolo/services/handleSocket.dart';
import 'package:cockpit_devolo/shared/app_colors.dart';
import 'package:cockpit_devolo/shared/helpers.dart';
import 'package:cockpit_devolo/views/helpScreen.dart';
import 'package:cockpit_devolo/views/settingsScreen.dart';
import 'package:cockpit_devolo/views/updateScreen.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:cockpit_devolo/models/networkListModel.dart';
import 'package:cockpit_devolo/views/overviewScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cockpit_devolo/views/appBuilder.dart';
import 'package:window_size/window_size.dart';
import 'dart:io';
import 'package:cockpit_devolo/shared/globals.dart';

import 'package:package_info_plus/package_info_plus.dart';
import 'dart:convert';

//TestComment
//TestComment2

void main() {
  //debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('devolo Cockpit');
  }

  runApp(new MyApp());
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
          return AppBuilder(
            builder: (context) {
              return MaterialApp(
                title: 'devolo Cockpit',
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
  int bottomSelectedIndex = 0;
  bool highContrast = false; // MediaQueryData().highContrast;  // Query current device if high Contrast theme is set

  // String version;
  // String buildNr;

  final List<String> languageList = <String>[
    "de",
    "en",
  ];

  @override
  void initState() {
    super.initState();
    _menuItemStyle = TextStyle(color: Colors.white, fontFamily: 'Roboto', decorationColor: fontColorLight);
    loadAllDeviceIcons();

    print('CONTRAST:  ${highContrast}');
    if (highContrast == true) config["high_contrast"] = true;

    getConnection();
    readSharedPrefs();
    //getVersion();
  }

  // Future<void> getVersion() async {
  //   if (Platform.isLinux) {
  //     File f = new File("data/flutter_assets/version.json");
  //     f.readAsString().then((String text) {
  //       Map<String, dynamic> versionJSON = jsonDecode(text);
  //       print(versionJSON['version']);
  //       versionName = versionJSON['version'];
  //       buildNum = versionJSON['build_number'];
  //     });
  //   }
  //   else{
  //     PackageInfo packageInfo = await PackageInfo.fromPlatform();
  //     version = packageInfo.version;
  //     buildNr = packageInfo.buildNumber;
  //   }
  // }

  Future<void> readSharedPrefs() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    // check if sharedPreferences are already created
    var checkSharedPreference = prefs.containsKey("config");

    if(checkSharedPreference){

      var configuration = prefs.get("config");
      var jsonconfig = json.decode(configuration);

      config = jsonconfig;

      if(config["language"] == ""){
        config["language"] = Localizations.localeOf(context).toString();
        saveToSharedPrefs(config);
      }

      // prevent flutter to take the local language when config is different
      if(config["language"] != Localizations.localeOf(context).toString()){
        S.load(Locale(config["language"], ''));
      }

      setTheme(jsonconfig["theme"]);
      fontSizeFactor = config["font_size_factor"];
    }

    else{
      config["language"] = Localizations.localeOf(context).toString();
      saveToSharedPrefs(config);

      setTheme(config["theme"]);
      fontSizeFactor = config["font_size_factor"];
    }

    // TODO Needed?
    //AppBuilder.of(context).rebuild();
  }

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(icon: Icon(Icons.workspaces_filled), label: S.of(context).overview),
      BottomNavigationBarItem(
        icon: Icon(Icons.download_rounded),
        label: S.of(context).update,
      ),
      BottomNavigationBarItem(icon: Icon(Icons.help), label: S.of(context).help),
      BottomNavigationBarItem(
        icon: Icon(Icons.settings_rounded),
        label: S.of(context).settings,
      ),
    ];
  }

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        OverviewScreen(),
        UpdateScreen(
          title: S.of(context).update,
        ),
        AddDeviceScreen(),
        SettingsScreen(
          title: S.of(context).settings,
        ),
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
      //pageController.jumpToPage(index);
      pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    // double mediaFontScaleFactor =  MediaQuery.textScaleFactorOf(context); // Query current device for the System FontSize
    // print('SIZE:  ${mediaFontScaleFactor}');

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(child: SvgPicture.asset('assets/logo.svg', height: 24, color: drawingColor)),
            Spacer(),
            DropdownButton<String>(
              //value: dropdownVal == null? "de": dropdownVal,
              isDense: true,
              icon: Row(
                children: [
                  Flag(
                    config["language"] == 'en' ? 'gb' : config["language"], // ToDo which flag?
                    height: 15,
                    width: 25,
                    fit: BoxFit.fill,
                  ),
                  Icon(
                    Icons.arrow_drop_down_rounded,
                    color: fontColorLight,
                  ),
                ],
              ),
              iconSize: 24,
              elevation: 8,
              style: TextStyle(color: fontColorLight),
              underline: Container(
                height: 2,
                color: mainColor,
              ),
              onChanged: (String newValue2) {
                setState(() {
                  config["language"] = newValue2;
                  print(newValue2);
                  S.load(Locale(newValue2, ''));
                });
                AppBuilder.of(context).rebuild();
                saveToSharedPrefs(config);
              },
              items: languageList.map<DropdownMenuItem<String>>((String _value2) {
                return DropdownMenuItem<String>(
                  value: _value2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _value2 + " ",
                        style: TextStyle(color: fontColorDark),
                      ),
                      Flag(
                        _value2 == 'en' ? 'gb' : _value2, // ToDo which flag?
                        height: 15,
                        width: 25,
                        fit: BoxFit.fill,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            IconButton(
              icon: const Icon(Icons.brightness_6_rounded),
              tooltip: S.of(context).highContrast,
              onPressed: () {
                setState(() {
                  print("Theme: " + config["theme"]);
                  print("Prev Theme: " + config["previous_theme"]);

                  if (config["theme"] == "High Contrast") {
                    config["theme"] = config["previous_theme"];
                    setTheme(config["previous_theme"]);
                  } else {
                    config["previous_theme"] = config["theme"];
                    config["theme"] = theme_highContrast["name"];
                    setTheme(theme_highContrast["name"]);
                  }

                  saveToSharedPrefs(config);
                  AppBuilder.of(context).rebuild();
                  //showNetwork = !showNetwork;
                });
              },
            ),
          ],
        ),
        // actions: <Widget>[
        //   IconButton(
        //     icon: const Icon(Icons.brightness_6_rounded),
        //     tooltip: S.of(context).highContrast,
        //     onPressed: () {
        //       setState(() {
        //         print("Theme: " + config["theme"]);
        //         print("Prev Theme: " + config["previous_theme"]);
        //
        //         if (config["theme"] == "High Contrast") {
        //           config["theme"] = config["previous_theme"];
        //           setTheme(config["previous_theme"]);
        //         } else {
        //           config["previous_theme"] = config["theme"];
        //           config["theme"] = theme_highContrast["name"];
        //           setTheme(theme_highContrast["name"]);
        //         }
        //         AppBuilder.of(context).rebuild();
        //         //showNetwork = !showNetwork;
        //       });
        //     },
        //   ),
        //   //Padding(padding: EdgeInsets.only(left:50))
        //   IconButton(icon: Icon(Icons.menu), onPressed: ()  {_scaffoldKey.currentState.openDrawer();}),
        //],
      ),
      endDrawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: mainColor, //This will change the drawer background.
          hoverColor: accentColor,
          //other styles
        ),
        child: Drawer(
            semanticLabel: "menu",
            child: ListView(padding: EdgeInsets.zero, children: <Widget>[
              DrawerHeader(
                child: Text(
                  S.of(context).homeNetworkDesktop,
                  style: TextStyle(fontSize: 23, color: drawingColor),
                ),
                margin: EdgeInsets.only(bottom: 0),
                decoration: BoxDecoration(
                  color: mainColor,
                ),
              ),
              Divider(color: fontColorLight, thickness: 2,),
              ListTile(
                  leading: Icon(Icons.workspaces_filled, color: fontColorLight), //miscellaneous_services
                  title: Text(S.of(context).overview, style: _menuItemStyle),
                  //tileColor: devoloBlue,
                  onTap: () {
                    bottomTapped(0);
                    Navigator.pop(context); //close drawer
                  }),
              Divider(color: fontColorLight, thickness: 2,),
              ListTile(
                  leading: Icon(Icons.download_rounded, color: fontColorLight),
                  title: Text(S.of(context).updates, style: _menuItemStyle),
                  onTap: () {
                    bottomTapped(1);
                    Navigator.pop(context); //close drawer
                    // Navigator.push(
                    //   context,
                    //   new MaterialPageRoute(
                    //       builder: (context) => UpdateScreen(title: "Updates", deviceList: deviceList)),
                    // );
                  }),
              Divider(color: fontColorLight, thickness: 2,),
              ListTile(
                  leading: Icon(Icons.help, color: fontColorLight),
                  title: Text(S.of(context).help, style: _menuItemStyle),
                  onTap: () {
                    bottomTapped(2);
                    Navigator.pop(context); //close drawer
                  }),
              Divider(color: fontColorLight, thickness: 2,),
              ListTile(
                  leading: Icon(Icons.miscellaneous_services, color: fontColorLight),
                  title: Text(S.of(context).settings, style: _menuItemStyle),
                  onTap: () {
                    bottomTapped(3);
                    Navigator.pop(context); //close drawer
                  }),
              Divider(color: fontColorLight,thickness: 2,),
              ListTile(
                  leading: Icon(Icons.info_outline_rounded, color: fontColorLight),
                  title: Text(S.of(context).appInfo, style: _menuItemStyle),
                  onTap: () {
                    Navigator.pop(context); //close drawer
                    _appInfoAlert(context);
                  }),
              Divider(color: fontColorLight,thickness: 2,),

            ])),
      ),
      body: buildPageView(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: mainColor,
        unselectedItemColor: secondColor,
        selectedItemColor: fontColorLight,
        selectedIconTheme: IconThemeData(size: 35),
        selectedFontSize: 16 * fontSizeFactor,
        unselectedFontSize: 14 * fontSizeFactor,
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
            title: Text(
              S.of(context).appInformation,
              textAlign: TextAlign.center,
              style: TextStyle(color: fontColorLight),
            ),
            backgroundColor: mainColor,
            contentTextStyle: TextStyle(color: Colors.white, decorationColor: Colors.white, fontSize: 18),
            content: Container(
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.center,
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/logo.svg', height: 20, color: drawingColor),
                  GestureDetector(
                      child: Text("\nwww.devolo.de", style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue)),
                      onTap: () {
                        launch("https://www.devolo.de/");
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  Text('Frontend Version: ${version_frontend.toString()}'), // from package_info_plus
                  Text('Installed Backend Version: ${version_backend.toString()}'), // from package_info_plus
                  SizedBox(height: 20,),
                  RaisedButton(onPressed: () {
                    Navigator.push(
                      context,
                      new MaterialPageRoute(builder: (context) => new LicensePage()),
                    );
                  },
                  child: Text("show Licences"))
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
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
