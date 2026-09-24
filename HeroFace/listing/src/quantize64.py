"""Snap an RGB(A) PNG to Garmin's 64-color palette (channels 00/55/AA/FF) for the store's
"Device 64 Color" icon; Chrome's SVG rendering antialiases edges into off-palette colors."""
import struct, sys, zlib

def read(path):
    d = open(path, 'rb').read(); i = 8; idat = b''
    while i < len(d):
        l, t = struct.unpack('>I4s', d[i:i + 8]); c = d[i + 8:i + 8 + l]; i += 12 + l
        if t == b'IHDR': w, h, _, ct = struct.unpack('>IIBB', c[:10])
        if t == b'IDAT': idat += c
    bpp = {2: 3, 6: 4}[ct]; raw = zlib.decompress(idat); st = w * bpp
    prev = bytearray(st); rows = []; o = 0
    for _ in range(h):
        f = raw[o]; o += 1; line = bytearray(raw[o:o + st]); o += st
        for x in range(st):
            a = line[x - bpp] if x >= bpp else 0; b = prev[x]; c = prev[x - bpp] if x >= bpp else 0
            if f == 1: line[x] = (line[x] + a) & 255
            elif f == 2: line[x] = (line[x] + b) & 255
            elif f == 3: line[x] = (line[x] + ((a + b) >> 1)) & 255
            elif f == 4:
                p = a + b - c; pa, pb, pc = abs(p - a), abs(p - b), abs(p - c)
                line[x] = (line[x] + (a if pa <= pb and pa <= pc else b if pb <= pc else c)) & 255
        prev = line; rows.append(bytes(v for k in range(0, st, bpp) for v in line[k:k + 3]))
    return w, h, rows

def write(path, w, h, rows):
    chunk = lambda t, c: struct.pack('>I', len(c)) + t + c + struct.pack('>I', zlib.crc32(t + c))
    data = zlib.compress(b''.join(b'\0' + r for r in rows), 9)
    open(path, 'wb').write(b'\x89PNG\r\n\x1a\n' + chunk(b'IHDR', struct.pack('>IIBBBBB', w, h, 8, 2, 0, 0, 0))
                           + chunk(b'IDAT', data) + chunk(b'IEND', b''))

w, h, rows = read(sys.argv[1])
snap = lambda v: min((0, 0x55, 0xAA, 0xFF), key=lambda s: abs(s - v))
write(sys.argv[2], w, h, [bytes(snap(v) for v in r) for r in rows])
