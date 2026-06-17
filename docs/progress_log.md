# Progress Log

## Final Status

The EGO1 FPGA Flappy Bird VGA project is ready for final board demonstration.

Final control uses the EGO1 board buttons:

- S4: Reset
- S0: Start
- S2: Flap

The external NFU FPGA V2.0 keypad board was investigated, but final demo keeps board-button control because the extension board's keypad pin mapping / schematic / example XDC is not available. This avoids unstable keypad behavior during presentation.

## Completed Features

- VGA output through EGO1 VGA connector
- VGA to HDMI capture path verified
- Playable Flappy Bird game flow
- START text on idle screen
- GAME / OVER text on game-over screen
- Pixel-art bird with body, border, beak, eye, pupil, and wing
- Sky, clouds, ground texture, and highlighted pipes
- Easier gameplay tuning:
  - Bird size: 24x24
  - Pipe gap: 180
  - Pipe speed: 2
  - Fall step: 3
  - Flap step: 34
- Two-digit score display at top-left
- Score rule: every passed pipe scores; every third pipe gives 5 points

Expected score sequence:

```text
Pipe 1: +1  -> 01
Pipe 2: +1  -> 02
Pipe 3: +5  -> 07
Pipe 4: +1  -> 08
Pipe 5: +1  -> 09
Pipe 6: +5  -> 14
```

## Final RTL

- rtl/top_vga.v
- rtl/button_ctrl.v
- rtl/game_fsm.v
- rtl/bird_ctrl.v
- rtl/pipe_ctrl.v
- rtl/collision.v
- rtl/score_ctrl.v
- rtl/vga_sync.v
- rtl/vga_renderer.v
- rtl/keypad_ctrl.v, retained for reference only and not used by final top_vga

## Final Constraint

- constraints/ego1_vga.xdc

## Final Bitstream

```text
D:\ego1_top_vga_build\bitstream\top_vga.bit
```

## Final Build Command

Run from:

```text
D:\ego1_top_vga_build
```

Command:

```powershell
D:\Xilinx\Vivado\2017.2\bin\vivado.bat -mode batch -source build_top_vga.tcl -log build.log -journal build.jou
```

## Board Demo Checklist

1. Program `D:\ego1_top_vga_build\bitstream\top_vga.bit`.
2. Confirm the VGA output shows the START screen.
3. Press S0 to start.
4. Press S2 to flap.
5. Confirm the score increases with the `+1, +1, +5` pattern.
6. Confirm collision enters GAME / OVER.
