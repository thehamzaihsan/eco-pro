# Deploy EcoSort Backend to Coolify

## 🚀 Quick Coolify Deployment Guide

Coolify is a self-hosted alternative to Heroku/Vercel. Here's how to deploy your Docker-based backend.

---

## 📋 Prerequisites

- ✅ Coolify instance running (self-hosted or cloud)
- ✅ Your GitHub repository: https://github.com/thehamzaihsan/eco-pro
- ✅ Docker files already created (we have them!)

---

## 🎯 Step-by-Step Deployment

### **Step 1: Login to Coolify**

1. Access your Coolify dashboard
2. Navigate to **Projects**

---

### **Step 2: Create New Project**

1. Click **+ New Project**
2. Give it a name: `EcoSort` or `eco-backend`
3. Click **Continue**

---

### **Step 3: Add GitHub Repository**

1. Click **+ New Resource**
2. Select **Application**
3. Choose **Public Repository** or **GitHub App** (if connected)
4. Enter repository URL:
   ```
   https://github.com/thehamzaihsan/eco-pro
   ```
5. Select branch: `main` (or your default branch)

---

### **Step 4: Configure Application**

#### **General Settings:**
- **Name:** `eco-backend`
- **Type:** Docker Compose
- **Build Pack:** Dockerfile

#### **Docker Configuration:**
- **Dockerfile Location:** `eco-backend/Dockerfile`
- **Docker Context:** `eco-backend`
- **Port:** `8000`

---

### **Step 5: Set Environment Variables**

Add these environment variables in Coolify:

```env
SECRET_KEY=generate-a-strong-random-key-here
DEBUG=False
ALLOWED_HOSTS=your-domain.com,.coolify.app
CORS_ALLOWED_ORIGINS=https://your-frontend.com
```

**Generate SECRET_KEY:**
```bash
python -c "import secrets; print(secrets.token_urlsafe(50))"
```

---

### **Step 6: Configure Build Settings**

#### **If using Dockerfile (Recommended):**

**Build Command:** (Leave empty - uses Dockerfile)

**Dockerfile Path:** 
```
eco-backend/Dockerfile
```

**Docker Build Context:**
```
eco-backend
```

**Port Mapping:**
- Internal: `8000`
- External: `80` or `443` (Coolify handles this)

---

#### **If using docker-compose.yml:**

**docker-compose.yml location:**
```
eco-backend/docker-compose.yml
```

Update your `docker-compose.yml` to use environment variables:

```yaml
version: '3.8'

services:
  web:
    build: .
    ports:
      - "8000:8000"
    environment:
      - DEBUG=${DEBUG:-False}
      - SECRET_KEY=${SECRET_KEY}
      - ALLOWED_HOSTS=${ALLOWED_HOSTS}
      - CORS_ALLOWED_ORIGINS=${CORS_ALLOWED_ORIGINS}
    restart: unless-stopped
```

---

### **Step 7: Deploy!**

1. Click **Save**
2. Click **Deploy**
3. Watch the build logs
4. Wait for deployment to complete (5-15 minutes first time)

---

## 🌐 Accessing Your Deployment

After deployment, Coolify will give you a URL like:
```
https://eco-backend-xyz.coolify.app
```

Or use your custom domain (see Domain Configuration below).

---

## 🔧 Configuration Files for Coolify

### **Option 1: Using Existing Dockerfile (Recommended)**

Already created! Located at: `eco-backend/Dockerfile`

No changes needed! ✅

---

### **Option 2: Create Coolify-Specific Configuration**

Create `eco-backend/.coolify.yml`:

```yaml
# Coolify Configuration
version: "1.0"

deployment:
  type: dockerfile
  dockerfile: ./Dockerfile
  context: .
  port: 8000

environment:
  - DEBUG=False
  - ALLOWED_HOSTS=${COOLIFY_URL}

healthcheck:
  enabled: true
  path: /api/models/
  port: 8000
  interval: 30s
  timeout: 10s
  retries: 3

resources:
  memory: 2048M
  cpu: 1
```

---

## 🗂️ File Structure for Coolify

Your repository structure is already perfect:

