`include "ctrl_encode_def.v"

module NPC(PC, Jump,Branch, IMM, NPC,PCPLUS4_o);  // next pc module
    
   input  [31:0] PC;        // pc
   input  Jump;
   input  Branch;
   input  [25:0] IMM;       // immediate
   output reg [31:0] NPC;   // next pc
   
   wire [31:0] PCPLUS4;
   reg [31:0] PCPLUS4_o;
   wire [1:0] NPCOp = {Jump,Branch}; //next pc operation
   assign PCPLUS4 = PC + 4; // pc + 4
   
   always @(*) begin
      case (NPCOp)
          `NPC_PLUS4:  NPC = PCPLUS4;
          `NPC_BRANCH: NPC = PCPLUS4 + {{14{IMM[15]}}, IMM[15:0], 2'b00};
          `NPC_JUMP:   NPC = {PCPLUS4[31:28], IMM[25:0], 2'b00};
          default:     NPC = PCPLUS4;
      endcase
   end // end always

   assign PCPLUS4_o = PCPLUS4;
   
endmodule
