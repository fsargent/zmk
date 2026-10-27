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
J+K+L=Enter, J+K+L+quote=Caps Lock, J+quote=Caps Word, and Z+X/X+C/C+V=cut/copy/paste.
A+Z and quote+slash act as held Shift on the typing layer: press both
within 50 ms, keep them held while typing, and release either to end Shift.
M+comma=minus; comma+period and period+slash=equals; N+M+comma=underscore.
Alpha combos use the Glove80 default 50 ms window and apply to typing layers only.
The Q+T control-layer combo uses a more forgiving 150 ms window and is also
enabled inside the control layer, so it can toggle back out.
Combos that require extra Glove80 columns or thumb keys are omitted.

Backspace+Space arms one-shot Hyper (Ctrl+Alt+Shift+Cmd) for the next key.
Release both thumbs, then press the desired key within five seconds.
Quick-release limits Hyper to that key, even during rapid typing. Lazy
activation avoids sending modifier presses until the target key arrives.
This replaces the old Backspace+Space unstick combo; the Bluetooth/control
layer still has Unstick on Y. Hyper applies on normal typing, navigation,
number, function, and gaming layers, but not Bluetooth.

## Thumb layers

The former Enter thumb is one-shot Shift on the normal typing
layer (also inherited by navigation). Tap it, then type the next key within
one second. Shift releases immediately after the next key registers, so
overlapping letter presses do not capitalize a second letter. Holding the
thumb still acts as normal Shift. Use J+K+L for Enter. Numbers retains its decimal point binding.

Tap Esc for Escape; hold it for Numbers. Tap Backspace for Backspace; hold
it for Navigation. Both use Glove80 thumb timing: balanced, 200 ms tapping
term, 300 ms quick-tap. Tap then hold quickly to repeat the tap key.

Navigation has E=Up, S=Left, D=Down, F=Right. The right home row is
H=Copy, J=Shift, K=Cmd, L=Alt, quote=Ctrl, matching the Glove80 cursor
layer. N=Paste, M=Home, comma=Page Up, period=Page Down, slash=End.
Advanced selection macros are replaced with basic shortcuts.

Numbers has U/I/O=7/8/9, J/K/L=4/5/6, M/comma/period=1/2/3,
Space=0, Enter=decimal point, Y=plus, H=plus, N=asterisk,
P=colon, quote=minus, slash=divide.
The Esc thumb replaces the Glove80's dedicated number-layer thumb key.

Q+T toggles controls. Release the combo, then tap the Esc thumb to enter
the left controller's bootloader. P is restart and slash is bootloader on
the right side; the reset behaviors are source-local. A physical double-tap
reset remains a dependable per-controller bootloader entry method.

The six layers are Typing, Navigation, Bluetooth/controls, Games, Functions,
and Numbers. Windows, Windows navigation, and Switch test were removed.

Build from the repository root: `./flash-sweep.sh --build-only`.
Flash `build/felix-sweep-left.uf2` to the left nice!nano v2 and
`build/felix-sweep-right.uf2` to the right. Double-tap reset and copy the
matching file to NICENANO. No settings reset is needed.

The config before this combo/layer port is in `build/sweep-before-combo-port/`.
The earlier config and device firmware backups are in
`build/sweep-config-before-glove80/`. The Sweep config files are tracked in this repository; other local
zmk-config files and build artifacts remain ignored.
