# Flight Parameters & Aircraft Configuration
| Parameter | Setting / Value | Flight Purpose / Notes |
| :--- | :--- | :--- |
| Aircraft | c172p | Cessna 172P Skyhawk |
| Departure Airport | KOAK | Metro Oakland International |
| Departure Runway | 29 | Main bay-side commercial runway (10,000 ft) pointing west-northwest over the bay |
| Time of Day | noon | Day VFR/IFR conditions |
| Heading Bug | 194° | Set on Directional Gyro to target KSFO 19L approach vector |
| Glide Path Tunnel | ON (draw-glideslope=true) | Visual 3D approach corridor enabled for KSFO landing |
| Electrical / Avionics | ON (Battery, Gen, Avionics) | Full 28V power supplied to COM/NAV radios |

---

# Communication Stack Setup (COMM 1 & COMM 2)
| Radio | Channel | Frequency | Identifier / Controller | Operational Role |
| :--- | :--- | :--- | :--- | :--- |
| COMM 1 | Active | 133.77 MHz | KOAK ATIS | Continuous weather and active airport information loop |
| COMM 1 | Standby | 121.90 MHz | KOAK Ground | Taxi clearances on movement areas at Oakland |
| COMM 2 | Active | 134.50 MHz | NorCal Approach | Radar flight following & approach vectoring over SF Bay |
| COMM 2 | Standby | 120.50 MHz | KSFO Tower | Landing clearance on final approach for Runway 19L |

---

# Navigation Stack Setup (NAV 1 & NAV 2)
| Radio | Channel | Frequency | Station / Identifier | Radial / OBS | Operational Role |
| :--- | :--- | :--- | :--- | :--- | :--- |
| NAV 1 | Active | 111.90 MHz | KOAK Rwy 29 Localizer (I-INB) | 194° | Departure guidance off Oakland Runway 29 |
| NAV 1 | Standby | 116.80 MHz | Oakland VOR (OAK) | — | Visual/IFR en-route fix reference |
| NAV 2 | Active | 115.80 MHz | San Francisco VOR (SFO) | 194° | Distance & radial tracking directly toward SFO field |
| NAV 2 | Standby | 108.90 MHz | KSFO Rwy 19L ILS (I-SFO) | 194° | Flip to Active when ready to lock ILS/Glideslope |

---

# Complete Flight & Cockpit Operational Procedures

## Phase 1: Pre-Engine Start & Ground Operations (At KOAK Ramp)
1. **Listen to ATIS (COMM 1 Active - 133.77 MHz):**
   * Listen to the continuous automated broadcast: *"Oakland Airport information Bravo. Wind 270 at 10, visibility 10, altimeter 29.92. Departure runway 29..."*
   * Note the phonetic letter code (e.g., Information Bravo) and altimeter setting.
2. **Switch to Ground Control:**
   * Flip **COMM 1** to Standby (**121.90 MHz** - KOAK Ground).
   * Request taxi clearance: *"Oakland Ground, Cessna 172SP ready to taxi with Information Bravo."*
   * Follow assigned taxiways to the holding point of Runway 29.

## Phase 2: Departure & Takeoff (KOAK Runway 29 Threshold)
1. **Switch to Tower Control:**
   * Switch active transmitter to **COMM 2** Active (**118.30 MHz** - KOAK Tower) or flip COMM 1 to Tower frequency when holding short.
   * Call Tower: *"Oakland Tower, Cessna 172SP holding short Runway 29, ready for departure."*
2. **Takeoff Roll & Initial Climbout:**
   * Upon clearance, execute takeoff on Runway 29 (Heading ~296°).
   * Verify **NAV 1 Active (111.90 MHz)** centers your CDI needle for runway alignment guidance during initial climb.
   * Climb past 500–1,000 ft AGL over the bay.

## Phase 3: En-Route Transition across San Francisco Bay
1. **Contact Departure / Approach Control:**
   * Switch to **COMM 2 Active (134.50 MHz - NorCal Approach)** when handed off by Oakland Tower.
   * Announce position: *"NorCal Approach, Cessna 172SP climbing through 1,500 ft heading southwest."*
2. **Turn South Toward KSFO:**
   * Initiate a left turn to intercept heading **194°** (following the orange Heading Bug on your Directional Gyro).
3. **Check SFO Arrival ATIS (Optional):**
   * Pre-tune **COMM 1 Active** to **118.85 MHz** (KSFO ATIS) to confirm weather and that Runway 19L is in active use for landings.
   * Set **COMM 1 Standby** to **121.80 MHz** (KSFO Ground Control) so it is ready after touchdown.

## Phase 4: Approach & Landing (KSFO Runway 19L)
1. **Track Navigation via NAV 2:**
   * Observe **NAV 2 Active (115.80 MHz - SFO VOR)** to monitor radial and Distance Measuring Equipment (DME) positioning relative to the airport.
