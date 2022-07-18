
/*
// Module: pipeline_reg_Mem_WB.v
// Description: Pipeline register between Memory and Writeback stage verilog code //
// Owner : Mohamed Ayman
// Date :  July 2022
*/

module pipeline_reg_Mem_WB
#(parameter data_size = 32)
(

    output  reg    [data_size-1:0]  ALUOutW,ReadDataW,
    output  reg    [4:0]            WriteRegW,
    output  reg                     RegWriteW,MemtoRegW,
    input   wire                    clk,reset,
    input   wire   [data_size-1:0]  ALUOutM,ReadDataM,
    input   wire   [4:0]            WriteRegM,
    input   wire                    RegWriteM,MemtoRegM
);

always @ ( posedge clk or negedge reset)
    begin
        if ( ! reset )
            begin
                ALUOutW <= 32'd0;
                ReadDataW <= 32'd0;
                WriteRegW <= 5'd0;
                RegWriteW <= 1'b0;
                MemtoRegW <= 1'b0;          
            end
        else
            begin
                ALUOutW <= ALUOutM;
                ReadDataW <= ReadDataM;
                WriteRegW <= WriteRegM;
                RegWriteW <= RegWriteM;
                MemtoRegW <= MemtoRegM; 
            end
    end
endmodule