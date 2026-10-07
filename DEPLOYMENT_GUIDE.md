#!/bin/bash

# Production Deployment Guide for Rn Archangel Works
# This script helps deploy to DigitalOcean with production best practices

echo "================================================"
echo "Rn Archangel Works - Production Deployment"
echo "================================================"
echo ""
echo "This guide will help you deploy to DigitalOcean"
echo ""

# Check prerequisites
echo "📋 Checking prerequisites..."
echo ""

if ! command -v git &> /dev/null; then
    echo "❌ Git not found - please install git"
    exit 1
fi

if ! command -v node &> /dev/null; then
    echo "❌ Node.js not found - please install Node.js 18+"
    exit 1
fi

if ! command -v npm &> /dev/null; then
    echo "❌ npm not found"
    exit 1
fi

echo "✅ Git: $(git --version)"
echo "✅ Node.js: $(node -v)"
echo "✅ npm: $(npm -v)"
echo ""

# Ask for configuration
echo "🔧 DEPLOYMENT CONFIGURATION"
echo ""
read -p "Enter your domain name: " DOMAIN
read -p "Enter your DigitalOcean droplet IP: " DROPLET_IP
read -p "Enter GitHub repository URL (default: https://github.com/mcsats383/rn-archangel-works.git): " REPO_URL

REPO_URL=${REPO_URL:-https://github.com/mcsats383/rn-archangel-works.git}

echo ""
echo "📝 Configuration Summary:"
echo "   Domain: $DOMAIN"
echo "   Droplet IP: $DROPLET_IP"
echo "   Repository: $REPO_URL"
echo ""

read -p "Is this correct? (y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Deployment cancelled"
    exit 1
fi

echo ""
echo "🚀 DEPLOYMENT STEPS"
echo ""
echo "1. SSH to your droplet:"
echo "   ssh root@$DROPLET_IP"
echo ""
echo "2. Download and run deployment script:"
echo "   wget https://raw.githubusercontent.com/mcsats383/rn-archangel-works/main/deploy.sh"
echo "   chmod +x deploy.sh"
echo "   ./deploy.sh $DOMAIN"
echo ""
echo "3. After deployment completes:"
echo "   nano /home/rn-archangel-works/backend/.env"
echo ""
echo "4. Update these fields:"
echo "   MONGODB_URI=<your_mongodb_connection_string>"
echo "   JWT_SECRET=<generate_secure_secret>"
echo ""
echo "5. Restart the application:"
echo "   pm2 restart rn-api"
echo ""
echo "🔑 Generate JWT Secret (run this locally):"
echo "   node -e \"console.log(require('crypto').randomBytes(32).toString('hex'))\""
echo ""
echo "📚 DOCUMENTATION"
echo "   - Backend Setup: backend/SETUP.md"
echo "   - API Testing: backend/API_TESTING.md"
echo "   - Payment Gateway: backend/PAYMENT_GATEWAY.md"
echo "   - Security Guide: SECURITY.md"
echo ""
echo "✅ Ready to deploy!"
echo ""
