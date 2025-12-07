# Custom Domain Setup for ecopro.hamzaihsan.me

## 🌐 DNS Configuration

To make your backend work on `https://ecopro.hamzaihsan.me/`, you need to:

### Option 1: Backend on Subdomain (Recommended)

**Setup:**
1. Create a CNAME record in your DNS:
   - **Name:** `api.ecopro` or `backend.ecopro`
   - **Value:** `your-app.onrender.com`

2. In Render Dashboard:
   - Go to your web service → Settings
   - Add Custom Domain: `api.ecopro.hamzaihsan.me`
   - Render will provide SSL certificate automatically

3. Update environment variables:
   ```
   ALLOWED_HOSTS=api.ecopro.hamzaihsan.me,your-app.onrender.com
   CORS_ALLOWED_ORIGINS=https://ecopro.hamzaihsan.me
   ```

4. Frontend calls:
   ```javascript
   fetch('https://api.ecopro.hamzaihsan.me/api/classify/', {
       method: 'POST',
       body: formData
   })
   ```

### Option 2: Backend on Path (Reverse Proxy Required)

**Setup:**
If you want `https://ecopro.hamzaihsan.me/api/` to serve the backend:

1. Host your frontend on `ecopro.hamzaihsan.me`
2. Configure a reverse proxy (nginx/Apache) to forward `/api/*` to Render:
   ```nginx
   location /api/ {
       proxy_pass https://your-app.onrender.com/api/;
       proxy_set_header Host $host;
       proxy_set_header X-Real-IP $remote_addr;
   }
   ```

3. Update CORS settings:
   ```
   CORS_ALLOWED_ORIGINS=https://ecopro.hamzaihsan.me
   ALLOWED_HOSTS=ecopro.hamzaihsan.me
   ```

## ✅ Current Configuration

Your backend is already configured to accept requests from:

**Allowed Hosts:**
- `localhost` / `127.0.0.1` (local development)
- `ecopro.hamzaihsan.me` (your custom domain)
- `*.onrender.com` (Render subdomains)

**CORS Origins:**
- `https://ecopro.hamzaihsan.me` ✅
- `http://ecopro.hamzaihsan.me` ✅
- Local development URLs

## 🧪 Testing

Once deployed, test your API:

```bash
# Test from command line
curl -X POST https://your-backend-url/api/classify/ \
  -F "image=@test_image.jpg"

# Test CORS
curl -X OPTIONS \
  -H "Origin: https://ecopro.hamzaihsan.me" \
  -H "Access-Control-Request-Method: POST" \
  -I https://your-backend-url/api/classify/
```

Expected response headers:
```
access-control-allow-origin: https://ecopro.hamzaihsan.me
access-control-allow-credentials: true
access-control-allow-methods: DELETE, GET, OPTIONS, PATCH, POST, PUT
```

## 🔒 Security Notes

- ✅ HTTPS enforced in production (DEBUG=False)
- ✅ CORS restricted to your domain
- ✅ Secure cookies enabled
- ✅ HSTS headers configured
- ⚠️  Set strong SECRET_KEY in production
- ⚠️  Remove `'*'` from ALLOWED_HOSTS in production

## 📝 Production Checklist

Before going live:

- [ ] Set `DEBUG=False` in Render environment variables
- [ ] Generate and set strong `SECRET_KEY`
- [ ] Configure custom domain in Render
- [ ] Update DNS records
- [ ] Set `ALLOWED_HOSTS=ecopro.hamzaihsan.me,your-render-app.onrender.com`
- [ ] Set `CORS_ALLOWED_ORIGINS=https://ecopro.hamzaihsan.me`
- [ ] Test API endpoints from your frontend
- [ ] Verify HTTPS is working
- [ ] Test CORS from browser console
