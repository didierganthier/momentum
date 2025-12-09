# App Icon Setup Guide

## 📱 Icon Requirements

To use the growth chart icon as your app icon, you need to create two PNG images:

### 1. Main Icon: `app_icon.png`
- **Size**: 1024x1024 pixels
- **Format**: PNG with transparency
- **Content**: The growth chart/trending up arrow icon
- **Background**: Transparent OR solid color (#6366F1 indigo)

### 2. Adaptive Icon Foreground: `app_icon_foreground.png` (Android)
- **Size**: 1024x1024 pixels
- **Format**: PNG with transparency
- **Content**: Same growth chart icon, but centered in safe zone
- **Safe Zone**: Keep icon within central 66% (684x684px)

## 🎨 Design Recommendations

### Style Options:

**Option 1: Minimalist (Recommended)**
- White growth arrow on indigo (#6366F1) background
- Clean, modern look
- Works well on all backgrounds

**Option 2: Gradient**
- Arrow with gradient from indigo to purple
- Transparent background
- More dynamic appearance

**Option 3: Badge Style**
- Growth arrow in a circular badge
- Drop shadow for depth
- Professional appearance

## 🛠️ How to Create the Icons

### Using Design Tools:

1. **Figma/Sketch** (Recommended):
   ```
   1. Create 1024x1024 artboard
   2. Draw growth arrow (trending up)
   3. Use #6366F1 (indigo) as primary color
   4. Export as PNG at 1x (@1x)
   ```

2. **Canva** (Easy):
   ```
   1. Create custom size: 1024x1024
   2. Add icons > Search "growth chart"
   3. Customize colors to match app
   4. Download as PNG (transparent background)
   ```

3. **Online Icon Makers**:
   - https://www.appicon.co/
   - https://makeappicon.com/
   - https://icon.kitchen/

## 📂 File Placement

Place your created icons here:
```
assets/icon/
  ├── app_icon.png              (1024x1024, main icon)
  └── app_icon_foreground.png   (1024x1024, Android adaptive)
```

## 🚀 Quick Setup (If You Have the Icons)

If you already have 1024x1024 PNG files ready:

1. **Save your icons:**
   - Main icon as: `assets/icon/app_icon.png`
   - Foreground as: `assets/icon/app_icon_foreground.png`

2. **Generate launcher icons:**
   ```bash
   flutter pub get
   dart run flutter_launcher_icons
   ```

3. **Rebuild the app:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

## 🎯 Using the Fluent Emoji Growth Chart

Since you want to use the growth chart emoji/icon (📈):

### Quick Method:
1. Go to https://icon.kitchen/
2. Choose "Clipart" > Search "growth chart"
3. Set background color to #6366F1
4. Set icon color to white
5. Download as 1024x1024 PNG
6. Save as `app_icon.png` and `app_icon_foreground.png`

### Custom Method:
Create a simple design with:
- Canvas: 1024x1024px
- Background: #6366F1 (indigo)
- Icon: White trending-up arrow
- Arrow: Starts bottom-left, goes up-right
- Dot/circle at the end of arrow
- Stroke width: 80-120px

## 🎨 Color Palette

Match your app theme:
- **Primary**: #6366F1 (Indigo)
- **Accent**: #818CF8 (Light Indigo)
- **White**: #FFFFFF
- **Dark**: #1E1B4B (Dark Indigo)

## ✅ Verification

After generating, check:
- [ ] Android: Check all mipmap folders have new icons
- [ ] iOS: Check AppIcon.appiconset has new images
- [ ] Icon looks good on light backgrounds
- [ ] Icon looks good on dark backgrounds
- [ ] Icon is recognizable at small sizes (20x20)

## 📝 Notes

- The configuration is already set up in `pubspec.yaml`
- Background color is set to #6366F1 (your app's indigo theme)
- iOS icons will have alpha channel removed automatically
- Android will use adaptive icons with indigo background

---

**Need Help?**
- Visit: https://pub.dev/packages/flutter_launcher_icons
- Icon design inspiration: https://materialdesignicons.com/
