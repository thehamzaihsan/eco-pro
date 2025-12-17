# EcoSort - Flutter Trash Detector App

A beautiful Flutter mobile application that uses AI to detect and classify different types of trash using the EcoSort backend API.

## Features

- 📸 **Camera Integration** - Capture photos directly from your device camera
- 🖼️ **Gallery Support** - Upload images from your photo gallery
- 🤖 **AI-Powered Detection** - Real-time trash classification using YOLOv11 model
- 🎨 **Beautiful UI** - Modern dark theme with gradient effects
- 📊 **Confidence Scores** - View all predictions with confidence percentages
- ⚡ **Fast Response** - Get results in milliseconds
- 🔄 **Backend Health Check** - Monitor connection status with the backend

## Supported Trash Categories

The app can detect and classify 12 different types of waste:

- 📄 Paper
- 📦 Cardboard
- 🥤 Plastic
- 🌿 Vegetation
- 🍂 Biological
- 🔩 Metal
- 👕 Clothes
- 🍾 Glass
- 🗑️ Trash
- 👟 Shoes
- 🔋 Battery
- ❓ Others

## Prerequisites

- Flutter SDK (3.9.2 or higher)
- Dart SDK
- Android Studio / Xcode (for running on emulators)
- EcoSort Django Backend running (see backend setup below)

## Installation

1. **Clone the repository** (if not already done):
   ```bash
   cd /home/hamzaihsan/Desktop/eco-pro/trash_detector_app
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Configure Backend URL**:
   
   Edit `lib/services/api_service.dart` and update the `baseUrl`:
   
   ```dart
   // For Android Emulator
   static const String baseUrl = 'http://10.0.2.2:8000';
   
   // For iOS Simulator
   static const String baseUrl = 'http://localhost:8000';
   
   // For Physical Device (use your computer's IP)
   static const String baseUrl = 'http://192.168.1.XXX:8000';
   
   // For Production
   static const String baseUrl = 'https://your-backend.onrender.com';
   ```

## Backend Setup

The app requires the EcoSort Django backend to be running. Start the backend:

```bash
cd /home/hamzaihsan/Desktop/eco-pro/eco-backend
python -m venv .venv
source .venv/bin/activate  # On Windows: .venv\Scripts\activate
pip install -r requirements.txt
python manage.py runserver
```

The backend should be accessible at `http://127.0.0.1:8000`

## Running the App

### On Android Emulator

1. Start Android Emulator from Android Studio
2. Run the app:
   ```bash
   flutter run
   ```

### On iOS Simulator

1. Open iOS Simulator
2. Run the app:
   ```bash
   flutter run
   ```

### On Physical Device

1. Connect your device via USB
2. Enable USB debugging (Android) or Trust the device (iOS)
3. Update the backend URL to your computer's IP address
4. Run:
   ```bash
   flutter run
   ```

## Project Structure

```
trash_detector_app/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── models/
│   │   └── classification_result.dart  # Data models
│   ├── services/
│   │   └── api_service.dart      # Backend API integration
│   ├── screens/
│   │   └── home_screen.dart      # Main screen
│   └── widgets/
│       └── result_card.dart      # Result display widget
├── pubspec.yaml                  # Dependencies
└── README.md                     # This file
```

## Dependencies

- **http** - HTTP client for API calls
- **image_picker** - Camera and gallery integration
- **cached_network_image** - Efficient image loading
- **provider** - State management
- **flutter_spinkit** - Loading animations

## Usage

1. **Launch the app** on your device/emulator
2. **Check backend status** - Green dot in app bar means connected
3. **Choose input method**:
   - Tap **Camera** to take a new photo
   - Tap **Gallery** to select an existing image
4. **View results**:
   - See the top prediction with confidence score
   - View all predictions ranked by confidence
   - Check inference time and model information

## Troubleshooting

### Backend Not Connected

- Ensure Django backend is running on port 8000
- Check the `baseUrl` in `api_service.dart`
- For Android emulator, use `10.0.2.2` instead of `localhost`
- For physical device, use your computer's local IP address
- Check firewall settings

### Camera Not Working

- Grant camera permissions in device settings
- For iOS, add camera usage description in `Info.plist`
- For Android, ensure permissions are declared in `AndroidManifest.xml`

### Build Errors

```bash
flutter clean
flutter pub get
flutter run
```

## API Response Format

The app expects the following JSON response from the backend:

```json
{
  "predictions": [
    {
      "label": "plastic",
      "confidence": 0.92
    },
    {
      "label": "cardboard",
      "confidence": 0.05
    }
  ],
  "model_name": "yoloMODEL_old_cls_12.pt",
  "inference_time_ms": 156.3
}
```

## Testing API Manually

Test the backend API with curl:

```bash
curl -X POST http://127.0.0.1:8000/api/classify/ \
  -F "image=@test_image.jpg"
```

## Configuration for Production

1. Update `baseUrl` in `api_service.dart` to production URL
2. Build release version:
   ```bash
   # Android
   flutter build apk --release
   
   # iOS
   flutter build ios --release
   ```

## Screenshots

### Home Screen
- Modern dark theme with gradient header
- Camera and Gallery buttons
- Backend connection indicator

### Results Screen
- Large emoji and category display
- Confidence percentage badge
- All predictions with progress bars
- Model information and inference time

## Performance

- **Average inference time**: 50-200ms (depends on backend)
- **Image upload**: < 1 second (local network)
- **App size**: ~15-20 MB (after compression)

## Contributing

Contributions are welcome! Please feel free to submit pull requests.

## License

MIT License - See main project LICENSE file

## Credits

- **Backend API**: EcoSort Django Backend
- **ML Model**: YOLOv11n (Ultralytics)
- **UI Framework**: Flutter
- **Icons**: Material Icons & Emoji

## Links

- **Main Project**: [EcoSort](https://ecopro.hamzaihsan.me)
- **Backend Docs**: See `eco-backend/README.md`
- **Flutter Docs**: https://docs.flutter.dev/

---

Built with ❤️ using Flutter and EcoSort AI
