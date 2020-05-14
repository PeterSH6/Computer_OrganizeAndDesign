module IM(
    input [31:0]PC,
    output reg[31:0] Instruction
);
    reg[31:0] Instruction_Memory[255:0];  
    initial 
    begin
        //$readmemh("mipstestloopjal_sim.txt", Instruction_Memory);
        //$readmemh("mipstest_extloop.txt", Instruction_Memory);
        $readmemh("extendedtest.txt", Instruction_Memory);
    end
    always@(*)
    begin
        assign Instruction = Instruction_Memory[PC>>2];
    end
endmodule
   