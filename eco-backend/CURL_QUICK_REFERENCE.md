# Quick Reference - Using Different Models via curl

## 🚀 One-Line Commands

### List Available Models
```bash
curl http://localhost:8000/api/models/
```

### Use Default Model (12 classes)
```bash
curl -X POST -F "image=@test_image.jpg" http://localhost:8000/api/classify/
```

### Use YOLOv11m (3 classes - Fast)
```bash
curl -X POST -F "image=@test_image.jpg" -F "model=yolov11m-3class" http://localhost:8000/api/classify/
```

### Use YOLOv11n (12 classes - Detailed)
```bash
curl -X POST -F "image=@test_image.jpg" -F "model=yolov11n-12class" http://localhost:8000/api/classify/
```

### Use YOLOv8n (3 classes - Legacy)
```bash
curl -X POST -F "image=@test_image.jpg" -F "model=yolov8n-3class" http://localhost:8000/api/classify/
```

---

## 🪟 Windows Commands

### Command Prompt
```cmd
REM List models
curl http://localhost:8000/api/models/

REM Classify with specific model
curl -X POST -F "image=@test_image.jpg" -F "model=yolov11n-12class" http://localhost:8000/api/classify/
```

### PowerShell
```powershell
# List models
Invoke-RestMethod -Uri "http://localhost:8000/api/models/" -Method Get

# Classify with specific model
$form = @{
    image = Get-Item -Path "test_image.jpg"
    model = "yolov11n-12class"
}
Invoke-RestMethod -Uri "http://localhost:8000/api/classify/" -Method Post -Form $form
```

---

## 🧪 Test All Models

### Linux/Mac/Git Bash
```bash
./test_all_models.sh test_image.jpg
```

### Windows Command Prompt
```cmd
test_all_models.bat test_image.jpg
```

### Windows PowerShell
```powershell
.\test_all_models.ps1 -Image "test_image.jpg"
```

---

## 📊 Available Models

| Model Key | Classes | Speed | Best For |
|-----------|---------|-------|----------|
| `yolov11m-3class` | 3 | Fast | Quick sorting |
| `yolov11n-12class` | 12 | Medium | **Default** - Best accuracy |
| `yolov8n-3class` | 3 | Fast | Legacy support |

---

## 🌐 Remote Server

Replace `localhost:8000` with your server:

```bash
# Production server
curl -X POST \
  -F "image=@test_image.jpg" \
  -F "model=yolov11n-12class" \
  https://ecopro.hamzaihsan.me/api/classify/
```

---

## 📝 Save Response to File

```bash
# Linux/Mac
curl -X POST -F "image=@test.jpg" -F "model=yolov11n-12class" \
  http://localhost:8000/api/classify/ > result.json

# Windows
curl -X POST -F "image=@test.jpg" -F "model=yolov11n-12class" http://localhost:8000/api/classify/ -o result.json
```

---

## 🔍 Pretty Print JSON

### With jq (Linux/Mac)
```bash
curl -s -X POST -F "image=@test.jpg" -F "model=yolov11n-12class" \
  http://localhost:8000/api/classify/ | jq
```

### With Python (All Platforms)
```bash
curl -s -X POST -F "image=@test.jpg" -F "model=yolov11n-12class" \
  http://localhost:8000/api/classify/ | python -m json.tool
```

### PowerShell
```powershell
Invoke-RestMethod -Uri "http://localhost:8000/api/classify/" -Method Post -Form $form | ConvertTo-Json -Depth 10
```

---

## 🎯 Quick Tips

✅ Default model is `yolov11n-12class` (most accurate)  
✅ Omit `model` parameter to use default  
✅ Use 3-class models for faster processing  
✅ Use 12-class model for detailed classification  
✅ Check `/api/models/` endpoint for available models  

---

## 📚 Full Documentation

See **API_MODELS_GUIDE.md** for:
- Complete API documentation
- Error handling
- Programming language examples (Python, Node.js, React)
- Model comparison
- Best practices

---

## 📞 Support

- **Full Guide:** API_MODELS_GUIDE.md
- **GitHub:** https://github.com/thehamzaihsan/eco-pro
- **Website:** http://edopro.hamzaihsan.me
