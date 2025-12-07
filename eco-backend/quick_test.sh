#!/bin/bash
# Quick test script for backend API

# Check if backend is running
if ! curl -s http://127.0.0.1:8000/api/classify/ > /dev/null 2>&1; then
    echo "❌ Backend is not running!"
    echo ""
    echo "Start the backend first:"
    echo "  cd eco-backend"
    echo "  source .venv/bin/activate"
    echo "  python manage.py runserver 0.0.0.0:8000"
    exit 1
fi

echo "✅ Backend is running!"
echo ""

# Check if we have a test image in public/stats
TEST_IMAGE="../public/stats/confusion_matrix.png"

if [ ! -f "$TEST_IMAGE" ]; then
    # Try to find any image
    TEST_IMAGE=$(find .. -name "*.jpg" -o -name "*.png" | head -1)
fi

if [ -z "$TEST_IMAGE" ] || [ ! -f "$TEST_IMAGE" ]; then
    echo "⚠️  No test image found. Downloading one..."
    curl -o /tmp/test_waste.jpg "https://images.unsplash.com/photo-1604187351574-c75ca79f5807?w=400" 2>/dev/null
    TEST_IMAGE="/tmp/test_waste.jpg"
fi

echo "📸 Using test image: $TEST_IMAGE"
echo ""
echo "🔄 Sending request to API..."
echo ""

# Make the request
RESPONSE=$(curl -s -X POST http://127.0.0.1:8000/api/classify/ \
  -F "image=@$TEST_IMAGE")

echo "📥 Response:"
echo "$RESPONSE" | jq . 2>/dev/null || echo "$RESPONSE"
echo ""

# Extract and display key info
if command -v jq &> /dev/null; then
    PREDICTIONS=$(echo "$RESPONSE" | jq -r '.predictions[]? | "\(.class_name) (\(.confidence * 100 | floor)%)"' 2>/dev/null)
    if [ ! -z "$PREDICTIONS" ]; then
        echo "✅ Detected objects:"
        echo "$PREDICTIONS"
    fi
fi
