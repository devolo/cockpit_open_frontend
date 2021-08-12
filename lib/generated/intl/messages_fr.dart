// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a fr locale. All the
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
  String get localeName => 'fr';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "LoadCockpitSupportInformationBody":
            MessageLookupByLibrary.simpleMessage(
                "Les informations de support sont générées"),
        "SendCockpitSupportInformationBody":
            MessageLookupByLibrary.simpleMessage(
                "Les informations sont envoyées à devolo"),
        "UpdateDeviceFailedBody": MessageLookupByLibrary.simpleMessage(
            "Les appareils suivants n\'ont pas pu être mis à jour:"),
        "UpdateDeviceFailedTitle":
            MessageLookupByLibrary.simpleMessage("Mise à jour échoué"),
        "activateLEDs": MessageLookupByLibrary.simpleMessage("DELs allumés"),
        "activateLEDsFailedBody": MessageLookupByLibrary.simpleMessage(
            "Une erreur s\'est produite lors de la modification des DEL!\nRéessayez plus tard"),
        "activateLEDsFailedTitle":
            MessageLookupByLibrary.simpleMessage("Action échouée"),
        "activateTransmission": MessageLookupByLibrary.simpleMessage(
            "Communication des données activé"),
        "activateTransmissionFailedBody": MessageLookupByLibrary.simpleMessage(
            "Une erreur s\'est produite lors du réglage de la communication de données!\nRéessayez plus tard"),
        "activateTransmissionFailedTitle":
            MessageLookupByLibrary.simpleMessage("Action échouée"),
        "addDeviceErrorBody": MessageLookupByLibrary.simpleMessage(
            "Une erreur s\'est produite lors de l\'ajout de l\'appareil!\nTRéessayez plus tard"),
        "addDeviceErrorTitle":
            MessageLookupByLibrary.simpleMessage("L\'installation échoué"),
        "addDeviceInstructionText": MessageLookupByLibrary.simpleMessage(
            "1) Branchez les deux adaptateurs WiFi dans une prise de courant libre et attendez 45 secondes.\n2) Appuyez sur le bouton de cryptage du adapteur CPL déjà existant.\n(\nVous pouvez également établir la connection via l\'interface web de l\'appareil déja existant.)\n3) Dans les deux minutes qui suivent, appuyez sur le bouton de cryptage du nouveau adapteur CPL.\n4) Les adapteurs CPL sont prêt à fonctionner une fois que la DEL blanche est allumée et ne clignotte plus."),
        "addDeviceLoading":
            MessageLookupByLibrary.simpleMessage("L´appareil sera ajouté"),
        "addDeviceViaSecurityId": MessageLookupByLibrary.simpleMessage(
            "Ajouter un appareil par l´ID de sécurité"),
        "addDeviceViaSecurityIdDialogContent": MessageLookupByLibrary.simpleMessage(
            "Entrez l´ID de sécurité du nouveau adapteur CPL.\nL\'ID de sécurité se trouve à l\'arrière de l\'appareil CPL."),
        "additionalDialogTitle":
            MessageLookupByLibrary.simpleMessage("Paramètres supplémentaires"),
        "additionalSettings":
            MessageLookupByLibrary.simpleMessage("Paramètres supplémentaires"),
        "appInfo": MessageLookupByLibrary.simpleMessage("Info app"),
        "appInformation":
            MessageLookupByLibrary.simpleMessage("Information app"),
        "appTheme": MessageLookupByLibrary.simpleMessage("App design"),
        "appearance": MessageLookupByLibrary.simpleMessage("Apparence"),
        "automaticCompatibilityMode": MessageLookupByLibrary.simpleMessage(
            "Mode de compatibilité automatique (recommandé)"),
        "back": MessageLookupByLibrary.simpleMessage("Précédente"),
        "cancel": MessageLookupByLibrary.simpleMessage("Annuler"),
        "change": MessageLookupByLibrary.simpleMessage("Modifier"),
        "changePlcNetworkPassword": MessageLookupByLibrary.simpleMessage(
            "Modifiez le mot de passe du réseau CPL"),
        "checkUpdates":
            MessageLookupByLibrary.simpleMessage("Rechercher des mises à jour"),
        "chooseNetwork": MessageLookupByLibrary.simpleMessage(
            "Sélectionnez le réseau dans lequel l´adapteur doit être ajouté."),
        "chooseTheAppTheme": MessageLookupByLibrary.simpleMessage(
            "Choisir le design de l´application"),
        "cockpitSupportInformationBody": MessageLookupByLibrary.simpleMessage(
            "Les informations de support ont été créées et sont maintenant disponibles pour vous. Veuillez sélectionner une action."),
        "cockpitSupportInformationTitle": MessageLookupByLibrary.simpleMessage(
            "devolo Cockpit informations support"),
        "complete": MessageLookupByLibrary.simpleMessage("terminé"),
        "confirm": MessageLookupByLibrary.simpleMessage("Confirmer"),
        "confirmAction":
            MessageLookupByLibrary.simpleMessage("Confirmer activité"),
        "confirmActionConnectedToRouterWarning":
            MessageLookupByLibrary.simpleMessage(
                "Attention ! Votre routeur est connecté à cet appareil CPL. Vous allez perdre la connexion à l\'internet"),
        "contactInfo":
            MessageLookupByLibrary.simpleMessage("Information de contact"),
        "contactSupport":
            MessageLookupByLibrary.simpleMessage("Contacter le support"),
        "currentVersion":
            MessageLookupByLibrary.simpleMessage("Version actuelle"),
        "dataRatesArePermanentlyDisplayedInTheOverview":
            MessageLookupByLibrary.simpleMessage(
                "Les taux de transmission seront toujours indiqués dans la vue d\'ensemble"),
        "deleteDevice":
            MessageLookupByLibrary.simpleMessage("Supprimer l\'appareil"),
        "deviceInfo":
            MessageLookupByLibrary.simpleMessage("Informations sur l´appareil"),
        "deviceNameDialogBody": MessageLookupByLibrary.simpleMessage(
            "Voulez-vous vraiment renommer cet appareil?"),
        "deviceNameDialogTitle":
            MessageLookupByLibrary.simpleMessage("Confirmer"),
        "deviceNameErrorBody": MessageLookupByLibrary.simpleMessage(
            "Une erreur s\'est produite lors du changement de nom.\nRéessayez plus tard"),
        "deviceNameErrorTitle": MessageLookupByLibrary.simpleMessage(
            "Le changement de nom a échoué"),
        "deviceNotFoundDeviceName": MessageLookupByLibrary.simpleMessage(
            "Une erreur s\'est produite lors de la définition du nom de l\'appareil"),
        "deviceNotFoundHint": MessageLookupByLibrary.simpleMessage(
            " - L\'adapteur CPL a-t-il été déconnecté du réseau électrique ?\n - Est-ce que l´adapteur CPL est en mode d\'économie d\'énergie ?"),
        "deviceNotFoundIdentifyDevice": MessageLookupByLibrary.simpleMessage(
            "Une erreur s\'est produite lors de l\'identification de l\'appareil"),
        "deviceNotFoundRemoveDevice": MessageLookupByLibrary.simpleMessage(
            "Une erreur s\'est produite lors de la suppression de l\'appareil"),
        "deviceNotFoundResetDevice": MessageLookupByLibrary.simpleMessage(
            "Une erreur s\'est produite lors de la réinitialisation de l\'appareil"),
        "emailIsInvalid":
            MessageLookupByLibrary.simpleMessage("Adresse e-mail non valide"),
        "enableShowingSpeeds": MessageLookupByLibrary.simpleMessage(
            "Afficher les taux de transmission"),
        "factoryReset": MessageLookupByLibrary.simpleMessage(
            "Réinitialisé aux paramètres d\'origine"),
        "failed": MessageLookupByLibrary.simpleMessage("échoué"),
        "fontSize": MessageLookupByLibrary.simpleMessage(
            "Choisir la taille des caractères"),
        "forward": MessageLookupByLibrary.simpleMessage("Suivant"),
        "general": MessageLookupByLibrary.simpleMessage("Général"),
        "help": MessageLookupByLibrary.simpleMessage("Aide"),
        "highContrast": MessageLookupByLibrary.simpleMessage("Haut contraste"),
        "identifyDevice":
            MessageLookupByLibrary.simpleMessage("Identifier l´appareil"),
        "identifyDeviceErrorBody": MessageLookupByLibrary.simpleMessage(
            "Une erreur s\'est produite lors de l\'identification de l\'appareil.\nRéessayez plus tard"),
        "identifyDeviceErrorTitle":
            MessageLookupByLibrary.simpleMessage("Identification échouée"),
        "ignoreUpdates": MessageLookupByLibrary.simpleMessage(
            "Ignorer les mises à jour des apparails"),
        "internet": MessageLookupByLibrary.simpleMessage("Internet"),
        "internetCentered": MessageLookupByLibrary.simpleMessage(
            "Centrer la vue d´ensamble sur l´internet"),
        "ipAddress": MessageLookupByLibrary.simpleMessage("Adresse IP"),
        "launchWebInterface": MessageLookupByLibrary.simpleMessage("Site web"),
        "macAddress": MessageLookupByLibrary.simpleMessage("Adresse MAC"),
        "manualErrorBody": MessageLookupByLibrary.simpleMessage(
            "Aucun manuel approprié n\'a été trouvé pour votre adapteur PLC..\n\nVous trouverez le manuel sur le CD du produit ou sur le site web de devolo."),
        "manualErrorTitle":
            MessageLookupByLibrary.simpleMessage("Manuel introuvable"),
        "mtNumber": MessageLookupByLibrary.simpleMessage("numéro MT devolo"),
        "name": MessageLookupByLibrary.simpleMessage("Nom"),
        "network": MessageLookupByLibrary.simpleMessage("Réseau"),
        "networkPasswordErrorBody": MessageLookupByLibrary.simpleMessage(
            "Une erreur s\'est produite lors de la définition du mot de passe du réseau"),
        "networkPasswordErrorHint": MessageLookupByLibrary.simpleMessage(
            "- Vérifiez la connexion avec l´adapteur CPL et réessayez l\'action."),
        "networkPasswordErrorTitle": MessageLookupByLibrary.simpleMessage(
            "La définition du mot de passe réseau n\'a pas abouti"),
        "noDevicesFoundScanningForDevices":
            MessageLookupByLibrary.simpleMessage(
                "Aucun adapteur trouvé. \n\nRecherche d\'appareils ..."),
        "open": MessageLookupByLibrary.simpleMessage("Ouvrir"),
        "optimizationHelp":
            MessageLookupByLibrary.simpleMessage("Aide d´optimisation"),
        "optimizeReception":
            MessageLookupByLibrary.simpleMessage("Optimiser la connexion"),
        "otherDevicesEgPcAreDisplayedInTheOverview":
            MessageLookupByLibrary.simpleMessage(
                "La vue d\'ensemble affichera autres appareils, e.g., ordinateurs"),
        "overview": MessageLookupByLibrary.simpleMessage("Vue d´ensamble"),
        "passwordMustBeGreaterThan8Characters":
            MessageLookupByLibrary.simpleMessage(
                "Le mot de passe doit contenir plus de 8 caractères"),
        "pending": MessageLookupByLibrary.simpleMessage("en attente"),
        "pleaseEnterDeviceName":
            MessageLookupByLibrary.simpleMessage("Entrez le nom de l´appareil"),
        "pleaseEnterPassword":
            MessageLookupByLibrary.simpleMessage("Entrez un mot de passe"),
        "pleaseEnterProcessingNumber": MessageLookupByLibrary.simpleMessage(
            "Entrez le numéro de processus"),
        "pleaseEnterYourMailAddress":
            MessageLookupByLibrary.simpleMessage("Entrez votre adresse e-mail"),
        "pleaseFillInYourName":
            MessageLookupByLibrary.simpleMessage("Entrez votre nom"),
        "powerSavingMode":
            MessageLookupByLibrary.simpleMessage("Mode d\'économie d\'énergie"),
        "powerSavingModeFailedBody": MessageLookupByLibrary.simpleMessage(
            "Une erreur s\'est produite lors du réglage du mode d\'économie d\'énergie!\nRéessayez plus tard"),
        "powerSavingModeFailedTitle":
            MessageLookupByLibrary.simpleMessage("Action échouée"),
        "processNumber":
            MessageLookupByLibrary.simpleMessage("Numéro de processus"),
        "recordTheTransmissionPowerOfTheDevicesAndTransmitIt":
            MessageLookupByLibrary.simpleMessage(
                "Enregistrer les taux de transmission des appareils CPL et les envoyer à devolo."),
        "refresh": MessageLookupByLibrary.simpleMessage("Actualiser"),
        "removeDeviceConfirmBody": MessageLookupByLibrary.simpleMessage(
            "Voulez-vous supprimer l´appareil PLC sélectionné du réseau ?"),
        "removeDeviceConfirmTitle":
            MessageLookupByLibrary.simpleMessage("Supprimer l´appareil PLC ?"),
        "removeDeviceErrorBody": MessageLookupByLibrary.simpleMessage(
            "Une erreur s\'est produite lors de la suppression de l\'appareil!\nRéessayez plus tard"),
        "removeDeviceErrorTitle":
            MessageLookupByLibrary.simpleMessage("Suppression échouée"),
        "resetDeviceConfirmBody": MessageLookupByLibrary.simpleMessage(
            "Voulez-vous réinitialiser l´appareil PLC sélectionné aux paramètres d\'origine?"),
        "resetDeviceConfirmTitle": MessageLookupByLibrary.simpleMessage(
            "Réinitialiser l\'appareil aux paramètres d\'origine"),
        "resetDeviceErrorBody": MessageLookupByLibrary.simpleMessage(
            "Une erreur s\'est produite lors de la réinitialisation de l\'appareil!\nRéessayez plus tard"),
        "resetDeviceErrorTitle":
            MessageLookupByLibrary.simpleMessage("Réinitialisation échouée"),
        "save": MessageLookupByLibrary.simpleMessage("Enregistrer"),
        "searching": MessageLookupByLibrary.simpleMessage("Recherche..."),
        "securityId": MessageLookupByLibrary.simpleMessage("ID de sécurité"),
        "selectAll": MessageLookupByLibrary.simpleMessage("Sélectionner tout"),
        "send": MessageLookupByLibrary.simpleMessage("Envoyer"),
        "serialNumber": MessageLookupByLibrary.simpleMessage("Numéro de série"),
        "setUpDevice":
            MessageLookupByLibrary.simpleMessage("Ajouter un nouvel appareil"),
        "setVdslCompatibility": MessageLookupByLibrary.simpleMessage(
            "Définir la compatibilité VDSL"),
        "settings": MessageLookupByLibrary.simpleMessage("Paramètres"),
        "showLicences": MessageLookupByLibrary.simpleMessage("licenses"),
        "showLogs":
            MessageLookupByLibrary.simpleMessage("Voir le fichier journal"),
        "showManual": MessageLookupByLibrary.simpleMessage("Voir le manuel"),
        "showOtherDevices":
            MessageLookupByLibrary.simpleMessage("Afficher autres appareils"),
        "showPassword":
            MessageLookupByLibrary.simpleMessage("Montrer le mot de passe"),
        "state": MessageLookupByLibrary.simpleMessage("État"),
        "supportInfoGenerateError": MessageLookupByLibrary.simpleMessage(
            "Une erreur s\'est produite lors de la création des informations de support.\nRéessayez plus tard"),
        "supportInfoSendErrorBody1": MessageLookupByLibrary.simpleMessage(
            "Une erreur s\'est produite lors de l\'envoi d\'informations de support à devolo."),
        "supportInfoSendErrorBody2": MessageLookupByLibrary.simpleMessage(
            "Vérifiez que votre adresse e-mail est correcte et que vous avez saisi un numéro de processus valide."),
        "supportInfoSendErrorTitle":
            MessageLookupByLibrary.simpleMessage("Impossible d\'envoyer"),
        "theCreatedSupportInformationCanNowBeSentToDevolo":
            MessageLookupByLibrary.simpleMessage(
                "Les informations créées peuvent maintenant être envoyées au support de devolo.\nComplétez le formulaire ci-dessous."),
        "theOverviewWillBeCenteredAroundThePlcDeviceConnected":
            MessageLookupByLibrary.simpleMessage(
                "La vue d\'ensemble sera centrée sur l´adapteur CPL connecté à l\'internet."),
        "thisPc": MessageLookupByLibrary.simpleMessage("Cet PC"),
        "title": MessageLookupByLibrary.simpleMessage("devolo Cockpit"),
        "type": MessageLookupByLibrary.simpleMessage("Type"),
        "upToDate": MessageLookupByLibrary.simpleMessage("À jour"),
        "update": MessageLookupByLibrary.simpleMessage("Actualisation"),
        "updateSelected":
            MessageLookupByLibrary.simpleMessage("Mettre à jour la sélection"),
        "updates": MessageLookupByLibrary.simpleMessage("Actualisation"),
        "updating": MessageLookupByLibrary.simpleMessage(
            "l\'appareil est en train de se mettre à jour..."),
        "vdslCompatibility":
            MessageLookupByLibrary.simpleMessage("Compatibilité VDSL"),
        "vdslExplanation": MessageLookupByLibrary.simpleMessage(
            "Dans de rares cas, la distorsion du signal Powerline peut interférer avec la connexion VDSL. Les appareils en mode de compatibilité automatique peuvent ajuster automatiquement la transmission pour limiter les interférences."),
        "vdslExplanation2": MessageLookupByLibrary.simpleMessage(
            "Sélectionnez un profil de transmission parmi les options proposées comme solution de repli lorsque le mode automatique est désactivé ou qu\'une détection fiable des interférences n\'est pas possible."),
        "vdslFailed": MessageLookupByLibrary.simpleMessage(
            "Les nouveaux paramètres VDSL n\'ont pas pu être enregistrés sur l\'appareil"),
        "vdslSuccessful": MessageLookupByLibrary.simpleMessage(
            "Les nouveaux paramètres VDSL ont été enregistrés sur l\'appareil"),
        "version": MessageLookupByLibrary.simpleMessage("Version firmware"),
        "yourEmailAddress":
            MessageLookupByLibrary.simpleMessage("Votre adresse e-mail"),
        "yourName": MessageLookupByLibrary.simpleMessage("Votre nom"),
        "yourPc": MessageLookupByLibrary.simpleMessage("Votre PC")
      };
}
