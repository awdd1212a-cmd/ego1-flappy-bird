module top_keypad_probe(
    input  wire        clk,
    input  wire        rst,
    input  wire [1:0]  sw,
    inout  wire [31:0] j5,
    output wire [15:0] led
);

    reg [16:0] div_cnt;
    reg [4:0] scan_idx;
    reg [4:0] drive_latched;
    reg [4:0] sense_latched;
    reg       hit_latched;

    wire scan_tick;
    wire [4:0] scan_base;
    wire [4:0] scan_pin;
    wire [31:0] low_mask;
    wire [31:0] sense_mask;
    wire any_hit;

    assign scan_tick = (div_cnt == 17'd0);
    assign scan_base = {sw, 3'b000};
    assign scan_pin = scan_base + scan_idx[2:0];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            div_cnt <= 17'd0;
            scan_idx <= 5'd0;
        end else begin
            div_cnt <= div_cnt + 17'd1;
            if (scan_tick) begin
                scan_idx <= scan_idx + 5'd1;
            end
        end
    end

    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : g_j5_scan
            assign j5[i] = (scan_pin == i[4:0]) ? 1'b0 : 1'bz;
        end
    endgenerate

    assign low_mask = ~j5;
    assign sense_mask = low_mask & ~(32'h00000001 << scan_pin);
    assign any_hit = (sense_mask != 32'd0);

    function [4:0] first_low_index;
        input [31:0] mask;
        begin
            if (mask[0])       first_low_index = 5'd0;
            else if (mask[1])  first_low_index = 5'd1;
            else if (mask[2])  first_low_index = 5'd2;
            else if (mask[3])  first_low_index = 5'd3;
            else if (mask[4])  first_low_index = 5'd4;
            else if (mask[5])  first_low_index = 5'd5;
            else if (mask[6])  first_low_index = 5'd6;
            else if (mask[7])  first_low_index = 5'd7;
            else if (mask[8])  first_low_index = 5'd8;
            else if (mask[9])  first_low_index = 5'd9;
            else if (mask[10]) first_low_index = 5'd10;
            else if (mask[11]) first_low_index = 5'd11;
            else if (mask[12]) first_low_index = 5'd12;
            else if (mask[13]) first_low_index = 5'd13;
            else if (mask[14]) first_low_index = 5'd14;
            else if (mask[15]) first_low_index = 5'd15;
            else if (mask[16]) first_low_index = 5'd16;
            else if (mask[17]) first_low_index = 5'd17;
            else if (mask[18]) first_low_index = 5'd18;
            else if (mask[19]) first_low_index = 5'd19;
            else if (mask[20]) first_low_index = 5'd20;
            else if (mask[21]) first_low_index = 5'd21;
            else if (mask[22]) first_low_index = 5'd22;
            else if (mask[23]) first_low_index = 5'd23;
            else if (mask[24]) first_low_index = 5'd24;
            else if (mask[25]) first_low_index = 5'd25;
            else if (mask[26]) first_low_index = 5'd26;
            else if (mask[27]) first_low_index = 5'd27;
            else if (mask[28]) first_low_index = 5'd28;
            else if (mask[29]) first_low_index = 5'd29;
            else if (mask[30]) first_low_index = 5'd30;
            else if (mask[31]) first_low_index = 5'd31;
            else               first_low_index = 5'd0;
        end
    endfunction

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            drive_latched <= 5'd0;
            sense_latched <= 5'd0;
            hit_latched <= 1'b0;
        end else if (scan_tick && any_hit) begin
            drive_latched <= scan_pin;
            sense_latched <= first_low_index(sense_mask);
            hit_latched <= 1'b1;
        end
    end

    assign led[4:0] = drive_latched + 5'd1;
    assign led[9:5] = sense_latched + 5'd1;
    assign led[13:10] = 4'd0;
    assign led[14] = any_hit;
    assign led[15] = hit_latched;

endmodule
