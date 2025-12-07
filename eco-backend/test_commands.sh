#!/bin/bash
# Backend Testing Commands for EcoSort Classification API

echo "======================================"
echo "EcoSort Backend Testing Guide"
echo "======================================"
echo ""

# 1. Start Backend Server
echo "1. START BACKEND SERVER"
echo "------------------------"
echo "cd eco-backend"
echo "source .venv/bin/activate"
echo "python manage.py runserver 0.0.0.0:8000"
echo ""
echo "Keep this terminal running!"
echo ""

# 2. Test with curl (basic check)
echo "2. CHECK SERVER IS RUNNING"
echo "------------------------"
echo "curl -X OPTIONS http://127.0.0.1:8000/api/classify/"
echo ""

# 3. Test with an image file
echo "3. TEST WITH IMAGE FILE"
echo "------------------------"
echo "# Download a test image first:"
echo "curl -o test_image.jpg https://images.unsplash.com/photo-1604187351574-c75ca79f5807?w=400"
echo ""
echo "# Then test the classify endpoint:"
echo "curl -X POST http://127.0.0.1:8000/api/classify/ \\"
echo "  -F 'image=@test_image.jpg' \\"
echo "  -H 'Accept: application/json'"
echo ""

# 4. Test with verbose output
echo "4. TEST WITH VERBOSE OUTPUT (see full response)"
echo "------------------------"
echo "curl -v -X POST http://127.0.0.1:8000/api/classify/ \\"
echo "  -F 'image=@test_image.jpg'"
echo ""

# 5. Pretty print JSON response
echo "5. TEST WITH PRETTY JSON OUTPUT"
echo "------------------------"
echo "curl -s -X POST http://127.0.0.1:8000/api/classify/ \\"
echo "  -F 'image=@test_image.jpg' | jq ."
echo ""
echo "Note: Install jq if needed: sudo dnf install jq"
echo ""

# 6. Test multiple images
echo "6. TEST MULTIPLE IMAGES"
echo "------------------------"
echo "for img in *.jpg; do"
echo "  echo 'Testing: \$img'"
echo "  curl -s -X POST http://127.0.0.1:8000/api/classify/ \\"
echo "    -F \"image=@\$img\" | jq '.predictions[0].class_name'"
echo "done"
echo ""

# 7. Performance test
echo "7. PERFORMANCE TEST (10 requests)"
echo "------------------------"
echo "time for i in {1..10}; do"
echo "  curl -s -X POST http://127.0.0.1:8000/api/classify/ \\"
echo "    -F 'image=@test_image.jpg' > /dev/null"
echo "done"
echo ""

# 8. Check server logs
echo "8. VIEW SERVER LOGS"
echo "------------------------"
echo "# Logs appear in the terminal where you ran 'python manage.py runserver'"
echo ""

echo "======================================"
echo "Quick Test Command"
echo "======================================"
echo "curl -X POST http://127.0.0.1:8000/api/classify/ -F 'image=@path/to/image.jpg'"
echo ""
