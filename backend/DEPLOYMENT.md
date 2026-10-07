# Deployment Guide - DigitalOcean

## Prerequisites

- DigitalOcean account
- Backend code running locally
- MongoDB Atlas account with database
- Domain name (optional but recommended)

## Step 1: Create DigitalOcean Droplet

1. Go to https://www.digitalocean.com
2. Sign up or login
3. Click "Create" → "Droplets"
4. Choose:
   - **Image**: Ubuntu 22.04 LTS
   - **Plan**: Basic $6/month (Droplet)
   - **Region**: Closest to your location (Bangkok for Thailand)
   - **Auth**: SSH Keys (recommended)
   - **Hostname**: rn-archangel-works-api

5. Click "Create Droplet"

## Step 2: Connect to Droplet via SSH

```bash
ssh root@your_droplet_ip
```

## Step 3: Initial Server Setup

```bash
# Update system
apt update && apt upgrade -y

# Install Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
apt install -y nodejs

# Install PM2 (process manager)
npm install -g pm2

# Install Git
apt install -y git

# Install Nginx (reverse proxy)
apt install -y nginx
```

## Step 4: Clone Repository

```bash
# Navigate to home directory
cd /home

# Clone repository
git clone https://github.com/mcsats383/rn-archangel-works.git
cd rn-archangel-works/backend

# Install dependencies
npm install --production
```

## Step 5: Setup Environment Variables

```bash
# Copy example env file
cp .env.example .env

# Edit with your values
nano .env
```

Make sure to set:
- `NODE_ENV=production`
- `MONGODB_URI=your_mongodb_atlas_connection_string`
- `JWT_SECRET=your_secure_secret_key`
- `CLIENT_URL=http://your_domain.com`

## Step 6: Start Application with PM2

```bash
# Start app
pm2 start server.js --name "rn-api"

# Save PM2 process list
pm2 save

# Setup startup on reboot
pm2 startup
```

## Step 7: Setup Nginx Reverse Proxy

```bash
# Create Nginx config
sudo nano /etc/nginx/sites-available/rn-api
```

Add this content:

```nginx
server {
    listen 80;
    server_name your_domain.com;

    location / {
        proxy_pass http://localhost:5000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

```bash
# Enable site
sudo ln -s /etc/nginx/sites-available/rn-api /etc/nginx/sites-enabled/

# Test Nginx config
sudo nginx -t

# Restart Nginx
sudo systemctl restart nginx
```

## Step 8: Setup SSL Certificate (Let's Encrypt)

```bash
# Install Certbot
apt install -y certbot python3-certbot-nginx

# Get SSL certificate
sudo certbot --nginx -d your_domain.com

# Auto renew certificate
sudo certbot renew --dry-run
```

## Step 9: Configure Firewall

```bash
# Enable UFW
ufw enable

# Allow SSH
ufw allow 22

# Allow HTTP
ufw allow 80

# Allow HTTPS
ufw allow 443
```

## Step 10: Verify Deployment

```bash
# Check PM2 status
pm2 status

# Check logs
pm2 logs rn-api

# Test API
curl http://your_domain.com/api
```

## Monitoring & Maintenance

### Check Logs

```bash
# View last 100 lines
pm2 logs rn-api --lines 100

# Real-time logs
pm2 logs rn-api
```

### Restart Application

```bash
pm2 restart rn-api
```

### View Memory Usage

```bash
pm2 monit
```

### Update Code

```bash
cd /home/rn-archangel-works/backend
git pull origin main
npm install
pm2 restart rn-api
```

## Backup Database

```bash
# MongoDB Atlas automatic backups are enabled by default
# No additional setup needed
# Backups available in Atlas dashboard
```

## Security Checklist

- [ ] Change root password
- [ ] Setup SSH keys
- [ ] Enable UFW firewall
- [ ] Install SSL certificate
- [ ] Set strong JWT_SECRET
- [ ] Regular database backups
- [ ] Monitor logs regularly
- [ ] Update system regularly

## Troubleshooting

### App not running

```bash
pm2 logs rn-api
```

Check error messages and ensure:
- MongoDB connection is working
- All environment variables are set
- Node modules are installed

### Connection refused

Make sure PM2 process is running:

```bash
pm2 status
pm2 start server.js --name "rn-api"
```

### Nginx 502 Bad Gateway

Check if Node app is running:

```bash
pm2 status
curl http://localhost:5000/
```

## Support

For deployment issues:
1. Check PM2 logs: `pm2 logs rn-api`
2. Check Nginx logs: `sudo tail -f /var/log/nginx/error.log`
3. Test MongoDB connection in .env
