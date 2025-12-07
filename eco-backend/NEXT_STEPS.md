# 🎯 Next Steps - Deploy to ecopro.hamzaihsan.me

## 📝 Quick Start (5 Minutes)

### Step 1: Push to GitHub
```bash
git add .
git commit -m "Configure backend for ecopro.hamzaihsan.me"
git push origin main
```

### Step 2: Deploy to Render

1. **Go to:** https://dashboard.render.com
2. **Click:** "New +" → "Web Service"
3. **Select:** Your GitHub repository
4. **Configure:**
   - Name: `eco-pro-backend`
   - Root Directory: `eco-backend`
   - Build Command: `./build.sh`
   - Start Command: `gunicorn config.wsgi:application --bind 0.0.0.0:$PORT`

5. **Add Environment Variables:**
   ```
   DEBUG=False
   SECRET_KEY=<generate-one>
   ALLOWED_HOSTS=ecopro.hamzaihsan.me,eco-pro-backend.onrender.com
   CORS_ALLOWED_ORIGINS=https://ecopro.hamzaihsan.me
   ```

6. **Generate SECRET_KEY:**
   ```bash
   python -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())'
   ```

7. **Click:** "Create Web Service"

### Step 3: Configure Custom Domain (Choose One)

#### Option A: Use Subdomain (Easiest)
**Your API will be:** `https://api.ecopro.hamzaihsan.me/api/classify/`

1. **DNS Settings** (in your domain registrar):
   - Type: `CNAME`
   - Name: `api.ecopro` or `backend.ecopro`
   - Value: `eco-pro-backend.onrender.com`
   - TTL: `3600`

2. **In Render Dashboard:**
   - Go to your service → Settings → Custom Domains
   - Add: `api.ecopro.hamzaihsan.me`
   - Wait for SSL certificate (automatic)

3. **Update Environment Variable:**
   ```
   ALLOWED_HOSTS=api.ecopro.hamzaihsan.me,eco-pro-backend.onrender.com
   ```

4. **Frontend Code:**
   ```javascript
   const API_URL = 'https://api.ecopro.hamzaihsan.me/api/classify/';
   ```

#### Option B: Use Main Domain with Proxy
**Your API will be:** `https://ecopro.hamzaihsan.me/api/classify/`

1. **Host frontend on ecopro.hamzaihsan.me**
2. **Configure nginx proxy** (on your server):
   ```nginx
   location /api/ {
       proxy_pass https://eco-pro-backend.onrender.com/api/;
       proxy_set_header Host $host;
   }
   ```
3. **Frontend uses same domain:** `/api/classify/`

## ✅ Verification

Once deployed, test:

```bash
# Test API endpoint
curl https://your-backend-url/api/classify/

# Test CORS
curl -X OPTIONS \
  -H "Origin: https://ecopro.hamzaihsan.me" \
  -H "Access-Control-Request-Method: POST" \
  -I https://your-backend-url/api/classify/
```

## 🎉 You're Done!

Your backend will work with:
- ✅ `https://ecopro.hamzaihsan.me` (CORS enabled)
- ✅ HTTPS enforced
- ✅ Production-ready security
- ✅ Classification model working
- ✅ Static files served

## 📚 Need More Details?

- **Render Guide:** See `RENDER_DEPLOY.md`
- **Custom Domain:** See `CUSTOM_DOMAIN.md`
- **Full Summary:** See `DEPLOYMENT_SUMMARY.md`
