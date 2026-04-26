module button_ctrl(
    input  wire clk,
    input  wire rst,
    input  wire btn_start,
    input  wire btn_flap,

    output wire start_pulse,
    output wire flap_pulse
);

    reg btn_start_d;
    reg btn_flap_d;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            btn_start_d <= 1'b0;
            btn_flap_d  <= 1'b0;
        end else begin
            btn_start_d <= btn_start;
            btn_flap_d  <= btn_flap;
        end
    end

    assign start_pulse = btn_start & ~btn_start_d;
    assign flap_pulse  = btn_flap  & ~btn_flap_d;

endmodule