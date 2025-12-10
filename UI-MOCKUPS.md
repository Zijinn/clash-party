# UI Mockups - Clash Party macOS Swift Version

This document provides visual mockups of the improved UI using ASCII art and detailed descriptions.

## Main Window Layout

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│  ☰  Clash Party                                                        ⚙️  ⓘ     │
├───────────────┬─────────────────────────────────────────────────────────────────┤
│               │                                                                 │
│  ╭─────────╮  │                     Clash Party                                │
│  │  🛡️💙   │  │                                                                 │
│  ╰─────────╯  │              Mihomo Proxy Management                           │
│               │                                                                 │
│ Clash Party   │   ╭──────────────────────────────────────────────────────╮    │
│               │   │  🔌 Proxy Status                                      │    │
│   🟢 Running  │   │                                                       │    │
│               │   │            ● Running                                  │    │
│───────────────│   │        [🛑 Stop Proxy]                               │    │
│               │   ╰──────────────────────────────────────────────────────╯    │
│ Main          │                                                                 │
│ 📊 Overview   │   ╭──────────────────────────────────────────────────────╮    │
│ 🌐 Proxies    │   │  📈 Network Traffic                                   │    │
│ 📄 Profiles   │   │                                                       │    │
│               │   │    🔼 Upload          │       🔽 Download             │    │
│ Monitoring    │   │    123.4 KB/s         │       456.7 KB/s             │    │
│ 📋 Rules      │   ╰──────────────────────────────────────────────────────╯    │
│ 🔗 Connections│                                                                 │
│ 🖥️  Logs      │   ╭──────────────────────────────────────────────────────╮    │
│               │   │  ⚡ Quick Actions                                      │    │
│               │   │                                                       │    │
│               │   │  [🌐 Proxies]  [📄 Profiles]                         │    │
│               │   │  [📋 Rules]    [🔗 Connections]                       │    │
│               │   ╰──────────────────────────────────────────────────────╯    │
│               │                                                                 │
└───────────────┴─────────────────────────────────────────────────────────────────┘
```

## Proxies View

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│  Proxies (42)                                                                    │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                  │
│  🔍 Search proxies...            ▼ Type: All                                    │
│                                                                                  │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                  │
│  ╭────────────────────────────────────────────────────────────╮                │
│  │  ┌──────┐                                                   │                │
│  │  │  🛡️  │  US-Node-01                            🟢         │                │
│  │  │ BLUE │  [Shadowsocks]  [145ms]                          │                │
│  │  └──────┘                                                   │                │
│  ╰────────────────────────────────────────────────────────────╯                │
│                                                                                  │
│  ╭────────────────────────────────────────────────────────────╮                │
│  │  ┌──────┐                                                   │                │
│  │  │  ✈️   │  HK-Premium-02                          🟢         │                │
│  │  │PURPLE│  [VMess]  [89ms]                                 │                │
│  │  └──────┘                                                   │                │
│  ╰────────────────────────────────────────────────────────────╯                │
│                                                                                  │
│  ╭────────────────────────────────────────────────────────────╮                │
│  │  ┌──────┐                                                   │                │
│  │  │  🏁  │  JP-Tokyo-Fast                           🟢         │                │
│  │  │ RED  │  [Trojan]  [67ms]                                │                │
│  │  └──────┘                                                   │                │
│  ╰────────────────────────────────────────────────────────────╯                │
│                                                                                  │
└─────────────────────────────────────────────────────────────────────────────────┘
```

