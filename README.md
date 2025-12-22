# 📱 ميثـــاق (Mithaq) - Government Complaint Management System

**ميثـــاق** (Mithaq) is the official mobile application for citizens, developed using **Flutter**, as part of the integrated Government Complaint Management System.

The application provides a seamless and transparent digital channel for citizens to report complaints against specific government entities and track their resolution process.

---

## ✨ Key Features

* **Easy Account Management:** Secure registration and login using email and password, with account confirmation via One-Time Password (OTP).
* **Simple Submission:** Citizens can submit new complaints by specifying the type, governorate, government entity, location, and a detailed description.
* **Attachment Support:** Ability to upload supporting documents or images (PNG, JPG, JPEG, or PDF format) with file size validation (default 10MB per file).
* **Real-time Tracking:** View all submitted complaints and filter them based on their status (**New**, **In Progress**, **Completed**, **Rejected**, **Info Requested**, **Resolved**). Filter switching works seamlessly, including switching back to "All" to view all complaints.
* **Info Request Handling:** Respond to information requests from government employees with supporting documents and details.
* **Instant Notifications:** Receive instant alerts for key status changes (e.g., successful receipt, status change, or a request for additional information from a government employee).
* **Reference Search:** Search for a specific complaint using its unique reference number.
* **Loading States:** Smooth loading indicators and shimmer effects for better user experience.

---

## 💻 Technology Stack

* **Framework:** Flutter (for cross-platform compatibility on Android and iOS)
* **Language:** Dart 3.8.1+
* **Architecture:** Clean Architecture with Layered Architecture pattern (Data, Domain, Presentation layers)
* **State Management:** BLoC (Business Logic Component) pattern using `flutter_bloc`
* **Dependency Injection:** GetIt service locator
* **Networking:** Dio for HTTP requests
* **Local Storage:** Flutter Secure Storage for sensitive data
* **Notifications:** Firebase Cloud Messaging (FCM) with local notifications
* **File Handling:** File Picker for document and image selection

### Key Dependencies

* `flutter_bloc` - State management
* `dio` - HTTP client
* `firebase_core` & `firebase_messaging` - Push notifications
* `flutter_secure_storage` - Secure local storage
* `file_picker` - File selection
* `connectivity_plus` - Network connectivity checking
* `google_fonts` - Typography
* `sizer` - Responsive design
* `flutter_native_splash` - Native splash screen configuration
* `flutter_launcher_icons` - App icon generation
* `dartz` - Functional programming (Either/Left/Right for error handling)
* `equatable` - Value equality for state management
* `device_info_plus` - Device information for notifications

---

## 🚀 Getting Started

### Prerequisites

* Flutter SDK (3.8.1 or higher)
* Dart SDK
* Android Studio / Xcode (for mobile development)
* Firebase account (for push notifications)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Sedranadr117/Mithaq.git
   cd Mithaq
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Add your `google-services.json` file to `android/app/`
   - Configure Firebase for iOS in `ios/Runner/`
   - Update `firebase_options.dart` with your Firebase configuration

4. **Configure Splash Screen** (Optional)
   - The app uses `flutter_native_splash` for native splash screens
   - Splash screen configuration is in `pubspec.yaml` under `flutter_native_splash`
   - To regenerate splash screen assets, run:
     ```bash
     dart run flutter_native_splash:create
     ```
   - Recommended splash image size: 400x400 to 600x600 pixels for optimal display

5. **Run the app**
   ```bash
   flutter run
   ```

### Building for Production

**Android:**
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

**iOS:**
```bash
flutter build ios --release
```

---

## 📁 Project Structure

```
lib/
├── config/          # App configuration, themes, extensions, helpers
├── core/            # Core functionality (databases, errors, services)
├── features/        # Feature modules
│   ├── auth/        # Authentication feature
│   ├── complaints/  # Complaints management feature
│   └── notification/# Notification handling feature
└── main.dart        # App entry point
```

Each feature follows Clean Architecture with:
- **Data Layer:** Data sources, repositories implementation, models
- **Domain Layer:** Entities, repositories interfaces, use cases
- **Presentation Layer:** UI pages, widgets, BLoC

---

## 🎯 Project Scope

**ميثـــاق** (Mithaq) focuses on empowering citizens to initiate and follow up on the complete **complaint lifecycle**, ensuring transparency and efficient communication with government bodies. It is an essential component designed for usability and accessibility across various screen sizes.

## 🐛 Error Handling

The app includes comprehensive error handling with:
* User-friendly Arabic error messages for common backend errors
* Network connectivity checking
* Secure token management with automatic logout on 401 errors
* Graceful handling of file upload errors
* Proper error states in UI with retry mechanisms
* Firebase error handling - app continues to work even if FCM token retrieval fails

## 🔧 Troubleshooting

### Firebase FIS_AUTH_ERROR

If you encounter `FIS_AUTH_ERROR` when running the app, it means your app's SHA-1/SHA-256 fingerprints are not registered in Firebase Console. The app will continue to work, but push notifications won't function.

**To fix this:**

1. **Get your SHA-1 fingerprint:**
   ```bash
   # For debug keystore (default)
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   
   # For Windows
   keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
   ```

2. **Get your SHA-256 fingerprint:**
   ```bash
   # Same command, look for SHA-256 in the output
   ```

3. **Add fingerprints to Firebase:**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Select your project (mithaq-956c5)
   - Go to Project Settings → Your apps → Android app
   - Click "Add fingerprint"
   - Paste your SHA-1 and SHA-256 fingerprints
   - Download the updated `google-services.json` and replace the one in `android/app/`

4. **Rebuild the app:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

**Note:** The app now handles this error gracefully and won't crash. Push notifications will simply be disabled until the fingerprints are added.

---

## 📝 Recent Updates

* **App Rebranding:** Changed app name to **ميثـــاق** (Mithaq) across all platforms
* **Filter Bug Fix:** Fixed issue where switching back to "All" filter would show "no complaints found" - now correctly displays all complaints
* **Enhanced Error Handling:** Improved error messages with user-friendly Arabic translations for backend errors (Index out of bounds, EntityManager transaction errors, etc.)
* **File Upload Improvements:** Added safer filename extraction and better file handling with size validation
* **Enhanced Info Request Handling:** Dedicated response page for handling information requests from government employees
* **UI Improvements:** Added shimmer loading effects, enhanced file picker with multiple file support, improved dropdown menus and custom text fields
* **Better State Management:** Improved BLoC implementation for complaints filtering and pagination
* **Splash Screen Optimization:** Fixed splash screen logo sizing and optimized assets for all screen sizes
* **Repository Updates:** Improved data source and repository implementation with better error handling

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---

## 👨‍💻 Project Team / Contributors

This project was developed by:

* GitHub: [@zainab-sendian03](https://github.com/zainab-sendian03)
* GitHub: [@Sedranadr117](https://github.com/Sedranadr117)

---

## 📄 License

This project is part of the Government Complaint Management System.
