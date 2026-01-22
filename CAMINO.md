# TYPO3 Camino Theme - Technische Dokumentation

Das Camino Theme ist das offizielle Standard-Theme für TYPO3 14.x.

## Übersicht

| Eigenschaft | Wert |
|-------------|------|
| **Pfad** | `vendor/typo3/theme-camino` |
| **Version** | 14.1.0 |
| **Autor** | TYPO3 Core Team |
| **Fonts** | Open Sans, Playfair |
| **Breakpoint** | 1280px (Mobile/Desktop) |

## Verzeichnisstruktur

```
theme-camino/
├── Configuration/
│   ├── BackendLayouts/              # Backend Layouts
│   │   ├── CaminoStartpage.tsconfig
│   │   ├── CaminoContentpage.tsconfig
│   │   └── CaminoContentpageSidebar.tsconfig
│   ├── Sets/camino/
│   │   ├── config.yaml              # Theme-Definition
│   │   ├── settings.definitions.yaml # Einstellungen
│   │   └── TypoScript/
│   │       ├── setup.typoscript     # Haupt-Setup
│   │       ├── page.typoscript      # Page-Konfiguration
│   │       └── content.typoscript   # Content-Rendering
│   └── TCA/Overrides/               # Content-Element-Definitionen
├── Resources/
│   ├── Private/
│   │   ├── Language/                # Übersetzungen
│   │   └── Templates/
│   │       ├── Pages/               # Seiten-Templates
│   │       ├── Content/             # Content-Element-Templates
│   │       ├── Layouts/             # Fluid Layouts
│   │       └── Partials/            # Komponenten
│   └── Public/
│       ├── Css/                     # Stylesheets (31 Module)
│       ├── JavaScript/              # main.js (Navigation)
│       ├── Fonts/                   # WOFF2 Fonts
│       └── Icons/                   # SVG Icons
```

## Color Schemes

Das Theme bietet 4 vordefinierte Farbschemas:

| Schema | Beschreibung |
|--------|--------------|
| `theme-caramel-cream` | Standard (warme Brauntöne) |
| `theme-ocean-breeze` | Blautöne |
| `theme-forest-mist` | Grüntöne |
| `theme-violet-velvet` | Violetttöne |

**Konfiguration in Site Settings:**
```yaml
# config/sites/main/settings.yaml
camino:
  colorScheme: theme-caramel-cream
  header:
    fixedPosition: false
```

## Backend Layouts

### CaminoStartpage
- **colPos 2** (Stage): Hero-Elemente
- **colPos 0** (Content): Hauptinhalt

### CaminoContentpage
- **colPos 2** (Stage): Hero-Elemente
- **colPos 0** (Content): Hauptinhalt

### CaminoContentpageSidebar
- Layout mit zusätzlicher Sidebar

## Content Elements

### Hero-Elemente (colPos 2)
| CType | Beschreibung |
|-------|--------------|
| `caminohero` | Hero mit Bild und Text |
| `caminoherosmall` | Kleiner Hero |
| `caminoherotextonly` | Hero nur mit Text |

### Teaser-Elemente
| CType | Beschreibung |
|-------|--------------|
| `caminotextteaser` | Text-Teaser |
| `caminotextmediateaser` | Text + Media Teaser |
| `caminotextmediateasergrid` | Teaser-Grid |

### Weitere Elemente
| CType | Beschreibung |
|-------|--------------|
| `caminoauthor` | Autor-Box |
| `caminolinklist` | Link-Liste |
| `caminosociallinks` | Social Media Links |
| `caminotestimonial` | Testimonial/Zitat |

## CSS-Architektur

### Haupt-CSS-Datei
`Resources/Public/Css/main.css` importiert alle Module.

### CSS-Variablen (`_css-variables.css`)

```css
:root {
  /* Primärfarben */
  --color-primary-75: #DD997C;
  --color-primary-100: #B45023;

  /* Neutrale Farben (0-90) */
  --color-neutral-0: #FFFFFF;
  --color-neutral-10: #F5F0ED;
  /* ... */
  --color-neutral-90: #220B01;

  /* Semantische Farben */
  --color-info: #0E55FF;
  --color-success: #378200;
  --color-warning: #846C00;
  --color-error: #D70000;

  /* Typografie */
  --headline-family: "Playfair";
  --subline-family: "Open Sans";
}
```

### CSS-Module

| Modul | Zweck |
|-------|-------|
| `_minireset.css` | CSS Reset |
| `_fonts.css` | Font-Definitionen |
| `_base.css` | Basis-Styles |
| `_header.css` | Header & Navigation |
| `_footer.css` | Footer |
| `_hero.css` | Hero-Sections |
| `_button.css` | Buttons |
| `_figure.css` | Bilder/Figures |
| `_textpic.css` | Text mit Bild |

## JavaScript

`Resources/Public/JavaScript/main.js` - Mobile Navigation:

