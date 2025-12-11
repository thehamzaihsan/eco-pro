#!/bin/bash
# Test all YOLO models via API

IMAGE="${1:-test_image.jpg}"
API_URL="${2:-http://localhost:8000/api/classify/}"

echo "======================================"
echo "Testing All YOLO Models"
echo "======================================"
echo "Image: $IMAGE"
echo "API URL: $API_URL"
echo ""

# Check if image exists
if [ ! -f "$IMAGE" ]; then
    echo "Error: Image file '$IMAGE' not found!"
    exit 1
fi

# Test Model 1: YOLOv11m (3 Classes)
echo "1. Testing YOLOv11m (3 Classes)..."
echo "--------------------------------------"
curl -s -X POST \
  -F "image=@$IMAGE" \
  -F "model=yolov11m-3class" \
  "$API_URL" | python3 -m json.tool || echo "Failed to parse JSON"
echo ""

# Test Model 2: YOLOv11n (12 Classes) - Default
echo "2. Testing YOLOv11n (12 Classes) - DEFAULT"
echo "--------------------------------------"
curl -s -X POST \
  -F "image=@$IMAGE" \
  -F "model=yolov11n-12class" \
  "$API_URL" | python3 -m json.tool || echo "Failed to parse JSON"
echo ""

# Test Model 3: YOLOv8n (3 Classes)
echo "3. Testing YOLOv8n (3 Classes) - Legacy"
echo "--------------------------------------"
curl -s -X POST \
  -F "image=@$IMAGE" \
  -F "model=yolov8n-3class" \
  "$API_URL" | python3 -m json.tool || echo "Failed to parse JSON"
echo ""

# Test default (no model specified)
echo "4. Testing Default Model (no model param)"
echo "--------------------------------------"
curl -s -X POST \
  -F "image=@$IMAGE" \
  "$API_URL" | python3 -m json.tool || echo "Failed to parse JSON"
echo ""

# List available models
echo "5. Listing Available Models"
echo "--------------------------------------"
curl -s "${API_URL%/classify/}/models/" | python3 -m json.tool || echo "Failed to parse JSON"
echo ""

echo "======================================"
echo "All tests completed!"
echo "======================================"
