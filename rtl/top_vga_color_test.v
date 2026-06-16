module top_vga_color_test(
    input  wire       clk,
    input  wire       rst,

    output wire [3:0] vga_r,
    output wire [3:0] vga_g,
    output wire [3:0] vga_b,
    output wire       vga_hsync,
    output wire       vga_vsync
);

    wire       video_on;
    wire       pixel_tick;
    wire [9:0] pixel_x;
    wire [9:0] pixel_y;

    reg [3:0] red;
    reg [3:0] green;
    reg [3:0] blue;

    vga_sync u_vga_sync(
        .clk(clk),
        .rst(rst),
        .vga_hsync(vga_hsync),
        .vga_vsync(vga_vsync),
        .video_on(video_on),
        .pixel_tick(pixel_tick),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y)
    );

    always @(*) begin
        if (!video_on) begin
            red   = 4'h0;
            green = 4'h0;
            blue  = 4'h0;
        end else if (pixel_y >= 10'd440) begin
            red   = 4'h6;
            green = 4'h3;
            blue  = 4'h1;
        end else if (pixel_x < 10'd160) begin
            red   = 4'h4;
            green = 4'hC;
            blue  = 4'hF;
        end else if (pixel_x < 10'd320) begin
            red   = 4'h3;
            green = 4'hD;
            blue  = 4'h6;
        end else if (pixel_x < 10'd480) begin
            red   = 4'hF;
            green = 4'hD;
            blue  = 4'h3;
        end else begin
            red   = 4'hF;
            green = 4'h5;
            blue  = 4'h5;
        end
    end

    assign vga_r = red;
    assign vga_g = green;
    assign vga_b = blue;

endmodule