- Hamburger-Menu Toggle
- Subnavigation Handling
- Scroll-Lock bei offenem Menu
- Responsive Verhalten (Breakpoint: 1280px)

**CSS-Klassen für JS:**
- `.JS_header-menu-button` - Menu-Button
- `.JS_header_subnav_link` - Submenu-Links

## Anpassung im eigenen Sitepackage

### 1. Template-Pfade überschreiben

```typoscript
# Configuration/Sets/my_sitepackage/setup.typoscript

lib.fluidPage {
  templateRootPaths.20 = EXT:my_sitepackage/Resources/Private/Templates/Pages/
  partialRootPaths.20 = EXT:my_sitepackage/Resources/Private/Partials/
  layoutRootPaths.20 = EXT:my_sitepackage/Resources/Private/Layouts/
}

lib.contentElement {
  templateRootPaths.20 = EXT:my_sitepackage/Resources/Private/Templates/Content/
  partialRootPaths.20 = EXT:my_sitepackage/Resources/Private/Partials/
  layoutRootPaths.20 = EXT:my_sitepackage/Resources/Private/Layouts/
}
```

### 2. Eigenes Color Scheme erstellen

```css
/* Resources/Public/Css/custom-theme.css */

.theme-custom {
  --color-primary-75: #7CB9DD;
  --color-primary-100: #2378B4;
  /* weitere Anpassungen */
}
```

### 3. Header/Footer anpassen

Kopiere die Partials in dein Sitepackage:
```
my_sitepackage/Resources/Private/Partials/Pages/
├── Header.fluid.html
└── Footer.fluid.html
```

### 4. Neues Content Element erstellen

1. TCA-Override erstellen:
```php
// Configuration/TCA/Overrides/tt_content.php
\TYPO3\CMS\Core\Utility\ExtensionManagementUtility::addTcaSelectItem(
    'tt_content',
    'CType',
    ['label' => 'My Element', 'value' => 'my_element', 'group' => 'default']
);
```

2. Template erstellen:
```html
<!-- Resources/Private/Templates/Content/MyElement.fluid.html -->
<f:layout name="Content/Default" />
<f:section name="Main">
    <!-- Content hier -->
</f:section>
```

## Wichtige Fluid-Variablen

### In Page-Templates
- `{data}` - Page-Record
- `{settings}` - Site Settings
- `{mainMenu}` - Hauptnavigation
- `{breadcrumb}` - Breadcrumb-Menü
- `{site}` - Site-Informationen

### In Content-Templates
- `{data}` - tt_content Record
- `{settings}` - Site Settings

## Partials-Übersicht

### Atoms
- `Image.fluid.html` - Responsive Bilder
- `Video.fluid.html` - Video-Elemente

### Components
- `Figure.fluid.html` - Bild mit Caption
- `Intro.fluid.html` - Intro-Text
- `Person.fluid.html` - Personen-Darstellung

### Icons (24 SVG-Icons)
- Navigation: Menu, Chevron, Arrow
- UI: Close, Download, Search, Zoom, Play
- Links: Launch, Mail, Phone, Globe
- Social: Facebook, Instagram, LinkedIn, X, Xing, YouTube

## FAQ

### Wie ändere ich das Farbschema?

In `config/sites/main/settings.yaml`:
```yaml
camino:
  colorScheme: theme-ocean-breeze
```
Verfügbar: `theme-caramel-cream`, `theme-ocean-breeze`, `theme-forest-mist`, `theme-violet-velvet`

---

### Wie erstelle ich ein eigenes Farbschema?

1. CSS-Datei erstellen mit neuer Theme-Klasse:
```css
/* my_sitepackage/Resources/Public/Css/my-theme.css */
.theme-my-custom {
  --color-primary-75: #7CB9DD;
  --color-primary-100: #2378B4;
  --color-neutral-0: #FFFFFF;
  /* ... alle Variablen aus _css-variables.css überschreiben */
}
```

2. CSS einbinden via TypoScript:
```typoscript
page.includeCSSLibs.myTheme = EXT:my_sitepackage/Resources/Public/Css/my-theme.css
```

3. In settings.yaml verwenden:
```yaml
camino:
  colorScheme: theme-my-custom
```

---

### Wie passe ich Header oder Footer an?

1. Partial kopieren nach `my_sitepackage/Resources/Private/Partials/Pages/Header.fluid.html`
2. Template-Pfad registrieren:
```typoscript
lib.fluidPage.partialRootPaths.20 = EXT:my_sitepackage/Resources/Private/Partials/
```

---

### Wie ändere ich die Schriftart?

1. Fonts in `Resources/Public/Fonts/` ablegen
2. CSS erstellen:
```css
@font-face {
  font-family: "MeineFont";
  src: url("../Fonts/MeineFont.woff2") format("woff2");
}
:root {
  --headline-family: "MeineFont";
  --subline-family: "MeineFont";
}
```

---

### Wie aktiviere ich den Fixed Header?

```yaml
# config/sites/main/settings.yaml
camino:
  header:
    fixedPosition: true
```

