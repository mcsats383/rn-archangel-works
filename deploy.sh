#!/bin/bash

# DigitalOcean Production Deployment Script for Rn Archangel Works
# This script automates the complete deployment process
# Usage: ./deploy.sh your_domain.com

set -e

echo "================================================"
echo "Rn Archangel Works - DigitalOcean Deployment"
echo "================================================"
echo ""

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo "❌ This script must be run as root"
   exit 1
fi

# Variables
DOMAIN="${1:-your_domain.com}"
REPO_URL="https://github.com/mcsats383/rn-archangel-works.git"
APP_DIR="/home/rn-archangel-works"
APP_PORT=5000
NGINX_USER="www-data"

echo "📝 Configuration:"
echo "   Domain: $DOMAIN"
echo "   App Directory: $APP_DIR"
echo "   API Port: $APP_PORT"
echo ""

# Step 1: Update system
echo "🔄 Step 1/12: Updating system packages..."
apt update && apt upgrade -y > /dev/null 2>&1
echo "✅ System updated"

# Step 2: Install Node.js 18
echo "🔄 Step 2/12: Installing Node.js 18..."
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - > /dev/null 2>&1
apt install -y nodejs > /dev/null 2>&1
echo "✅ Node.js version: $(node -v)"

# Step 3: Install PM2
echo "🔄 Step 3/12: Installing PM2..."
npm install -g pm2 > /dev/null 2>&1
pm2 update > /dev/null 2>&1
echo "✅ PM2 installed"

# Step 4: Install Nginx
echo "🔄 Step 4/12: Installing Nginx..."
apt install -y nginx > /dev/null 2>&1
systemctl enable nginx > /dev/null 2>&1
echo "✅ Nginx installed"

# Step 5: Install Certbot for SSL
echo "🔄 Step 5/12: Installing Certbot..."
apt install -y certbot python3-certbot-nginx > /dev/null 2>&1
echo "✅ Certbot installed"

# Step 6: Clone repository
echo "🔄 Step 6/12: Cloning repository..."
if [ -d "$APP_DIR" ]; then
    echo "   Repository already exists, pulling latest..."
    cd $APP_DIR
    git pull origin main > /dev/null 2>&1
else
    git clone $REPO_URL $APP_DIR > /dev/null 2>&1
fi
echo "✅ Repository ready"

# Step 7: Install dependencies
echo "🔄 Step 7/12: Installing backend dependencies..."
cd $APP_DIR/backend
npm install --production > /dev/null 2>&1
echo "✅ Dependencies installed"

# Step 8: Setup environment
echo "🔄 Step 8/12: Setting up environment..."
if [ ! -f ".env" ]; then
    cp .env.example .env
    echo "⚠️  Created .env file - PLEASE UPDATE IT!"
    echo "   Location: $APP_DIR/backend/.env"
    echo "   Required: MONGODB_URI, JWT_SECRET"
else
    echo "✅ .env file already exists"
fi

# Step 9: Start application with PM2
echo "🔄 Step 9/12: Starting application with PM2..."
pm2 start server.js --name "rn-api" --instances max > /dev/null 2>&1
pm2 save > /dev/null 2>&1
pm2 startup > /dev/null 2>&1
echo "✅ Application started with PM2"

