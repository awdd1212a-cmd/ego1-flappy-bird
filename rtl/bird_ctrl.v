module bird_ctrl(
    input  wire       clk,
    input  wire       rst,
    input  wire       game_tick,
    input  wire       flap_pulse,
    input  wire [1:0] game_state,

    output wire [9:0] bird_x,
    output reg  [8:0] bird_y,
    output wire [4:0] bird_w,
    output wire [4:0] bird_h
);

    // State encoding
    localparam S_IDLE      = 2'd0;
    localparam S_PLAY      = 2'd1;
    localparam S_GAME_OVER = 2'd2;

    // Screen / bird constants
    localparam [9:0] BIRD_X_INIT = 10'd100;
    localparam [8:0] BIRD_Y_INIT = 9'd220;
    localparam [4:0] BIRD_SIZE   = 5'd16;

    // Movement constants
    localparam [8:0] FLAP_STEP = 9'd28;
    localparam [8:0] FALL_STEP = 9'd4;

    // Boundary
    localparam [8:0] TOP_LIMIT    = 9'd0;
    localparam [8:0] GROUND_Y     = 9'd440; // 480 - ground_h(40)
    localparam [8:0] BIRD_Y_MAX   = GROUND_Y - BIRD_SIZE;

    assign bird_x = BIRD_X_INIT;
    assign bird_w = BIRD_SIZE;
    assign bird_h = BIRD_SIZE;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            bird_y <= BIRD_Y_INIT;
        end
        else begin
            case (game_state)

                S_IDLE: begin
                    // Hold the bird at the initial position before the game starts.
                    bird_y <= BIRD_Y_INIT;
                end

                S_PLAY: begin
                    if (game_tick) begin
                        if (flap_pulse) begin
                            // Move upward and clamp at the top of the screen.
                            if (bird_y > FLAP_STEP)
                                bird_y <= bird_y - FLAP_STEP;
                            else
                                bird_y <= TOP_LIMIT;
                        end
                        else begin
                            // Fall downward and clamp at the ground.
                            if (bird_y < BIRD_Y_MAX - FALL_STEP)
                                bird_y <= bird_y + FALL_STEP;
                            else
                                bird_y <= BIRD_Y_MAX;
                        end
                    end
                end

                S_GAME_OVER: begin
                    // Freeze the bird after game over.
                    bird_y <= bird_y;
                end

                default: begin
                    bird_y <= BIRD_Y_INIT;
                end

            endcase
        end
    end

endmodule
