# Product Requirements Document (PRD)
# WASap - Sapa Lebih Mudah

---

## 1. Introduction

### 1.1 Purpose
This document outlines the requirements for the WASap mobile application. The app enables users to quickly launch WhatsApp with pre-filled phone numbers by automatically normalizing Indonesian phone number formats.

### 1.2 Scope
- **App Name**: WASap
- **Tagline**: Sapa Lebih Mudah
- **Package Name**: `com.ceko.wasap`
- **Version**: 1.1.0+8
- **Platform**: Android (primary), iOS (secondary)
- **Framework**: Flutter 3.10+

---

## 2. User Experience (UX) Requirements

### 2.1 Target Audience
- Indonesian users who frequently share WhatsApp contact links
- Business users needing quick WhatsApp contact launching
- Anyone needing phone number format normalization for WhatsApp
- General audience seeking a simple way to start WhatsApp conversations

### 2.2 User Flow
1. User opens WASap
2. User enters/pastes a phone number in any format
3. App displays normalized phone number in real-time
4. User taps "Open WhatsApp" button
5. WhatsApp opens with the number pre-filled — ready to say hello

### 2.3 UI/UX Specification

#### Layout Structure
- **Single-page design** with scrollable content
- **AppBar**: App title "WASap" + Settings icon (top-right)
- **Subtitle**: "Sapa Lebih Mudah" below AppBar
- **Main content**: Phone input card + Recent numbers section + Action button + Info card
- **Bottom Sheet**: Settings panel (language/theme selection)

#### Visual Design
- **Primary Color**: `#3A87AD` (teal blue)
- **WhatsApp Button**: `#25D366` (official WhatsApp green)
- **Typography**: Google Fonts - Inter
- **Design System**: Material Design 3
- **Border Radius**: 16-20px (rounded cards)
- **Elevation**: Minimal (flat design)

#### Theme Support
- Light theme (default)
- Dark theme
- System theme persistence via SharedPreferences

#### Localization
- English (en) - Default
- Indonesian (id) - Bahasa Indonesia

### 2.4 Screens & Components

#### Home Screen
- Header: App title "WASap" + subtitle "Sapa Lebih Mudah"
- Phone Input Card:
  - Icon indicator (phone_android)
  - Label: "Phone Number"
  - TextField with phone keyboard
  - Prefix icon (phone)
  - Suffix icons: paste/clear
  - Normalized preview box (shows `+62XXXXXXXXX`)
  - Validation status icon (check_circle/error)
  - Error message display area
- Recent Numbers Section:
  - Section title + clear all button
  - Horizontal wrap of recent number chips
- Open WhatsApp Button:
  - WhatsApp green background
  - Disabled state when input invalid
  - Loading spinner during launch
- Info Card:
  - "How It Works" section
  - Example formats displayed as chips

#### Settings Bottom Sheet
- Header: "Settings" title
- Language Selector:
  - Two options: English 🇬🇧 / Indonesian 🇮🇩
  - Card-style selection buttons
- Theme Selector:
  - Two options: Light / Dark
  - Card-style selection buttons

---

## 3. Functional Requirements

### 3.1 Core Features

#### F1: Phone Number Normalization
**Description**: Automatically convert various Indonesian phone formats to WhatsApp-compatible format.

**Supported Input Formats**:
| Input | Output |
|-------|--------|
| `08123456789` | `628123456789` |
| `8123456789` | `628123456789` |
| `628123456789` | `628123456789` |
| `+628123456789` | `628123456789` |

**Normalization Logic**:
1. Remove all non-digit characters
2. If starts with `62` → use as-is
3. If starts with `0` → replace `0` with `62`
4. If starts with `8` → prepend `62`
5. Otherwise → prepend `62`

#### F2: WhatsApp Launch
**Description**: Open WhatsApp with normalized number pre-filled.

**URL Format**: `https://wa.me/{normalizedNumber}?text=`

**Behavior**:
- Launch via `url_launcher` package
- Handle missing WhatsApp installation gracefully
- Show loading state during launch

#### F3: Recent Numbers History
**Description**: Store and display recently used phone numbers.

**Implementation**:
- Store last 20 numbers in SharedPreferences
- Display as tappable chips
- Tap to re-use number
- Clear all option available

#### F4: Clipboard Paste
**Description**: Quick paste phone number from clipboard.

**Behavior**:
- Paste button in text field suffix
- On tap: read clipboard, populate field, normalize

#### F5: Settings Persistence
**Description**: Save user preferences locally.

**Stored Settings**:
- Theme mode (light/dark)
- Locale (en/id)

