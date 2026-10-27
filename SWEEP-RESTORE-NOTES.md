# Ferris Sweep restoration — 20 October 2026

## Update — 27 October 2026

- Replacement nice!nano v2 arrived. Its USB serial is **`F5F4B7E58E58F365`**.
- Flashed it with `build/felix-sweep-right.uf2` as the **right/peripheral**. SHA-256: `8265445d81a7543318dc345f8cbe08e9ab6980a88c722eb07232388156f711d5`.
- Its NICENANO bootloader drive disappeared and the same serial re-enumerated as **Felix Sweep**. macOS `cp` reported `fchmod failed: Device not configured` after the device rebooted; this was a post-copy filesystem operation. Firmware was not read back for a byte comparison.
- Restored normal **left/central** firmware to retained **+** (`842AA5C13B65DD18`) using `build/felix-sweep-left.uf2`. SHA-256: `d94dade76f2f40f4d70163a374801fcf83c8e8bfbaba37622258a4dbef1bfa98`. Data copy completed successfully and the same serial rebooted as **Felix Sweep**. Both intended controllers now have normal keyboard firmware; split pairing and physical key operation remain to be checked.
- Subsequently flashed the verified settings-reset UF2 to **both** + (`842AA5C13B65DD18`) and the replacement (`F5F4B7E58E58F365`) to clear old split bonds. Both re-enumerated as **SETTINGS RESET**. Then restored the normal **right** image to replacement `F5F4B7E58E58F365` and the normal **left** image to + `842AA5C13B65DD18`, matching USB serial numbers to mounted disks via the IOService tree. Both data copies completed successfully. **Current state: both have normal firmware after settings reset; physical-key and inter-half operation await user verification.** Saved host Bluetooth pairings were cleared; forget/re-pair the keyboard on hosts as needed.
- The older “Where we stopped” and “currently installed” statements below describe the end of the 20 October session, not the new replacement.
- User then confirmed normal typing from both halves, including the full alphabet and comma/period/slash/quote. Split pairing and the replacement controller are working.
- Subsequently changed the Numbers layer and then revised it per user correction: **Y=plus, H=plus, N=asterisk**. Y retains the plus binding from the first edit; the user explicitly revised H and N only. **These number-symbol changes are now flashed to the left/central controller.** The October 27 hashes above identify the earlier flashed images, not the latest rebuilt artifacts.
- Added `sweep-keymap.html`: offline layer atlas and practice page with all nine layers, 24 combos, tap/hold details, typed-output and find-key drills, dark mode, and print styling. Generated directly from the current config using `python3 scripts/generate-sweep-keymap.py`; editable page template is `scripts/sweep-keymap.template.html`. Browser checks passed for all layers, combo highlighting, drill interactions, and mobile layouts down to 320 px. The generator supports `--pending` for displaying an unflashed-changes notice; the current page has been regenerated without that notice after flashing the left controller.
- Added **Backspace+Space = one-shot Hyper** (Ctrl+Alt+Shift+Cmd), replacing the old unstick combo on positions 31/32. Release both, then press the target within 5 seconds. Dedicated sticky behavior uses `lazy`, `quick-release`, and `ignore-modifiers`; the compiled binding is `&hyper 0xe0700e0`. Active on layers 0/1/3/4/5/6/7; excluded on Bluetooth and Switch test. Unstick remains on control-layer Y. Both firmware images built successfully and compiled properties were verified. Practice page regenerated and browser checks passed. **Hyper and the latest number-symbol changes are now flashed to the left/central controller.** No dedicated Meh binding exists.
- User asked about Bluetooth keymap changes. Current builds have Studio disabled (`# CONFIG_ZMK_STUDIO is not set`). Current upstream ZMK Studio supports BLE via native apps (including macOS), but configuring combos and behavior properties is still unsupported/planned. Enabling Studio requires another initial firmware flash and unlock binding. Studio-maintained runtime keymaps override `.keymap` changes until Restore Stock Settings, so the existing HTML generator would need a source-of-truth decision before switching to Studio.

