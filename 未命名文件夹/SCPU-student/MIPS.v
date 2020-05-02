`include "alu.v"
`include "ctrl_encode_def.v"
`include "EXT.v"
`include "mux.v"
`include "NPC.v"
`include "PC.v"
`include "RF.v"

module MIPS(clk,rst)
    input clk;
    input rst;

    //PC module
    wire [31:0] i_PC;
    reg [31:0] o_PC;
    PC my_PC(.clk(clk),.rst(rst),.NPC(i_PC),.PC(o_PC))
