#!/bin/bash

# Installation & Setup Script for Rn Archangel Works Backend
# This script automates the setup process

echo "================================================"
echo "Rn Archangel Works - Backend Setup"
echo "================================================"
echo ""

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed"
    echo "Please install Node.js from https://nodejs.org/"
    exit 1
fi

echo "✅ Node.js version: $(node -v)"
echo "✅ npm version: $(npm -v)"
echo ""

# Install dependencies
echo "📦 Installing dependencies..."
npm install

if [ -f ".env" ]; then
    echo "⚠️  .env file already exists"
else
    echo "📝 Creating .env file from template..."
    cp .env.example .env
    echo "✅ .env file created"
    echo ""
    echo "⚠️  IMPORTANT: Please update .env file with your MongoDB URI"
    echo "   Location: backend/.env"
    echo ""
fi

echo "================================================"
echo "Setup Complete!"
echo "================================================"
echo ""
echo "Next steps:"
echo "1. Update backend/.env with your MongoDB connection string"
echo "2. Run: npm run dev"
echo "3. Visit: http://localhost:5000"
echo ""
echo "For API documentation, see: backend/API_TESTING.md"
echo ""
