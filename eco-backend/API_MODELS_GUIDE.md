# Using Different YOLO Models via API

## 📋 Available Models

Your backend supports **3 different YOLO models**:

| Model Key | Model Name | Classes | Use Case |
|-----------|------------|---------|----------|
| `yolov11m-3class` | YOLOv11m (3 Classes) | 3 | Fast, basic classification |
| `yolov11n-12class` | YOLOv11n (12 Classes) | 12 | **Default** - Detailed classification |
| `yolov8n-3class` | YOLOv8n (3 Classes) | 3 | Legacy, basic classification |

**Default Model:** `yolov11n-12class` (12 classes)

---

## 🔍 API Endpoints

### 1. List Available Models
**Endpoint:** `GET /api/models/`

#### Using curl (Linux/Mac/Git Bash):
```bash
curl http://localhost:8000/api/models/
```

#### Using curl (Windows Command Prompt):
```cmd
curl http://localhost:8000/api/models/
```

#### Using PowerShell:
```powershell
Invoke-RestMethod -Uri "http://localhost:8000/api/models/" -Method Get
```

#### Response:
```json
{
  "models": [
    {
      "key": "yolov11m-3class",
      "name": "YOLOv11m (3 Classes)",
      "classes": 3
    },
    {
      "key": "yolov11n-12class",
      "name": "YOLOv11n (12 Classes)",
      "classes": 12
    },
    {
      "key": "yolov8n-3class",
      "name": "YOLOv8n (3 Classes)",
      "classes": 3
    }
  ],
  "default": "yolov11n-12class"
}
```

---

## 🎯 Classify Images with Different Models

### 2. Classify Image (Default Model)
**Endpoint:** `POST /api/classify/`

#### Using curl (Linux/Mac/Git Bash):
```bash
curl -X POST \
  -F "image=@test_image.jpg" \
  http://localhost:8000/api/classify/
```

#### Using curl (Windows Command Prompt):
```cmd
curl -X POST -F "image=@test_image.jpg" http://localhost:8000/api/classify/
```

#### Using PowerShell:
```powershell
$uri = "http://localhost:8000/api/classify/"
$filePath = "test_image.jpg"
$fileBytes = [System.IO.File]::ReadAllBytes($filePath)
$fileName = [System.IO.Path]::GetFileName($filePath)

$boundary = [System.Guid]::NewGuid().ToString()
$LF = "`r`n"

$bodyLines = (
    "--$boundary",
    "Content-Disposition: form-data; name=`"image`"; filename=`"$fileName`"",
    "Content-Type: image/jpeg$LF",
    [System.Text.Encoding]::GetEncoding("iso-8859-1").GetString($fileBytes),
    "--$boundary--$LF"
) -join $LF

Invoke-RestMethod -Uri $uri -Method Post -ContentType "multipart/form-data; boundary=$boundary" -Body $bodyLines
```

---

## 🔄 Using Specific Models

### Using YOLOv11m (3 Classes) - Fast Model
```bash
# Linux/Mac/Git Bash
curl -X POST \
  -F "image=@test_image.jpg" \
  -F "model=yolov11m-3class" \
  http://localhost:8000/api/classify/
```

```cmd
REM Windows Command Prompt
curl -X POST -F "image=@test_image.jpg" -F "model=yolov11m-3class" http://localhost:8000/api/classify/
```

```powershell
# PowerShell
$form = @{
    image = Get-Item -Path "test_image.jpg"
    model = "yolov11m-3class"
}
Invoke-RestMethod -Uri "http://localhost:8000/api/classify/" -Method Post -Form $form
```

---

### Using YOLOv11n (12 Classes) - Default, Most Detailed
```bash
# Linux/Mac/Git Bash
curl -X POST \
  -F "image=@test_image.jpg" \
  -F "model=yolov11n-12class" \
  http://localhost:8000/api/classify/
```

```cmd
REM Windows Command Prompt
curl -X POST -F "image=@test_image.jpg" -F "model=yolov11n-12class" http://localhost:8000/api/classify/
```

```powershell
# PowerShell
$form = @{
    image = Get-Item -Path "test_image.jpg"
    model = "yolov11n-12class"
}
Invoke-RestMethod -Uri "http://localhost:8000/api/classify/" -Method Post -Form $form
```

---

### Using YOLOv8n (3 Classes) - Legacy Model
```bash
# Linux/Mac/Git Bash
curl -X POST \
  -F "image=@test_image.jpg" \
  -F "model=yolov8n-3class" \
  http://localhost:8000/api/classify/