## Profiles View

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│  Profiles (3)                                                                    │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                  │
│  Manage your proxy profiles          [🔄 Refresh]  [➕ Add Profile]            │
│                                                                                  │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                  │
│  ╭─────────────────────────────╮  ╭─────────────────────────────╮             │
│  │  ✅        [ACTIVE]          │  │  📄                         │             │
│  │                              │  │                             │             │
│  │  My Main Profile             │  │  Backup Profile            │             │
│  │  🔗 https://sub.example...   │  │  📍 Local profile          │             │
│  │  ─────────────────────────   │  │  ─────────────────────────  │             │
│  │  [✏️ Edit]  [🔄 Update]      │  │  [✏️ Edit]  [▶️ Activate]   │             │
│  ╰─────────────────────────────╯  ╰─────────────────────────────╯             │
│                                                                                  │
│  ╭─────────────────────────────╮                                               │
│  │  📄                         │                                               │
│  │                             │                                               │
│  │  Test Profile               │                                               │
│  │  🔗 https://test.sub...     │                                               │
│  │  ─────────────────────────   │                                               │
│  │  [✏️ Edit]  [🔄 Update]     │                                               │
│  ╰─────────────────────────────╯                                               │
│                                                                                  │
└─────────────────────────────────────────────────────────────────────────────────┘
```

## Add Profile Modal

```
        ╭────────────────────────────────────────────╮
        │                                            │
        │  📄   Add New Profile                      │
        │       Create a new proxy configuration     │
        │                                            │
        │  ───────────────────────────────────────   │
        │                                            │
        │  Profile Type                              │
        │  ┌──────────────────┬──────────────────┐  │
        │  │ Subscription URL │   Local File     │  │
        │  └──────────────────┴──────────────────┘  │
        │                                            │
        │  Profile Name                              │
        │  ┌────────────────────────────────────┐   │
        │  │ Enter a descriptive name           │   │
        │  └────────────────────────────────────┘   │
        │                                            │
        │  Subscription URL                          │
        │  ┌────────────────────────────────────┐   │
        │  │ https://example.com/subscription   │   │
        │  └────────────────────────────────────┘   │
        │                                            │
        │  ℹ️  Enter the subscription link from     │
        │     your proxy provider                    │
        │                                            │
        │  ───────────────────────────────────────   │
        │                                            │
        │  [Cancel]              [✓ Add Profile]    │
        │                                            │
        ╰────────────────────────────────────────────╯
```

## Rules View

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│  Rules                                                                           │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                  │
│  Proxy Mode:  ┌──────┬────────┬────────┐                    142 rules          │
│               │ Rule │ Global │ Direct │                                        │
│               └──────┴────────┴────────┘                                        │
│                                                                                  │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                  │
│  🔍 Search rules...                              ▼ Type: All                    │
│                                                                                  │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                  │
│  [DOMAIN]           google.com                    ➡️ Proxy-US-01               │
│  [DOMAIN-SUFFIX]    .twitter.com                  ➡️ Proxy-US-02               │
│  [IP-CIDR]          192.168.1.0/24                ➡️ DIRECT                    │
│  [GEOIP]            CN                            ➡️ DIRECT                    │
│  [PROCESS-NAME]     Telegram                      ➡️ Proxy-HK-01               │
│  [MATCH]            All                           ➡️ Proxy-Default              │
│                                                                                  │
└─────────────────────────────────────────────────────────────────────────────────┘
```

## Connections View

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│  Connections                                                                     │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                  │
│        Active Connections          Total Upload          Total Download         │
│              42                      1.2 GB                  5.8 GB             │
│                                                                                  │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                  │
│  🔍 Search connections...                                                       │
│                                                                                  │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                  │
│  🌐  api.openai.com                                       Proxy-US-01           │
│      192.168.1.100:52341 ➡️  52.44.96.33:443                                   │
│      Process: /Applications/Safari.app      ⬆️ 12 KB  ⬇️ 845 KB                │
│                                                                                  │
│  🌐  github.com                                           DIRECT                │
│      192.168.1.100:52342 ➡️  140.82.113.4:443                                  │
│      Process: /Applications/Safari.app      ⬆️ 8 KB   ⬇️ 234 KB                │
│                                                                                  │
│  🌐  twitter.com                                          Proxy-HK-02           │
│      192.168.1.100:52343 ➡️  104.244.42.1:443                                  │
│                                                ⬆️ 15 KB  ⬇️ 1.2 MB              │
│                                                                                  │
├─────────────────────────────────────────────────────────────────────────────────┤
│  [Close All]                                              [Refresh]             │
└─────────────────────────────────────────────────────────────────────────────────┘
```

## Logs View

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│  Logs                                                                            │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                  │
│  🔍 Search...   [All|Debug|Info|Warning|Error]  ⚙️ Auto-scroll  [🗑️][📤]      │
│                                                                                  │
├─────────────────────────────────────────────────────────────────────────────────┤
│   1  🔵  [INFO] Clash Party started successfully                               │
│   2  🔵  [INFO] Loading configuration from disk                                │
│   3  🟣  [DEBUG] Found 3 profiles in configuration                             │
│   4  🔵  [INFO] Mihomo core started on port 7890                               │
│   5  🟠  [WARNING] Profile update check failed: network timeout                │
│   6  🔵  [INFO] System proxy enabled                                           │
│   7  🔵  [INFO] Connected to api.openai.com via Proxy-US-01                    │
│   8  🟣  [DEBUG] Traffic: ⬆️ 12.4 KB ⬇️ 845.2 KB                                │
│   9  🔴  [ERROR] Failed to connect to proxy server: timeout                    │
│  10  🔵  [INFO] Switched to backup proxy Proxy-US-02                           │
│  11  🔵  [INFO] Connection established successfully                            │
│  12  🟣  [DEBUG] Current upload speed: 125.4 KB/s                              │
│  13  🟣  [DEBUG] Current download speed: 456.7 KB/s                            │
│                                                                                  │
├─────────────────────────────────────────────────────────────────────────────────┤
│  📄 13 log entries                                         [Refresh]            │
└─────────────────────────────────────────────────────────────────────────────────┘
```

