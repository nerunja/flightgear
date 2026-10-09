#!/usr/bin/env bash
# Download photoscenery (satellite orthophotos) for FlightGear, as DDS.
#
# Usage:
#   scripts/photoscenery.sh <provider> --icao <CODE> [--radius <km>] [--out <folder>] [--dry-run]
#   scripts/photoscenery.sh <provider> <latMin> <lonMin> <latMax> <lonMax> [scenery_folder] [--dry-run]
#
#   provider  USGS (US only, public domain) | ArcGIS (world, Esri terms) | PNOA (Spain)
#   --icao    airport code; the centre is taken from FlightGear's apt.dat (runway coordinates)
#   --radius  kilometres around the airport (default 5). Whole tiles are downloaded, so the
#             covered area is larger than the circle (a tile is about 14 km tall).
#   --dry-run list the tiles and estimated sizes, download nothing
#
# Detail = size of a tile's LONGEST side in pixels (tiles are wider than tall away from the tropics) - pick one:
#   PROFILE=laptop   16384 px  (~0.85 m/px, GPUs with GL_MAX_TEXTURE_SIZE 16384, e.g. Intel Iris Xe)
#   PROFILE=rtx      32768 px  (~0.42 m/px, NVIDIA RTX class GPUs)
#   PIXELS=<n>       any multiple of 2048
#   (default) auto:  largest size the GPU reports in ~/.fgfs/fgfs.log ("Maximum texture size"), else 16384
# Other env: OVERWRITE=1 replace existing tiles | NO_DDS=1 skip the DDS conversion
#            CLEAN_PNG=1 delete each PNG after its DDS is made (PNGs are kept by default)
#            FG_ORTHO_JOBS=4 parallel downloads | APT_DAT=<file> airport database for --icao
# Output folder: ~/fg-ortho/scenery for 16384 px, ~/fg-ortho/scenery-<N>k otherwise.
#
# Example (Chennai VOMM, 15 km, laptop):  PROFILE=laptop scripts/photoscenery.sh ArcGIS --icao VOMM --radius 15
# Example (check the size first):         PROFILE=laptop scripts/photoscenery.sh ArcGIS --icao VOMM --radius 15 --dry-run
# Example (RTX, explicit box):            PROFILE=rtx scripts/photoscenery.sh ArcGIS 12.964 80.140 13.024 80.202
set -uo pipefail
usage() { sed -n 2,27p "$0"; exit 1; }
[ $# -ge 2 ] || usage
PROVIDER=$1; shift
HERE=$(dirname "$(readlink -f "$0")")

ICAO=""; RADIUS=5; OUT_ARG=""; DRY=""; POS=()
while [ $# -gt 0 ]; do
  case "$1" in
    --icao)    ICAO=${2:?--icao needs a code}; shift 2 ;;
    --radius)  RADIUS=${2:?--radius needs kilometres}; shift 2 ;;
    --out)     OUT_ARG=${2:?--out needs a folder}; shift 2 ;;
    --dry-run) DRY=1; shift ;;
    -h|--help) usage ;;
    --*)       echo "Unknown option $1"; usage ;;
    *)         POS+=("$1"); shift ;;
  esac
done

