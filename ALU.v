
/*
// Module: ALU.v
// Description: ALU verilog code //
// Owner : Mohamed Ayman
// Date :  July 2022
*/

module ALU 
#(parameter data_size = 32)
(
output  reg    [data_size-1:0]   ALUResult,
input   wire   [data_size-1:0]   SrcA,SrcB,
input   wire   [2:0]             ALUcontrol
);

always @ (*)
begin
    case (ALUcontrol)
        3'b000 : ALUResult = SrcA & SrcB;
        3'b001 : ALUResult = SrcA | SrcB; 
        3'b010 : ALUResult = SrcA + SrcB;        
        3'b100 : ALUResult = SrcA - SrcB; 
        3'b101 : ALUResult = SrcA * SrcB; 
        3'b110 : 
                begin
                    if (SrcA < SrcB)
                        ALUResult = 1;
                    else
                        ALUResult = 0;
                end
        default: ALUResult = SrcA + SrcB;  
    endcase 
end
endmodule