Here’s a clean and professional **documentation snippet** you can paste into your `README.md` file for setting up fingerprint authentication in your Flutter app, including build issues like NDK mismatch and `FragmentActivity` setup.

---

## 🔐 Fingerprint Authentication Setup in Flutter

This project uses [`local_auth`](https://pub.dev/packages/local_auth) to support biometric authentication (fingerprint, face unlock). Below are the configuration steps for Android.

---

### ✅ Features

* Fingerprint biometric lock
* Fallback PIN screen after 3 failed attempts
* Secure unlock mechanism using Flutter

---

## ⚙️ Setup Instructions

### 1. Add Dependencies

In `pubspec.yaml`:

```yaml
dependencies:
  local_auth: ^2.1.6
```

---

### 2. Android Configuration

#### ➤ `build.gradle.kts` (app level):

Add the following in the `android` block:

```kotlin
android {
    ndkVersion = "27.0.12077973" // Required by local_auth
}
```

> 🔧 Make sure NDK version 27.0.12077973 is installed via **Android Studio → SDK Manager → NDK (Side by side)**.

#### ➤ `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.USE_BIOMETRIC"/>
<uses-permission android:name="android.permission.USE_FINGERPRINT"/>
```

#### ➤ `MainActivity.kt`:

> Replace `FlutterActivity` with `FlutterFragmentActivity` (required by biometric plugin).

```kotlin
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity: FlutterFragmentActivity() {
}
```

---

### 3. iOS Configuration

In `ios/Runner/Info.plist`:

```xml
<key>NSFaceIDUsageDescription</key>
<string>Used to unlock the app using Face ID.</string>
```

---

### 4. Common Issues & Fixes

#### ❌ NDK Version Mismatch

If you see:

```
local_auth_android requires Android NDK 27.0.12077973
```

Fix it by setting `ndkVersion` in `build.gradle.kts` and installing the correct version via Android Studio.

---

#### ❌ `no_fragment_activity` Error

If you get:

```
PlatformException(no_fragment_activity, local_auth plugin requires activity to be a FragmentActivity.)
```

Change your `MainActivity` to extend `FlutterFragmentActivity`.

---

#### ❌ Disk Space Errors

If build fails with:

```
There is not enough space on the disk
```

Clean up space in `C:` drive, especially:

* `C:\Users\<your_name>\.gradle\caches`
* `C:\Users\<your_name>\AppData\Local\Temp`
* Run `flutter clean` to remove old build files.

---

### 5. Build & Run

```bash
flutter clean
flutter pub get
flutter run
```

