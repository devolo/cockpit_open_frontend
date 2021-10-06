// defines the version, is a combination of the cockpit backend version (against which the flutter frontend was developed) and the date of the release build
// format: <developBackendVersion>_YYYY-MM-DD
String versionCockpit = "5.1.6_2021-05-05";

// Define config options for device simulator
const bool simulatedDevices = false;
const int nDevices = 5;

final List<String> languageList = <String>[
  "de",
  "en",
  "fr",
];

final Map<String,String> languageMapFull = {"de": "Deutsch", "en": "English", "fr": "Français"};
