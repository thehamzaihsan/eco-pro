# Backend Server Scripts - Complete Guide

## 📁 All Available Scripts

### Windows Scripts (.bat)
- ✅ **setup.bat** - One-time setup (installs everything)
- ✅ **start_server.bat** - Start development server
- ✅ **start_production.bat** - Start production server with Waitress

### Linux/Mac Scripts (.sh)
- ✅ **setup.sh** - One-time setup (installs everything)
- ✅ **start_server.sh** - Start development server

### Docker Files
- ✅ **Dockerfile** - Container definition
- ✅ **docker-compose.yml** - Easy container orchestration
- ✅ **.dockerignore** - Build optimization

### Documentation
- ✅ **WINDOWS_SETUP.md** - Complete Windows guide
- ✅ **WINDOWS_COMMANDS.md** - Quick command reference
- ✅ **DOCKER_DEPLOYMENT.md** - Full Docker deployment guide
- ✅ **DOCKER_QUICK_START.md** - Docker quick reference
- ✅ **PLATFORM_GUIDE.md** - Cross-platform comparison
- ✅ **README_SCRIPTS.md** - This file

---

## 🚀 Quick Start by Platform

### Windows Users (Command Prompt/PowerShell)

```cmd
REM 1. First time setup
cd C:\path\to\eco-pro\eco-backend
setup.bat

REM 2. Start server
start_server.bat

REM 3. Access server
REM Open browser: http://localhost:8000
```

### Linux/Mac Users (Terminal)

```bash
# 1. First time setup
cd /path/to/eco-pro/eco-backend
chmod +x setup.sh start_server.sh
./setup.sh

# 2. Start server
./start_server.sh

# 3. Access server
# Open browser: http://localhost:8000
```

### Docker Users (Any Platform)

```bash
# 1. Build and start
cd /path/to/eco-pro/eco-backend
docker-compose up -d

# 2. View logs
docker-compose logs -f

# 3. Stop
docker-compose down
```

---

## 📖 What Each Script Does

### setup.bat / setup.sh
**Purpose:** Complete initial setup

**What it does:**
1. Creates Python virtual environment (.venv)
2. Activates virtual environment
3. Installs all Python dependencies from requirements.txt
   - Django
   - Django REST Framework
   - Ultralytics YOLO
   - PyTorch
   - OpenCV
   - And more...
4. Runs database migrations
5. Creates database (db.sqlite3)

**When to run:** Once, before first use

**Time:** 5-15 minutes (depends on internet speed)

---

### start_server.bat / start_server.sh
**Purpose:** Start Django development server

**What it does:**
1. Checks if virtual environment exists
2. Activates virtual environment
3. Starts Django server on port 8000
4. Enables auto-reload on code changes

**When to run:** Every time you want to run the server

**Features:**
- Auto-reload on file changes
- Detailed error messages
- Development-friendly
- NOT for production use

---

### start_production.bat (Windows only)
**Purpose:** Start production-ready server

**What it does:**
1. Activates virtual environment
2. Collects static files
3. Installs Waitress (if not installed)
4. Starts Waitress WSGI server
5. Runs on port 8000

**When to run:** Production deployment on Windows

**Why Waitress:**
- Gunicorn doesn't work on Windows
- Waitress is production-quality alternative
- Better performance than dev server
- Handles multiple concurrent requests

---

## 🔍 Detailed Comparison

| Feature | Development (start_server) | Production (start_production) | Docker |
|---------|---------------------------|------------------------------|--------|
| **Auto-reload** | ✅ Yes | ❌ No | ❌ No |
| **Performance** | Medium | High | High |
| **Concurrency** | Low | High | High |
| **Static Files** | Debug mode | Collected | Collected |
| **Use Case** | Development | Production | Both |
| **Multi-threading** | ❌ | ✅ | ✅ |
| **Error Detail** | Verbose | Minimal | Configurable |

---

## 🛠️ Troubleshooting

### Windows: "Python not recognized"

**Problem:** Python not in PATH

**Solution:**
1. Reinstall Python from python.org
2. Check "Add Python to PATH" during installation

Or manually:
1. Find Python install path (e.g., C:\Python311)
2. Add to System PATH environment variable

---

### Windows: "Cannot activate virtual environment"

**Problem:** PowerShell execution policy

**Solution:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

---

### Linux/Mac: "Permission denied"

**Problem:** Scripts not executable

**Solution:**
```bash
chmod +x setup.sh start_server.sh
./setup.sh
```

---

### All Platforms: "Port 8000 already in use"

**Windows:**
```cmd
netstat -ano | findstr :8000
taskkill /PID <PID> /F
```

**Linux/Mac:**
```bash
lsof -i :8000
kill -9 <PID>
```

**Or use different port:**
```bash
python manage.py runserver 8080
```

---

### All Platforms: "Module not found"

**Problem:** Dependencies not installed

