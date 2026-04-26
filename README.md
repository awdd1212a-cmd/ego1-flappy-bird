# EGO1 Flappy Bird FPGA Project

這是我們 FPGA 小專題的 GitHub repo，主題是使用 EGO1 FPGA 板實作簡化版 Flappy Bird。

目前主要目標是先完成遊戲邏輯，再和 VGA 顯示模組整合。

## 目前進度

目前 game logic 第一階段已完成，並且已經通過以下測試：

- Behavioral Simulation 已通過
- Synthesis 已通過
- Implementation 已通過
- Bitstream 已成功產生
- 已成功燒錄到 EGO1 FPGA 板
- LED board test 已通過

目前已確認的遊戲流程：

- IDLE
- PLAY
- GAME_OVER

## 資料夾說明

rtl/  
放 Verilog 設計模組，也就是主要會被 Vivado 合成的程式。

sim/  
放 simulation testbench，只用來模擬，不會燒進 FPGA。

constraints/  
放 EGO1 的 XDC 腳位約束檔。

docs/  
放訊號規格、進度紀錄，以及後續整合用的說明文件。

## RTL 模組說明

rtl/button_ctrl.v  
負責把按鍵輸入轉成 one-cycle pulse，例如 start_pulse 和 flap_pulse。

rtl/game_fsm.v  
負責控制遊戲狀態，目前有 IDLE、PLAY、GAME_OVER。

rtl/bird_ctrl.v  
負責控制鳥的位置，以及按下 flap 之後的跳躍行為。

rtl/pipe_ctrl.v  
負責控制管子的移動，以及每個 pipe 的 gap 位置。

rtl/collision.v  
負責判斷鳥是否撞到地板、邊界或管子。

rtl/score_ctrl.v  
負責分數計算。

rtl/top_debug.v  
這是 debug / integration 用的 top，適合 simulation、觀察訊號，以及後續和 VGA renderer 整合。

rtl/top_board_led_test.v  
這是 EGO1 LED 上板測試用的 top，已經實際燒錄到板子測試通過。

## Simulation

simulation testbench 放在：

sim/tb_top.v

目前 testbench 已經確認：

- reset 後進入 IDLE
- 按 start 後進入 PLAY
- bird_y 會變化
- pipe_x 會移動
- collision 發生後進入 GAME_OVER

## Constraints

constraints/ego1_led_test.xdc  
這份是 LED 上板測試用的 XDC，只支援以下 top-level ports：

- clk
- rst
- btnC
- btnU
- led[3:0]

constraints/ego1_vga_reference.xdc  
這份是給 VGA 整合時參考腳位用的 XDC。

建議 VGA top port 命名如下：

- vga_r[3:0]
- vga_g[3:0]
- vga_b[3:0]
- vga_hsync
- vga_vsync

如果 VGA 模組的 port 名稱不同，XDC 裡面的 get_ports 名稱也要一起改。

## EGO1 LED 上板測試結果

按鍵對應：

- S4：reset
- S0：start
- S2：flap

LED 對應：

- LD0：game_state[0]
- LD1：game_state[1]
- LD2：dead
- LD3：btnU

實際測試結果：

- 按 S4 reset 後 LED 全暗
- 按 S0 start 後 LD0 亮，代表進入 PLAY
- 過一段時間後 LD1 和 LD2 亮，代表進入 GAME_OVER 且 dead = 1
- 按住 S2 時 LD3 亮，放開 S2 後 LD3 熄滅

這代表 game logic 已經能在 EGO1 板上正常運作。

## 重要提醒：目前有兩個 top 版本

### top_debug.v

用途：

- simulation
- 觀察 game logic 訊號
- 後續 VGA renderer 整合

這版會輸出比較多 debug 訊號，例如：

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

注意：這版不能直接搭配 ego1_led_test.xdc 上板，因為它有很多額外 top-level output，XDC 沒有綁那些腳位。

### top_board_led_test.v

用途：

- EGO1 LED 上板測試

這版 top-level ports 只有：

- clk
- rst
- btnC
- btnU
- led[3:0]

這版可以搭配 constraints/ego1_led_test.xdc 使用。

## GAME_TICK_MAX 設定

simulation 用：

GAME_TICK_MAX = 21'd99

上板用：

GAME_TICK_MAX = 21'd1666665

原因是 EGO1 的 clock 是 100 MHz。上板時要讓遊戲邏輯大約以 60 Hz 更新，所以使用 21'd1666665。simulation 時為了加快測試，會改成 21'd99。

## VGA 整合需要的 game logic 訊號

VGA renderer 後續需要接以下訊號：

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

詳細訊號說明請看：

docs/signal_spec.md

目前進度紀錄請看：

docs/progress_log.md

VGA 腳位參考請看：

constraints/ego1_vga_reference.xdc

## 下一步

下一階段主要是 VGA renderer 整合。

顯示端需要根據 game logic 給出的座標畫出：

- bird
- pipes
- ground
- start / game over 狀態
- optional score display

目前 game logic 端已經完成第一階段，可以開始和 VGA 顯示端對接。
