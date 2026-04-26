# Progress Log

## Current Status

Game logic first-pass implementation is complete.

The current game logic has been verified through simulation and EGO1 LED board testing.

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

- Behavioral Simulation
- Synthesis
- Implementation
- Bitstream Generation
- Program Device
- LED board test

## Important Notes

There are two top versions:

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

## GAME_TICK_MAX

Simulation version:

GAME_TICK_MAX = 21'd99

Board version:

GAME_TICK_MAX = 21'd1666665

The simulation version runs faster for easier waveform and console testing.

The board version runs close to 60 Hz based on the 100 MHz EGO1 system clock.

## Next Step

Next task is VGA integration.

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
