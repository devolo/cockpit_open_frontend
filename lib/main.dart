/*
Copyright © 2021, devolo AG
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree.
*/

import 'package:cockpit_devolo/generated/l10n.dart';
import 'package:cockpit_devolo/services/handleSocket.dart';
import 'package:cockpit_devolo/shared/app_colors.dart';
import 'package:cockpit_devolo/shared/app_fontSize.dart';
import 'package:cockpit_devolo/shared/buttons.dart';
import 'package:cockpit_devolo/shared/devolo_icons_icons.dart';
import 'package:cockpit_devolo/shared/helpers.dart';
import 'package:cockpit_devolo/views/helpScreen.dart';
import 'package:cockpit_devolo/views/settingsScreen.dart';
import 'package:cockpit_devolo/views/updateScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:cockpit_devolo/models/networkListModel.dart';
import 'package:cockpit_devolo/views/overviewScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cockpit_devolo/views/appBuilder.dart';
import 'package:window_size/window_size.dart';
import 'dart:io';
import 'package:cockpit_devolo/shared/globals.dart';
import 'package:cockpit_devolo/shared/imageLoader.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

import 'models/fontSizeModel.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

void main() {
  //debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;

  //verbose(grey): Use to display objects or XMLData
  //debug(white): Use for normal debug outputs
  //info(blue): Use to highlight interesting parts
  //warn(orange): Use to mark critical parts
  //error(red): Use to output error
  Logger.level = Level.debug;

  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isLinux) {
    setWindowTitle('devolo Cockpit');
  }

  runApp(Phoenix(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DataHand>(create: (_) => DataHand()),
        ChangeNotifierProvider<NetworkList>(create: (_) => NetworkList()),
        ChangeNotifierProvider<FontSize>(create: (_) => FontSize(1.0)),
      ],
      child: Consumer<DataHand>(
        builder: (context, counter, _) {
          return AppBuilder(
            builder: (context) {
              return MaterialApp(
                title: 'devolo Cockpit',
                theme: ThemeData(

                  dialogTheme: DialogTheme(backgroundColor: backgroundColor.withOpacity(0.9)),

                  highlightColor: Colors.transparent,
                  textTheme: Theme.of(context).textTheme.apply(
                        fontFamily: 'OpenSans',
                        displayColor: fontColorOnSecond,
                        bodyColor: fontColorOnSecond,
                        decorationColor: fontColorOnSecond,
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
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int bottomSelectedIndex = 0;
  bool highContrast = false; // MediaQueryData().highContrast;  // Query current device if high Contrast theme is set

  late FontSize fontSize;

  // String version;
  // String buildNr;

  final List<String> languageList = <String>[
    "de",
    "en",
    "fr",
  ];

  @override
  void initState() {
    super.initState();
    loadAllDeviceIcons();

    getConnection();
    readSharedPrefs();
    getVersions();

    fontSize = context.read<FontSize>();

    if (kReleaseMode) {
      ErrorWidget.builder = (errorDetails) {
        return AlertDialog(
            backgroundColor: backgroundColor,
            content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(S.of(context).errorScreenText, style: TextStyle(color: fontColorOnBackground), textScaleFactor: fontSize.factor,),
                  SizedBox(height: 20),
                  TextButton(
                    child: Text(
                      S.of(context).restart,
                      style: TextStyle(fontSize: dialogContentTextFontSize, color: Colors.white),
                      textScaleFactor: fontSize.factor,
                    ),
                    onPressed: () {
                      Phoenix.rebirth(context);
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                              (states) {
                            if (states.contains(MaterialState.hovered)) {
                              return devoloGreen.withOpacity(hoverOpacity);
                            } else if (states.contains(MaterialState.pressed)) {
                              return devoloGreen.withOpacity(activeOpacity);
                            }
                            return devoloGreen;
                          },
                        ),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(vertical: 13.0, horizontal: 32.0)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            )
                        )
                    ),
                  )
                ]));
      };
    }
  }


  // Future<void> getVersion() async {
  //   if (Platform.isLinux) {
  //     File f = new File("data/flutter_assets/version.json");
  //     f.readAsString().then((String text) {
  //       Map<String, dynamic> versionJSON = jsonDecode(text);
  //       logger.i(versionJSON['version']);
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

      dynamic configuration = prefs.get("config");
      var jsonconfig = json.decode(configuration);

      config = jsonconfig;

      if(config["language"] == ""){
        if(Localizations.localeOf(context).languageCode == "und") { // This must not be null. It may be 'und', representing 'undefined'. See flutter documentation
          config["language"] = "en";
        }
        else{
          config["language"] = Localizations.localeOf(context).languageCode;
        }
        saveToSharedPrefs(config);
      }

      // prevent flutter to take the local language when config is different
      if(config["language"] != Localizations.localeOf(context).languageCode){
        S.load(Locale(config["language"], ''));
      }

      setTheme(jsonconfig["theme"]);
      fontSize.factor = config["font_size_factor"];
    }

    else{
      if(Localizations.localeOf(context).languageCode == "und") { // This must not be null. It may be 'und', representing 'undefined'. See flutter documentation
        config["language"] = "en";
      }
      else{
        config["language"] = Localizations.localeOf(context).languageCode;
      }
      saveToSharedPrefs(config);

      setTheme(config["theme"]);
      fontSize.factor = config["font_size_factor"];
    }


    // Rebuild the Widget to reflect changes to the app
    AppBuilder.of(context)!.rebuild();
  }

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(icon: Icon(Icons.workspaces_filled), label: S.of(context).overview, tooltip: ""),
      BottomNavigationBarItem(
        icon: Icon(DevoloIcons.ic_file_download_24px),
        label: S.of(context).update,
        tooltip: "",
      ),
      BottomNavigationBarItem(icon: Icon(DevoloIcons.ic_help_24px), label: S.of(context).help, tooltip: "",),
      BottomNavigationBarItem(
        icon: Icon(DevoloIcons.devolo_UI_settings),
        label: S.of(context).settings,
        tooltip: "",
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
        AddDeviceScreen(title: "Help screen"),
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
      pageController.jumpToPage(index);
    });
  }

  String? getPathForLanguage(String language){
    if(language == "de")
      return  "assets/flagImages/devolo_DE.png";

    else if(language == "fr")
      return  "assets/flagImages/devolo_FR.png";

    else if(language == "gb" || language == "en")
      return  "assets/flagImages/devolo_UK.png";
  }

  @override
  Widget build(BuildContext context) {
    // double mediaFontScaleFactor =  MediaQuery.textScaleFactorOf(context); // Query current device for the System FontSize
    // logger.i('SIZE:  ${mediaFontScaleFactor}');

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        centerTitle: true,
        iconTheme: IconThemeData(color: fontColorOnMain),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(child: Icon(DevoloIcons.logo, color: fontColorOnMain,)),
            Spacer(),
            DropdownButton<String>(
              value: config["language"] == "" ? "en" : config["language"], // this had to be done, because config["language"] isn´t directly initialized as reading SharedPreferences needs some time
              dropdownColor: secondColor,
              //isDense: true,
              elevation: 8,
              style: TextStyle(color: fontColorOnSecond),
              iconEnabledColor: fontColorOnMain,
              underline: Container(
                height: 0,
                color: secondColor,
              ),
              onChanged: (String? newValue2) {
                setState(() {
                  config["language"] = newValue2;
                  //logger.i(newValue2);
                  S.load(Locale(newValue2!, ''));
                });
                AppBuilder.of(context)!.rebuild();
                saveToSharedPrefs(config);
              },
              selectedItemBuilder: (BuildContext context) {
                return languageList.map((String value) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.asset(getPathForLanguage(value)!, height: 20, width: 20, fit: BoxFit.fill),
                    ],
                  );
                }).toList();
              },
              items: languageList.map<DropdownMenuItem<String>>((String _value2) {
                return DropdownMenuItem<String>(
                  value: _value2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        _value2 + " ",
                        textScaleFactor: fontSize.factor,
                      ),
                      Image.asset(getPathForLanguage(_value2)!, height: 20, width: 20, fit: BoxFit.fill),
                    ],
                  ),
                );
              }).toList(),
            ),
            IconButton(
              icon: const Icon(DevoloIcons.ic_brightness_medium_24px),
              color: fontColorOnMain,
              tooltip: S.of(context).highContrast,
              onPressed: () {
                setState(() {
                  //logger.i("Theme: " + config["theme"]);
                  //logger.i("Prev Theme: " + config["previous_theme"]);

                  if (config["theme"] == "High Contrast") {
                    config["theme"] = config["previous_theme"];
                    setTheme(config["previous_theme"]);
                  } else {
                    config["previous_theme"] = config["theme"];
                    config["theme"] = theme_highContrast["name"];
                    setTheme(theme_highContrast["name"]);
                  }

                  saveToSharedPrefs(config);
                  AppBuilder.of(context)!.rebuild();
                  //showNetwork = !showNetwork;
                });
              },
            ),
          ],
        ),
      ),
      endDrawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: mainColor, //This will change the drawer background.
          hoverColor: Colors.white.withOpacity(0.2),
          primaryIconTheme: IconThemeData(color: fontColorOnMain),
          //hoverColor: mainColor.withOpacity(0.7), doesn´t work !!!
        ),


        child: Drawer(
            semanticLabel: "menu",
            child: ListView(padding: EdgeInsets.zero, children: <Widget>[
              DrawerHeader(
                child: Text(
                  "devolo Cockpit",
                  style: TextStyle(fontSize: 23 * fontSize.factor, color: fontColorOnMain),
                ),
                margin: EdgeInsets.only(bottom: 0),
                padding: EdgeInsets.symmetric(vertical: 50.0, horizontal:16.0),
              ),
              Container(

                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: fontColorOnMain, width: 2), top: BorderSide(color: fontColorOnMain, width: 2)),
                ),
                child: ListTile(
                    leading: Icon(Icons.workspaces_filled, color: fontColorOnMain, size: 24*fontSize.factor), //miscellaneous_services
                    title: Text(S.of(context).overview,
                        style: TextStyle(color: fontColorOnMain),
                        textScaleFactor: fontSize.factor),
                    contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal:16.0),
                    onTap: () {
                      bottomTapped(0);
                      Navigator.pop(context); //close drawer
                    },
                ),

              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: fontColorOnMain, width: 2)),
                ),
                child: ListTile(
                    leading: Icon(DevoloIcons.ic_file_download_24px, color: fontColorOnMain, size: 24*fontSize.factor),
                    title: Text(S.of(context).updates,
                        style: TextStyle(color: fontColorOnMain),
                        textScaleFactor: fontSize.factor),
                    contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal:16.0),
                    onTap: () {
                      bottomTapped(1);
                      Navigator.pop(context); //close drawer
                    }),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: fontColorOnMain, width: 2)),
                ),
                child: ListTile(
                    leading: Icon(DevoloIcons.ic_help_24px, color: fontColorOnMain, size: 24*fontSize.factor),
                    title: Text(S.of(context).help,
                        style: TextStyle(color: fontColorOnMain),
                        textScaleFactor: fontSize.factor),
                    contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal:16.0),
                    onTap: () {
                      bottomTapped(2);
                      Navigator.pop(context); //close drawer
                    }),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: fontColorOnMain, width: 2)),
                ),
                child: ListTile(
                    leading: Icon(DevoloIcons.devolo_UI_settings, color: fontColorOnMain, size: 24*fontSize.factor),
                    title: Text(S.of(context).settings,
                        style: TextStyle(color: fontColorOnMain),
                        textScaleFactor: fontSize.factor),
                    contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal:16.0),
                    onTap: () {
                      bottomTapped(3);
                      Navigator.pop(context); //close drawer
                    }),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: fontColorOnMain, width: 2)),
                ),
                child: ListTile(
                    leading: Icon(DevoloIcons.ic_info_24px, color: fontColorOnMain, size: 24*fontSize.factor),
                    title: Text(S.of(context).appInfo,
                        style: TextStyle(color: fontColorOnMain),
                        textScaleFactor: fontSize.factor),
                    contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal:16.0),
                    onTap: () {
                      Navigator.pop(context); //close drawer
                      _appInfoAlert(context);
                    }),
              ),
            ])),
      ),
      body: buildPageView(),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: mainColor,
        unselectedItemColor: fontColorOnMain,
        selectedItemColor: fontColorOnMain,
        selectedIconTheme: IconThemeData(size: 35),
        selectedFontSize: 16 * fontSize.factor,
        unselectedFontSize: 14 * fontSize.factor,
        currentIndex: bottomSelectedIndex,
        onTap: (index) {
          bottomTapped(index);
        },
        items: buildBottomNavBarItems(),
      ),
    );
  }

  //added showLicenses button manually!!!
  void _appInfoAlert(context) {
    //ToDo not working yet, switch _index and rebuild
    showDialog<void>(
        context: context,
        barrierDismissible: true, // user doesn't need to tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: [
                getCloseButton(context),
                Center(
                    child: Text(
                      S.of(context).appInformation,
                      textAlign: TextAlign.center,
                    ),
                ),
              ],
            ),
            titleTextStyle: TextStyle(color: fontColorOnBackground, fontSize: dialogTitleTextFontSize * fontSize.factor),
            contentTextStyle: TextStyle(color: fontColorOnBackground, decorationColor: fontColorOnBackground, fontSize: dialogContentTextFontSize * fontSize.factor),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(padding: EdgeInsets.only(right: 110 * fontSize.factor),child: Icon(DevoloIcons.logo, color: drawingColor, size: 24 * fontSize.factor)),
                GestureDetector(
                    child: Text("\nwww.devolo.de", style: TextStyle(decoration: TextDecoration.underline, color: drawingColor)),
                    onTap: () {
                      launch("https://www.devolo.de/");
                    }),
                SizedBox(
                  height: 20,
                ),
                Text('Cockpit Version: ${versionCockpit.toString()}'), // from package_info_plus
                SizedBox(height: 20,),
                TextButton(
                  child: Text(
                    S.of(context).showLicences,
                    style: TextStyle(fontSize: dialogContentTextFontSize, color: Colors.white),
                    textScaleFactor: fontSize.factor,
                  ),
                  onPressed: () {
                    Navigator.maybeOf(context)!.pop(true);
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                            (states) {
                          if (states.contains(MaterialState.hovered)) {
                            return devoloGreen.withOpacity(hoverOpacity);
                          } else if (states.contains(MaterialState.pressed)) {
                            return devoloGreen.withOpacity(activeOpacity);
                          }
                          return devoloGreen;
                        },
                      ),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(vertical: 13.0, horizontal: 32.0)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          )
                      )
                  ),
                ),
              ],
            ),
            actions: <Widget>[
            ],
          );
        });
  }
}