```

```cmd
REM Windows Command Prompt
curl -X POST -F "image=@test_image.jpg" -F "model=yolov8n-3class" http://localhost:8000/api/classify/
```

```powershell
# PowerShell
$form = @{
    image = Get-Item -Path "test_image.jpg"
    model = "yolov8n-3class"
}
Invoke-RestMethod -Uri "http://localhost:8000/api/classify/" -Method Post -Form $form
```

---

## 📊 Example Response

### Successful Classification:
```json
{
  "message": "Image classified successfully",
  "model": "yolov11n-12class",
  "count": 3,
  "predictions": [
    {
      "class": "plastic_bottle",
      "confidence": 0.95,
      "bbox": {
        "x1": 120,
        "y1": 50,
        "x2": 250,
        "y2": 400
      }
    },
    {
      "class": "cardboard",
      "confidence": 0.88,
      "bbox": {
        "x1": 300,
        "y1": 100,
        "x2": 450,
        "y2": 350
      }
    },
    {
      "class": "glass_bottle",
      "confidence": 0.92,
      "bbox": {
        "x1": 500,
        "y1": 80,
        "x2": 620,
        "y2": 420
      }
    }
  ]
}
```

### No Objects Detected:
```json
{
  "message": "No objects detected in the image",
  "predictions": [],
  "model": "yolov11n-12class"
}
```

### Error - Invalid Model:
```json
{
  "error": "Invalid model key. Available models: ['yolov11m-3class', 'yolov11n-12class', 'yolov8n-3class']"
}
```

---

## 🧪 Testing All Models

### Bash Script (Linux/Mac/Git Bash):
```bash
#!/bin/bash
# test_all_models.sh

IMAGE="test_image.jpg"
API_URL="http://localhost:8000/api/classify/"

echo "Testing YOLOv11m (3 Classes)..."
curl -X POST -F "image=@$IMAGE" -F "model=yolov11m-3class" $API_URL | jq

echo -e "\nTesting YOLOv11n (12 Classes)..."
curl -X POST -F "image=@$IMAGE" -F "model=yolov11n-12class" $API_URL | jq

echo -e "\nTesting YOLOv8n (3 Classes)..."
curl -X POST -F "image=@$IMAGE" -F "model=yolov8n-3class" $API_URL | jq
```

Make executable and run:
```bash
chmod +x test_all_models.sh
./test_all_models.sh
```

---

### Batch Script (Windows):
```bat
@echo off
REM test_all_models.bat

set IMAGE=test_image.jpg
set API_URL=http://localhost:8000/api/classify/

echo Testing YOLOv11m (3 Classes)...
curl -X POST -F "image=@%IMAGE%" -F "model=yolov11m-3class" %API_URL%
echo.

echo Testing YOLOv11n (12 Classes)...
curl -X POST -F "image=@%IMAGE%" -F "model=yolov11n-12class" %API_URL%
echo.

echo Testing YOLOv8n (3 Classes)...
curl -X POST -F "image=@%IMAGE%" -F "model=yolov8n-3class" %API_URL%
echo.

pause
```

Run:
```cmd
test_all_models.bat
```

---

### PowerShell Script (Windows):
```powershell
# test_all_models.ps1

$image = "test_image.jpg"
$apiUrl = "http://localhost:8000/api/classify/"
$models = @("yolov11m-3class", "yolov11n-12class", "yolov8n-3class")

foreach ($model in $models) {
    Write-Host "`nTesting $model..." -ForegroundColor Cyan
    
    $form = @{
        image = Get-Item -Path $image
        model = $model
    }
    
    try {
        $response = Invoke-RestMethod -Uri $apiUrl -Method Post -Form $form
        $response | ConvertTo-Json -Depth 10
    }
    catch {
        Write-Host "Error: $_" -ForegroundColor Red
    }
}
```

Run:
```powershell
.\test_all_models.ps1
```

---

## 🌐 Using with Remote Server

Replace `localhost:8000` with your server URL:

```bash
# Example: Production server
curl -X POST \
  -F "image=@test_image.jpg" \
  -F "model=yolov11n-12class" \
  https://ecopro.hamzaihsan.me/api/classify/
