# Photo-Realistic Ground (Satellite Photoscenery)

FlightGear can drape real aerial/satellite imagery over the normal terrain. This is built in (no TerraGear build needed): it reads PNG/DDS files from an `Orthophotos/` folder in a scenery directory.

TerraSync does not carry this imagery. It only syncs FlightGear's generated scenery (terrain, airports, objects, buildings, roads), and photo licences generally don't allow redistribution. You download the imagery yourself with the script below.

## 1. Download imagery

[scripts/photoscenery.sh](../scripts/photoscenery.sh) wraps `creator.py` from [flightgear-photoscenery](https://github.com/frougon/flightgear-photoscenery) (needs `python3`, `requests`, `Pillow`). It clones it, applies [scripts/creator.patch](../scripts/creator.patch) (parallel downloads, retries on server errors, progress output), downloads every FlightGear tile in a lat/lon box, and converts each to DDS with [scripts/png2dds.py](../scripts/png2dds.py).

```bash
# Bay Area (KOAK-KSFO), USGS imagery, laptop profile
PROFILE=laptop scripts/photoscenery.sh USGS 37.5 -122.5 37.87 -122.01

# New York (KJFK, KLGA, KEWR, Manhattan), USGS imagery, laptop profile - 16 tiles, about 1.4 GB of DDS
PROFILE=laptop scripts/photoscenery.sh USGS 40.55 -74.32 40.92 -73.68

# Chennai VOMM, about 3 km around the airport, laptop profile
PROFILE=laptop scripts/photoscenery.sh ArcGIS 12.964 80.140 13.024 80.202

# Same area, RTX profile (for GPUs that support 32768 px textures)
PROFILE=rtx scripts/photoscenery.sh ArcGIS 12.964 80.140 13.024 80.202
```

### By airport code

```bash
# What would it download, and how big? (nothing is downloaded)
PROFILE=laptop scripts/photoscenery.sh ArcGIS --icao VOMM --radius 15 --dry-run

# Download everything within about 15 km of the airport
PROFILE=laptop scripts/photoscenery.sh ArcGIS --icao VOMM --radius 15
```

`--icao` takes the airport centre from FlightGear's own `apt.dat.gz` (the middle of its runway ends), so no coordinates are needed. `--radius` is in **kilometres** (default 5). Whole tiles are downloaded, so the covered area is larger than the circle: a tile is about 14 km tall, and 15 km around VOMM touches 12 tiles. `--dry-run` lists the tiles, which are already present, and rough sizes. `--out <folder>` overrides the output folder. The older form with an explicit lat/lon box still works.

### Detail profiles

The detail level is the size of a tile's **longest side** in pixels, so it never exceeds your GPU's texture limit. Near the equator (below 22 deg latitude, e.g. Chennai) tiles are square, about 14 km on a side. At Bay Area latitudes they are twice as wide as tall, so a 16384 px profile gives 16384x8192 px there. More pixels means sharper ground.

| Profile | Longest side | Ground detail (Chennai) | For | Output folder | Disk per tile (DDS / PNG) |
|---------|-----------|---------------|-----|---------------|---------------------------|
| `PROFILE=laptop` | 16384 px | about 0.85 m/px | GPUs reporting a 16384 px limit (Intel Iris Xe) | `~/fg-ortho/scenery` | 179 MB / about 0.5 GB |
| `PROFILE=rtx` | 32768 px | about 0.42 m/px | NVIDIA RTX class GPUs | `~/fg-ortho/scenery-32k` | 682 MB / about 2 GB |
| `PIXELS=<n>` | any multiple of 2048 | | custom | `~/fg-ortho/scenery-<n/1024>k` | |
| (nothing set) | auto | | reads "Maximum texture size" from `~/.fgfs/fgfs.log`, else 16384 | | |

> **Warning:** do not use a tile size above your GPU's maximum texture size. On the Intel Iris Xe laptop (16384 px limit) a 32768 px tile loads but renders as blank ground. The log shows `Composite orthophoto exceeds the maximum texture size` and `Mipmapped osg::Image not a power of two, cannot apply to texture`. Check the limit with `grep "Maximum texture size" ~/.fgfs/fgfs.log`.

### Options

| Variable | Effect |
|----------|--------|
| `OVERWRITE=1` | replace tiles that already exist (default: skip them) |
| `CLEAN_PNG=1` | delete each PNG after its DDS is made (default: keep PNGs) |
| `NO_DDS=1` | skip the DDS conversion |
| `FG_ORTHO_JOBS=4` | parallel downloads. Be considerate of the provider's servers. |

The script prints per-tile progress and a summary of failed tiles. Re-running it fetches only the missing tiles, so you can extend coverage incrementally by giving a larger box.

### Providers

| Provider | Coverage | Licence |
|----------|----------|---------|
| `USGS` | United States | Public domain (USGS National Map imagery, largely NAIP) |
| `ArcGIS` | Whole world (e.g. India) | Esri terms of use - personal use at your own responsibility |
| `PNOA` | Spain | Open |

Outside the US there is no public-domain provider in the script, so use `ArcGIS` and check Esri's terms. Google Maps and Bing imagery are not supported and their terms forbid this use.

### How sharp can it get?

Esri's imagery near Chennai has real detail down to about 0.29 m/px (zoom 19); finer requests return no data. A full tile at that detail would need about 48,000 px, so 32768 px keeps roughly 70% of it and 16384 px keeps about a third. India restricts distribution of imagery sharper than 1 m, so no free sharper source is available there.

### Tile facts
- Each FlightGear tile is 0.125 deg tall. Its width is 0.125 deg near the equator and 0.25 deg at Bay Area latitudes.
- A radius of 30 km around an airport at 13 deg N is about 24 to 30 tiles. At the laptop profile that is roughly 12 to 16 GB of downloads and about 5 GB of DDS.
- Show a tile index without downloading: `python3 -I ~/fg-ortho/src/flightgear-photoscenery/creator.py --lat 12.99 --lon 80.17 --info_only` (VOMM is tile 4266425).
- Fetching a large area strains the provider's servers. Keep boxes small.

### Other tools and sources

I searched for alternatives (October 2026). None gives sharper imagery than Esri for areas like Chennai.

| Option | What it is | Notes |
|--------|------------|-------|
| [Julia photoscenery generator](https://github.com/abassign/Photoscenary) and its [GUI](https://github.com/abassign/Photoscenery-GUI) | Download by airport and radius, along a route, or live from a running FlightGear | Uses the same servers as `creator.py` (ArcGIS, USGS, PNOA, Geoportal PL), so no better imagery. Needs Julia and ImageMagick. Not tested here. |
| gis2fg | Turns a raster orthophoto you supply into FlightGear tiles, plus OSM roads, buildings and pylons | Does not download imagery. Debian only. The author says its objects are lower quality than osm2city. Not tested here. |
| Sentinel-2 | Free, open, global | 10 m per pixel and over-saturated colours. The forum calls it the best open global option, but it is far less sharp than Esri. |
| Bing | Being added to a Python tool (quadkey tiles) | I could not confirm its status, and its terms of use are not clear. |
| National open orthophotos | Spain (PNOA), Poland (Geoportal), Bavaria, Switzerland (swisstopo, non-commercial) | Best realism where available. Nothing free was found for India. |

FlightGear loads one image per tile, with no higher resolution inside a tile (as of the 2020.3 forum discussion), so you cannot concentrate detail around an airport.

### Roads and buildings look artificial

Photoscenery only replaces the ground texture. Roads, buildings and trees are separate TerraSync layers (osm2city) drawn on top, with generic textures and OSM-derived shapes. To see the photo's real roads and rooftops, turn layers off and restart FlightGear (they are read when tiles load):

```
--prop:/sim/rendering/scenery-path-suffix[1]/enabled=false   # Roads
--prop:/sim/rendering/scenery-path-suffix[2]/enabled=false   # Buildings
--prop:/sim/rendering/scenery-path-suffix[5]/enabled=false   # Trees
```

### Which areas do I have?

```bash
python3 -I scripts/photoscenery-list.py            # areas per profile folder
python3 -I scripts/photoscenery-list.py --tiles    # also one line per tile
python3 -I scripts/photoscenery-list.py ~/fg-ortho/scenery   # any scenery folder
```

It prints each area (a group of touching tiles) with its bounding box, centre, tile count, how many tiles have DDS, and the pixel size, for example `12.625N to 13.375N, 79.875E to 80.375E, 24 tiles (24 with DDS), 16384x16384`.

### Areas downloaded so far

| Area | Provider | Command | Tiles | Result |
|------|----------|---------|-------|--------|
| Chennai, VOMM 30 km | ArcGIS | `PROFILE=laptop scripts/photoscenery.sh ArcGIS 12.725 79.894 13.264 80.30` | 24 | 16384x16384, 179 MB DDS each |
| Chennai, VOMM 40 km (extension) | ArcGIS | `PROFILE=laptop scripts/photoscenery.sh ArcGIS --icao VOMM --radius 40` | 18 new (42 in all: 12.625N to 13.375N, 79.75E to 80.625E) | 16384x16384, 170 MB DDS each; 12 of the new ones are mostly sea. Esri capture dates run from Mar 2025 to Mar 2026, 0.3 to 0.5 m source. Stored in `~/fg-ortho/scenery` |
| Bay Area, KOAK-KSFO | USGS | `PROFILE=laptop scripts/photoscenery.sh USGS 37.5 -122.5 37.87 -122.01` | 6 | 16384x8192, 85 MB DDS each |
| New York, KJFK/KLGA/KEWR | USGS | `PROFILE=laptop scripts/photoscenery.sh USGS 40.55 -74.32 40.92 -73.68` | 16 | 16384x8192, 85 MB DDS each |
| Chennai, VOMM 3 km | ArcGIS | `PROFILE=rtx scripts/photoscenery.sh ArcGIS 12.964 80.140 13.024 80.202` | 2 | 32768x32768 (RTX machines only), 682 MB DDS each |

## 2. DDS

FlightGear prefers `<tile>.dds` over `<tile>.png` in the same folder and needs it compressed (an uncompressed DDS logs a warning). DXT1 with mipmaps cuts texture memory by about 6x: a 16384 px tile drops from about 1 GB of raw RGBA to about 170 MB.

The script converts automatically. To convert by hand (needs only Pillow, no ImageMagick):

```bash
python3 -I scripts/png2dds.py ~/fg-ortho/scenery            # new tiles only
python3 -I scripts/png2dds.py --force ~/fg-ortho/scenery    # redo all
```

> **Stale DDS:** a `.dds` beats the `.png`. If you re-download a tile, regenerate its DDS (`--force`), or FlightGear keeps showing the old image. The script does this for you.

## 3. Use it in FlightGear

1. In the launcher, go to **Add-ons**, then **Additional scenery folders**, and add `~/fg-ortho/scenery` (or `scenery-32k` on an RTX machine). On the command line: `--fg-scenery=$HOME/.fgfs/TerraSync:$HOME/fg-ortho/scenery`.
2. After starting a flight, enable **View > Rendering Options > Satellite Photoscenery**, or start with `--prop:/sim/rendering/photoscenery/enabled=true`.

Keep TerraSync in the scenery path so terrain, airports and models still load. The photos only replace the ground textures. Use one detail folder at a time.

### Full startup settings

The launch options used for the photoscenery flights on the laptop (paste into the launcher's extra command-line options, or append to a `fgfs` command). Remove any space after a trailing `\`, or the line continuation breaks and later flags are dropped.

```bash
--log-level=debug \
--aircraft=c172p-bush36 \
--timeofday=noon \
--enable-hud \
--prop:/sim/hud/current-color=0 \
--prop:/sim/hud/color/red=0.0 \
--prop:/sim/hud/color/green=1.0 \
--prop:/sim/hud/color/blue=0.0 \
--prop:/sim/hud/color/alpha=0.8 \
--prop:/sim/rendering/glide-slope-tunnel=true \
--prop:/sim/rendering/scenery-path-suffix[1]/enabled=false \
--prop:/sim/rendering/scenery-path-suffix[2]/enabled=true \
--fg-scenery=$HOME/.fgfs/TerraSync:$HOME/fg-ortho/scenery \
--prop:/sim/rendering/photoscenery/enabled=true
```

What the scenery lines do:

| Option | Effect |
|--------|--------|
| `--fg-scenery=$HOME/.fgfs/TerraSync:$HOME/fg-ortho/scenery` | Adds the photo folder. Keep TerraSync in the path so terrain, airports and models still load. |
| `--prop:/sim/rendering/photoscenery/enabled=true` | Turns the photo ground on. It is saved to `autosave_2024_1.xml`, so it stays off after a test that disabled it until you set it back. |
| `scenery-path-suffix[1]` = `false` | Roads layer off. The OSM road ribbons are drawn flat over the photo and hide its real roads. Set to `true` to bring them back. |
| `scenery-path-suffix[2]` = `true` | Buildings layer on (generic 3D buildings from OSM). Set to `false` to see the bare photo. |

`--log-level=debug` is only for checking that the photos load (see Troubleshooting); drop it for normal flying.

### What you see in the sim versus the imagery

In the sim the ground photo is softer than the downloaded tile looks in an image viewer. A 16384 px tile over about 13.5 km is roughly 0.85 m per pixel, so from a low altitude the texture is magnified, and 16384 px is the ceiling on a GPU with a 16384 px texture limit. Roads and generic buildings are drawn over the photo, and OSM covers only part of the real building stock, so gaps show the soft photo. The photo reads best from a few thousand feet up, with Roads off.

### Profile folders in this repo

A local copy of the downloaded tiles lives in `photoscenery/` (not tracked by git, see below). Each folder is a complete scenery root with an `Orthophotos/` folder inside:

```
photoscenery/
  16k-px/Orthophotos/   laptop profile (16384 px longest side), PNG + DDS for each tile:
                        Chennai VOMM 30 km (24 tiles, 16384x16384),
                        Bay Area KOAK/KSFO (6 tiles, USGS, 16384x8192),
                        New York KJFK/KLGA/KEWR (16 tiles, USGS, 16384x8192)
  32k-px/Orthophotos/   rtx profile (32768 px). Chennai VOMM only, 2 tiles (PNG + DDS)
```

Point FlightGear at one folder, matching your GPU (run from the repo root, or use the full path):

```bash
# laptop (GPU limit 16384 px)
--fg-scenery=$HOME/.fgfs/TerraSync:$PWD/photoscenery/16k-px
# RTX machine (GPU limit 32768 px)
--fg-scenery=$HOME/.fgfs/TerraSync:$PWD/photoscenery/32k-px
```

In the launcher, add the same folder under Add-ons, Additional scenery folders. Only the `.dds` files are needed to fly. The PNGs are only the source for regenerating DDS.

The imagery is git-ignored on purpose (`.git/info/exclude`). It is too large for normal commits (files over 100 MB are rejected by GitHub), and the Chennai tiles are Esri imagery that must not be redistributed from a public repository. Copy the folders to another machine directly, or regenerate them there with `PROFILE=rtx scripts/photoscenery.sh ...`.

### Settings that stick, and custom scenery order

- **Layer switches are saved.** `--prop:/sim/rendering/scenery-path-suffix[N]/enabled=...` options are written to `~/.fgfs/autosave_2024_1.xml` when FlightGear exits. If you test with Roads (`[1]`) or Buildings (`[2]`) switched off, a later normal launch will also have them off. Restore them by starting once with both set to `true`, or by editing the file while FlightGear is closed (it overwrites the file when it exits).
- **Custom scenery goes before TerraSync.** FlightGear reads object files from each scenery folder in order and stops after the first one that contains terrain. TerraSync has terrain, so a custom folder listed after it is never read. Photoscenery is the exception: orthophotos are found independently, so its position does not matter.

## 4. Troubleshooting
- **Nothing changes:** the most common cause is that the folder is not in the scenery path. Check `~/.fgfs/fgfs.log` after a launch: `scenery-search-paths` must list the photoscenery folder, and `Registered orthophoto for bucket index ...` lines show the tiles it found. With `--log-level=debug`, `Applying satellite orthophoto to terrain object` lines show where the photos were applied.
- **No buildings at all:** check `~/.fgfs/autosave_2024_1.xml`. If the `scenery-path-suffix n="2"` entry (Buildings) or `n="1"` (Roads) says `false`, a test launch switched it off. Start once with `--prop:/sim/rendering/scenery-path-suffix[2]/enabled=true` (and `[1]` for roads).
- **Blank ground:** the tile size is above your GPU's maximum texture size (see the warning above). Switch to a smaller profile.
- **Looks only slightly different on the ground:** from the cockpit, the airport surface, buildings and trees hide the photo. Fly a few thousand feet up over the surrounding area to see it clearly.
- **Memory or stutter:** use DDS, a smaller profile, or a smaller area.
- **Runways look wrong or blurry:** photos are a few years old and sit under airport markings, so expect minor mismatches.

## 5. Experiments (October 2026)

### More buildings from Overture Maps (not recommended on the laptop)

OpenStreetMap supplies only about a third of the buildings around Chennai. In a 15 km box around VOMM, Overture Maps (which merges OSM with Google Open Buildings and Microsoft ML footprints) has about 1.05 million buildings, of which OSM supplies 33%, Google 57% and Microsoft 11%. Almost none have heights (62 buildings), so osm2city guesses them.

It can be run end to end without installing anything system-wide: pull the `vanosten/o2c_container:ws2` image (16.7 GB) and a local `wiktorn/overpass-api` image, convert the Overture parquet to an OSM file, load it into the local Overpass server, and run osm2city against it (the public Overpass server rejects osm2gear requests without a User-Agent and times out on dense tiles). For a 3 km square around VOMM this produced about 29,600 buildings, twice what OSM alone gives.

Things that went wrong and were fixed:
- **Machine-detected buildings on the airfield.** Google/Microsoft footprints can sit on runways, aprons and taxiways; FlightGear treats them as solid. The first build had geometry 0.3 m from a runway centreline. Drop non-OSM footprints within the airfield zone and everything within 40 m of a runway.
- **Wrong scenery order** (see above): the new folder must precede TerraSync, and sit under `Objects/` if TerraSync's `Buildings/` layer is switched off.

Cost: about 20 to 24 fps with the extra buildings against 26 to 30 fps with TerraSync's own, with dips to 3 fps. The visible gain is a denser city with generic facades and guessed heights.

### Terrain shape

The terrain is already good around VOMM. Compared with the Copernicus 30 m model at 1,257 points within 5 km, FlightGear's terrain correlates at 0.94 with a typical difference of about 3 m. FlightGear already has the hills (St Thomas Mount reaches about 120 m); Copernicus peaks are 10 to 20 m higher, and part of its +2 m average is buildings and trees, because it is a surface model. Rebuilding terrain with TerraGear would give a modest gain for a large effort.
