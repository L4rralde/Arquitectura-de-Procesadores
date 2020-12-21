//`include "include/lagartoII_const.vh"

module msinc(
	input 				 clk_i,  
	input 				 WE,  
	//input  [`INDEX_MSB-1:0] AddrR, 
		input  [12-1:0] AddrR, 
	//input  [`INDEX_MSB-1:0] AddrW, 
		input  [12-1:0] AddrW, 
	//input  `WORD DataW, 
		input  [31:0] DataW, 
	//output `WORD DataR
		output [31:0] DataR
); 
	//reg	`WORD memSync [2**`INDEX_MSB-1:0]; 
		reg	[31:0] memSync [2**12-1:0]; 
	
	initial begin  
		$readmemh ("bubblesorttext.hex", memSync); 
	end 
	//Puerto de escritura. 
	always @(posedge clk_i) begin 
		if(WE)
			memSync[AddrW] <= DataW; 
	end 
	
	assign DataR = memSync[AddrR]; 
endmodule 
