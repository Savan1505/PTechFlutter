# ptecpos

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
### flutter pub run easy_localization:generate -S assets/translations -f keys -o locale_keys.g.dart  --> Creating the Local Translation file
### flutter pub pub run flutter_launcher_icons:main  --> Application icon creating for both android and iOS
### flutter build apk --release --target-platform android-arm,android-arm64,android-x64 --split-per-abi --> android apk creating
### flutter build appbundle --release --target-platform android-arm,android-arm64,android-x64 --> Android apk App Bundle 
### flutter build apk --release flutter build apk -t .\lib\main_dev.dart --target-platform android-arm,android-arm64,android-x64 --split-per-abi --> Android version apk Apk Bundle 
### flutter pub run build_runner build --delete-conflicting-outputs --> Auto generated file creating


