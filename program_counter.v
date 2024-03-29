
/*
// Module: Program_counter.v
// Description: Program counter verilog code //
// Owner : Mohamed Ayman
// Date :  July 2022
*/

module program_counter 
#(parameter data_size = 32)
(

    output  reg    [data_size-1:0]  PC_out,
    input   wire                    clk,reset,EN,
    input   wire   [data_size-1:0]  PC_in     
);

always @ ( posedge clk or negedge reset)
begin
    if ( ! reset )
        PC_out <= 32'd0;
    else if (! EN)
        PC_out <= PC_in;
end

endmodule