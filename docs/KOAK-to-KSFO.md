# Flight Parameters & Aircraft Configuration
| Parameter | Setting / Value | Flight Purpose / Notes |
| :--- | :--- | :--- |
| Aircraft | c172p-bush36 | Cessna 172P Skyhawk with 36" bush tires (engine set to 180 HP by the script) |
| Departure Airport | KOAK | Metro Oakland International |
| Departure Runway | 29 | Main bay-side commercial runway (10,000 ft) pointing west-northwest over the bay |
| Time of Day | noon | Day VFR/IFR conditions |
| Heading Bug | 194° | Set on Directional Gyro to target KSFO 19L approach vector |
| Glide Path Tunnel | ON (glide-slope-tunnel=true) | Visual 3D approach corridor enabled for KSFO landing |
| Electrical / Avionics | ON (Battery, Alternator, Avionics masters) | Full 28V power supplied to COM/NAV radios |

---

# Communication Stack Setup (COMM 1 & COMM 2)
| Radio | Channel | Frequency | Identifier / Controller | Operational Role |
| :--- | :--- | :--- | :--- | :--- |
| COMM 1 | Active | 133.775 MHz | KOAK ATIS | Continuous weather and active airport information loop |
| COMM 1 | Standby | 121.900 MHz | KOAK Ground | Taxi clearances on movement areas at Oakland |
| COMM 2 | Active | 134.500 MHz | NorCal Approach | Radar flight following & approach vectoring over SF Bay |
| COMM 2 | Standby | 120.500 MHz | KSFO Tower | Landing clearance on final approach for Runway 19L |

---

# Navigation Stack Setup (NAV 1 & NAV 2)
| Radio | Channel | Frequency | Station / Identifier | Radial / OBS | Operational Role |
| :--- | :--- | :--- | :--- | :--- | :--- |
| NAV 1 | Active | 108.70 MHz | KOAK Rwy 29 Localizer (I-INB) | 194° | Departure guidance off Oakland Runway 29 |
| NAV 1 | Standby | 116.80 MHz | Oakland VOR (OAK) | — | Visual/IFR en-route fix reference |
| NAV 2 | Active | 115.80 MHz | San Francisco VOR (SFO) | 194° | Distance & radial tracking directly toward SFO field |
| NAV 2 | Standby | 108.90 MHz | KSFO Rwy 19L ILS (I-SIA) | 194° | Flip to Active when ready to lock ILS/Glideslope |

---

# Complete Flight & Cockpit Operational Procedures

## Phase 1: Pre-Engine Start & Ground Operations (At KOAK Ramp)
1. **Listen to ATIS (COMM 1 Active - 133.775 MHz):**
   * Listen to the continuous automated broadcast: *"Oakland Airport information Bravo. Wind 270 at 10, visibility 10, altimeter 29.92. Departure runway 29..."*
   * Note the phonetic letter code (e.g., Information Bravo) and altimeter setting.
2. **Switch to Ground Control:**
   * Flip **COMM 1** to Standby (**121.900 MHz** - KOAK Ground).
   * Request taxi clearance: *"Oakland Ground, Cessna 172SP ready to taxi with Information Bravo."*
   * Follow assigned taxiways to the holding point of Runway 29.

## Phase 2: Departure & Takeoff (KOAK Runway 29 Threshold)
1. **Switch to Tower Control:**
   * Switch active transmitter to **COMM 2** Active (**118.300 MHz** - KOAK Tower) or flip COMM 1 to Tower frequency when holding short.
   * Call Tower: *"Oakland Tower, Cessna 172SP holding short Runway 29, ready for departure."*
2. **Takeoff Roll & Initial Climbout:**
   * Upon clearance, execute takeoff on Runway 29 (Heading ~296°).
   * Verify **NAV 1 Active (108.70 MHz)** centers your CDI needle for runway alignment guidance during initial climb.
   * Climb past 500–1,000 ft AGL over the bay.

## Phase 3: En-Route Transition across San Francisco Bay
1. **Contact Departure / Approach Control:**
   * Switch to **COMM 2 Active (134.500 MHz - NorCal Approach)** when handed off by Oakland Tower.
   * Announce position: *"NorCal Approach, Cessna 172SP climbing through 1,500 ft heading southwest."*
