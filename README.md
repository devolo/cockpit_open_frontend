# Cockpit open frontend

A devolo Cockpit alternative Flutter front end. This Flutter Cockpit connects with the existing devolo Cockpit backend and is a proof of concept for the Cockpit front end, build with Flutter desktop.
The program provides information about the connection speed of all adapters on the network. This makes it possible to immediately see how high the data transmission is, for example, between the study and the living room. If new firmware updates are available for our powerline adapters, the update can be applied directly via the network. In addition to status displays, "devolo Cockpit" also provides control over encryption and configuration. 


## Getting Started

### Requirements
- devolo Cockpit https://www.devolo.de/support/downloads/download/devolo-cockpit
- Flutter SDK
- Android Studio or Visual Studio Code (with _Flutter_, _Dart_ and _Flutter Intl_ plugin) (see: https://flutter.dev/docs/get-started/editor?tab=androidstudio)
- Enable developer mode in Windows 10 
- more **platform specific** requirements (see: https://flutter.dev/docs/get-started/install)
- flutter **Desktop support** requirements (see: https://flutter.dev/desktop)

The regular devolo cockpit is required because it contains the necessary back-end components (which talk to your devolo devices; the Flutter cockpit only talks to the back-end).

### Install Flutter
- flutter installation: https://flutter.dev/docs/get-started/install
- add Flutter desktop support: https://flutter.dev/desktop
- run '*flutter doctor*' in Terminal to verify everything is set up correctly

### Import cockpit_devolo repository
1. Download the repository, following the *Clone or download* button's instructions above and copy the url or unpack the zip.
2. 
   - "Import Project" into Android Studio:
      * In Android Studio *File -> New -> Import Project* dialogue.
      * Select *Create project from existing sources* and click next.
      * Continue clicking *next* (leave everything checked).
      * Leave all checkboxes marked and click *Finish*.
   - or "Import Project from Version Control" into Android Studio:
      * In Android Studio *File -> New -> Import Project from Version Control* dialogue.
      * Insert the git url and click *Clone*
3. Make sure _Flutter SDK_ and _Dart SDK_ are _enabled_ and the _path_ ist correct
   * In *File -> Settings -> Languages & Frameworks -> Dart* 
      * verify if the path to Dart SDK is correct (Dart SDK located in "...\flutterSDK\flutter\bin\cache\dart-sdk")
      * check "Enable Dart support for the projekt '...' "
      * check all "Enable Dart support for the following modules:"
   * In *File -> Settings -> Languages & Frameworks -> Flutter*
      * verify if the path to Flutter SDK is correct
4. Select *desktop* in *Flutter device selection* dropdown in Android Studio
5. run '*flutter pub get*' to get all dependencies
6. Click on Icon *Run 'main.dart'*
7. Building the App:
   - build the app (run "_flutter build windows_" in a terminal in the projects root directory)
   - get the executable and the data folder (for example Windows in: "C:\Users\\_name_\AndroidStudioProjects\Cockpit-open-frontend\build\windows\runner\Release")
   - open terminal navigate to the containing path and run "devoloCockpit.exe" (!double tap on the executable will throw an Error)


<img src="images/overviewENG.png"  width="700">

## Building on Linux
The following explains how to build and run the Flutter cockpit on Linux, not requiring any particular IDE (you may use any editor even if it doesn't come with explicit Flutter support).

Note that the regular devolo Cockpit needs to be installed first (see above).

### Install Flutter
Refer to https://flutter.dev/docs/get-started/install and https://flutter.dev/desktop for details. Installing Android support and Android Studio is optional (because this is a desktop application) so don't worry if `flutter doctor` reports a missing Android toolchain.

For example:

```sh
$ sudo snap install flutter --classic
$ flutter config --no-analytics
$ flutter config --enable-linux-desktop

$ flutter devices
2 connected devices:

Linux (desktop) • linux  • linux-x64      • Linux
Chrome (web)    • chrome • web-javascript • Google Chrome 90.0.4430.93
```

### Build and Run
Clone this repository, or download the source distribution. Then:

```sh
$ cd flutter_devolo_cockpit
$ flutter run -d linux
```

## Links
- flutter Desktop Support: https://flutter.dev/desktop
- For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
