#!/usr/bin/env bash
# Download photoscenery (satellite orthophotos) for a lat/lon box, for FlightGear, as DDS.
# Usage: scripts/photoscenery.sh <provider> <latMin> <lonMin> <latMax> <lonMax> [scenery_folder]
#   provider: USGS (US only, public domain) | ArcGIS (world, Esri terms) | PNOA (Spain)
#
# Detail (tile height in pixels) - pick one:
#   PROFILE=laptop   16384 px  (~0.85 m/px, GPUs with GL_MAX_TEXTURE_SIZE 16384, e.g. Intel Iris Xe)
#   PROFILE=rtx      32768 px  (~0.42 m/px, NVIDIA RTX class GPUs)
#   PIXELS=<n>       any power of two from 2048 up
#   (default) auto:  largest size the GPU reports in ~/.fgfs/fgfs.log ("Maximum texture size"), else 16384
# Other env: OVERWRITE=1 replace existing tiles | NO_DDS=1 skip the DDS conversion
#            CLEAN_PNG=1 delete each PNG after its DDS is made (PNGs are kept by default)
#            FG_ORTHO_JOBS=4 parallel downloads
# Output folder: ~/fg-ortho/scenery for 16384 px, ~/fg-ortho/scenery-<N>k otherwise (override with arg 6).
#
# Example (Chennai VOMM, 3 km, laptop):  PROFILE=laptop scripts/photoscenery.sh ArcGIS 12.964 80.140 13.024 80.202
# Example (Chennai VOMM, 3 km, RTX):     PROFILE=rtx    scripts/photoscenery.sh ArcGIS 12.964 80.140 13.024 80.202
set -uo pipefail
[ $# -ge 5 ] || { sed -n 2,20p "$0"; exit 1; }
PROVIDER=$1; LAT0=$2; LON0=$3; LAT1=$4; LON1=$5
HERE=$(dirname "$(readlink -f "$0")")

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
COLS=$((PIXELS / 2048))
if [ "$PIXELS" -eq 16384 ]; then DEFAULT_OUT=$HOME/fg-ortho/scenery; else DEFAULT_OUT=$HOME/fg-ortho/scenery-$((PIXELS / 1024))k; fi
OUT=${6:-$DEFAULT_OUT}
CREATOR=${CREATOR:-$HOME/fg-ortho/src/flightgear-photoscenery/creator.py}

if [ ! -f "$CREATOR" ]; then
  git clone --depth 1 https://github.com/frougon/flightgear-photoscenery.git "$(dirname "$CREATOR")" || exit 1
  # Per-request retries/timeouts and parallel downloads; upstream gives up on a whole tile after one HTTP 5xx.
  git -C "$(dirname "$CREATOR")" apply "$HERE/creator.patch" || exit 1
fi

echo "Tile size ${PIXELS}x${PIXELS} px (${COLS}x${COLS} pieces per tile) -> $OUT"

# Sample the box (including its far edges) and let creator.py map each point to its tile.
python3 -I - "$LAT0" "$LON0" "$LAT1" "$LON1" <<'PY' > "${TMPDIR:-/tmp}/photoscenery-points.$$"
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
POINTS="${TMPDIR:-/tmp}/photoscenery-points.$$"
trap 'rm -f "$POINTS"' EXIT

SEEN=""; FAILED=0
while read -r lat lon; do
  # Several sample points can fall in the same tile; fetch each tile only once.
  info=$(python3 -I "$CREATOR" --lat "$lat" --lon "$lon" --info_only | grep Index)
  idx=${info##*Index: }
  case " $SEEN " in *" $idx "*) continue ;; esac
  SEEN="$SEEN $idx"
  if [ -z "${OVERWRITE:-}" ] && [ -n "$(find "$OUT/Orthophotos" \( -name "$idx.dds" -o -name "$idx.png" \) 2>/dev/null | head -1)" ]; then
    echo "== Tile $idx already present, skipping (OVERWRITE=1 to replace)"; continue
  fi
  echo "== Tile $idx ($lat, $lon)"
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

echo "Done ($FAILED tile(s) failed). Add '$OUT' as an additional scenery folder in the FlightGear launcher."
[ "$FAILED" -eq 0 ]
