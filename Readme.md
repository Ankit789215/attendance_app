# Modern Attendance Management System

A beautiful, Material 3 attendance management application built with Flutter, Riverpod, and Supabase.

## ✨ Features

*   **Student Management**: Full CRUD capabilities for managing student records.
*   **Batch Management**: Organize students into batches with specific timings.
*   **Fast Attendance**: An optimized, one-tap UI for rapidly marking students Present/Absent.
*   **Interactive Reports**: Beautiful analytics dashboards using `fl_chart` to visualize monthly trends, batch comparisons, and individual student stats.
*   **Live Database**: Powered by Supabase for real-time, secure data persistence.

## 🛠️ Tech Stack

*   **Frontend**: [Flutter](https://flutter.dev/) (Web/Mobile)
*   **State Management**: [Riverpod](https://riverpod.dev/) (`flutter_riverpod`)
*   **Navigation**: [GoRouter](https://pub.dev/packages/go_router)
*   **Charting**: [fl_chart](https://pub.dev/packages/fl_chart)
*   **Backend & Auth**: [Supabase](https://supabase.com/)

## 🚀 Getting Started

Follow these instructions to get the project up and running on your local machine.

### Prerequisites

1.  **Flutter SDK**: Ensure you have Flutter installed. You can download it from [here](https://docs.flutter.dev/get-started/install).
2.  **Supabase Account**: You need a free Supabase account to host the database.

### 1. Database Setup (Supabase)

1.  Create a new project in your Supabase dashboard.
2.  Navigate to the **SQL Editor** in the left sidebar.
3.  Copy and paste the schema provided by the AI assistant (or run the `supabase_schema.sql` file if you saved it).
4.  Click **Run** to generate the `batches`, `students`, `attendance_sessions`, and `attendance_records` tables along with their security policies.

### 2. Configure API Keys

1.  In your Supabase dashboard, go to **Project Settings** -> **API**.
2.  Copy your **Project URL** and your **anon / public key**.
3.  Open the project code and locate `lib/core/constants/app_constants.dart`.
4.  Paste your keys into the configuration file:

```dart
class AppConstants {
  static const String supabaseUrl = 'YOUR_SUPABASE_URL_HERE';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY_HERE';
}
```

### 3. Install Dependencies

Open your terminal, navigate to the project directory, and run:

```bash
flutter pub get
```

### 4. Run the App

To run the application locally on the web (Chrome), execute the following command:

```bash
flutter run -d chrome
```

## 🏗️ Architecture

This project strictly follows **Clean Architecture** principles using the Repository Pattern:

*   **Domain Layer**: Contains the core business models (`Batch`, `Student`, etc.) and Repository Interfaces.
*   **Data Layer**: Contains the concrete implementations (`SupabaseBatchRepository`, etc.) that talk to the external database.
*   **Presentation Layer**: Contains the Riverpod providers, UI screens, and widgets. Data is injected seamlessly via providers.
