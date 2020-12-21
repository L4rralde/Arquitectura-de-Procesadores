module RAM #(
	parameter ADDRW = 6, 
	parameter DATAW = 32)(
	
	input 	clk,
	input 	WE,
	input 	[ADDRW-1:0] adr,
	input 	[DATAW-1:0] din,	
	output	[DATAW-1:0] dout
); 

reg [DATAW-1:0] RAM[2**ADDRW-1:0];

	always @(posedge clk)
	begin 
		if(WE)
			RAM[adr] <= din; 
	end 
	
	assign dout =  RAM[adr]; 

endmodule 
