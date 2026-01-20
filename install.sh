#!/bin/bash
#
# TYPO3 14.1 + DDEV Installation Script
# Erstellt am 20. Januar 2026
#
# Verwendung:
#   mkdir my-typo3-project && cd my-typo3-project
#   curl -O https://example.com/install.sh
#   chmod +x install.sh
#   ./install.sh
#

set -e

# Konfiguration
PROJECT_NAME="${PWD##*/}"
TYPO3_VERSION="^14.0"
PHP_VERSION="8.3"
DB_TYPE="mariadb"
DB_VERSION="10.11"
ADMIN_USER="admin"
ADMIN_PASSWORD="Admin123!"
ADMIN_EMAIL="admin@example.com"

echo "=============================================="
echo "TYPO3 14.1 + DDEV Installation"
echo "Projekt: $PROJECT_NAME"
echo "=============================================="

# 1. Verzeichnisstruktur erstellen
echo ""
echo "[1/8] Erstelle Verzeichnisstruktur..."
mkdir -p .ddev/commands/web
mkdir -p .ddev/nginx
mkdir -p config/sites/main
mkdir -p packages
mkdir -p public/fileadmin
mkdir -p public/typo3temp
mkdir -p var

touch public/fileadmin/.gitkeep
touch public/typo3temp/.gitkeep
touch var/.gitkeep

# 2. DDEV config.yaml
echo "[2/8] Erstelle DDEV Konfiguration..."
cat > .ddev/config.yaml << 'EOF'
name: PROJECT_NAME_PLACEHOLDER
type: typo3
docroot: public
php_version: "PHP_VERSION_PLACEHOLDER"
webserver_type: nginx-fpm
xdebug_enabled: false
additional_hostnames: []
additional_fqdns: []
database:
  type: DB_TYPE_PLACEHOLDER
  version: "DB_VERSION_PLACEHOLDER"
nodejs_version: "20"
corepack_enable: true

mutagen_enabled: false
nfs_mount_enabled: false

hooks:
  post-start:
    - exec: composer install --quiet

web_environment:
  - TYPO3_CONTEXT=Development
  - TYPO3_DB_DRIVER=mysqli
  - TYPO3_DB_HOST=db
  - TYPO3_DB_PORT=3306
  - TYPO3_DB_NAME=db
  - TYPO3_DB_USER=db
  - TYPO3_DB_PASSWORD=db
EOF

sed -i.bak "s/PROJECT_NAME_PLACEHOLDER/$PROJECT_NAME/g" .ddev/config.yaml
sed -i.bak "s/PHP_VERSION_PLACEHOLDER/$PHP_VERSION/g" .ddev/config.yaml
sed -i.bak "s/DB_TYPE_PLACEHOLDER/$DB_TYPE/g" .ddev/config.yaml
sed -i.bak "s/DB_VERSION_PLACEHOLDER/$DB_VERSION/g" .ddev/config.yaml
rm -f .ddev/config.yaml.bak

# 3. DDEV TYPO3 Command
echo "[3/8] Erstelle DDEV Commands..."
cat > .ddev/commands/web/typo3 << 'EOF'
#!/bin/bash

## Description: Run TYPO3 CLI commands
## Usage: typo3 [command]
## Example: ddev typo3 cache:flush

vendor/bin/typo3 "$@"
EOF
chmod +x .ddev/commands/web/typo3

# 4. Nginx Konfiguration
cat > .ddev/nginx/typo3.conf << 'EOF'
# TYPO3 specific nginx configuration

location ~* ^/(typo3conf/ext|typo3/sysext|typo3temp/var) {
    deny all;
    return 404;
}

location ~ /\. {
    deny all;
    return 404;
}

location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
    expires 1y;
    add_header Cache-Control "public, immutable";
    access_log off;
}

location /typo3 {
    try_files $uri /typo3/index.php$is_args$args;
}
EOF

# 5. composer.json
echo "[4/8] Erstelle composer.json..."
cat > composer.json << EOF
{
    "name": "local/$PROJECT_NAME",
    "description": "TYPO3 CMS Project",
    "license": "GPL-2.0-or-later",
    "type": "project",
    "require": {
        "php": "^$PHP_VERSION",
        "typo3/cms-core": "$TYPO3_VERSION",
        "typo3/cms-backend": "$TYPO3_VERSION",
        "typo3/cms-frontend": "$TYPO3_VERSION",
        "typo3/cms-install": "$TYPO3_VERSION",
        "typo3/cms-fluid-styled-content": "$TYPO3_VERSION",
        "typo3/cms-rte-ckeditor": "$TYPO3_VERSION",
        "typo3/cms-filelist": "$TYPO3_VERSION",
        "typo3/cms-info": "$TYPO3_VERSION",
        "typo3/cms-lowlevel": "$TYPO3_VERSION",
        "typo3/cms-setup": "$TYPO3_VERSION",
        "typo3/cms-tstemplate": "$TYPO3_VERSION",
        "typo3/cms-recycler": "$TYPO3_VERSION",
        "typo3/cms-redirects": "$TYPO3_VERSION",
        "typo3/cms-reports": "$TYPO3_VERSION",
        "typo3/cms-seo": "$TYPO3_VERSION",
        "typo3/cms-sys-note": "$TYPO3_VERSION",
        "typo3/theme-camino": "^14.1",
        "helhum/typo3-console": "^8.3"
    },
    "require-dev": {
        "typo3/testing-framework": "^9.0",
        "phpstan/phpstan": "^1.10",
        "friendsofphp/php-cs-fixer": "^3.0"
    },
    "autoload": {
        "psr-4": {
            "Local\\\\": "packages/"
        }
    },
    "config": {
        "allow-plugins": {
            "typo3/class-alias-loader": true,
            "typo3/cms-composer-installers": true
        },
        "platform": {
            "php": "$PHP_VERSION"
        },
        "sort-packages": true
    },
    "extra": {
        "typo3/cms": {
            "web-dir": "public"
        }
    },
    "repositories": [
        {
            "type": "path",
            "url": "packages/*"
        }
    ],
    "scripts": {
        "post-autoload-dump": [
            "@php vendor/bin/typo3 cache:flush --no-interaction 2>/dev/null || true"
        ]
    }
}
EOF

