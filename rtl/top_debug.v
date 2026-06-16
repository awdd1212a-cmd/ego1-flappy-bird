module top_debug(
    input  wire clk,
    input  wire rst,

    input  wire btnC,   // start
    input  wire btnU,   // flap

    output wire [1:0] game_state,
    output wire       dead,
    output wire [7:0] score,
    
    output wire [9:0] bird_x,
    output wire [8:0] bird_y,

    output wire [9:0] pipe1_x,
    output wire [8:0] pipe1_gap_y,
    output wire [9:0] pipe2_x,
    output wire [8:0] pipe2_gap_y,
    output wire [9:0] pipe3_x,
    output wire [8:0] pipe3_gap_y,
    
    output wire [3:0] led // 測試用 LED
);

    wire start_pulse;
    wire flap_pulse;
    reg  flap_pending;

    wire game_tick;

    wire [4:0] bird_w;
    wire [4:0] bird_h;

    // ============================================================
    // Game tick generator
    // ============================================================
    // Simulation/debug version
    // 21'd99：模擬加速用
    // 上板時如果要用真實速度，改成 21'd1666665

    localparam [20:0] GAME_TICK_MAX = 21'd99;
    // localparam [20:0] GAME_TICK_MAX = 21'd1666665; // FPGA board 60Hz

    reg [20:0] tick_cnt;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tick_cnt <= 21'd0;
        end else begin
            if (tick_cnt == GAME_TICK_MAX) begin
                tick_cnt <= 21'd0;
            end else begin
                tick_cnt <= tick_cnt + 21'd1;
            end
        end
    end

    assign game_tick = (tick_cnt == GAME_TICK_MAX);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            flap_pending <= 1'b0;
        end else if (game_state != 2'd1) begin
            flap_pending <= 1'b0;
        end else if (flap_pulse) begin
            flap_pending <= 1'b1;
        end else if (game_tick) begin
            flap_pending <= 1'b0;
        end
    end

    // ============================================================
    // Button control
    // ============================================================

    button_ctrl u_button_ctrl(
        .clk(clk),
        .rst(rst),

        .btn_start(btnC),
        .btn_flap(btnU),

        .start_pulse(start_pulse),
        .flap_pulse(flap_pulse)
    );

    // ============================================================
    // Game FSM
    // ============================================================

    game_fsm u_game_fsm(
        .clk(clk),
        .rst(rst),

        .start_pulse(start_pulse),
        .dead(dead),

        .game_state(game_state)
    );

    // ============================================================
    // Bird control
    // ============================================================

    bird_ctrl u_bird_ctrl(
        .clk(clk),
        .rst(rst),

        .game_tick(game_tick),
        .flap_pulse(flap_pending),
        .game_state(game_state),

        .bird_x(bird_x),
        .bird_y(bird_y),
        .bird_w(bird_w),
        .bird_h(bird_h)
    );

    // ============================================================
    // Pipe control
    // ============================================================

    pipe_ctrl u_pipe_ctrl(
        .clk(clk),
        .rst(rst),

        .game_tick(game_tick),
        .game_state(game_state),

        .pipe1_x(pipe1_x),
        .pipe1_gap_y(pipe1_gap_y),

        .pipe2_x(pipe2_x),
        .pipe2_gap_y(pipe2_gap_y),

        .pipe3_x(pipe3_x),
        .pipe3_gap_y(pipe3_gap_y)
    );

    // ============================================================
    // Score control
    // ============================================================

    score_ctrl u_score_ctrl(
        .clk(clk),
        .rst(rst),

        .game_tick(game_tick),
        .game_state(game_state),

        .bird_x(bird_x),

        .pipe1_x(pipe1_x),
        .pipe2_x(pipe2_x),
        .pipe3_x(pipe3_x),

        .score(score)
    );

    // ============================================================
    // Collision detection
    // ============================================================

    collision u_collision(
        .bird_x(bird_x),
        .bird_y(bird_y),
        .bird_w(bird_w),
        .bird_h(bird_h),

        .pipe1_x(pipe1_x),
        .pipe1_gap_y(pipe1_gap_y),

        .pipe2_x(pipe2_x),
        .pipe2_gap_y(pipe2_gap_y),

        .pipe3_x(pipe3_x),
        .pipe3_gap_y(pipe3_gap_y),

        .dead(dead)
    );

    // ============================================================
    // LED debug
    // ============================================================

    assign led[0] = game_state[0];
    assign led[1] = game_state[1];
    assign led[2] = dead;
    assign led[3] = btnU;

endmodule
