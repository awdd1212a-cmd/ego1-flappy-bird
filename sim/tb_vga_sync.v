`timescale 1ns / 1ps

module tb_vga_sync;

    reg clk;
    reg rst;

    wire       vga_hsync;
    wire       vga_vsync;
    wire       video_on;
    wire       pixel_tick;
    wire [9:0] pixel_x;
    wire [9:0] pixel_y;

    integer i;

    vga_sync uut(
        .clk(clk),
        .rst(rst),
        .vga_hsync(vga_hsync),
        .vga_vsync(vga_vsync),
        .video_on(video_on),
        .pixel_tick(pixel_tick),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    task wait_pixel_tick;
        begin
            @(posedge clk);
            while (!pixel_tick)
                @(posedge clk);
            #1;
        end
    endtask

    task fail;
        input [639:0] message;
        begin
            $display("FAIL: %0s", message);
            $finish;
        end
    endtask

    initial begin
        rst = 1'b1;
        #40;
        rst = 1'b0;
        #1;

        if (pixel_x !== 10'd0) fail("pixel_x should reset to 0");
        if (pixel_y !== 10'd0) fail("pixel_y should reset to 0");
        if (video_on !== 1'b1) fail("video_on should be high at the first visible pixel");

        wait_pixel_tick();
        if (pixel_x !== 10'd1) fail("pixel_x should increment after one pixel tick");
        if (pixel_y !== 10'd0) fail("pixel_y should remain 0 during the first line");

        for (i = 1; i < 656; i = i + 1)
            wait_pixel_tick();
        if (vga_hsync !== 1'b0) fail("hsync should be low during horizontal sync");

        for (i = 656; i < 800; i = i + 1)
            wait_pixel_tick();
        if (pixel_x !== 10'd0) fail("pixel_x should wrap after one full line");
        if (pixel_y !== 10'd1) fail("pixel_y should increment after one full line");

        $display("VGA sync test passed: pixel counters and hsync timing look valid.");
        $finish;
    end

endmodule
