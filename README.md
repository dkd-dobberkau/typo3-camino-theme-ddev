# t3-v14-2

TYPO3 14.1 Projekt mit DDEV Entwicklungsumgebung.

## Voraussetzungen

- [DDEV](https://ddev.com/) installiert
- Docker Desktop oder Colima

## Installation

```bash
# DDEV starten
ddev start

# TYPO3 installieren (Composer wird automatisch ausgeführt)
ddev typo3 setup

# Admin-User erstellen
ddev typo3 backend:createadmin admin@example.com admin
```

## URLs

| Service | URL |
|---------|-----|
| Frontend | https://t3-v14-2.ddev.site |
| Backend | https://t3-v14-2.ddev.site/typo3 |

## DDEV Befehle

```bash
# TYPO3 CLI
ddev typo3 cache:flush
ddev typo3 database:updateschema
ddev typo3 extension:setup <ext_key>

# Datenbank
ddev export-db > dump.sql.gz
ddev import-db < dump.sql.gz

# SSH in Container
ddev ssh

# Logs anzeigen
ddev logs -f
```

## Deployment

```bash
# Composer für Production
composer install --no-dev --optimize-autoloader

# TYPO3 Caches leeren
vendor/bin/typo3 cache:flush
vendor/bin/typo3 cache:warmup
```

## Projektstruktur

```
├── .ddev/              # DDEV Konfiguration
├── config/
│   └── sites/          # TYPO3 Site Configuration
├── packages/           # Lokale Extensions/Sitepackages
├── public/             # Web Root
├── var/                # TYPO3 var Directory
└── vendor/             # Composer Dependencies
```

## Dokumentation

- [INSTALLATION.md](INSTALLATION.md) - Detaillierte Installationsanleitung
- [CAMINO.md](CAMINO.md) - Camino Theme Dokumentation & FAQ
- [Gist](https://gist.github.com/dkd-dobberkau/fa709d84ced310dad15ed75d23f5117b) - Install-Script & Dokumentation
