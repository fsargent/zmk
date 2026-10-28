# Sweep home row mods

Adapted from the local daily-driver Glove80 QWERTY keymap, without the
Glorious Engrammer layer system or its special multi-mod chord macros.

| Finger | Left key | Right key | Hold | Threshold | Prior idle |
| --- | --- | --- | --- | --- | --- |
| Pinky | A | quote | Ctrl | 260 ms | 150 ms |
| Ring | S | L | Alt | 240 ms | 150 ms |
| Middle | D | K | Cmd | 210 ms | 150 ms |
| Index | F | J | Shift | 170 ms | 100 ms |

All eight use tap-preferred, 300 ms quick-tap, opposite-hand/thumb trigger
positions, and hold-trigger-on-release, matching the Glove80 core behavior.
The right pinky
keeps quote because the Sweep lacks the Glove80's extra semicolon column.
Bottom-row letters are plain taps. The Glove80's alpha-block combos are now
ported, including D+F=Tab, S+D=grave, A+S=sticky Shift, J+K=Alt+Backspace,
J+K+L=Enter, J+quote=Caps Word, and Z+X/X+C/C+V=cut/copy/paste.
Z+slash toggles Caps Lock. A+S+D+F and J+K+L+quote each arm one-shot
Hyper (Ctrl+Alt+Shift+Cmd) on Base; release the chord before the target key.
A+Z and quote+slash act as held Shift on the typing layer: press both
within 50 ms, keep them held while typing, and release either to end Shift.
M+comma=minus; comma+period and period+slash=equals; N+M+comma=underscore.
Alpha combos use the Glove80 default 50 ms window and apply to typing layers only.
The two left thumbs open Bluetooth controls while held together, with a
150 ms combo window. Releasing either thumb exits the momentary layer.
Combos that require extra Glove80 columns or thumb keys are omitted.

Backspace+Space arms one-shot Hyper (Ctrl+Alt+Shift+Cmd) for the next key.
Release both thumbs, then press the desired key within five seconds.
Quick-release limits Hyper to that key, even during rapid typing. Lazy
activation avoids sending modifier presses until the target key arrives.
This replaces the old Backspace+Space unstick combo; the Bluetooth/control
layer still has Unstick on Y. Hyper applies on normal typing, navigation,
and function layers, but not Bluetooth.

## Thumb layers

The outer left thumb (formerly Escape) is one-shot Hyper
(Ctrl+Alt+Shift+Cmd). Tap and release it, then press the target within
five seconds. Quick-release and lazy activation limit Hyper to one key.
S+D+F sends Escape on the typing layer (50 ms combo window).
The outer right thumb sends Enter on Base and decimal on Nav / Num.
J+K+L also sends Enter; Backspace+Space also arms one-shot Hyper.

Tap Backspace for Backspace; hold it for Nav / Num.
Backspace uses Glove80 thumb timing: balanced, 200 ms tapping term,
300 ms quick-tap. Tap then hold quickly to repeat Backspace.

Navigation combines ESDF arrows with the right-hand number pad:
U/I/O=7/8/9, J/K/L=4/5/6, M/comma/period=1/2/3, Space=0,
Y=plus, H=colon, N=asterisk, P=minus, quote=semicolon, slash=divide,
outer right thumb=decimal.
Both home rows retain the normal modifier holds (Ctrl/Alt/Cmd/Shift,
mirrored on the right), with the same timing and positional rules.
Tap the keys for their arrows, numbers, or symbols; hold for modifiers.
The former right-side editing/navigation bindings are replaced by numbers.

Nav Z/X/C/V match the four Glove80 bottom-row window/tab shortcuts:
Z=Cmd+Shift+grave (previous window), X=Ctrl+Shift+Tab (previous tab),
C=Ctrl+Tab (next tab), V=Cmd+grave (next window). B remains Cmd+F (Find).
The separate Numbers layer has been removed.

## Bluetooth controls

Hold both left thumbs (the former Esc and Backspace positions), then:
- M/comma/period select profiles 1/2/3; J/K select profiles 4/5.
- U selects USB output; B selects Bluetooth output.
- Enter clears the current profile's Bluetooth bond.
- Z enters the left bootloader; slash enters the right bootloader.
- P restarts the right controller; Y unsticks modifiers.

Release either thumb to exit. Profile selection keeps controls active only
while the thumbs remain held; it does not latch the layer after switching.
No key in this layer falls through to typing. Q+T no longer toggles it.
Bootloader/reset bindings act on the physical half that produces the key.

The four layers are Typing, Nav / Num, Bluetooth/controls, and Functions.
Games, separate Numbers, Windows, Windows navigation, and Switch test
were removed.

Build from the repository root: `./flash-sweep.sh --build-only`.
Flash `build/felix-sweep-left.uf2` to the left nice!nano v2 and
`build/felix-sweep-right.uf2` to the right. Double-tap reset and copy the
matching file to NICENANO. No settings reset is needed.

The config before this combo/layer port is in `build/sweep-before-combo-port/`.
The earlier config and device firmware backups are in
`build/sweep-config-before-glove80/`. The Sweep config files are tracked in this repository; other local
zmk-config files and build artifacts remain ignored.
