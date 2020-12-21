//`include "include/lagartoII_const.vh"
module Rfile (
//#(parameter ADDRW = 5)
	input clk_i, 
	input we_i,
	//input `RS1 addrs1, 
		input [4:0] addrs1, 
	//input `RS1 addrs2,
		input [4:0] addrs2,
	//input `RS1 addrd,
		input [4:0] addrd,	
	//input `WORD datard, 
		input [31:0] datard, 
	//output reg `WORD datars1, 
		output reg [31:0] datars1 = 32'b0, 
	//output reg `WORD datars2
		output reg [31:0] datars2 = 32'b0
); 
	//reg `WORD RegFile [2**`RS1_WIDTH -1:0];  //Registers file
		reg [31:0] RegFile [2**5-1:0];  //Registers file
	integer i; 
	initial begin 
		for(i=0; i<32; i=i+1) begin 
			//RegFile[i] = `WORD_ZERO;
				RegFile[i] = 32'h0;
		end
	end 
	//Puerto de escritura
	always @(posedge clk_i) 
	begin 
		if(we_i)
			RegFile[addrd] <= datard; 
	end 
	
	always @(*) 
	begin
		datars1 <= RegFile[addrs1];
		datars2 <= RegFile[addrs2];	
	end 
	
endmodule 

/*
module Rfile_tb #(parameter ADDRW = 5, parameter DATAW=32)(); 
	reg [ADDRW-1:0] rs1_tb; 
	reg [ADDRW-1:0] rd_tb;  
	reg [DATAW-1:0] datard_tb;  
	wire [DATAW-1:0] datars1_tb; 
	
	initial begin 
		rs1_tb = {ADDRW{1'b0}}; //ADDRW{1'b0} = ADDRW'b0; 
		rd_tb = {ADDRW{1'b0}};
		datard_tb = {DATAW{1'b0}}; 
	end 
	
	Rfile Rf_tb(rs1_tb, rd_tb, datard_tb, datars1_tb); 
	
	always begin 
		//-------3 ESCRITURAS-----------
		#100 
			rd_tb =   	5'b00101;  //t0
			datard_tb =	32'hAAAAAAAA; 
		#100
			rd_tb =   	5'b00110; //t1
			datard_tb =	32'hBBBBBBBB; 
		#100
			rd_tb =   	5'b00111; //t2
			datard_tb =	32'hCCCCCCCC;
		
		//---------LECTURAS-------------
		#100
			rs1_tb = 5'b00101; 
		#100
			rs1_tb = 5'b00110; 
		#100
			rs1_tb = 5'b00111; 	
	end 
endmodule 
*/	
