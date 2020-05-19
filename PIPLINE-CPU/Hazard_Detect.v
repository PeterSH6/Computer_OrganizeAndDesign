`include "ctrl_encode_def.v"
module Hazard_Detect(
    input [1:0] Nexttype,//从EX级中的Branch检测单元检测出是否预测正确或者是否为Jump
    input IDEXMEMRead,
    input [4:0] IDEXRt, //load stall
    input [4:0] IFIDRs,
    input [4:0] IFIDRt,
    output reg IFIDStall,
    output reg IFIDFlush,
    output reg [1:0] PCSrc, //第一个MUX,用于选择PC+4，Jump，IDEXPC+4
    output reg PCWrite,
    output reg IDEXFlush
);

initial
begin
    IFIDStall <= 1'b0;
    IFIDFlush <= 1'b0;
    PCSrc <= 2'b00; //PC+4
    PCWrite <= 1'b1; //刚开始时必须为1
    IDEXFlush <= 1'b0;
end

always @(*)
    begin
        if(IDEXMEMRead && ((IDEXRt == IFIDRs) || (IDEXRt == IFIDRt))) //load hazard
            begin
                PCWrite <= 1'b0; //stall
                IFIDStall <= 1'b1;
                IDEXFlush <= 1'b1;
                $display("A Load Hazard Occur");
            end
        else
            begin
                case(Nexttype)
                    `PCPlus4:
                    begin
                        PCWrite <= 1'b1;
                        PCSrc <= 2'b00;  //PC+4
                        IFIDStall <= 1'b0;
                        IFIDFlush <= 1'b0;
                        IDEXFlush <= 1'b0;
                        $display("NexPC is PC+4");
                    end
                    `Branch:
                    begin
                        PCWrite <= 1'b1;
                        PCSrc <= 2'b00;  //此处选择PC+4，因为预测正确，且发生，所以继续执行
                        IFIDStall <= 1'b0;
                        IFIDFlush <= 1'b0;
                        IDEXFlush <= 1'b1;
                        $display("Predict right PC+4");
                    end
                    `BranchWrong:
                    begin
                        PCWrite <= 1'b1;
                        PCSrc <= 2'b10;  //预测错误，修改为IDEXPC,即Branch后一条指令
                        IFIDStall <= 1'b0;
                        IFIDFlush <= 1'b1;
                        IDEXFlush <= 1'b1;//Branch在EX级，预测错误意味着IFID要Flush
                        $display("Predict wrong,go back to IDEXPC");
                    end
                    `Jump:
                    begin
                        PCWrite <= 1'b1;
                        PCSrc <= 2'b01;  //JumpPC
                        IFIDStall <= 1'b0;
                        IFIDFlush <= 1'b1;
                        IDEXFlush <= 1'b1;
                        $display("Next PC is Jumps");
                    end
                endcase
            end
    end
endmodule