## Flashed update — one-shot Shift thumb and layer cleanup

The former Enter thumb (position 33) is now `&sk RSHFT` on Base, inherited by navigation. Standard sticky-key timeout: 1000 ms.
J+K+L still sends Enter; Numbers retains decimal point; Games retains its existing binding. Build and practice page updated;
these changes were flashed to the left/central controller + (`842AA5C13B65DD18`).
Data copy completed and the controller re-enumerated as Felix Sweep.
Left SHA-256: `fba389e0e2b0e07bc0b6f56949d90947ab50f146f7ead78524972489c498d919`.
Both images built; only the left needed flashing for these keymap changes.
Practice page regenerated without the pending notice; browser checks passed
for all six layers, Shift thumb, combos, drills, and mobile layout.
Removed Windows, Windows navigation, and Switch test, plus their entry
shortcuts and Windows-only combos. Remaining IDs: Base 0, Nav 1,
Bluetooth 2, Games 3, Functions 4, Numbers 5. Controls O is now disabled.
The regenerated HTML shows six layers and 19 combos.

## Where we stopped

- User ordered a new genuine nice!nano to replace controller **−**.
- **Both existing controllers currently have standalone raw GPIO diagnostic firmware, not keyboard firmware.** Neither should type in this state. Restore normal firmware before using the keyboard.
- Serial capture processes had already ended when these notes were saved.
- No settings-reset image was flashed during this session. Swapping central/peripheral firmware roles temporarily interrupted split communication; do not interpret a silent peripheral as a GPIO failure.
- Physical controller swapping was confused during testing. The user later said they might not actually have swapped the controllers. Use the serial identities below, not earlier assumptions about which controller was in which half.

## Latest flashed keymap update — 27 October 2026

- Flashed retained left/central **+** (`842AA5C13B65DD18`) with the Hyper combo, number-symbol edits, and explicit left bootloader binding. Copy completed successfully and the same USB serial rebooted as **Felix Sweep**.
- SHA-256 of the flashed left UF2: `464769136e4932918f723b26d749580d658dd22412404d79c4903404e7335836`.
- Left bootloader access: **Q+T together, release, then tap the Esc thumb**. Q+T now allows 150 ms and includes BT_L in its active layer list, fixing the missing toggle-off behavior.
- Right peripheral remains on the previously flashed normal image; keymap actions are handled on the left. Both current artifact builds were regenerated, but only the left needed flashing for this update.
- Firmware checks verified the 34-key control layer, Esc-thumb bootloader binding, Q+T layer list/timeout, and sticky Hyper properties. Hardware use of the new actions awaits the user's check.
- Studio remains disabled. Enabling Studio was discussed but not implemented.

## Controller identities and diagnostic conclusion

| Label | USB serial number | Raw GPIO result outside keyboard PCB |
| --- | --- | --- |
| **−** | `46196CCA810B6CD3` | P0.20 and P0.22 stayed low with internal pull-ups enabled and nothing touching the controller. P0.17/P0.24 were high. |
| **+** | `842AA5C13B65DD18` | All four inputs idle high. Grounding P0.20/P0.22 produced low readings followed by high readings on release. |

These results used **the exact same standalone Zephyr application**, with no ZMK code, keymap, scanner, debouncing, Bluetooth, or HID keyboard output. GPIO configuration succeeded (`configure=0`); each pin's hardware `PIN_CNF` register was `0x0000000c` (input with pull-up).

This isolates a controller-level electrical problem on **−**, rather than a ZMK home-row-mod/combo problem. It does not establish whether the cause is chip damage, a solder bridge, or contamination; inspect the board before discarding it. **+** responded on both suspect inputs and is being retained.

Earlier claims of an interrupt-only firmware issue or two faulty controllers were premature. Polling did not fix it: one test emitted a stuck period. USB logging then showed no comma/period transitions even with the controller outside the PCB. The standalone raw GPIO comparison is the strongest evidence.

The I key did produce events during later logging. Initially the user could trigger it by bridging its switch pads, so recheck the actual I switch/contact when reassembling; do not assume a remaining I problem is resolved by replacing a controller.

