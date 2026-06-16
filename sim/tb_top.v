`timescale 1ns / 1ps

module tb_top;

    reg clk;
    reg rst;
    reg btnC;
    reg btnU;

    wire [1:0] game_state;
    wire       dead;
    wire [7:0] score;

    wire [9:0] bird_x;
    wire [8:0] bird_y;

    wire [9:0] pipe1_x;
    wire [8:0] pipe1_gap_y;
    wire [9:0] pipe2_x;
    wire [8:0] pipe2_gap_y;
    wire [9:0] pipe3_x;
    wire [8:0] pipe3_gap_y;

    wire [3:0] led;

    // ============================================================
    // Instantiate top
    // ============================================================

    top_debug uut (
        .clk(clk),
        .rst(rst),

        .btnC(btnC),
        .btnU(btnU),

        .game_state(game_state),
        .dead(dead),
        .score(score),

        .bird_x(bird_x),
        .bird_y(bird_y),

        .pipe1_x(pipe1_x),
        .pipe1_gap_y(pipe1_gap_y),
        .pipe2_x(pipe2_x),
        .pipe2_gap_y(pipe2_gap_y),
        .pipe3_x(pipe3_x),
        .pipe3_gap_y(pipe3_gap_y),

        .led(led)
    );

    // ============================================================
    // Clock generation
    // 100 MHz clock => 10 ns period
    // ============================================================

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // ============================================================
    // Test sequence
    // ============================================================

    initial begin
        // Initial values
        rst  = 1'b1;
        btnC = 1'b0;
        btnU = 1'b0;

        // Hold reset
        #100;
        rst = 1'b0;

        // Wait after reset
        #100;
        $display("After reset: game_state = %b, dead = %b, bird_y = %d, pipe1_x = %d",
                 game_state, dead, bird_y, pipe1_x);

        // --------------------------------------------------------
        // Press start button
        // --------------------------------------------------------
        btnC = 1'b1;
        #20;
        btnC = 1'b0;

        // Wait for game to enter PLAY
        #1000;
        $display("After start: game_state = %b, dead = %b, bird_y = %d, pipe1_x = %d",
                 game_state, dead, bird_y, pipe1_x);

        // --------------------------------------------------------
        // Press flap 1
        // --------------------------------------------------------
        btnU = 1'b1;
        #20;
        btnU = 1'b0;

        #1000;
        $display("After flap 1: game_state = %b, dead = %b, bird_y = %d, pipe1_x = %d",
                 game_state, dead, bird_y, pipe1_x);

        // Let the game run for a while
        #2000000;

        // --------------------------------------------------------
        // Press flap 2
        // --------------------------------------------------------
        btnU = 1'b1;
        #20;
        btnU = 1'b0;

        #1000;
        $display("After flap 2: game_state = %b, dead = %b, bird_y = %d, pipe1_x = %d",
                 game_state, dead, bird_y, pipe1_x);

        // Let the game run for a while
        #2000000;

        // --------------------------------------------------------
        // Press flap 3
        // --------------------------------------------------------
        btnU = 1'b1;
        #20;
        btnU = 1'b0;

        #1000;
        $display("After flap 3: game_state = %b, dead = %b, bird_y = %d, pipe1_x = %d",
                 game_state, dead, bird_y, pipe1_x);

        // Let the game run
        #20000000;

        // --------------------------------------------------------
        // Final check
        // --------------------------------------------------------
        $display("=================================");
        $display("Final game_state = %b", game_state);
        $display("Final dead       = %b", dead);
        $display("Final score      = %d", score);
        $display("Final bird_x     = %d", bird_x);
        $display("Final bird_y     = %d", bird_y);
        $display("Final pipe1_x    = %d", pipe1_x);
        $display("Final pipe2_x    = %d", pipe2_x);
        $display("Final pipe3_x    = %d", pipe3_x);
        $display("Final led        = %b", led);
        $display("=================================");

        $finish;
    end

endmodule
