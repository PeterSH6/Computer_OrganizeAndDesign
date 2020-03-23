module alu(a,b,opcode,c,d);

output signed[31:0] c;
output signed[2:0] d;
input signed[31:0] a,b;
input [2:0] opcode;


reg[31:0] c;
reg[2:0] d;//d[0]:zero flag,d[1]:overflow flag, d[2]:negtive flag

reg[5:0] ii;//used for iterate;
reg cf;
reg[32:0] temp;//used for add
reg[31:0] multiplicand;
reg[64:0] mul_temp;//used for product


parameter  sla = 3'b000,
           sra = 3'b001,
           add = 3'b010,
           sub = 3'b011,
           mul = 3'b100,
           andd = 3'b101,
           ord = 3'b110,
           notd= 3'b111;

always@(a,b,opcode)//always中能被赋值的只能是register类型的
begin
    case(opcode)
    sla:
        begin
        c[0] = 1'b0;
        for(ii = 1; ii < 32 ; ii = ii+1)
            c[ii] = a[ii - 1];
        if(a[30:0] == 31'b0000_0000_0000_0000_0000_0000_0000_000)
            d[0] = 1'b1; //set zero flag
        else
            d[0] = 1'b0;
        if(a[31] == 1'b1)
            d[2] = 1'b1;
        else
            d[2] = 1'b0;
        d[1] = a[31]^c[31];
        end

    sra:
        begin
        c[31] = a[31];
        for(ii = 0 ; ii < 31 ; ii = ii+1)
            c[ii] = a[ii+1];
        if(a[31:1] == 31'b0000_0000_0000_0000_0000_0000_0000_000)
            d[0] = 1'b1; //set zero flag
        else
            d[0] = 1'b0;
        if(a[31] == 1'b1)
            d[2] = 1'b1;
        else
            d[2] = 1'b0;
        d[1] = 1'bz;//sra won't overflow
        end

    add:
        begin
        temp = 0;
        temp = a[31:0] + b[31:0];
        c = temp[31:0];
        cf = temp[32];
        d[1] = c[31]^a[31]^b[31]^cf;//set overflow flag
        if(c == 32'b0000_0000_0000_0000_0000_0000_0000_0000)
            d[0] = 1'b1; //set zero flag
        else
            d[0] = 1'b0;
        if(c[31] == 1'b1)
            d[2] = 1'b1;
        else
            d[2] = 1'b0;
        end
    
    sub:
        begin
        temp = 0;
        temp = a[31:0] - b[31:0];
        c = temp[31:0];
        d[1] = c[31]^a[31]^b[31];
        if(c == 32'b0000_0000_0000_0000_0000_0000_0000_0000)
            d[0] = 1'b1; //set zero flag
        else
            d[0] = 1'b0;
        if(c[31] == 1'b1)
            d[2] = 1'b1;
        else
            d[2] = 1'b0;
        end
        
    mul:
        begin
        multiplicand = (~a + 1'b1 > a) ? a : (~a + 1'b1);//convert to postive
        mul_temp = {33'd0,(~b + 1'b1 > b) ? b : (~b + 1'b1)};
        for(ii = 0 ; ii < 31 ; ii = ii+1)
            begin
            if(mul_temp[0])
                begin
                mul_temp[64:32] = mul_temp[64:32] + multiplicand;
                end
                mul_temp = mul_temp >> 1;
            end
        mul_temp = mul_temp >> 1;//only 31 interation so 1 more for signed bit
        mul_temp = (a[31] == b[31]) ? mul_temp[63:0] : (~mul_temp[63:0] + 1);
        c = mul_temp[31:0];
        if(c == 32'b0000_0000_0000_0000_0000_0000_0000_0000)
            d[0] = 1'b1; //set zero flag
        else
            d[0] = 1'b0;
        d[2] = a[31]^b[31];
        d[1] = (mul_temp[63:32] == 32'b0000_0000_0000_0000_0000_0000_0000_0000)  ? 0:1;
        //used up 32 bits to identify overflow
        end
    andd:
        begin
        c = a&b;
        if(c == 32'b0000_0000_0000_0000_0000_0000_0000_0000)
            d[0] = 1'b1; //set zero flag
        else
            d[0] = 1'b0;
        d[2] = 1'bz;
        d[1] = 1'bz;
        end
    ord:
        begin
        c = a&b;
        if(c == 32'b0000_0000_0000_0000_0000_0000_0000_0000)
            d[0] = 1'b1; //set zero flag
        else
            d[0] = 1'b0;
        d[2] = 1'bz;
        d[1] = 1'bz;
        end
    notd:
        begin
        c = ~a;
        if(c == 32'b0000_0000_0000_0000_0000_0000_0000_0000)
            d[0] = 1'b1; //set zero flag
        else
            d[0] = 1'b0;
        d[2] = 1'bz;
        d[1] = 1'bz;
        end
    endcase
end
endmodule