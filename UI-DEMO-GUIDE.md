# UI Demonstration Guide - Clash Party macOS

## Quick Start Guide for Reviewing UI Improvements

This guide helps you experience and evaluate the UI improvements made to Clash Party's macOS Swift version.

## Prerequisites

- macOS 13.0 (Ventura) or later
- Xcode 15.0 or later
- Git

## How to Build and Run

### 1. Clone and Open Project

```bash
# Clone the repository
git clone https://github.com/Zijinn/clash-party.git
cd clash-party

# Checkout the UI improvements branch
git checkout copilot/improve-macos-ui

# Open in Xcode
open ClashParty.xcodeproj
```

### 2. Build the Application

In Xcode:
1. Select the **ClashParty** scheme in the toolbar
2. Choose your Mac as the destination
3. Press **⌘R** or click the ▶️ Run button
4. Wait for build to complete (first build may take a minute)

### 3. First Launch

The app will launch and you'll immediately see the improved UI:
- Beautiful gradient app icon in the sidebar
- Modern dashboard view
- Professional card-based layouts

## UI Tour - What to Look For

### 🏠 Overview Screen (Main Dashboard)

**What's New:**
1. **Hero Section**
   - Large gradient network shield icon (blue to purple gradient)
   - Professional typography with the app name
   - Subtle tagline below

2. **Status Card**
   - GroupBox with elegant border
   - Animated status indicator (pulsing green/red dot)
   - Large, prominent Start/Stop button
   - Color changes: Green for start, Red for stop

3. **Traffic Statistics Card**
   - Side-by-side upload/download display
   - Color-coded icons (orange for upload, blue for download)
   - Large, readable speed values
   - Proper byte formatting (KB/s, MB/s)

4. **Quick Actions Grid**
   - 2×2 grid of action buttons
   - Each with gradient background
   - Smooth hover effects
   - Shadow and elevation on hover

**Try This:**
- Hover over the quick action buttons - notice the smooth animations
- Click Start/Stop - watch the status indicator change color
- Let it run and observe the traffic statistics update in real-time

### 🌐 Proxies Screen

**What's New:**
1. **Search & Filter Bar**
   - Magnifying glass icon on the left
   - Real-time search as you type
   - Type filter dropdown on the right
   - Clear button (X) appears when typing

2. **Proxy Cards**
   - Large colored icons specific to each proxy type
   - Type badge with matching colors
   - Latency display with speedometer icon
   - Status indicator (green dot = alive)
   - Hover effect: subtle scale up + shadow

3. **Empty State**
   - Helpful icon and message
   - Guides user on what to do next

**Try This:**
- Type in the search box - watch instant filtering
- Hover over a proxy card - see the smooth scale animation
- Right-click a proxy - context menu with actions
- Try different type filters

### 📄 Profiles Screen

**What's New:**
1. **Action Bar**
   - Description text on the left
   - Refresh button (circular arrow icon)
   - Prominent "Add Profile" button (blue, with plus icon)

2. **Grid Layout**
   - Responsive cards that adapt to window size
   - Professional elevation (shadows)
   - Cards grow on hover

3. **Profile Cards**
   - Large icon at top (checkmark seal for active)
   - "ACTIVE" badge in green
   - Green border for active profiles
   - Subscription URL preview with link icon
   - Action buttons at bottom
   - Update button disabled for local profiles

4. **Add Profile Modal**
   - Large dialog with professional layout
   - Icon + title header with description
   - Profile type selector (Subscription/Local)
   - Form fields with placeholders
   - Helpful hints below inputs
   - Dual action buttons (Cancel + Add)

**Try This:**
- Click "Add Profile" - see the beautiful modal
- Switch between Subscription and Local types
- Notice how fields appear/disappear
- Hover over profile cards - watch them lift up
- Try to submit with empty name - button is disabled

### 📋 Rules Screen

**What's New:**
1. **Mode Selector**
   - Segmented control at top (Rule/Global/Direct)
   - Rule count displayed on the right
   - Updates immediately on selection

2. **Search & Filter**
   - Search bar with clear button
   - Type dropdown with all rule types
   - Real-time filtering

3. **Rule Display**
   - Color-coded type badges:
     - Blue: DOMAIN
     - Cyan: DOMAIN-SUFFIX
     - Green: IP-CIDR
     - Orange: GEOIP
     - Purple: PROCESS-NAME
     - Red: MATCH
   - Payload in center
   - Destination proxy in badge on right
   - Right-click to copy

4. **Empty State**
   - Shows when no rules match filters
   - Large icon and helpful message

**Try This:**
- Switch proxy modes - see immediate update
- Filter by type - watch rules update
- Search for specific domains
- Right-click rules to copy
- Notice the consistent color coding