## Color Legend

### Status Indicators
- 🟢 Green: Running / Active / Alive / Success
- 🔴 Red: Stopped / Error / Failed
- 🟠 Orange: Warning
- ⚪ Gray: Inactive / Disabled
- 🔵 Blue: Info / Normal operation
- 🟣 Purple: Debug information

### Proxy Types
- 🛡️ Blue: Shadowsocks
- ✈️ Purple: VMess
- 🏁 Red: Trojan
- 🔄 Orange: SOCKS5
- 🌐 Green: HTTP/HTTPS

### Icons Used
- 📊 Dashboard/Overview/Charts
- 🌐 Network/Proxy/Internet
- 📄 Documents/Profiles
- 📋 Lists/Rules
- 🔗 Connections/Links
- 🖥️ Terminal/Logs
- ⚙️ Settings/Configuration
- 🔍 Search
- 🔄 Refresh/Reload
- ➕ Add
- ✏️ Edit
- 🗑️ Delete/Clear
- 📤 Export
- ⬆️ Upload
- ⬇️ Download
- ➡️ Forward/Next
- ✅ Active/Checked
- 🛡️ Shield/Security
- ⚡ Quick/Fast
- ℹ️ Information
- ⚠️ Warning

## Interactive Elements

### Hover Effects
All interactive elements have hover states:
- **Cards**: Subtle scale (1.0 → 1.02) + shadow increase
- **Buttons**: Background color change + cursor pointer
- **Rows**: Background highlight

### Context Menus
Right-click reveals contextual actions:
- **Proxy Cards**: Test Latency, Copy Name, Edit, Delete
- **Profile Cards**: Activate, Edit, Update, Delete
- **Connections**: Close Connection, Copy Host, Copy IP
- **Rules**: Copy Rule, Copy Payload
- **Log Rows**: Copy Log Entry

### Drag and Drop
Future enhancement: Reorder profiles and rules with drag-and-drop

## Responsive Behavior

### Window Sizes
- **Minimum**: 900×650 px
- **Comfortable**: 1200×800 px
- **Optimal**: 1400×900 px

### Sidebar
- **Width**: 220px fixed
- **Collapsible**: Via toolbar button
- **Minimum**: Can collapse to icon-only mode

### Grid Layouts
- **Profiles**: 1-3 columns depending on width
- **Quick Actions**: 2×2 grid, fixed

### Lists
- **Auto-scrolling**: Enabled for logs and connections
- **Virtualization**: LazyVStack/LazyVGrid for performance

## Accessibility Features

### Keyboard Navigation
- **Tab**: Navigate between controls
- **Space**: Activate buttons
- **⌘N**: New profile
- **⌘R**: Refresh
- **⌘F**: Focus search
- **⌘W**: Close window
- **⌘,**: Open settings

### VoiceOver Support
- All controls properly labeled
- Status changes announced
- Navigation hierarchy clear

### Reduced Motion
- Respects system preference
- Falls back to simple transitions

## Dark Mode

All views support both Light and Dark modes:
- Automatic color adaptation
- Proper contrast ratios
- Semantic colors throughout
- No hardcoded colors

### Dark Mode Colors
- **Background**: System background (dark gray)
- **Cards**: Slightly lighter gray
- **Text**: White/light gray
- **Accent**: Blue (adjusts for dark mode)
- **Borders**: Subtle gray

## Implementation Notes

### Performance
- Lazy loading for all lists
- Efficient state management
- Minimal re-renders
- Native SwiftUI rendering

### Memory
- Proper resource cleanup
- No retain cycles
- Efficient image caching
- Controlled log history

### Battery
- Efficient updates
- No unnecessary polling
- Background throttling
- Native animations only

## Summary

These mockups demonstrate the comprehensive UI improvements:

1. **Professional appearance** - Modern, polished design
2. **Clear hierarchy** - Visual organization makes information easy to find
3. **Rich interactions** - Hover effects, context menus, drag-and-drop ready
4. **Better feedback** - Clear status indicators and color coding
5. **Efficient workflows** - Search, filter, and quick actions throughout
6. **Consistent design** - Unified visual language across all views
7. **Native experience** - Feels like a native macOS application
8. **Accessibility** - Keyboard shortcuts and VoiceOver support

The UI transforms Clash Party from a functional utility into a beautiful, professional macOS application that users will enjoy using daily.
