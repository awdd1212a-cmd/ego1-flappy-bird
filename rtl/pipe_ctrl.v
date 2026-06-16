module pipe_ctrl(
    input  wire       clk,
    input  wire       rst,
    input  wire       game_tick,
    input  wire [1:0] game_state,

    output reg  [9:0] pipe1_x,
    output reg  [8:0] pipe1_gap_y,
    output reg  [9:0] pipe2_x,
    output reg  [8:0] pipe2_gap_y,
    output reg  [9:0] pipe3_x,
    output reg  [8:0] pipe3_gap_y
);

    // State encoding
    localparam S_IDLE      = 2'd0;
    localparam S_PLAY      = 2'd1;
    localparam S_GAME_OVER = 2'd2;

    // Screen / pipe constants
    localparam [9:0] SCREEN_W   = 10'd640;
    localparam [9:0] PIPE_W     = 10'd40;
    localparam [8:0] GAP_H      = 9'd180;

    // Initial pipe positions. Some values start off-screen to the right.
    localparam [9:0] PIPE1_X_INIT = 10'd500;
    localparam [9:0] PIPE2_X_INIT = 10'd700;
    localparam [9:0] PIPE3_X_INIT = 10'd900;

    // Fixed gap positions for the first version.
    localparam [8:0] PIPE1_GAP_Y_INIT = 9'd140;
    localparam [8:0] PIPE2_GAP_Y_INIT = 9'd220;
    localparam [8:0] PIPE3_GAP_Y_INIT = 9'd180;

    // Movement speed per game tick.
    localparam [9:0] PIPE_SPEED = 10'd2;

    // Recycle positions must fit in 10 bits.
    localparam [9:0] PIPE1_RECYCLE_X = 10'd700;
    localparam [9:0] PIPE2_RECYCLE_X = 10'd860;
    localparam [9:0] PIPE3_RECYCLE_X = 10'd1020;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pipe1_x     <= PIPE1_X_INIT;
            pipe1_gap_y <= PIPE1_GAP_Y_INIT;

            pipe2_x     <= PIPE2_X_INIT;
            pipe2_gap_y <= PIPE2_GAP_Y_INIT;

            pipe3_x     <= PIPE3_X_INIT;
            pipe3_gap_y <= PIPE3_GAP_Y_INIT;
        end
        else begin
            case (game_state)

                S_IDLE: begin
                    // Reset pipes to their initial positions before the game starts.
                    pipe1_x     <= PIPE1_X_INIT;
                    pipe1_gap_y <= PIPE1_GAP_Y_INIT;

                    pipe2_x     <= PIPE2_X_INIT;
                    pipe2_gap_y <= PIPE2_GAP_Y_INIT;

                    pipe3_x     <= PIPE3_X_INIT;
                    pipe3_gap_y <= PIPE3_GAP_Y_INIT;
                end

                S_PLAY: begin
                    if (game_tick) begin
                        // pipe1
                        if (pipe1_x > PIPE_SPEED)
                            pipe1_x <= pipe1_x - PIPE_SPEED;
                        else
                            pipe1_x <= PIPE1_RECYCLE_X;

                        // pipe2
                        if (pipe2_x > PIPE_SPEED)
                            pipe2_x <= pipe2_x - PIPE_SPEED;
                        else
                            pipe2_x <= PIPE2_RECYCLE_X;

                        // pipe3
                        if (pipe3_x > PIPE_SPEED)
                            pipe3_x <= pipe3_x - PIPE_SPEED;
                        else
                            pipe3_x <= PIPE3_RECYCLE_X;
                    end
                end

                S_GAME_OVER: begin
                    // Freeze pipes after game over.
                    pipe1_x <= pipe1_x;
                    pipe2_x <= pipe2_x;
                    pipe3_x <= pipe3_x;
                end

                default: begin
                    pipe1_x     <= PIPE1_X_INIT;
                    pipe1_gap_y <= PIPE1_GAP_Y_INIT;

                    pipe2_x     <= PIPE2_X_INIT;
                    pipe2_gap_y <= PIPE2_GAP_Y_INIT;

                    pipe3_x     <= PIPE3_X_INIT;
                    pipe3_gap_y <= PIPE3_GAP_Y_INIT;
                end

            endcase
        end
    end

endmodule