---

## 4. Architecture

### 4.1 Clean Architecture Layers

```

lib/
├── domain/                 # Business Logic Layer
│   ├── entities/          # Core business objects
│   │   ├── phone_number.dart
│   │   ├── app_settings.dart
│   │   └── recent_number.dart
│   ├── repositories/      # Repository interfaces
│   │   ├── whatsapp_repository.dart
│   │   └── phone_repository.dart
│   └── usecases/          # Business use cases
│       ├── normalize_phone_number.dart
│       └── launch_whatsapp.dart
│
├── data/                   # Data Layer
│   ├── services/           # External service implementations
│   │   ├── phone_normalizer.dart
│   │   ├── whatsapp_launcher.dart
│   │   ├── settings_storage.dart
│   │   └── recent_numbers_storage.dart
│   └── repositories/      # Repository implementations
│       └── whatsapp_repository_impl.dart
│
├── presentation/           # UI Layer
│   ├── controllers/        # Riverpod state management
│   │   ├── phone_controller.dart
│   │   ├── settings_controller.dart
│   │   └── recent_numbers_controller.dart
│   ├── providers/         # Dependency injection
│   ├── screens/           # Page widgets
│   │   └── home_screen.dart
│   ├── widgets/           # Reusable UI components
│   │   └── settings_sheet.dart
│   └── theme/             # Theme configuration
│       └── app_theme.dart
│
├── l10n/                  # Localization
│   ├── app_localizations.dart
│   ├── app_localizations_en.dart
│   └── app_localizations_id.dart
│
└── main.dart              # App entry point

```

### 4.2 State Management
- **Riverpod** (with code generation)
- Providers:
  - `phoneControllerProvider` - Phone input state
  - `settingsControllerProvider` - App settings state
  - `recentNumbersControllerProvider` - Recent numbers state

---

## 5. Technical Requirements

### 5.1 Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| flutter_riverpod | ^2.4.9 | State management |
| riverpod_annotation | ^2.3.3 | Code generation annotations |
| url_launcher | ^6.2.2 | Launch external URLs |
| google_fonts | ^6.1.0 | Typography |
| intl | any | Internationalization |
| shared_preferences | ^2.2.2 | Local persistence |

### 5.2 Dev Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| flutter_lints | ^6.0.0 | Code quality |
| riverpod_generator | ^2.3.9 | Code generation |
| build_runner | ^2.4.7 | Build tool |
| riverpod_lint | ^2.3.7 | Linting |
| flutter_launcher_icons | ^0.13.1 | App icons |

### 5.3 Android Permissions
- `INTERNET` - For launching WhatsApp web URL
- `QUERY_ALL_PACKAGES` - For detecting WhatsApp installation

### 5.4 Build Commands

```
# Development
flutter run

# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release
```

---

## 6. Non-Functional Requirements

### 6.1 Performance

· App launch time: < 2 seconds
· Normalization response: < 100ms
· Smooth 60fps scrolling

### 6.2 Reliability

· Graceful error handling for invalid numbers
· Empty state handling for recent numbers
· Offline functionality (all features work offline)

### 6.3 Maintainability

· Clean Architecture separation
· Comprehensive code comments
· Code generation for providers

---

## 7. Edge Cases & Error Handling

Scenario Handling
Empty input Hide normalized preview, disable button
Invalid format Show error message, show error icon
WhatsApp not installed Show error via url_launcher failure
Clipboard empty No action on paste button tap
Very long input Text field truncation with scroll

---

## 8. Branding & Messaging

### 8.1 App Name

WASap — derived from "WA" (WhatsApp) + "Sap" (Sapa)

### 8.2 Tagline

Sapa Lebih Mudah

### 8.3 Key Messaging

· Sapa, Klik, Kirim
· Cukup masukkan nomor, WASap yang bekerja
· Siapa pun, sapa WA

### 8.4 App Icon Concept

· WhatsApp green (#25D366) bubble
· Simple hand wave 👋 or chat bubble with greeting symbol
· Clean, minimal, easily recognizable

---

## 9. Future Considerations (Out of Scope)

· Contact list import
· Message templates
· Multiple country support
· WhatsApp Business support
· Widget for home screen

---

### 10. Success Metrics

· Users can normalize phone numbers in < 1 second
· 100% of valid Indonesian numbers normalize correctly
· App works completely offline
· Settings persist across app restarts
· Brand recognition: "WASap" associated with easy WhatsApp greeting

---

Document Version: 1.2.0
Last Updated: March 2026
App Name: WASap | Tagline: Sapa Lebih Mudah