2. **Intercept the ILS 19L Localizer & Glideslope:**
   * As you close within 5–8 nautical miles of KSFO, press the **NAV 2 Flip/Transfer button** to swap Standby (**108.90 MHz - KSFO Rwy 19L ILS**) into Active.
   * Verify both horizontal localizer needle (CDI) and vertical glideslope needle center up.
   * Visually line up with the 3D Glide Path Tunnel displayed in FlightGear (`--draw-glideslope=true`).
3. **Switch to SFO Tower:**
   * When instructed by Approach (or ~5 miles out), flip **COMM 2** to Standby (**120.50 MHz - KSFO Tower**).
   * Report: *"San Francisco Tower, Cessna 172SP on final approach Runway 19L."*
4. **Touchdown & Rollout:**
   * Complete landing on Runway 19L. Exit the active runway onto a high-speed taxiway past the hold-short line.
5. **After Landing Taxi:**
   * Flip **COMM 1** to Standby (**121.80 MHz - KSFO Ground**).
   * Call Ground for taxi instructions to general aviation parking.


---

# How to Run This in FlightGear

1. Launch FlightGear with your preferred startup flags:
   ```
   --aircraft=c172p \
   --airport=KOAK \
   --runway=29 \
   --timeofday=noon \
   --enable-hud \
   --prop:/sim/model/c172p/options/enable-damage=false \
   --prop:/sim/model/c172p/options/enable-frost-fog-icing=false \
   --prop:/sim/model/c172p/sec-switches/yoke-show-left=false \
   --prop:/sim/model/c172p/sec-switches/yoke-show-right=false \
   --prop:/sim/model/c172p/options/show-walker=false \
   --prop:/sim/model/c172p/options/tyres=1 \
   --prop:/sim/hud/visibility[0]=true \
   --prop:/sim/hud/current-color=0 \
   --prop:/sim/hud/color/red=0.0 \
   --prop:/sim/hud/color/green=1.0 \
   --prop:/sim/hud/color/blue=0.0 \
   --prop:/sim/hud/color/alpha=0.8 \
   --prop:/sim/rendering/draw-glideslope=true \
   --prop:/sim/hud/path-markers=true \
   --prop:/sim/hud/runway-markers=true \
   --prop:/sim/rendering/draw-hud-airports=true
   ```
2. Once the simulator loads, open the top menu bar and navigate to **Debug -> Nasal Console**.
3. Paste the code block below into the window and click **Execute**.

