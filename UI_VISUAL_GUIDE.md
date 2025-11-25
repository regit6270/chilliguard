# Disease Detection UI - Visual Guide

## Screen Layout Preview

```
┌─────────────────────────────────────────┐
│  ← Disease Detection              ⋮     │
├─────────────────────────────────────────┤
│                                         │
│     [  Disease Image Preview  ]         │
│         (tap to enlarge)                │
│                                         │
├─────────────────────────────────────────┤
│  [ 📷 Gallery ]    [ 📸 Camera ]       │
│  [ 🔍 Detect  ]    [ 🗑️  Clear ]       │
├─────────────────────────────────────────┤
│                                         │
│  ┌───────────────────────────────────┐  │
│  │     92%                           │  │
│  │                                   │  │
│  │  Bacterial Spot (Pepper)          │  │
│  │  Xanthomonas spp.                 │  │
│  │                                   │  │
│  │  [ High ] [ 25.5% affected ]     │  │
│  └───────────────────────────────────┘  │
│                                         │
│  ┌───────────────────────────────────┐  │
│  │ Bacterial disease causing         │  │
│  │ necrotic leaf and fruit spots...  │  │
│  └───────────────────────────────────┘  │
│                                         │
│  ┌─ 🦠 Causes ──────────────────────┐  │
│  │  • Xanthomonas spp. infection    │  │
│  │    (seed-, transplant- and       │  │
│  │    splash-borne)                 │  │
│  │  • Warm, humid weather with      │  │
│  │    rain-splash dissemination     │  │
│  └───────────────────────────────────┘  │
│                                         │
│  ┌─ 👁️  Symptoms ──────────────────┐  │
│  │  • Small water-soaked lesions    │  │
│  │    on leaves and fruits          │  │
│  │  • Brown/black circular spots    │  │
│  │    with yellow halos             │  │
│  │  • Premature leaf yellowing      │  │
│  │    and defoliation               │  │
│  └───────────────────────────────────┘  │
│                                         │
│  ┌─ 💊 Treatment Options ───────────┐  │
│  │                                   │  │
│  │  ┌─ Chemical ──────────────────┐ │  │
│  │  │ 🔬 Chemical                  │ │  │
│  │  │                              │ │  │
│  │  │ Copper oxychloride           │ │  │
│  │  │ Reduces surface inoculum...  │ │  │
│  │  │                              │ │  │
│  │  │ ┌──────────────────────────┐ │ │  │
│  │  │ │ 📏 Dosage: 2-3 g/L       │ │ │  │
│  │  │ │ 🕐 Frequency: Every 7-10 │ │ │  │
│  │  │ │    days during epidemic  │ │ │  │
│  │  │ └──────────────────────────┘ │ │  │
│  │  └──────────────────────────────┘ │  │
│  │                                   │  │
│  │  ┌─ Foliar Spray ──────────────┐ │  │
│  │  │ 💧 Foliar Spray              │ │  │
│  │  │                              │ │  │
│  │  │ Streptocycline + copper      │ │  │
│  │  │ Bactericidal foliar spray... │ │  │
│  │  │                              │ │  │
│  │  │ ┌──────────────────────────┐ │ │  │
│  │  │ │ 📏 Dosage: 200-300 ppm   │ │ │  │
│  │  │ │ 🕐 Frequency: 7-10 days  │ │ │  │
│  │  │ └──────────────────────────┘ │ │  │
│  │  └──────────────────────────────┘ │  │
│  │                                   │  │
│  │  ┌─ Organic ────────────────────┐ │  │
│  │  │ 🌿 Organic                   │ │  │
│  │  │                              │ │  │
│  │  │ Bacillus subtilis / neem oil │ │  │
│  │  │ Biocontrol agents and neem...│ │  │
│  │  │                              │ │  │
│  │  │ ┌──────────────────────────┐ │ │  │
│  │  │ │ 📏 Dosage: 5-10 ml/L     │ │ │  │
│  │  │ │ 🕐 Frequency: Weekly     │ │ │  │
│  │  │ └──────────────────────────┘ │ │  │
│  │  └──────────────────────────────┘ │  │
│  │                                   │  │
│  │  ┌─ Micronutrients ─────────────┐ │  │
│  │  │ 🌸 Micronutrients            │ │  │
│  │  │                              │ │  │
│  │  │ Zinc sulphate foliar spray   │ │  │
│  │  │ Corrects zinc deficiency...  │ │  │
│  │  │                              │ │  │
│  │  │ ┌──────────────────────────┐ │ │  │
│  │  │ │ 📏 Dosage: 0.5-1 g/L     │ │ │  │
│  │  │ │ 🕐 Frequency: Once at    │ │ │  │
│  │  │ │    early growth          │ │ │  │
│  │  │ └──────────────────────────┘ │ │  │
│  │  └──────────────────────────────┘ │  │
│  └───────────────────────────────────┘  │
│                                         │
│  ┌─ 💡 Recommendations ──────────────┐  │
│  │  • Use certified disease-free    │  │
│  │    seed/seedlings                │  │
│  │  • Avoid overhead irrigation     │  │
│  │  • Maintain plant spacing        │  │
│  │  • Rogue and destroy infected    │  │
│  │    plants                        │  │
│  └───────────────────────────────────┘  │
│                                         │
│  ┌─ 📚 References & Sources ─────────┐  │
│  │  ┌─────────────────────────────┐  │  │
│  │  │ 📄 ICAR-Indian Agricultural │  │  │
│  │  │    Research Institute...    │  │  │
│  │  └─────────────────────────────┘  │  │
│  │  ┌─────────────────────────────┐  │  │
│  │  │ 📄 TNAU / Regional Centre   │  │  │
│  │  │    studies on bacterial...  │  │  │
│  │  └─────────────────────────────┘  │  │
│  └───────────────────────────────────┘  │
│                                         │
│  ▼ Raw response                         │
│                                         │
└─────────────────────────────────────────┘
```

