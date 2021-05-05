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


<img src="images/overview.PNG"  width="700">



## Links
- flutter Desktop Support: https://flutter.dev/desktop
- For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.