2. **Turn South Toward KSFO:**
   * Initiate a left turn to intercept heading **194°** (following the orange Heading Bug on your Directional Gyro).
3. **Check SFO Arrival ATIS (Optional):**
   * Pre-tune **COMM 1 Active** to **118.850 MHz** (KSFO ATIS) to confirm weather and that Runway 19L is in active use for landings.
   * Set **COMM 1 Standby** to **121.800 MHz** (KSFO Ground Control) so it is ready after touchdown.

## Phase 4: Approach & Landing (KSFO Runway 19L)
1. **Track Navigation via NAV 2:**
   * Observe **NAV 2 Active (115.80 MHz - SFO VOR)** to monitor radial and Distance Measuring Equipment (DME) positioning relative to the airport.
2. **Intercept the ILS 19L Localizer & Glideslope:**
   * As you close within 5–8 nautical miles of KSFO, press the **NAV 2 Flip/Transfer button** to swap Standby (**108.90 MHz - KSFO Rwy 19L ILS**) into Active.
   * Verify both horizontal localizer needle (CDI) and vertical glideslope needle center up.
   * Visually line up with the 3D Glide Path Tunnel displayed in FlightGear (`glide-slope-tunnel`, or **View -> Toggle Glide Slope Tunnel**).
3. **Switch to SFO Tower:**
   * When instructed by Approach (or ~5 miles out), flip **COMM 2** to Standby (**120.500 MHz - KSFO Tower**).
   * Report: *"San Francisco Tower, Cessna 172SP on final approach Runway 19L."*
4. **Touchdown & Rollout:**
   * Complete landing on Runway 19L. Exit the active runway onto a high-speed taxiway past the hold-short line.
5. **After Landing Taxi:**
   * Flip **COMM 1** to Standby (**121.800 MHz - KSFO Ground**).
   * Call Ground for taxi instructions to general aviation parking.


---

# How to Run This in FlightGear

1. Launch FlightGear with your preferred startup flags:
   ```
   --aircraft=c172p-bush36 \
   --airport=KOAK \
   --runway=29 \
   --timeofday=noon \
   --enable-hud \
   --prop:/sim/hud/current-color=0 \
   --prop:/sim/hud/color/red=0.0 \
   --prop:/sim/hud/color/green=1.0 \
   --prop:/sim/hud/color/blue=0.0 \
   --prop:/sim/hud/color/alpha=0.8 \
   --prop:/sim/rendering/glide-slope-tunnel=true
   ```
2. Once the simulator loads, open the top menu bar and navigate to **Debug -> Nasal Console**.
3. Paste the code block below into the window and click **Execute**. Besides the radios and panel, it applies the remaining Aircraft Options (damage, frost/fog/icing, human model, yoke, 180 HP engine, Realistic Instruments).

