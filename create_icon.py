#!/usr/bin/env python3
"""
Simple script to create a Momentum app icon with a growth chart design.
Requires: pip install pillow
"""

from PIL import Image, ImageDraw

def create_app_icon():
    # Configuration
    size = 1024
    background_color = (99, 102, 241)  # #6366F1 Indigo
    arrow_color = (255, 255, 255)  # White
    
    # Create image with background
    img = Image.new('RGBA', (size, size), background_color + (255,))
    draw = ImageDraw.Draw(img)
    
    # Calculate coordinates for growth arrow
    margin = 200  # Space from edges
    line_width = 60
    
    # Draw trending up line (growth chart)
    points = [
        (margin, size - margin),           # Bottom left
        (size // 3, size - margin - 150),  # First rise
        (size // 2, size - margin - 100),  # Dip
        (size - margin - 100, margin + 100)  # Final high point
    ]
    
    # Draw the line
    for i in range(len(points) - 1):
        draw.line([points[i], points[i + 1]], fill=arrow_color, width=line_width)
    
    # Draw arrow head at the end
    arrow_tip = points[-1]
    arrow_size = 100
    
    # Arrow triangle
    arrow_points = [
        arrow_tip,  # Tip
        (arrow_tip[0] - arrow_size, arrow_tip[1] - arrow_size // 2),  # Left
        (arrow_tip[0] - arrow_size, arrow_tip[1] + arrow_size // 2),  # Right
    ]
    draw.polygon(arrow_points, fill=arrow_color)
    
    # Add dots on the line for data points
    dot_radius = 40
    for point in points:
        draw.ellipse([
            point[0] - dot_radius,
            point[1] - dot_radius,
            point[0] + dot_radius,
            point[1] + dot_radius
        ], fill=arrow_color)
    
    # Save main icon
    img.save('assets/icon/app_icon.png', 'PNG')
    print("✅ Created: assets/icon/app_icon.png")
    
    # Create foreground version (same for adaptive icons)
    # For adaptive icon, make background transparent
    img_foreground = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw_fg = ImageDraw.Draw(img_foreground)
    
    # Draw same arrow on transparent background
    for i in range(len(points) - 1):
        draw_fg.line([points[i], points[i + 1]], fill=arrow_color, width=line_width)
    
    draw_fg.polygon(arrow_points, fill=arrow_color)
    
    for point in points:
        draw_fg.ellipse([
            point[0] - dot_radius,
            point[1] - dot_radius,
            point[0] + dot_radius,
            point[1] + dot_radius
        ], fill=arrow_color)
    
    img_foreground.save('assets/icon/app_icon_foreground.png', 'PNG')
    print("✅ Created: assets/icon/app_icon_foreground.png")
    
    print("\n🎉 Icons created successfully!")
    print("\nNext steps:")
    print("1. Run: flutter pub get")
    print("2. Run: dart run flutter_launcher_icons")
    print("3. Run: flutter clean && flutter run")

if __name__ == "__main__":
    try:
        create_app_icon()
    except ImportError:
        print("❌ Error: Pillow not installed")
        print("Install it with: pip install pillow")
    except Exception as e:
        print(f"❌ Error: {e}")
