
/*
// Module: topmodule.v
// Description: Top Module verilog code //
// Owner : Mohamed Ayman
// Date :  July 2022
*/

module topmodule

#(parameter datasize = 32)
(
    output      wire      [15:0]    testvalue,
    input       wire                clk,reset
);

wire                       Mem_to_Reg,Mem_Write,Reg_Write,ALU_Src,Reg_Dst,branch,jump;
wire    [4:0]              RS_e,RT_e,RS_d,RT_d,outmux2 ,outmux3 ,outmux4;
wire    [5:0]              OP_code,Funct;
wire                       Reg_Write2,Reg_Write3,Reg_Write4,Mem_to_Reg2,Mem_to_Reg3;
wire                       stall_f,stall_d,flush_e;
wire    [2:0]              ALU_control;
wire    [1:0]              forward_AE,forward_BE;
wire                       forward_AD,forward_BD;


Datapath data_path (

    .rs_e (RS_e),
    .rt_e (RT_e),
    .rs_d (RS_d),
    .rt_d (RT_d),
    .outmux2_A3 (outmux2),
    .outmux3_A3 (outmux3),
    .outmux4_A3 (outmux4),
    .opcode (OP_code),
    .funct (Funct),
    .testvalue (testvalue),
    .RegWrite2 (Reg_Write2),
    .RegWrite3 (Reg_Write3),
    .RegWrite4 (Reg_Write4),
    .MemtoReg2 (Mem_to_Reg2),
    .MemtoReg3 (Mem_to_Reg3),
    .clk (clk),
    .reset (reset),
    .StallF (stall_f),
    .StallD (stall_d),
    .FlushE (flush_e),
    .RegWrite (Reg_Write),
    .MemtoReg (Mem_to_Reg),
    .MemWrite (Mem_Write),
    .ALUSrc (ALU_Src),
    .RegDst (Reg_Dst),
    .Branch (branch),
    .Jump (jump),
    .ALUcontrol (ALU_control),
    .ForwardAE (forward_AE),
    .ForwardBE (forward_BE),
    .ForwardAD (forward_AD),
    .ForwardBD (forward_BD)
);

control_unit controlunit (

    .MemtoReg (Mem_to_Reg),
    .MemWrite (Mem_Write),
    .ALUSrc (ALU_Src),
    .RegDst (Reg_Dst),    
    .RegWrite (Reg_Write),
    .Jump (jump),
    .Branch (branch),
    .ALUControl (ALU_control),
    .Funct (Funct),
    .opcode (OP_code)

);


Hazard_Unit hazard_unit (

    .Forward_AE (forward_AE),
    .Forward_BE (forward_BE),
    .Forward_AD (forward_AD),
    .Forward_BD (forward_BD),
    .Stall_F (stall_f),
    .Stall_D (stall_d),
    .Flush_E (flush_e),
    .Branch_D (branch),
    .Jump_D (jump),
    .Rs_E (RS_e),
    .Rt_E (RT_e),
    .Rs_D (RS_d),
    .Rt_D (RT_d),
    .OUTmux2_A3 (outmux2),
    .OUTmux3_A3 (outmux3),
    .OUTmux4_A3 (outmux4),
    .RegWrite_2 (Reg_Write2),
    .RegWrite_3 (Reg_Write3),
    .RegWrite_4 (Reg_Write4), 
    .MemtoReg_2 (Mem_to_Reg2),
    .MemtoReg_3 (Mem_to_Reg3)

);

endmodule 