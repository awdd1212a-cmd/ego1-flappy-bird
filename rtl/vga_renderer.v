module vga_renderer(
    input  wire       video_on,
    input  wire [9:0] pixel_x,
    input  wire [9:0] pixel_y,

    input  wire [1:0] game_state,
    input  wire       dead,
    input  wire [7:0] score,

    input  wire [9:0] bird_x,
    input  wire [8:0] bird_y,

    input  wire [9:0] pipe1_x,
    input  wire [8:0] pipe1_gap_y,
    input  wire [9:0] pipe2_x,
    input  wire [8:0] pipe2_gap_y,
    input  wire [9:0] pipe3_x,
    input  wire [8:0] pipe3_gap_y,

    output reg  [3:0] vga_r,
    output reg  [3:0] vga_g,
    output reg  [3:0] vga_b
);

    localparam S_IDLE      = 2'd0;
    localparam S_PLAY      = 2'd1;
    localparam S_GAME_OVER = 2'd2;

    localparam [9:0] BIRD_W = 10'd24;
    localparam [9:0] BIRD_H = 10'd24;
    localparam [9:0] PIPE_W = 10'd40;
    localparam [9:0] GAP_H  = 10'd180;
    localparam [9:0] GROUND_Y = 10'd440;
    localparam [9:0] SCORE_X0 = 10'd20;
    localparam [9:0] SCORE_Y0 = 10'd18;
    localparam [9:0] DIGIT_W = 10'd20;
    localparam [9:0] DIGIT_H = 10'd28;
    localparam [9:0] DIGIT_GAP = 10'd6;

    wire [9:0] bird_y_10;
    wire [9:0] pipe1_gap_y_10;
    wire [9:0] pipe2_gap_y_10;
    wire [9:0] pipe3_gap_y_10;

    assign bird_y_10 = {1'b0, bird_y};
    assign pipe1_gap_y_10 = {1'b0, pipe1_gap_y};
    assign pipe2_gap_y_10 = {1'b0, pipe2_gap_y};
    assign pipe3_gap_y_10 = {1'b0, pipe3_gap_y};

    wire in_ground;
    wire in_bird_body;
    wire in_bird_border;
    wire in_bird_beak;
    wire in_bird_eye;
    wire in_bird_pupil;
    wire in_bird_wing;
    wire in_pipe1;
    wire in_pipe2;
    wire in_pipe3;
    wire in_pipe;
    wire in_pipe_highlight;
    wire in_cloud;
    wire in_ground_line;
    wire in_game_over_bar;
    wire in_idle_marker;
    wire in_score_tens;
    wire in_score_ones;
    wire in_score;
    reg [3:0] score_tens;
    reg [3:0] score_ones;

    function digit_pixel;
        input [3:0] digit;
        input [9:0] dx;
        input [9:0] dy;
        reg [6:0] seg;
        reg a;
        reg b;
        reg c;
        reg d;
        reg e;
        reg f;
        reg g;
        begin
            case (digit)
                4'd0: seg = 7'b1111110;
                4'd1: seg = 7'b0110000;
                4'd2: seg = 7'b1101101;
                4'd3: seg = 7'b1111001;
                4'd4: seg = 7'b0110011;
                4'd5: seg = 7'b1011011;
                4'd6: seg = 7'b1011111;
                4'd7: seg = 7'b1110000;
                4'd8: seg = 7'b1111111;
                4'd9: seg = 7'b1111011;
                default: seg = 7'b0000001;
            endcase

            a = (dy < 10'd4) && (dx >= 10'd4) && (dx < 10'd16);
            b = (dx >= 10'd16) && (dx < 10'd20) && (dy >= 10'd4) && (dy < 10'd14);
            c = (dx >= 10'd16) && (dx < 10'd20) && (dy >= 10'd14) && (dy < 10'd24);
            d = (dy >= 10'd24) && (dy < 10'd28) && (dx >= 10'd4) && (dx < 10'd16);
            e = (dx < 10'd4) && (dy >= 10'd14) && (dy < 10'd24);
            f = (dx < 10'd4) && (dy >= 10'd4) && (dy < 10'd14);
            g = (dy >= 10'd12) && (dy < 10'd16) && (dx >= 10'd4) && (dx < 10'd16);

            digit_pixel =
                (seg[6] && a) ||
                (seg[5] && b) ||
                (seg[4] && c) ||
                (seg[3] && d) ||
                (seg[2] && e) ||
                (seg[1] && f) ||
                (seg[0] && g);
        end
    endfunction

    assign in_ground = (pixel_y >= GROUND_Y);

    assign in_bird_body =
        (pixel_x >= bird_x) &&
        (pixel_x < bird_x + BIRD_W) &&
        (pixel_y >= bird_y_10) &&
        (pixel_y < bird_y_10 + BIRD_H);

    assign in_bird_border =
        in_bird_body &&
        ((pixel_x == bird_x) ||
         (pixel_x == bird_x + BIRD_W - 10'd1) ||
         (pixel_y == bird_y_10) ||
         (pixel_y == bird_y_10 + BIRD_H - 10'd1));

    assign in_bird_beak =
        (pixel_x >= bird_x + 10'd20) &&
        (pixel_x < bird_x + 10'd28) &&
        (pixel_y >= bird_y_10 + 10'd9) &&
        (pixel_y < bird_y_10 + 10'd15);

    assign in_bird_eye =
        (pixel_x >= bird_x + 10'd14) &&
        (pixel_x < bird_x + 10'd20) &&
        (pixel_y >= bird_y_10 + 10'd5) &&
        (pixel_y < bird_y_10 + 10'd11);

    assign in_bird_pupil =
        (pixel_x >= bird_x + 10'd17) &&
        (pixel_x < bird_x + 10'd20) &&
        (pixel_y >= bird_y_10 + 10'd7) &&
        (pixel_y < bird_y_10 + 10'd10);

    assign in_bird_wing =
        (pixel_x >= bird_x + 10'd4) &&
        (pixel_x < bird_x + 10'd13) &&
        (pixel_y >= bird_y_10 + 10'd13) &&
        (pixel_y < bird_y_10 + 10'd20);

    assign in_pipe1 =
        (pixel_x >= pipe1_x) &&
        (pixel_x < pipe1_x + PIPE_W) &&
        ((pixel_y < pipe1_gap_y_10) ||
         (pixel_y >= pipe1_gap_y_10 + GAP_H));

    assign in_pipe2 =
        (pixel_x >= pipe2_x) &&
        (pixel_x < pipe2_x + PIPE_W) &&
        ((pixel_y < pipe2_gap_y_10) ||
         (pixel_y >= pipe2_gap_y_10 + GAP_H));

    assign in_pipe3 =
        (pixel_x >= pipe3_x) &&
        (pixel_x < pipe3_x + PIPE_W) &&
        ((pixel_y < pipe3_gap_y_10) ||
         (pixel_y >= pipe3_gap_y_10 + GAP_H));

    assign in_pipe = in_pipe1 || in_pipe2 || in_pipe3;

    assign in_pipe_highlight =
        in_pipe &&
        (((pixel_x >= pipe1_x + 10'd3) && (pixel_x < pipe1_x + 10'd7)) ||
         ((pixel_x >= pipe2_x + 10'd3) && (pixel_x < pipe2_x + 10'd7)) ||
         ((pixel_x >= pipe3_x + 10'd3) && (pixel_x < pipe3_x + 10'd7)));

    assign in_cloud =
        ((pixel_x >= 10'd70) && (pixel_x < 10'd150) &&
         pixel_y >= 10'd55 && pixel_y < 10'd78) ||
        ((pixel_x >= 10'd420) && (pixel_x < 10'd520) &&
         pixel_y >= 10'd90 && pixel_y < 10'd116);

    assign in_ground_line =
        in_ground &&
        ((pixel_y == 10'd440) ||
         ((pixel_y >= 10'd458) && (pixel_y < 10'd462)) ||
         ((pixel_x[5:0] >= 6'd0) && (pixel_x[5:0] < 6'd5) &&
          (pixel_y >= 10'd446) && (pixel_y < 10'd480)));

    always @(*) begin
        if (score >= 8'd99) begin
            score_tens = 4'd9;
            score_ones = 4'd9;
        end else if (score >= 8'd90) begin
            score_tens = 4'd9;
            score_ones = score - 8'd90;
        end else if (score >= 8'd80) begin
            score_tens = 4'd8;
            score_ones = score - 8'd80;
        end else if (score >= 8'd70) begin
            score_tens = 4'd7;
            score_ones = score - 8'd70;
        end else if (score >= 8'd60) begin
            score_tens = 4'd6;
            score_ones = score - 8'd60;
        end else if (score >= 8'd50) begin
            score_tens = 4'd5;
            score_ones = score - 8'd50;
        end else if (score >= 8'd40) begin
            score_tens = 4'd4;
            score_ones = score - 8'd40;
        end else if (score >= 8'd30) begin
            score_tens = 4'd3;
            score_ones = score - 8'd30;
        end else if (score >= 8'd20) begin
            score_tens = 4'd2;
            score_ones = score - 8'd20;
        end else if (score >= 8'd10) begin
            score_tens = 4'd1;
            score_ones = score - 8'd10;
        end else begin
            score_tens = 4'd0;
            score_ones = score[3:0];
        end
    end

    assign in_score_tens =
        (pixel_x >= SCORE_X0) &&
        (pixel_x < SCORE_X0 + DIGIT_W) &&
        (pixel_y >= SCORE_Y0) &&
        (pixel_y < SCORE_Y0 + DIGIT_H) &&
        digit_pixel(score_tens, pixel_x - SCORE_X0, pixel_y - SCORE_Y0);

    assign in_score_ones =
        (pixel_x >= SCORE_X0 + DIGIT_W + DIGIT_GAP) &&
        (pixel_x < SCORE_X0 + DIGIT_W + DIGIT_GAP + DIGIT_W) &&
        (pixel_y >= SCORE_Y0) &&
        (pixel_y < SCORE_Y0 + DIGIT_H) &&
        digit_pixel(score_ones, pixel_x - SCORE_X0 - DIGIT_W - DIGIT_GAP, pixel_y - SCORE_Y0);

    assign in_score = in_score_tens || in_score_ones;

    assign in_idle_marker =
        (game_state == S_IDLE) &&
        (pixel_x >= 10'd250) && (pixel_x < 10'd390) &&
        (pixel_y >= 10'd210) && (pixel_y < 10'd270);

    assign in_game_over_bar =
        (game_state == S_GAME_OVER || dead) &&
        (pixel_x >= 10'd180) && (pixel_x < 10'd460) &&
        (pixel_y >= 10'd200) && (pixel_y < 10'd280);

    always @(*) begin
        if (!video_on) begin
            vga_r = 4'h0;
            vga_g = 4'h0;
            vga_b = 4'h0;
        end else if (in_game_over_bar) begin
            vga_r = 4'hD;
            vga_g = 4'h1;
            vga_b = 4'h1;
        end else if (in_idle_marker) begin
            vga_r = 4'hF;
            vga_g = 4'hD;
            vga_b = 4'h3;
        end else if (in_score) begin
            vga_r = 4'hF;
            vga_g = 4'hF;
            vga_b = 4'hF;
        end else if (in_bird_pupil) begin
            vga_r = 4'h0;
            vga_g = 4'h0;
            vga_b = 4'h0;
        end else if (in_bird_eye) begin
            vga_r = 4'hF;
            vga_g = 4'hF;
            vga_b = 4'hF;
        end else if (in_bird_beak) begin
            vga_r = 4'hF;
            vga_g = 4'h7;
            vga_b = 4'h1;
        end else if (in_bird_border) begin
            vga_r = 4'h1;
            vga_g = 4'h1;
            vga_b = 4'h1;
        end else if (in_bird_wing) begin
            vga_r = 4'hC;
            vga_g = 4'h8;
            vga_b = 4'h1;
        end else if (in_bird_body) begin
            vga_r = 4'hF;
            vga_g = 4'hD;
            vga_b = 4'h2;
        end else if (in_pipe_highlight) begin
            vga_r = 4'h6;
            vga_g = 4'hF;
            vga_b = 4'h6;
        end else if (in_pipe) begin
            vga_r = 4'h1;
            vga_g = 4'hB;
            vga_b = 4'h3;
        end else if (in_ground_line) begin
            vga_r = 4'h9;
            vga_g = 4'h5;
            vga_b = 4'h2;
        end else if (in_ground) begin
            vga_r = 4'h6;
            vga_g = 4'h3;
            vga_b = 4'h1;
        end else if (in_cloud) begin
            vga_r = 4'hF;
            vga_g = 4'hF;
            vga_b = 4'hF;
        end else begin
            vga_r = 4'h4;
            vga_g = 4'hC;
            vga_b = 4'hF;
        end
    end

endmodule