## Nasal Script
```nasal
# NOTE: Ensure the flight is started with these settings: --aircraft=c172p-bush36 --airport=KOAK --runway=29
# San Francisco Bay VFR/IFR Flight Setup: KOAK Rwy 29 -> KSFO Rwy 19L
# Includes Aircraft Options, Panel Lights, Electrical, DME, Glide Slope Tunnel & Radios

# --- 0. Aircraft Options (same settings as Cessna C172p -> Aircraft Options) ---
# Landing Gear 36" comes from launching the c172p-bush36 variant (see step 1 above)
setprop("/fdm/jsbsim/settings/damage", 0);               # Enable damage OFF
setprop("/sim/model/c172p/enable-fog-frost", 0);         # Frost, fog and icing OFF
setprop("/sim/model/occupants", 0);                      # Human models OFF
setprop("/sim/model/hide-yoke", 1);                      # Yoke hidden
setprop("/sim/realism/instruments/realistic-instruments", 1);   # Realistic Instruments ON
# Engine power: 180 HP (same steps the menu runs)
setprop("/controls/engines/active-engine", 1);
setprop("controls/engines/engine/primer", 0);
setprop("sim/model/c172p/engine_flag_0", 0);
setprop("sim/model/c172p/engine_flag_1", 1);
setprop("/engines/active-engine/oil-level", 8.0);

# --- 1. Instrument Panel & Radio Lighting ---
setprop("/controls/lighting/instruments-norm", 1.0);    # Instrument Panel Lights (Full Brightness)
setprop("/controls/lighting/radio-norm", 1.0);          # Radio Stack Display Lighting
setprop("/controls/lighting/nav-lights", 1);            # Exterior Navigation Lights ON
setprop("/controls/lighting/beacon", 1);                # Anti-Collision Beacon ON

# --- 2. Electrical Master Switches ---
# The aircraft's electrical system powers the radios from these switches
setprop("/controls/switches/master-bat", 1);            # Battery Master ON
setprop("/controls/switches/master-alt", 1);            # Alternator ON
setprop("/controls/switches/master-avionics", 1);       # Avionics Master ON

# --- 3. DME (KI 266) on NAV 2 ---
# Knob positions: 1 = NAV1, 2 = HOLD, 3 = NAV2. The source is a property path, not a number
setprop("/instrumentation/dme/serviceable", 1);
setprop("/instrumentation/dme/power-btn", 1);
setprop("/instrumentation/dme/switch-position", 3);
setprop("/instrumentation/dme/frequencies/source", "instrumentation/nav[1]/frequencies/selected-mhz");

# --- 4. Glide Slope Tunnel (same as View -> Toggle Glide Slope Tunnel) ---
setprop("/sim/rendering/glide-slope-tunnel", 1);

# --- 5. Radio Serviceability, Volume & Audio Panel ---
setprop("/instrumentation/comm[0]/serviceable", 1);
setprop("/instrumentation/comm[1]/serviceable", 1);
setprop("/instrumentation/nav[0]/serviceable", 1);
setprop("/instrumentation/nav[1]/serviceable", 1);
setprop("/instrumentation/nav[0]/power-btn", 1);
setprop("/instrumentation/nav[1]/power-btn", 1);
setprop("/instrumentation/nav[0]/volume", 1.0);
setprop("/instrumentation/nav[1]/volume", 1.0);
setprop("/instrumentation/comm[0]/volume", 1.0);
# Audio Panel: COMM 1 audio and speaker ON (needed to hear ATIS)
setprop("/instrumentation/audio-panel/com1-btn", 1);
setprop("/instrumentation/audio-panel/spkr-btn", 1);

# --- 6. COMM 1 & COMM 2 Frequencies ---
# COMM 1: Active = 133.775 MHz (KOAK ATIS) | Standby = 121.900 MHz (KOAK Ground)
setprop("/instrumentation/comm[0]/frequencies/selected-mhz", 133.775);
setprop("/instrumentation/comm[0]/frequencies/standby-mhz", 121.900);

# COMM 2: Active = 134.500 MHz (NorCal Approach) | Standby = 120.500 MHz (KSFO Tower)
setprop("/instrumentation/comm[1]/frequencies/selected-mhz", 134.500);
setprop("/instrumentation/comm[1]/frequencies/standby-mhz", 120.500);

# --- 7. NAV 1 & NAV 2 Frequencies ---
# NAV 1: Active = 108.70 MHz (KOAK Rwy 29 LOC I-INB) | Standby = 116.80 MHz (OAK VOR)
setprop("/instrumentation/nav[0]/frequencies/selected-mhz", 108.70);
setprop("/instrumentation/nav[0]/frequencies/standby-mhz", 116.80);

# NAV 2: Active = 115.80 MHz (SFO VOR) | Standby = 108.90 MHz (KSFO Rwy 19L ILS I-SIA)
setprop("/instrumentation/nav[1]/frequencies/selected-mhz", 115.80);
setprop("/instrumentation/nav[1]/frequencies/standby-mhz", 108.90);

# --- 8. Gyro Alignment, Heading Bug & OBS Radials ---
setprop("/instrumentation/heading-indicator/offset-deg", 0);
setprop("/instrumentation/heading-indicator/spin", 1);
setprop("/autopilot/settings/heading-bug-deg", 194);
setprop("/instrumentation/nav[0]/radials/selected-deg", 194);
setprop("/instrumentation/nav[1]/radials/selected-deg", 194);

print(">>> KOAK -> KSFO setup applied: Aircraft Options, Lights, Electrical, DME, Radios <<<");
```

---

# FAQ

### 1. Why the Flag Doesn't Flip to "FROM" After Passing the Runway

