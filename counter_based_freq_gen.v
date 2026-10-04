`timescale 1ns / 1ps

// toggles out using a counter, no MMCM, just fabric logic
module generation #(
    parameter FREQ_HZ  = 1000,
    parameter DUTY_PCT = 50
)(
    input  wire clk,
    input  wire rst,
    output reg  out
);
    localparam CLK_HZ = 100_000_000;
    localparam PERIOD = CLK_HZ / FREQ_HZ;
    localparam HIGH_C = (PERIOD * DUTY_PCT) / 100;
    localparam LOW_C  = PERIOD - HIGH_C;

    localparam LOW  = 1'b0;
    localparam HIGH = 1'b1;

    reg        state;
    reg [26:0] cnt;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= HIGH;
            cnt   <= 0;
            out   <= 1'b1;
        end
        else begin
            case (state)
                LOW: begin
                    out <= 1'b0;
                    if (cnt == LOW_C - 1) begin
                        cnt   <= 0;
                        state <= HIGH;
                    end
                    else cnt <= cnt + 1;
                end
                HIGH: begin
                    out <= 1'b1;
                    if (cnt == HIGH_C - 1) begin
                        cnt   <= 0;
                        state <= LOW;
                    end
                    else cnt <= cnt + 1;
                end
                default: begin
                    state <= HIGH;
                    cnt   <= 0;
                    out   <= 1'b1;
                end
            endcase
        end
    end
endmodule


module top (
    input  wire clk,
    input  wire rst,
    output wire out
);
    generation #(
        .FREQ_HZ (1000),
        .DUTY_PCT(50)
    ) u_gen (
        .clk(clk),
        .rst(rst),
        .out(out)
    );
endmodule
