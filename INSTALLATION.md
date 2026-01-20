# TYPO3 14.1 Installation mit DDEV

Dokumentation der Installation vom 20. Januar 2026.

## Schnellinstallation

```bash
mkdir my-typo3-project && cd my-typo3-project
# install.sh in das Verzeichnis kopieren
./install.sh
```

Das Script `install.sh` führt alle unten dokumentierten Schritte automatisch aus.

## Projektkonfiguration

| Einstellung | Wert |
|-------------|------|
| Projektname | t3-v14-2 |
| TYPO3 Version | 14.1.0 |
| PHP Version | 8.3 |
| Datenbank | MariaDB 10.11 |
| Webserver | nginx-fpm |
| Theme | Camino |

## 1. Projektstruktur erstellt

```
t3-v14-2/
├── .ddev/
│   ├── config.yaml
│   ├── commands/web/typo3
│   └── nginx/typo3.conf
├── config/
│   └── sites/main/
│       ├── config.yaml
│       └── settings.yaml
├── packages/
├── public/
│   ├── .htaccess
│   ├── fileadmin/
│   └── typo3temp/
├── var/
├── composer.json
├── .gitignore
└── README.md
```

## 2. DDEV Konfiguration

**.ddev/config.yaml:**
```yaml
name: t3-v14-2
type: typo3
docroot: public
php_version: "8.3"
webserver_type: nginx-fpm
database:
  type: mariadb
  version: "10.11"
nodejs_version: "20"

web_environment:
  - TYPO3_CONTEXT=Development
  - TYPO3_DB_DRIVER=mysqli
  - TYPO3_DB_HOST=db
  - TYPO3_DB_PORT=3306
  - TYPO3_DB_NAME=db
  - TYPO3_DB_USER=db
  - TYPO3_DB_PASSWORD=db
```

## 3. DDEV gestartet

```bash
ddev start
```

## 4. Composer Dependencies installiert

**Initiale composer.json mit TYPO3 14.0 Paketen:**
```bash
ddev composer install
```

Installierte TYPO3 System Extensions:
- typo3/cms-core
- typo3/cms-backend
- typo3/cms-frontend
- typo3/cms-install
- typo3/cms-fluid-styled-content
- typo3/cms-rte-ckeditor
- typo3/cms-filelist
- typo3/cms-info
- typo3/cms-lowlevel
- typo3/cms-setup
- typo3/cms-tstemplate
- typo3/cms-recycler
- typo3/cms-redirects
- typo3/cms-reports
- typo3/cms-seo
- typo3/cms-sys-note
- helhum/typo3-console

## 5. TYPO3 Setup ausgeführt

```bash
ddev typo3 setup \
  --driver=mysqli \
  --host=db \
  --port=3306 \
  --dbname=db \
  --username=db \
  --password=db \
  --admin-username=admin \
  --admin-user-password=Admin123! \
  --admin-email=admin@example.com \
  --project-name="TYPO3v14" \
  --server-type=apache \
  --no-interaction
```

## 6. Trusted Hosts Pattern konfiguriert

**Problem:** UnexpectedValueException - Host header 't3-v14-2.ddev.site' nicht erlaubt.

**Lösung:** In `config/system/settings.php` hinzugefügt:
```php
'SYS' => [
    'trustedHostsPattern' => '.*\\.ddev\\.site$',
    // ...
],
```

## 7. Camino Theme installiert

```bash
ddev composer require typo3/theme-camino
ddev typo3 extension:setup -e theme_camino
ddev typo3 cache:flush
```

## 8. Site Configuration

**config/sites/main/config.yaml:**
```yaml
base: 'https://t3-v14-2.ddev.site/'
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
    websiteTitle: 'TYPO3 v14.2 Site'
errorHandling:
  - errorCode: 404
    errorHandler: Page
    errorContentSource: 't3://page?uid=404'
baseVariants:
  - base: 'https://t3-v14-2.ddev.site/'
    condition: 'applicationContext == "Development"'
```

## Zugang

| Service | URL |
|---------|-----|
| Frontend | https://t3-v14-2.ddev.site |
| Backend | https://t3-v14-2.ddev.site/typo3 |
| Mailpit | https://t3-v14-2.ddev.site:8026 |

**Backend Login:**
- Benutzer: `admin`
- Passwort: `Admin123!`

## Nützliche Befehle

```bash
# TYPO3 CLI
ddev typo3 cache:flush
ddev typo3 database:updateschema
ddev typo3 extension:setup -e <extension_key>

# DDEV
ddev start
ddev stop
ddev restart
ddev ssh
ddev logs -f

# Datenbank
ddev export-db > dump.sql.gz
ddev import-db < dump.sql.gz

# Composer
ddev composer require <package>
ddev composer update
```

## Installierte Pakete (composer.json)

```json
{
    "require": {
        "php": "^8.3",
        "helhum/typo3-console": "^8.3",
        "typo3/cms-backend": "^14.0",
        "typo3/cms-core": "^14.0",
        "typo3/cms-filelist": "^14.0",
        "typo3/cms-fluid-styled-content": "^14.0",
        "typo3/cms-frontend": "^14.0",
        "typo3/cms-info": "^14.0",
        "typo3/cms-install": "^14.0",
        "typo3/cms-lowlevel": "^14.0",
        "typo3/cms-recycler": "^14.0",
        "typo3/cms-redirects": "^14.0",
        "typo3/cms-reports": "^14.0",
        "typo3/cms-rte-ckeditor": "^14.0",
        "typo3/cms-seo": "^14.0",
        "typo3/cms-setup": "^14.0",
        "typo3/cms-sys-note": "^14.0",
        "typo3/cms-tstemplate": "^14.0",
        "typo3/theme-camino": "^14.1"
    }
}
```