**Question:** Flying past the end of the KOAK runway still doesn't change the flag from TO to FROM. Why?

In a standard VOR receiver, passing the station flips the flag from TO to FROM. NAV 1 is tuned to 108.70 MHz, a Localizer (ILS) frequency (I-INB), so the CDI behaves differently.

- **Localizers have no TO/FROM logic:** A VOR transmits a 360-degree radial signal, so the receiver can tell whether you are flying toward or away from the station relative to the selected OBS radial. A localizer is a single beam aligned with one runway centerline, and the receiver only processes left/right deviation. On most analog NAV indicators (such as the Bendix/King KI 209 in the C172P), the TO/FROM flag on a LOC frequency is driven out of view, stays fixed on TO, or acts only as a signal-validity (NAV) flag.
- **Antenna position:** The localizer antenna for KOAK Runway 29 is at the far departure end of the runway. Flying past it over San Francisco Bay, you remain on the front-course side of the beam. The CDI keeps showing your left/right alignment with the runway heading, but it never flips to **FROM** like a VOR radial would.
- **NAV 2 (SFO VOR, 115.80 MHz):** This is a true VOR, so it does use TO/FROM. As you turn left toward heading 194° across the bay, NAV 2 displays **TO**, because you are flying toward the SFO VOR transmitter on the airport grounds.
- **Getting a FROM flag from NAV 1:** NAV 1 standby is set to 116.80 MHz, the OAK VOR. After flying past the runway, swap NAV 1 to the standby frequency. Because OAK is a true VOR, it shows the **FROM** flag once the selected OBS course points away from the station, which is the TO/FROM behavior the localizer cannot give.

> **TIP:** To tell from the cockpit display whether NAV is tuned to a VOR or a Localizer, watch the GS (Glide Slope) horizontal needle. It moves only when NAV is tuned to a Localizer (ILS) frequency, and stays parked on a VOR frequency. The glide slope signal is only received within the ILS coverage area, so the needle may sit still when you are far from the runway even on a localizer frequency.

---

### 2. How Does a VOR Detect and Switch the TO/FROM Flag?

**Question:** How does the VOR receiver decide between TO and FROM?

A VOR receiver compares the phase of two 30 Hz signals, then checks the result against the radial selected with the OBS.

1. **The station sends two 30 Hz signals:**
   - **Reference phase:** a 30 Hz FM signal on a 9960 Hz subcarrier. It is the same in every direction.
   - **Variable phase:** a 30 Hz AM signal made by a rotating antenna pattern. Its phase depends on the compass direction from the station.
   - The two are in phase on the magnetic 360° radial (due north of the station). At any other bearing the variable signal lags the reference by that many degrees. On the 090° radial, for example, it lags by 90°.
2. **The receiver measures your radial:** the phase difference gives the radial you are on, which is your bearing *from* the station. This works the same way anywhere around the station.
3. **The OBS sets what counts as TO and FROM:** the receiver compares your actual radial with the course you dialed in.
   - **Radial within ±90° of the OBS:** the flag shows **FROM**. Flying the selected course takes you away from the station.
   - **Radial within ±90° of the reciprocal (OBS + 180°):** the flag shows **TO**. Flying the selected course takes you toward the station.
   - **Radial about 90° off the OBS:** the flag shows **OFF** or **NAV** (neutral). You are abeam the station relative to the selected course.
4. **Why passing the station flips the flag:** with the OBS at 360° and flying north toward the station, you are on the 180° radial (the reciprocal side), so the flag shows **TO**. Crossing the station moves you to the 0° radial (the OBS side), so it changes to **FROM**. The flag depends on which side of the station you are on, not on your direction of flight. Dialing the OBS to the reciprocal swaps the flag even if you haven't moved.
5. **Inside the instrument:** the comparison of the radial with the OBS setting produces a sense signal that drives the TO/FROM flag. It blanks in the ±90° ambiguity zone, where the sense signal is near zero. The same comparison moves the CDI needle left or right, based on how far your radial is from the OBS.

**Why a localizer has no TO/FROM:** a localizer sends only a left/right deviation signal along one runway centerline. There is no 360° phase relationship to compare against an OBS, so nothing drives the flag. See the previous entry.
