module game_fsm(
    input  wire       clk,
    input  wire       rst,
    input  wire       start_pulse,
    input  wire       dead,
    output reg  [1:0] game_state
);

    // State encoding
    localparam S_IDLE      = 2'd0;
    localparam S_PLAY      = 2'd1;
    localparam S_GAME_OVER = 2'd2;

    reg [1:0] next_state;

    // State register
    always @(posedge clk or posedge rst) begin
        if (rst)
            game_state <= S_IDLE;
        else
            game_state <= next_state;
    end

    // Next-state logic
    always @(*) begin
        // default: stay in current state
        next_state = game_state;

        case (game_state)
            S_IDLE: begin
                if (start_pulse)
                    next_state = S_PLAY;
            end

            S_PLAY: begin
                if (dead)
                    next_state = S_GAME_OVER;
            end

            S_GAME_OVER: begin
                if (start_pulse)
                    next_state = S_IDLE;
            end

            default: begin
                next_state = S_IDLE;
            end
        endcase
    end

endmodule