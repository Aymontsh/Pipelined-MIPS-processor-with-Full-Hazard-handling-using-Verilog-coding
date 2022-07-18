
/*
// Module: Datapath.v
// Description: Datapath verilog code //
// Owner : Mohamed Ayman
// Date :  July 2022
*/

module Datapath

#(parameter datasize = 32)

(    
    output  wire    [4:0]              rs_e,rt_e,rs_d,rt_d,outmux2_A3,outmux3_A3,outmux4_A3,
    output  wire    [5:0]              opcode,funct,
    output  wire    [15:0]             testvalue,
    output  wire                       RegWrite2,RegWrite3,RegWrite4,MemtoReg2,MemtoReg3,
    input   wire                       clk,reset,StallF,StallD,FlushE,
    input   wire                       RegWrite,MemtoReg,MemWrite,ALUSrc,RegDst,Branch,Jump,
    input   wire    [2:0]              ALUcontrol,
    input   wire    [1:0]              ForwardAE,ForwardBE,
    input   wire                       ForwardAD,ForwardBD     
    
);

wire    [datasize-1:0]     RD1,RD2,RD1_2,RD2_2,SrcA2,SrcB2,WriteData2,RD_inst2,RD_inst;
wire    [datasize-1:0]     Pc,ALUout3,WriteData3;
wire    [datasize-1:0]     outmux_WD3;
wire    [datasize-1:0]     SignImm,shiftout_inst6,SignImm2,ALUout,ALUout4,RD_Data4;   
wire    [datasize-1:0]     PCBranch,PCPlus4,PCPlus4_1;
wire    [datasize-1:0]     currentpc,RD_instF,RD_Data,RD1_muxout,RD2_muxout;
wire                       MemWrite2,ALUSrc2,RegDst2,MemtoReg4;
wire                       MemWrite3,EqualD, CLR_D, B_E_and ;
wire    [27:0]             PCjump;
wire    [2:0]              ALUcontrol2;
wire    [1:0]              PCSrcD;

assign EqualD = ( RD1_muxout == RD2_muxout ) ? 1'b1:1'b0 ;
assign B_E_and = EqualD & Branch;
assign PCSrcD={ Jump , B_E_and };
assign CLR_D  = PCSrcD [0] | PCSrcD [1];
assign rs_e   = RD_inst2[25:21];
assign rt_e   = RD_inst2[20:16];
assign rs_d   = RD_inst[25:21];
assign rt_d   = RD_inst[20:16];
assign opcode = RD_inst[31:26];
assign funct  = RD_inst[5:0];

// Fetch stage 

program_counter Program_Counter (

    .PC_out (Pc),
    .clk (clk),
    .reset (reset),
    .EN (StallF),
    .PC_in (currentpc)
);