## Verified pin mapping

These are **Pro Micro digital pin names**, not the nRF GPIO numbers.

| Pro Micro pin | nice!nano GPIO | Normal right-half base binding |
| --- | --- | --- |
| D0 | P0.08 | Unused by Sweep scanning |
| D1 | P0.06 | H |
| D2 | P0.17 | Slash |
| D3 | P0.20 | Period |
| D4 | P0.22 | Comma |
| D5 | P0.24 | M |
| D6 | P1.00 | N |
| D7 | P0.11 | P |
| D8 | P1.04 | Enter on tap, Shift on hold |
| D9 | P1.06 | Space |

I is P0.02, through Pro Micro D19. In left firmware, grounding D2/D3/D4/D5 produces Z/X/C/V instead.

All keyboard and diagnostic builds in this session targeted **`nice_nano_v2`**, verified in CMake caches and generated `.config`. The v1/v2 board definitions share the keyboard GPIO mapping; their battery/power definitions differ.

## Normal firmware and layout changes

The normal builds use `zmk-config/config/cradio.keymap`, **not** `app/boards/shields/cradio/cradio.keymap`. Today's initial build had plain home-row letters and modifiers on the bottom row/thumbs. We adapted the Sweep toward the user's daily-driver Glove80 QWERTY layout, without importing its whole Glorious Engrammer layer system.

### Home row

| Fingers | Left/right tap keys | Hold | Hold threshold | Prior idle |
| --- | --- | --- | --- | --- |
| Pinky | A / quote | Ctrl | 260 ms | 150 ms |
| Ring | S / L | Alt | 240 ms | 150 ms |
| Middle | D / K | Cmd | 210 ms | 150 ms |
| Index | F / J | Shift | 170 ms | 100 ms |

All use `tap-preferred`, 300 ms quick-tap, opposite-hand/all-thumb trigger positions, and `hold-trigger-on-release`, matching the Glove80's core settings. This is a simplified port: its special multi-mod chord macros are not included. Quote substitutes for the Glove80 home-row semicolon. Typing-layer bottom-row letters are plain taps. The Windows typing layer currently retains the same finger-to-modifier mapping.

### Thumb layers and combos

- Tap Esc for Escape; **hold Esc for Numbers**.
- Tap Backspace for Backspace; **hold Backspace for Navigation**.
- Thumb layer behavior: `balanced`, 200 ms tapping term, 300 ms quick-tap.
- Navigation: **E=Up, S=Left, D=Down, F=Right**. Right home row: H=Copy, J=Shift, K=Cmd, L=Alt, quote=Ctrl. Bottom right: N=Paste, M=Home, comma=Page Up, period=Page Down, slash=End. Advanced Glove80 selection macros were simplified to ordinary shortcuts.
- Numbers: U/I/O=7/8/9, J/K/L=4/5/6, M/comma/period=1/2/3, Space=0, Enter=decimal point. Y/H/N=plus/plus/asterisk (updated 27 October); P=colon, quote=minus, slash=divide.
- Glove80 alpha-block combos ported with a 50 ms window: **D+F=Tab**, S+D=grave, A+S=sticky Shift, L+quote=sticky Shift, F+G=!, H+J=?, J+K=Alt+Backspace (Ctrl+Backspace in Windows), J+K+L=Enter, J+quote=Caps Word, Z+X/X+C/C+V=cut/copy/paste, M+comma=minus, comma+period and period+slash=equals, N+M+comma=underscore.
- Old Sweep vertical number combos were removed in favor of the number layer. Alpha editing combos apply to typing layers, not navigation/numbers.
- Q+T toggles Bluetooth/control layer with a 150 ms combo window, including while on that layer so it can toggle back out. On that layer, the Esc thumb enters the **left** bootloader; P is reset and slash is bootloader on the right side. These are ordinary source-local behavior bindings: the normal P/slash keys are on the right half, so **do not rely on the earlier conversational claim that they always reset the central**. Physical double-tap reset is the dependable per-controller flashing method.
- Q+T then O enters the normal firmware's switch-test layer: physical I/comma/period emit 1/2/3 with no combos/mods. Esc thumb returns to base. This is separate from the standalone diagnostic firmware used earlier during hardware investigation.