## Color Scheme

### Section Colors

| Section | Background | Text Color | Icon | Purpose |
|---------|-----------|------------|------|---------|
| **Causes** | Light Red (#FFEBEE) | Dark Red (#B71C1C) | 🦠 Coronavirus | Warning about disease triggers |
| **Symptoms** | Light Orange (#FFF3E0) | Dark Orange (#E65100) | 👁️ Visibility | Attention to what to look for |
| **Treatments** | White | Green (#2E7D32) | 💊 Medical | Hope and healing |
| **Recommendations** | Light Purple (#F3E5F5) | Dark Purple (#4A148C) | 💡 Lightbulb | Wisdom and guidance |
| **Sources** | Light Blue (#E3F2FD) | Dark Blue (#0D47A1) | 📚 Source | Trust and authority |

### Treatment Type Colors

| Type | Color | Icon | Hex Code |
|------|-------|------|----------|
| **Chemical** | Deep Purple | 🔬 Science | #673AB7 |
| **Organic** | Green | 🌿 Eco | #4CAF50 |
| **Foliar Spray** | Blue | 💧 Water Drop | #2196F3 |
| **Micronutrients** | Orange | 🌸 Flower | #FF9800 |
| **Other** | Grey | 💊 Medical | #757575 |

## Component Breakdown

### Treatment Card Structure

```
┌─────────────────────────────────┐
│ ┌────────────────┐              │  ← Type Badge (colored)
│ │ 🔬 Chemical    │              │
│ └────────────────┘              │
│                                 │
│ Copper oxychloride              │  ← Treatment Name (bold)
│                                 │
│ Reduces surface inoculum and    │  ← Description (grey text)
│ prevents new infections.        │
│                                 │
│ ┌─────────────────────────────┐ │  ← Info Box (white background)
│ │ 📏 Dosage: 2-3 g/L          │ │
│ │ 🕐 Frequency: Every 7-10    │ │
│ │    days during epidemic     │ │
│ └─────────────────────────────┘ │
└─────────────────────────────────┘
```

### Section Header Pattern

```
┌─────────────────────────────────┐
│ [Icon] Section Title            │  ← Icon + Bold Title
│                                 │
│ • Bullet point 1                │  ← Content with bullets
│ • Bullet point 2                │
│ • Bullet point 3                │
└─────────────────────────────────┘
```

## Responsive Design

- All cards use `SingleChildScrollView` for long content
- Cards have consistent 12px border radius
- Padding: 14px for card content
- Spacing between sections: 12px
- Margins: 12px horizontal for cards

## Interactive Elements

1. **Image Preview**: Tap to open full-screen zoomable view
2. **Gallery/Camera Buttons**: Pick image from gallery or take photo
3. **Detect Button**: Analyze the selected image
4. **Clear Button**: Remove selected image
5. **Raw Response**: Expandable section for debugging

## Typography

- **Section Headers**: 16px, Bold, Section Color
- **Treatment Names**: 16px, Bold, Black87
- **Body Text**: 14px, Regular, Grey[700]
- **Card Text**: 14px, Regular, Section Color
- **Info Labels**: 13px, SemiBold, Grey[700]
- **Info Values**: 13px, Regular, Black87

## Accessibility Features

✅ Sufficient color contrast (WCAG AA compliant)
✅ Clear visual hierarchy
✅ Icon + text labels for better understanding
✅ Readable font sizes (minimum 13px)
✅ Proper spacing for tap targets
✅ Scrollable content areas
✅ Clear section separation

## Before vs After

### Before
- Plain text lists
- No visual hierarchy
- Basic treatment display
- Missing causes section
- Missing sources section
- No color coding
- Limited visual appeal

### After
- ✨ Color-coded sections
- ✨ Icon-based headers
- ✨ Enhanced treatment cards with type badges
- ✨ Dedicated causes section
- ✨ Professional sources display
- ✨ Better visual hierarchy
- ✨ Modern, clean design
- ✨ Improved scannability

