
/*
// Module: control_unit.v
// Description: Control unit verilog code //
// Owner : Mohamed Ayman
// Date :  July 2022
*/

module control_unit (
    output  wire             MemtoReg,MemWrite,ALUSrc,RegDst,RegWrite,Jump,Branch,
    output  wire    [2:0]    ALUControl,
    input   wire    [5:0]    Funct,
    input   wire    [5:0]    opcode
);



wire    [1:0]   Aluop;



Main_Decoder Inst1 (

    .MemtoReg (MemtoReg),
    .MemWrite (MemWrite),
    .Branch (Branch),
    .ALUSrc (ALUSrc),
    .RegDst (RegDst),
    .RegWrite (RegWrite),
    .Jump (Jump),
    .ALUOp (Aluop),
    .opcode (opcode)
);

ALU_Decoder Inst2 (

    .ALUOp (Aluop),
    .Funct (Funct),
    .ALUControl (ALUControl)
);


endmodule