
module EXT16( Imm16,EXTOp,Imm32 );
    
   input  [15:0] Imm16;
   input         EXTOp;
   output [31:0] Imm32;
   
   assign Imm32 = (EXTOp) ? {{16{Imm16[15]}}, Imm16} : {16'd0, Imm16}; // signed-extension or zero extension
       
endmodule

module EXT8( Imm8,EXTOp,Imm32 );
    
   input  [7:0]  Imm8;
   input         EXTOp;
   output [31:0] Imm32;
   
   assign Imm32 = (EXTOp) ? {{24{Imm8[7]}}, Imm8} : {24'd0, Imm8}; // signed-extension or zero extension
       
endmodule
