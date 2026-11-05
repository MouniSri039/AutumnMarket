
# Autumn Market

Autumn Market is a Flutter application built with Firebase. It combines product management through Cloud Firestore with user authentication through Firebase Authentication.

The project was developed in two stages: first, implementing cloud-based product management, and then adding account registration, sign-in, profile management, and password updates.

## Features

### Product Management
- Create, read, update, and delete products.
- Store product information in Cloud Firestore.
- Display real-time database changes using StreamBuilder.
- Search products by name without case sensitivity.
- Filter products using inclusive minimum and maximum prices.
- Validate product names, prices, and filter ranges.
- Display previously accessed products while offline.

### Authentication
- Register new accounts using email and password.
- Sign in to existing accounts.
- Display the currently authenticated user's email.
- Change passwords after verifying the current password.
- Reauthenticate when Firebase requires a recent login.
- Sign out securely.
- Restore the correct authentication screen using the authentication state stream.
- Display loading states and readable error messages.

## Technology Stack

- Flutter
- Dart
- Firebase Core
- Firebase Authentication
- Cloud Firestore
- FlutterFire CLI

## Firebase Configuration

The application uses a Firebase project configured through FlutterFire.

Authentication:
- Provider: Email/Password
- Authentication state: Firebase `authStateChanges()`

Firestore:
- Collection: `products`

| Field | Data type | Description |
|---|---|---|
| name | String | Product name |
| price | Number | Product price |

Each product is stored as a separate Firestore document with an automatically generated document ID.

## Project Structure

```text
lib/
├── main.dart
├── firebase_options.dart
├── models/
├── screens/
│   ├── product_screen.dart
│   └── profile_screen.dart
└── services/
    ├── product_service.dart
    └── auth_service.dart
```

## Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK
- Android Studio or another Flutter-compatible IDE
- A Firebase project

### Installation

1. Clone the repository:

```bash
git clone https://github.com/MouniSri039/AutumnMarket.git
```

2. Open the project directory:

```bash
cd AutumnMarket
```

3. Install dependencies:

```bash
flutter pub get
```

4. Configure Firebase for your own project:

```bash
flutterfire configure
```

5. In Firebase Console, enable:
   - Authentication → Sign-in method → Email/Password
   - Cloud Firestore

6. Run the application:

```bash
flutter run
```

## Testing

Run static analysis:

```bash
flutter analyze
```

Run automated tests:

```bash
flutter test
```

The application was tested using an Android emulator and Firebase Console. Authentication tests included registration, successful and unsuccessful sign-in, password updates, sign-out, and session restoration.

The password reauthentication recovery handler is implemented. A real `requires-recent-login` recovery scenario should be distinguished from the documented test plan if it was not triggered during testing.

## Repository

GitHub: https://github.com/MouniSri039/AutumnMarket
