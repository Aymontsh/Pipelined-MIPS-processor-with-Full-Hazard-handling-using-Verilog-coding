
/*
// Module: pipeline_reg_fet_Dec.v
// Description: Pipeline register between Fetch and Decode stage verilog code //
// Owner : Mohamed Ayman
// Date :  July 2022
*/

module pipeline_reg_fet_Dec 
#(parameter data_size = 32)
(

    output  reg    [data_size-1:0]  InstrD,PCPlus4D,
    input   wire                    clk,reset,EN,CLR,
    input   wire   [data_size-1:0]  InstrF, PCPlus4F     
);

always @ ( posedge clk or negedge reset)

    begin
        if ( ! reset )
            begin
                PCPlus4D <= 32'd0;
                InstrD <= 32'd0;
            end
        else if ( CLR && !EN )
            begin
                PCPlus4D <= 32'd0;
                InstrD <= 32'd0;
            end
        else if (!EN)
            begin
               PCPlus4D <= PCPlus4F;
               InstrD <= InstrF;
            end    
    end

endmodule