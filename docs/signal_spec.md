# Signal Specification

This document defines the shared signals between the game logic modules and the VGA renderer.

## Coordinate System

- Screen width: 640
- Screen height: 480
- `x = 0` is the left side
- `y = 0` is the top side
- Larger `y` means lower position on the screen

## Game State

```verilog
game_state[1:0]

input wire [1:0] game_state,
input wire       dead,
input wire [7:0] score,

input wire [9:0] bird_x,
input wire [8:0] bird_y,

input wire [9:0] pipe1_x,
input wire [8:0] pipe1_gap_y,
input wire [9:0] pipe2_x,

bird_area =
    (pixel_x >= bird_x) &&
    (pixel_x <  bird_x + 16) &&
    (pixel_y >= bird_y) &&
    (pixel_y <  bird_y + 16);

pipe1_x[9:0]
pipe1_gap_y[8:0]

pipe2_x[9:0]
pipe2_gap_y[8:0]

pipe3_x[9:0]
pipe3_gap_y[8:0]

in_pipe_x =
    (pixel_x >= pipeX_x) &&
    (pixel_x <  pipeX_x + 40);

in_pipe_y =
    (pixel_y < pipeX_gap_y) ||
    (pixel_y >= pipeX_gap_y + 120);

pipe_area = in_pipe_x && in_pipe_y;

ground_area = (pixel_y >= 440);

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

output wire [3:0] vga_r,
output wire [3:0] vga_g,
output wire [3:0] vga_b,
output wire       vga_hsync,
output wire       vga_vsync

Reset: LEDs off
Press S0: LD0 on, game enters PLAY
After falling: LD1 + LD2 on, game enters GAME_OVER
Hold S2: LD3 on
input wire [8:0] pipe2_gap_y,
input wire [9:0] pipe3_x,
input wire [8:0] pipe3_gap_y
