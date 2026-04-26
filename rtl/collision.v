module collision(
    input  wire [9:0] bird_x,
    input  wire [8:0] bird_y,
    input  wire [4:0] bird_w,
    input  wire [4:0] bird_h,

    input  wire [9:0] pipe1_x,
    input  wire [8:0] pipe1_gap_y,
    input  wire [9:0] pipe2_x,
    input  wire [8:0] pipe2_gap_y,
    input  wire [9:0] pipe3_x,
    input  wire [8:0] pipe3_gap_y,

    output wire       dead
);

    localparam [9:0] PIPE_W     = 10'd40;
    localparam [8:0] PIPE_GAP_H = 9'd120;
    localparam [8:0] SCREEN_H   = 9'd480;
    localparam [8:0] GROUND_H   = 9'd40;
    localparam [8:0] GROUND_Y   = SCREEN_H - GROUND_H; // 440

    wire [9:0] bird_right;
    wire [8:0] bird_bottom;

    assign bird_right  = bird_x + bird_w;
    assign bird_bottom = bird_y + bird_h;

    // ground collision
    wire hit_ground;
    assign hit_ground = (bird_bottom >= GROUND_Y);

    // ---------- pipe1 ----------
    wire pipe1_x_overlap;
    wire pipe1_hit_top;
    wire pipe1_hit_bottom;
    wire pipe1_hit;

    assign pipe1_x_overlap =
        (bird_right > pipe1_x) &&
        (bird_x < pipe1_x + PIPE_W);

    assign pipe1_hit_top =
        pipe1_x_overlap &&
        (bird_y < pipe1_gap_y);

    assign pipe1_hit_bottom =
        pipe1_x_overlap &&
        (bird_bottom > pipe1_gap_y + PIPE_GAP_H);

    assign pipe1_hit = pipe1_hit_top || pipe1_hit_bottom;

    // ---------- pipe2 ----------
    wire pipe2_x_overlap;
    wire pipe2_hit_top;
    wire pipe2_hit_bottom;
    wire pipe2_hit;

    assign pipe2_x_overlap =
        (bird_right > pipe2_x) &&
        (bird_x < pipe2_x + PIPE_W);

    assign pipe2_hit_top =
        pipe2_x_overlap &&
        (bird_y < pipe2_gap_y);

    assign pipe2_hit_bottom =
        pipe2_x_overlap &&
        (bird_bottom > pipe2_gap_y + PIPE_GAP_H);

    assign pipe2_hit = pipe2_hit_top || pipe2_hit_bottom;

    // ---------- pipe3 ----------
    wire pipe3_x_overlap;
    wire pipe3_hit_top;
    wire pipe3_hit_bottom;
    wire pipe3_hit;

    assign pipe3_x_overlap =
        (bird_right > pipe3_x) &&
        (bird_x < pipe3_x + PIPE_W);

    assign pipe3_hit_top =
        pipe3_x_overlap &&
        (bird_y < pipe3_gap_y);

    assign pipe3_hit_bottom =
        pipe3_x_overlap &&
        (bird_bottom > pipe3_gap_y + PIPE_GAP_H);

    assign pipe3_hit = pipe3_hit_top || pipe3_hit_bottom;

    assign dead = hit_ground || pipe1_hit || pipe2_hit || pipe3_hit;

endmodule