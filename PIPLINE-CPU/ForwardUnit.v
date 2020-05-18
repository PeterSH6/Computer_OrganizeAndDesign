module ForwardUnit(
    input EXMEMRegWrite,
    //input [4:0] IDEXRegRd,
    input [4:0] EXMEMRegRd,
    input [4:0] IDEXRegRs,
    input [4:0] IDEXRegRt,
    input MEMWBRegWrite,
    input [4:0] MEMWBRegRd,
    output [1:0] ForwardA,
    output [1:0] ForwardB
)

initial
    begin
        ForwardA <= 2'b00; //初始均为IDEXRD1,无需Forward
        ForwardB <= 2'b00;
    end

always @(*)
    begin
        if(EXMEMRegWrite && (EXMEMRegRd != 5'b0) && (EXMEMRegRd != 5'b11111) && (EXMEMRegRd == IDEXRegRs))
            begin
            $display("ForwardA--EXMEM->EX");
            ForwardA <=  `EXMEMForward;
            end
        else if(EXMEMRegWrite && (EXMEMRegRd != 5'b0) && (EXMEMRegRd != 5'b11111) && (EXMEMRegRd == IDEXRegRt))
            begin
            $display("ForwardB--EXMEM->EX");
            ForwardB <=  `EXMEMForward;
            end
        else if(MEMWBRegWrite && (MEMWBRegRd!= 5'b0) && (MEMWBRegRd != 5'b11111) &&
        !(EXMEMRegWrite && (EXMEMRegRd != 5'b0) && (EXMEMRegRd != 5'b11111) && (EXMEMRegRd == IDEXRegRs)) &&
        (MEMWBRegRd == IDEXRegRs))
            begin
            $display("ForwardA--MEMWB->EX");
            ForwardA <= `MEMWBForward;
            end
        else if(MEMWBRegWrite && (MEMWBRegRd!= 5'b0) && (MEMWBRegRd != 5'b11111) &&
        !(EXMEMRegWrite && (EXMEMRegRd != 5'b0) && (EXMEMRegRd != 5'b11111) && (EXMEMRegRd == IDEXRegRt)) &&
        (MEMWBRegRd == IDEXRegRt))
            begin
            $display("ForwardB--MEMWB->EX");
            ForwardB <= `MEMWBForward;
            end  
        else 
            $display("NoForward");
    end
endmodule