# 6. public/.htaccess
cat > public/.htaccess << 'EOF'
<IfModule mod_rewrite.c>
    RewriteEngine On
    RewriteCond %{REQUEST_URI} ^(.*)$
    RewriteRule . - [E=TYPO3_REQUEST_URI:%1]
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteRule ^(.+)\.(\d+)\.(php|js|css|png|jpg|gif|gzip)$ $1.$3 [L]
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteCond %{REQUEST_FILENAME} !-l
    RewriteRule . index.php [L]
</IfModule>

<FilesMatch "^\.">
    <IfModule mod_authz_core.c>
        Require all denied
    </IfModule>
</FilesMatch>

<FilesMatch "(~|\.sw[op]|\.bak|\.orig|\.old)$">
    <IfModule mod_authz_core.c>
        Require all denied
    </IfModule>
</FilesMatch>

<IfModule mod_expires.c>
    ExpiresActive On
    ExpiresByType text/css "access plus 1 year"
    ExpiresByType application/javascript "access plus 1 year"
    ExpiresByType image/gif "access plus 1 year"
    ExpiresByType image/jpeg "access plus 1 year"
    ExpiresByType image/png "access plus 1 year"
    ExpiresByType image/svg+xml "access plus 1 year"
    ExpiresByType font/woff2 "access plus 1 year"
</IfModule>

<IfModule mod_deflate.c>
    AddOutputFilterByType DEFLATE text/html text/plain text/xml text/css application/javascript application/json image/svg+xml
</IfModule>
EOF

# 7. .gitignore
cat > .gitignore << 'EOF'
/public/fileadmin/
/public/typo3/
/public/typo3conf/ext/
/public/typo3temp/
/public/uploads/
/var/
/vendor/

!public/fileadmin/.gitkeep
!public/typo3temp/.gitkeep
!var/.gitkeep

.ddev/.gitignore
.ddev/db_snapshots/
.ddev/mutagen/
.ddev/.webimageBuild/

.idea/
.vscode/
*.swp
*.swo

.DS_Store
Thumbs.db

.env
.env.local
*.local.yaml

node_modules/
/Build/
EOF

# 8. DDEV starten
echo "[5/8] Starte DDEV..."
ddev start

# 9. Composer install (falls nicht durch hook)
echo "[6/8] Installiere Composer Dependencies..."
ddev composer install --quiet

# 10. TYPO3 Setup
echo "[7/8] Führe TYPO3 Setup aus..."
ddev typo3 setup \
    --driver=mysqli \
    --host=db \
    --port=3306 \
    --dbname=db \
    --username=db \
    --password=db \
    --admin-username="$ADMIN_USER" \
    --admin-user-password="$ADMIN_PASSWORD" \
    --admin-email="$ADMIN_EMAIL" \
    --project-name="$PROJECT_NAME" \
    --server-type=apache \
    --no-interaction

# 11. Trusted Hosts Pattern setzen
echo "[8/8] Konfiguriere TYPO3..."
SETTINGS_FILE="config/system/settings.php"
if [ -f "$SETTINGS_FILE" ]; then
    # Füge trustedHostsPattern hinzu falls nicht vorhanden
    if ! grep -q "trustedHostsPattern" "$SETTINGS_FILE"; then
        sed -i.bak "s/'SYS' => \[/'SYS' => [\n        'trustedHostsPattern' => '.*\\\\.ddev\\\\.site\$',/g" "$SETTINGS_FILE"
        rm -f "$SETTINGS_FILE.bak"
    fi
fi

# 12. Site Configuration erstellen
cat > config/sites/main/config.yaml << EOF
base: 'https://$PROJECT_NAME.ddev.site/'
rootPageId: 1
dependencies:
  - typo3/theme-camino
  - typo3/seo-sitemap
  - typo3/redirects
languages:
  - title: Deutsch
    enabled: true
    languageId: 0
    base: /
    locale: de_DE.UTF-8
    navigationTitle: DE
    hreflang: de-DE
    direction: ltr
    flag: de
    websiteTitle: '$PROJECT_NAME'
errorHandling:
  - errorCode: 404
    errorHandler: Page
    errorContentSource: 't3://page?uid=404'
baseVariants:
  - base: 'https://$PROJECT_NAME.ddev.site/'
    condition: 'applicationContext == "Development"'
EOF

cat > config/sites/main/settings.yaml << 'EOF'
settings: []
EOF

# 13. Extension aktivieren und Cache leeren
ddev typo3 extension:setup -e theme_camino
ddev typo3 cache:flush

# Fertig
echo ""
echo "=============================================="
echo "Installation abgeschlossen!"
echo "=============================================="
echo ""
echo "URLs:"
echo "  Frontend: https://$PROJECT_NAME.ddev.site"
echo "  Backend:  https://$PROJECT_NAME.ddev.site/typo3"
echo ""
echo "Login:"
echo "  Benutzer: $ADMIN_USER"
echo "  Passwort: $ADMIN_PASSWORD"
echo ""
echo "Befehle:"
echo "  ddev typo3 cache:flush    - Cache leeren"
echo "  ddev stop                 - Projekt stoppen"
echo "  ddev start                - Projekt starten"
echo ""
