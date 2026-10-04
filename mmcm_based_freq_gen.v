`timescale 1ns / 1ps

// output = 100MHz * CLKFBOUT_MULT_F / (DIVCLK_DIVIDE * CLKOUT0_DIVIDE_F)
// set up here for 400MHz (100 * 12 / (1 * 3))
module clk_gen (
    input  wire clk_in,
    output wire clk_out,
    output wire locked
);
    wire fb, fb_buf;
    wire c0;

    MMCME2_BASE #(
        .CLKIN1_PERIOD    (10.0),
        .DIVCLK_DIVIDE    (1),
        .CLKFBOUT_MULT_F  (12.0),
        .CLKOUT0_DIVIDE_F (3.0),
        .CLKOUT0_DUTY_CYCLE(0.5),
        .STARTUP_WAIT("FALSE")
    ) mmcm (
        .CLKIN1  (clk_in),
        .CLKFBIN (fb_buf),
        .PWRDWN  (1'b0),
        .RST     (1'b0),
        .CLKFBOUT(fb),
        .CLKOUT0 (c0),
        .LOCKED  (locked)
    );

    BUFG b_fb (.I(fb), .O(fb_buf));
    BUFG b0   (.I(c0), .O(clk_out));
endmodule


module top (
    input  wire clk,
    output wire out,
    output wire locked_led
);
    wire clk_out;

    clk_gen u_clk (
        .clk_in (clk),
        .clk_out(clk_out),
        .locked (locked_led)
    );

    assign out = clk_out;
endmodule
