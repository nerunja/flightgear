# FlightGear Navigation & Heading Guide

Understanding how to position your aircraft relative to a VOR station or airport threshold requires distinguishing between two distinct concepts:

* **Position / Azimuth (`--offset-azimuth`):** Where your plane is placed on the map relative to the reference point (e.g., North-East, South-West).
* **Heading (`--heading`):** Which way the nose of your aircraft is pointed once spawned.

---

## 1. Understanding Headings ($000^\circ$ to $360^\circ$)

Heading is measured as a compass direction clockwise from North ($000^\circ$ or $360^\circ$):

```
                      NORTH (360° / 000°)
                               │
            North-West (315°)  │  North-East (045°)
                            \  │  /
                             \ │ /
    WEST (270°) ───────────────┼─────────────── EAST (090°)
                             / │ \
                            /  │  \
            South-West (225°)  │  South-East (135°)
                               │
                      SOUTH (180°)
```

---

## 2. Reciprocal Headings (Inbound vs. Outbound)

If you spawn at a specific location relative to a VOR, your heading depends on whether you want to **fly toward (inbound)** or **fly away from (outbound)** the VOR station:

$$\text{Inbound Heading} = \text{Position Bearing} \pm 180^\circ$$

### Positioning Rules Table

| Aircraft Position relative to VOR | Azimuth (`--offset-azimuth`) | Flying INBOUND (Toward VOR) Heading | Flying OUTBOUND (Away from VOR) Heading |
| :--- | :--- | :--- | :--- |
| **North-East** | `045` | `--heading=225` | `--heading=045` |
| **South-West** | `225` | `--heading=045` | `--heading=225` |
| **North** | `000` / `360` | `--heading=180` | `--heading=360` |
| **South** | `180` | `--heading=360` | `--heading=180` |
| **East** | `090` | `--heading=270` | `--heading=090` |
| **West** | `270` | `--heading=090` | `--heading=270` |

---

## 3. Command Line Examples (5 NM Offsets)

To position your aircraft 5 nautical miles away relative to a VOR, combine `--vor`, `--offset-distance`, `--offset-azimuth`, and `--heading`:

### Scenario A: 5 NM North-East of SFO VOR, Flying Inbound (Toward VOR)
```bash
--vor=SFO \
--offset-distance=5 \
--offset-azimuth=045 \
--heading=225
```

### Scenario B: 5 NM South-West of SFO VOR, Flying Inbound (Toward VOR)
```bash
--vor=SFO \
--offset-distance=5 \
--offset-azimuth=225 \
--heading=045
```

### Scenario C: 5 NM North of SFO VOR, Flying Inbound (Toward VOR)
```bash
--vor=SFO \
--offset-distance=5 \
--offset-azimuth=000 \
--heading=180
```

---

## 4. Runway Alignment Context (`--heading=194`)

For **KSFO Runway 19L**, the runway itself lies oriented along a heading of **$194^\circ$ magnetic** (South-South-West). 

When positioning north of the airport to fly an approach to 19L, you set `--heading=194` so that the nose points directly down the runway alignment path toward the threshold.