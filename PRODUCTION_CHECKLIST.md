# Rn Archangel Works - Production Checklist

## Pre-Deployment

- [ ] Repository is private on GitHub
- [ ] All sensitive data removed from git history
- [ ] .env file is in .gitignore
- [ ] All dependencies are tested locally
- [ ] npm install works without errors
- [ ] npm run dev works locally
- [ ] All API endpoints tested with Postman
- [ ] Admin dashboard tested locally
- [ ] Database backups configured
- [ ] Domain name is registered and DNS configured

## DigitalOcean Setup

- [ ] Droplet created (Ubuntu 22.04 LTS, minimum $6/month)
- [ ] SSH key configured (no password login)
- [ ] Droplet IP noted
- [ ] Firewall enabled and configured
- [ ] Backups enabled on droplet
- [ ] Monitoring enabled (optional)

## Deployment

- [ ] SSH into droplet as root
- [ ] Downloaded deploy.sh script
- [ ] Ran deploy.sh with domain name
- [ ] All steps completed without errors
- [ ] PM2 processes started
- [ ] Nginx configured and running
- [ ] SSL certificate requested and installed

## Configuration

- [ ] .env file updated with:
  - [ ] MONGODB_URI (MongoDB Atlas connection string)
  - [ ] JWT_SECRET (strong 32+ character secret)
  - [ ] NODE_ENV=production
  - [ ] CLIENT_URL=https://yourdomain.com
  - [ ] STRIPE_SECRET_KEY (if using Stripe)
  - [ ] PROMPTPAY_ID (if using PromptPay)
  - [ ] BANK_ACCOUNT_NUMBER (if using bank transfer)
- [ ] PM2 restarted after .env changes
- [ ] Logs checked for errors

## MongoDB Atlas Setup

- [ ] MongoDB Atlas account created
- [ ] Cluster created (free tier)
- [ ] Database user created
- [ ] IP whitelist configured (allow droplet IP + 0.0.0.0/0 for testing)
- [ ] Connection string copied to .env
- [ ] Database connection tested
- [ ] Collections created
- [ ] Backup enabled

## Security

- [ ] SSH key only authentication (no passwords)
- [ ] UFW firewall enabled with rules:
  - [ ] Port 22 (SSH) allowed
  - [ ] Port 80 (HTTP) allowed
  - [ ] Port 443 (HTTPS) allowed
  - [ ] All other incoming ports denied
- [ ] Fail2Ban installed (optional)
- [ ] HTTPS redirect enabled
- [ ] Security headers configured in Nginx
- [ ] CORS configured for your domain only
- [ ] Rate limiting enabled on API
- [ ] JWT token validation working
- [ ] Password hashing verified (bcryptjs)
- [ ] Environment variables not logged
- [ ] Error messages don't leak sensitive info

## SSL/TLS Certificate

- [ ] Let's Encrypt certificate installed
- [ ] Certificate auto-renewal configured
- [ ] HTTPS working for both www and non-www
- [ ] HTTP redirects to HTTPS
- [ ] Certificate validity checked
- [ ] Mixed content warnings resolved

## Monitoring & Logging

- [ ] PM2 logs checked and configured
- [ ] Nginx access logs monitored
- [ ] Nginx error logs checked
- [ ] Error handling middleware active
- [ ] Admin emails configured for alerts
- [ ] Backup verification scheduled
- [ ] Uptime monitoring setup (optional)
- [ ] Performance monitoring setup (optional)

## Database

- [ ] MongoDB Atlas backup enabled
- [ ] Local backup script created and tested
- [ ] Backup location secured
- [ ] Database indexes created
- [ ] Database size monitored
- [ ] Query performance optimized

## API Testing

- [ ] Health check endpoint: GET /
- [ ] Auth endpoint: POST /api/auth/register
- [ ] Auth endpoint: POST /api/auth/login
- [ ] Projects endpoint: GET /api/projects
- [ ] Contacts endpoint: POST /api/contacts
- [ ] Payments endpoint: POST /api/payments
- [ ] Admin endpoint: GET /api/dashboard
- [ ] Error handling tested (wrong credentials, invalid data)
- [ ] Rate limiting tested
- [ ] CORS tested

## Frontend

- [ ] Landing page loads
- [ ] Admin dashboard accessible at /admin
- [ ] Contact form submits to API
- [ ] Admin login works
- [ ] Dashboard displays correctly
- [ ] All links work
- [ ] Mobile responsive design verified
- [ ] Page load time acceptable (<3 seconds)

## Payment Gateway (If Enabled)

- [ ] Stripe account created and API keys configured (if using)
- [ ] PromptPay ID configured (if using)
- [ ] Bank account details configured (if using)
- [ ] Payment endpoints tested
- [ ] Payment webhook configured
- [ ] Test payment completed successfully
- [ ] Payment status updates working
- [ ] Invoice generation working

## Documentation

- [ ] README.md updated with deployment info
- [ ] API documentation complete
- [ ] Team members have access to documentation
- [ ] Troubleshooting guide created
- [ ] Emergency recovery procedure documented
- [ ] Contact person assigned for production issues

## Post-Deployment

- [ ] Monitor logs for 24 hours
- [ ] Test all critical workflows
- [ ] Verify automated backups running
- [ ] Set up monitoring alerts
- [ ] Notify team of live status
- [ ] Create incident response plan
- [ ] Schedule security audit
- [ ] Plan for scaling (if needed)

## Maintenance Schedule

- [ ] Daily: Check logs for errors
- [ ] Weekly: Verify backups
- [ ] Monthly: Security review
- [ ] Monthly: Update dependencies
- [ ] Quarterly: Full security audit
- [ ] Quarterly: Disaster recovery test
- [ ] Annually: Penetration testing

## Rollback Plan

- [ ] Previous version backed up
- [ ] Rollback procedure documented
- [ ] Database backup available
- [ ] Deployment script can run multiple times
- [ ] Team trained on rollback process

## Performance Targets

- [ ] API response time: <200ms
- [ ] Page load time: <3 seconds
- [ ] Database query time: <100ms
- [ ] Uptime target: 99.5%
- [ ] Max concurrent users: 100+

## Success Criteria

✅ All checklist items completed
✅ Application running without errors
✅ All API endpoints responding
✅ Admin dashboard functional
✅ HTTPS working
✅ Backups verified
✅ Team trained and ready
✅ Monitoring and alerting active

---

**Deployment Date**: ________________
**Deployed By**: ________________
**Reviewed By**: ________________

**Issues Found**: 

```

```

**Resolution**:

```

```
