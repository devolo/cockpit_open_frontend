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
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
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

  /// `Home network desktop`
  String get homeNetworkDesktop {
    return Intl.message(
      'Home network desktop',
      name: 'homeNetworkDesktop',
      desc: '',
      args: [],
    );
  }

  /// `Network overview`
  String get networkoverview {
    return Intl.message(
      'Network overview',
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

  /// `Network settings`
  String get networkSettings {
    return Intl.message(
      'Network settings',
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

  /// `Show network speeds`
  String get enableShowingSpeeds {
    return Intl.message(
      'Show network speeds',
      name: 'enableShowingSpeeds',
      desc: '',
      args: [],
    );
  }

  /// `Use internet-centered overview`
  String get internetcentered {
    return Intl.message(
      'Use internet-centered overview',
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

  /// `Ignore device updates`
  String get ignoreUpdates {
    return Intl.message(
      'Ignore device updates',
      name: 'ignoreUpdates',
      desc: '',
      args: [],
    );
  }

  /// `Record the transmission power of PLC devices and send it to devolo`
  String get recordTheTransmissionPowerOfTheDevicesAndTransmitIt {
    return Intl.message(
      'Record the transmission power of PLC devices and send it to devolo',
      name: 'recordTheTransmissionPowerOfTheDevicesAndTransmitIt',
      desc: '',
      args: [],
    );
  }

  /// `Use Windows network throttling`
  String get windowsNetworkThrottling {
    return Intl.message(
      'Use Windows network throttling',
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

  /// `Change`
  String get change {
    return Intl.message(
      'Change',
      name: 'change',
      desc: '',
      args: [],
    );
  }

  /// `Change PLC network password`
  String get changePlcnetworkPassword {
    return Intl.message(
      'Change PLC network password',
      name: 'changePlcnetworkPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter password`
  String get pleaseEnterPassword {
    return Intl.message(
      'Enter password',
      name: 'pleaseEnterPassword',
      desc: '',
      args: [],
    );
  }

  /// `Show password`
  String get showPassword {
    return Intl.message(
      'Show password',
      name: 'showPassword',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
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

  /// `Generate support information`
  String get generateSupportInformation {
    return Intl.message(
      'Generate support information',
      name: 'generateSupportInformation',
      desc: '',
      args: [],
    );
  }

  /// `Open support informations`
  String get openSupportInformations {
    return Intl.message(
      'Open support informations',
      name: 'openSupportInformations',
      desc: '',
      args: [],
    );
  }

  /// `Save support informations`
  String get saveSupportInformations {
    return Intl.message(
      'Save support informations',
      name: 'saveSupportInformations',
      desc: '',
      args: [],
    );
  }

  /// `send support informations to devolo Support`
  String get sendToDevolo {
    return Intl.message(
      'send support informations to devolo Support',
      name: 'sendToDevolo',
      desc: '',
      args: [],
    );
  }

  /// `Show logs`
  String get showLogs {
    return Intl.message(
      'Show logs',
      name: 'showLogs',
      desc: '',
      args: [],
    );
  }

  /// `Confirm action`
  String get pleaseConfirmAction {
    return Intl.message(
      'Confirm action',
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

  /// `The created support information can now be sent to devolo support.\nFill the following fields`
  String get theCreatedSupportInformationCanNowBeSentToDevolo {
    return Intl.message(
      'The created support information can now be sent to devolo support.\nFill the following fields',
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

  /// `Enter processing number`
  String get pleaseEnterProcessingNumber {
    return Intl.message(
      'Enter processing number',
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

  /// `Enter your name`
  String get pleaseFillInYourName {
    return Intl.message(
      'Enter your name',
      name: 'pleaseFillInYourName',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email address`
  String get pleaseEnterYourMailAddress {
    return Intl.message(
      'Enter your email address',
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

  /// `Current version`
  String get currentVersion {
    return Intl.message(
      'Current version',
      name: 'currentVersion',
      desc: '',
      args: [],
    );
  }

  /// `New version`
  String get newVersion {
    return Intl.message(
      'New version',
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

  /// `Cockpit software is up to date`
  String get cockpitSoftwareIsUpToDate {
    return Intl.message(
      'Cockpit software is up to date',
      name: 'cockpitSoftwareIsUpToDate',
      desc: '',
      args: [],
    );
  }

  /// `Ready to install updates`
  String get updateReadyToInstall {
    return Intl.message(
      'Ready to install updates',
      name: 'updateReadyToInstall',
      desc: '',
      args: [],
    );
  }

  /// `Check for updates`
  String get checkUpdates {
    return Intl.message(
      'Check for updates',
      name: 'checkUpdates',
      desc: '',
      args: [],
    );
  }

  /// `Add device`
  String get addDevice {
    return Intl.message(
      'Add device',
      name: 'addDevice',
      desc: '',
      args: [],
    );
  }

  /// `Open optimization help`
  String get openOptimization {
    return Intl.message(
      'Open optimization help',
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

  /// `Attention! Your router is connected to this PLC device. You will lose connection to the internet`
  String get confirmActionConnectedToRouterWarning {
    return Intl.message(
      'Attention! Your router is connected to this PLC device. You will lose connection to the internet',
      name: 'confirmActionConnectedToRouterWarning',
      desc: '',
      args: [],
    );
  }

  /// `Install`
  String get install {
    return Intl.message(
      'Install',
      name: 'install',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
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

  /// `1) Plug both PLC devices into wall sockets and wait for 45 seconds.\n2) Briefly press the encryption button of the existing PLC device.\n(Alternatively start pairing via the web interface of the existing device.)\n3) Within 2 minutes, press the encryption button of the new PLC device also briefly.\n4) As soon as the LEDs light up and do not blink, the PLC devices are ready for operation.`
  String get addDeviceInstructionText {
    return Intl.message(
      '1) Plug both PLC devices into wall sockets and wait for 45 seconds.\n2) Briefly press the encryption button of the existing PLC device.\n(Alternatively start pairing via the web interface of the existing device.)\n3) Within 2 minutes, press the encryption button of the new PLC device also briefly.\n4) As soon as the LEDs light up and do not blink, the PLC devices are ready for operation.',
      name: 'addDeviceInstructionText',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get back {
    return Intl.message(
      'Back',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get forward {
    return Intl.message(
      'Next',
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

  /// `High contrast`
  String get highContrast {
    return Intl.message(
      'High contrast',
      name: 'highContrast',
      desc: '',
      args: [],
    );
  }

  /// `No devices found. \n\nScanning for devices ...`
  String get noDevicesFoundNscanningForDevices {
    return Intl.message(
      'No devices found. \n\nScanning for devices ...',
      name: 'noDevicesFoundNscanningForDevices',
      desc: '',
      args: [],
    );
  }

  /// `Previous network`
  String get previousNetwork {
    return Intl.message(
      'Previous network',
      name: 'previousNetwork',
      desc: '',
      args: [],
    );
  }

  /// `Next network`
  String get nextNetwork {
    return Intl.message(
      'Next network',
      name: 'nextNetwork',
      desc: '',
      args: [],
    );
  }

  /// `Enter a device name`
  String get pleaseEnterDevicename {
    return Intl.message(
      'Enter a device name',
      name: 'pleaseEnterDevicename',
      desc: '',
      args: [],
    );
  }

  /// `Type`
  String get type {
    return Intl.message(
      'Type',
      name: 'type',
      desc: '',
      args: [],
    );
  }

  /// `Serial number`
  String get serialNumber {
    return Intl.message(
      'Serial number',
      name: 'serialNumber',
      desc: '',
      args: [],
    );
  }

  /// `devolo MT number`
  String get mtnumber {
    return Intl.message(
      'devolo MT number',
      name: 'mtnumber',
      desc: '',
      args: [],
    );
  }

  /// `Firmware version`
  String get version {
    return Intl.message(
      'Firmware version',
      name: 'version',
      desc: '',
      args: [],
    );
  }

  /// `IP address`
  String get ipaddress {
    return Intl.message(
      'IP address',
      name: 'ipaddress',
      desc: '',
      args: [],
    );
  }

  /// `MAC address`
  String get macaddress {
    return Intl.message(
      'MAC address',
      name: 'macaddress',
      desc: '',
      args: [],
    );
  }

  /// `Attached to router`
  String get attachedToRouter {
    return Intl.message(
      'Attached to router',
      name: 'attachedToRouter',
      desc: '',
      args: [],
    );
  }

  /// `Your email address`
  String get yourEmailaddress {
    return Intl.message(
      'Your email address',
      name: 'yourEmailaddress',
      desc: '',
      args: [],
    );
  }

  /// `Refresh`
  String get refresh {
    return Intl.message(
      'Refresh',
      name: 'refresh',
      desc: '',
      args: [],
    );
  }

  /// `Is local device`
  String get isLocalDevice {
    return Intl.message(
      'Is local device',
      name: 'isLocalDevice',
      desc: '',
      args: [],
    );
  }

  /// `Set font size`
  String get fontsize {
    return Intl.message(
      'Set font size',
      name: 'fontsize',
      desc: '',
      args: [],
    );
  }

  /// `Set app theme`
  String get appColor {
    return Intl.message(
      'Set app theme',
      name: 'appColor',
      desc: '',
      args: [],
    );
  }

  /// `Select from classic devolo, light, dark, and high-contrast themes`
  String get chooseMainColorAccentColorAndFontColors {
    return Intl.message(
      'Select from classic devolo, light, dark, and high-contrast themes',
      name: 'chooseMainColorAccentColorAndFontColors',
      desc: '',
      args: [],
    );
  }

  /// `Overview shows other devices, e.g., laptops and mobiles`
  String get otherDevicesEgPcAreDisplayedInTheOverview {
    return Intl.message(
      'Overview shows other devices, e.g., laptops and mobiles',
      name: 'otherDevicesEgPcAreDisplayedInTheOverview',
      desc: '',
      args: [],
    );
  }

  /// `The overview is centered around the PLC device connected to the internet`
  String get theOverviewWillBeCenteredAroundThePlcDeviceConnected {
    return Intl.message(
      'The overview is centered around the PLC device connected to the internet',
      name: 'theOverviewWillBeCenteredAroundThePlcDeviceConnected',
      desc: '',
      args: [],
    );
  }

  /// `Data transfer rates are always shown in overview`
  String get dataRatesArePermanentlyDisplayedInTheOverview {
    return Intl.message(
      'Data transfer rates are always shown in overview',
      name: 'dataRatesArePermanentlyDisplayedInTheOverview',
      desc: '',
      args: [],
    );
  }

  /// `Change language`
  String get changeTheLanguageOfTheApp {
    return Intl.message(
      'Change language',
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

  /// `Change theme`
  String get chooseTheme {
    return Intl.message(
      'Change theme',
      name: 'chooseTheme',
      desc: '',
      args: [],
    );
  }

  /// `Customize colors`
  String get fullyCustomizeColors {
    return Intl.message(
      'Customize colors',
      name: 'fullyCustomizeColors',
      desc: '',
      args: [],
    );
  }

  /// `Enter device name`
  String get pleaseEnterDeviceName {
    return Intl.message(
      'Enter device name',
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

  /// `This device is connected directly to the internet router.`
  String get thisDeviceIsConnectedDirectlyToTheInternetRouter {
    return Intl.message(
      'This device is connected directly to the internet router.',
      name: 'thisDeviceIsConnectedDirectlyToTheInternetRouter',
      desc: '',
      args: [],
    );
  }

  /// `Your current terminal is connected to this devolo device.`
  String get yourCurrentTerminalIsConnectedToThisDevolodevice {
    return Intl.message(
      'Your current terminal is connected to this devolo device.',
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

  /// `Confirm action`
  String get confirmAction {
    return Intl.message(
      'Confirm action',
      name: 'confirmAction',
      desc: '',
      args: [],
    );
  }

  /// `Up-to-date`
  String get upToDate {
    return Intl.message(
      'Up-to-date',
      name: 'upToDate',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update2 {
    return Intl.message(
      'Update',
      name: 'update2',
      desc: '',
      args: [],
    );
  }

  /// `Updating...`
  String get updating {
    return Intl.message(
      'Updating...',
      name: 'updating',
      desc: '',
      args: [],
    );
  }

  /// `Searching...`
  String get searching {
    return Intl.message(
      'Searching...',
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

  /// `An error occurred while setting the device name`
  String get deviceNotFoundDeviceName {
    return Intl.message(
      'An error occurred while setting the device name',
      name: 'deviceNotFoundDeviceName',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while resetting the device`
  String get deviceNotFoundResetDevice {
    return Intl.message(
      'An error occurred while resetting the device',
      name: 'deviceNotFoundResetDevice',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while removing the device`
  String get deviceNotFoundRemoveDevice {
    return Intl.message(
      'An error occurred while removing the device',
      name: 'deviceNotFoundRemoveDevice',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while removing the device`
  String get deviceNotFoundIdentifyDevice {
    return Intl.message(
      'An error occurred while removing the device',
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

  /// `An error occurred while setting the network password`
  String get networkPasswordErrorBody {
    return Intl.message(
      'An error occurred while setting the network password',
      name: 'networkPasswordErrorBody',
      desc: '',
      args: [],
    );
  }

  /// `- Check the connection to the PLC device and repeat the action`
  String get networkPasswordErrorHint {
    return Intl.message(
      '- Check the connection to the PLC device and repeat the action',
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

  /// `An error occurred while changing the name.\nTry again later`
  String get deviceNameErrorBody {
    return Intl.message(
      'An error occurred while changing the name.\nTry again later',
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

  /// `An error occurred while resetting the device!\nTry again later`
  String get resetDeviceErrorBody {
    return Intl.message(
      'An error occurred while resetting the device!\nTry again later',
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

  /// `An error occurred while removing the device!\nTry again later`
  String get removeDeviceErrorBody {
    return Intl.message(
      'An error occurred while removing the device!\nTry again later',
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

  /// `No suitable manual was found for your PLC device.\n\nYou can find the manual on the product CD or on the devolo website`
  String get manualErrorBody {
    return Intl.message(
      'No suitable manual was found for your PLC device.\n\nYou can find the manual on the product CD or on the devolo website',
      name: 'manualErrorBody',
      desc: '',
      args: [],
    );
  }

  /// `Remove the PLC device?`
  String get removeDeviceConfirmTitle {
    return Intl.message(
      'Remove the PLC device?',
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

  /// `Setup new device`
  String get setUpDevice {
    return Intl.message(
      'Setup new device',
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

  /// `In rare cases, noise from Powerline signal can interfere with VDSL connection. Devices in automatic compatibility mode can automatically adjust transmission to limit interference`
  String get vdslexplanation {
    return Intl.message(
      'In rare cases, noise from Powerline signal can interfere with VDSL connection. Devices in automatic compatibility mode can automatically adjust transmission to limit interference',
      name: 'vdslexplanation',
      desc: '',
      args: [],
    );
  }

  /// `Select a transmission profile from the given options as a fallback when automatic mode is OFF or reliable detection of interference is not possible`
  String get vdslexplanation2 {
    return Intl.message(
      'Select a transmission profile from the given options as a fallback when automatic mode is OFF or reliable detection of interference is not possible',
      name: 'vdslexplanation2',
      desc: '',
      args: [],
    );
  }

  /// `Set VDSL \ncompatibility`
  String get setVdslCompatibility {
    return Intl.message(
      'Set VDSL \ncompatibility',
      name: 'setVdslCompatibility',
      desc: '',
      args: [],
    );
  }

  /// `The new VDSL settings could not be saved on the device`
  String get vdslfailed {
    return Intl.message(
      'The new VDSL settings could not be saved on the device',
      name: 'vdslfailed',
      desc: '',
      args: [],
    );
  }

  /// `The new VDSL settings have been saved on the device`
  String get vdslsuccessful {
    return Intl.message(
      'The new VDSL settings have been saved on the device',
      name: 'vdslsuccessful',
      desc: '',
      args: [],
    );
  }

  /// `Automatic compatibility mode (recommended)`
  String get automaticCompatibilityMode {
    return Intl.message(
      'Automatic compatibility mode (recommended)',
      name: 'automaticCompatibilityMode',
      desc: '',
      args: [],
    );
  }

  /// `VDSL compatibility`
  String get vdslCompatibility {
    return Intl.message(
      'VDSL compatibility',
      name: 'vdslCompatibility',
      desc: '',
      args: [],
    );
  }

  /// `devolo Cockpit support informations`
  String get cockpitSupportInformationsTitle {
    return Intl.message(
      'devolo Cockpit support informations',
      name: 'cockpitSupportInformationsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Support informations are getting generated.`
  String get LoadCockpitSupportInformationsBody {
    return Intl.message(
      'Support informations are getting generated.',
      name: 'LoadCockpitSupportInformationsBody',
      desc: '',
      args: [],
    );
  }

  /// `The support informations have been created and are now available to you. Please select an action.`
  String get cockpitSupportInformationsBody {
    return Intl.message(
      'The support informations have been created and are now available to you. Please select an action.',
      name: 'cockpitSupportInformationsBody',
      desc: '',
      args: [],
    );
  }

  /// `E-mail is invalid`
  String get emailIsInvalid {
    return Intl.message(
      'E-mail is invalid',
      name: 'emailIsInvalid',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while creating the support informations.\nPlease try again!`
  String get supportInfoGenerateError {
    return Intl.message(
      'An error occurred while creating the support informations.\nPlease try again!',
      name: 'supportInfoGenerateError',
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
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
