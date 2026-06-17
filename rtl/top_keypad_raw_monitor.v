module top_keypad_raw_monitor(
    input  wire        clk,
    input  wire        rst,
    input  wire [1:0]  sw,
    input  wire [31:0] j5,
    output wire [15:0] led
);

    reg [31:0] low_latched;
    wire [31:0] low_now;
    wire [7:0] bank_now;
    wire [7:0] bank_latched;

    assign low_now = ~j5;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            low_latched <= 32'd0;
        end else begin
            low_latched <= low_latched | low_now;
        end
    end

    assign bank_now =
        (sw == 2'b00) ? low_now[7:0] :
        (sw == 2'b01) ? low_now[15:8] :
        (sw == 2'b10) ? low_now[23:16] :
                        low_now[31:24];

    assign bank_latched =
        (sw == 2'b00) ? low_latched[7:0] :
        (sw == 2'b01) ? low_latched[15:8] :
        (sw == 2'b10) ? low_latched[23:16] :
                        low_latched[31:24];

    assign led[7:0] = bank_now;
    assign led[15:8] = bank_latched;

endmodule
