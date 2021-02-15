// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `devolo Cockpit`
  String get title {
    return Intl.message(
      'devolo Cockpit',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `Home Network Desktop`
  String get homeNetworkDesktop {
    return Intl.message(
      'Home Network Desktop',
      name: 'homeNetworkDesktop',
      desc: '',
      args: [],
    );
  }

  /// `Networkoverview`
  String get networkoverview {
    return Intl.message(
      'Networkoverview',
      name: 'networkoverview',
      desc: '',
      args: [],
    );
  }

  /// `Updates`
  String get updates {
    return Intl.message(
      'Updates',
      name: 'updates',
      desc: '',
      args: [],
    );
  }

  /// `Network Settings`
  String get networkSettings {
    return Intl.message(
      'Network Settings',
      name: 'networkSettings',
      desc: '',
      args: [],
    );
  }

  /// `App info`
  String get appInfo {
    return Intl.message(
      'App info',
      name: 'appInfo',
      desc: '',
      args: [],
    );
  }

  /// `App information`
  String get appInformation {
    return Intl.message(
      'App information',
      name: 'appInformation',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Appearance`
  String get appearance {
    return Intl.message(
      'Appearance',
      name: 'appearance',
      desc: '',
      args: [],
    );
  }

  /// `Enable Showing Speeds`
  String get enableShowingSpeeds {
    return Intl.message(
      'Enable Showing Speeds',
      name: 'enableShowingSpeeds',
      desc: '',
      args: [],
    );
  }

  /// `Internet-centered`
  String get internetcentered {
    return Intl.message(
      'Internet-centered',
      name: 'internetcentered',
      desc: '',
      args: [],
    );
  }

  /// `Show other devices`
  String get showOtherDevices {
    return Intl.message(
      'Show other devices',
      name: 'showOtherDevices',
      desc: '',
      args: [],
    );
  }

  /// `Network`
  String get network {
    return Intl.message(
      'Network',
      name: 'network',
      desc: '',
      args: [],
    );
  }

  /// `Ignore Updates`
  String get ignoreUpdates {
    return Intl.message(
      'Ignore Updates',
      name: 'ignoreUpdates',
      desc: '',
      args: [],
    );
  }

  /// `Record the transmission power of the devices and transmit it to devolo`
  String get recordTheTransmissionPowerOfTheDevicesAndTransmitIt {
    return Intl.message(
      'Record the transmission power of the devices and transmit it to devolo',
      name: 'recordTheTransmissionPowerOfTheDevicesAndTransmitIt',
      desc: '',
      args: [],
    );
  }

  /// `Windows network throttling`
  String get windowsNetworkThrottling {
    return Intl.message(
      'Windows network throttling',
      name: 'windowsNetworkThrottling',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `change`
  String get change {
    return Intl.message(
      'change',
      name: 'change',
      desc: '',
      args: [],
    );
  }

  /// `Change PLC-network password`
  String get changePlcnetworkPassword {
    return Intl.message(
      'Change PLC-network password',
      name: 'changePlcnetworkPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please enter password`
  String get pleaseEnterPassword {
    return Intl.message(
      'Please enter password',
      name: 'pleaseEnterPassword',
      desc: '',
      args: [],
    );
  }

  /// `show password `
  String get showPassword {
    return Intl.message(
      'show password ',
      name: 'showPassword',
      desc: '',
      args: [],
    );
  }

  /// `set`
  String get set {
    return Intl.message(
      'set',
      name: 'set',
      desc: '',
      args: [],
    );
  }

  /// `Support`
  String get support {
    return Intl.message(
      'Support',
      name: 'support',
      desc: '',
      args: [],
    );
  }

  /// `Generate support information `
  String get generateSupportInformation {
    return Intl.message(
      'Generate support information ',
      name: 'generateSupportInformation',
      desc: '',
      args: [],
    );
  }

  /// `open browser`
  String get openBrowser {
    return Intl.message(
      'open browser',
      name: 'openBrowser',
      desc: '',
      args: [],
    );
  }

  /// `open zip`
  String get openZip {
    return Intl.message(
      'open zip',
      name: 'openZip',
      desc: '',
      args: [],
    );
  }

  /// `send to devolo`
  String get sendToDevolo {
    return Intl.message(
      'send to devolo',
      name: 'sendToDevolo',
      desc: '',
      args: [],
    );
  }

  /// `Show Logs`
  String get showLogs {
    return Intl.message(
      'Show Logs',
      name: 'showLogs',
      desc: '',
      args: [],
    );
  }

  /// `Please confirm action.`
  String get pleaseConfirmAction {
    return Intl.message(
      'Please confirm action.',
      name: 'pleaseConfirmAction',
      desc: '',
      args: [],
    );
  }

  /// `Contact information`
  String get contactInfo {
    return Intl.message(
      'Contact information',
      name: 'contactInfo',
      desc: '',
      args: [],
    );
  }

  /// `The created support information can now be sent to devolo support.\nPlease fill in the following fields.`
  String get theCreatedSupportInformationCanNowBeSentToDevolo {
    return Intl.message(
      'The created support information can now be sent to devolo support.\nPlease fill in the following fields.',
      name: 'theCreatedSupportInformationCanNowBeSentToDevolo',
      desc: '',
      args: [],
    );
  }

  /// `Process number`
  String get processNumber {
    return Intl.message(
      'Process number',
      name: 'processNumber',
      desc: '',
      args: [],
    );
  }

  /// `Please enter processing number`
  String get pleaseEnterProcessingNumber {
    return Intl.message(
      'Please enter processing number',
      name: 'pleaseEnterProcessingNumber',
      desc: '',
      args: [],
    );
  }

  /// `Your name`
  String get yourName {
    return Intl.message(
      'Your name',
      name: 'yourName',
      desc: '',
      args: [],
    );
  }

  /// `Please fill in your name`
  String get pleaseFillInYourName {
    return Intl.message(
      'Please fill in your name',
      name: 'pleaseFillInYourName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your mail address`
  String get pleaseEnterYourMailAddress {
    return Intl.message(
      'Please enter your mail address',
      name: 'pleaseEnterYourMailAddress',
      desc: '',
      args: [],
    );
  }

  /// `name`
  String get name {
    return Intl.message(
      'name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `current version`
  String get currentVersion {
    return Intl.message(
      'current version',
      name: 'currentVersion',
      desc: '',
      args: [],
    );
  }

  /// `new version`
  String get newVersion {
    return Intl.message(
      'new version',
      name: 'newVersion',
      desc: '',
      args: [],
    );
  }

  /// `state`
  String get state {
    return Intl.message(
      'state',
      name: 'state',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message(
      'Update',
      name: 'update',
      desc: '',
      args: [],
    );
  }

  /// `Cockpit software is up to date.`
  String get cockpitSoftwareIsUpToDate {
    return Intl.message(
      'Cockpit software is up to date.',
      name: 'cockpitSoftwareIsUpToDate',
      desc: '',
      args: [],
    );
  }

  /// `Update ready to install`
  String get updateReadyToInstall {
    return Intl.message(
      'Update ready to install',
      name: 'updateReadyToInstall',
      desc: '',
      args: [],
    );
  }

  /// ` Check Updates `
  String get checkUpdates {
    return Intl.message(
      ' Check Updates ',
      name: 'checkUpdates',
      desc: '',
      args: [],
    );
  }

  /// `Add Device`
  String get addDevice {
    return Intl.message(
      'Add Device',
      name: 'addDevice',
      desc: '',
      args: [],
    );
  }

  /// `open optimization`
  String get openOptimization {
    return Intl.message(
      'open optimization',
      name: 'openOptimization',
      desc: '',
      args: [],
    );
  }

  /// `Optimization help`
  String get optimizationHelp {
    return Intl.message(
      'Optimization help',
      name: 'optimizationHelp',
      desc: '',
      args: [],
    );
  }

  /// `Please confirm action. \nAttention! Your router is connected to this PLC device you lose connection to the Internet`
  String get pleaseConfirmActionAttentionYourRouterIsConnectedToThis {
    return Intl.message(
      'Please confirm action. \nAttention! Your router is connected to this PLC device you lose connection to the Internet',
      name: 'pleaseConfirmActionAttentionYourRouterIsConnectedToThis',
      desc: '',
      args: [],
    );
  }

  /// `install`
  String get install {
    return Intl.message(
      'install',
      name: 'install',
      desc: '',
      args: [],
    );
  }

  /// `confirm`
  String get confirm {
    return Intl.message(
      'confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `cancel`
  String get cancel {
    return Intl.message(
      'cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Show manual`
  String get showManual {
    return Intl.message(
      'Show manual',
      name: 'showManual',
      desc: '',
      args: [],
    );
  }

  /// `Identify device`
  String get identifyDevice {
    return Intl.message(
      'Identify device',
      name: 'identifyDevice',
      desc: '',
      args: [],
    );
  }

  /// `Web interface`
  String get launchWebinterface {
    return Intl.message(
      'Web interface',
      name: 'launchWebinterface',
      desc: '',
      args: [],
    );
  }

  /// `Factory reset`
  String get factoryReset {
    return Intl.message(
      'Factory reset',
      name: 'factoryReset',
      desc: '',
      args: [],
    );
  }

  /// `Delete device`
  String get deleteDevice {
    return Intl.message(
      'Delete device',
      name: 'deleteDevice',
      desc: '',
      args: [],
    );
  }

  /// `1.) Plug both PLC devices into the desired wall sockets and wait for about 45 seconds.\n2.) Briefly press the encryption button of the first (possibly already existing) PLC device.\n    (Alternatively, pairing can also be started via the web interface of the existing device.)\n 3.) Within two minutes, press the encryption button of the second (new) PLC device also briefly.\n4.) As soon as the LEDs light up permanently, the PLC devices are ready for operation.`
  String get addDeviceInstructionText {
    return Intl.message(
      '1.) Plug both PLC devices into the desired wall sockets and wait for about 45 seconds.\n2.) Briefly press the encryption button of the first (possibly already existing) PLC device.\n    (Alternatively, pairing can also be started via the web interface of the existing device.)\n 3.) Within two minutes, press the encryption button of the second (new) PLC device also briefly.\n4.) As soon as the LEDs light up permanently, the PLC devices are ready for operation.',
      name: 'addDeviceInstructionText',
      desc: '',
      args: [],
    );
  }

  /// `back`
  String get back {
    return Intl.message(
      'back',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  /// `forward`
  String get forward {
    return Intl.message(
      'forward',
      name: 'forward',
      desc: '',
      args: [],
    );
  }

  /// `Overview`
  String get overview {
    return Intl.message(
      'Overview',
      name: 'overview',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Help`
  String get help {
    return Intl.message(
      'Help',
      name: 'help',
      desc: '',
      args: [],
    );
  }

  /// `High Contrast`
  String get highContrast {
    return Intl.message(
      'High Contrast',
      name: 'highContrast',
      desc: '',
      args: [],
    );
  }

  /// `No devices found \nScanning for devices ...`
  String get noDevicesFoundNscanningForDevices {
    return Intl.message(
      'No devices found \nScanning for devices ...',
      name: 'noDevicesFoundNscanningForDevices',
      desc: '',
      args: [],
    );
  }

  /// `previous network`
  String get previousNetwork {
    return Intl.message(
      'previous network',
      name: 'previousNetwork',
      desc: '',
      args: [],
    );
  }

  /// `next network`
  String get nextNetwork {
    return Intl.message(
      'next network',
      name: 'nextNetwork',
      desc: '',
      args: [],
    );
  }

  /// `Please enter devicename`
  String get pleaseEnterDevicename {
    return Intl.message(
      'Please enter devicename',
      name: 'pleaseEnterDevicename',
      desc: '',
      args: [],
    );
  }

  /// `Type:`
  String get type {
    return Intl.message(
      'Type:',
      name: 'type',
      desc: '',
      args: [],
    );
  }

  /// `Serial number:`
  String get serialNumber {
    return Intl.message(
      'Serial number:',
      name: 'serialNumber',
      desc: '',
      args: [],
    );
  }

  /// `MT number:`
  String get mtnumber {
    return Intl.message(
      'MT number:',
      name: 'mtnumber',
      desc: '',
      args: [],
    );
  }

  /// `Firmware version:`
  String get version {
    return Intl.message(
      'Firmware version:',
      name: 'version',
      desc: '',
      args: [],
    );
  }

  /// `IP address:`
  String get ipaddress {
    return Intl.message(
      'IP address:',
      name: 'ipaddress',
      desc: '',
      args: [],
    );
  }

  /// `MAC address:`
  String get macaddress {
    return Intl.message(
      'MAC address:',
      name: 'macaddress',
      desc: '',
      args: [],
    );
  }

  /// `Attached to Router:`
  String get attachedToRouter {
    return Intl.message(
      'Attached to Router:',
      name: 'attachedToRouter',
      desc: '',
      args: [],
    );
  }

  /// ` Your email-address`
  String get yourEmailaddress {
    return Intl.message(
      ' Your email-address',
      name: 'yourEmailaddress',
      desc: '',
      args: [],
    );
  }

  /// `refresh`
  String get refresh {
    return Intl.message(
      'refresh',
      name: 'refresh',
      desc: '',
      args: [],
    );
  }

  /// `Is Local Device:`
  String get isLocalDevice {
    return Intl.message(
      'Is Local Device:',
      name: 'isLocalDevice',
      desc: '',
      args: [],
    );
  }

  /// `Fontsize`
  String get fontsize {
    return Intl.message(
      'Fontsize',
      name: 'fontsize',
      desc: '',
      args: [],
    );
  }

  /// `App Color`
  String get appColor {
    return Intl.message(
      'App Color',
      name: 'appColor',
      desc: '',
      args: [],
    );
  }

  /// `Choose main color, accent color and font colors`
  String get chooseMainColorAccentColorAndFontColors {
    return Intl.message(
      'Choose main color, accent color and font colors',
      name: 'chooseMainColorAccentColorAndFontColors',
      desc: '',
      args: [],
    );
  }

  /// `Other devices, e.g. PC are displayed in the overview`
  String get otherDevicesEgPcAreDisplayedInTheOverview {
    return Intl.message(
      'Other devices, e.g. PC are displayed in the overview',
      name: 'otherDevicesEgPcAreDisplayedInTheOverview',
      desc: '',
      args: [],
    );
  }

  /// `The overview will be centered around the PLC device connected to the Internet.`
  String get theOverviewWillBeCenteredAroundThePlcDeviceConnected {
    return Intl.message(
      'The overview will be centered around the PLC device connected to the Internet.',
      name: 'theOverviewWillBeCenteredAroundThePlcDeviceConnected',
      desc: '',
      args: [],
    );
  }

  /// `Data rates are permanently displayed in the Overview`
  String get dataRatesArePermanentlyDisplayedInTheOverview {
    return Intl.message(
      'Data rates are permanently displayed in the Overview',
      name: 'dataRatesArePermanentlyDisplayedInTheOverview',
      desc: '',
      args: [],
    );
  }

  /// `Change the language of the app`
  String get changeTheLanguageOfTheApp {
    return Intl.message(
      'Change the language of the app',
      name: 'changeTheLanguageOfTheApp',
      desc: '',
      args: [],
    );
  }

  /// `Device information`
  String get deviceinfo {
    return Intl.message(
      'Device information',
      name: 'deviceinfo',
      desc: '',
      args: [],
    );
  }

  /// `Choose Theme`
  String get chooseTheme {
    return Intl.message(
      'Choose Theme',
      name: 'chooseTheme',
      desc: '',
      args: [],
    );
  }

  /// `Fully customize colors`
  String get fullyCustomizeColors {
    return Intl.message(
      'Fully customize colors',
      name: 'fullyCustomizeColors',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'de'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}