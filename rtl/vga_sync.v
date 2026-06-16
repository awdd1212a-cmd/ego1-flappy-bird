module vga_sync(
    input  wire       clk,
    input  wire       rst,

    output wire       vga_hsync,
    output wire       vga_vsync,
    output wire       video_on,
    output wire       pixel_tick,
    output wire [9:0] pixel_x,
    output wire [9:0] pixel_y
);

    // 640x480 @ 60 Hz VGA timing with a 25 MHz pixel enable.
    // EGO1 clock is 100 MHz, so pixel_tick is generated once every 4 clocks.
    localparam [1:0] PIXEL_DIV_MAX = 2'd3;

    localparam [9:0] H_DISPLAY = 10'd640;
    localparam [9:0] H_FRONT   = 10'd16;
    localparam [9:0] H_SYNC    = 10'd96;
    localparam [9:0] H_BACK    = 10'd48;
    localparam [9:0] H_TOTAL   = H_DISPLAY + H_FRONT + H_SYNC + H_BACK;

    localparam [9:0] V_DISPLAY = 10'd480;
    localparam [9:0] V_FRONT   = 10'd10;
    localparam [9:0] V_SYNC    = 10'd2;
    localparam [9:0] V_BACK    = 10'd33;
    localparam [9:0] V_TOTAL   = V_DISPLAY + V_FRONT + V_SYNC + V_BACK;

    localparam [9:0] H_SYNC_START = H_DISPLAY + H_FRONT;
    localparam [9:0] H_SYNC_END   = H_DISPLAY + H_FRONT + H_SYNC;
    localparam [9:0] V_SYNC_START = V_DISPLAY + V_FRONT;
    localparam [9:0] V_SYNC_END   = V_DISPLAY + V_FRONT + V_SYNC;

    reg [1:0] pixel_div;
    reg [9:0] h_count;
    reg [9:0] v_count;

    assign pixel_tick = (pixel_div == PIXEL_DIV_MAX);
    assign pixel_x = h_count;
    assign pixel_y = v_count;
    assign video_on = (h_count < H_DISPLAY) && (v_count < V_DISPLAY);
    assign vga_hsync = ~((h_count >= H_SYNC_START) && (h_count < H_SYNC_END));
    assign vga_vsync = ~((v_count >= V_SYNC_START) && (v_count < V_SYNC_END));

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pixel_div <= 2'd0;
        end else begin
            pixel_div <= pixel_div + 2'd1;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            h_count <= 10'd0;
            v_count <= 10'd0;
        end else if (pixel_tick) begin
            if (h_count == H_TOTAL - 10'd1) begin
                h_count <= 10'd0;

                if (v_count == V_TOTAL - 10'd1)
                    v_count <= 10'd0;
                else
                    v_count <= v_count + 10'd1;
            end else begin
                h_count <= h_count + 10'd1;
            end
        end
    end

endmodule
