//`include "include/lagartoII_const.vh"
module PCGen(
	input clk_i, 
	input rst_i, 
	input [31:0] PC_i,
	//output reg `WORD PC_o
		output reg [31:0] PC_o = 32'b0 
); 

	always @(posedge clk_i, negedge rst_i) begin 
		if(!rst_i) 
			//PC_o <= `WORD_ZERO; 
				PC_o <= 32'b0; 
		else 
				PC_o <= PC_i; 
	end 
endmodule
