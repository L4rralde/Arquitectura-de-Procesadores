module Hazard(
	input [4:0] rs1_ifr_i,
	input [4:0] rs2_ifr_i, 
	input [4:0] rd_idr_i, 
	input MemRead_idr_i, 
	output reg stall_pc_o,
	output reg nop_o, 
	output reg [3:0] stall_r_o
); 
	always @(*) begin 
		if(((rd_idr_i==rs1_ifr_i)|(rd_idr_i==rs2_ifr_i))&(rd_idr_i!=0)&(MemRead_idr_i)) begin 
			nop_o 		<= 1'b1; 
			stall_pc_o 	<= 1'b1;
			stall_r_o 	<= 4'b0001;
		end else begin 
			nop_o 		<= 1'b0; 
			stall_pc_o 	<= 1'b0;
			stall_r_o 	<= 4'b0000;
		end 
	end 
endmodule 