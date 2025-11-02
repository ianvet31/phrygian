# User Interface Description

## App Screen Layout

The Phrygian guitar tuner app features a clean, intuitive single-screen interface designed for ease of use while tuning your guitar.

### Header
- **App Bar**: Displays "Guitar Tuner" title centered at the top

### Main Content Area

#### 1. Guitar Strings Display (Top Section)
Shows all 6 guitar strings with their information:

```
E2  [========●========]  82.41 Hz
A2  [=================]  110.00 Hz
D3  [=================]  146.83 Hz
G3  [=================]  196.00 Hz
B3  [=================]  246.94 Hz
E4  [=================]  329.63 Hz
```

- **String Name**: Left-aligned (E2, A2, D3, etc.)
- **Tuning Indicator**: Center bar with sliding dot showing tuning position
- **Target Frequency**: Right-aligned in Hz

When a string is detected:
- The corresponding row is highlighted
- The dot position shows how far sharp (right) or flat (left) the string is
- Colors change based on tuning accuracy:
  - 🟢 Green: In tune (±5 cents)
  - 🟠 Orange: Close (±5-15 cents)
  - 🔴 Red: Out of tune (>15 cents)

#### 2. Current Note Display (Center Circle)
Large circular display showing:

```
    ┌─────────────┐
    │             │
    │     E2      │  ← Detected note (large text)
    │   82.41 Hz  │  ← Frequency
    │   +3 cents  │  ← Deviation from perfect tuning
    │             │
    └─────────────┘
```

- **Circle Border**: Changes color based on tuning accuracy
- **Note Name**: Large, bold text (72pt)
- **Frequency**: Current frequency in Hz
- **Cents**: Shows how many cents sharp (+) or flat (-)

Initial state shows:
```
    ┌─────────────┐
    │             │
    │     --      │
    │             │
    │             │
    │             │
    └─────────────┘
```

#### 3. Status Message
Centered text below the circle:
- "Tap to start" - When inactive
- "Listening..." - When active (demo mode note)
- "Microphone permission denied" - If permission is not granted

#### 4. Control Button (Bottom)
Large button to control the tuner:
- **Inactive State**: Blue button labeled "Start Tuner"
- **Active State**: Red button labeled "Stop"

### Color Scheme

- **Primary Color**: Blue (#2196F3)
- **Background**: White
- **Tuning Indicators**:
  - Perfect: Green (#4CAF50)
  - Close: Orange (#FF9800)
  - Off: Red (#F44336)
- **Inactive Elements**: Grey (#9E9E9E)

### Interactive Elements

1. **Start/Stop Button**
   - Touch to toggle tuner on/off
   - Visual feedback on press
   - Color changes based on state

2. **Permission Request**
   - Automatic prompt for microphone access on first use
   - Graceful handling if permission is denied

### Responsive Design

- Adapts to different screen sizes
- Maintains aspect ratios and readability
- Portrait orientation optimized
- Works on phones and tablets

### Material Design 3

The app follows Material Design 3 guidelines:
- Elevation and shadows
- Rounded corners
- Smooth animations
- Consistent spacing (8dp grid)
- Accessible touch targets (48dp minimum)

### Accessibility Features

- High contrast colors for visibility
- Large touch targets for easy interaction
- Clear visual hierarchy
- Readable font sizes
- Color-blind friendly indicators (uses position and color)

## User Flow

1. **Launch App**
   - See guitar strings layout
   - See "--" in center circle
   - See "Tap to start" message
   - See blue "Start Tuner" button

2. **Start Tuning**
   - Tap "Start Tuner" button
   - Grant microphone permission (first time only)
   - Button turns red, label changes to "Stop"
   - Status message shows "Listening..."

3. **Tune Guitar** (Demo Mode)
   - Play a guitar string
   - App would detect frequency (in real implementation)
   - Corresponding string row highlights
   - Center circle shows note, frequency, and cents
   - Visual indicators guide tuning adjustment

4. **Stop Tuning**
   - Tap "Stop" button
   - Returns to initial state
   - Button turns blue, label changes to "Start Tuner"

## Future UI Enhancements

Potential improvements for future versions:
- Waveform visualization
- Settings screen for alternate tunings
- Dark mode support
- Tuning history graph
- Multiple instrument support with tabs
- Sensitivity adjustment slider
- Auto-detect mode toggle
