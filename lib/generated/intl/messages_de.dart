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
        "LoadCockpitSupportInformationBody":
            MessageLookupByLibrary.simpleMessage(
                "Support-Informationen werden erstellt"),
        "SendCockpitSupportInformationBody":
            MessageLookupByLibrary.simpleMessage(
                "Support-Informationen werden nach devolo gesendet"),
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
            MessageLookupByLibrary.simpleMessage("erweiterte Einstellungen"),
        "appInfo": MessageLookupByLibrary.simpleMessage("App Info"),
        "appInformation":
            MessageLookupByLibrary.simpleMessage("App Information"),
        "appTheme": MessageLookupByLibrary.simpleMessage("App Design"),
        "appearance": MessageLookupByLibrary.simpleMessage("Erscheinungbild"),
        "automaticCompatibilityMode": MessageLookupByLibrary.simpleMessage(
            "Automatischer Kompatibilitäsmodus (empfohlen)"),
        "back": MessageLookupByLibrary.simpleMessage("zurück"),
        "cancel": MessageLookupByLibrary.simpleMessage("Abbrechen"),
        "change": MessageLookupByLibrary.simpleMessage("ändern"),
        "changePlcNetworkPassword": MessageLookupByLibrary.simpleMessage(
            "Ändern des PLC-Netzwerk Passwort"),
        "changeTheLanguageOfTheApp": MessageLookupByLibrary.simpleMessage(
            "Ändere die Spache der Anwendung"),
        "checkUpdates":
            MessageLookupByLibrary.simpleMessage(" Aktualisierungen suchen "),
        "chooseNetwork": MessageLookupByLibrary.simpleMessage(
            "Wähle das Netzwerk in welchem das Gerät hinzugefügt werden soll."),
        "chooseTheAppTheme":
            MessageLookupByLibrary.simpleMessage("Wähle das App Design"),
        "cockpitSupportInformationBody": MessageLookupByLibrary.simpleMessage(
            "Die Support-Informationen wurden erstellt und stehen Ihnen jetzt zur Verfügung. Bitte wählen Sie eine Aktion aus."),
        "cockpitSupportInformationTitle": MessageLookupByLibrary.simpleMessage(
            "devolo Cockpit Support-Informationen"),
        "complete": MessageLookupByLibrary.simpleMessage("erfolgreich"),
        "confirm": MessageLookupByLibrary.simpleMessage("Bestätigen"),
        "confirmAction":
            MessageLookupByLibrary.simpleMessage("Aktion Bestätigen"),
        "confirmActionConnectedToRouterWarning":
            MessageLookupByLibrary.simpleMessage(
                "Achtung! Ihr Router ist an dieses PLC-Gerät angeschlossen. Sie verlieren damit die Verbindung zum Internet "),
        "contactInfo": MessageLookupByLibrary.simpleMessage("Kontakt info"),
        "contactSupport": MessageLookupByLibrary.simpleMessage("Support"),
        "currentCompatibility":
            MessageLookupByLibrary.simpleMessage("Aktuelle Kompatibilität"),
        "currentVersion":
            MessageLookupByLibrary.simpleMessage("Aktuelle Version"),
        "currentlyNotAvailableBody": MessageLookupByLibrary.simpleMessage(
            "Dieses Feature befindet sich zur Zeit noch in Entwicklung\nund wird in naher Zukunft verfügbar sein."),
        "currentlyNotAvailableTitle":
            MessageLookupByLibrary.simpleMessage("Beta-Hinweis"),
        "dataRatesArePermanentlyDisplayedInTheOverview":
            MessageLookupByLibrary.simpleMessage(
                "Datenraten werden dauerhaft in der Übersicht angezeigt "),
        "deviceInfo":
            MessageLookupByLibrary.simpleMessage("Geräteinformationen"),
        "deviceNameDialogBody": MessageLookupByLibrary.simpleMessage(
            "Möchten Sie den Gerätenamen ändern?"),
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
        "deviceNotFoundSetIpConfig": MessageLookupByLibrary.simpleMessage(
            "Es ist ein Fehler beim Ändern der IP-Adresse/Netzmaske aufgetreten!"),
        "deviceSettings":
            MessageLookupByLibrary.simpleMessage("Geräte Einstellungen"),
        "emailIsInvalid":
            MessageLookupByLibrary.simpleMessage("Ungültige E-mail Adresse"),
        "enableShowingSpeeds":
            MessageLookupByLibrary.simpleMessage("Anzeigen der Datenraten"),
        "errorScreenText": MessageLookupByLibrary.simpleMessage(
            "Der Inhalt kann nicht angezeigt werden!"),
        "factoryReset":
            MessageLookupByLibrary.simpleMessage("Werkseinstellung setzen"),
        "failed": MessageLookupByLibrary.simpleMessage("fehlgeschlagen"),
        "fillInIpAddress":
            MessageLookupByLibrary.simpleMessage("Bitte IP-Adresse eintragen"),
        "fillInNetmask":
            MessageLookupByLibrary.simpleMessage("Bitte Netzmaske eintragen"),
        "fontSize": MessageLookupByLibrary.simpleMessage("Schriftgröße"),
        "forward": MessageLookupByLibrary.simpleMessage("weiter"),
        "general": MessageLookupByLibrary.simpleMessage("Allgemein"),
        "help": MessageLookupByLibrary.simpleMessage("Hilfe"),
        "highContrast": MessageLookupByLibrary.simpleMessage("Hoher Kontrast"),
        "identifyDevice":
            MessageLookupByLibrary.simpleMessage("Gerät identifizieren"),
        "identifyDeviceErrorBody": MessageLookupByLibrary.simpleMessage(
            "Es ist ein Fehler bei der Identifizierung des Gerätes aufgetreten!\nBitte versuchen Sie es erneut."),
        "identifyDeviceErrorTitle": MessageLookupByLibrary.simpleMessage(
            "Identifizierung fehlgeschlagen"),
        "identifyDeviceTooltip": MessageLookupByLibrary.simpleMessage(
            "Leuchtdiode (LED) blinkt zwei Minuten lang"),
        "ignoreUpdates": MessageLookupByLibrary.simpleMessage(
            "Ignoriere zukünftige Aktualisierungen (Updates)"),
        "incompleteDeviceInfoText": MessageLookupByLibrary.simpleMessage(
            "Dieses Gerät kann nicht über das IP-Protokoll erreicht werden. Dies deutet auf eine fehlerhafte Netwerkkonfiguration hin, vielleicht hat das Gerät keine IP-Adresse von Ihrem Internet Router erhalten. Einige Funktionen sind daher nicht verfügbar."),
        "internet": MessageLookupByLibrary.simpleMessage("Internet"),
        "internetCentered":
            MessageLookupByLibrary.simpleMessage("Internetzentrisch"),
        "ipAddress": MessageLookupByLibrary.simpleMessage("IP-Adresse"),
        "language": MessageLookupByLibrary.simpleMessage("Sprache"),
        "launchWebInterface":
            MessageLookupByLibrary.simpleMessage("Webinterface öffnen "),
        "macAddress": MessageLookupByLibrary.simpleMessage("MAC-Adresse"),
        "manualErrorBody": MessageLookupByLibrary.simpleMessage(
            "Für Ihr PLC-Gerät wurde kein passendes Handbuch gefunden.\n\nSie können das Handbuch auf der Produkt-CD oder der devolo Internet-Seite finden."),
        "manualErrorTitle":
            MessageLookupByLibrary.simpleMessage("Handbuch nicht gefunden"),
        "mimoFull": MessageLookupByLibrary.simpleMessage("Volle Leistung"),
        "mimoVdslProfil17a":
            MessageLookupByLibrary.simpleMessage("VDSL Profil 17a"),
        "mimoVdslProfil35a":
            MessageLookupByLibrary.simpleMessage("VDSL Profil 35a"),
        "mtNumber": MessageLookupByLibrary.simpleMessage("devolo MT-Nummer"),
        "name": MessageLookupByLibrary.simpleMessage("Name"),
        "netmask": MessageLookupByLibrary.simpleMessage("Netzmaske"),
        "network": MessageLookupByLibrary.simpleMessage("Netzwerk"),
        "networkPasswordErrorBody": MessageLookupByLibrary.simpleMessage(
            "Es ist ein Fehler beim Setzen des Netzwerk-Kennwortes aufgetreten!"),
        "networkPasswordErrorHint": MessageLookupByLibrary.simpleMessage(
            "- Prüfen Sie die Verbindung zum PLC-Gerät und wiederholen Sie die Aktion!"),
        "networkPasswordErrorTitle": MessageLookupByLibrary.simpleMessage(
            "Setzen des Netzwerk-Kennworts fehlgeschlagen "),
        "networkSettings":
            MessageLookupByLibrary.simpleMessage("Netzwerk Einstellungen"),
        "noDevicesFoundScanningForDevices":
            MessageLookupByLibrary.simpleMessage(
                "Kein lokales Gerät gefunden.\nSuche nach Geräten"),
        "noconnection":
            MessageLookupByLibrary.simpleMessage("Fehler mit der Verbindung"),
        "noconnectionbody": MessageLookupByLibrary.simpleMessage(
            "Es konnte keine Verbindung zum devolo Netzwerk Dienst (devolonetworkservice) aufgebaut werden."),
        "open": MessageLookupByLibrary.simpleMessage("Öffnen"),
        "optimizationHelp":
            MessageLookupByLibrary.simpleMessage("Optimierungs Hilfe"),
        "optimizeReception":
            MessageLookupByLibrary.simpleMessage("Empfang optimieren"),
        "otherDevicesEgPcAreDisplayedInTheOverview":
            MessageLookupByLibrary.simpleMessage(
                "Weitere Geräte, z.B. PC werden in der Übersicht angezeigt"),
        "overview": MessageLookupByLibrary.simpleMessage("Übersicht"),
        "passwordMustBeGreaterThan8Characters":
            MessageLookupByLibrary.simpleMessage(
                "Passwort muss länger als 8 Zeichen sein"),
        "pending": MessageLookupByLibrary.simpleMessage("anstehend"),
        "plcNetworkPassword":
            MessageLookupByLibrary.simpleMessage("PLC-Netzwerk Passwort"),
        "pleaseEnterDeviceName":
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
        "privacyWarningDialogBody": MessageLookupByLibrary.simpleMessage(
            "Nach dieser Aktualisierung werden die Geräte selbstständig regelmäßig prüfen, ob neue Firmware verfügbar ist, und diese gegebenenfalls aktualisieren. Hierbei wird Ihre öffentliche IP-Adresse erfasst und unmittelbar nach der Aktualisierung wieder gelöscht.\n\nMöchten Sie diese jetzt aktualisieren?"),
        "privacyWarningDialogTitle": MessageLookupByLibrary.simpleMessage(
            "Aktualisierungsinformationen"),
        "processNumber":
            MessageLookupByLibrary.simpleMessage("Bearbeitungsnummer"),
        "recordTheTransmissionPowerOfTheDevicesAndTransmitIt":
            MessageLookupByLibrary.simpleMessage(
                "Übertragungsleistung der Geräte Aufzeichnen und an devolo übermitteln"),
        "refresh": MessageLookupByLibrary.simpleMessage("Neu laden"),
        "removeDevice": MessageLookupByLibrary.simpleMessage("Gerät entfernen"),
        "removeDeviceConfirmBody": MessageLookupByLibrary.simpleMessage(
            "Wollen Sie das gewählte PLC-Gerät aus dem Netzwerk entfernen?"),
        "removeDeviceConfirmTitle":
            MessageLookupByLibrary.simpleMessage("Das PLC-Gerät entfernen?"),
        "removeDeviceErrorBody": MessageLookupByLibrary.simpleMessage(
            "Es ist ein Fehler beim Entfernen des Gerätes aufgetreten!\nBitte versuchen Sie es erneut."),
        "removeDeviceErrorTitle":
            MessageLookupByLibrary.simpleMessage("Löschvorgang fehlgeschlagen"),
        "repeat": MessageLookupByLibrary.simpleMessage("Wiederholen"),
        "resetDeviceConfirmBody": MessageLookupByLibrary.simpleMessage(
            "Wollen Sie das gewählte PLC-Gerät in den Auslieferungszustand zurücksetzen?"),
        "resetDeviceConfirmTitle": MessageLookupByLibrary.simpleMessage(
            "Gerät in den Auslieferunszustand zurücksetzen"),
        "resetDeviceErrorBody": MessageLookupByLibrary.simpleMessage(
            "Es ist ein Fehler beim Zurücksetzen des Gerätes aufgetreten!\nBitte versuchen Sie es erneut."),
        "resetDeviceErrorTitle": MessageLookupByLibrary.simpleMessage(
            "Zurücksetzung fehlgeschlagen"),
        "restart": MessageLookupByLibrary.simpleMessage("Neu starten"),
        "samePasswordForAll": MessageLookupByLibrary.simpleMessage(
            "Gleiches Passwort für alle Geräte"),
        "save": MessageLookupByLibrary.simpleMessage("Speichern"),
        "searchManual":
            MessageLookupByLibrary.simpleMessage("Suche nach Handbuch"),
        "searching": MessageLookupByLibrary.simpleMessage("suche..."),
        "securityId": MessageLookupByLibrary.simpleMessage("Security-ID"),
        "selectAll": MessageLookupByLibrary.simpleMessage("Alle auswählen"),
        "selectProfile":
            MessageLookupByLibrary.simpleMessage("Profil auswählen ..."),
        "send": MessageLookupByLibrary.simpleMessage("Senden"),
        "serialNumber": MessageLookupByLibrary.simpleMessage("Seriennummer"),
        "setIpConfigErrorBody": MessageLookupByLibrary.simpleMessage(
            "Es ist ein Fehler bei der Änderung der IP-Adresse/Netzmaske aufgetreten!.\nBitte versuchen Sie es erneut."),
        "setIpConfigErrorTitle": MessageLookupByLibrary.simpleMessage(
            "Konfiguration fehlgeschlagen"),
        "setUpDevice": MessageLookupByLibrary.simpleMessage("Gerät einrichten"),
        "setVdslCompatibility":
            MessageLookupByLibrary.simpleMessage("VDSL Kompatibilität setzen"),
        "settings": MessageLookupByLibrary.simpleMessage("Einstellungen"),
        "showLicences":
            MessageLookupByLibrary.simpleMessage("Lizenzen anzeigen"),
        "showLogs": MessageLookupByLibrary.simpleMessage("Zeige Logs"),
        "showManual": MessageLookupByLibrary.simpleMessage("Handbuch anzeigen"),
        "showOtherDevices":
            MessageLookupByLibrary.simpleMessage("Anzeigen anderer Geräte"),
        "showPassword":
            MessageLookupByLibrary.simpleMessage("Passwort anzeigen "),
        "sisoFull": MessageLookupByLibrary.simpleMessage("Volle Leistung"),
        "sisoVdslProfil17a":
            MessageLookupByLibrary.simpleMessage("VDSL Profil 17a"),
        "sisoVdslProfil35b":
            MessageLookupByLibrary.simpleMessage("VDSL Profil 35b"),
        "standard": MessageLookupByLibrary.simpleMessage("(Standard)"),
        "state": MessageLookupByLibrary.simpleMessage("Update Status"),
        "success": MessageLookupByLibrary.simpleMessage("Erfolgreich"),
        "supportInfoGenerateError": MessageLookupByLibrary.simpleMessage(
            "Bei der Erstellung der Support Informationen ist ein Fehler aufgetreten.\nBitte versuchen Sie es erneut!"),
        "supportInfoSendErrorBody1": MessageLookupByLibrary.simpleMessage(
            "Beim Senden der Support-Informationen an devolo ist ein Fehler aufgetreten."),
        "supportInfoSendErrorBody2": MessageLookupByLibrary.simpleMessage(
            " Bitte überprüfen Sie, ob Ihre E-Mail-Adresse korrekt ist und ob Sie eine gültige Bearbeitungsnummer angegeben haben."),
        "supportInfoSendErrorTitle":
            MessageLookupByLibrary.simpleMessage("Senden fehlgeschlagen"),
        "switchNetwork":
            MessageLookupByLibrary.simpleMessage("Netzwerk auswählen"),
        "theCreatedSupportInformationCanNowBeSentToDevolo":
            MessageLookupByLibrary.simpleMessage(
                "Die erstellten Support-Informationen können jetzt zum devolo Support gesendet werden.\nBitte füllen Sie folgende Felder aus."),
        "theOverviewWillBeCenteredAroundThePlcDeviceConnected":
            MessageLookupByLibrary.simpleMessage(
                "Die Übersicht wird um das PLC-Gerät zentriert, welches am Internet angeschlossen ist"),
        "thisPc": MessageLookupByLibrary.simpleMessage("Dieser PC"),
        "title": MessageLookupByLibrary.simpleMessage("devolo Cockpit"),
        "type": MessageLookupByLibrary.simpleMessage("Typ"),
        "upToDate": MessageLookupByLibrary.simpleMessage("aktuell"),
        "upToDatePlaceholder":
            MessageLookupByLibrary.simpleMessage("sierung verfügbar"),
        "update": MessageLookupByLibrary.simpleMessage("Aktualisierung"),
        "updateAvailable":
            MessageLookupByLibrary.simpleMessage("Aktualisierung verfügbar"),
        "updateDeviceFailedBody": MessageLookupByLibrary.simpleMessage(
            "Folgende Geräte konnten nicht aktualisiert werden:"),
        "updateDeviceFailedTitle": MessageLookupByLibrary.simpleMessage(
            "Aktualisierung fehlgeschlagen"),
        "updateDevicePasswordNeededBody1": MessageLookupByLibrary.simpleMessage(
            "Für folgendes Gerät wird ein Passwort zur Aktualisierung benötigt:"),
        "updateDevicePasswordNeededBody2": MessageLookupByLibrary.simpleMessage(
            "Für folgende Geräte werden Passwörter zur Aktualisierung benötigt:"),
        "updateDevicePasswordNeededTitle":
            MessageLookupByLibrary.simpleMessage("Passwort benötigt"),
        "updateDialogTitle": MessageLookupByLibrary.simpleMessage(
            "Aktualisierungsinformationen"),
        "updateFailed": MessageLookupByLibrary.simpleMessage(
            "Aktualisierung fehlgeschlagen"),
        "updateSelected":
            MessageLookupByLibrary.simpleMessage("Aktualisiere Auswahl"),
        "updates": MessageLookupByLibrary.simpleMessage("Aktualisierungen"),
        "updating": MessageLookupByLibrary.simpleMessage(" aktualisieren..."),
        "vdslCompatibility":
            MessageLookupByLibrary.simpleMessage("VDSL Kompatibilität"),
        "vdslExplanation": MessageLookupByLibrary.simpleMessage(
            "In seltenen Fällen können VDSL-Verbindungsprobleme durch Übersprechen des Powerline-Signals verursacht werden. Wenn der automatische Kompatibilitätsmodus aktiv ist, versucht das Gerät, diese Situation zu erkennen und automatisch seinen Sendepegel so anzupassen, dass die bestmögliche Leistung ohne Störung erzielt wird."),
        "vdslExplanation2": MessageLookupByLibrary.simpleMessage(
            "Wenn der automatische Modus deaktiviert ist oder die Störung nicht zuverlässig erkannt werden kann, kann stattdessen ein fest eingestelltes Profil für eine angepasste Sendeleistung verwendet werden. Wählen Sie das Profil aus, das dem Typ ihres VDSL-Anschlusses entspricht, oder wählen Sie \"volle Leistung\", wenn keine Störungsvermeidung benötigt wird."),
        "vdslFailed": MessageLookupByLibrary.simpleMessage(
            "Die neuen VDSL-Einstellungen konnten nicht auf dem Gerät gespeichert werden."),
        "vdslSuccessful": MessageLookupByLibrary.simpleMessage(
            "Die neuen VDSL-Einstellungen wurden auf dem Gerät gespeichert."),
        "version": MessageLookupByLibrary.simpleMessage("Firmware-Version"),
        "yourEmailAddress":
            MessageLookupByLibrary.simpleMessage(" Ihre E-mail Adresse"),
        "yourName": MessageLookupByLibrary.simpleMessage("Ihr Name"),
        "yourPc": MessageLookupByLibrary.simpleMessage("Dein PC")
      };
}
