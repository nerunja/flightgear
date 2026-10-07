# FlightGear Documentation & Resources

A comprehensive collection of documentation, guides, and resources for flight simulation using FlightGear, with a focus on the Cessna 172p aircraft.

## About This Repository

This repository contains detailed guides covering all aspects of FlightGear flight simulation - from basic controls to advanced ILS approaches. Whether you're a beginner learning to take off or an experienced pilot practicing instrument approaches, you'll find useful information here.

## Documentation Library

### Quick Start Guides

- **[Keyboard Shortcuts and Controls](docs/Keyboard-Shortcuts-and-Controls.md)** ⌨️
  - Complete keyboard reference
  - Mouse controls and view management
  - Flight controls and autopilot shortcuts
  - Custom key binding examples

- **[Takeoff and Landing Procedures](docs/Takeoff-and-Landing-Procedures.md)** 🛫🛬
  - Realistic takeoff procedures
  - Landing techniques and alignment
  - Visual approach slope indicators (VASI/PAPI)
  - Pattern work and practice exercises

### Navigation Guides

- **[VOR-DME Flying Guide](docs/VOR-DME-Flying-Guide.md)** 📡
  - Understanding VOR and DME systems
  - VOR navigation and tracking
  - DME operation and practical uses
  - Cross-country navigation techniques
  - 6 progressive practice exercises

- **[ILS Approach Guide](docs/ILS-Approach-Guide.md)** 🎯
  - Complete ILS approach procedures
  - Localizer and glideslope tracking
  - Angle of Attack (AoA) for approaches
  - Common Bay Area ILS frequencies
  - Step-by-step approach walkthroughs

- **[Radio Communications and Navigation Aids](docs/Radio-Communications-and-Navigation-Aids.md)** 📻
  - ATIS (Automatic Terminal Information Service)
  - VOR station identification
  - Navigation aid terminology reference
  - Finding radio frequencies
  - Audio panel configuration

- **[KOAK to KSFO Flight Setup](docs/KOAK-to-KSFO.md)** 🛩️
  - Flight parameters and aircraft configuration
  - Nasal console setup
  - Oakland to San Francisco route walkthrough
  - FAQ (e.g. why the NAV flag stays on TO)

- **[Photo-Realistic Ground (Photoscenery)](docs/Photoscenery-Guide.md)** 🛰️
  - Satellite/aerial imagery for any region (USGS for the US, ArcGIS worldwide)
  - Download script and FlightGear setup

### Advanced Systems

- **[Autopilot and GPS Navigation](docs/Autopilot-and-GPS-Navigation.md)** 🤖
  - Heading hold (HDG) operation
  - Altitude and NAV hold modes
  - GPS navigation setup
  - Autopilot best practices
  - Complete navigation examples

### Reference Materials

- **[Command Line Options](docs/Command-Line-Options.md)** 💻
  - Starting FlightGear with options
  - Position and orientation setup
  - Starting in the air
  - Radio frequency pre-configuration
  - Useful command combinations

- **[Scenic Airports Guide](docs/Scenic-Airports-Guide.md)** 🌎
  - Top scenic airports worldwide
  - Famous landmarks (Eiffel Tower, Statue of Liberty, Big Ben)
  - Sightseeing flight tips
  - Regional highlights
  - Scenery installation guide

### Multiplayer

- **[Multiplayer Mode Guide](docs/Multiplayer-Mode-Guide.md)** 👥
  - Connecting to multiplayer servers
  - Using the multiplayer map
  - Finding and tracking aircraft
  - Multiplayer etiquette
  - Organized flight events

## Getting Started

### New to FlightGear?

1. **Install FlightGear**: Download from [flightgear.org](https://www.flightgear.org/)
2. **Select the Cessna 172p**: Available in the default aircraft selection
3. **Start with basics**:
   - Read [Keyboard Shortcuts and Controls](docs/Keyboard-Shortcuts-and-Controls.md)
   - Practice [Takeoff and Landing Procedures](docs/Takeoff-and-Landing-Procedures.md)
4. **Progress to navigation**:
   - Learn [VOR-DME Flying](docs/VOR-DME-Flying-Guide.md)
   - Try [ILS Approaches](docs/ILS-Approach-Guide.md)

### Recommended Learning Path

**Beginner** (First Flights):
1. Keyboard Shortcuts and Controls
2. Takeoff and Landing Procedures
3. Scenic Airports Guide (for practice destinations)

**Intermediate** (Navigation):
1. VOR-DME Flying Guide
2. Radio Communications and Navigation Aids
3. Autopilot and GPS Navigation

**Advanced** (Instrument Flying):
1. ILS Approach Guide
2. Command Line Options (for approach setups)
3. Multiplayer Mode Guide (for shared flights)

## Quick Reference

### Common Frequencies (San Francisco Bay Area)

**VOR Navigation**:
- SFO: 115.80 MHz
- OAK: 116.80 MHz
- SJC: 114.10 MHz

**ILS Approaches**:
- KSFO 28R: 111.70 MHz
- KOAK 29: 108.70 MHz

**ATIS**:
- KSFO: (check charts)
- KOAK: (check charts)

### Essential Keyboard Shortcuts

| Key | Function |
|---|---|
| **Tab** | Mouse control mode |
| **h** | Toggle HUD |
| **F12** | Radio frequencies |
| **Ctrl + M** | Map |
| **Ctrl + C** | Highlight clickable controls |
| **]** | Extend flaps |
| **PgUp/PgDn** | Throttle |
| **Backspace** | Toggle autopilot |

