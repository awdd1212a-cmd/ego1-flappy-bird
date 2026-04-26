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

    // ============================================================
    // State encoding
    // ============================================================

    localparam S_IDLE      = 2'd0;
    localparam S_PLAY      = 2'd1;
    localparam S_GAME_OVER = 2'd2;

    // ============================================================
    // Constants
    // ============================================================

    localparam [9:0] PIPE_W = 10'd40;

    // ============================================================
    // Counted flags
    // ============================================================

    reg pipe1_counted;
    reg pipe2_counted;
    reg pipe3_counted;

    // ============================================================
    // Score logic
    // ============================================================

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            score <= 8'd0;

            pipe1_counted <= 1'b0;
            pipe2_counted <= 1'b0;
            pipe3_counted <= 1'b0;
        end else begin
            if (game_state == S_IDLE) begin
                score <= 8'd0;

                pipe1_counted <= 1'b0;
                pipe2_counted <= 1'b0;
                pipe3_counted <= 1'b0;
            end else if (game_state == S_PLAY && game_tick) begin

                // ----------------------------
                // Pipe 1 scoring
                // ----------------------------
                if ((pipe1_x + PIPE_W < bird_x) && !pipe1_counted) begin
                    score <= score + 8'd1;
                    pipe1_counted <= 1'b1;
                end

                // 當 pipe 回到右側，解除 counted
                if (pipe1_x > 10'd600) begin
                    pipe1_counted <= 1'b0;
                end

                // ----------------------------
                // Pipe 2 scoring
                // ----------------------------
                if ((pipe2_x + PIPE_W < bird_x) && !pipe2_counted) begin
                    score <= score + 8'd1;
                    pipe2_counted <= 1'b1;
                end

                if (pipe2_x > 10'd600) begin
                    pipe2_counted <= 1'b0;
                end

                // ----------------------------
                // Pipe 3 scoring
                // ----------------------------
                if ((pipe3_x + PIPE_W < bird_x) && !pipe3_counted) begin
                    score <= score + 8'd1;
                    pipe3_counted <= 1'b1;
                end

                if (pipe3_x > 10'd600) begin
                    pipe3_counted <= 1'b0;
                end

            end
        end
    end

endmodule