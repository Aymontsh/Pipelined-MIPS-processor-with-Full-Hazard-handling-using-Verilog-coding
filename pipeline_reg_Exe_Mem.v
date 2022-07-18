
/*
// Module: pipeline_reg_Exe_Mem.v
// Description: Pipeline register between Execute and Memory stage verilog code //
// Owner : Mohamed Ayman
// Date :  July 2022
*/

module pipeline_reg_Exe_Mem 
#(parameter data_size = 32)
(

    output  reg    [data_size-1:0]  ALUOutM,WriteDataM,
    output  reg    [4:0]            WriteRegM,
    output  reg                     RegWriteM,MemtoRegM,MemWriteM,
    input   wire                    clk,reset,
    input   wire   [data_size-1:0]  ALUOutE,WriteDataE,
    input   wire   [4:0]            WriteRegE,
    input   wire                    RegWriteE,MemtoRegE,MemWriteE
);

always @ ( posedge clk or negedge reset)
    begin
        if ( ! reset )
            begin
                ALUOutM <= 32'd0;
                WriteDataM <= 32'd0;
                WriteRegM <= 5'd0;
                RegWriteM <= 1'b0;
                MemtoRegM <= 1'b0;
                MemWriteM <= 1'b0;       
            end
        else
            begin
                ALUOutM <= ALUOutE;
                WriteDataM <= WriteDataE;
                WriteRegM <= WriteRegE;
                RegWriteM <= RegWriteE;
                MemtoRegM <= MemtoRegE;
                MemWriteM <= MemWriteE;
            end
    end
endmodule