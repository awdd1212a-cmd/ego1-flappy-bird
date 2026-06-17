# Keypad Probe Test

This test maps the external NFU FPGA V2.0 keypad board to EGO1 J5 pins.

Bitstream:

```text
D:\ego1_keypad_probe_build\bitstream\top_keypad_probe.bit
```

## Control

- S4 resets and clears the latched result.
- SW1/SW0 select which J5 bank is scanned.
- Press one keypad key at a time.

## Bank Select

Only one 8-pin J5 bank is scanned at a time.

```text
SW1 SW0 = 00 scans J5-1  to J5-8
SW1 SW0 = 01 scans J5-9  to J5-16
SW1 SW0 = 10 scans J5-17 to J5-24
SW1 SW0 = 11 scans J5-25 to J5-32
```

Try one bank, press S4, then press a keypad key. If the LED matrix flashes badly or the keypad does not latch a result, move to the next bank.

## LED Meaning

The probe scans J5-1 through J5-32.

When a keypad key connects two J5 pins, the board LEDs latch the detected pair.

```text
led[4:0]  = driven J5 pin number, binary, value is 1 to 32
led[9:5]  = sensed J5 pin number, binary, value is 1 to 32
led[14]   = live hit indicator
led[15]   = latched hit indicator
```

Examples:

```text
led[4:0] = 00101 means driven pin is J5-5
led[9:5] = 01000 means sensed pin is J5-8
```

Record one row for each key:

```text
Key F:
Key E:
Key D:
Key C:
Key B:
Key 3:
Key 6:
Key 9:
Key A:
Key 2:
Key 5:
Key 8:
Key 0:
Key 1:
Key 4:
Key 7:
```

After the table is filled, the keypad row/column mapping can be connected back into `top_vga`.
