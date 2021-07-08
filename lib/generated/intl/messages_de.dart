// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a de locale. All the
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
  String get localeName => 'de';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "LoadCockpitSupportInformationsBody":
            MessageLookupByLibrary.simpleMessage(
                "Support-Informationen werden erstellt."),
        "UpdateDeviceFailedBody": MessageLookupByLibrary.simpleMessage(
            "Folgende Geräte konnten nicht aktualisiert werden:"),
        "UpdateDeviceFailedTitle": MessageLookupByLibrary.simpleMessage(
            "Aktualisierung fehlgeschlagen"),
        "activateLEDs": MessageLookupByLibrary.simpleMessage(
            "Leuchtdioden (LEDs) angeschaltet"),
        "activateLEDsFailedBody": MessageLookupByLibrary.simpleMessage(
            "Es ist ein Fehler beim Ändern der LEDs aufgetreten!\nBitte versuchen Sie es erneut."),
        "activateLEDsFailedTitle":
            MessageLookupByLibrary.simpleMessage("Aktion fehlgeschlagen"),
        "activateTransmission":
            MessageLookupByLibrary.simpleMessage("Datenkommunikation erlauben"),
        "activateTransmissionFailedBody": MessageLookupByLibrary.simpleMessage(
            "Es ist ein Fehler beim Anpassen der Datenkommunikation aufgetreten!\nBitte versuchen Sie es erneut."),
        "activateTransmissionFailedTitle":
            MessageLookupByLibrary.simpleMessage("Aktion fehlgeschlagen"),
        "add": MessageLookupByLibrary.simpleMessage("Hinzufügen"),
        "addDevice": MessageLookupByLibrary.simpleMessage("Gerät hinzufügen"),
        "addDeviceErrorBody": MessageLookupByLibrary.simpleMessage(
            "Es ist ein Fehler beim Hinzufügen des Gerätes aufgetreten!\nBitte versuchen Sie es erneut."),
        "addDeviceErrorTitle":
            MessageLookupByLibrary.simpleMessage("Einrichtung fehlgeschlagen"),
        "addDeviceInstructionText": MessageLookupByLibrary.simpleMessage(
            "1.) Stecken Sie beide PLC-Geräte in die gewünschten Wandsteckdosen und warten ca. 45 Sekunden.\n2.) Drücken Sie kurz den Verschlüsselungsknopf des ersten (evtl. bereits vorhandenen) PLC-Gerätes.\n    (Alternativ kann das Pairing auch über das Webinterface des bereits vorhandenen Geräts gestartet werden.) \n3.) Drücken Sie innerhalb von zwei Minuten den Verschlüsselungsknopf des zweiten (neuen) PLC-Gerätes ebenfalls kurz.\n4.) Sobald die LEDs dauerhaft leuchten, sind die PLC-Geräte betriebsbereit."),
        "addDeviceLoading":
            MessageLookupByLibrary.simpleMessage("Gerät wird hinzugefügt"),
        "addDeviceViaSecurityId": MessageLookupByLibrary.simpleMessage(
            "Gerät mittels Security-ID hinzufügen"),
        "addDeviceViaSecurityIdDialogContent": MessageLookupByLibrary.simpleMessage(
            "Geben Sie die Security-ID des neuen PLC-Gerätes ein.\nDie Security-ID finden Sie auf der Rückseite des PLC-Gerätes"),
        "additionalDialogTitle":
            MessageLookupByLibrary.simpleMessage("Erweiterte Einstellungen"),
        "additionalSettings":
            MessageLookupByLibrary.simpleMessage("erweiterte\nEinstellungen"),
        "appInfo": MessageLookupByLibrary.simpleMessage("App Info"),
        "appInformation":
            MessageLookupByLibrary.simpleMessage("App Information"),
        "appTheme": MessageLookupByLibrary.simpleMessage("App Design"),
        "appearance": MessageLookupByLibrary.simpleMessage("Erscheinungbild"),
        "attachedToRouter": MessageLookupByLibrary.simpleMessage(
            "Ist am Router angeschlossen:"),
        "automaticCompatibilityMode": MessageLookupByLibrary.simpleMessage(
            "Automatischer Kompatibilitäsmodus (empfohlen)"),
        "back": MessageLookupByLibrary.simpleMessage("zurück"),
        "cancel": MessageLookupByLibrary.simpleMessage("Abbrechen"),
        "change": MessageLookupByLibrary.simpleMessage("ändern"),
        "changePlcnetworkPassword": MessageLookupByLibrary.simpleMessage(
            "PLC-Netzwerk Passwort ändern"),
        "changeTheLanguageOfTheApp":
            MessageLookupByLibrary.simpleMessage("Ändere die Sprache der App"),
        "checkUpdates":
            MessageLookupByLibrary.simpleMessage(" Aktualisierungen suchen "),
        "chooseNetwork": MessageLookupByLibrary.simpleMessage(
            "Wähle das Netzwerk in welchem das Gerät hinzugefügt werden soll."),
        "chooseTheAppTheme":
            MessageLookupByLibrary.simpleMessage("Wähle das App Design"),
        "chooseTheme": MessageLookupByLibrary.simpleMessage("Wähle Thema"),
        "cockpitSoftwareIsUpToDate": MessageLookupByLibrary.simpleMessage(
            "Cockpit Software auf dem neusten Stand."),
        "cockpitSupportInformationsBody": MessageLookupByLibrary.simpleMessage(
            "Die Support-Informationen wurden erstellt und stehen Ihnen jetzt zur Verfügung. Bitte wählen Sie eine Aktion aus."),
        "cockpitSupportInformationsTitle": MessageLookupByLibrary.simpleMessage(
            "devolo Cockpit Support-Informationen"),
        "complete": MessageLookupByLibrary.simpleMessage("erfolgreich"),
        "confirm": MessageLookupByLibrary.simpleMessage("Bestätigen"),
        "confirmAction":
            MessageLookupByLibrary.simpleMessage("Aktion Bestätigen"),
        "confirmActionConnectedToRouterWarning":
            MessageLookupByLibrary.simpleMessage(
                "Achtung! Ihr Router ist an dieses PLC-Gerät angeschlossen. Sie verlieren damit die Verbindung zum Internet "),
        "contactInfo": MessageLookupByLibrary.simpleMessage("Kontakt info"),
        "contactSupport":
            MessageLookupByLibrary.simpleMessage("Support kontaktieren"),
        "currentVersion":
            MessageLookupByLibrary.simpleMessage("Aktuelle Version"),
        "dataRatesArePermanentlyDisplayedInTheOverview":
            MessageLookupByLibrary.simpleMessage(
                "Datenraten werden dauerhaft in der Übersicht angezeigt "),
        "deleteDevice": MessageLookupByLibrary.simpleMessage("Gerät \nlöschen"),
        "deviceNameDialogBody": MessageLookupByLibrary.simpleMessage(
            "Möchten Sie wirklich den Gerätenamen ändern?"),
        "deviceNameDialogTitle":
            MessageLookupByLibrary.simpleMessage("Bestätigung"),
        "deviceNameErrorBody": MessageLookupByLibrary.simpleMessage(
            "Es ist ein Fehler beim Setzen des Gerätenamens aufgetreten!\nBitte versuchen Sie es erneut."),
        "deviceNameErrorTitle": MessageLookupByLibrary.simpleMessage(
            "Namensänderung fehlgeschlagen"),
        "deviceNotFoundDeviceName": MessageLookupByLibrary.simpleMessage(
            "Es ist ein Fehler beim Setzen des Gerätenamens aufgetreten!"),
        "deviceNotFoundHint": MessageLookupByLibrary.simpleMessage(
            " - Wurde das PLC-Gerät vom Stromnetz getrennt?\n - Befindet sich das PLC-Gerät im Stromsparmodus?"),
        "deviceNotFoundIdentifyDevice": MessageLookupByLibrary.simpleMessage(
            "Es ist ein Fehler beim Identifizieren des Gerätes aufgetreten!"),
        "deviceNotFoundRemoveDevice": MessageLookupByLibrary.simpleMessage(
            "Es ist ein Fehler beim Entfernen des Gerätes aufgetreten!"),
        "deviceNotFoundResetDevice": MessageLookupByLibrary.simpleMessage(
            "Es ist ein Fehler beim Zurücksetzen des Gerätes aufgetreten!"),
        "deviceinfo":
            MessageLookupByLibrary.simpleMessage("Geräteinformationen"),
        "emailIsInvalid":
            MessageLookupByLibrary.simpleMessage("Ungültige E-mail Adresse"),
        "enableShowingSpeeds":
            MessageLookupByLibrary.simpleMessage("Anzeigen der Datenraten"),
        "factoryReset":
            MessageLookupByLibrary.simpleMessage("Werkseinstellung \nsetzen"),
        "failed": MessageLookupByLibrary.simpleMessage("fehlgeschlagen"),
        "fontsize": MessageLookupByLibrary.simpleMessage("Schriftgröße"),
        "forward": MessageLookupByLibrary.simpleMessage("weiter"),
        "fullyCustomizeColors": MessageLookupByLibrary.simpleMessage(
            "Vollständig anpassbare Farben"),
        "general": MessageLookupByLibrary.simpleMessage("Allgemein"),
        "generateSupportInformation": MessageLookupByLibrary.simpleMessage(
            "Support Informationen generieren "),
        "help": MessageLookupByLibrary.simpleMessage("Hilfe"),
        "highContrast": MessageLookupByLibrary.simpleMessage("Hoher Kontrast"),
        "homeNetworkDesktop":
            MessageLookupByLibrary.simpleMessage("Home Netzwerk Desktop"),
        "identifyDevice":
            MessageLookupByLibrary.simpleMessage("Gerät \nidentifizieren"),
        "identifyDeviceErrorTitle": MessageLookupByLibrary.simpleMessage(
            "Identifizierung fehlgeschlagen"),
        "ignoreUpdates": MessageLookupByLibrary.simpleMessage(
            "Ignoriere zukünftige Aktualisierungen (Updates)"),
        "install": MessageLookupByLibrary.simpleMessage("Installieren"),
        "internet": MessageLookupByLibrary.simpleMessage("Internet"),
        "internetcentered":
            MessageLookupByLibrary.simpleMessage("Internetzentrisch"),
        "ipaddress": MessageLookupByLibrary.simpleMessage("IP-Adresse"),
        "isLocalDevice":
            MessageLookupByLibrary.simpleMessage("Ist lokales Gerät:"),
        "language": MessageLookupByLibrary.simpleMessage("Sprache"),
        "launchWebinterface":
            MessageLookupByLibrary.simpleMessage("Webinterface \nöffnen "),
        "macaddress": MessageLookupByLibrary.simpleMessage("MAC-Adresse"),
        "manualErrorBody": MessageLookupByLibrary.simpleMessage(
            "Für Ihr PLC-Gerät wurde kein passendes Handbuch gefunden.\n\nSie können das Handbuch auf der Produkt-CD oder der devolo Internet-Seite finden."),
        "manualErrorTitle":
            MessageLookupByLibrary.simpleMessage("Handbuch nicht gefunden"),
        "mtnumber": MessageLookupByLibrary.simpleMessage("devolo MT-Nummer"),
        "name": MessageLookupByLibrary.simpleMessage("Name"),
        "network": MessageLookupByLibrary.simpleMessage("Netzwerk"),
        "networkPasswordErrorBody": MessageLookupByLibrary.simpleMessage(
            "Es ist ein Fehler beim Setzen des Netzwerk-Kennwortes aufgetreten!"),
        "networkPasswordErrorHint": MessageLookupByLibrary.simpleMessage(
            "- Prüfen Sie die Verbindung zum PLC-Gerät und wiederholen Sie die Aktion!"),
        "networkPasswordErrorTitle": MessageLookupByLibrary.simpleMessage(
            "Setzen des Netzwerk-Kennworts fehlgeschlagen "),
        "networkSettings":
            MessageLookupByLibrary.simpleMessage("Netzwerk Einstellungen"),
        "networkoverview":
            MessageLookupByLibrary.simpleMessage("Netzwerkübersicht"),
        "newVersion": MessageLookupByLibrary.simpleMessage("neue Version"),
        "nextNetwork":
            MessageLookupByLibrary.simpleMessage("nächstes Netzwerk"),
        "no": MessageLookupByLibrary.simpleMessage("Nein"),
        "noDevicesFoundNscanningForDevices":
            MessageLookupByLibrary.simpleMessage(
                "No devices found \nScanning for devices ..."),
        "openOptimization":
            MessageLookupByLibrary.simpleMessage("Optimierungshilfe öffnen"),
        "openSupportInformations":
            MessageLookupByLibrary.simpleMessage("Öffnen"),
        "optimizationHelp":
            MessageLookupByLibrary.simpleMessage("Optimierungs Hilfe"),
        "optimizeReception":
            MessageLookupByLibrary.simpleMessage("Empfang optimieren"),
        "otherDevicesEgPcAreDisplayedInTheOverview":
            MessageLookupByLibrary.simpleMessage(
                "Weitere Geräte, z.B. PC werden in der Übersicht angezeigt"),
        "overview": MessageLookupByLibrary.simpleMessage("Übersicht"),
        "pending": MessageLookupByLibrary.simpleMessage("anstehend"),
        "pleaseConfirmAction":
            MessageLookupByLibrary.simpleMessage("Bitte Aktion bestätigen."),
        "pleaseEnterDeviceName":
            MessageLookupByLibrary.simpleMessage("Bitte Gerätenamen eintragen"),
        "pleaseEnterDevicename":
            MessageLookupByLibrary.simpleMessage("Bitte Gerätenamen eintragen"),
        "pleaseEnterPassword":
            MessageLookupByLibrary.simpleMessage("Bitte Passwort eingeben"),
        "pleaseEnterProcessingNumber": MessageLookupByLibrary.simpleMessage(
            "Bitte Bearbeitungsnummer eintragen"),
        "pleaseEnterYourMailAddress": MessageLookupByLibrary.simpleMessage(
            "Bitte tragen Sie ihre E-mail Adresse ein"),
        "pleaseFillInYourName": MessageLookupByLibrary.simpleMessage(
            "Bitte tragen Sie ihren Namen ein"),
        "powerSavingMode":
            MessageLookupByLibrary.simpleMessage("Stromsparmodus"),
        "powerSavingModeFailedBody": MessageLookupByLibrary.simpleMessage(
            "Es ist ein Fehler beim Anpassen des Stromsparmodus aufgetreten!\nBitte versuchen Sie es erneut."),
        "powerSavingModeFailedTitle":
            MessageLookupByLibrary.simpleMessage("Aktion fehlgeschlagen"),
        "previousNetwork":
            MessageLookupByLibrary.simpleMessage("vorheriges Netzwerk"),
        "processNumber":
            MessageLookupByLibrary.simpleMessage("Bearbeitungsnummer"),
        "recordTheTransmissionPowerOfTheDevicesAndTransmitIt":
            MessageLookupByLibrary.simpleMessage(
                "Übertragungsleistung der Geräte Aufzeichnen und an devolo übermitteln"),
        "refresh": MessageLookupByLibrary.simpleMessage("neu laden"),
        "removeDeviceConfirmBody": MessageLookupByLibrary.simpleMessage(
            "Wollen Sie das gewählte PLC-Gerät aus dem Netzwerk entfernen?"),
        "removeDeviceConfirmTitle":
            MessageLookupByLibrary.simpleMessage("Das PLC-Gerät entfernen?"),
        "removeDeviceErrorBody": MessageLookupByLibrary.simpleMessage(
            "Es ist ein Fehler beim Entfernen des Gerätes aufgetreten!\nBitte versuchen Sie es erneut."),
        "removeDeviceErrorTitle":
            MessageLookupByLibrary.simpleMessage("Löschvorgang fehlgeschlagen"),
        "resetDeviceConfirmBody": MessageLookupByLibrary.simpleMessage(
            "Wollen Sie das gewählte PLC-Gerät in den Auslieferungszustand zurücksetzen?"),
        "resetDeviceConfirmTitle": MessageLookupByLibrary.simpleMessage(
            "Gerät in den Auslieferunszustand zurücksetzen"),
        "resetDeviceErrorBody": MessageLookupByLibrary.simpleMessage(
            "Es ist ein Fehler beim Zurücksetzen des Gerätes aufgetreten!\nBitte versuchen Sie es erneut."),
        "resetDeviceErrorTitle": MessageLookupByLibrary.simpleMessage(
            "Zurücksetzung fehlgeschlagen"),
        "save": MessageLookupByLibrary.simpleMessage("speichern"),
        "saveSupportInformations":
            MessageLookupByLibrary.simpleMessage("Speichern"),
        "searching": MessageLookupByLibrary.simpleMessage("suche..."),
        "selectAll": MessageLookupByLibrary.simpleMessage("Alle auswählen"),
        "securityId": MessageLookupByLibrary.simpleMessage("Security-ID"),
        "sendToDevolo": MessageLookupByLibrary.simpleMessage("Senden"),
        "serialNumber": MessageLookupByLibrary.simpleMessage("Seriennummer"),
        "setUpDevice": MessageLookupByLibrary.simpleMessage("Gerät einrichten"),
        "setVdslCompatibility": MessageLookupByLibrary.simpleMessage(
            "VDSL Kompatibilität \nsetzen"),
        "settings": MessageLookupByLibrary.simpleMessage("Einstellungen"),
        "showLicences":
            MessageLookupByLibrary.simpleMessage("Lizenzen anzeigen"),
        "showLogs": MessageLookupByLibrary.simpleMessage("Zeige Logs"),
        "showManual":
            MessageLookupByLibrary.simpleMessage("Handbuch \nanzeigen"),
        "showOtherDevices":
            MessageLookupByLibrary.simpleMessage("Anzeigen anderer Geräte"),
        "showPassword":
            MessageLookupByLibrary.simpleMessage("Passwort anzeigen "),
        "state": MessageLookupByLibrary.simpleMessage("Status"),
        "support": MessageLookupByLibrary.simpleMessage("Support"),
        "supportInfoGenerateError": MessageLookupByLibrary.simpleMessage(
            "Bei der Erstellung der Support Informationen ist ein Fehler aufgetreten.\nBitte versuchen Sie es erneut!"),
        "theCreatedSupportInformationCanNowBeSentToDevolo":
            MessageLookupByLibrary.simpleMessage(
                "Die erstellten Support-Informationen können jetzt zum devolo Support gesendet werden.\nBitte füllen Sie folgende Felder aus."),
        "theOverviewWillBeCenteredAroundThePlcDeviceConnected":
            MessageLookupByLibrary.simpleMessage(
                "Die Übersicht wird um das PLC-Gerät zentriert, welches am Internet angeschlossen ist"),
        "thisDeviceIsConnectedDirectlyToTheInternetRouter":
            MessageLookupByLibrary.simpleMessage(
                "Dieses Gerät ist direkt an den Internet-Router angeschlossen."),
        "thisPc": MessageLookupByLibrary.simpleMessage("Dieser PC"),
        "title": MessageLookupByLibrary.simpleMessage("devolo Cockpit"),
        "type": MessageLookupByLibrary.simpleMessage("Typ"),
        "upToDate": MessageLookupByLibrary.simpleMessage("aktuell"),
        "update": MessageLookupByLibrary.simpleMessage("Aktualisierung"),
        "update2":
            MessageLookupByLibrary.simpleMessage("Aktualisierung verfügbar"),
        "updateReadyToInstall": MessageLookupByLibrary.simpleMessage(
            "Update bereit zur Installation."),
        "updateSelected":
            MessageLookupByLibrary.simpleMessage("Aktualisiere Auswahl"),
        "updates": MessageLookupByLibrary.simpleMessage("Aktualisierungen"),
        "updating": MessageLookupByLibrary.simpleMessage(" aktualisieren..."),
        "vdslCompatibility":
            MessageLookupByLibrary.simpleMessage("VDSL Kompatibilität"),
        "vdslexplanation": MessageLookupByLibrary.simpleMessage(
            "In seltenen Fällen können VDSL-Verbindungsprobleme durch Übersprechen des Powerline-Signals verursacht werden. Wenn der automatische Kompatibilitätsmodus aktiv ist, versucht das Gerät, diese Situation zu erkennen und automatisch seinen Sendepegel so anzupassen, dass die bestmögliche Leistung ohne Störung erzielt wird."),
        "vdslexplanation2": MessageLookupByLibrary.simpleMessage(
            "Wenn der automatische Modus deaktiviert ist oder die Störung nicht zuverlässig erkannt werden kann, kann stattdessen ein fest eingestelltes Profil für eine angepasste Sendeleistung verwendet werden. Wählen Sie das Profil aus, das dem Typ ihres VDSL-Anschlusses entspricht, oder wählen Sie \"volle Leistung\", wenn keine Störungsvermeidung benötigt wird."),
        "vdslfailed": MessageLookupByLibrary.simpleMessage(
            "Die neuen VDSL-Einstellungen konnten nicht auf dem Gerät gespeichert werden."),
        "vdslsuccessful": MessageLookupByLibrary.simpleMessage(
            "Die neuen VDSL-Einstellungen wurden auf dem Gerät gespeichert."),
        "version": MessageLookupByLibrary.simpleMessage("Firmware-Version"),
        "windowsNetworkThrottling":
            MessageLookupByLibrary.simpleMessage("Windows Netzwerkdrosselung"),
        "yes": MessageLookupByLibrary.simpleMessage("Ja"),
        "yourCurrentTerminalIsConnectedToThisDevolodevice":
            MessageLookupByLibrary.simpleMessage(
                "Ihr aktuelles Endgerät ist mit diesem devolo-Gerät verbunden."),
        "yourEmailaddress":
            MessageLookupByLibrary.simpleMessage(" Ihre E-mail Adresse"),
        "yourName": MessageLookupByLibrary.simpleMessage("Ihr Name"),
        "yourPc": MessageLookupByLibrary.simpleMessage("Dein PC")
      };
}
