# Keypad Raw Monitor Test

This test checks whether pressing the NFU FPGA V2.0 keypad directly changes any EGO1 J5 input level.

Bitstream:

```text
D:\ego1_keypad_raw_monitor_build\bitstream\top_keypad_raw_monitor.bit
```

## Control

- S4 clears the latched result.
- SW1/SW0 select one 8-pin J5 bank.
- All J5 pins are high-Z inputs with pull-ups from the XDC.

## Bank Select

```text
SW1 SW0 = 00 shows J5-1  to J5-8
SW1 SW0 = 01 shows J5-9  to J5-16
SW1 SW0 = 10 shows J5-17 to J5-24
SW1 SW0 = 11 shows J5-25 to J5-32
```

## LED Meaning

```text
led[7:0]  = current low pins in the selected bank
led[15:8] = latched low pins in the selected bank
```

If keypad presses change these LEDs, the keypad has direct J5-visible signals.

If keypad presses never change these LEDs in any bank, the keypad likely needs the NFU extension-board schematic, XDC, or example code.