if [ -n "$ICAO" ]; then
  [ ${#POS[@]} -eq 0 ] || { echo "Use either --icao or a lat/lon box, not both"; exit 1; }
  APT=${APT_DAT:-$(ls -d "$HOME"/.fgfs/fgdata_*/Airports/apt.dat.gz 2>/dev/null | sort -V | tail -1)}
  [ -n "$APT" ] && [ -f "$APT" ] || { echo "apt.dat.gz not found (set APT_DAT=<file>)"; exit 1; }
  # Airport centre = middle of the box around all its runway ends / helipads (apt.dat row codes 100, 101, 102).
  read -r CLAT CLON CNAME < <(python3 -I - "$ICAO" "$APT" <<'PY'
import gzip, sys
code, path = sys.argv[1].upper(), sys.argv[2]
name, pts, inside = None, [], False
with gzip.open(path, "rt", encoding="utf-8", errors="replace") as f:
    for line in f:
        p = line.split()
        if not p:
            continue
        if p[0] in ("1", "16", "17"):
            if inside:
                break
            if len(p) > 4 and p[4].upper() == code:
                inside, name = True, " ".join(p[5:])
            continue
        if not inside:
            continue
        try:
            if p[0] == "100":
                pts += [(float(p[9]), float(p[10])), (float(p[18]), float(p[19]))]
            elif p[0] == "101":
                pts += [(float(p[4]), float(p[5])), (float(p[7]), float(p[8]))]
            elif p[0] == "102":
                pts.append((float(p[2]), float(p[3])))
        except (ValueError, IndexError):
            pass
if not pts:
    sys.exit(1)
la = [x[0] for x in pts]; lo = [x[1] for x in pts]
print(round((min(la) + max(la)) / 2, 5), round((min(lo) + max(lo)) / 2, 5), name)
PY
  ) || { echo "Airport '$ICAO' not found in $APT"; exit 1; }
  read -r LAT0 LON0 LAT1 LON1 < <(python3 -I - "$CLAT" "$CLON" "$RADIUS" <<'PY'
import math, sys
lat, lon, r = map(float, sys.argv[1:4])
dlat = r / 111.32
dlon = r / (111.32 * math.cos(math.radians(lat)))
print(round(lat - dlat, 5), round(lon - dlon, 5), round(lat + dlat, 5), round(lon + dlon, 5))
PY
  )
  echo "$ICAO ($CNAME) at $CLAT, $CLON; radius $RADIUS km -> box $LAT0..$LAT1 N, $LON0..$LON1 E"
else
  [ ${#POS[@]} -ge 4 ] || usage
  LAT0=${POS[0]}; LON0=${POS[1]}; LAT1=${POS[2]}; LON1=${POS[3]}
  [ -z "${POS[4]:-}" ] || OUT_ARG=${POS[4]}
fi

case "${PROFILE:-}" in
  laptop) PIXELS=16384 ;;
  rtx)    PIXELS=32768 ;;
  "")     : ;;
  *)      echo "Unknown PROFILE '$PROFILE' (use laptop or rtx, or set PIXELS)"; exit 1 ;;
esac
if [ -z "${PIXELS:-}" ]; then
  PIXELS=$(sed -n 's/.*Maximum texture size \([0-9]*\).*/\1/p' "$HOME/.fgfs/fgfs.log" 2>/dev/null | tail -1)
  PIXELS=${PIXELS:-16384}
  echo "Auto-detected max texture size: $PIXELS px"
fi
[ $((PIXELS % 2048)) -eq 0 ] || { echo "PIXELS must be a multiple of 2048"; exit 1; }
if [ "$PIXELS" -eq 16384 ]; then DEFAULT_OUT=$HOME/fg-ortho/scenery; else DEFAULT_OUT=$HOME/fg-ortho/scenery-$((PIXELS / 1024))k; fi
OUT=${OUT_ARG:-$DEFAULT_OUT}
CREATOR=${CREATOR:-$HOME/fg-ortho/src/flightgear-photoscenery/creator.py}

if [ ! -f "$CREATOR" ]; then
  git clone --depth 1 https://github.com/frougon/flightgear-photoscenery.git "$(dirname "$CREATOR")" || exit 1
  # Per-request retries/timeouts and parallel downloads; upstream gives up on a whole tile after one HTTP 5xx.
  git -C "$(dirname "$CREATOR")" apply "$HERE/creator.patch" || exit 1
fi

echo "Longest tile side ${PIXELS} px -> $OUT"

# Sample the box (including its far edges) and let creator.py map each point to its tile.
POINTS="${TMPDIR:-/tmp}/photoscenery-points.$$"
trap 'rm -f "$POINTS"' EXIT
python3 -I - "$LAT0" "$LON0" "$LAT1" "$LON1" <<'PY' > "$POINTS"
import sys
la0, lo0, la1, lo1 = map(float, sys.argv[1:5])
def steps(a, b, d=0.125):
    v = [a]
    while v[-1] + d < b:
        v.append(v[-1] + d)
    return v + [b]