# Step 10: Setup Nginx reverse proxy
echo "🔄 Step 10/12: Configuring Nginx reverse proxy..."
cat > /etc/nginx/sites-available/rn-archangel-works << EOF
server {
    listen 80;
    server_name $DOMAIN www.$DOMAIN;

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;

    # API Proxy
    location /api {
        proxy_pass http://localhost:$APP_PORT;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }

    # Frontend
    location / {
        root /var/www/rn-archangel-works;
        try_files \$uri \$uri/ /index.html;
        expires 1d;
    }

    # Admin
    location /admin {
        root /var/www/rn-archangel-works;
        try_files \$uri \$uri/ /admin/index.html;
    }
}
EOF

# Enable site
ln -sf /etc/nginx/sites-available/rn-archangel-works /etc/nginx/sites-enabled/

# Test Nginx
nginx -t > /dev/null 2>&1
systemctl restart nginx > /dev/null 2>&1
echo "✅ Nginx configured"

# Step 11: Setup SSL
echo "🔄 Step 11/12: Setting up SSL certificate..."
if [ "$DOMAIN" = "your_domain.com" ]; then
    echo "⚠️  Skipping SSL setup - domain not configured"
else
    certbot --nginx -d $DOMAIN -d www.$DOMAIN --non-interactive --agree-tos -m admin@$DOMAIN > /dev/null 2>&1
    echo "✅ SSL certificate configured"
fi

# Step 12: Setup firewall
echo "🔄 Step 12/12: Configuring firewall..."
ufw --force enable > /dev/null 2>&1
ufw default deny incoming > /dev/null 2>&1
ufw default allow outgoing > /dev/null 2>&1
ufw allow 22/tcp > /dev/null 2>&1
ufw allow 80/tcp > /dev/null 2>&1
ufw allow 443/tcp > /dev/null 2>&1
echo "✅ Firewall configured"

# Copy frontend files
echo "📁 Copying frontend files..."
mkdir -p /var/www/rn-archangel-works
cp $APP_DIR/index.html /var/www/rn-archangel-works/
cp -r $APP_DIR/admin /var/www/rn-archangel-works/
echo "✅ Frontend files ready"

# Create backup script
echo "🔧 Creating backup script..."
mkdir -p $APP_DIR/scripts
cat > $APP_DIR/scripts/backup.sh << 'BACKUP_SCRIPT'
#!/bin/bash
BACKUP_DIR="/backups/rn-archangel"
DATE=$(date +%Y%m%d_%H%M%S)
mkdir -p $BACKUP_DIR

echo "🔄 Backing up application..."
tar -czf $BACKUP_DIR/rn-api-$DATE.tar.gz /home/rn-archangel-works/backend

echo "🔄 Backing up .env file..."
cp /home/rn-archangel-works/backend/.env $BACKUP_DIR/.env-$DATE

echo "✅ Backup complete: $BACKUP_DIR"
BACKUP_SCRIPT

chmod +x $APP_DIR/scripts/backup.sh

echo ""
echo "================================================"
echo "✅ DEPLOYMENT COMPLETE!"
echo "================================================"
echo ""
echo "📝 NEXT STEPS:"
echo ""
echo "1️⃣  SSH to your droplet:"
echo "   ssh root@$DOMAIN"
echo ""
echo "2️⃣  Update environment configuration:"
echo "   nano $APP_DIR/backend/.env"
echo ""
echo "3️⃣  Required settings in .env:"
echo "   MONGODB_URI=mongodb+srv://..."
echo "   JWT_SECRET=your_secure_secret_key"
echo "   NODE_ENV=production"
echo "   CLIENT_URL=https://$DOMAIN"
echo ""
echo "4️⃣  Restart application:"
echo "   pm2 restart rn-api"
echo ""
echo "🔍 MONITORING:"
echo "   View logs:     pm2 logs rn-api"
echo "   Status:        pm2 status"
echo "   Monitor:       pm2 monit"
echo ""
echo "🌐 ACCESS:"
echo "   API:           https://$DOMAIN/api"
echo "   Dashboard:     https://$DOMAIN/admin"
echo "   Website:       https://$DOMAIN"
echo ""
echo "💾 BACKUP:"
echo "   Manual backup: $APP_DIR/scripts/backup.sh"
echo ""
echo "📊 IMPORTANT FILES:"
echo "   Config:        $APP_DIR/backend/.env"
echo "   Logs:          pm2 logs"
echo "   Nginx config:  /etc/nginx/sites-available/rn-archangel-works"
echo ""
echo "🔒 SECURITY CHECKLIST:"
echo "   [ ] Update .env with real MongoDB URI"
echo "   [ ] Set strong JWT_SECRET"
echo "   [ ] Verify SSL certificate"
echo "   [ ] Check firewall rules"
echo "   [ ] Enable backups"
echo "   [ ] Monitor logs"
echo ""
