`include "ctrl_encode_def.v"
module Branch_Jump_Detect(
    input [1:0] NPCType,
    input Zero,
    output reg [1:0] NextType
);

always@(*)
begin
    case(NPCType)
    `PCPlus4:
    begin
        $display("PC+4");
        NextType <= 2'b00; //选择PC+4 
    end
    `Branch:
    begin
        if(Zero == 1) //说明预测正确，继续PC+4
        begin
            $display("预测正确");
            NextType <= 2'b00;
        end
        else //预测错误，回到IDEXPC+4
        begin
            $display("预测错误");
            NextType <= 2'b01; //IDEXPC+4
        end
    end
    `Jump:
    begin
        $display("下一条Jump");
        NextType <= 2'b10; //JumpPC
    end
    endcase
end

endmodule