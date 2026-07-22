📋 Nexvoria - Offline-First Task Management App
A robust, offline-first task management application built with Flutter, implementing Clean Architecture, BLoC pattern, and local-first data synchronization with Firebase Firestore.

🚀 Key Features
Core Functionality
✅ Create Tasks - Add tasks with title, description, and auto-generated ID

✏️ Edit Tasks - Update existing task details

✅ Mark Complete - Toggle task completion status with real-time sync

🗑️ Delete Tasks - Swipe-to-delete with undo functionality

🔄 Restore Tasks - Undo deleted tasks within 3 seconds

Offline-First Capabilities
📱 Hive Local Storage - All tasks cached locally for offline access

🔄 Automatic Sync - Seamless sync when connectivity restores

📶 Connectivity Awareness - Visual banner showing online/offline status

💾 Optimistic Updates - Instant UI updates, background sync

User Experience
🌓 Dark/Light Theme - Persistent theme preference using SharedPreferences

🔍 Search & Filter - Real-time search with pending/completed filters

📋 Swipe to Delete - Intuitive gesture-based task deletion

🎨 Material Design 3 - Modern UI with smooth animations

📱 Responsive - Works on all screen sizes

🏗️ Architecture
Clean Architecture Layers
text
┌─────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                    │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐ │
│  │   Pages      │  │    BLoC      │  │   Widgets    │ │
│  │ TodoList     │  │ TaskBloc     │  │ TaskTile     │ │
│  │ AddEdit      │  │ ThemeCubit   │  │ EmptyState   │ │
│  │ Splash       │  │ ConnectCubit │  │ SearchBar    │ │
│  └──────────────┘  └──────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────┘
                           │
┌─────────────────────────────────────────────────────────┐
│                     DOMAIN LAYER                        │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐ │
│  │   Entities   │  │  Repositories│  │   Use Cases  │ │
│  │ TaskEntity   │  │ TaskRepo     │  │ (in BLoC)    │ │
│  │              │  │ ConnectRepo  │  │              │ │
│  └──────────────┘  └──────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────┘
                           │
┌─────────────────────────────────────────────────────────┐
│                      DATA LAYER                         │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐ │
│  │   Remote     │  │    Local     │  │   Models     │ │
│  │ Firebase     │  │    Hive      │  │ TaskModel    │ │
│  │ DataSource   │  │  DataSource  │  │ HiveModel    │ │
│  └──────────────┘  └──────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────┘
Data Flow
text
┌─────────┐     ┌─────────┐     ┌─────────┐     ┌──────────┐
│  User   │────▶│  BLoC   │────▶│  Repo   │────▶│  Local   │
│ Action  │     │  Event  │     │  (Sync) │     │   Hive   │
└─────────┘     └─────────┘     └─────────┘     └──────────┘
                                    │                  │
                                    ▼                  ▼
                             ┌─────────────┐   ┌──────────────┐
                             │   Remote    │   │  UI Update   │
                             │  Firebase   │◀──│  Optimistic  │
                             └─────────────┘   └──────────────┘
🛠️ Tech Stack
Technology	Purpose
Flutter	UI Framework
Dart	Programming Language
BLoC	State Management
Firebase Firestore	Cloud Database
Hive	Local Database
Connectivity Plus	Network Status
Shared Preferences	Theme Persistence
GoRouter	Navigation
GetIt	Dependency Injection
Equatable	Value Equality
UUID	Unique ID Generation
📦 Dependencies
yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_bloc: ^8.1.3
  bloc: ^8.1.2
  
  # Firebase
  firebase_core: ^2.24.2
  cloud_firestore: ^4.14.0
  
  # Local Storage
  hive_flutter: ^1.1.0
  hive: ^2.2.3
  
  # Connectivity
  connectivity_plus: ^5.0.1
  
  # Theme Persistence
  shared_preferences: ^2.2.2
  
  # Navigation
  go_router: ^13.0.1
  
  # Utilities
  equatable: ^2.0.5
  uuid: ^4.3.3
  get_it: ^7.6.4
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  hive_generator: ^2.0.0
  build_runner: ^2.4.6
