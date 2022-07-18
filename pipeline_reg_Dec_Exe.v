
/*
// Module: pipeline_reg_Dec_Exe.v
// Description: Pipeline register between Decode and Execute stage verilog code //
// Owner : Mohamed Ayman
// Date :  July 2022
*/

module pipeline_reg_Dec_Exe 
#(parameter data_size = 32)
(

    output  reg    [data_size-1:0]  RD1E,RD2E,SignImmE,
    output  reg    [4:0]            RtE,RdE,RsE,
    output  reg                     RegWriteE,MemtoRegE,MemWriteE,ALUSrcE,RegDstE,
    output  reg    [2:0]            ALUControlE,
    input   wire                    clk,reset,CLR,
    input   wire   [data_size-1:0]  RD1D,RD2D,SignImmD,
    input   wire   [4:0]            RtD, RdD, RsD,
    input   wire                    RegWriteD,MemtoRegD,MemWriteD,ALUSrcD,RegDstD,
    input   wire   [2:0]            ALUControlD    
);

always @ ( posedge clk or negedge reset)
    begin
        if ( ! reset )
            begin
                RD1E <= 32'd0;
                RD2E <= 32'd0;
                RsE <= 32'd0;
                RtE <= 5'd0;
                RdE <= 5'd0;
                SignImmE <= 32'd0;
                RegWriteE <= 1'b0;
                MemtoRegE <= 1'b0;
                MemWriteE <= 1'b0;
                ALUSrcE <= 1'b0;
                RegDstE <= 1'b0;
                ALUControlE <= 3'd0;            
            end
        else if ( CLR )
            begin
                RD1E <= 32'd0;
                RD2E <= 32'd0;
                RsE <= 32'd0;
                RtE <= 5'd0;
                RdE <= 5'd0;
                SignImmE <= 32'd0;
                RegWriteE <= 1'b0;
                MemtoRegE <= 1'b0;
                MemWriteE <= 1'b0;
                ALUSrcE <= 1'b0;
                RegDstE <= 1'b0;
                ALUControlE <= 3'd0;                
            end
        else
            begin
                RD1E <= RD1D;
                RD2E <= RD2D;
                RsE <= RsD;
                RtE <= RtD;
                RdE <= RdD;
                SignImmE <= SignImmD;
                RegWriteE <= RegWriteD;
                MemtoRegE <= MemtoRegD;
                MemWriteE <= MemWriteD;
                ALUSrcE <= ALUSrcD;
                RegDstE <= RegDstD;
                ALUControlE <= ALUControlD;
            end
    end
endmodule