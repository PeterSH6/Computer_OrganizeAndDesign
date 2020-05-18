module Hazard_Detect(
    input [1:0] Nexttype,//从EX级中的Branch检测单元检测出是否预测正确或者是否为Jump
    input IDEXMEMRead;
    input [4:0] IDEXRt; //load stall
    input [4:0] IFIDRs;
    input [4:0] IFIDRt;
    output reg IFIDStall;
    output reg [1:0] PCSrc; //第一个MUX,用于
)