📁 Project Structure
text
lib/
├── core/
│   ├── di/
│   │   └── injection.dart          # Dependency Injection
│   ├── enum/
│   │   └── task_filter.dart        # Filter enums
│   └── router/
│       ├── app_router.dart
│       └── app_routes.dart
│
├── feature/
│   ├── connectivity/               # Connectivity Feature
│   │   ├── data/
│   │   │   └── repo_impl/
│   │   │       └── connectivity_repo_impl.dart
│   │   ├── domain/
│   │   │   └── repositories/
│   │   │       └── connectivity_repository.dart
│   │   └── presentation/
│   │       ├── cubit/
│   │       │   ├── connectivity_cubit.dart
│   │       │   └── connectivity_state.dart
│   │       └── widget/
│   │           └── connectivity_banner.dart
│   │
│   ├── theme/                      # Theme Feature
│   │   └── bloc/
│   │       ├── theme_cubit.dart
│   │       ├── theme_event.dart
│   │       └── theme_state.dart
│   │
│   └── todo/                       # Todo Feature
│       ├── data/
│       │   ├── datasources/
│       │   │   ├── task_local_datasource.dart
│       │   │   └── task_remote_datasource.dart
│       │   ├── mapper/
│       │   │   └── task_mapper.dart
│       │   ├── model/
│       │   │   ├── task_hive_model.dart
│       │   │   └── task_model.dart
│       │   └── repository_impl/
│       │       └── task_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   └── task_entity.dart
│       │   └── repositories/
│       │       └── task_repository.dart
│       └── presentation/
│           ├── bloc/
│           │   ├── task_bloc.dart
│           │   ├── task_event.dart
│           │   └── task_state.dart
│           ├── pages/
│           │   ├── add_edit_page.dart
│           │   ├── splash_screen.dart
│           │   └── todolist_page.dart
│           └── widgets/
│               ├── empty_state.dart
│               ├── searchbar.dart
│               └── task_tile.dart
│
├── utils/
│   └── searchbar.dart
│
└── main.dart
🔄 BLoC Events & States
Task Events
Event	Description
WatchTasksRequested	Start listening to task stream
TasksUpdated	Update task list from stream
TaskAdded	Add a new task
TaskUpdated	Update existing task
TaskToggled	Toggle completion status
TaskDeleted	Delete a task
TaskRestored	Restore deleted task
Task States
State	Description
TaskInitial	Initial state
TaskLoading	Loading tasks
TaskLoaded	Tasks loaded successfully
TaskError	Error occurred
Connectivity States
State	Description
ConnectivityStatus.online	Device is online
ConnectivityStatus.offline	Device is offline
Theme States
State	Description
ThemeState.light	Light theme active
ThemeState.dark	Dark theme active
💾 Offline-First Strategy
1. Local Storage (Hive)
dart
// Tasks are cached locally
await localDataSource.cacheTasks(tasks);

// Immediate UI updates from cache
final cached = localDataSource.getCachedTasks();
_controller?.add(cached);
2. Sync Strategy
Optimistic Updates: UI updates instantly

Background Sync: Firebase sync in background

Conflict Resolution: Last write wins (simple strategy)

Fallback: Cache serves when offline

3. Connectivity Handling
Visual banner shows online/offline status

Operations work offline

Auto-sync when connectivity restores

🔧 Firebase Setup
Firestore Rules
javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /tasks/{document} {
      allow read, write: if request.auth != null;
    }
  }
}
Firestore Indexes
Create composite index for:

Collection: tasks

Fields: createdAt (descending)

🚦 Getting Started
Prerequisites
Flutter SDK (>=3.0.0)

Android Studio / VS Code

Firebase Account

Installation
Clone the repository

bash
git clone https://github.com/yourusername/nexvoria_assignment_flutter.git
cd nexvoria_assignment_flutter
Install dependencies

bash
flutter pub get
Generate Hive adapter (if using build_runner)

bash
flutter pub run build_runner build --delete-conflicting-outputs
Configure Firebase

Create a Firebase project

Add Android/iOS apps

Download google-services.json (Android) and GoogleService-Info.plist (iOS)

Place them in the appropriate directories

Run the app

bash
flutter run
🎨 UI Features
Theme Management
Persistent theme preference using SharedPreferences

Toggle between light/dark mode

Material Design 3 components

Search & Filter
Real-time search by title/description

Filter: All, Pending, Completed

Empty states for no results

Swipe Actions
Swipe right-to-left to delete

Undo option with SnackBar

Visual feedback with red background