## Nasal Script
```nasal
# NOTE: Ensure the flight is started with these settings: --aircraft=c172p --airport=KOAK --runway=29
# San Francisco Bay VFR/IFR Flight Setup: KOAK Rwy 29 -> KSFO Rwy 19L
# Includes Panel Lights, DME Tuning, Visual Markers, Glideslope & Radios

# --- 1. Instrument Panel & Radio Lighting ---
setprop("/controls/lighting/instrument-lights", 1.0);     # Master Panel Lights ON (Full Brightness)
setprop("/controls/lighting/panel-norm", 1.0);           # Panel Backlighting Intensity
setprop("/controls/lighting/radio-norm", 1.0);           # Radio Stack Display Lighting
setprop("/controls/lighting/nav-lights", 1);             # Exterior Navigation Lights ON
setprop("/controls/lighting/beacon", 1);                 # Anti-Collision Beacon ON

# --- 2. DME (Distance Measuring Equipment) Setup ---
setprop("/instrumentation/dme/serviceable", 1);
setprop("/instrumentation/dme/power-btn", 1);
# Set DME source to NAV 2 (115.80 MHz - SFO VOR) for distance tracking to KSFO
setprop("/instrumentation/dme/frequencies/source", 2);
# Direct frequency override for standalone DME tracking to KSFO Rwy 19L ILS (108.90 MHz)
setprop("/instrumentation/dme/frequencies/selected-mhz", 108.90);

# --- 3. Visual Markers, Airport Overlay & Glideslope Tunnel ---
setprop("/sim/hud/path-markers", 1);               # Show airport marker pins/path markers
setprop("/sim/hud/runway-markers", 1);             # Highlight runway outlines
setprop("/sim/rendering/draw-hud-airports", 1);      # Enable airport markers in HUD/view
setprop("/sim/rendering/draw-glideslope", 1);        # Enable 3D Glide Slope Tunnel

# --- 4. Avionics & Electrical Master Overrides ---
setprop("/controls/electric/battery-switch", 1);
setprop("/controls/electric/engine[0]/generator", 1);
setprop("/controls/switches/master-avionics", 1);
setprop("/systems/electrical/outputs/avionics", 28.0);
setprop("/systems/electrical/outputs/nav[0]", 28.0);
setprop("/systems/electrical/outputs/nav[1]", 28.0);

# Serviceability & Power
setprop("/instrumentation/comm[0]/serviceable", 1);
setprop("/instrumentation/comm[1]/serviceable", 1);
setprop("/instrumentation/nav[0]/serviceable", 1);
setprop("/instrumentation/nav[1]/serviceable", 1);
setprop("/instrumentation/nav[0]/power-btn", 1);
setprop("/instrumentation/nav[1]/power-btn", 1);
setprop("/instrumentation/nav[0]/volume", 1.0);
setprop("/instrumentation/nav[1]/volume", 1.0);
setprop("/instrumentation/comm[0]/volume", 1.0);

# Audio Panel: route COMM 1 to the speaker (needed to hear ATIS)
setprop("/instrumentation/audio-panel/comm-select", 1);

# --- 5. COMM 1 & COMM 2 Frequencies ---
# COMM 1: Active = 133.77 MHz (KOAK ATIS) | Standby = 121.90 MHz (KOAK Ground)
setprop("/instrumentation/comm[0]/frequencies/selected-mhz", 133.77);
setprop("/instrumentation/comm[0]/frequencies/selected-mhz-prop", 133.77);
setprop("/instrumentation/comm[0]/frequencies/selected-mhz-fmt", "133.770");
setprop("/instrumentation/comm[0]/frequencies/standby-mhz", 121.90);
setprop("/instrumentation/comm[0]/frequencies/standby-mhz-prop", 121.90);
setprop("/instrumentation/comm[0]/frequencies/standby-mhz-fmt", "121.900");

# COMM 2: Active = 134.50 MHz (NorCal Approach) | Standby = 120.50 MHz (KSFO Tower)
setprop("/instrumentation/comm[1]/frequencies/selected-mhz", 134.50);
setprop("/instrumentation/comm[1]/frequencies/selected-mhz-prop", 134.50);
setprop("/instrumentation/comm[1]/frequencies/selected-mhz-fmt", "134.500");
setprop("/instrumentation/comm[1]/frequencies/standby-mhz", 120.50);
setprop("/instrumentation/comm[1]/frequencies/standby-mhz-prop", 120.50);
setprop("/instrumentation/comm[1]/frequencies/standby-mhz-fmt", "120.500");

# --- 6. NAV 1 & NAV 2 Frequencies ---
# NAV 1: Active = 111.90 MHz (KOAK Rwy 29 LOC I-INB) | Standby = 116.80 MHz (OAK VOR)
setprop("/instrumentation/nav[0]/frequencies/selected-mhz", 111.90);
setprop("/instrumentation/nav[0]/frequencies/selected-mhz-prop", 111.90);
setprop("/instrumentation/nav[0]/frequencies/standby-mhz", 116.80);
setprop("/instrumentation/nav[0]/frequencies/standby-mhz-prop", 116.80);

# NAV 2: Active = 115.80 MHz (SFO VOR) | Standby = 108.90 MHz (KSFO Rwy 19L ILS I-SFO)
setprop("/instrumentation/nav[1]/frequencies/selected-mhz", 115.80);
setprop("/instrumentation/nav[1]/frequencies/selected-mhz-prop", 115.80);
setprop("/instrumentation/nav[1]/frequencies/standby-mhz", 108.90);
setprop("/instrumentation/nav[1]/frequencies/standby-mhz-prop", 108.90);

# --- 7. Gyro Alignment, Heading Bug & OBS Radials ---
setprop("/instrumentation/heading-indicator/offset-deg", 0);
setprop("/instrumentation/heading-indicator/spin", 1);
setprop("/instrumentation/heading-indicator/heading-bug-deg", 194);
setprop("/autopilot/settings/heading-bug-deg", 194);
setprop("/controls/autoflight/heading-select", 1);
setprop("/instrumentation/nav[0]/radials/selected-deg", 194);
setprop("/instrumentation/nav[1]/radials/selected-deg", 194);

print(">>> FlightGear Panel Lighting, DME (KSFO), Radios & Visual Guidance Initialized! <<<");
```

---

## Why the Flag Doesn't Flip to "FROM" After Passing the Runway

**Question:** Flying past the end of the KOAK runway still doesn't change the flag from TO to FROM. Why?

In a standard VOR receiver, passing the station flips the flag from TO to FROM. NAV 1 is tuned to 111.90 MHz, a Localizer (ILS) frequency (I-INB), so the CDI behaves differently.

- **Localizers have no TO/FROM logic:** A VOR transmits a 360-degree radial signal, so the receiver can tell whether you are flying toward or away from the station relative to the selected OBS radial. A localizer is a single beam aligned with one runway centerline, and the receiver only processes left/right deviation. On most analog NAV indicators (such as the Bendix/King KI 209 in the C172P), the TO/FROM flag on a LOC frequency is driven out of view, stays fixed on TO, or acts only as a signal-validity (NAV) flag.
- **Antenna position:** The localizer antenna for KOAK Runway 29 is at the far departure end of the runway. Flying past it over San Francisco Bay, you remain on the front-course side of the beam. The CDI keeps showing your left/right alignment with the runway heading, but it never flips to **FROM** like a VOR radial would.
- **NAV 2 (SFO VOR, 115.80 MHz):** This is a true VOR, so it does use TO/FROM. As you turn left toward heading 194° across the bay, NAV 2 displays **TO**, because you are flying toward the SFO VOR transmitter on the airport grounds.