```

```powershell
# PowerShell with remote server
$form = @{
    image = Get-Item -Path "test_image.jpg"
    model = "yolov11n-12class"
}
Invoke-RestMethod -Uri "https://ecopro.hamzaihsan.me/api/classify/" -Method Post -Form $form
```

---

## 📝 Python Example

```python
import requests

# List available models
response = requests.get('http://localhost:8000/api/models/')
print("Available models:", response.json())

# Classify with specific model
with open('test_image.jpg', 'rb') as f:
    files = {'image': f}
    data = {'model': 'yolov11n-12class'}
    
    response = requests.post(
        'http://localhost:8000/api/classify/',
        files=files,
        data=data
    )
    
    print("Results:", response.json())
```

---

## 🔧 Node.js/JavaScript Example

```javascript
const FormData = require('form-data');
const fs = require('fs');
const fetch = require('node-fetch');

async function classifyImage(imagePath, modelKey) {
    const form = new FormData();
    form.append('image', fs.createReadStream(imagePath));
    form.append('model', modelKey);

    const response = await fetch('http://localhost:8000/api/classify/', {
        method: 'POST',
        body: form
    });

    return await response.json();
}

// Usage
classifyImage('test_image.jpg', 'yolov11n-12class')
    .then(result => console.log(result))
    .catch(error => console.error(error));
```

---

## 🎨 Frontend Integration (React/Next.js)

```javascript
async function classifyWithModel(imageFile, modelKey = 'yolov11n-12class') {
    const formData = new FormData();
    formData.append('image', imageFile);
    formData.append('model', modelKey);

    try {
        const response = await fetch('http://localhost:8000/api/classify/', {
            method: 'POST',
            body: formData
        });

        const data = await response.json();
        return data;
    } catch (error) {
        console.error('Classification error:', error);
        throw error;
    }
}

// Usage in component
const handleImageUpload = async (file, selectedModel) => {
    const results = await classifyWithModel(file, selectedModel);
    console.log('Predictions:', results.predictions);
};
```

---

## 🔍 Model Comparison

| Feature | YOLOv11m (3 class) | YOLOv11n (12 class) | YOLOv8n (3 class) |
|---------|-------------------|---------------------|-------------------|
| **Speed** | Fast | Medium | Fast |
| **Accuracy** | Good | Best | Good |
| **Classes** | 3 | 12 | 3 |
| **Detail** | Basic | Detailed | Basic |
| **Use Case** | Quick sorting | Detailed analysis | Legacy support |
| **Model Size** | Medium | Small | Small |

---

## 💡 Best Practices

1. **Use default model** for most cases (12 classes)
2. **Use 3-class model** when speed is critical
3. **Always check response** for errors
4. **Handle timeouts** for large images
5. **Validate image format** before sending
6. **Cache model list** to reduce API calls

---

## 🚨 Error Handling

### Common Errors:

```bash
# Invalid model key
{
  "error": "Invalid model key. Available models: [...]"
}

# Missing image
{
  "image": ["This field is required."]
}

# Invalid image format
{
  "image": ["Upload a valid image."]
}

# Server error
{
  "error": "Model file not found or corrupted"
}
```

### Handling in curl:
```bash
# Check HTTP status code
curl -w "\nHTTP Status: %{http_code}\n" \
  -X POST -F "image=@test.jpg" -F "model=yolov11n-12class" \
  http://localhost:8000/api/classify/
```

---

## 📞 Support

- **GitHub:** https://github.com/thehamzaihsan/eco-pro
- **Website:** http://edopro.hamzaihsan.me
- **API Base URL:** http://localhost:8000 (local) or https://ecopro.hamzaihsan.me (production)

---

## 🎯 Quick Reference

```bash
# List models
curl http://localhost:8000/api/models/

# Default model (12 classes)
curl -X POST -F "image=@img.jpg" http://localhost:8000/api/classify/

# Specific model
curl -X POST -F "image=@img.jpg" -F "model=yolov11m-3class" http://localhost:8000/api/classify/
```

---

**Last Updated:** December 2024  
**API Version:** 1.0
