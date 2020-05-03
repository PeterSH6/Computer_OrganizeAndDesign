`timescale 1ns/1ps;
`include "MIPS.v"

module MIPS_tb();
    reg clk,rst;
    MIPS my_MIPS(.clk(clk),.rst(rst));
    initial
        begin
            clk = 1;
            reset = 1;
            #5
            reset = 0;
            #20
            reset = 1;
        end

    always
        #(50) clk = ~clk;