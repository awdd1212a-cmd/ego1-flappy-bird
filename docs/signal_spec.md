# Signal Specification

This document defines the shared signals between the game logic modules and the VGA renderer.

## Coordinate System

- Screen width: 640
- Screen height: 480
- x = 0 is the left side
- y = 0 is the top side
- Larger y means lower position on the screen

## Game State

game_state[1:0]

State encoding:
- 2'd0: S_IDLE
- 2'd1: S_PLAY
- 2'd2: S_GAME_OVER

Renderer usage:
- S_IDLE: show start screen or still scene
- S_PLAY: draw normal game scene
- S_GAME_OVER: draw game over screen

## Main Signals for Renderer

Inputs from game logic:
- game_state[1:0]
- dead
- score[7:0]
- bird_x[9:0]
- bird_y[8:0]
- pipe1_x[9:0]
- pipe1_gap_y[8:0]
- pipe2_x[9:0]
- pipe2_gap_y[8:0]
- pipe3_x[9:0]
- pipe3_gap_y[8:0]

## Bird

Current design:
- bird_x = 100
- bird size = 16 x 16

Renderer idea:
- Draw the bird when pixel_x is between bird_x and bird_x + 16
- Draw the bird when pixel_y is between bird_y and bird_y + 16

## Pipes

Current design:
- pipe width = 40
- gap height = 120

Each pipe has:
- pipeX_x: left x-coordinate of the pipe
- pipeX_gap_y: top y-coordinate of the gap

Pipe signals:
- pipe1_x[9:0]
- pipe1_gap_y[8:0]
- pipe2_x[9:0]
- pipe2_gap_y[8:0]
- pipe3_x[9:0]
- pipe3_gap_y[8:0]

Gap range:
- from pipeX_gap_y
- to pipeX_gap_y + 120

Renderer idea:
- Draw pipe body when pixel_x is between pipeX_x and pipeX_x + 40
- Do not draw pipe inside the gap area
- Gap area is from pipeX_gap_y to pipeX_gap_y + 120

## Ground

Current design:
- ground height = 40
- ground starts at y = 440

Renderer idea:
- Draw ground when pixel_y >= 440

## Shared Constants

- VGA width: 640
- VGA height: 480
- Bird size: 16 x 16
- Bird x: 100
- Pipe width: 40
- Gap height: 120
- Ground height: 40
- Ground y start: 440

## VGA Renderer Outputs

Recommended VGA output names:
- vga_r[3:0]
- vga_g[3:0]
- vga_b[3:0]
- vga_hsync
- vga_vsync

These names match constraints/ego1_vga_reference.xdc.

## VGA Sync Signals

Provided by rtl/vga_sync.v:

- pixel_x[9:0]
- pixel_y[9:0]
- video_on
- pixel_tick
- vga_hsync
- vga_vsync

Renderer usage:

- pixel_x and pixel_y identify the current pixel location
- video_on is 1 only inside the visible 640x480 area
- RGB output should be black when video_on is 0
- pixel_tick is a 25 MHz enable derived from the 100 MHz EGO1 clock

## LED Board Test Result

Game logic has passed EGO1 LED board test.

Button mapping:
- S4: reset
- S0: start
- S2: flap

LED mapping:
- LD0: game_state[0]
- LD1: game_state[1]
- LD2: dead
- LD3: btnU

Observed behavior:
- Reset: LEDs off
- Press S0: LD0 on, game enters PLAY
- After falling: LD1 + LD2 on, game enters GAME_OVER
- Hold S2: LD3 on
