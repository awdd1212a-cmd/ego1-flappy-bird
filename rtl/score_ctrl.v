module score_ctrl(
    input  wire       clk,
    input  wire       rst,
    input  wire       game_tick,
    input  wire [1:0] game_state,

    input  wire [9:0] bird_x,

    input  wire [9:0] pipe1_x,
    input  wire [9:0] pipe2_x,
    input  wire [9:0] pipe3_x,

    output reg  [7:0] score
);

    localparam S_IDLE = 2'd0;
    localparam S_PLAY = 2'd1;

    localparam [10:0] PIPE_W = 11'd40;
    localparam [10:0] SCREEN_W = 11'd640;
    localparam [7:0]  SCORE_STEP_NORMAL = 8'd1;
    localparam [7:0]  SCORE_STEP_BONUS = 8'd5;

    reg [9:0] pipe1_x_prev;
    reg [9:0] pipe2_x_prev;
    reg [9:0] pipe3_x_prev;
    reg [1:0] passed_pipe_count;

    wire [10:0] bird_x_ext;
    wire [10:0] pipe1_right;
    wire [10:0] pipe2_right;
    wire [10:0] pipe3_right;
    wire [10:0] pipe1_right_prev;
    wire [10:0] pipe2_right_prev;
    wire [10:0] pipe3_right_prev;

    wire pipe1_passed;
    wire pipe2_passed;
    wire pipe3_passed;
    wire any_pipe_passed;

    assign bird_x_ext = {1'b0, bird_x};

    assign pipe1_right = {1'b0, pipe1_x} + PIPE_W;
    assign pipe2_right = {1'b0, pipe2_x} + PIPE_W;
    assign pipe3_right = {1'b0, pipe3_x} + PIPE_W;

    assign pipe1_right_prev = {1'b0, pipe1_x_prev} + PIPE_W;
    assign pipe2_right_prev = {1'b0, pipe2_x_prev} + PIPE_W;
    assign pipe3_right_prev = {1'b0, pipe3_x_prev} + PIPE_W;

    assign pipe1_passed =
        (pipe1_right_prev >= bird_x_ext) &&
        (pipe1_right < bird_x_ext) &&
        (pipe1_right < SCREEN_W);

    assign pipe2_passed =
        (pipe2_right_prev >= bird_x_ext) &&
        (pipe2_right < bird_x_ext) &&
        (pipe2_right < SCREEN_W);

    assign pipe3_passed =
        (pipe3_right_prev >= bird_x_ext) &&
        (pipe3_right < bird_x_ext) &&
        (pipe3_right < SCREEN_W);

    assign any_pipe_passed = pipe1_passed || pipe2_passed || pipe3_passed;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            score <= 8'd0;
            passed_pipe_count <= 2'd0;
            pipe1_x_prev <= pipe1_x;
            pipe2_x_prev <= pipe2_x;
            pipe3_x_prev <= pipe3_x;
        end else if (game_state == S_IDLE) begin
            score <= 8'd0;
            passed_pipe_count <= 2'd0;
            pipe1_x_prev <= pipe1_x;
            pipe2_x_prev <= pipe2_x;
            pipe3_x_prev <= pipe3_x;
        end else if (game_state == S_PLAY && game_tick) begin
            if (any_pipe_passed) begin
                if (passed_pipe_count == 2'd2) begin
                    score <= score + SCORE_STEP_BONUS;
                    passed_pipe_count <= 2'd0;
                end else begin
                    score <= score + SCORE_STEP_NORMAL;
                    passed_pipe_count <= passed_pipe_count + 2'd1;
                end
            end

            pipe1_x_prev <= pipe1_x;
            pipe2_x_prev <= pipe2_x;
            pipe3_x_prev <= pipe3_x;
        end
    end

endmodule
