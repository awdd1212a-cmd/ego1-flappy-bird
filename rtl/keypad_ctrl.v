module keypad_ctrl(
    input  wire       clk,
    input  wire [3:0] row,

    output reg  [3:0] col = 4'b1110,
    output reg        key_start = 1'b0,
    output reg        key_flap = 1'b0,
    output reg        key_reset = 1'b0,
    output reg  [3:0] key_code = 4'd0
);

    localparam [15:0] SCAN_MAX = 16'd50000;

    reg [15:0] scan_cnt = 16'd0;
    reg [1:0]  scan_col = 2'd0;
    reg [3:0]  row_sync0 = 4'hF;
    reg [3:0]  row_sync1 = 4'hF;
    reg [3:0]  detected_code = 4'd0;
    reg        detected_valid = 1'b0;

    always @(posedge clk) begin
        row_sync0 <= row;
        row_sync1 <= row_sync0;

        if (scan_cnt == SCAN_MAX) begin
            scan_cnt <= 16'd0;
            scan_col <= scan_col + 2'd1;
        end else begin
            scan_cnt <= scan_cnt + 16'd1;
        end
    end

    always @(*) begin
        case (scan_col)
            2'd0: col = 4'b1110;
            2'd1: col = 4'b1101;
            2'd2: col = 4'b1011;
            default: col = 4'b0111;
        endcase
    end

    always @(*) begin
        detected_valid = 1'b1;
        case ({row_sync1, scan_col})
            // Physical keypad layout in the NFU FPGA board:
            // F E D C
            // B 3 6 9
            // A 2 5 8
            // 0 1 4 7
            {4'b1110, 2'd0}: detected_code = 4'hF;
            {4'b1110, 2'd1}: detected_code = 4'hE;
            {4'b1110, 2'd2}: detected_code = 4'hD;
            {4'b1110, 2'd3}: detected_code = 4'hC;
            {4'b1101, 2'd0}: detected_code = 4'hB;
            {4'b1101, 2'd1}: detected_code = 4'h3;
            {4'b1101, 2'd2}: detected_code = 4'h6;
            {4'b1101, 2'd3}: detected_code = 4'h9;
            {4'b1011, 2'd0}: detected_code = 4'hA;
            {4'b1011, 2'd1}: detected_code = 4'h2;
            {4'b1011, 2'd2}: detected_code = 4'h5;
            {4'b1011, 2'd3}: detected_code = 4'h8;
            {4'b0111, 2'd0}: detected_code = 4'h0;
            {4'b0111, 2'd1}: detected_code = 4'h1;
            {4'b0111, 2'd2}: detected_code = 4'h4;
            {4'b0111, 2'd3}: detected_code = 4'h7;
            default: begin
                detected_code = 4'd0;
                detected_valid = 1'b0;
            end
        endcase
    end

    always @(posedge clk) begin
        if (detected_valid) begin
            key_code <= detected_code;
            key_start <= (detected_code == 4'h1);
            key_flap  <= (detected_code == 4'h5);
            key_reset <= (detected_code == 4'hD);
        end else begin
            key_start <= 1'b0;
            key_flap  <= 1'b0;
            key_reset <= 1'b0;
        end
    end

endmodule
