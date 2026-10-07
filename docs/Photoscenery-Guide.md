# Photo-Realistic Ground (Satellite Photoscenery)

FlightGear can drape real aerial/satellite imagery over the normal terrain. This is built in (no TerraGear build needed): it reads PNG/DDS files from an `Orthophotos/` folder in a scenery directory.

TerraSync does not carry this imagery. It only syncs FlightGear's generated scenery (terrain, airports, objects, buildings, roads), and photo licences generally don't allow redistribution. You download the imagery yourself with the script below.

## 1. Download imagery

[scripts/photoscenery.sh](../scripts/photoscenery.sh) wraps `creator.py` from [flightgear-photoscenery](https://github.com/frougon/flightgear-photoscenery) (needs `python3`, `requests`, `Pillow`). It clones it, applies [scripts/creator.patch](../scripts/creator.patch) (parallel downloads, retries on server errors, progress output), downloads every FlightGear tile in a lat/lon box, and converts each to DDS with [scripts/png2dds.py](../scripts/png2dds.py).

```bash
# Bay Area (KOAK-KSFO), USGS imagery, laptop profile
PROFILE=laptop scripts/photoscenery.sh USGS 37.5 -122.5 37.87 -122.01

# Chennai VOMM, about 3 km around the airport, laptop profile
PROFILE=laptop scripts/photoscenery.sh ArcGIS 12.964 80.140 13.024 80.202

# Same area, RTX profile (for GPUs that support 32768 px textures)
PROFILE=rtx scripts/photoscenery.sh ArcGIS 12.964 80.140 13.024 80.202
```

### Detail profiles

The detail level is the size of each tile in pixels. A tile is about 14 km tall, so more pixels means sharper ground.

| Profile | Tile size | Ground detail | For | Output folder | Disk per tile (DDS / PNG) |
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

## 4. Troubleshooting
- **Nothing changes:** the most common cause is that the folder is not in the scenery path. Check `~/.fgfs/fgfs.log` after a launch: `scenery-search-paths` must list the photoscenery folder, and `Registered orthophoto for bucket index ...` lines show the tiles it found. With `--log-level=debug`, `Applying satellite orthophoto to terrain object` lines show where the photos were applied.
- **Blank ground:** the tile size is above your GPU's maximum texture size (see the warning above). Switch to a smaller profile.
- **Looks only slightly different on the ground:** from the cockpit, the airport surface, buildings and trees hide the photo. Fly a few thousand feet up over the surrounding area to see it clearly.
- **Memory or stutter:** use DDS, a smaller profile, or a smaller area.
- **Runways look wrong or blurry:** photos are a few years old and sit under airport markings, so expect minor mismatches.
