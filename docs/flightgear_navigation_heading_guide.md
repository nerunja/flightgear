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

### The Simple Idea (Straight-Line View)

Forget compass directions for a moment. It is just a line with the VOR on it, and the only question is: **is the nose pointing at the VOR or away from it?**

```
 INBOUND  = nose pointing AT the VOR     (distance to VOR shrinks, flag = TO)
 OUTBOUND = nose pointing AWAY from VOR  (distance to VOR grows,   flag = FROM)


 Aircraft placed here                                   VOR
        ✈ ────────────────────────────────────────►  (VOR)
        INBOUND: closing in, getting closer


        VOR                                   Aircraft placed here
      (VOR)  ◄──────────────────────────────────── ✈
        INBOUND from the other side: still nose toward VOR


        VOR       Aircraft placed here
      (VOR)  ─────────────────────────────►  ✈ ─────►
        OUTBOUND: nose points away, getting farther
```

**The one trap to avoid:** `--offset-azimuth` is where you *are* relative to the VOR (the direction from the VOR to you). It is **not** the direction you are flying.

| You want | Heading rule | Why |
| :--- | :--- | :--- |
| **Outbound** (away) | `--heading` = azimuth | You keep going in the same direction you were placed from the VOR |
| **Inbound** (toward) | `--heading` = azimuth ± 180° | You turn around and point back at the VOR |

**Worked example:** placed at azimuth `045` (North-East of the VOR).
- Outbound: keep heading `045` (continue North-East, away).
- Inbound: heading `045 + 180 = 225` (turn to South-West, toward the VOR).

**Quick sanity check:** with `--offset-distance=5`, DME should start at about 5 NM. If DME counts **down** you are inbound; if it counts **up** you are outbound.

### Common Misconception: "OBS or Heading >= 180 Means Inbound"

**This is false.** The OBS value (or your heading) alone never tells you inbound vs. outbound. It depends on where the aircraft is relative to the VOR.

Rows are the heading you fly; columns are where the aircraft is relative to the VOR. **TO** = inbound (toward the VOR), **FROM** = outbound (away from the VOR), `-` = neither (you are crossing, not flying directly toward or away).

| Heading | North (`000`) | North-East (`045`) | East (`090`) | South-East (`135`) | South (`180`) | South-West (`225`) | West (`270`) | North-West (`315`) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| `360` | FROM | - | - | - | TO | - | - | - |
| `045` | - | FROM | - | - | - | TO | - | - |
| `090` | - | - | FROM | - | - | - | TO | - |
| `135` | - | - | - | FROM | - | - | - | TO |
| `180` | TO | - | - | - | FROM | - | - | - |
| `225` | - | TO | - | - | - | FROM | - | - |
| `270` | - | - | TO | - | - | - | FROM | - |
| `315` | - | - | - | TO | - | - | - | FROM |

The same heading can be inbound from one side and outbound from the other, and inbound headings can be below 180 (`045`, `090`, `135`) or above it (`225`, `270`, `315`).

**What always works:** set the OBS to the course you are flying, then read the flag.

- **TO** flag: flying the OBS course takes you toward the VOR (inbound).
- **FROM** flag: flying the OBS course takes you away from the VOR (outbound).
- Cross-check with DME: counting down is inbound, counting up is outbound.

### Note: How to Measure a Radial (TO vs. FROM)

- **Radial TO the VOR (arrival):** imagine the **aircraft** is at the center/origin (0,0) of a graph, and measure the angle from **North** to the **VOR**.
- **Radial FROM the VOR (departure):** imagine the **VOR** is at the center/origin (0,0) of a graph, and measure the angle from **North** to the **aircraft**.

The two values are always reciprocals (differ by 180°).

> **You'll NEVER need FROM the VOR flying.**
> **You'll ALWAYS be caring about TO the VOR flying.**
>
> In practice, always think in terms of TO the VOR and the OBS course that takes you there.

### Inbound vs. Outbound Diagram

Example: aircraft placed **North-East** of the VOR (`--offset-azimuth=045`).

```
                          N (000°)
                            │
                            │            ✈  Aircraft (spawn point)
                            │         ↙   ↗
                            │      ↙         ↗
                            │   ↙               ↗
                            │ ↙ INBOUND           ↗ OUTBOUND
                            │   heading 225°        heading 045°
                            │   (toward VOR)        (away from VOR)
    W (270°) ───────────── (VOR) ─────────────── E (090°)
                            │
                            │
                          S (180°)
```

- **Azimuth (`--offset-azimuth=045`)** = the direction from the VOR *to* the aircraft (where you are placed).
- **Inbound** = nose points back toward the VOR, so heading = azimuth + 180° = `225`.
- **Outbound** = nose points away from the VOR, so heading = azimuth = `045`.
- Quick check: fly inbound and the TO/FROM flag shows **TO**; fly outbound and it shows **FROM**.

### Positioning Rules Table

| Aircraft Position relative to VOR | Azimuth (`--offset-azimuth`) | Flying INBOUND (Toward VOR) Heading | Flying OUTBOUND (Away from VOR) Heading |
| :--- | :--- | :--- | :--- |
| **North-East** | `045` | `--heading=225` | `--heading=045` |
| **South-West** | `225` | `--heading=045` | `--heading=225` |
| **North** | `000` / `360` | `--heading=180` | `--heading=360` |
| **South** | `180` | `--heading=360` | `--heading=180` |
| **East** | `090` | `--heading=270` | `--heading=090` |
| **West** | `270` | `--heading=090` | `--heading=270` |
| **South-East** | `135` | `--heading=315` | `--heading=135` |
| **North-West** | `315` | `--heading=135` | `--heading=315` |

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

---

## References

- [YouTube video: VOR navigation reference](https://www.youtube.com/watch?v=U-AcHM9x2mA)
