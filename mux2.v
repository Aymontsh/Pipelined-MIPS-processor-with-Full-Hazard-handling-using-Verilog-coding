
/*
// Module: mux2.v
// Description: MUX with two bits select size verilog code //
// Owner : Mohamed Ayman
// Date :  July 2022
*/

module mux2
#(parameter data_size = 32) 
(
    output reg    [data_size-1:0]     data_out,
    input  wire   [data_size-1:0]     data_in0,data_in1,data_in2,data_in3,
    input  wire   [1:0]               sel
);

always @(*)

    begin
        case(sel) 
            2'b00:   data_out = data_in0; 
            2'b01:   data_out = data_in1;
            2'b10:   data_out = data_in2;
            2'b11:   data_out = data_in3;
        endcase 
    end

endmodule


