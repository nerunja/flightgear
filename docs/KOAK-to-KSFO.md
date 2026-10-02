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

# Communication Stack Setup (COMM 1 & COMM 2)
| Radio | Channel | Frequency | Identifier / Controller | Operational Role |
| :--- | :--- | :--- | :--- | :--- |
| COMM 1 | Active | 133.77 MHz | KOAK ATIS | Continuous weather and active airport information loop |
| COMM 1 | Standby | 121.90 MHz | KOAK Ground | Taxi clearances on movement areas at Oakland |
| COMM 2 | Active | 134.50 MHz | NorCal Approach | Radar flight following & approach vectoring over SF Bay |
| COMM 2 | Standby | 120.50 MHz | KSFO Tower | Landing clearance on final approach for Runway 19L |

# Navigation Stack Setup (NAV 1 & NAV 2)
| Radio | Channel | Frequency | Station / Identifier | Radial / OBS | Operational Role |
| :--- | :--- | :--- | :--- | :--- | :--- |
| NAV 1 | Active | 111.90 MHz | KOAK Rwy 29 Localizer (I-INB) | 194° | Departure guidance off Oakland Runway 29 |
| NAV 1 | Standby | 116.80 MHz | Oakland VOR (OAK) | — | Visual/IFR en-route fix reference |
| NAV 2 | Active | 115.80 MHz | San Francisco VOR (SFO) | 194° | Distance & radial tracking directly toward SFO field |
| NAV 2 | Standby | 108.90 MHz | KSFO Rwy 19L ILS (I-SFO) | 194° | Flip to Active when ready to lock ILS/Glideslope |

# Complete FlightGear Command-Line Script
--aircraft=c172p \
--airport=KOAK \
--runway=29 \
--timeofday=noon \
--enable-hud \
--enable-ai-models \
--prop:/sim/rendering/draw-glideslope=true \
--prop:/controls/electric/battery-switch=1 \
--prop:/controls/electric/engine[0]/generator=1 \
--prop:/controls/switches/master-avionics=1 \
--prop:/systems/electrical/outputs/avionics=28.0 \
--prop:/systems/electrical/outputs/nav[0]=28.0 \
--prop:/systems/electrical/outputs/nav[1]=28.0 \
--prop:/instrumentation/nav[0]/serviceable=true \
--prop:/instrumentation/nav[1]/serviceable=true \
--prop:/instrumentation/comm[0]/serviceable=true \
--prop:/instrumentation/comm[1]/serviceable=true \
--prop:/instrumentation/nav[0]/power-btn=1 \
--prop:/instrumentation/nav[1]/power-btn=1 \
--prop:/instrumentation/nav[0]/volume=1.0 \
--prop:/instrumentation/nav[1]/volume=1.0 \
--prop:/instrumentation/comm[0]/frequencies/selected-mhz=133.77 \
--prop:/instrumentation/comm[0]/frequencies/selected-mhz-prop=133.77 \
--prop:/instrumentation/comm[0]/frequencies/standby-mhz=121.90 \
--prop:/instrumentation/comm[1]/frequencies/selected-mhz=134.50 \
--prop:/instrumentation/comm[1]/frequencies/selected-mhz-prop=134.50 \
--prop:/instrumentation/comm[1]/frequencies/standby-mhz=120.50 \
--prop:/instrumentation/nav[0]/frequencies/selected-mhz=111.90 \
--prop:/instrumentation/nav[0]/frequencies/selected-mhz-prop=111.90 \
--prop:/instrumentation/nav[0]/frequencies/standby-mhz=116.80 \
--prop:/instrumentation/nav[1]/frequencies/selected-mhz=115.80 \
--prop:/instrumentation/nav[1]/frequencies/selected-mhz-prop=115.80 \
--prop:/instrumentation/nav[1]/frequencies/standby-mhz=108.90 \
--prop:/instrumentation/heading-indicator/offset-deg=0 \
--prop:/instrumentation/heading-indicator/spin=1 \
--prop:/instrumentation/heading-indicator/heading-bug-deg=194 \
--prop:/instrumentation/nav[0]/radials/selected-deg=194 \
--prop:/instrumentation/nav[1]/radials/selected-deg=194