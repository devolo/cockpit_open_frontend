/*
Copyright © 2021, devolo AG
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree.
*/

import 'dart:ui';

import 'package:cockpit_devolo/generated/l10n.dart';
import 'package:cockpit_devolo/services/handleSocket.dart';
import 'package:cockpit_devolo/shared/alertDialogs.dart';
import 'package:cockpit_devolo/shared/app_colors.dart';
import 'package:cockpit_devolo/shared/app_fontSize.dart';
import 'package:cockpit_devolo/shared/buttons.dart';
import 'package:cockpit_devolo/shared/devolo_icons.dart';
import 'package:cockpit_devolo/shared/helpers.dart';
import 'package:desktop_window/desktop_window.dart';
import 'views/helpSection/supportScreen.dart';
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
import 'package:flutter/foundation.dart';
import 'dart:convert';

import 'models/sizeModel.dart';
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

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DataHand>(create: (_) => DataHand()),
        ChangeNotifierProvider<NetworkList>(create: (_) => NetworkList()),
        ChangeNotifierProvider<SizeModel>(create: (_) => SizeModel(1.0, 1.0)),
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
  
  final GlobalKey<ScaffoldState> _drawerScaffoldKey = new GlobalKey<ScaffoldState>();
  late NetworkList _deviceList;
  double paddingLeftDrawerUnderSection = 60;
  bool helpNavigationCollapsed = false;
  bool selectNetworkCollapsed = false;
  bool highContrast = false; // MediaQueryData().highContrast;  // Query current device if high Contrast theme is set
  PageController pageController = PageController(initialPage: 0, keepPage: true);
  int selectedPage = 0;

  late SizeModel size;

  late DataHand socket;

  // String version;
  // String buildNr;


  @override
  void initState() {
    super.initState();
    
    getConnection();
    readSharedPrefs();
    getVersions();

    size = context.read<SizeModel>();

    if (kReleaseMode) {
      ErrorWidget.builder = (errorDetails) {
        return AlertDialog(
            backgroundColor: backgroundColor,
            content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(S.of(context).errorScreenText, style: TextStyle(color: fontColorOnBackground), textScaleFactor: size.font_factor,),
                  SizedBox(height: 20),
                  TextButton(
                    child: Text(
                      S.of(context).restart,
                      style: TextStyle(fontSize: dialogContentTextFontSize, color: Colors.white),
                      textScaleFactor: size.font_factor,
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



  Future<void> readSharedPrefs() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    // check if sharedPreferences are already created
    var checkSharedPreference = prefs.containsKey("config");

    if(checkSharedPreference){

      dynamic configuration = prefs.get("config");
      var jsonconfig =  await json.decode(configuration);
      config = jsonconfig;

      setWindowSize(jsonconfig["window_width"], jsonconfig["window_height"], jsonconfig["fullscreen"]);

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
      size.font_factor = config["font_size_factor"];
      size.icon_factor = config["icon_size_factor"];

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
      size.font_factor = config["font_size_factor"];

    }




    // Rebuild the Widget to reflect changes to the app
    AppBuilder.of(context)!.rebuild();
  }

  void setWindowSize(width, height, fullscreen) async {
    logger.d("SetWindow");
    await DesktopWindow.setWindowSize(Size(width,height));
    await DesktopWindow.setMinWindowSize(Size(800,600));
    await DesktopWindow.setFullScreen(fullscreen);
  }



  Widget buildPageView() {
    return PageView(
      controller: pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        OverviewScreen(),
        UpdateScreen(
          title: S.of(context).update,
        ),
        SettingsScreen(
          title: S.of(context).settings,
        ),
      ],
    );
  }

  void changePage(int index) {
    setState(() {
      selectedPage = index;
      pageController.jumpToPage(index);
    });
  }



  @override
  Widget build(BuildContext context) {
    _deviceList = Provider.of<NetworkList>(context);
    socket = Provider.of<DataHand>(context);



    if(!socket.connected && widgetsPoped) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        while(Navigator.canPop(context)){ // Navigator.canPop return true if can pop
          logger.i(Navigator.of(context).overlay.toString());
          Navigator.pop(context);
          changePage(0);
        }
      });
      widgetsPoped = false;
    }
    else if(socket.connected && widgetsPoped == false) {
      widgetsPoped = true;
    }

    saveWindowSize();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        centerTitle: true,
        iconTheme: IconThemeData(color: fontColorOnMain),
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(child: Icon(DevoloIcons.logo, color: fontColorOnMain,)),
            Spacer(),
            IconButton(
              icon: const Icon(DevoloIcons.ic_brightness_medium_24px),
              color: fontColorOnMain,
              iconSize: 24 * size.icon_factor,
              tooltip: S.of(context).highContrast,
              onPressed: () {
                setState(() {
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
            IconButton(
              onPressed: (){
                setState(() {
                  if(_drawerScaffoldKey.currentState!.isEndDrawerOpen){
                    Navigator.pop(context);
                  }else{
                    _drawerScaffoldKey.currentState!.openEndDrawer();
                  }
                });
              },
              iconSize: 24 * size.icon_factor,
              icon: _drawerScaffoldKey.currentState == null ? Icon(Icons.menu) : _drawerScaffoldKey.currentState!.isEndDrawerOpen ? Icon(DevoloIcons.devolo_UI_cancel_2) : Icon(Icons.menu),
            ),
          ],
        ),
      ),

      body: Scaffold(
          //second scaffold
          backgroundColor: backgroundColor,
          key:_drawerScaffoldKey, //set gobal key defined above
          onEndDrawerChanged: (isClosed){
            setState(() {
                // to refresh state when drawer is closed by clicking outside of it.
            });
          },
          endDrawer: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: mainColor, //This will change the drawer background.
              hoverColor: Colors.white.withOpacity(0.2),
              primaryIconTheme: IconThemeData(color: fontColorOnMain, size: 24 * size.icon_factor,),
            ),
            child: Padding(padding: EdgeInsets.only(top: 1.0), child:
            Drawer(
                semanticLabel: "menu",
                child: ListView(padding: EdgeInsets.zero, children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: fontColorOnMain, width: 1), top: BorderSide(color: fontColorOnMain, width: 1)),
                    ),
                    child: ListTile(
                      enabled: socket.connected ? true: false,
                      tileColor: (selectedPage == 0) ? Colors.white.withOpacity(0.2) : null,
                      leading: Icon(Icons.workspaces_filled, color: fontColorOnMain, size: 24 * size.icon_factor,), //miscellaneous_services
                      title: Text(S.of(context).overview,
                          style: TextStyle(color: fontColorOnMain),
                          textScaleFactor: size.font_factor),
                      contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal:16.0),
                      onTap: () {
                        changePage(0);
                        Navigator.pop(context); //close drawer
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: fontColorOnMain, width: 1)),
                    ),
                    child: ListTile(
                        enabled: socket.connected ? true: false,
                        tileColor: selectedPage == 1 ? Colors.white.withOpacity(0.2) : null,
                        leading: Icon(DevoloIcons.ic_file_download_24px, color: fontColorOnMain, size: 24 * size.icon_factor,),
                        title: Text(S.of(context).updates,
                            style: TextStyle(color: fontColorOnMain),
                            textScaleFactor: size.font_factor),
                        contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal:16.0),
                        onTap: () {
                          changePage(1);
                          Navigator.pop(context); //close drawer
                        }),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: fontColorOnMain, width: 1)),
                    ),
                    child: ListTile(
                        enabled: socket.connected ? true: false,
                        tileColor: selectedPage == 2 ? Colors.white.withOpacity(0.2) : null,
                        leading: Icon(DevoloIcons.devolo_UI_settings, color: fontColorOnMain, size: 24 * size.icon_factor),
                        title: Text(S.of(context).settings,
                            style: TextStyle(color: fontColorOnMain),
                            textScaleFactor: size.font_factor),
                        contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal:16.0),
                        onTap: () {
                          changePage(2);
                          Navigator.pop(context); //close drawer
                        }),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: fontColorOnMain, width: 1)),
                    ),
                    child: ListTile(
                        enabled: socket.connected ? true: false,
                        tileColor: (!helpNavigationCollapsed && selectedPage == 3) ? Colors.white.withOpacity(0.2) : null,
                        leading: Icon(DevoloIcons.ic_help_24px, color: fontColorOnMain, size: 24 * size.icon_factor),
                        trailing: Icon(helpNavigationCollapsed ? DevoloIcons.ic_remove_24px_1 : DevoloIcons.devolo_UI_add, color: fontColorOnMain, size: 20*size.font_factor),
                        title: Text(S.of(context).help,
                            style: TextStyle(color: fontColorOnMain),
                            textScaleFactor: size.font_factor),
                        contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal:16.0),
                        onTap: () {
                          setState(() {
                            helpNavigationCollapsed = !helpNavigationCollapsed;
                          });
                        }),
                  ),
                  if (helpNavigationCollapsed) ...[
                    Container(
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: fontColorOnMain, width: 1)),
                      ),
                      child: ListTile(
                          enabled: socket.connected ? true: false,
                          tileColor: selectedPage == 3 ? Colors.white.withOpacity(0.2) : null,
                          title: Padding(padding: EdgeInsets.only(left:paddingLeftDrawerUnderSection),child : Text(S.of(context).setUpDevice,
                              style: TextStyle(color: fontColorOnMain),
                              textScaleFactor: size.font_factor
                          ),),
                          contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal:16.0),
                          onTap: () {
                            Navigator.pop(context);
                          notAvailableDialog(context, size);
                          }),
                    ),

                  Container(
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: fontColorOnMain, width: 1)),
                    ),
                    child: ListTile(
                        enabled: socket.connected ? true: false,
                        tileColor: selectedPage == 3 ? Colors.white.withOpacity(0.2) : null,
                        title: Padding(padding: EdgeInsets.only(left:paddingLeftDrawerUnderSection),child : Text(S.of(context).optimizeReception,
                            style: TextStyle(color: fontColorOnMain),
                            textScaleFactor: size.font_factor
                        ),),
                        contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal:16.0),
                        onTap: () {
                          Navigator.pop(context);
                          notAvailableDialog(context, size);
                          }),
                    ),

                  Container(
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: fontColorOnMain, width: 1)),
                    ),
                    child: ListTile(
                        enabled: socket.connected ? true: false,
                        tileColor: selectedPage == 3 ? Colors.white.withOpacity(0.2) : null,
                        title: Padding(padding: EdgeInsets.only(left:paddingLeftDrawerUnderSection),child : Text(S.of(context).contactSupport,
                            style: TextStyle(color: fontColorOnMain),
                            textScaleFactor: size.font_factor
                        ),),
                        contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal:16.0),
                        onTap: () {
                          Navigator.pop(context);
                          loadingSupportDialog(context, socket, size);
                          }),
                    ),
                  ],
                  Container(
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: fontColorOnMain, width: 1)),
                    ),
                    child: ListTile(
                        leading: Icon(DevoloIcons.ic_info_24px, color: fontColorOnMain, size: 24 * size.icon_factor),
                        title: Text(S.of(context).appInfo,
                            style: TextStyle(color: fontColorOnMain),
                            textScaleFactor: size.font_factor),
                        contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal:16.0),
                        onTap: () {
                          Navigator.pop(context); //close drawer
                          _appInfoAlert(context);
                        }),
                  ),
                ])),),
          ),
          body: buildPageView()
      )
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
                getCloseButton(context, size),
                Center(
                    child: Text(
                      S.of(context).appInformation,
                      textAlign: TextAlign.center,
                    ),
                ),
              ],
            ),
            titleTextStyle: TextStyle(color: fontColorOnBackground, fontSize: dialogTitleTextFontSize * size.font_factor),
            contentTextStyle: TextStyle(color: fontColorOnBackground, decorationColor: fontColorOnBackground, fontSize: dialogContentTextFontSize * size.font_factor),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(padding: EdgeInsets.only(right: 110 * size.font_factor),child: Icon(DevoloIcons.logo, color: drawingColor, size: 24 * size.font_factor)),
                GestureDetector(
                    child: Text("\nwww.devolo.de", style: TextStyle(decoration: TextDecoration.underline, color: drawingColor)),
                    onTap: () {
                      launch("https://www.devolo.de/");
                    }),
                SizedBox(
                  height: 20,
                ),
                Text('Cockpit Version: ' + getVersionSyntax()), // from package_info_plus
                SizedBox(height: 20,),
                TextButton(
                  child: Text(
                    S.of(context).showLicences,
                    style: TextStyle(fontSize: dialogContentTextFontSize, color: Colors.white),
                    textScaleFactor: size.font_factor,
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