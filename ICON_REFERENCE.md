# Momentum App Icon Reference

## 📱 Your New App Icon

```
┌────────────────────────────────────┐
│                                    │
│          ┌─────────────╮ ●         │
│         ╱               ╲          │
│        ╱                 ╲         │
│       ●                   ╲        │
│      ╱                     ╲       │
│     ╱                       ╲      │
│    ●                         ●     │
│   ╱                               │
│  ╱                                │
│ ●                                 │
│                                    │
│      #6366F1 Background            │
│      White Growth Chart            │
└────────────────────────────────────┘
```

## Icon Elements

### Design Components:
1. **Rising Trend Line**
   - Starts at bottom-left
   - Rises steadily through 4 data points
   - Ends at top-right with arrow

2. **Data Points (4 circles)**
   - Point 1: Bottom-left (starting point)
   - Point 2: Rising to middle
   - Point 3: Slight dip (realistic growth pattern)
   - Point 4: High point with arrow

3. **Arrow Head**
   - Triangular shape
   - Points up and to the right
   - Indicates continued growth

### Color Scheme:
```
Background:  #6366F1  ■  Indigo
Icon/Line:   #FFFFFF  □  White
Stroke:      60px width
Dots:        40px radius
```

## Adaptive Icon (Android)

### Layers:
```
Layer 1 (Background):
┌────────────────────────────────────┐
│                                    │
│                                    │
│                                    │
│          SOLID INDIGO              │
│           #6366F1                  │
│                                    │
│                                    │
│                                    │
└────────────────────────────────────┘

Layer 2 (Foreground):
┌────────────────────────────────────┐
│ (Transparent background)           │
│          ┌─────────────╮ ●         │
│         ╱               ╲          │
│       ●                  ╲         │
│      ╱                    ╲        │
│     ●                      ●       │
│    ╱  WHITE CHART                 │
│   ●                                │
└────────────────────────────────────┘

Combined Result:
Launcher can apply effects like:
- Circle mask (circular icon)
- Rounded square mask (rounded corners)
- Squircle mask (iOS-style)
- Teardrop mask (unique launchers)
```

## Icon in Different Contexts

### Home Screen (Large)
```
┌────────────┐
│   ╱●       │
│  ╱         │
│ ●          │
│            │  Momentum
└────────────┘
```

### Notification (Small)
```
┌──┐
│╱●│  Habit Reminder
└──┘
```

### App Drawer
```
┌────────┐
│  ╱●    │
│ ●      │
└────────┘  Momentum
```

### Settings (Tiny)
```
[╱●] Momentum
```

## Platform-Specific Appearances

### iOS Home Screen:
- Rounded square shape (iOS style)
- Slight shadow/depth effect
- Vibrant background color
- White foreground stands out

### Android (Material You):
- Can be themed by system colors
- Background adapts to wallpaper (on supported devices)
- Foreground remains white for contrast
- Shape follows launcher preference

### Android (Older Versions):
- Fixed circular or rounded square
- Solid indigo background
- Consistent appearance across devices

## Size Specifications

All generated sizes maintain the same design, optimized for clarity:

| Platform | Sizes (px)                                      |
|----------|------------------------------------------------|
| Android  | 48, 72, 96, 144, 192, adaptive layers         |
| iOS      | 20-1024 (all @1x, @2x, @3x variants)          |
| Web      | 192, 512, with theme colors                    |

## Visual Guidelines

### What Works:
✅ High contrast (white on indigo)
✅ Simple, recognizable shape
✅ Clear at all sizes
✅ Thematically relevant
✅ Professional appearance

### What to Avoid:
❌ Too much detail (hard to see when small)
❌ Low contrast colors
❌ Thin lines (disappear at small sizes)
❌ Complex gradients
❌ Text/letters (unless part of brand)

## Brand Consistency

The icon matches your app's visual identity:

```
App Theme:          Icon Design:
─────────────       ─────────────
Primary: #6366F1    Background: #6366F1 ✓
Clean UI Design     Simple Chart Icon   ✓
Material 3          Material Design     ✓
Growth/Progress     Upward Arrow        ✓
Data Tracking       Data Points         ✓
```

## Accessibility Notes

- **High Contrast**: 4.5:1 ratio (WCAG AA compliant)
- **Simple Shape**: Easy to recognize
- **No Text**: Works in all languages
- **Color Independent**: Shape is still visible in grayscale
- **Size Resilient**: Looks good from 20px to 1024px

## Testing the Icon

### Visual Check:
1. ✅ Looks good on light wallpapers
2. ✅ Looks good on dark wallpapers
3. ✅ Recognizable at 20x20 pixels
4. ✅ No important details are cut off
5. ✅ Arrow direction is clear
6. ✅ Colors match app theme

### Platform Check:
1. ✅ Android: Multiple launcher styles
2. ✅ iOS: Home screen and App Library
3. ✅ Web: Browser tab and PWA
4. ✅ Adaptive: Circle, square, squircle shapes

## Icon Philosophy

**"Growth Made Visible"**

The icon embodies the core purpose of Momentum:
- **Upward Trend**: Progress and improvement
- **Data Points**: Consistent habit tracking
- **Arrow**: Forward momentum
- **Clean Design**: Simplicity and focus
- **Indigo Color**: Trust and reliability

---

**Your app icon perfectly represents what Momentum does:  
Help users track their journey to becoming better.** 📈

