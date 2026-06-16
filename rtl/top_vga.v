module top_vga(
    input  wire       clk,
    input  wire [3:0] keypad_row,
    output wire [3:0] keypad_col,

    output wire [3:0] vga_r,
    output wire [3:0] vga_g,
    output wire [3:0] vga_b,
    output wire       vga_hsync,
    output wire       vga_vsync,

    output wire [3:0] led
);

    wire rst;
    wire key_start;
    wire key_flap;
    wire key_reset;
    wire [3:0] key_code;
    wire start_pulse;
    wire flap_pulse;
    reg  flap_pending;
    reg  [19:0] power_on_cnt = 20'd0;
    reg         power_on_done = 1'b0;

    wire game_tick;
    wire video_on;
    wire pixel_tick;
    wire [9:0] pixel_x;
    wire [9:0] pixel_y;

    wire [1:0] game_state;
    wire       dead;
    wire [7:0] score;

    wire [9:0] bird_x;
    wire [8:0] bird_y;
    wire [4:0] bird_w;
    wire [4:0] bird_h;

    wire [9:0] pipe1_x;
    wire [8:0] pipe1_gap_y;
    wire [9:0] pipe2_x;
    wire [8:0] pipe2_gap_y;
    wire [9:0] pipe3_x;
    wire [8:0] pipe3_gap_y;

    localparam [20:0] GAME_TICK_MAX = 21'd1666665;

    reg [20:0] tick_cnt;

    assign rst = key_reset || !power_on_done;

    always @(posedge clk) begin
        if (!power_on_done) begin
            power_on_cnt <= power_on_cnt + 20'd1;
            if (power_on_cnt == 20'hFFFFF)
                power_on_done <= 1'b1;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tick_cnt <= 21'd0;
        end else begin
            if (tick_cnt == GAME_TICK_MAX)
                tick_cnt <= 21'd0;
            else
                tick_cnt <= tick_cnt + 21'd1;
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

    keypad_ctrl u_keypad_ctrl(
        .clk(clk),
        .row(keypad_row),
        .col(keypad_col),
        .key_start(key_start),
        .key_flap(key_flap),
        .key_reset(key_reset),
        .key_code(key_code)
    );

    button_ctrl u_button_ctrl(
        .clk(clk),
        .rst(rst),
        .btn_start(key_start),
        .btn_flap(key_flap),
        .start_pulse(start_pulse),
        .flap_pulse(flap_pulse)
    );

    game_fsm u_game_fsm(
        .clk(clk),
        .rst(rst),
        .start_pulse(start_pulse),
        .dead(dead),
        .game_state(game_state)
    );

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

    vga_sync u_vga_sync(
        .clk(clk),
        .rst(rst),
        .vga_hsync(vga_hsync),
        .vga_vsync(vga_vsync),
        .video_on(video_on),
        .pixel_tick(pixel_tick),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y)
    );

    vga_renderer u_vga_renderer(
        .video_on(video_on),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .game_state(game_state),
        .dead(dead),
        .score(score),
        .bird_x(bird_x),
        .bird_y(bird_y),
        .pipe1_x(pipe1_x),
        .pipe1_gap_y(pipe1_gap_y),
        .pipe2_x(pipe2_x),
        .pipe2_gap_y(pipe2_gap_y),
        .pipe3_x(pipe3_x),
        .pipe3_gap_y(pipe3_gap_y),
        .vga_r(vga_r),
        .vga_g(vga_g),
        .vga_b(vga_b)
    );

    assign led[0] = game_state[0];
    assign led[1] = game_state[1];
    assign led[2] = dead;
    assign led[3] = key_flap;

endmodule
