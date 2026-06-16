# Progress Log

## Current Status

Game logic first-pass implementation is complete.

The current game logic has been verified through simulation and EGO1 LED board testing.

VGA timing first-pass implementation is complete. A color-bar VGA test top has been added for the next board test.

## Completed Modules

- button_ctrl.v
- game_fsm.v
- bird_ctrl.v
- pipe_ctrl.v
- collision.v
- score_ctrl.v
- top_debug.v
- top_board_led_test.v
- tb_top.v
- vga_sync.v
- top_vga_color_test.v
- tb_vga_sync.v
- constraints/ego1_vga_color_test.xdc

## Simulation Result

Behavioral simulation passed.

Verified flow:

- Reset
- IDLE state
- Press start button
- Enter PLAY state
- Bird position changes
- Pipe position changes
- Collision occurs
- Enter GAME_OVER state

Observed simulation result:

- After start: game_state = 01, dead = 0
- After flap 1: game_state = 01, dead = 0
- After flap 2: game_state = 10, dead = 1
- Final game_state = 10
- Final dead = 1
- Final score = 0
- Final bird_x = 100
- Final bird_y = 424
- Final pipe1_x = 296
- Final pipe2_x = 496
- Final pipe3_x = 696

The final bird_y = 424 means the bird reached the ground area.

With bird height = 16:

424 + 16 = 440

The ground starts at y = 440, so the collision result is correct.

## Board Test Result

EGO1 LED board test passed.

Board test setup:

- S4: reset
- S0: start
- S2: flap
- LD0: game_state[0]
- LD1: game_state[1]
- LD2: dead
- LD3: btnU

Observed behavior:

- Press S4 reset: LEDs off
- Press S0 start: LD0 turns on
- After a short time: LD1 and LD2 turn on
- Hold S2: LD3 turns on
- Release S2: LD3 turns off

This confirms:

- Start button works
- Game FSM works
- Bird control runs
- Pipe control runs
- Collision detection works
- dead signal returns to FSM correctly
- EGO1 button and LED mapping works

## Vivado Verification

Passed:

- Game logic behavioral simulation
- VGA sync behavioral simulation
- VGA color test synthesis
- Game logic synthesis
- Implementation
- Bitstream Generation
- Program Device
- LED board test

VGA sync simulation result:

- Pixel counter increments with a 25 MHz pixel enable generated from the 100 MHz clock
- Horizontal counter wraps after one 800-pixel line
- Vertical counter increments after each completed line
- hsync becomes active during the expected horizontal sync interval

VGA color test synthesis result:

- Top module: top_vga_color_test
- XDC: constraints/ego1_vga_color_test.xdc
- Vivado synthesis completed with 0 errors, 0 critical warnings, and 0 warnings

VGA color test implementation result:

- Top module: top_vga_color_test
- Vivado opt/place/route completed successfully
- Bitstream generation completed successfully
- Generated bitstream during local build:
  - C:/ego1_vga_color_build2/bitstream/top_vga_color_test.bit
- Automatic Vivado Hardware Manager probe timed out, so board programming still needs to be done from Vivado GUI or retried after confirming the EGO1 USB/JTAG connection

## Important Notes

There are currently three top versions:

1. top_debug.v

Used for:
- simulation
- signal observation
- future VGA renderer integration

This version has debug outputs such as:

- game_state
- dead
- score
- bird_x
- bird_y
- pipe1_x
- pipe1_gap_y
- pipe2_x
- pipe2_gap_y
- pipe3_x
- pipe3_gap_y

2. top_board_led_test.v

Used for:
- EGO1 LED board testing

This version only has these top-level ports:

- clk
- rst
- btnC
- btnU
- led[3:0]

3. top_vga_color_test.v

Used for:
- VGA output bring-up
- VGA to HDMI / capture card verification
- color-bar display test before integrating the game renderer

This version uses:

- clk
- rst
- vga_r[3:0]
- vga_g[3:0]
- vga_b[3:0]
- vga_hsync
- vga_vsync

## GAME_TICK_MAX

Simulation version:

GAME_TICK_MAX = 21'd99

Board version:

GAME_TICK_MAX = 21'd1666665

The simulation version runs faster for easier waveform and console testing.

The board version runs close to 60 Hz based on the 100 MHz EGO1 system clock.

## Next Step

Next task is VGA board bring-up.

Use:

- rtl/vga_sync.v
- rtl/top_vga_color_test.v
- constraints/ego1_vga_color_test.xdc

Expected board result:

- VGA to HDMI converter and capture card should show stable color bars
- Bottom 40 pixels should display the ground-color band

After the VGA output path is confirmed, start the full VGA renderer integration.

The VGA renderer should use the game logic signals listed in:

docs/signal_spec.md

Main signals needed:

- game_state
- dead
- score
- bird_x
- bird_y
- pipe1_x
- pipe1_gap_y
- pipe2_x
- pipe2_gap_y
- pipe3_x
- pipe3_gap_y

The VGA team should also refer to:

constraints/ego1_vga_reference.xdc
