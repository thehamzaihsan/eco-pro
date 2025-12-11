@echo off
REM Test all YOLO models via API (Windows)

set IMAGE=%1
if "%IMAGE%"=="" set IMAGE=test_image.jpg

set API_URL=%2
if "%API_URL%"=="" set API_URL=http://localhost:8000/api/classify/

echo ======================================
echo Testing All YOLO Models
echo ======================================
echo Image: %IMAGE%
echo API URL: %API_URL%
echo.

REM Check if image exists
if not exist "%IMAGE%" (
    echo Error: Image file '%IMAGE%' not found!
    pause
    exit /b 1
)

REM Test Model 1: YOLOv11m (3 Classes)
echo 1. Testing YOLOv11m ^(3 Classes^)...
echo --------------------------------------
curl -s -X POST -F "image=@%IMAGE%" -F "model=yolov11m-3class" "%API_URL%"
echo.
echo.

REM Test Model 2: YOLOv11n (12 Classes) - Default
echo 2. Testing YOLOv11n ^(12 Classes^) - DEFAULT
echo --------------------------------------
curl -s -X POST -F "image=@%IMAGE%" -F "model=yolov11n-12class" "%API_URL%"
echo.
echo.

REM Test Model 3: YOLOv8n (3 Classes)
echo 3. Testing YOLOv8n ^(3 Classes^) - Legacy
echo --------------------------------------
curl -s -X POST -F "image=@%IMAGE%" -F "model=yolov8n-3class" "%API_URL%"
echo.
echo.

REM Test default (no model specified)
echo 4. Testing Default Model ^(no model param^)
echo --------------------------------------
curl -s -X POST -F "image=@%IMAGE%" "%API_URL%"
echo.
echo.

REM List available models
echo 5. Listing Available Models
echo --------------------------------------
curl -s "http://localhost:8000/api/models/"
echo.
echo.

echo ======================================
echo All tests completed!
echo ======================================
pause
