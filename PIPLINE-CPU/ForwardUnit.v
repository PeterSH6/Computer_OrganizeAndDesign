module ForwardUnit(
    input EXMEMRegWrite,
    //input [4:0] IDEXRegRd,
    input [4:0] EXMEMRegRd,
    input [4:0] IDEXMemRegRs,
    input [4:0] IDEXMemRegRt,
    input MEMWBRegWrite,
    input [4:0] MEMWBRegRd,
    output [1:0] ForwardA,
    output [1:0] ForwardB,
    output [1:0] ForwardC
)

always @(*)
    begin
        if()
    end