### Useful Command Line Examples

**Standard Practice Flight**:
```bash
--aircraft=c172p --airport=KSFO --runway=28L --timeofday=noon
```

**ILS Approach Setup (KSFO 28R)**:
```bash
--aircraft=c172p --timeofday=noon --enable-hud \
--altitude=3000 --heading=294 --vc=110 \
--vor=SFO --offset-distance=12 --offset-azimuth=294 \
--nav1=111.70
```

## About FlightGear

FlightGear is a free, open-source flight simulator with a strong focus on realism and accuracy.

**Key Features**:
- ✈️ Realistic flight dynamics
- 🎮 Detailed aircraft models (600+ aircraft)
- 🗺️ Real-world navigation data
- 👥 Multiplayer capabilities
- 💻 Cross-platform support (Windows, macOS, Linux)
- 🆓 Completely free and open source
- 🌍 25,000+ airports worldwide

**System Requirements**:
- Modern computer with OpenGL support
- 4GB RAM minimum (8GB recommended)
- 2GB disk space for base installation
- Additional space for scenery downloads

**Download**: [flightgear.org](https://www.flightgear.org/)

## Helpful Tools and Resources

### Online Tools

- **Multiplayer Map**: http://mpmap02.flightgear.org/v3/
- **Server Status**: http://mpmap01.flightgear.org/mpstatus/
- **SkyVector (Charts)**: https://skyvector.com/
- **AirNav (Airport Info)**: https://www.airnav.com/

### FlightGear Community

- **Official Site**: https://www.flightgear.org/
- **Wiki**: https://wiki.flightgear.org/
- **Forums**: https://forum.flightgear.org/
- **GitHub**: https://github.com/FlightGear

### Additional Documentation

- **FlightGear Manual**: https://wiki.flightgear.org/Portal:User
- **Cessna 172p Wiki**: https://wiki.flightgear.org/Cessna_172P
- **Getting Started PDF**: Included with FlightGear installation

## Tips for Success

### For Beginners

1. **Start Simple**: Master basic takeoff and landing before attempting navigation
2. **Use Autopilot**: Reduce workload while learning navigation
3. **Practice at KSFO**: Large, forgiving airport with good facilities
4. **Enable HUD**: Helpful for learning airspeeds and attitudes
5. **Disable Damage**: Use `--prop:/sim/crash/detect=false` while learning

### For Navigation Practice

1. **Use the Map**: Ctrl + M is your friend
2. **Identify Stations**: Always verify VOR/ILS Morse code
3. **Start in Air**: Use command line options to start at optimal positions
4. **Track Your Progress**: Use multiplayer map even when flying solo
5. **Keep Notes**: Write down frequencies and procedures that work

### For IFR Training

1. **Study the Guides**: Read ILS and VOR guides thoroughly
2. **Use Glide Slope Tunnel**: Visual aid for learning glideslope tracking
3. **Practice Approaches**: Repeat approaches until comfortable
4. **Try Different Weather**: Practice in various conditions
5. **Go Around**: Don't force bad approaches - practice missed approach procedures

## Troubleshooting

### Common Issues

**Can't see instruments clearly**:
- Adjust seat height: Alt + PgUp/PgDn
- Zoom view: x/X keys
- Adjust cockpit position: Ctrl + Right Click + Drag

**Aircraft won't respond to controls**:
- Check mouse control mode (Tab)
- Verify controls aren't locked
- Try pressing Numpad 5 to reset

**VOR/ILS not working**:
- Verify correct frequency tuned
- Check volume is FULL
- Ensure audio panel speaker ON
- Listen for Morse code identifier
- Confirm you're in range

**Poor performance**:
- Reduce rendering distance
- Disable 3D clouds: `--prop:/sim/rendering/clouds3d-enable=false`
- Lower scenery detail in settings
- Close other applications

## Contributing

Contributions are welcome! If you'd like to add guides, corrections, or improvements:

1. Fork this repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

**Ideas for Contributions**:
- Additional aircraft guides
- More advanced procedures (holdings, DME arcs)
- Regional airport guides
- Screenshots and diagrams
- Translations

## License

This documentation is provided as-is for educational purposes. Feel free to use, share, and modify as needed.

## Acknowledgments

- FlightGear development team for creating an amazing free simulator
- FlightGear community for sharing knowledge and support
- All contributors to FlightGear documentation

---

**Document Version**: 2.0
**Last Updated**: January 25, 2026
**Status**: Active Development

**Questions or Issues?** Open an issue on GitHub or visit the FlightGear forums.
