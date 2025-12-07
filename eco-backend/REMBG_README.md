# Background Removal with rembg

## Installation

The backend now includes background removal using the `rembg` library. This strips the background from uploaded images before classification, improving accuracy.

### Install rembg

```bash
cd eco-backend
source .venv/bin/activate
pip install rembg
```

**Note:** The installation may take several minutes as it downloads the ML model (~170MB).

### What it does

1. **Backend Processing**:
   - User uploads an image
   - Backend removes the background using rembg
   - Processes the foreground image with YOLO for classification
   - Returns both the classification result AND the foreground image

2. **Frontend Display**:
   - Shows the original image initially
   - After classification, replaces it with the foreground-only image
   - Provides a cleaner, more professional look

### Fallback Behavior

If rembg is not installed:
- Backend will still work normally
- Uses the original image for classification
- No foreground image is returned to frontend

### Requirements

Added to `requirements.txt`:
```
rembg
```

This will automatically install on deployment.

### API Response Format

```json
{
  "message": "Image classified successfully",
  "predictions": [
    {
      "class_id": 0,
      "class_name": "plastic",
      "confidence": 0.95
    }
  ],
  "count": 1,
  "foreground_image": "base64_encoded_png_image_here"
}
```

The `foreground_image` field contains a base64-encoded PNG with transparent background.
