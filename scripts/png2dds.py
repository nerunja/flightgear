#!/usr/bin/env python3
"""Convert photoscenery PNGs to DXT1-compressed DDS with a full mipmap chain.

FlightGear prefers <tile>.dds next to <tile>.png and needs it compressed, which cuts
video/system memory roughly 8x (16384x16384: ~1 GB RGBA -> ~170 MB DXT1 with mipmaps).
Needs only Pillow (no ImageMagick/nvcompress). The image is not flipped, matching
the repo's create_dds.sh.

Usage: png2dds.py <png-or-directory> [...]   (existing .dds files are skipped; --force to redo)
"""
import io
import struct
import sys
from pathlib import Path

from PIL import Image

Image.MAX_IMAGE_PIXELS = None
HEADER = 128  # plain DDS header, no DX10 extension for DXT1


def encode(im):
    buf = io.BytesIO()
    im.save(buf, format="DDS", pixel_format="DXT1")
    return buf.getvalue()


def convert(png, dds):
    im = Image.open(png).convert("RGB")
    w, h = im.size
    levels = []
    first = None
    while True:
        data = encode(im)
        if first is None:
            first = data[:HEADER]
        levels.append(data[HEADER:])
        if w == 1 and h == 1:
            break
        w, h = max(w // 2, 1), max(h // 2, 1)
        im = im.resize((w, h), Image.BOX)
    header = bytearray(first)
    flags, = struct.unpack_from("<I", header, 8)
    struct.pack_into("<I", header, 8, flags | 0x20000)       # DDSD_MIPMAPCOUNT
    struct.pack_into("<I", header, 28, len(levels))           # dwMipMapCount
    caps, = struct.unpack_from("<I", header, 108)
    struct.pack_into("<I", header, 108, caps | 0x401008)      # TEXTURE | MIPMAP | COMPLEX
    tmp = dds.with_suffix(".dds.tmp")
    tmp.write_bytes(bytes(header) + b"".join(levels))
    tmp.rename(dds)
    return len(levels)


def main(args):
    force = "--force" in args
    paths = [Path(a) for a in args if a != "--force"]
    if not paths:
        sys.exit(__doc__)
    pngs = []
    for p in paths:
        pngs += sorted(p.rglob("*.png")) if p.is_dir() else [p]
    for png in pngs:
        dds = png.with_suffix(".dds")
        if dds.exists() and not force:
            print(f"{dds}: already there")
            continue
        n = convert(png, dds)
        print(f"{dds}: {n} mip levels, {png.stat().st_size >> 20} MB png -> {dds.stat().st_size >> 20} MB dds")


if __name__ == "__main__":
    main(sys.argv[1:])