### 🔗 Connections Screen

**What's New:**
1. **Statistics Header**
   - Three-column layout
   - Active connection count
   - Total upload and download
   - All with proper formatting

2. **Search Bar**
   - Filter by host or IP
   - Clear button included
   - Real-time filtering

3. **Connection Rows**
   - Network type icon (different for TCP/UDP)
   - Host name prominent
   - Source → Destination with arrow
   - Upload/download with arrows
   - Process path when available
   - Context menu for actions

4. **Footer Actions**
   - "Close All" button (disabled when no connections)
   - Refresh button

**Try This:**
- Watch connections appear in real-time
- Right-click to close individual connections
- Try "Close All" button
- Search for specific hosts
- Notice upload/download arrows and formatting

### 🖥️ Logs Screen

**What's New:**
1. **Comprehensive Toolbar**
   - Search bar on left
   - Level filter (segmented control)
   - Auto-scroll toggle
   - Clear logs button
   - Export logs button

2. **Log Display**
   - Line numbers on left
   - Color-coded level indicators:
     - 🔴 Red: Errors
     - 🟠 Orange: Warnings
     - 🔵 Blue: Info
     - 🟣 Purple: Debug
     - ⚪ Gray: Other
   - Monospace font for readability
   - Zebra striping (alternating row colors)
   - Text selection enabled
   - Context menu to copy

3. **Footer**
   - Total log entry count
   - Quick refresh button

**Try This:**
- Toggle auto-scroll on/off
- Filter by log level
- Search for specific text
- Right-click to copy a log entry
- Try the export function
- Click Clear and watch logs clear

### 📁 Sidebar

**What's New:**
1. **App Branding**
   - Gradient shield icon at top
   - App name below
   - Real-time status indicator
   - Changes with proxy state

2. **Organized Navigation**
   - Grouped into sections (Main, Monitoring)
   - Better icon choices
   - Proper spacing
   - Badge support (for future notifications)

**Try This:**
- Watch the status update when starting/stopping proxy
- Notice the icon and color scheme
- Click between different views
- Use the sidebar toggle button in toolbar

## Detailed Feature Testing

### Animation & Interaction Testing

1. **Hover Effects**
   - Move mouse over any card
   - Should see smooth scale and shadow changes
   - Duration: ~0.2 seconds
   - Effect should feel natural, not jarring

2. **Button States**
   - Normal: Visible but not prominent
   - Hover: Slight highlight
   - Disabled: Grayed out, no pointer cursor
   - Active: Pressed appearance

3. **Status Changes**
   - Start proxy: Green appears, button changes
   - Stop proxy: Red appears, button changes
   - Transitions should be smooth

### Search & Filter Testing

1. **Proxy Search**
   - Type partial name
   - Should filter instantly
   - Clear button should appear
   - Click X to clear and reset

2. **Rule Filtering**
   - Type in search
   - Change type filter
   - Both should work together
   - Count should update

3. **Connection Search**
   - Filter by host or IP
   - Should work while connections update
   - Real-time filtering

### Layout & Responsiveness

1. **Window Resizing**
   - Make window smaller
   - Profile grid should adjust columns
   - Lists should resize properly
   - No content should be cut off

2. **Sidebar**
   - Click sidebar toggle in toolbar
   - Should collapse/expand smoothly
   - Content should adjust

3. **Scroll Behavior**
   - Long lists should scroll smoothly
   - Logs with auto-scroll should jump to bottom
   - No lag or stuttering

## Comparison Checklist

Use this checklist to compare with the original UI:

### Visual Design
- [x] Modern, professional appearance
- [x] Consistent color scheme throughout
- [x] Proper use of icons (SF Symbols)
- [x] Clear visual hierarchy
- [x] Appropriate spacing and padding
- [x] Professional typography

### Layout
- [x] Card-based design for content
- [x] Grid layouts for collections
- [x] Proper grouping with GroupBox
- [x] Responsive to window size
- [x] Clear sections and divisions

### Interaction
- [x] Hover effects on interactive elements
- [x] Context menus for actions
- [x] Smooth animations
- [x] Clear disabled states
- [x] Keyboard shortcuts
- [x] Search and filter capabilities

### Information Display
- [x] Status indicators with color
- [x] Real-time updates
- [x] Proper data formatting
- [x] Helpful empty states
- [x] Clear error messages
- [x] Useful tooltips

### User Experience
- [x] Intuitive navigation
- [x] Clear call-to-actions
- [x] Helpful placeholder text
- [x] Logical information flow
- [x] Minimal clicks to accomplish tasks
- [x] Professional feel throughout

## Performance Testing

### Things to Monitor

1. **Memory Usage**
   - Open Activity Monitor
   - Find ClashParty process
   - Memory should stay reasonable (< 100MB idle)

