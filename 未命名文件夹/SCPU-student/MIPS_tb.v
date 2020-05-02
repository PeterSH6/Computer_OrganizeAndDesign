`timescale 1ns/1ps;
`include "MIPS.v"

module MIPS_tb();
    reg clk,rst;
    MIPS my_MIPS(.clk(clk),.rst(rst));
    initial
        begin
            
        end