## Files and build artifacts

Normal firmware, last built successfully and checked against generated device trees:

- `build/felix-sweep-left.uf2` — left/central, 444416 bytes.
- `build/felix-sweep-right.uf2` — right/peripheral, 343040 bytes.
- `flash-sweep.sh --build-only` rebuilds both. The script's default mode flashes sequentially and assumes one `NICENANO` mount; do not use it blindly with multiple mounted bootloaders. Its `cp ... || true` can hide copy failures.

Normal configuration and reference:

- `zmk-config/config/cradio.keymap`, `combos.dtsi`, `cradio.conf`, `SWEEP.md`.
- Glove80 reference: `Glorious Engrammer v41 - fsargent - 1200.keymap`; `zmk-config/config/glove80.keymap` includes it.
- **`zmk-config/` and `build/` are ignored by the parent repository.** Preserve these separately if cleaning or moving the checkout. The root summary itself is not ignored. No commit was made during this session.

Backups:

- `build/sweep-config-before-glove80/` — original config; `device-backup/left-current.uf2` and `right-current.uf2` are original device flash dumps.
- `build/sweep-before-combo-port/` — config before the combo/thumb-layer correction.
- Other snapshots: `build/sweep-left-before-role-test.uf2`, `sweep-original-right-before-role-test.uf2`, `sweep-minus-before-usb-test.uf2`, `sweep-plus-before-raw-probe.uf2`.

Diagnostics:

- `build/sweep-right-usb-test/` — standalone right mapping, no BLE/split, normal interrupt scanner; D8/D9 visibly emit E/S.
- `build/sweep-right-usb-poll-test/` — identical except `CONFIG_ZMK_KSCAN_DIRECT_POLLING=y`.
- `build/sweep-right-usb-log/` — ZMK polling scanner with USB debug logs, all 34 bindings inert (`&none`). Built with `-S zmk-usb-logging`.
- `build/sweep-raw-probe/` — standalone Zephyr source project; reads P0.17/20/22/24 directly, logs raw levels and GPIO configuration. Has a local copy of the nice!nano board files so the standalone build does not import ZMK shields.
- `build/sweep-raw-probe-build/zephyr/zephyr.uf2` — **currently installed on both controllers**; USB product `Sweep Raw GPIO`. UF2 addresses checked to stay within the application partition beginning at `0x26000`.
- Raw evidence: `build/sweep-raw-gpio-capture.log` (**−**) and `build/sweep-raw-gpio-plus-capture.log` (**+**).
- Earlier ZMK evidence: `build/sweep-usb-scan-capture.log`, `build/sweep-usb-scan-capture-detached.log`.
- USB serial was captured using `.venv/bin/python` and installed `pyserial` 3.5. Match device by serial number; `/dev/cu.usbmodem...` paths can change.

## Resume when replacement arrives

1. Keep labels **+** and **−** attached to the physical devices; record the new controller's serial number. Do not assume a label implies a physical keyboard side.
2. Check/solder replacement socket pins to match existing sockets and height. Included square headers do not fit common machine-pin sockets. Test controller before fitting it over a battery.
3. Put the replacement and + into their intended physical halves. Flash `felix-sweep-left.uf2` to the **physical left** controller and `felix-sweep-right.uf2` to the **physical right** controller. Identify one device at a time; mount names alone do not establish handedness.
4. Reboot both. If the peripheral does not communicate, investigate split bonding. A replacement changes the hardware address; use ZMK's documented two-half settings-reset/reflash procedure if necessary. That also clears saved Bluetooth host profiles, requiring host pairing again. The ready `build/nice-nano-settings-reset.uf2` exists, but was not used here.
5. Verify every physical key, especially I/comma/period, then home-row holds, D+F Tab, Esc-held numbers, and Backspace-held ESDF navigation.
6. If normal firmware works, leave polling/logging/raw probes out of the daily-driver configuration; they were diagnostic experiments, not confirmed fixes.