mux2 MUX2_inst1 (

    .data_out (currentpc),
    .data_in0 (PCPlus4),
    .data_in1 (PCBranch),
    .data_in2 ( { PCPlus4_1[31:28] , RD_inst[25:0] , 2'b00 } ),
    .data_in3 (32'd0),
    .sel (PCSrcD)

);


Instruction_memory instr_mem (

    .dout (RD_instF),
    .addr (Pc)
);


Adder Adder_inst1 (

    .C (PCPlus4),
    .A (Pc),
    .B (32'd4)
);

// Decode stage

Register_file Register_File (

    .readData1 (RD1), 
    .readData2 (RD2),
    .writeData (outmux_WD3),
    .readAddr1 (RD_inst[25:21]),
    .readAddr2 (RD_inst[20:16]),
    .writeAddr (outmux4_A3),
    .writeEnable (RegWrite4),
    .clk (clk),
    .reset (reset)

);

mux MUX_inst1 (

    .data_out (RD1_muxout),
    .data_in1 (RD1),
    .data_in2 (ALUout3),
    .sel (ForwardAD)

);

mux  MUX_inst2 (

    .data_out (RD2_muxout),
    .data_in1 (RD2),
    .data_in2 (ALUout3),
    .sel (ForwardBD)

);

Sign_Extend Sign_Extend (

    .SignImm (SignImm),
    .Instr (RD_inst[15:0])
);

shift_left_twice Shift_Left2 (

    .data_out (shiftout_inst6),
    .data_in  (SignImm)
);

Adder Adder_inst2 (

    .C (PCBranch),
    .A (shiftout_inst6),
    .B (PCPlus4_1)
);

pipeline_reg_fet_Dec Pipeline_register1 (

    .InstrD (RD_inst),
    .PCPlus4D (PCPlus4_1),
    .clk (clk),
    .reset(reset),
    .EN (StallD),
    .CLR (CLR_D),
    .InstrF(RD_instF),
    .PCPlus4F(PCPlus4)

);

// Execute stage 

mux #(.data_size(5)) MUX_inst3 (

    .data_out (outmux2_A3),
    .data_in1 (RD_inst2[20:16]),
    .data_in2 (RD_inst2[15:11]),
    .sel (RegDst2)
);

mux2 MUX2_inst2 (

    .data_out (SrcA2),
    .data_in0 (RD1_2),
    .data_in1 (outmux_WD3),
    .data_in2 (ALUout3),
    .data_in3 (32'd0),
    .sel (ForwardAE)
);

mux2 MUX2_inst3 (

    .data_out (WriteData2),
    .data_in0 (RD2_2),
    .data_in1 (outmux_WD3),
    .data_in2 (ALUout3),
    .data_in3 (32'd0),
    .sel (ForwardBE)
);

mux MUX_inst4 (

    .data_out (SrcB2),
    .data_in1 (WriteData2),
    .data_in2 (SignImm2),
    .sel (ALUSrc2)
);


ALU ALU (

    .ALUResult (ALUout),
    .SrcA (SrcA2),
    .SrcB (SrcB2),
    .ALUcontrol (ALUcontrol2)
);

pipeline_reg_Dec_Exe Pipeline_register2 (

    .RD1E (RD1_2),
    .RD2E (RD2_2),
    .SignImmE (SignImm2),
    .RtE (RD_inst2[20:16]),
    .RdE (RD_inst2[15:11]),
    .RsE (RD_inst2[25:21]),
    .RegWriteE (RegWrite2),
    .MemtoRegE (MemtoReg2),
    .MemWriteE (MemWrite2),
    .ALUSrcE (ALUSrc2),
    .RegDstE (RegDst2),
    .ALUControlE (ALUcontrol2),
    .clk (clk),
    .reset (reset),
    .CLR (FlushE),
    .RD1D (RD1),
    .RD2D (RD2),
    .SignImmD (SignImm),
    .RtD (RD_inst[20:16]),
    .RdD (RD_inst[15:11]),
    .RsD (RD_inst[25:21]),
    .RegWriteD (RegWrite),
    .MemtoRegD (MemtoReg),
    .MemWriteD (MemWrite),
    .ALUSrcD (ALUSrc),
    .RegDstD (RegDst),
    .ALUControlD (ALUcontrol)
);

// Memory Stage

 Data_memory data_mem (

    .RD (RD_Data),
    .test_value (testvalue),
    .clk (clk),
    .reset (reset),
    .WE (MemWrite3),
    .WD (WriteData3),
    .A (ALUout3)
);

pipeline_reg_Exe_Mem Pipeline_register3 (

    .ALUOutM (ALUout3),
    .WriteDataM (WriteData3),
    .WriteRegM (outmux3_A3),
    .RegWriteM (RegWrite3),
    .MemtoRegM (MemtoReg3),
    .MemWriteM (MemWrite3),
    .clk (clk),
    .reset (reset),
    .ALUOutE (ALUout),
    .WriteDataE (WriteData2),
    .WriteRegE (outmux2_A3),
    .RegWriteE (RegWrite2),
    .MemtoRegE (MemtoReg2),
    .MemWriteE (MemWrite2)
);

// Writeback stage 

mux MUX_inst5 (

    .data_out (outmux_WD3),
    .data_in1 (ALUout4),
    .data_in2 (RD_Data4),
    .sel (MemtoReg4)
);

pipeline_reg_Mem_WB Pipeline_register4 (

    .ALUOutW (ALUout4),
    .ReadDataW (RD_Data4),
    .WriteRegW (outmux4_A3),
    .RegWriteW (RegWrite4),
    .MemtoRegW (MemtoReg4),
    .clk (clk),
    .reset (reset),
    .ALUOutM (ALUout3),
    .ReadDataM (RD_Data),
    .WriteRegM (outmux3_A3),
    .RegWriteM (RegWrite3),
    .MemtoRegM (MemtoReg3)
);

endmodule 