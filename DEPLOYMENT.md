#!/bin/bash

# Rat UI Installer - Deployment Guide
# This guide explains how to host the installer for one-line installation

# The installer can be deployed on:
# 1. GitHub Pages
# 2. Your own web server
# 3. CDN services like Fastly, Cloudflare
# 4. Cloud storage like AWS S3, Google Cloud Storage

# =============================================================================
# OPTION 1: GitHub Pages (Easiest - Free)
# =============================================================================

# 1. Create a gh-pages branch or use docs/ folder
# 2. Place install.sh in the repository
# 3. Enable GitHub Pages in settings
# 4. Access at: https://username.github.io/rat/install.sh

# Add to your main repository to enable:
cat > .github/workflows/deploy-installer.yml << 'EOF'
name: Deploy Installer

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Deploy to Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./dist
EOF

# =============================================================================
# OPTION 2: Self-Hosted Web Server
# =============================================================================

# Nginx example:
cat > /tmp/nginx-installer.conf << 'EOF'
server {
    listen 80;
    server_name your-domain.com;
    
    location /install.sh {
        alias /var/www/rat-ui/install.sh;
        types {
            application/x-sh sh;
        }
        add_header Content-Type application/x-sh;
    }
}
EOF

# Deployment steps:
# 1. Copy install.sh to server: scp install.sh user@your-domain.com:/var/www/rat-ui/
# 2. Set permissions: chmod 644 /var/www/rat-ui/install.sh
# 3. Configure Nginx to serve it

# =============================================================================
# OPTION 3: AWS S3 + CloudFront
# =============================================================================

# 1. Create S3 bucket
# aws s3 mb s3://rat-ui-installers

# 2. Upload installer
# aws s3 cp install.sh s3://rat-ui-installers/mac/install.sh --acl public-read

# 3. Create CloudFront distribution pointing to S3
# Access at: https://d1234abcd.cloudfront.net/mac/install.sh

# =============================================================================
# OPTION 4: Docker Web Server
# =============================================================================

cat > /tmp/Dockerfile << 'EOF'
FROM nginx:alpine

COPY install.sh /usr/share/nginx/html/
COPY INSTALL_MAC.md /usr/share/nginx/html/README.md

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
EOF

# Build and run:
# docker build -t rat-ui-installer .
# docker run -p 80:80 rat-ui-installer

# =============================================================================
# INSTALLATION COMMANDS FOR EACH OPTION
# =============================================================================

echo "GitHub Pages:"
echo 'curl -fsSL "https://username.github.io/rat/install.sh" | bash'
echo ""

echo "Self-hosted:"
echo 'curl -fsSL "https://your-domain.com/install.sh" | bash'
echo ""

echo "AWS CloudFront:"
echo 'curl -fsSL "https://d1234abcd.cloudfront.net/mac/install.sh" | bash'
echo ""

echo "Docker local (for testing):"
echo 'curl -fsSL "http://localhost/install.sh" | bash'
echo ""

# =============================================================================
# SECURITY CONSIDERATIONS
# =============================================================================

# 1. Use HTTPS only in production
# 2. Sign the installer script with GPG
# 3. Provide SHA256 checksums
# 4. Keep the installer updated
# 5. Monitor for security issues

# Example: Generate and verify checksums
# sha256sum install.sh > install.sh.sha256
# sha256sum -c install.sh.sha256

# =============================================================================
# TESTING THE INSTALLER LOCALLY
# =============================================================================

# Start a local web server:
# python3 -m http.server 8000

# Then test installation:
# curl -fsSL "http://localhost:8000/install.sh" | bash

# =============================================================================
# CI/CD INTEGRATION
# =============================================================================

# The GitHub Actions workflow (build-mac-installer.yml) automatically:
# 1. Builds the installer on each push to main
# 2. Generates all required files
# 3. Creates artifacts for download
# 4. Can deploy to your hosting service

# To enable auto-deployment, add these steps to your workflow:
# - Deploy to GitHub Pages
# - Deploy to S3
# - Deploy to your custom server

# Example S3 deployment step:
cat > /tmp/s3-deploy.yml << 'EOF'
- name: Deploy to S3
  run: |
    aws s3 cp install.sh s3://rat-ui-installers/mac/install.sh --acl public-read
  env:
    AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
    AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
    AWS_DEFAULT_REGION: us-east-1
EOF

echo "✅ Deployment guide created"
echo ""
echo "Next steps:"
echo "1. Choose a deployment option above"
echo "2. Upload install.sh to your server"
echo "3. Test with: curl -fsSL 'YOUR_URL' | bash"
echo "4. Share the one-liner with users"
