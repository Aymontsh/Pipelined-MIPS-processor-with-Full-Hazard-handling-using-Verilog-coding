
/*
// Module: Hazard unit.v
// Description: Hazard unit verilog code //
// Owner : Mohamed Ayman
// Date :  July 2022
*/

module Hazard_Unit

#(parameter datasize = 32)

(
    output   reg    [1:0]               Forward_AE,Forward_BE,
    output   wire                       Forward_AD,Forward_BD,Stall_F,Stall_D,Flush_E,Branch_D,Jump_D,
    input    wire   [4:0]               Rs_E,Rt_E,Rs_D,Rt_D,OUTmux2_A3,OUTmux3_A3,OUTmux4_A3,
    input    wire                       RegWrite_2,RegWrite_3,RegWrite_4,MemtoReg_2,MemtoReg_3

);

wire                       lwstall,branchstall;

assign lwstall = (( Rs_D == Rt_E ) | ( Rt_D == Rt_E )) & (MemtoReg_2) ;

assign Forward_AD = ( Rs_D != 0 ) & ( Rs_D == OUTmux3_A3 ) & ( RegWrite_3 );
assign Forward_BD = ( Rt_D != 0 ) & ( Rt_D == OUTmux3_A3 ) & ( RegWrite_3 );

assign branchstall = ( Branch_D & RegWrite_2 & (( OUTmux2_A3 == Rs_D ) | ( OUTmux2_A3 == Rt_D ) )) | ( Branch_D & MemtoReg_3 & (( OUTmux3_A3 == Rs_D ) | ( OUTmux3_A3 == Rt_D ) )); 

assign Stall_F = lwstall | branchstall;
assign Stall_D = lwstall | branchstall;
assign Flush_E = lwstall | branchstall | Jump_D;

always @ (*)
    begin
        if ( ( Rs_E != 0 ) & ( Rs_E == OUTmux3_A3 ) & (RegWrite_3) )
            Forward_AE = 2'b10;
        else if ( ( Rs_E != 0 ) & ( Rs_E == OUTmux4_A3 ) & (RegWrite_4) )
            Forward_AE = 2'b01;
        else
            Forward_AE = 2'b00;
    end

always @ (*)
    begin
        if ( ( Rt_E != 0 ) & ( Rt_E == OUTmux3_A3 ) & (RegWrite_3) )
            Forward_BE = 2'b10;
        else if ( ( Rt_E != 0 ) & ( Rt_E == OUTmux4_A3 ) & (RegWrite_4) )
            Forward_BE = 2'b01;
        else
            Forward_BE = 2'b00;
    end

endmodule 

