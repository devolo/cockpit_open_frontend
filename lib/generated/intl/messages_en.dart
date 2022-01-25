// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "LoadCockpitSupportInformationBody":
            MessageLookupByLibrary.simpleMessage(
                "Support informations are getting generated"),
        "SendCockpitSupportInformationBody":
            MessageLookupByLibrary.simpleMessage(
                "Support informations are sent to devolo"),
        "activateLEDs": MessageLookupByLibrary.simpleMessage("LEDs activated"),
        "activateLEDsFailedBody": MessageLookupByLibrary.simpleMessage(
            "An error occurred while modifying the LEDs!\nTry again later"),
        "activateLEDsFailedTitle":
            MessageLookupByLibrary.simpleMessage("Action failed"),
        "activateTransmission": MessageLookupByLibrary.simpleMessage(
            "Data communication activated"),
        "activateTransmissionFailedBody": MessageLookupByLibrary.simpleMessage(
            "An error occurred while setting the data communication!\nTry again later"),
        "activateTransmissionFailedTitle":
            MessageLookupByLibrary.simpleMessage("Action failed"),
        "addDeviceErrorBody": MessageLookupByLibrary.simpleMessage(
            "An error occurred while adding the device!\nTry again later"),
        "addDeviceErrorTitle":
            MessageLookupByLibrary.simpleMessage("Setup failed"),
        "addDeviceInstructionText": MessageLookupByLibrary.simpleMessage(
            "1) Plug both PLC devices into wall sockets and wait for 45 seconds.\n2) Briefly press the encryption button of the existing PLC device.\n(Alternatively start pairing via the web interface of the existing device.)\n3) Within 2 minutes, press the encryption button of the new PLC device also briefly.\n4) As soon as the LEDs light up and do not blink, the PLC devices are ready for operation."),
        "addDeviceLoading":
            MessageLookupByLibrary.simpleMessage("Device will be added"),
        "addDeviceViaSecurityId":
            MessageLookupByLibrary.simpleMessage("Add device via security ID"),
        "addDeviceViaSecurityIdDialogContent": MessageLookupByLibrary.simpleMessage(
            "Enter the security ID of the new PLC device.\nThe security ID can be found on the back of the PLC device."),
        "additionalDialogTitle":
            MessageLookupByLibrary.simpleMessage("Additional settings"),
        "additionalSettings":
            MessageLookupByLibrary.simpleMessage("additional settings"),
        "appInfo": MessageLookupByLibrary.simpleMessage("App info"),
        "appInformation":
            MessageLookupByLibrary.simpleMessage("App information"),
        "appTheme": MessageLookupByLibrary.simpleMessage("App Theme"),
        "appearance": MessageLookupByLibrary.simpleMessage("Appearance"),
        "automaticCompatibilityMode": MessageLookupByLibrary.simpleMessage(
            "Automatic compatibility mode (recommended)"),
        "back": MessageLookupByLibrary.simpleMessage("Back"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "change": MessageLookupByLibrary.simpleMessage("Change"),
        "changePlcNetworkPassword":
            MessageLookupByLibrary.simpleMessage("Change PLC network password"),
        "changeTheLanguageOfTheApp": MessageLookupByLibrary.simpleMessage(
            "Change the language of the App"),
        "checkForUpdates":
            MessageLookupByLibrary.simpleMessage("Regularly check for updates"),
        "checkUpdates":
            MessageLookupByLibrary.simpleMessage("Check for updates"),
        "chooseNetwork": MessageLookupByLibrary.simpleMessage(
            "Select the network in which the device should be added."),
        "chooseTheAppTheme":
            MessageLookupByLibrary.simpleMessage("Choose the app theme"),
        "cockpitSupportInformationBody": MessageLookupByLibrary.simpleMessage(
            "The support informations have been created and are now available to you. Please select an action."),
        "cockpitSupportInformationTitle": MessageLookupByLibrary.simpleMessage(
            "devolo Cockpit support information"),
        "complete": MessageLookupByLibrary.simpleMessage("complete"),
        "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
        "confirmAction": MessageLookupByLibrary.simpleMessage("Confirm action"),
        "confirmActionConnectedToRouterWarning":
            MessageLookupByLibrary.simpleMessage(
                "Attention! Your router is connected to this PLC device. You will lose connection to the internet"),
        "contactInfo":
            MessageLookupByLibrary.simpleMessage("Contact information"),
        "contactSupport": MessageLookupByLibrary.simpleMessage("Support"),
        "currentCompatibility":
            MessageLookupByLibrary.simpleMessage("Current compatibility"),
        "currentVersion":
            MessageLookupByLibrary.simpleMessage("Current version"),
        "currentlyNotAvailableBody": MessageLookupByLibrary.simpleMessage(
            "This feature is currently under development\nand will be available in the near future."),
        "currentlyNotAvailableTitle":
            MessageLookupByLibrary.simpleMessage("Beta-Notification"),
        "dataRatesArePermanentlyDisplayedInTheOverview":
            MessageLookupByLibrary.simpleMessage(
                "Data transfer rates are always shown in overview"),
        "deviceInfo":
            MessageLookupByLibrary.simpleMessage("Device information"),
        "deviceNameDialogBody": MessageLookupByLibrary.simpleMessage(
            "Do you want to rename this device?"),
        "deviceNameDialogTitle":
            MessageLookupByLibrary.simpleMessage("Confirm"),
        "deviceNameErrorBody": MessageLookupByLibrary.simpleMessage(
            "An error occurred while changing the name.\nTry again later"),
        "deviceNameErrorTitle":
            MessageLookupByLibrary.simpleMessage("Name change failed"),
        "deviceNotFoundDeviceName": MessageLookupByLibrary.simpleMessage(
            "An error occurred while setting the device name"),
        "deviceNotFoundHint": MessageLookupByLibrary.simpleMessage(
            " - Has the PLC device been disconnected from the power grid?\n - Is the PLC device in power-saving mode?"),
        "deviceNotFoundIdentifyDevice": MessageLookupByLibrary.simpleMessage(
            "An error occurred while identifying the device"),
        "deviceNotFoundRemoveDevice": MessageLookupByLibrary.simpleMessage(
            "An error occurred while removing the device"),
        "deviceNotFoundResetDevice": MessageLookupByLibrary.simpleMessage(
            "An error occurred while resetting the device"),
        "deviceNotFoundSetIpConfig": MessageLookupByLibrary.simpleMessage(
            "An error occurred while changing the IP address/netmask"),
        "deviceSettings":
            MessageLookupByLibrary.simpleMessage("Device Settings"),
        "emailIsInvalid":
            MessageLookupByLibrary.simpleMessage("E-mail is invalid"),
        "enableShowingSpeeds":
            MessageLookupByLibrary.simpleMessage("Show network speeds"),
        "errorScreenText": MessageLookupByLibrary.simpleMessage(
            "The content cannot be displayed!"),
        "factoryReset": MessageLookupByLibrary.simpleMessage("Factory reset"),
        "failed": MessageLookupByLibrary.simpleMessage("failed"),
        "fillInIpAddress":
            MessageLookupByLibrary.simpleMessage("Enter the IP address"),
        "fillInNetmask":
            MessageLookupByLibrary.simpleMessage("Enter the netmask"),
        "fontSize": MessageLookupByLibrary.simpleMessage("Set font size"),
        "forward": MessageLookupByLibrary.simpleMessage("Next"),
        "general": MessageLookupByLibrary.simpleMessage("General"),
        "help": MessageLookupByLibrary.simpleMessage("Help"),
        "highContrast": MessageLookupByLibrary.simpleMessage("High contrast"),
        "identifyDevice":
            MessageLookupByLibrary.simpleMessage("Identify device"),
        "identifyDeviceErrorBody": MessageLookupByLibrary.simpleMessage(
            "An error occurred while identifying the device.\nTry again later"),
        "identifyDeviceErrorTitle":
            MessageLookupByLibrary.simpleMessage("Identifying failed"),
        "identifyDeviceTooltip": MessageLookupByLibrary.simpleMessage(
            "The light-emitting diode (LED) flashes for two minutes"),
        "incompleteDeviceInfoText": MessageLookupByLibrary.simpleMessage(
            "This device cannot be reached via the IP protocol. This indicates a faulty network configuration, for example, the device may not have received an IP address from your Internet router. Some functions are therefore not available."),
        "internet": MessageLookupByLibrary.simpleMessage("Internet"),
        "internetCentered": MessageLookupByLibrary.simpleMessage(
            "Use internet-centered overview"),
        "ipAddress": MessageLookupByLibrary.simpleMessage("IP address"),
        "language": MessageLookupByLibrary.simpleMessage("Language"),
        "launchWebInterface":
            MessageLookupByLibrary.simpleMessage("Web interface"),
        "macAddress": MessageLookupByLibrary.simpleMessage("MAC address"),
        "manualErrorBody": MessageLookupByLibrary.simpleMessage(
            "No suitable manual was found for your PLC device.\nYou can find the manual on the product CD or on the devolo website."),
        "manualErrorTitle":
            MessageLookupByLibrary.simpleMessage("Manual not found"),
        "mimoFull": MessageLookupByLibrary.simpleMessage("Full power"),
        "mimoVdslProfil17a":
            MessageLookupByLibrary.simpleMessage("VDSL Profil 17a"),
        "mimoVdslProfil35a":
            MessageLookupByLibrary.simpleMessage("VDSL Profil 35a"),
        "mtNumber": MessageLookupByLibrary.simpleMessage("devolo MT number"),
        "name": MessageLookupByLibrary.simpleMessage("Name"),
        "netmask": MessageLookupByLibrary.simpleMessage("Netmask"),
        "network": MessageLookupByLibrary.simpleMessage("Network"),
        "networkPasswordErrorBody": MessageLookupByLibrary.simpleMessage(
            "An error occurred while setting the network password"),
        "networkPasswordErrorHint": MessageLookupByLibrary.simpleMessage(
            "- Check the connection to the PLC device and repeat the action"),
        "networkPasswordErrorTitle": MessageLookupByLibrary.simpleMessage(
            "Failed to set the network password"),
        "networkSettings":
            MessageLookupByLibrary.simpleMessage("Network Settings"),
        "noDevicesFoundScanningForDevices":
            MessageLookupByLibrary.simpleMessage(
                "No local device found.\nScanning for devices"),
        "noconnection":
            MessageLookupByLibrary.simpleMessage("Connection error"),
        "noconnectionbody": MessageLookupByLibrary.simpleMessage(
            "No connection could be established to the devolo network service (devolonetworkservice)."),
        "open": MessageLookupByLibrary.simpleMessage("Open"),
        "optimizationHelp":
            MessageLookupByLibrary.simpleMessage("Optimization help"),
        "optimizeReception":
            MessageLookupByLibrary.simpleMessage("Optimize reception"),
        "otherDevicesEgPcAreDisplayedInTheOverview":
            MessageLookupByLibrary.simpleMessage(
                "Overview shows other devices, e.g., laptops and mobiles"),
        "overview": MessageLookupByLibrary.simpleMessage("Overview"),
        "passwordMustBeGreaterThan8Characters":
            MessageLookupByLibrary.simpleMessage(
                "The password must contain more than 8 characters"),
        "pending": MessageLookupByLibrary.simpleMessage("pending"),
        "plcNetworkPassword":
            MessageLookupByLibrary.simpleMessage("PLC network password"),
        "pleaseEnterDeviceName":
            MessageLookupByLibrary.simpleMessage("Enter device name"),
        "pleaseEnterPassword":
            MessageLookupByLibrary.simpleMessage("Enter password"),
        "pleaseEnterProcessingNumber":
            MessageLookupByLibrary.simpleMessage("Enter processing number"),
        "pleaseEnterYourMailAddress":
            MessageLookupByLibrary.simpleMessage("Enter your email address"),
        "pleaseFillInYourName":
            MessageLookupByLibrary.simpleMessage("Enter your name"),
        "powerSavingMode":
            MessageLookupByLibrary.simpleMessage("Power saving mode"),
        "powerSavingModeFailedBody": MessageLookupByLibrary.simpleMessage(
            "An error occurred while setting the Power save mode!\nTry again later"),
        "powerSavingModeFailedTitle":
            MessageLookupByLibrary.simpleMessage("Action failed"),
        "privacyWarningDialogBody": MessageLookupByLibrary.simpleMessage(
            "After this update, the devices will automatically check for new firmware on a regular basis and update it if necessary. In this case, your public IP address will be collected and deleted immediately after the update.\n\nWould you like to install them now?"),
        "privacyWarningDialogTitle":
            MessageLookupByLibrary.simpleMessage("Update information"),
        "processNumber": MessageLookupByLibrary.simpleMessage("Process number"),
        "recordTheTransmissionPowerOfTheDevicesAndTransmitIt":
            MessageLookupByLibrary.simpleMessage(
                "Record the transmission power of PLC devices and send it to devolo"),
        "refresh": MessageLookupByLibrary.simpleMessage("Refresh"),
        "removeDevice": MessageLookupByLibrary.simpleMessage("Remove device"),
        "removeDeviceConfirmBody": MessageLookupByLibrary.simpleMessage(
            "Do you want to remove the selected PLC device from the network?"),
        "removeDeviceConfirmTitle":
            MessageLookupByLibrary.simpleMessage("Remove the PLC device?"),
        "removeDeviceErrorBody": MessageLookupByLibrary.simpleMessage(
            "An error occurred while removing the device!\nTry again later"),
        "removeDeviceErrorTitle":
            MessageLookupByLibrary.simpleMessage("Remove failed"),
        "repeat": MessageLookupByLibrary.simpleMessage("Repeat"),
        "resetDeviceConfirmBody": MessageLookupByLibrary.simpleMessage(
            "Do you want to reset the selected PLC device to the delivery state?"),
        "resetDeviceConfirmTitle": MessageLookupByLibrary.simpleMessage(
            "Reset device to delivery state"),
        "resetDeviceErrorBody": MessageLookupByLibrary.simpleMessage(
            "An error occurred while resetting the device!\nTry again later"),
        "resetDeviceErrorTitle":
            MessageLookupByLibrary.simpleMessage("Reset failed"),
        "restart": MessageLookupByLibrary.simpleMessage("Restart"),
        "samePasswordForAll": MessageLookupByLibrary.simpleMessage(
            "Same password for all devices"),
        "save": MessageLookupByLibrary.simpleMessage("Save"),
        "searchManualAndUpdates": MessageLookupByLibrary.simpleMessage(
            "Search for manual and updates"),
        "searchManualConfirmBody": MessageLookupByLibrary.simpleMessage(
            "No suitable manual was found for your device.\nDo you want to check if manuals and updates are available?"),
        "searching": MessageLookupByLibrary.simpleMessage("Searching..."),
        "securityId": MessageLookupByLibrary.simpleMessage("Security ID"),
        "selectAll": MessageLookupByLibrary.simpleMessage("Select all"),
        "selectProfile":
            MessageLookupByLibrary.simpleMessage("select profile ..."),
        "send": MessageLookupByLibrary.simpleMessage("Send"),
        "serialNumber": MessageLookupByLibrary.simpleMessage("Serial number"),
        "setIpConfigErrorBody": MessageLookupByLibrary.simpleMessage(
            "An error occurred while changing the IP address/netmask!\nTry again later"),
        "setIpConfigErrorTitle":
            MessageLookupByLibrary.simpleMessage("Configuration failed"),
        "setUpDevice": MessageLookupByLibrary.simpleMessage("Setup new device"),
        "setVdslCompatibility":
            MessageLookupByLibrary.simpleMessage("Set VDSL compatibility"),
        "settings": MessageLookupByLibrary.simpleMessage("Settings"),
        "showLicences": MessageLookupByLibrary.simpleMessage("show licenses"),
        "showLogs": MessageLookupByLibrary.simpleMessage("Show logs"),
        "showManual": MessageLookupByLibrary.simpleMessage("Show manual"),
        "showOtherDevices":
            MessageLookupByLibrary.simpleMessage("Show other devices"),
        "showPassword": MessageLookupByLibrary.simpleMessage("Show password"),
        "sisoFull": MessageLookupByLibrary.simpleMessage("Full power"),
        "sisoVdslProfil17a":
            MessageLookupByLibrary.simpleMessage("VDSL Profil 17a"),
        "sisoVdslProfil35b":
            MessageLookupByLibrary.simpleMessage("VDSL Profil 35b"),
        "standard": MessageLookupByLibrary.simpleMessage("(default)"),
        "state": MessageLookupByLibrary.simpleMessage("Update status"),
        "success": MessageLookupByLibrary.simpleMessage("Success"),
        "supportInfoGenerateError": MessageLookupByLibrary.simpleMessage(
            "An error occurred while creating the support informations.\nTry again later"),
        "supportInfoSendErrorBody1": MessageLookupByLibrary.simpleMessage(
            "An error occurred while sending support information to devolo."),
        "supportInfoSendErrorBody2": MessageLookupByLibrary.simpleMessage(
            "Check that your email address is correct and that you have entered a valid processing number."),
        "supportInfoSendErrorTitle":
            MessageLookupByLibrary.simpleMessage("Failed to send"),
        "switchNetwork": MessageLookupByLibrary.simpleMessage("Switch Network"),
        "theCreatedSupportInformationCanNowBeSentToDevolo":
            MessageLookupByLibrary.simpleMessage(
                "The created support information can now be sent to devolo support.\nFill in the following fields"),
        "theOverviewWillBeCenteredAroundThePlcDeviceConnected":
            MessageLookupByLibrary.simpleMessage(
                "The overview is centered around the PLC device connected to the internet"),
        "thisPc": MessageLookupByLibrary.simpleMessage("This PC"),
        "title": MessageLookupByLibrary.simpleMessage("devolo Cockpit"),
        "type": MessageLookupByLibrary.simpleMessage("Type"),
        "upToDate": MessageLookupByLibrary.simpleMessage("Up-to-date"),
        "upToDatePlaceholder": MessageLookupByLibrary.simpleMessage("ilable"),
        "update": MessageLookupByLibrary.simpleMessage("Update"),
        "updateAvailable":
            MessageLookupByLibrary.simpleMessage("Update available"),
        "updateDeviceFailedBody": MessageLookupByLibrary.simpleMessage(
            "Following devices could not be updated:"),
        "updateDeviceFailedTitle":
            MessageLookupByLibrary.simpleMessage("Update failed"),
        "updateDevicePasswordNeededBody1": MessageLookupByLibrary.simpleMessage(
            "The following device requires a password to update:"),
        "updateDevicePasswordNeededBody2": MessageLookupByLibrary.simpleMessage(
            "Enter the passwords of following devices to update them:"),
        "updateDevicePasswordNeededTitle":
            MessageLookupByLibrary.simpleMessage("Password required"),
        "updateDialogTitle":
            MessageLookupByLibrary.simpleMessage("Update information"),
        "updateFailed": MessageLookupByLibrary.simpleMessage("Update failed"),
        "updateSelected":
            MessageLookupByLibrary.simpleMessage("Update selected"),
        "updates": MessageLookupByLibrary.simpleMessage("Updates"),
        "updating": MessageLookupByLibrary.simpleMessage("Updating..."),
        "vdslCompatibility":
            MessageLookupByLibrary.simpleMessage("VDSL compatibility"),
        "vdslExplanation": MessageLookupByLibrary.simpleMessage(
            "In rare cases, noise from Powerline signal can interfere with VDSL connection. Devices in automatic compatibility mode can automatically adjust transmission to limit interference"),
        "vdslExplanation2": MessageLookupByLibrary.simpleMessage(
            "Select a transmission profile from the given options as a fallback when automatic mode is OFF or reliable detection of interference is not possible"),
        "vdslFailed": MessageLookupByLibrary.simpleMessage(
            "The new VDSL settings could not be saved on the device"),
        "vdslSuccessful": MessageLookupByLibrary.simpleMessage(
            "The new VDSL settings have been saved on the device"),
        "version": MessageLookupByLibrary.simpleMessage("Firmware version"),
        "yourEmailAddress":
            MessageLookupByLibrary.simpleMessage("Your email address"),
        "yourName": MessageLookupByLibrary.simpleMessage("Your name"),
        "yourPc": MessageLookupByLibrary.simpleMessage("Your PC")
      };
}