---

### Wie überschreibe ich ein Content-Element-Template?

1. Template kopieren von `vendor/typo3/theme-camino/Resources/Private/Templates/Content/`
2. In eigenem Sitepackage ablegen: `Resources/Private/Templates/Content/CaminoHero.fluid.html`
3. Pfad registrieren:
```typoscript
lib.contentElement.templateRootPaths.20 = EXT:my_sitepackage/Resources/Private/Templates/Content/
```

---

### Wie füge ich ein eigenes Content Element hinzu?

1. **TCA registrieren** (`Configuration/TCA/Overrides/tt_content.php`):
```php
\TYPO3\CMS\Core\Utility\ExtensionManagementUtility::addTcaSelectItem(
    'tt_content',
    'CType',
    ['label' => 'Mein Element', 'value' => 'my_element', 'group' => 'default']
);

$GLOBALS['TCA']['tt_content']['types']['my_element'] = [
    'showitem' => '--div--;LLL:EXT:core/Resources/Private/Language/Form/locallang_tabs.xlf:general,
        --palette--;;general,header,bodytext,
        --div--;LLL:EXT:core/Resources/Private/Language/Form/locallang_tabs.xlf:access,
        --palette--;;hidden',
];
```

2. **Template erstellen** (`Resources/Private/Templates/Content/MyElement.fluid.html`):
```html
<f:layout name="Content/Default" />
<f:section name="Main">
    <h2>{data.header}</h2>
    <f:format.html>{data.bodytext}</f:format.html>
</f:section>
```

---

### Wie ändere ich den Mobile-Breakpoint?

Der Breakpoint ist in `main.js` auf 1280px gesetzt. Zum Ändern:

1. JavaScript kopieren und anpassen:
```javascript
const BREAKPOINT = 1024; // Neuer Wert
```

2. CSS-Media-Queries entsprechend anpassen in den relevanten CSS-Modulen.

---

### Wie füge ich Social-Media-Icons hinzu?

Das `caminosociallinks` Content Element nutzen. Eigene Icons:

1. SVG-Partial erstellen: `Partials/Icons/SocialTiktok.fluid.html`
2. Im Template referenzieren: `<f:render partial="Icons/SocialTiktok" />`

---

### Warum werden meine Hero-Elemente nicht angezeigt?

Hero-Elemente (`caminohero`, `caminoherosmall`, `caminoherotextonly`) sind nur für **colPos 2 (Stage)** erlaubt. Prüfe:
- Backend Layout ist korrekt zugewiesen (CaminoStartpage oder CaminoContentpage)
- Element wurde in den "Stage"-Bereich eingefügt

---

### Wie füge ich Google Analytics / Matomo hinzu?

Via TypoScript im `<head>`:
```typoscript
page.headerData.100 = TEXT
page.headerData.100.value (
  <script async src="https://www.googletagmanager.com/gtag/js?id=GA_ID"></script>
  <script>
    window.dataLayer = window.dataLayer || [];
    function gtag(){dataLayer.push(arguments);}
    gtag('js', new Date());
    gtag('config', 'GA_ID');
  </script>
)
```

---

### Wie deaktiviere ich ein Standard-Content-Element?

```php
// Configuration/TCA/Overrides/tt_content.php
unset($GLOBALS['TCA']['tt_content']['types']['caminotestimonial']);

// Oder aus der Auswahlliste entfernen:
$GLOBALS['TCA']['tt_content']['columns']['CType']['config']['items'] = array_filter(
    $GLOBALS['TCA']['tt_content']['columns']['CType']['config']['items'],
    fn($item) => $item['value'] !== 'caminotestimonial'
);
```

---

### Wo finde ich die Bild-Crop-Varianten?

Crop-Varianten sind in den TCA-Overrides definiert:
`vendor/typo3/theme-camino/Configuration/TCA/Overrides/99_sys_file_reference.php`

Eigene Varianten in deinem Sitepackage überschreiben.

---

### Wie debugge ich Fluid-Templates?

```html
<!-- Variable ausgeben -->
<f:debug>{data}</f:debug>

<!-- Alle verfügbaren Variablen -->
<f:debug>{_all}</f:debug>

<!-- Inline -->
{data -> f:debug()}
```

---

### Kann ich das Theme ohne Sitepackage anpassen?

Nicht empfohlen. Der `vendor/`-Ordner wird bei `composer update` überschrieben. Immer ein eigenes Sitepackage erstellen, das Camino erweitert.

## Links

- [TYPO3 Fluid Documentation](https://docs.typo3.org/m/typo3/reference-coreapi/main/en-us/ApiOverview/Fluid/Index.html)
- [TYPO3 Site Sets](https://docs.typo3.org/m/typo3/reference-coreapi/main/en-us/ApiOverview/SiteHandling/SiteSets.html)
- [Content Elements](https://docs.typo3.org/m/typo3/reference-coreapi/main/en-us/ApiOverview/ContentElements/Index.html)
