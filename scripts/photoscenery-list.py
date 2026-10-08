#!/usr/bin/env python3
"""List which areas have photoscenery in one or more scenery folders.

Reads every <index>.dds / <index>.png under <folder>/Orthophotos, converts the FlightGear
tile index to latitude/longitude, and prints each tile plus the areas (groups of touching
tiles) with their bounding box and centre. Standard library only.

Usage: photoscenery-list.py [folder ...]    (default: photoscenery/16k-px photoscenery/32k-px,
                                             falling back to ~/fg-ortho/scenery*)
       photoscenery-list.py --tiles ...     also print one line per tile
Run it with: python3 -I scripts/photoscenery-list.py
"""
import glob
import os
import struct
import sys

TABLE = [(0, 0.125), (22, 0.25), (62, 0.5), (76, 1.0), (83, 2.0), (86, 4.0), (89, 12.0), (90, None)]


def tile_width(lat):
    for (a, w), (b, _) in zip(TABLE, TABLE[1:]):
        if a <= abs(lat) < b:
            return w


def bounds(index):
    """FlightGear tile index -> (min_lat, max_lat, min_lon, max_lon)."""
    lon = (index >> 14) - 180
    lat = ((index - ((lon + 180) << 14)) >> 6) - 90
    y = (index - (((lon + 180) << 14) + ((lat + 90) << 6))) >> 3
    x = index - ((((lon + 180) << 14) + ((lat + 90) << 6)) + (y << 3))
    w = tile_width(lat)
    return (lat + 0.125 * y, lat + 0.125 * (y + 1), lon + x * w, lon + (x + 1) * w)


def image_size(path):
    with open(path, "rb") as f:
        head = f.read(32)
    if path.endswith(".dds"):
        h, w = struct.unpack_from("<II", head, 12)
    else:
        w, h = struct.unpack_from(">II", head, 16)
    return w, h


def hemi(v, pos, neg):
    return f"{abs(v):.3f}{pos if v >= 0 else neg}"


def scan(folder):
    tiles = {}
    for path in glob.glob(os.path.join(folder, "Orthophotos", "*", "*", "*.*")):
        stem, ext = os.path.splitext(os.path.basename(path))
        if ext not in (".dds", ".png") or not stem.isdigit():
            continue
        t = tiles.setdefault(int(stem), {"formats": set(), "size": None})
        t["formats"].add(ext[1:])
        if ext == ".dds" or t["size"] is None:
            t["size"] = image_size(path)
    return tiles


def groups(tiles):
    """Connected groups of tiles whose boxes touch or overlap."""
    boxes = {i: bounds(i) for i in tiles}
    left, out = set(boxes), []
    eps = 1e-9
    while left:
        stack = [left.pop()]
        comp = set(stack)
        while stack:
            a = boxes[stack.pop()]
            for j in list(left):
                b = boxes[j]
                if a[0] <= b[1] + eps and b[0] <= a[1] + eps and a[2] <= b[3] + eps and b[2] <= a[3] + eps:
                    left.discard(j)
                    comp.add(j)
                    stack.append(j)
        out.append(sorted(comp))
    return sorted(out, key=lambda c: (-boxes[c[0]][0], boxes[c[0]][2]))


def main(argv):
    show_tiles = "--tiles" in argv
    folders = [a for a in argv if not a.startswith("--")]
    if not folders:
        here = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        folders = [p for p in (os.path.join(here, "photoscenery", "16k-px"), os.path.join(here, "photoscenery", "32k-px")) if os.path.isdir(p)]
        folders = folders or sorted(glob.glob(os.path.expanduser("~/fg-ortho/scenery*")))
    if not folders:
        sys.exit("No scenery folders found. Pass one or more scenery folders.")
    for folder in folders:
        tiles = scan(folder)
        print(f"\n{folder}: {len(tiles)} tiles")
        for comp in groups(tiles):
            bs = [bounds(i) for i in comp]
            la0, la1 = min(b[0] for b in bs), max(b[1] for b in bs)
            lo0, lo1 = min(b[2] for b in bs), max(b[3] for b in bs)
            sizes = sorted({tiles[i]["size"] for i in comp})
            dds = sum("dds" in tiles[i]["formats"] for i in comp)
            sizes_txt = ", ".join(f"{w}x{h}" for w, h in sizes)
            print(f"  area: {hemi(la0,'N','S')} to {hemi(la1,'N','S')}, {hemi(lo0,'E','W')} to {hemi(lo1,'E','W')}"
                  f"  centre {(la0+la1)/2:.3f},{(lo0+lo1)/2:.3f}  {len(comp)} tiles ({dds} with DDS)  {sizes_txt}")
            if show_tiles:
                for i in comp:
                    b = bounds(i)
                    t = tiles[i]
                    print(f"    {i}  {hemi(b[0],'N','S')}..{hemi(b[1],'N','S')}  {hemi(b[2],'E','W')}..{hemi(b[3],'E','W')}  {t['size'][0]}x{t['size'][1]}  {'+'.join(sorted(t['formats']))}")


if __name__ == "__main__":
    main(sys.argv[1:])