## Other discussion / future ideas

- User paid **€37.69 delivered at splitkb** for the ordered replacement. Mechboards' live stock was unavailable. splitkb's live listing was available; 42. Keebs also showed stock. Only one replacement is needed based on the raw comparison.
- Standard upstream QMK is not a drop-in firmware for the nRF52840 wireless split. Its standard split transport is wired serial/I2C. The current keyboard uses BLE between halves in ZMK; using RP2040/QMK would require compatible hardware and an inter-half wired connection. Pico W has Bluetooth but is not Pro Micro socket-compatible.
- A Cirque Pinnacle I2C touchpad is a plausible future addition; a TrackPoint is possible through external driver support. Sweep scans 17 pins per half; nice!nano has spare GPIOs including extra pads. Remap I2C to unused pins rather than stealing existing key inputs. Requires mounting, wiring, driver configuration, and battery-budget consideration; no pointing hardware was ordered or configured here.
- Tenting puck fit is **not confirmed for this user's self-built PCB**. Standard Sweep 2.x and most other full-size Sweep variants support splitkb's puck; Sweep Mini does not. Need PCB revision/photo or original design to confirm the four M2 mounting holes and case clearance.
- No KiCad projects, PCB/schematic/Gerber/DXF files found in this ZMK checkout, including ignored files. No KiCad file history in the available shallow Git history. Neighboring `../qmk_firmware` contains firmware but no matching PCB project. Do not claim the user's hardware revision is established by the `cradio` firmware target.

Useful references:

- nice!nano pinout: https://nicekeyboards.com/docs/nice-nano/pinout-schematic/
- ZMK split-pairing troubleshooting: https://zmk.dev/docs/troubleshooting/connection-issues
- Sweep hardware/variant table: https://github.com/davidphilipbarr/Sweep
- Tenting puck drawings/template: https://github.com/splitkb/tenting_puck
- ZMK pointing devices: https://zmk.dev/docs/hardware-integration/pointing

## Flashed update — Caps Lock and Shift rollover

Added J+K+L+quote (positions 16/17/18/19) = `&kp CAPSLOCK` on Base,
50 ms combo window; J+K+L remains Enter and J+quote remains Caps Word.
Thumb position 33 now uses `&skq RSHFT`: 1000 ms expiry, quick-release,
ignore-modifiers, lazy. Releases after the first key press rather than its
release to prevent overlapping letters producing WEll. Holding the thumb
still behaves as normal Shift. Both firmware images built; flashed left/central + (`842AA5C13B65DD18`).
Data copy completed and same serial re-enumerated as Felix Sweep.
SHA-256: `d89dd2f0d49ebf6d792c8ce72cc1f15d3b5fff48f77cf951b44de192cc7f3534`.
HTML regenerated without pending notice. Browser checks passed for six
layers and 20 combos, including Caps Lock highlighting all four positions.

## Flashed update — held Shift combos

Added Base combos A+Z (`10 20`, `&kp LSHFT`) and quote+slash
(`19 29`, `&kp RSHFT`). Both use 50 ms combo timing and normal release:
Shift remains down while both keys are held, releasing either ends it.
Existing sticky Shift combos remain. Updated HTML now has 22 combos.
Both firmware images built. Flashed left/central + (`842AA5C13B65DD18`);
data copy completed and the same serial re-enumerated as Felix Sweep.
Left SHA-256: `a0690831dc486d206adb6cf08510775601b2e213d8c405dd0d3169a3dd310872`.
Compiled combo bindings verified; browser checks passed for six layers and
22 combos. HTML regenerated without the pending firmware notice.

## Repository tracking

Sweep sources (`cradio.keymap`, `cradio.conf`, `combos.dtsi`, `SWEEP.md`)
are now tracked under `zmk-config/config/`, alongside the build helper,
practice-page generator/template/output, and these notes. Other local
zmk-config files and generated firmware artifacts remain ignored. Older
statements above about the whole config being ignored are historical.
