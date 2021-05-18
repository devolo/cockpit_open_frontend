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

  /// `Show Network Speeds`
  String get enableShowingSpeeds {
    return Intl.message(
      'Show Network Speeds',
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

  /// `Show Other Devices`
  String get showOtherDevices {
    return Intl.message(
      'Show Other Devices',
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

  /// `save`
  String get save {
    return Intl.message(
      'save',
      name: 'save',
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

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Current Version`
  String get currentVersion {
    return Intl.message(
      'Current Version',
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

  /// `State`
  String get state {
    return Intl.message(
      'State',
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

  /// ` Check for Updates `
  String get checkUpdates {
    return Intl.message(
      ' Check for Updates ',
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

  /// `open optimization help`
  String get openOptimization {
    return Intl.message(
      'open optimization help',
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

  /// `Attention! Your router is connected to this PLC device. You will lose connection to the Internet`
  String get confirmActionConnectedToRouterWarning {
    return Intl.message(
      'Attention! Your router is connected to this PLC device. You will lose connection to the Internet',
      name: 'confirmActionConnectedToRouterWarning',
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

  /// `devolo MT number:`
  String get mtnumber {
    return Intl.message(
      'devolo MT number:',
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

  /// `Attached to router:`
  String get attachedToRouter {
    return Intl.message(
      'Attached to router:',
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

  /// `Is local device:`
  String get isLocalDevice {
    return Intl.message(
      'Is local device:',
      name: 'isLocalDevice',
      desc: '',
      args: [],
    );
  }

  /// `Font Size`
  String get fontsize {
    return Intl.message(
      'Font Size',
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

  /// `Device Information`
  String get deviceinfo {
    return Intl.message(
      'Device Information',
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

  /// `Please enter device name`
  String get pleaseEnterDeviceName {
    return Intl.message(
      'Please enter device name',
      name: 'pleaseEnterDeviceName',
      desc: '',
      args: [],
    );
  }

  /// `yes`
  String get yes {
    return Intl.message(
      'yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `no`
  String get no {
    return Intl.message(
      'no',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `This device is connected directly to the Internet router.`
  String get thisDeviceIsConnectedDirectlyToTheInternetRouter {
    return Intl.message(
      'This device is connected directly to the Internet router.',
      name: 'thisDeviceIsConnectedDirectlyToTheInternetRouter',
      desc: '',
      args: [],
    );
  }

  /// `Your current terminal is connected to this devolo-device.`
  String get yourCurrentTerminalIsConnectedToThisDevolodevice {
    return Intl.message(
      'Your current terminal is connected to this devolo-device.',
      name: 'yourCurrentTerminalIsConnectedToThisDevolodevice',
      desc: '',
      args: [],
    );
  }

  /// `Update all`
  String get updateAll {
    return Intl.message(
      'Update all',
      name: 'updateAll',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Action`
  String get confirmAction {
    return Intl.message(
      'Confirm Action',
      name: 'confirmAction',
      desc: '',
      args: [],
    );
  }

  /// `up to date`
  String get upToDate {
    return Intl.message(
      'up to date',
      name: 'upToDate',
      desc: '',
      args: [],
    );
  }

  /// `update`
  String get update2 {
    return Intl.message(
      'update',
      name: 'update2',
      desc: '',
      args: [],
    );
  }

  /// `updating...`
  String get updating {
    return Intl.message(
      'updating...',
      name: 'updating',
      desc: '',
      args: [],
    );
  }

  /// `searching...`
  String get searching {
    return Intl.message(
      'searching...',
      name: 'searching',
      desc: '',
      args: [],
    );
  }

  /// `General`
  String get general {
    return Intl.message(
      'General',
      name: 'general',
      desc: '',
      args: [],
    );
  }

  /// `Your PC`
  String get yourPc {
    return Intl.message(
      'Your PC',
      name: 'yourPc',
      desc: '',
      args: [],
    );
  }

  /// `This PC`
  String get thisPc {
    return Intl.message(
      'This PC',
      name: 'thisPc',
      desc: '',
      args: [],
    );
  }

  /// `Internet`
  String get internet {
    return Intl.message(
      'Internet',
      name: 'internet',
      desc: '',
      args: [],
    );
  }

  /// ` - Has the PLC device been disconnected from the power grid?\n - Is the PLC device in power-saving mode?`
  String get deviceNotFoundHint {
    return Intl.message(
      ' - Has the PLC device been disconnected from the power grid?\n - Is the PLC device in power-saving mode?',
      name: 'deviceNotFoundHint',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while setting the device name!`
  String get deviceNotFoundDeviceName {
    return Intl.message(
      'An error occurred while setting the device name!',
      name: 'deviceNotFoundDeviceName',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while resetting the device!`
  String get deviceNotFoundResetDevice {
    return Intl.message(
      'An error occurred while resetting the device!',
      name: 'deviceNotFoundResetDevice',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while removing the device!`
  String get deviceNotFoundRemoveDevice {
    return Intl.message(
      'An error occurred while removing the device!',
      name: 'deviceNotFoundRemoveDevice',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while removing the device!`
  String get deviceNotFoundIdentifyDevice {
    return Intl.message(
      'An error occurred while removing the device!',
      name: 'deviceNotFoundIdentifyDevice',
      desc: '',
      args: [],
    );
  }

  /// `Failed to set the network password`
  String get networkPasswordErrorTitle {
    return Intl.message(
      'Failed to set the network password',
      name: 'networkPasswordErrorTitle',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while setting the network password!`
  String get networkPasswordErrorBody {
    return Intl.message(
      'An error occurred while setting the network password!',
      name: 'networkPasswordErrorBody',
      desc: '',
      args: [],
    );
  }

  /// `- Check the connection to the PLC device and repeat the action!`
  String get networkPasswordErrorHint {
    return Intl.message(
      '- Check the connection to the PLC device and repeat the action!',
      name: 'networkPasswordErrorHint',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get deviceNameDialogTitle {
    return Intl.message(
      'Confirm',
      name: 'deviceNameDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `Do you really want to rename this device?`
  String get deviceNameDialogBody {
    return Intl.message(
      'Do you really want to rename this device?',
      name: 'deviceNameDialogBody',
      desc: '',
      args: [],
    );
  }

  /// `Name change failed`
  String get deviceNameErrorTitle {
    return Intl.message(
      'Name change failed',
      name: 'deviceNameErrorTitle',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while changing the name.\nPlease try it again.`
  String get deviceNameErrorBody {
    return Intl.message(
      'An error occurred while changing the name.\nPlease try it again.',
      name: 'deviceNameErrorBody',
      desc: '',
      args: [],
    );
  }

  /// `Reset failed`
  String get resetDeviceErrorTitle {
    return Intl.message(
      'Reset failed',
      name: 'resetDeviceErrorTitle',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while resetting the device!\nPlease try it again.`
  String get resetDeviceErrorBody {
    return Intl.message(
      'An error occurred while resetting the device!\nPlease try it again.',
      name: 'resetDeviceErrorBody',
      desc: '',
      args: [],
    );
  }

  /// `Remove failed`
  String get removeDeviceErrorTitle {
    return Intl.message(
      'Remove failed',
      name: 'removeDeviceErrorTitle',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while removing the device!\nPlease try it again.`
  String get removeDeviceErrorBody {
    return Intl.message(
      'An error occurred while removing the device!\nPlease try it again.',
      name: 'removeDeviceErrorBody',
      desc: '',
      args: [],
    );
  }

  /// `Identifying failed`
  String get identifyDeviceErrorTitle {
    return Intl.message(
      'Identifying failed',
      name: 'identifyDeviceErrorTitle',
      desc: '',
      args: [],
    );
  }

  /// `Manual not found`
  String get manualErrorTitle {
    return Intl.message(
      'Manual not found',
      name: 'manualErrorTitle',
      desc: '',
      args: [],
    );
  }

  /// `No suitable manual was found for your PLC device.\n\nYou can find the manual on the product CD or on the devolo website.`
  String get manualErrorBody {
    return Intl.message(
      'No suitable manual was found for your PLC device.\n\nYou can find the manual on the product CD or on the devolo website.',
      name: 'manualErrorBody',
      desc: '',
      args: [],
    );
  }

  /// `Remove the PLC-Device?`
  String get removeDeviceConfirmTitle {
    return Intl.message(
      'Remove the PLC-Device?',
      name: 'removeDeviceConfirmTitle',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to remove the selected PLC device from the network?`
  String get removeDeviceConfirmBody {
    return Intl.message(
      'Do you want to remove the selected PLC device from the network?',
      name: 'removeDeviceConfirmBody',
      desc: '',
      args: [],
    );
  }

  /// `Reset device to delivery state`
  String get resetDeviceConfirmTitle {
    return Intl.message(
      'Reset device to delivery state',
      name: 'resetDeviceConfirmTitle',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to reset the selected PLC device to the delivery state?`
  String get resetDeviceConfirmBody {
    return Intl.message(
      'Do you want to reset the selected PLC device to the delivery state?',
      name: 'resetDeviceConfirmBody',
      desc: '',
      args: [],
    );
  }

  /// `Set up a new device`
  String get setUpDevice {
    return Intl.message(
      'Set up a new device',
      name: 'setUpDevice',
      desc: '',
      args: [],
    );
  }

  /// `Optimize reception`
  String get optimizeReception {
    return Intl.message(
      'Optimize reception',
      name: 'optimizeReception',
      desc: '',
      args: [],
    );
  }

  /// `Contact support`
  String get contactSupport {
    return Intl.message(
      'Contact support',
      name: 'contactSupport',
      desc: '',
      args: [],
    );
  }

  /// `Set VDSL-compatibility`
  String get setVdslcompatibility {
    return Intl.message(
      'Set VDSL-compatibility',
      name: 'setVdslcompatibility',
      desc: '',
      args: [],
    );
  }

  /// `In rare cases, VDSL connection problems can be caused by crosstalk of the Powerline signal. When the automatic compatibility mode is active, the device tries to detect this situation and automatically adjusts its transmit level to achieve the best possible performance without interference.`
  String get vdslexplanation {
    return Intl.message(
      'In rare cases, VDSL connection problems can be caused by crosstalk of the Powerline signal. When the automatic compatibility mode is active, the device tries to detect this situation and automatically adjusts its transmit level to achieve the best possible performance without interference.',
      name: 'vdslexplanation',
      desc: '',
      args: [],
    );
  }

  /// `If automatic mode is deactivated or the interference cannot be reliably detected, a fixed profile for adjusted transmission power can be used instead. Select the profile that matches the type of your VDSL connection, or select "full power" if interference avoidance is not required.`
  String get vdslexplanation2 {
    return Intl.message(
      'If automatic mode is deactivated or the interference cannot be reliably detected, a fixed profile for adjusted transmission power can be used instead. Select the profile that matches the type of your VDSL connection, or select "full power" if interference avoidance is not required.',
      name: 'vdslexplanation2',
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