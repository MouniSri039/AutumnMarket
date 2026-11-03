# Autumn Market

A Flutter-based product management application built with **Firebase Cloud Firestore**. Autumn Market allows users to manage product records, search the catalogue, filter products by price, and receive real-time updates.

## Features

- **Product CRUD:** Create, view, edit, and delete products.
- **Cloud Firestore:** Store product information in a cloud database.
- **Real-time updates:** Automatically display database changes using `StreamBuilder`.
- **Search:** Case-insensitive product name search.
- **Price filters:** Inclusive minimum and maximum price filtering.
- **Input validation:** Validate product names, prices, and filter ranges.
- **Offline support:** Display previously accessed products when the device is offline.

## Technology Stack

- Flutter
- Dart
- Firebase Core
- Cloud Firestore
- FlutterFire CLI

## Database Structure

Collection: `products`

| Field | Data type | Description |
|---|---|---|
| name | String | Product name |
| price | Number | Product price |

Each product is stored as a separate Firestore document with an automatically generated document ID.

## Getting Started

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

4. Configure your own Firebase project using FlutterFire CLI:

   ```bash
   flutterfire configure
   ```

5. Run the application:

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

The project was tested using an Android emulator, Firebase Console, and Firestore Rules Playground.

## Repository

[GitHub — MouniSri039/AutumnMarket](https://github.com/MouniSri039/AutumnMarket)

---