for lat in steps(la0, la1):
    for lon in steps(lo0, lo1):
        print(lat, lon)
PY

SEEN=""; FAILED=0; NEW=0; HAVE=0; DDS_MB=0; PNG_MB=0
while read -r lat lon; do
  # Several sample points can fall in the same tile; fetch each tile only once.
  info=$(python3 -I "$CREATOR" --lat "$lat" --lon "$lon" --info_only | grep Index)
  idx=${info##*Index: }
  case " $SEEN " in *" $idx "*) continue ;; esac
  SEEN="$SEEN $idx"
  # Tile width/height ratio (1 below 22 deg latitude, 2 up to 62 deg, ...): the longest side gets $PIXELS px.
  ratio=$(printf '%s' "$info" | python3 -I -c "import sys,re; v=[float(x) for x in re.findall(r\"'m(?:in|ax)_(?:lat|lon)': ([-\d.]+)\", sys.stdin.read())]; print(round((v[3]-v[2])/(v[1]-v[0])))")
  COLS=$((PIXELS / 2048 / ratio))
  if [ "$COLS" -lt 1 ]; then echo "== Tile $idx: too wide for $PIXELS px (width ratio $ratio), skipping"; continue; fi
  if [ -z "${OVERWRITE:-}" ] && [ -n "$(find "$OUT/Orthophotos" \( -name "$idx.dds" -o -name "$idx.png" \) 2>/dev/null | head -1)" ]; then
    echo "== Tile $idx already present, skipping (OVERWRITE=1 to replace)"; HAVE=$((HAVE + 1)); continue
  fi
  # Rough sizes: DXT1 with mipmaps ~0.67 byte/px, PNG ~2 byte/px (less over sea or fields).
  px_m=$(( (PIXELS / ratio) * PIXELS / 1000000 ))
  NEW=$((NEW + 1)); DDS_MB=$((DDS_MB + px_m * 2 / 3)); PNG_MB=$((PNG_MB + px_m * 2))
  if [ -n "$DRY" ]; then echo "== Tile $idx ($lat, $lon) would download: $((COLS * ratio * 2048))x$((COLS * 2048)) px"; continue; fi
  echo "== Tile $idx ($lat, $lon) ${COLS}x${COLS} pieces"
  python3 -I "$CREATOR" --lat "$lat" --lon "$lon" --provider "$PROVIDER" \
    --cols "$COLS" --theight 2048 ${OVERWRITE:+--overwrite} --scenery_folder "$OUT" 2>&1 \
    | grep --line-buffered -E 'PROGRESS|Exception|Joining|already exists|Error|retry' | sed -u 's/^[A-Z]*:root://'
  if [ "${PIPESTATUS[0]}" -ne 0 ]; then echo "!! Tile $idx FAILED"; FAILED=$((FAILED + 1)); continue; fi
  if [ -z "${NO_DDS:-}" ]; then
    # Convert only this tile's PNG (regenerates the DDS so a stale one never hides a new download).
    png=$(find "$OUT/Orthophotos" -name "$idx.png" | head -1)
    if [ -n "$png" ]; then
      python3 -I "$HERE/png2dds.py" --force "$png" && [ -n "${CLEAN_PNG:-}" ] && rm -f "$png"
    fi
  fi
done < "$POINTS"

if [ -n "$DRY" ]; then
  echo "Dry run: $NEW tile(s) to download, $HAVE already present."
  echo "Estimated: about $((DDS_MB / 100 / 10)).$((DDS_MB / 100 % 10)) GB of DDS, about $((PNG_MB / 100 / 10)).$((PNG_MB / 100 % 10)) GB of PNG/download (upper estimate; sea and rural tiles are smaller)."
  exit 0
fi
echo "Done ($FAILED tile(s) failed). Add '$OUT' as an additional scenery folder in the FlightGear launcher."
[ "$FAILED" -eq 0 ]
