# Coolify Quick Start - Deploy in 5 Minutes

## 🚀 Super Quick Deployment

Your Docker files are **already ready**! Just follow these steps:

---

## 📋 Step-by-Step

### **1. Login to Coolify**
Go to your Coolify dashboard

### **2. Create New Application**
- Click **+ New Resource** → **Application**
- Select **Public Repository**
- URL: `https://github.com/thehamzaihsan/eco-pro`
- Branch: `main`

### **3. Configure Docker**
- **Build Pack:** Dockerfile
- **Dockerfile Path:** `eco-backend/Dockerfile`
- **Docker Context:** `eco-backend`
- **Port:** `8000`

### **4. Add Environment Variables**
```env
SECRET_KEY=your-random-secret-key-here
DEBUG=False
ALLOWED_HOSTS=.coolify.app,your-domain.com
```

Generate SECRET_KEY:
```bash
python -c "import secrets; print(secrets.token_urlsafe(50))"
```

### **5. Deploy**
Click **Deploy** button and wait 10-15 minutes

---

## ✅ That's It!

Your API will be available at:
```
https://your-app-name.coolify.app/api/models/
```

---

## 🧪 Test It

```bash
# List models
curl https://your-app.coolify.app/api/models/

# Classify image
curl -X POST \
  -F "image=@test.jpg" \
  -F "model=yolov11n-12class" \
  https://your-app.coolify.app/api/classify/
```

---

## 🔧 Configuration Summary

**What Coolify uses:**
- ✅ `eco-backend/Dockerfile` (already exists)
- ✅ `eco-backend/requirements.txt` (already exists)
- ✅ `eco-backend/manage.py` (Django)
- ✅ Model files: `*.pt` (included)

**No changes needed to your code!** 🎉

---

## 🌐 Custom Domain (Optional)

1. In Coolify → **Domains** → Add `api.yourdomain.com`
2. Update DNS:
   ```
   Type: CNAME
   Name: api
   Value: your-coolify-instance.com
   ```
3. Coolify auto-enables SSL ✅

---

## 📊 Resources Needed

| Resource | Recommended |
|----------|-------------|
| Memory | 4 GB |
| CPU | 2 cores |
| Disk | 10 GB |
| Port | 8000 |

Set in Coolify → Application → **Resources**

---

## 🔄 Auto-Deploy

Enable in Coolify → **Automatic Deployment**

Now every push to GitHub auto-deploys! 🚀

---

## 🆘 Troubleshooting

### Build fails?
- Check **Docker Context** is `eco-backend`
- Verify **Dockerfile Path** is `eco-backend/Dockerfile`

### App crashes?
- Check environment variables are set
- Verify `SECRET_KEY` is configured
- Check logs in Coolify dashboard

### Slow?
- Increase memory to 4GB
- Increase CPU to 2 cores

---

## 📚 Full Guide

See **COOLIFY_DEPLOY.md** for:
- Detailed configuration
- PostgreSQL setup
- Advanced options
- Monitoring
- Troubleshooting

---

## 🎯 Quick Reference

```yaml
Project: eco-backend
Repo: https://github.com/thehamzaihsan/eco-pro
Branch: main
Type: Dockerfile
Context: eco-backend
Dockerfile: eco-backend/Dockerfile
Port: 8000
```

---

**Time to deploy: 10-15 minutes**  
**Your files: Already ready!** ✅  
**Next step: Click Deploy!** 🚀
