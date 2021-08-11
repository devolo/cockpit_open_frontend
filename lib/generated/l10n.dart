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

  /// `Overview`
  String get overview {
    return Intl.message(
      'Overview',
      name: 'overview',
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

  /// `Help`
  String get help {
    return Intl.message(
      'Help',
      name: 'help',
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

  /// `App info`
  String get appInfo {
    return Intl.message(
      'App info',
      name: 'appInfo',
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

  /// `App information`
  String get appInformation {
    return Intl.message(
      'App information',
      name: 'appInformation',
      desc: '',
      args: [],
    );
  }

  /// `show licenses`
  String get showLicences {
    return Intl.message(
      'show licenses',
      name: 'showLicences',
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

  /// `Appearance`
  String get appearance {
    return Intl.message(
      'Appearance',
      name: 'appearance',
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

  /// `Show network speeds`
  String get enableShowingSpeeds {
    return Intl.message(
      'Show network speeds',
      name: 'enableShowingSpeeds',
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

  /// `Use internet-centered overview`
  String get internetCentered {
    return Intl.message(
      'Use internet-centered overview',
      name: 'internetCentered',
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

  /// `Show other devices`
  String get showOtherDevices {
    return Intl.message(
      'Show other devices',
      name: 'showOtherDevices',
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

  /// `App Theme`
  String get appTheme {
    return Intl.message(
      'App Theme',
      name: 'appTheme',
      desc: '',
      args: [],
    );
  }

  /// `Choose the app theme`
  String get chooseTheAppTheme {
    return Intl.message(
      'Choose the app theme',
      name: 'chooseTheAppTheme',
      desc: '',
      args: [],
    );
  }

  /// `Set font size`
  String get fontSize {
    return Intl.message(
      'Set font size',
      name: 'fontSize',
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
  String get changePlcNetworkPassword {
    return Intl.message(
      'Change PLC network password',
      name: 'changePlcNetworkPassword',
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

  /// `Show logs`
  String get showLogs {
    return Intl.message(
      'Show logs',
      name: 'showLogs',
      desc: '',
      args: [],
    );
  }

  /// `The password must contain more than 8 characters`
  String get passwordMustBeGreaterThan8Characters {
    return Intl.message(
      'The password must contain more than 8 characters',
      name: 'passwordMustBeGreaterThan8Characters',
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

  /// `Check for updates`
  String get checkUpdates {
    return Intl.message(
      'Check for updates',
      name: 'checkUpdates',
      desc: '',
      args: [],
    );
  }

  /// `Select all`
  String get selectAll {
    return Intl.message(
      'Select all',
      name: 'selectAll',
      desc: '',
      args: [],
    );
  }

  /// `Update selected`
  String get updateSelected {
    return Intl.message(
      'Update selected',
      name: 'updateSelected',
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

  /// `Update available`
  String get update2 {
    return Intl.message(
      'Update available',
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

  /// `complete`
  String get complete {
    return Intl.message(
      'complete',
      name: 'complete',
      desc: '',
      args: [],
    );
  }

  /// `failed`
  String get failed {
    return Intl.message(
      'failed',
      name: 'failed',
      desc: '',
      args: [],
    );
  }

  /// `pending`
  String get pending {
    return Intl.message(
      'pending',
      name: 'pending',
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

  /// `devolo Cockpit support information`
  String get cockpitSupportInformationTitle {
    return Intl.message(
      'devolo Cockpit support information',
      name: 'cockpitSupportInformationTitle',
      desc: '',
      args: [],
    );
  }

  /// `The created support information can now be sent to devolo support.\nFill in the following fields`
  String get theCreatedSupportInformationCanNowBeSentToDevolo {
    return Intl.message(
      'The created support information can now be sent to devolo support.\nFill in the following fields',
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

  /// `Contact information`
  String get contactInfo {
    return Intl.message(
      'Contact information',
      name: 'contactInfo',
      desc: '',
      args: [],
    );
  }

  /// `Your email address`
  String get yourEmailAddress {
    return Intl.message(
      'Your email address',
      name: 'yourEmailAddress',
      desc: '',
      args: [],
    );
  }

  /// `Support informations are getting generated`
  String get LoadCockpitSupportInformationBody {
    return Intl.message(
      'Support informations are getting generated',
      name: 'LoadCockpitSupportInformationBody',
      desc: '',
      args: [],
    );
  }

  /// `Support informations are sent to devolo`
  String get SendCockpitSupportInformationBody {
    return Intl.message(
      'Support informations are sent to devolo',
      name: 'SendCockpitSupportInformationBody',
      desc: '',
      args: [],
    );
  }

  /// `The support informations have been created and are now available to you. Please select an action.`
  String get cockpitSupportInformationBody {
    return Intl.message(
      'The support informations have been created and are now available to you. Please select an action.',
      name: 'cockpitSupportInformationBody',
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

  /// `Optimization help`
  String get optimizationHelp {
    return Intl.message(
      'Optimization help',
      name: 'optimizationHelp',
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

  /// `Security ID`
  String get securityId {
    return Intl.message(
      'Security ID',
      name: 'securityId',
      desc: '',
      args: [],
    );
  }

  /// `Add device via security ID`
  String get addDeviceViaSecurityId {
    return Intl.message(
      'Add device via security ID',
      name: 'addDeviceViaSecurityId',
      desc: '',
      args: [],
    );
  }

  /// `Enter the security ID of the new PLC device.\nThe security ID can be found on the back of the PLC device.`
  String get addDeviceViaSecurityIdDialogContent {
    return Intl.message(
      'Enter the security ID of the new PLC device.\nThe security ID can be found on the back of the PLC device.',
      name: 'addDeviceViaSecurityIdDialogContent',
      desc: '',
      args: [],
    );
  }

  /// `Device will be added`
  String get addDeviceLoading {
    return Intl.message(
      'Device will be added',
      name: 'addDeviceLoading',
      desc: '',
      args: [],
    );
  }

  /// `Select the network in which the device should be added.`
  String get chooseNetwork {
    return Intl.message(
      'Select the network in which the device should be added.',
      name: 'chooseNetwork',
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

  /// `Open`
  String get open {
    return Intl.message(
      'Open',
      name: 'open',
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

  /// `Send`
  String get send {
    return Intl.message(
      'Send',
      name: 'send',
      desc: '',
      args: [],
    );
  }

  /// `Device information`
  String get deviceInfo {
    return Intl.message(
      'Device information',
      name: 'deviceInfo',
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
  String get launchWebInterface {
    return Intl.message(
      'Web interface',
      name: 'launchWebInterface',
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

  /// `additional\nsettings`
  String get additionalSettings {
    return Intl.message(
      'additional\nsettings',
      name: 'additionalSettings',
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
  String get mtNumber {
    return Intl.message(
      'devolo MT number',
      name: 'mtNumber',
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
  String get ipAddress {
    return Intl.message(
      'IP address',
      name: 'ipAddress',
      desc: '',
      args: [],
    );
  }

  /// `MAC address`
  String get macAddress {
    return Intl.message(
      'MAC address',
      name: 'macAddress',
      desc: '',
      args: [],
    );
  }

  /// `No devices found. \n\nScanning for devices ...`
  String get noDevicesFoundScanningForDevices {
    return Intl.message(
      'No devices found. \n\nScanning for devices ...',
      name: 'noDevicesFoundScanningForDevices',
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

  /// `Confirm action`
  String get confirmAction {
    return Intl.message(
      'Confirm action',
      name: 'confirmAction',
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

  /// `An error occurred while identifying the device`
  String get deviceNotFoundIdentifyDevice {
    return Intl.message(
      'An error occurred while identifying the device',
      name: 'deviceNotFoundIdentifyDevice',
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

  /// `An error occurred while identifying the device.\nTry again later`
  String get identifyDeviceErrorBody {
    return Intl.message(
      'An error occurred while identifying the device.\nTry again later',
      name: 'identifyDeviceErrorBody',
      desc: '',
      args: [],
    );
  }

  /// `Setup failed`
  String get addDeviceErrorTitle {
    return Intl.message(
      'Setup failed',
      name: 'addDeviceErrorTitle',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while adding the device!\nTry again later`
  String get addDeviceErrorBody {
    return Intl.message(
      'An error occurred while adding the device!\nTry again later',
      name: 'addDeviceErrorBody',
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

  /// `Action failed`
  String get activateLEDsFailedTitle {
    return Intl.message(
      'Action failed',
      name: 'activateLEDsFailedTitle',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while modifying the LEDs!\nTry again later`
  String get activateLEDsFailedBody {
    return Intl.message(
      'An error occurred while modifying the LEDs!\nTry again later',
      name: 'activateLEDsFailedBody',
      desc: '',
      args: [],
    );
  }

  /// `Action failed`
  String get activateTransmissionFailedTitle {
    return Intl.message(
      'Action failed',
      name: 'activateTransmissionFailedTitle',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while setting the data communication!\nTry again later`
  String get activateTransmissionFailedBody {
    return Intl.message(
      'An error occurred while setting the data communication!\nTry again later',
      name: 'activateTransmissionFailedBody',
      desc: '',
      args: [],
    );
  }

  /// `Action failed`
  String get powerSavingModeFailedTitle {
    return Intl.message(
      'Action failed',
      name: 'powerSavingModeFailedTitle',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while setting the Power save mode!\nTry again later`
  String get powerSavingModeFailedBody {
    return Intl.message(
      'An error occurred while setting the Power save mode!\nTry again later',
      name: 'powerSavingModeFailedBody',
      desc: '',
      args: [],
    );
  }

  /// `Update failed`
  String get UpdateDeviceFailedTitle {
    return Intl.message(
      'Update failed',
      name: 'UpdateDeviceFailedTitle',
      desc: '',
      args: [],
    );
  }

  /// `Following devices could not be updated:`
  String get UpdateDeviceFailedBody {
    return Intl.message(
      'Following devices could not be updated:',
      name: 'UpdateDeviceFailedBody',
      desc: '',
      args: [],
    );
  }

  /// `Failed to send`
  String get supportInfoSendErrorTitle {
    return Intl.message(
      'Failed to send',
      name: 'supportInfoSendErrorTitle',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while sending support information to devolo.`
  String get supportInfoSendErrorBody1 {
    return Intl.message(
      'An error occurred while sending support information to devolo.',
      name: 'supportInfoSendErrorBody1',
      desc: '',
      args: [],
    );
  }

  /// `Check that your email address is correct and that you have entered a valid processing number.`
  String get supportInfoSendErrorBody2 {
    return Intl.message(
      'Check that your email address is correct and that you have entered a valid processing number.',
      name: 'supportInfoSendErrorBody2',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while creating the support informations.\nTry again later`
  String get supportInfoGenerateError {
    return Intl.message(
      'An error occurred while creating the support informations.\nTry again later',
      name: 'supportInfoGenerateError',
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

  /// `In rare cases, noise from Powerline signal can interfere with VDSL connection. Devices in automatic compatibility mode can automatically adjust transmission to limit interference`
  String get vdslExplanation {
    return Intl.message(
      'In rare cases, noise from Powerline signal can interfere with VDSL connection. Devices in automatic compatibility mode can automatically adjust transmission to limit interference',
      name: 'vdslExplanation',
      desc: '',
      args: [],
    );
  }

  /// `Select a transmission profile from the given options as a fallback when automatic mode is OFF or reliable detection of interference is not possible`
  String get vdslExplanation2 {
    return Intl.message(
      'Select a transmission profile from the given options as a fallback when automatic mode is OFF or reliable detection of interference is not possible',
      name: 'vdslExplanation2',
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
  String get vdslFailed {
    return Intl.message(
      'The new VDSL settings could not be saved on the device',
      name: 'vdslFailed',
      desc: '',
      args: [],
    );
  }

  /// `The new VDSL settings have been saved on the device`
  String get vdslSuccessful {
    return Intl.message(
      'The new VDSL settings have been saved on the device',
      name: 'vdslSuccessful',
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

  /// `Additional settings`
  String get additionalDialogTitle {
    return Intl.message(
      'Additional settings',
      name: 'additionalDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `LEDs activated`
  String get activateLEDs {
    return Intl.message(
      'LEDs activated',
      name: 'activateLEDs',
      desc: '',
      args: [],
    );
  }

  /// `Data communication activated`
  String get activateTransmission {
    return Intl.message(
      'Data communication activated',
      name: 'activateTransmission',
      desc: '',
      args: [],
    );
  }

  /// `Power saving mode`
  String get powerSavingMode {
    return Intl.message(
      'Power saving mode',
      name: 'powerSavingMode',
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
      Locale.fromSubtags(languageCode: 'fr'),
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
