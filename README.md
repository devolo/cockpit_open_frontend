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
- flutter **Desktop support** requirements (see: https://flutter.dev/desktop#requirements)

### Install Flutter
- Flutter installation: https://flutter.dev/docs/get-started/install
- add Flutter desktop support (for details: https://flutter.dev/desktop#set-up)
  ```sh
  $ flutter config --enable-<platform>-desktop
  ```
  Where <_platform_> is windows, macos, or linux.<br/>
  
  Check if desktop is enabled:
  ```sh
  $ flutter devices
  ```
  
- Verify if everything is set up correctly
  ```sh
  $ flutter doctor
  ```
  
### Build and Run

#### From the command line
Clone this repository, or download the source distribution. Then:
```sh
$ cd Cockpit-open-frontend
$ flutter run -d <platform>
```
Where <_platform_> is windows, macos, or linux.

#### Using Android Studio IDE
1. Clone this repository, or download the source distribution.
2. 
   - "Import Project" into Android Studio:
      * In Android Studio *File -> New -> Import Project* dialogue.
      * Select *Create project from existing sources* and click next.
      * Continue clicking *next* (leave everything checked).
      * Leave all checkboxes marked and click *Finish*.
   - or "Import Project from Version Control" into Android Studio:
      * In Android Studio *File -> New -> Import Project from Version Control* dialogue.
      * Insert the git url and click *Clone*.
3. Make sure _Flutter SDK_ and _Dart SDK_ are _enabled_ and the _path_ ist correct
   * In *File -> Settings -> Languages & Frameworks -> Dart* 
      * verify if the path to Dart SDK is correct (Dart SDK located in ".../flutterSDK/flutter/bin/cache/dart-sdk")
      * check "Enable Dart support for the projekt '...' "
      * check all "Enable Dart support for the following modules:"
   * In *File -> Settings -> Languages & Frameworks -> Flutter*
      * verify if the path to Flutter SDK is correct
4. Select *desktop* in *Flutter device selection* dropdown in Android Studio
5. run '*flutter pub get*' to get all dependencies
6. Run the flutter app by clicking on the green Play Icon *Run 'main.dart'*

#### Build a release app

- To generate a release build, run the following command:
  ```sh
  $ flutter build <platform>
  ```
  Where <_platform_> is windows, macos, or linux.

- the executable and the data folder are located in:
   * windows: .../Cockpit-open-frontend/build/windows/runner/Release
   * linux: .../Cockpit-open-frontend/build/linux/release/bundle
   * macos:

- navigate in terminal to the containing path and run "devoloCockpit" (!double tap on the executable will throw an Error)

<img src="images/overviewENG.png"  width="700">

## Links
- flutter Desktop Support: https://flutter.dev/desktop
- For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
