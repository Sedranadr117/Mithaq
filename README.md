# 📱 Government Complaint Management System - Citizen Mobile App (Flutter)

This is the official mobile application for citizens, developed using **Flutter**, as part of the integrated Government Complaint Management System.

The application provides a seamless and transparent digital channel for citizens to report complaints against specific government entities and track their resolution process.

---

## ✨ Key Features

* **Easy Account Management:** Secure registration and login using email and password, with account confirmation via One-Time Password (OTP).
* **Simple Submission:** Citizens can submit new complaints by specifying the type, governorate, government entity, location, and a detailed description.
* **Attachment Support:** Ability to upload supporting documents or images (PNG or PDF format) to the complaint.
* **Real-time Tracking:** View all submitted complaints and filter them based on their status (**New**, **In Progress**, **Completed**, **Rejected**).
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
   git clone https://github.com/Sedranadr117/ComplaintsApp.git
   cd ComplaintsApp
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Add your `google-services.json` file to `android/app/`
   - Configure Firebase for iOS in `ios/Runner/`
   - Update `firebase_options.dart` with your Firebase configuration

4. **Run the app**
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

This application focuses on empowering citizens to initiate and follow up on the complete **complaint lifecycle**, ensuring transparency and efficient communication with government bodies. It is an essential component designed for usability and accessibility across various screen sizes.

---

## 📝 Recent Updates

* Enhanced info request handling with dedicated response page
* Added shimmer loading effects for better UX
* Improved complaints data source and repository implementation
* Updated API endpoints and data models
* Enhanced UI components (file picker, dropdown menu, custom text fields)
* Better error handling and state management

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