**Solution:**
```bash
# Activate virtual environment first
# Windows:
.venv\Scripts\activate

# Linux/Mac:
source .venv/bin/activate

# Then install:
pip install -r requirements.txt
```

---

## 🧪 Testing the Server

### Option 1: Browser
1. Open browser
2. Go to http://localhost:8000/admin/
3. Should see Django admin page

### Option 2: Python Test Script
```bash
# Activate venv first
python test_api.py test_image.jpg
```

### Option 3: curl
```bash
curl -X POST -F "image=@test_image.jpg" http://localhost:8000/api/classify/
```

### Option 4: PowerShell (Windows)
```powershell
$response = Invoke-WebRequest -Uri "http://localhost:8000/api/classify/" -Method POST -InFile "test_image.jpg"
$response.Content
```

---

## 🌍 Environment Variables

### Setting Variables

**Windows (Temporary - Current Session):**
```cmd
set DEBUG=False
set SECRET_KEY=your-secret-key
set ALLOWED_HOSTS=localhost,127.0.0.1
```

**Windows (Permanent):**
```cmd
setx DEBUG "False"
setx SECRET_KEY "your-secret-key"
```

**Linux/Mac (Temporary):**
```bash
export DEBUG=False
export SECRET_KEY=your-secret-key
export ALLOWED_HOSTS=localhost,127.0.0.1
```

**Linux/Mac (Permanent):**
Add to `~/.bashrc` or `~/.zshrc`:
```bash
export DEBUG=False
export SECRET_KEY=your-secret-key
```

**Docker:**
Edit `docker-compose.yml`:
```yaml
environment:
  - DEBUG=False
  - SECRET_KEY=your-secret-key
```

### Required Variables for Production
- `SECRET_KEY` - Django secret key (generate random string)
- `DEBUG` - Set to False
- `ALLOWED_HOSTS` - Your domain names

---

## 📚 Related Documentation

| Document | Purpose | When to Read |
|----------|---------|-------------|
| **WINDOWS_SETUP.md** | Windows detailed guide | Windows users - first time |
| **WINDOWS_COMMANDS.md** | Quick command reference | Windows users - regular use |
| **DOCKER_DEPLOYMENT.md** | Complete Docker guide | Docker deployment |
| **DOCKER_QUICK_START.md** | Docker quick reference | Docker quick start |
| **PLATFORM_GUIDE.md** | Cross-platform comparison | Choosing platform |
| **README_SCRIPTS.md** | This file | Understanding scripts |

---

## 💡 Best Practices

1. **Always use virtual environment** - Keeps dependencies isolated
2. **Use development server for development** - Auto-reload is helpful
3. **Use production server for production** - Better performance
4. **Never commit .env files** - Contains secrets
5. **Keep requirements.txt updated** - Document dependencies
6. **Use Docker for deployment** - Consistency across environments
7. **Read error messages** - They usually tell you what's wrong
8. **Check logs** - Server logs show what's happening

---

## 🎯 Common Workflows

### Starting Development (Windows)
```cmd
cd eco-backend
.venv\Scripts\activate
start_server.bat
REM Server runs at http://localhost:8000
```

### Starting Development (Linux/Mac)
```bash
cd eco-backend
source .venv/bin/activate
./start_server.sh
# Server runs at http://localhost:8000
```

### Adding New Dependency
```bash
# Activate venv
pip install new-package
pip freeze > requirements.txt
git add requirements.txt
git commit -m "Add new-package"
```

### Updating Dependencies
```bash
# Activate venv
pip install -r requirements.txt --upgrade
pip freeze > requirements.txt
```

### Resetting Database
```cmd
REM Windows
del db.sqlite3
python manage.py migrate
python manage.py createsuperuser

# Linux/Mac
rm db.sqlite3
python manage.py migrate
python manage.py createsuperuser
```

---

## 🚀 Deployment Checklist

### Before Deploying to Production:

- [ ] Set `DEBUG=False`
- [ ] Set strong `SECRET_KEY`
- [ ] Configure `ALLOWED_HOSTS`
- [ ] Collect static files
- [ ] Run migrations
- [ ] Test all endpoints
- [ ] Setup HTTPS/SSL
- [ ] Configure firewall
- [ ] Setup monitoring
- [ ] Backup database

### Deployment Options:
- ✅ Docker (recommended)
- ✅ Cloud platforms (Render, Fly.io, Railway)
- ✅ VPS with systemd/supervisor
- ✅ Windows Server with IIS + wfastcgi

---

## 📞 Support & Resources

- **GitHub:** https://github.com/thehamzaihsan/eco-pro
- **Website:** http://edopro.hamzaihsan.me
- **Django Docs:** https://docs.djangoproject.com/
- **YOLO Docs:** https://docs.ultralytics.com/

---

**Created:** December 2024  
**Last Updated:** December 11, 2024
