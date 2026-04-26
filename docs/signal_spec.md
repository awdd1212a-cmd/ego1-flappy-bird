# Signal Specification

This document defines the shared signals between the game logic modules and the VGA renderer.

## Coordinate System

- Screen width: 640
- Screen height: 480
- x = 0 is the left side
- y = 0 is the top side
- Larger y means lower position on the screen

## Game State

```verilog
game_state[1:0]
| Value  | State         |
| ------ | ------------- |
| `2'd0` | `S_IDLE`      |
| `2'd1` | `S_PLAY`      |
| `2'd2` | `S_GAME_OVER` |
Renderer usage:

S_IDLE: show start screen or still scene
S_PLAY: draw normal game scene
S_GAME_OVER: draw game over screen

Main Signals for Renderer
input wire [1:0] game_state,
input wire       dead,
input wire [7:0] score,

input wire [9:0] bird_x,
input wire [8:0] bird_y,

input wire [9:0] pipe1_x,
input wire [8:0] pipe1_gap_y,
input wire [9:0] pipe2_x,
input wire [8:0] pipe2_gap_y,
input wire [9:0] pipe3_x,
input wire [8:0] pipe3_gap_y

Bird

Current design:

bird_x = 100
bird size = 16 x 16
Suggested renderer condition:
bird_area =
    (pixel_x >= bird_x) &&
    (pixel_x <  bird_x + 16) &&
    (pixel_y >= bird_y) &&
    (pixel_y <  bird_y + 16);
Pipes

Current design:

pipe width = 40
gap height = 120

Each pipe has:
pipe1_x[9:0]
pipe1_gap_y[8:0]

pipe2_x[9:0]
pipe2_gap_y[8:0]

pipe3_x[9:0]
pipe3_gap_y[8:0]
Meaning:

pipeX_x is the left x-coordinate of the pipe.
pipeX_gap_y is the top y-coordinate of the gap.
Gap range: pipeX_gap_y to pipeX_gap_y + 120

Suggested renderer condition:
Meaning:

pipeX_x is the left x-coordinate of the pipe.
pipeX_gap_y is the top y-coordinate of the gap.
Gap range: pipeX_gap_y to pipeX_gap_y + 120

Suggested renderer condition:
Ground

Current design:

ground height = 40
ground starts at y = 440

Suggested renderer condition:
ground_area = (pixel_y >= 440);
Shared Constants
| Item           | Value   |
| -------------- | ------- |
| VGA width      | 640     |
| VGA height     | 480     |
| Bird size      | 16 x 16 |
| Bird x         | 100     |
| Pipe width     | 40      |
| Gap height     | 120     |
| Ground height  | 40      |
| Ground y start | 440     |
VGA Renderer Outputs

Recommended VGA output names:
output wire [3:0] vga_r,
output wire [3:0] vga_g,
output wire [3:0] vga_b,
output wire       vga_hsync,
output wire       vga_vsync
These names match constraints/ego1_vga_reference.xdc.

LED Board Test Result

Game logic has passed EGO1 LED board test.

S4: reset
S0: start
S2: flap
LD0: game_state[0]
LD1: game_state[1]
LD2: dead
LD3: btnU

Observed behavior:
Reset: LEDs off
Press S0: LD0 on, game enters PLAY
After falling: LD1 + LD2 on, game enters GAME_OVER
Hold S2: LD3 on
