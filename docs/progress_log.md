# Progress Log

## Current Status

Game logic first-pass implementation is complete.

The current game logic has been verified through simulation and EGO1 LED board testing.

VGA timing first-pass implementation is complete. The color-bar VGA test top has passed simulation, synthesis, implementation, bitstream generation, and board display testing through the VGA to HDMI capture path.

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
- vga_renderer.v
- top_vga.v
- tb_vga_sync.v
- constraints/ego1_vga_color_test.xdc
- constraints/ego1_vga.xdc

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
- VGA color-bar board display test

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
- Programmed through Vivado GUI Hardware Manager
- Board display test passed through:
  - EGO1 VGA output
  - VGA to HDMI converter
  - HDMI capture card
  - OBS on laptop
- Observed image:
  - blue / green / yellow / red vertical color bars
  - brown ground-color band at the bottom

Full VGA game top implementation result:

- Top module: top_vga
- XDC: constraints/ego1_vga.xdc
- Renderer: rtl/vga_renderer.v
- Vivado synthesis, opt, place, route, and bitstream generation completed
- Generated bitstream during local build:
  - C:/ego1_top_vga_build/bitstream/top_vga.bit
- Build result:
  - 0 errors
  - 0 critical warnings
  - bitstream generation completed successfully
- Board display test:
  - top_vga successfully displays a game scene through OBS
  - VGA path remains stable after switching from color bars to the game renderer

Current top_vga observations:

- The renderer is functional and displays through OBS
- The first game scene was visible, but the bird was not visually clear enough
- The first gameplay tuning was too difficult for demonstration
- The latest source now improves bird readability and lowers the difficulty

Latest VGA polish changes:

- Bird size increased from 16x16 to 24x24
- Bird renderer now includes body, border, orange beak, white eye, black pupil, and darker wing
- Pipe gap increased from 120 pixels to 180 pixels
- Pipe speed reduced from 4 pixels per game tick to 2 pixels per game tick
- Flap step increased from 28 to 34
- Fall step reduced from 4 to 3

Latest top_vga build result:

- Top module: top_vga
- Generated bitstream:
  - C:/ego1_top_vga_build/bitstream/top_vga.bit
- Vivado synthesis, implementation, routing, and bitstream generation completed successfully
- Build result:
  - 0 errors
  - 0 critical warnings
- Board test status:
  - waiting for the latest tuned bitstream to be programmed and tested on EGO1

Latest bonus feature update:

- VGA score display added:
  - two decimal digits at the top-left corner
  - score is clamped to 99 for display
- Visual polish added:
  - simple white clouds in the sky
  - ground texture lines
  - brighter pipe highlight strips
- Vivado build completed again after the bonus renderer update:
  - 0 errors
  - 0 critical warnings
  - bitstream regenerated at C:/ego1_top_vga_build/bitstream/top_vga.bit
- Board test status:
  - waiting for EGO1 testing of the bonus display version

Latest requested control/display update:

- IDLE and GAME_OVER are being changed from solid color blocks to block-letter VGA text:
  - IDLE shows START
  - GAME_OVER shows GAME / OVER
- Score logic is being changed to avoid overflow-based false scoring:
  - pipe pass detection now compares previous and current pipe positions
  - scoring rule is now every 3 passed pipes = +5 points
- 4x4 keypad control RTL has been added:
  - key 1 = start
  - key 5 = flap
  - key D = reset
- top_vga now uses keypad_row[3:0] and keypad_col[3:0] instead of btnC and btnU
- Important blocking item:
  - the exact EGO1 header pins for the external 4x4 keypad still need to be filled into constraints/ego1_vga.xdc before a usable bitstream can be generated
- Verification status:
  - Vivado xvlog syntax check passed for the updated RTL
  - full bitstream generation is intentionally blocked until keypad PACKAGE_PIN values are known

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

Next task is latest tuned top_vga board testing.

The VGA output path has been confirmed with:

- rtl/vga_sync.v
- rtl/top_vga_color_test.v
- constraints/ego1_vga_color_test.xdc

Recommended next test steps:

- Program C:/ego1_top_vga_build/bitstream/top_vga.bit through Vivado Hardware Manager
- Confirm the OBS display shows the larger bird with beak, eye, pupil, and wing
- Confirm the score digits, clouds, ground texture, and pipe highlights are visible
- Confirm the pipe gap is easier to pass through
- Confirm flap control feels playable rather than instantly dying
- If needed, tune BIRD_SIZE, GAP_H, PIPE_SPEED, FLAP_STEP, and FALL_STEP again based on the actual board result

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
