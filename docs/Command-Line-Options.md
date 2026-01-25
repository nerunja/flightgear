# FlightGear Command Line Options Reference

## Table of Contents
1. [Introduction](#introduction)
2. [Basic Usage](#basic-usage)
3. [Aircraft and Airport Selection](#aircraft-and-airport-selection)
4. [Position and Orientation](#position-and-orientation)
5. [Starting in the Air](#starting-in-the-air)
6. [Radio Frequencies](#radio-frequencies)
7. [System Failures](#system-failures)
8. [Time and Weather](#time-and-weather)
9. [Display Options](#display-options)
10. [Network and Multiplayer](#network-and-multiplayer)
11. [Useful Combinations](#useful-combinations)

---

## Introduction

FlightGear can be customized extensively using command-line parameters. These options allow you to start at specific airports, set initial aircraft position, configure radios, and much more.

### Documentation Links
- **All Command Line Options**: http://wiki.flightgear.org/Command_line_options
- **Man Page**: https://www.mankier.com/1/fgfs
- **Getting Started**: http://flightgear.sourceforge.net/getstart-en/getstart-enpa2.html#x5-450004.5

---

## Basic Usage

### Starting FlightGear with Options

**Method 1: Command Line**
```bash
fgfs --aircraft=c172p --airport=KSFO --timeofday=noon
```

**Method 2: FlightGear Launcher**
- In Settings → Additional Settings
- Add parameters in the text box
- Click [Run] button

**Note**: All command-line options can also be set in the launcher's Additional Settings field.

---

## Aircraft and Airport Selection

### Aircraft Selection
```bash
--aircraft=<aircraft-name>
```

**Examples**:
```bash
--aircraft=c172p          # Cessna 172p
--aircraft=737-300        # Boeing 737
--aircraft=A320-family    # Airbus A320
```

### Airport Selection
```bash
--airport=<ICAO-code>
```

**Examples**:
```bash
--airport=KSFO      # San Francisco International
--airport=KJFK      # New York JFK
--airport=KHAF      # Half Moon Bay
--airport=EGLL      # London Heathrow
```

### Runway Selection
```bash
--runway=<runway-number>
```

**Example**:
```bash
--airport=KSFO --runway=28R
```

---

## Position and Orientation

### Starting Position by Coordinates

**Latitude and Longitude**
```bash
--lat=<degrees>
--lon=<degrees>
```

**Notes**:
- South latitudes and West longitudes are negative
- Decimal degrees format

**Example**:
```bash
--lat=37.6213 --lon=-122.3790    # Half Moon Bay area
```

### Altitude
```bash
--altitude=<feet>
```

**Notes**:
- Altitude in feet (default)
- Use `--units-meters` for meters
- Implies `--in-air` (starts aircraft airborne)
- **Important**: Set initial velocity with `--vc` to avoid stalling

**Example**:
```bash
--altitude=5000 --vc=110    # Start at 5000 ft with 110 knots
```

### Initial Orientation

**Heading**
```bash
--heading=<degrees>
```
- Magnetic heading (0-359°)
- 0 = North, 90 = East, 180 = South, 270 = West

**Pitch**
```bash
--pitch=<degrees>
```
- Positive = nose up
- Negative = nose down
- Default: 0 (level)

**Roll**
```bash
--roll=<degrees>
```
- Positive = right wing down
- Negative = left wing down
- Default: 0 (wings level)

**Example**:
```bash
--heading=270 --pitch=5 --roll=0    # Heading west, slight nose up, wings level
```

### Initial Velocity
```bash
--vc=<knots>
```
- Calibrated airspeed in knots
- Essential when starting in air to avoid stall

**Example**:
```bash
--altitude=3000 --vc=110 --heading=270
```

---

## Starting in the Air

### Basic Air Start
```bash
--altitude=<feet> --vc=<knots> --heading=<degrees>
```

**Example**:
```bash
--altitude=5000 --vc=110 --heading=270
```

### Positioned Relative to VOR/NDB

**VOR-Based Positioning**
```bash
--vor=<VOR-ID> --offset-distance=<nm> --offset-azimuth=<degrees>
```

**Parameters**:
- `--vor=<VOR-ID>`: VOR station identifier (e.g., OAK, SFO)
- `--offset-distance=<nm>`: Distance from VOR in nautical miles
- `--offset-azimuth=<degrees>`: Bearing FROM VOR (0-359°)

**Important**:
- `--offset-azimuth` is the angle FROM the VOR TO your aircraft
- Measured clockwise from North (VOR is at center)

**Example 1**: Position for VOR approach
```bash
--altitude=5000 --heading=270 --vc=110 --vor=OAK --offset-distance=5 --offset-azimuth=270
```
This positions you 5 NM **East** of Oakland VOR, heading West toward it.

**Example 2**: Position for ILS approach to KSFO runway 28R
```bash
--aircraft=c172p --timeofday=noon --enable-hud --altitude=3000 --heading=294 --vc=110 --vor=SFO --offset-distance=12 --offset-azimuth=294
```

**Understanding Offset-Azimuth**:
```
        North (0°)
            |
            |
    270° ---VOR--- 90°
            |
            |
        South (180°)

If offset-azimuth = 90°, you're positioned EAST of the VOR
If offset-azimuth = 270°, you're positioned WEST of the VOR
```

### NDB-Based Positioning
```bash
--ndb=<NDB-ID> --offset-distance=<nm> --offset-azimuth=<degrees>
```

### Fix-Based Positioning
```bash
--fix=<FIX-ID>
```

### Alignment Tip for Approaches

**Important**: For proper runway alignment, set heading slightly different from offset-azimuth:
```bash
--heading=300 --offset-azimuth=320
```

The **10-20° difference** helps align exactly with the runway. The heading should be within ±30° of offset-azimuth to properly align for approach.

**Conceptual Explanation**:
- With aircraft as origin of quadrant
- Draw line from aircraft to North
- Draw line from aircraft to airport/VOR
- Angle measured FROM North TO airport = `--offset-azimuth`
- Aircraft heading (`--heading`) can be different to set up intercept angle

---

## Radio Frequencies

### COM Radios
```bash
--com1=<frequency>
--com2=<frequency>
```

**Example**:
```bash
--com1=125.20    # ATIS frequency
```

### NAV Radios
```bash
--nav1=[radial:]<frequency>
--nav2=[radial:]<frequency>
```

**Examples**:
```bash
--nav1=115.80           # SFO VOR (115.80 MHz)
--nav1=090:114.10       # Radial 090 from SJC VOR
--nav2=111.70           # KSFO Runway 28R Localizer
```

### ADF Radio
```bash
--adf=[radial:]<frequency>
```

**Example**:
```bash
--adf=340           # NDB frequency 340 kHz
--adf=180:350       # Radial 180 from NDB 350 kHz
```

### DME
```bash
--dme=nav1|nav2|<frequency>
```

**Examples**:
```bash
--dme=nav1          # DME tied to NAV1
--dme=116.80        # Specific DME frequency
```

---

## System Failures

### Simulate System Failures
```bash
--failure=<system>
```

**Available Systems**:
- `pitot` - Pitot tube (airspeed indicator)
- `static` - Static port (altimeter, VSI)
- `vacuum` - Vacuum system (attitude indicator, heading indicator)
- `electrical` - Electrical system

**Example**: Simulate electrical failure
```bash
--failure=electrical
```

**Multiple Failures**:
```bash
--failure=pitot --failure=vacuum
```

---

## Time and Weather

### Time of Day
```bash
--timeofday=<time>
```

**Options**:
- `real` - Current real-world time
- `dawn`
- `morning`
- `noon`
- `afternoon`
- `dusk`
- `evening`
- `midnight`

**Example**:
```bash
--timeofday=noon
```

### Specific Date and Time

**GMT Time**
```bash
--start-date-gmt=yyyy:mm:dd:hh:mm:ss
```

**Local Time**
```bash
--start-date-lat=yyyy:mm:dd:hh:mm:ss
```

**System Time**
```bash
--start-date-sys=yyyy:mm:dd:hh:mm:ss
```

**Example**:
```bash
--start-date-gmt=2026:01:25:14:30:00
```

### Clock Control
```bash
--enable-clock-freeze      # Freeze time
--disable-clock-freeze     # Normal time progression
```

### Weather

**Disable Real Weather**
```bash
--disable-real-weather-fetch
```

**Set Weather Manually** (requires additional plugins/settings)

---

## Display Options

### HUD (Heads-Up Display)
```bash
--enable-hud          # Start with HUD enabled
--disable-hud         # Start with HUD disabled
```

### Full Screen
```bash
--enable-fullscreen
--disable-fullscreen
```

### Window Size
```bash
--geometry=<width>x<height>
```

**Example**:
```bash
--geometry=1920x1080
```

### View Options
```bash
--enable-panel        # Show instrument panel
--disable-panel       # Hide instrument panel
```

---

## Network and Multiplayer

### HTTP Server (for browser map)
```bash
--httpd=<port>
```

**Example**:
```bash
--httpd=8080
```

Then open browser to: `http://localhost:8080`

### Multiplayer
```bash
--multiplay=out,<rate>,<server>,<port>
--multiplay=in,<rate>,<server>,<port>
--callsign=<your-callsign>
```

**Example**:
```bash
--callsign=FGNSOUB --multiplay=out,10,mpserver01.flightgear.org,5000
```

---

## Useful Combinations

### Standard Practice Flight
```bash
--aircraft=c172p --airport=KSFO --runway=28L --timeofday=noon
```

### VOR Navigation Practice
```bash
--aircraft=c172p --airport=KHAF --timeofday=noon --nav1=115.80 --nav2=114.10
```

### ILS Approach Setup to KSFO 28R
```bash
--aircraft=c172p --timeofday=noon --enable-hud --httpd=8080 \
--altitude=3000 --heading=294 --vc=110 \
--vor=SFO --offset-distance=12 --offset-azimuth=294 \
--nav1=111.70
```

**Breakdown**:
- Start at 3000 ft, 12 NM from SFO VOR
- Heading 294° (aligned for runway 28R)
- 110 knots airspeed
- NAV1 tuned to 111.70 (ILS 28R frequency)
- HUD enabled for approach guidance
- HTTP server for map display

### ILS Approach to KOAK 28R
```bash
--aircraft=c172p --timeofday=noon --enable-hud \
--altitude=2000 --heading=300 --vc=110 \
--vor=OAK --offset-distance=5 --offset-azimuth=320 \
--nav1=111.90 --nav2=116.80
```

### Night Flight Practice
```bash
--aircraft=c172p --airport=KSFO --timeofday=midnight \
--enable-hud
```

### Cross-Country Flight Setup
```bash
--aircraft=c172p --airport=KHAF \
--nav1=115.80 --nav2=114.10 \
--com1=125.20 \
--timeofday=morning
```

### Emergency Procedure Practice
```bash
--aircraft=c172p --airport=KSFO \
--altitude=3000 --vc=100 --heading=270 \
--failure=electrical
```

### Formation Flying (Multiplayer)
```bash
--aircraft=c172p --airport=KSFO \
--callsign=LEADER1 \
--multiplay=out,10,mpserver01.flightgear.org,5000 \
--multiplay=in,10,mpserver01.flightgear.org,5000
```

---

## Aircraft-Specific Options

### Cessna 172p Options

**Hide Yoke at Startup**
Edit: `data/Aircraft/c172p/c172p-set.xml`
Change: `<hide-yoke>` parameter to `true`

**Using Properties**
```bash
--prop:/sim/crash/detect=false              # Disable crash detection
--prop:/sim/abuse=false                      # Disable aircraft abuse warnings
--prop:/engines/active-engine/running=true   # Start with engine running
```

**Example**: Safe practice mode
```bash
--aircraft=c172p --airport=KSFO \
--prop:/sim/crash/detect=false \
--prop:/sim/abuse=false \
--disable-real-weather-fetch
```

---

## Property System

### Setting Properties
```bash
--prop:<property-path>=<value>
```

**Common Properties**:
```bash
--prop:/sim/rendering/particles=false                    # Disable particles
--prop:/sim/rendering/clouds3d-enable=false              # Disable 3D clouds
--prop:/sim/startup/xsize=1920                           # Window width
--prop:/sim/startup/ysize=1080                           # Window height
--prop:/sim/view/internal=true                           # Start in cockpit view
```

---

## Advanced Examples

### Complete ILS Training Setup
```bash
fgfs \
  --aircraft=c172p \
  --timeofday=noon \
  --enable-hud \
  --httpd=8080 \
  --altitude=2500 \
  --heading=294 \
  --vc=100 \
  --vor=SFO \
  --offset-distance=10 \
  --offset-azimuth=294 \
  --nav1=111.70 \
  --nav2=115.80 \
  --com1=125.20 \
  --prop:/sim/crash/detect=false \
  --disable-real-weather-fetch
```

### VOR-DME Cross-Country
```bash
fgfs \
  --aircraft=c172p \
  --airport=KHAF \
  --runway=30 \
  --timeofday=morning \
  --nav1=115.80 \
  --nav2=114.10 \
  --dme=nav1 \
  --com1=125.20 \
  --enable-hud
```

### Night IFR Practice
```bash
fgfs \
  --aircraft=c172p \
  --airport=KSFO \
  --runway=28R \
  --timeofday=midnight \
  --enable-hud \
  --nav1=111.70 \
  --nav2=115.80 \
  --com1=125.20
```

---

## Tips and Best Practices

### Starting in Air
1. **Always set `--vc`** to avoid stalling immediately
2. **Recommended speeds**:
   - Cessna 172p: 100-120 knots
   - Jets: 200-300 knots depending on aircraft
3. **Set heading** to something reasonable for the area

### Radio Frequencies
1. **Find frequencies** from:
   - In-game map (Ctrl + M)
   - http://mpmap02.flightgear.org/
   - SkyVector.com
   - Real-world charts
2. **Pre-tune radios** to save time after startup

### Performance
1. **Disable features** if performance is slow:
   ```bash
   --prop:/sim/rendering/particles=false
   --prop:/sim/rendering/clouds3d-enable=false
   ```
2. **Reduce rendering distance**
3. **Use simpler aircraft** for practice

### Consistency
Create **shell scripts or batch files** for frequently used configurations:

**Example**: `ils_practice.sh`
```bash
#!/bin/bash
fgfs \
  --aircraft=c172p \
  --timeofday=noon \
  --enable-hud \
  --altitude=2500 \
  --heading=294 \
  --vc=100 \
  --vor=SFO \
  --offset-distance=10 \
  --offset-azimuth=294 \
  --nav1=111.70
```

Make executable: `chmod +x ils_practice.sh`
Run: `./ils_practice.sh`

---

## Reference Tables

### Common VOR Frequencies (San Francisco Bay Area)
| Station | ID | Frequency | Location |
|---|---|---|---|
| San Francisco | SFO | 115.80 | KSFO Airport |
| Oakland | OAK | 116.80 | KOAK Airport |
| San Jose | SJC | 114.10 | KSJC Airport |
| Woodside | OSI | 113.90 | Peninsula |

### Common ILS Frequencies (Bay Area)
| Airport | Runway | Frequency |
|---|---|---|
| KSFO | 28L | 111.30 |
| KSFO | 28R | 111.70 |
| KOAK | 28R | 111.90 |
| KOAK | 28L | 109.70 |
| KSJC | 30L | 111.10 |

### Heading Reference
| Direction | Degrees |
|---|---|
| North | 0° / 360° |
| Northeast | 45° |
| East | 90° |
| Southeast | 135° |
| South | 180° |
| Southwest | 225° |
| West | 270° |
| Northwest | 315° |

---

## Additional Resources

- **Complete Command Line Reference**: http://wiki.flightgear.org/Command_line_options
- **Starting in Air Tutorial**: http://wiki.flightgear.org/Starting_in_the_Air
- **Property Browser**: Available in FlightGear via Debug menu
- **FlightGear Forums**: https://forum.flightgear.org/

---

**Document Version**: 1.0
**Last Updated**: January 25, 2026
**Flight Simulator**: FlightGear
