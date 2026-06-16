# EGO1 Flappy Bird FPGA Project

這是 FPGA 小專題的 GitHub repo，主題是使用 EGO1 FPGA 板實作一款簡化版 Flappy Bird。

本專題的最終目標是完成一款可以在 EGO1 FPGA 上實際操作，並透過 VGA 輸出畫面的簡化版 Flappy Bird 遊戲。遊戲會包含按鍵輸入、狀態控制、鳥的跳躍、管子移動、碰撞判斷、分數計算，以及即時 VGA 畫面顯示。

專題定位不是製作複雜美術或商業等級遊戲，而是完成一個架構清楚、可上板展示、可說明硬體設計流程的 FPGA 遊戲作品。

## 最終完成目標

完成後的遊戲至少需要具備以下功能：

- VGA 輸出穩定顯示遊戲畫面
- 按鍵可以控制遊戲開始與鳥的跳躍
- 鳥會受到簡化重力影響並上下移動
- 管子會由右往左移動，並保留可通過的 gap
- 撞到地板或管子時進入 GAME_OVER
- 遊戲畫面能看出 bird、pipes、ground、IDLE / PLAY / GAME_OVER 狀態
- 分數由 game logic 計算，至少可透過 debug 訊號、LED 或後續 VGA 顯示確認

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

這代表目前遊戲核心邏輯已經可以正常運作。VGA timing 第一版也已完成，並通過 Vivado behavioral simulation；彩條測試 top 已完成 bitstream 產生並成功上板顯示。目前已新增 VGA renderer 與最終 top_vga，且 top_vga bitstream 已成功產生。下一階段重點是上板確認實際遊戲畫面。

## 系統架構

整體專案可以分成三個主要部分：

1. Input control
   - 將 EGO1 按鍵輸入轉成 one-cycle pulse
   - 提供 start 與 flap 控制訊號

2. Game logic
   - 控制遊戲狀態、鳥的位置、管子位置、碰撞與分數
   - 目前已完成第一階段並通過 LED 上板測試

3. VGA display
   - 產生 VGA timing
   - 根據 game logic 的座標與狀態畫出天空、地板、鳥、管子與遊戲狀態
   - 這是下一階段主要整合目標

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
負責判斷鳥是否撞到地板或管子。

rtl/score_ctrl.v  
負責分數計算。

rtl/top_debug.v  
這是 debug / integration 用的 top，適合 simulation、觀察訊號，以及後續和 VGA renderer 整合。

rtl/top_board_led_test.v  
這是 EGO1 LED 上板測試用的 top，已經實際燒錄到板子測試通過。

rtl/vga_sync.v  
產生 640x480 @ 60Hz VGA timing，包括 pixel 座標、hsync、vsync 和 video_on。

rtl/top_vga_color_test.v
VGA 上板前的彩條測試 top，用來確認 EGO1 VGA 輸出、VGA to HDMI 轉換器與擷取卡能正常顯示畫面。

rtl/vga_renderer.v  
根據目前 pixel 座標與 game logic 訊號決定 RGB 輸出，畫出 bird、pipes、ground 和遊戲狀態。

rtl/top_vga.v  
最終 VGA 版本 top module，整合 button control、game logic、VGA sync 和 renderer。

## VGA 顯示規劃

VGA 目標採用簡潔但完整的矩形風格，避免過度複雜的 sprite 或圖片 ROM，確保可以在專題時程內完成並穩定上板。

預計畫面元素：

- 背景：淺藍色天空
- 地板：底部固定高度的 ground
- 鳥：黃色矩形或簡單方塊，可加黑色邊框增加辨識度
- 管子：綠色上下矩形，中間保留 gap
- IDLE：顯示等待開始狀態
- PLAY：正常遊戲畫面
- GAME_OVER：顯示結束狀態，可用紅色提示或畫面變暗表示

renderer 核心邏輯會使用座標範圍判斷，例如：

```verilog
if (pixel is inside bird)
    draw yellow;
else if (pixel is inside pipe)
    draw green;
else if (pixel is inside ground)
    draw ground color;
else
    draw sky color;
```

這種方式可綜合、容易除錯，也適合 FPGA 小專題展示。

## Simulation

simulation testbench 放在：

sim/tb_top.v

目前 testbench 已經確認：

- reset 後進入 IDLE
- 按 start 後進入 PLAY
- bird_y 會變化
- pipe_x 會移動
- collision 發生後進入 GAME_OVER

後續 VGA 整合後，建議新增或擴充測試：

- VGA counter 是否產生正確 h_count / v_count
- video_on 是否只在可視區域內為 1
- renderer 在指定座標是否輸出正確顏色
- top_vga 是否能接上現有 game logic 訊號

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

### top_vga.v

用途：

- 最終 VGA 遊戲展示版本
- 整合 game logic 與 VGA 顯示

這版預計會包含：

- clk
- rst
- start button
- flap button
- vga_r[3:0]
- vga_g[3:0]
- vga_b[3:0]
- vga_hsync
- vga_vsync

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

constraints/ego1_vga_color_test.xdc

這份是 VGA 彩條測試 top 的正式 XDC，可搭配 top_vga_color_test.v 先做上板畫面測試。

## 兩週內完成策略

為了確保專題可以完整收斂，優先完成必要功能，再做加分項。

必要功能：

- vga_sync.v 產生穩定 VGA timing（已完成 simulation）
- top_vga_color_test.v 產生 VGA 彩條測試畫面（已通過 synthesis / implementation / bitstream / board test）
- vga_renderer.v 畫出天空、地板、鳥、管子（已完成 first-pass）
- top_vga.v 整合現有 game logic 與 VGA 顯示（已完成 bitstream）
- IDLE / PLAY / GAME_OVER 都能在畫面上被分辨
- 實際上板測試可操作、可顯示、可 Game Over

加分功能：

- 鳥和水管加邊框，讓畫面更清楚
- GAME_OVER 畫面加簡單提示
- 分數顯示到 VGA 畫面
- 增加簡單背景線條或地板紋理

## 下一步

下一階段主要是 top_vga 上板測試。VGA to HDMI 轉換器與擷取卡已確認可以收到 EGO1 輸出的彩條畫面。

建議實作順序：

1. 將 C:/ego1_top_vga_build/bitstream/top_vga.bit 燒錄到 EGO1
2. 在 OBS 確認 sky、ground、bird、pipes 是否正常顯示
3. 上板測試 start、flap、collision、GAME_OVER
4. 依照實際畫面調整顏色、尺寸或狀態提示
5. 補上 README、測試紀錄與展示結果

目前 game logic 端已經完成第一階段，可以開始和 VGA 顯示端對接。
