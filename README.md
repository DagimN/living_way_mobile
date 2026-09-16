# Living Way

Living Way is a Flutter application for the Living Way church community. It helps users stay connected with church programs, events, seminars, Bible resources, and devotional content while also supporting personalized notifications and multilingual experiences.

## Overview

This app is built to provide a modern, mobile-first experience for church members and visitors. It combines content discovery, media access, notifications, and account-based features in a single application.

## Key Features

- Authentication flows for login, sign-up, password recovery, and Google sign-in
- Home and content discovery experience for church activities and resources
- Dedicated screens for Bible study, devotionals, activities, media, and notifications
- Local reminders and push-style notification support
- Multi-language support with English and Amharic translations
- Firebase analytics, crash reporting, and messaging integration
- Local caching and secure storage for better offline and repeat-use experiences

## Technology Stack

- Flutter and Dart
- Provider for state management
- Firebase for analytics, crash reporting, messaging, and app configuration
- Hive and Shared Preferences for local storage
- Easy Localization for translations
- Shorebird for over-the-air update workflows

## Project Structure

- lib/main.dart - app startup, initialization, and background notification handling
- lib/app.dart - app-level providers, routing, theme setup, and shell UI
- lib/controllers/ - app controllers for auth, layout, content, profile, notifications, and more
- lib/screens/ - screen-level UI for the app experience
- lib/core/ - shared services, models, utilities, and platform integrations
- assets/ - translations, images, SVGs, icons, animations, splash assets, and data files

## Getting Started

1. Install Flutter and the required platform tools for your target devices.
2. Clone the repository and install dependencies:

   flutter pub get

3. Make sure any required environment values are available locally, especially for Firebase and other secrets.
4. Run the app:

   flutter run

## Useful Development Commands

- flutter analyze
- flutter test
- flutter pub upgrade
- flutter build apk
- flutter build ios

## Platform and Integration Notes

- The project already includes Android, iOS, Linux, macOS, and Windows support.
- Firebase configuration is defined in lib/firebase_options.dart.
- The app initializes Firebase, localization, notifications, and media services during startup.
- If you add new translations, update the language files under assets/translations.

## Critical Developer Notes

This section is intended for important information that future developers should not lose.

- Keep secrets and local environment values out of source control.
- Preserve startup initialization order for Firebase, localization, notifications, and media services.
- If you change any Hive models or cached data structures, verify adapters and migration behavior.
- Be careful when modifying authentication or notification flows because they are deeply integrated with app startup and controllers.
- When adding new strings, update all relevant translation files so the app remains consistent across languages.
- Document breaking changes, dependency upgrades, or environment-specific setup here.

### Current Notes

- The app uses Provider as the main state management approach.
- The main entry point is initialized with Firebase messaging and crash reporting support.
- The app currently includes localization assets and splash/launcher configuration.
- If you introduce new app-wide services, keep them organized under lib/core/ and register them intentionally in the app bootstrap flow.
