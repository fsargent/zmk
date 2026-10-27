#!/usr/bin/env python3
"""Render the local Sweep keymap into a self-contained, offline practice page."""
from pathlib import Path
import argparse
import hashlib
import json
import re

ROOT = Path(__file__).resolve().parents[1]
CONFIG = ROOT / 'zmk-config/config'
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--pending', action='store_true', help='Show that the current config still needs flashing')
args = parser.parse_args()

def uncomment(text):
    return re.sub(r'//[^\n]*|/\*.*?\*/', '', text, flags=re.S)

def split_args(text):
    parts, start, depth = [], 0, 0
    for i, char in enumerate(text):
        depth += (char == '(') - (char == ')')
        if char == ',' and depth == 0:
            parts.append(text[start:i].strip())
            start = i + 1
    return parts + [text[start:].strip()]

source = (CONFIG / 'cradio.keymap').read_text()
combo_source = (CONFIG / 'combos.dtsi').read_text()
clean = uncomment(source)
constants = dict((name, int(number)) for name, number in re.findall(r'^#define (\w+) (\d+)\s*$', clean, re.M))
layers = []
for match in re.finditer(r'(\w+_layer)\s*\{\s*display-name\s*=\s*"([^"]+)";\s*bindings\s*=\s*<(.*?)>;', clean, re.S):
    bindings = [re.sub(r'\s+', ' ', b).strip() for b in re.findall(r'&\w+[^&]*', match[3])]
    if len(bindings) != 34:
        raise ValueError(f'{match[1]}: expected 34 bindings, got {len(bindings)}')
    layers.append({'node': match[1], 'name': match[2], 'bindings': bindings})
assert len(layers) == 6, f'Expected six layers, got {len(layers)}'
combos = []
for line in uncomment(combo_source).splitlines():
    if not line.startswith('COMBO('):
        continue
    name, binding, positions, active = split_args(line[6:-1])
    combos.append({'name': name, 'binding': binding,
                   'positions': list(map(int, positions.split())),
                   'layers': [constants[layer] for layer in active.split()], 'timeout': 50})
for match in re.finditer(r'combo_(\w+)\s*\{(.*?)\};', uncomment(combo_source), re.S):
    body = match[2]
    binding = re.search(r'bindings\s*=\s*<(.*?)>', body, re.S)[1].strip()
    positions = re.search(r'key-positions\s*=\s*<(.*?)>', body, re.S)[1]
    active = re.search(r'layers\s*=\s*<(.*?)>', body, re.S)[1]
    timeout = int(re.search(r'timeout-ms\s*=\s*<(\d+)>', body)[1])
    combos.append({'name': match[1], 'binding': binding,
                   'positions': list(map(int, positions.split())),
                   'layers': [constants[layer] for layer in active.split()], 'timeout': timeout})
assert combos and len({combo["name"] for combo in combos}) == len(combos)
assert all(0 <= position < 34 for combo in combos for position in combo["positions"])
hold_timings = {}
for name, term, idle in re.findall(r'HOME_MOD\((hr_\w+),\s*(\d+),\s*(\d+),', clean):
    hold_timings[name] = {'term': int(term), 'idle': int(idle), 'quick': 300}
for name in ['sh', 'hm', 'thumb']:
    body = re.search(r'\b' + name + r':\s*\w+\s*\{(.*?)\};', clean, re.S)[1]
    hold_timings[name] = {key: int(value) for key, value in
        ((short, re.search(long + r'\s*=\s*<(\d+)>', body)[1])
         for short, long in [('term', 'tapping-term-ms'), ('quick', 'quick-tap-ms')])}
data = {'layers': layers, 'combos': combos, 'constants': constants, 'timings': hold_timings,
        'pendingFirmware': args.pending,
        'sourceHash': hashlib.sha256((source + combo_source).encode()).hexdigest()[:12]}
template = (ROOT / 'scripts/sweep-keymap.template.html').read_text()
assert template.count('/*__KEYMAP_DATA__*/') == 1
output = template.replace('/*__KEYMAP_DATA__*/', json.dumps(data, ensure_ascii=False).replace('</', '<\\/'))
(ROOT / 'sweep-keymap.html').write_text(output)
print(f'Rendered sweep-keymap.html: {len(layers)} layers, {len(combos)} combos, source {data["sourceHash"]}')
