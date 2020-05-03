module IM(
    input [31:0]PC,
    output reg[31:0] Instruction
);
    reg[31:0] Instruction_Memory[255:0];
    //integer i,count,fp,regist;   
    initial 
    begin
        $readmemh("mipstestloopjal_sim.txt", Instruction_Memory);
    end
    always@(*)
    begin
        assign Instruction = Instruction_Memory[PC>>2];
    end
endmodule
   /* 
    initial
        begin
        for(i = 0 ; i < 256 ; i++)
            Instruction_Memory[i] = 0
        fp = $fopen("test.txt","r");//fp文件指针指向文件开头
        i = 32'h0000_0000;
        while(!$feof(fp))
            begin
            count = $fscanf(fp,"%h",regist);
            if(count == 1)
                begin
                Instruction_Memory[i] = regist;
                i = i + 1;
                end
            end
        $fclose(fp);*/