2. **CPU Usage**
   - Should be low when idle (< 1%)
   - Brief spikes when updating are OK
   - No constant high CPU usage

3. **Responsiveness**
   - UI should never freeze
   - Animations should be smooth (60fps)
   - Search should be instant
   - Window resizing should be smooth

4. **Startup Time**
   - App should launch quickly (< 2 seconds)
   - Initial view should appear immediately
   - No long loading screens

## Dark Mode Testing

1. **Enable Dark Mode**
   ```
   System Settings → Appearance → Dark
   ```

2. **Verify:**
   - All text is readable
   - Colors adapt properly
   - Icons are visible
   - Shadows still work
   - Hover effects still visible
   - No hardcoded colors showing

3. **Switch Back and Forth**
   - Should update immediately
   - No visual glitches
   - All elements adapt

## Accessibility Testing

### Keyboard Navigation

1. **Tab Through Controls**
   - Press Tab repeatedly
   - Should visit all interactive elements
   - Focus should be visible
   - Order should be logical

2. **Activate with Keyboard**
   - Space bar activates buttons
   - Enter submits forms
   - Escape closes modals
   - Arrow keys work in pickers

### VoiceOver (Optional)

1. **Enable VoiceOver**
   - Press ⌘F5
   - Or System Settings → Accessibility → VoiceOver

2. **Navigate App**
   - All elements should be announced
   - Labels should be meaningful
   - Status changes should be announced
   - Structure should be clear

## Common Issues & Solutions

### Build Errors

**Issue:** "Command CompileSwiftSources failed"
**Solution:** 
- Clean build folder (⌘⇧K)
- Rebuild (⌘B)

**Issue:** Missing dependencies
**Solution:**
- Update Xcode
- Check minimum macOS version (13.0)

### Runtime Issues

**Issue:** App launches but shows blank window
**Solution:**
- Check Console.app for errors
- Verify entitlements are set
- Try running in Debug mode

**Issue:** Animations are choppy
**Solution:**
- Check Activity Monitor for CPU usage
- Close other apps
- Restart Mac if needed

## Screenshots to Take

For documentation purposes, capture:

1. **Overview Screen** - Full window
2. **Proxies View** - Showing cards
3. **Profiles Grid** - Multiple profiles
4. **Add Profile Modal** - The dialog
5. **Rules View** - With colored badges
6. **Connections View** - Active connections
7. **Logs View** - With different log levels
8. **Sidebar** - Both light and dark mode
9. **Hover States** - Card with hover effect
10. **Empty States** - Each view when empty

## Feedback

When reviewing, consider:

### What Works Well
- Visual appeal
- Ease of use
- Information clarity
- Performance
- Consistency

### What Could Improve
- Any confusing elements
- Missing features
- Performance issues
- Visual inconsistencies
- Accessibility problems

## Summary of Improvements

### Before
- Basic lists
- Minimal visual design
- Limited interactivity
- No search/filter
- Simple layouts
- No empty states

### After
- Modern card designs
- Professional visual design
- Rich hover effects and animations
- Advanced search/filter everywhere
- Responsive grid and card layouts
- Helpful empty states with guidance
- Color-coded information
- Context menus
- Better information hierarchy
- Professional status indicators
- Real-time updates
- Smooth transitions

## Conclusion

The UI improvements transform Clash Party from a basic functional tool into a polished, professional macOS application. The new design:

- **Looks Professional**: Modern, clean, consistent design
- **Feels Native**: True macOS experience with native controls
- **Works Better**: Enhanced functionality with search and filters
- **Guides Users**: Empty states and hints throughout
- **Performs Well**: Smooth animations and efficient rendering
- **Scales Well**: Responsive layouts adapt to window size

Take your time exploring each view and experiencing the improvements. The attention to detail in spacing, colors, icons, and animations creates a cohesive, polished experience that users will appreciate.

---

## Quick Reference

### Keyboard Shortcuts
- **⌘R** - Refresh current view
- **⌘F** - Focus search field
- **⌘N** - New profile
- **⌘,** - Open settings
- **⌘W** - Close window
- **⌘Q** - Quit app
- **Tab** - Navigate controls
- **Space** - Activate button
- **Escape** - Close dialog

### Visual Legend
- 🟢 Green = Running/Active/Alive
- 🔴 Red = Stopped/Error
- 🟠 Orange = Warning/Upload
- 🔵 Blue = Info/Download
- 🟣 Purple = Debug
- ⚪ Gray = Inactive

### Color Coding
- **Shadowsocks**: Blue
- **VMess**: Purple
- **Trojan**: Red
- **SOCKS5**: Orange
- **HTTP/HTTPS**: Green

Enjoy exploring the improved UI! 🎉
