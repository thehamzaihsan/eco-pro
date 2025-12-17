# Flutter Trash Detector App - Quick Start Guide

## 🚀 Quick Start (5 Minutes)

### 1. Backend Setup (Terminal 1)
```bash
cd eco-backend
python -m venv .venv
source .venv/bin/activate  # Windows: .venv\Scripts\activate
pip install -r requirements.txt
python manage.py runserver
```
Keep this running! Backend will be at http://127.0.0.1:8000

### 2. Flutter App Setup (Terminal 2)
```bash
cd trash_detector_app
flutter pub get
```

### 3. Configure Backend URL
Open `trash_detector_app/lib/services/api_service.dart` and set:

**For Android Emulator:**
```dart
static const String baseUrl = 'http://10.0.2.2:8000';
```

**For iOS Simulator:**
```dart
static const String baseUrl = 'http://localhost:8000';
```

**For Physical Device:**
```dart
static const String baseUrl = 'http://YOUR_COMPUTER_IP:8000';
```
(Find your IP with `ipconfig` on Windows or `ifconfig` on Mac/Linux)

### 4. Run the App
```bash
cd trash_detector_app
flutter run
```

Select your device when prompted (emulator or physical device).

### 5. Use the App
1. ✅ Check green dot in app bar (backend connected)
2. 📸 Tap "Camera" or "Gallery"
3. 🖼️ Select/capture trash image
4. 🎯 View AI classification results!

## 📱 Supported Platforms
- ✅ Android (Emulator & Physical)
- ✅ iOS (Simulator & Physical)

## 🎯 What It Does
Detects 12 types of trash:
📄 Paper | 📦 Cardboard | 🥤 Plastic | 🌿 Vegetation | 🍂 Biological | 🔩 Metal
👕 Clothes | 🍾 Glass | 🗑️ Trash | 👟 Shoes | 🔋 Battery | ❓ Others

## ⚠️ Troubleshooting

**Backend Not Connected?**
- Check Django server is running on port 8000
- Verify baseUrl in api_service.dart
- For Android emulator use `10.0.2.2`, NOT `localhost`

**Camera Not Working?**
- Grant camera permissions in device settings
- Check AndroidManifest.xml / Info.plist permissions

**Build Errors?**
```bash
flutter clean
flutter pub get
flutter run
```

## 📚 Full Documentation
See `trash_detector_app/README.md` for complete details.

---
**Need Help?** Check the backend is running first, then verify your baseUrl matches your setup!