```
eco-pro/
├── eco-backend/              ← Root for Coolify
│   ├── Dockerfile            ✅ Already exists
│   ├── docker-compose.yml    ✅ Already exists
│   ├── requirements.txt      ✅ Required
│   ├── manage.py             ✅ Django entry point
│   ├── config/               ✅ Django settings
│   ├── classifier/           ✅ Your app
│   └── *.pt                  ✅ YOLO models
```

---

## 🔐 Environment Variables Reference

| Variable | Value | Required | Example |
|----------|-------|----------|---------|
| `SECRET_KEY` | Random string | ✅ Yes | `abc123xyz...` |
| `DEBUG` | False | ✅ Yes | `False` |
| `ALLOWED_HOSTS` | Your domains | ✅ Yes | `.coolify.app,yourdomain.com` |
| `CORS_ALLOWED_ORIGINS` | Frontend URLs | ⚠️ If CORS needed | `https://frontend.com` |
| `DATABASE_URL` | PostgreSQL URL | ❌ Optional | `postgres://...` |

---

## 📊 Build Process

What happens during Coolify deployment:

1. ✅ Clone your GitHub repository
2. ✅ Navigate to `eco-backend` directory
3. ✅ Build Docker image using `Dockerfile`
4. ✅ Download dependencies (~1-2 GB for PyTorch, YOLO)
5. ✅ Copy YOLO model files (`.pt`)
6. ✅ Run `collectstatic`
7. ✅ Start Gunicorn server
8. ✅ Map port 8000 to public URL

**First deployment:** 10-15 minutes  
**Subsequent deployments:** 3-5 minutes (cached layers)

---

## 🌍 Custom Domain Configuration

### **Step 1: Add Domain in Coolify**

1. Go to your application settings
2. Click **Domains**
3. Add your domain: `api.yourdomain.com`

### **Step 2: Update DNS Records**

Add CNAME record at your DNS provider:

```
Type:  CNAME
Name:  api (or your subdomain)
Value: your-coolify-instance.com
```

### **Step 3: Update ALLOWED_HOSTS**

Add your domain to environment variables:
```env
ALLOWED_HOSTS=api.yourdomain.com,.coolify.app
```

### **Step 4: Enable SSL**

Coolify automatically provisions SSL certificates via Let's Encrypt.

Just enable **Force HTTPS** in domain settings.

---

## 🔄 Automatic Deployments

### **Enable GitHub Webhooks:**

1. Go to application settings
2. Enable **Automatic Deployment**
3. Choose trigger:
   - On **Push** to main branch
   - On **Pull Request** merge
   - Manual only

Coolify will auto-deploy when you push to GitHub! 🎉

---

## 🧪 Testing Your Deployment

### **1. Check Health:**
```bash
curl https://your-app.coolify.app/api/models/
```

### **2. Test Classification:**
```bash
curl -X POST \
  -F "image=@test.jpg" \
  -F "model=yolov11n-12class" \
  https://your-app.coolify.app/api/classify/
```

### **3. Check Logs:**
In Coolify dashboard → Your App → **Logs**

---

## 📈 Resource Configuration

### **Recommended Settings:**

| Resource | Minimum | Recommended | Notes |
|----------|---------|-------------|-------|
| **Memory** | 2 GB | 4 GB | YOLO models need RAM |
| **CPU** | 1 core | 2 cores | Better inference speed |
| **Disk** | 5 GB | 10 GB | Model files + dependencies |
| **Port** | 8000 | 8000 | Default Django/Gunicorn |

### **Configure in Coolify:**

1. Application Settings → **Resources**
2. Set Memory Limit: `4096M`
3. Set CPU Limit: `2`
4. Set Disk Limit: `10G`

---

## 🔍 Troubleshooting

### **Build Fails - "No such file or directory"**

**Issue:** Coolify can't find Dockerfile

**Solution:**
- Set **Docker Context** to `eco-backend`
- Set **Dockerfile Path** to `eco-backend/Dockerfile`

---

### **Build Fails - "Model file not found"**

**Issue:** `.pt` files not included

**Solution:**
- Check `.dockerignore` allows `.pt` files
- Ensure model files are committed to Git
- File: `yoloMODEL_new_medium.pt` exists in `eco-backend/`

---

### **Application Crashes - "Internal Server Error"**

**Issue:** Missing environment variables

