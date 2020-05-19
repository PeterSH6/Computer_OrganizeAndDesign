`include "ctrl_encode_def.v"
module ForwardUnit(
    input EXMEMRegWrite,
    input [4:0] EXMEMRegRd,
    input [4:0] IDEXRegRs,
    input [4:0] IDEXRegRt,
    input MEMWBRegWrite,
    input MEMWBMemRead,
    input EXMEMMemWrite,
    input [4:0] MEMWBRegRd,
    output reg [1:0] ForwardA,
    output reg [1:0] ForwardB,
    output reg ForwardC
);

initial
    begin
        ForwardA <= 2'b00; //初始均为IDEXRD1,无需Forward
        ForwardB <= 2'b00;
        ForwardC <= 1'b0;
    end

always @(*)
    begin
        //每次初始化
        ForwardA <= 2'b00;
        ForwardB <= 2'b00;
        ForwardC <= 1'b0;

        if(EXMEMRegWrite && (EXMEMRegRd != 5'b0) && (EXMEMRegRd != 5'b11111) && (EXMEMRegRd == IDEXRegRs))
            begin
            $display("ForwardA--EXMEM->EX");
            ForwardA <=  `EXMEMForward;
            end
        if(EXMEMRegWrite && (EXMEMRegRd != 5'b0) && (EXMEMRegRd != 5'b11111) && (EXMEMRegRd == IDEXRegRt))
            begin
            $display("ForwardB--EXMEM->EX");
            ForwardB <=  `EXMEMForward;
            end
        if(MEMWBRegWrite && (MEMWBRegRd!= 5'b0) && (MEMWBRegRd != 5'b11111) &&
        !(EXMEMRegWrite && (EXMEMRegRd != 5'b0) && (EXMEMRegRd != 5'b11111) && (EXMEMRegRd == IDEXRegRs)) &&
        (MEMWBRegRd == IDEXRegRs))
            begin
            $display("ForwardA--MEMWB->EX");
            ForwardA <= `MEMWBForward;
            end
        if(MEMWBRegWrite && (MEMWBRegRd!= 5'b0) && (MEMWBRegRd != 5'b11111) &&
        !(EXMEMRegWrite && (EXMEMRegRd != 5'b0) && (EXMEMRegRd != 5'b11111) && (EXMEMRegRd == IDEXRegRt)) &&
        (MEMWBRegRd == IDEXRegRt))
            begin
            $display("ForwardB--MEMWB->EX");
            ForwardB <= `MEMWBForward;
            end 
        //Store需要toMEM,与前面EX级forward分开考虑。
        if(MEMWBMemRead &&  EXMEMMemWrite && (MEMWBRegRd == EXMEMRegRd) && (MEMWBRegRd != 5'b0) && (MEMWBRegRd != 5'b11111))
            begin
            $display("ForwardC--MEMWB->MEM");
            ForwardC <= 1'b1;
            end
    end
endmodule