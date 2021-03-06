# Contributing

Thank you very much for considering to contribute to our project.

The following guidelines will help you to understand how you can help. They will also make transparent to you the time we need to manage and develop this open source project. In return, we will reciprocate that respect in addressing your issues, assessing changes, and helping you finalize your pull requests.

## Table of contents

1. [Reporting an issue](#reporting-an-issue)
1. [Requesting a feature](#requesting-a-feature)
1. [Code style guide](#code-style-guide)
1. [Localizations](#localizations)
1. [Testing](#testing)

## Reporting an issue

If you are having issues with our code, especially if you found a bug, we want to know. Please [create an issue](https://github.com/devolo/Cockpit-open-frontend/issues). However, you should keep in mind that it might take some time for us to respond to your issue. We will try to get in contact with you within two weeks (please do the same when responding to our inquiries).

## Requesting a feature

While we develop this frontend, we have our own use cases in mind. Those use cases do not necessarily meet your use cases. Nevertheless we want to hear about them, so you can either [create an issue](https://github.com/devolo/Cockpit-open-frontend/issues) or create a merge request. By choosing the first option, you tell us to take care of your use case. That will take time as we will prioritize it with our own needs. By choosing the second option, you can speed up this process. Please read our code style guide.

## Code style guide

- Use the [material styleguide for writing](https://material.io/design/communication/writing.html#principles) for all text shown in the app, e.g., labels and help content. The styleguide includes guidelines for the use of cases, punctuations, tenses, and so on.
- TBD    

## Localizations
If you are using a programming IDE with Flutter Intl, such as VS Code or Android Studio, changes to resource files (`/lib/l10n/*.arb`) will automatically generate localization files (`lib/generated/intl/*.dart`).
If you are building this app using a command-line interface, new localization files will be generated only when new key-value pairs are added to the resource files. If you want to manually generate localization files, e.g., when updating an existing key-value pair, run the following command:
```
flutter pub run intl_utils:generate
```

## Testing

TBD (TDD eventually ;-))