**Solution:**
- Check all required env vars are set
- Verify `SECRET_KEY` is set
- Check `ALLOWED_HOSTS` includes Coolify URL

---

### **Slow Performance**

**Issue:** Not enough resources

**Solution:**
- Increase memory to 4GB
- Increase CPU cores to 2
- Enable HTTP/2 in Coolify
- Use CDN for static files

---

## 🎛️ Advanced Configuration

### **Using PostgreSQL (Optional):**

1. Add PostgreSQL service in Coolify
2. Get database URL
3. Add to environment:
   ```env
   DATABASE_URL=postgresql://user:pass@host:5432/dbname
   ```

4. Update `requirements.txt`:
   ```
   psycopg2-binary>=2.9.0
   ```

### **Redis for Caching (Optional):**

1. Add Redis service
2. Get Redis URL
3. Add to environment:
   ```env
   REDIS_URL=redis://host:6379/0
   ```

---

## 📊 Monitoring & Logs

### **View Logs:**
```
Coolify Dashboard → Your App → Logs
```

### **Monitor Resources:**
```
Coolify Dashboard → Your App → Metrics
```

### **Set Up Alerts:**
- CPU usage > 80%
- Memory usage > 90%
- Application down

---

## 🚦 Deployment Checklist

Before deploying:

- [ ] GitHub repository accessible
- [ ] Dockerfile exists in `eco-backend/`
- [ ] Model files (`.pt`) committed to repo
- [ ] `requirements.txt` is complete
- [ ] Environment variables ready
- [ ] Custom domain configured (optional)
- [ ] SSL certificate auto-enabled

After deploying:

- [ ] Application is accessible
- [ ] `/api/models/` endpoint works
- [ ] `/api/classify/` endpoint works
- [ ] Logs show no errors
- [ ] Custom domain works (if configured)
- [ ] Auto-deploy enabled (optional)

---

## 📝 Quick Deploy Steps (TL;DR)

1. **Login to Coolify**
2. **Create Project** → Name: `eco-backend`
3. **Add GitHub Repo:** `https://github.com/thehamzaihsan/eco-pro`
4. **Set Docker Context:** `eco-backend`
5. **Set Dockerfile:** `eco-backend/Dockerfile`
6. **Add Environment Variables:**
   ```
   SECRET_KEY=your-secret
   DEBUG=False
   ALLOWED_HOSTS=.coolify.app
   ```
7. **Deploy!** 🚀

---

## 🆚 Coolify vs Other Platforms

| Feature | Coolify | Render | Vercel | AWS |
|---------|---------|--------|--------|-----|
| **Cost** | Self-hosted (Free) | $7/mo | $0 (hobby) | $15-50/mo |
| **Docker Support** | ✅ Native | ✅ Yes | ❌ No | ✅ Yes |
| **Self-Hosted** | ✅ Yes | ❌ No | ❌ No | ❌ No |
| **Auto-Deploy** | ✅ Yes | ✅ Yes | ✅ Yes | ⚠️ Complex |
| **SSL** | ✅ Free | ✅ Free | ✅ Free | 💰 Paid |
| **Database** | ✅ Included | 💰 Paid | ❌ No | 💰 Paid |

---

## 🔗 Useful Links

- **Coolify Docs:** https://coolify.io/docs
- **Your GitHub:** https://github.com/thehamzaihsan/eco-pro
- **Django Deployment:** https://docs.djangoproject.com/en/stable/howto/deployment/
- **Docker Best Practices:** https://docs.docker.com/develop/dev-best-practices/

---

## 📞 Support

- **Coolify Issues:** https://github.com/coollabsio/coolify/issues
- **Your Project:** https://github.com/thehamzaihsan/eco-pro
- **Documentation:** See `DOCKER_DEPLOYMENT.md` for other platforms

---

## 🎉 Summary

**What you need:**
1. Coolify instance
2. GitHub repository
3. Environment variables
4. Click Deploy

**What Coolify does:**
1. Clones your repo
2. Builds Docker image
3. Starts your application
4. Provides public URL
5. Auto-renews SSL

**Time to deploy:** 10-15 minutes

**Your files are already ready!** ✅

---

**Last Updated:** December 2024  
**Status:** Production Ready for Coolify 🚀
