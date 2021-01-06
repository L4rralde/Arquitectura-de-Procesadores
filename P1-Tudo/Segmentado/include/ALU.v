//`include "include/lagartoII_const.vh"
//Hae falta un overflow
module ALU(
	//input `WORD  rr_datars1_i,
		input [31:0]  rr_datars1_i,
	//input `WORD  rr_datars2_i,
		input [31:0]  rr_datars2_i,
	input [5:0]	 ctrl_aluop_i, 
	//output reg `WORD ex_data_o, 
		output reg [31:0] ex_data_o = 32'b0, 
	output reg		ex_zeroflag_o
); 
	/**control_aluop_i: 
	 bit 5: Not(zeroFlag)
	 bit 4 : Unsgined. lt{i}u
	 bit 3 : Negative. A+not(B)+1=A-B
	 bits [2:0] : Choose from arithmetic and logic operations
	**/
	
	//assign ex_zeroflag_o = (ex_data_o==`WORD_ZERO); 
	wire pre_ex_zero_flag_o;  	
	assign pre_ex_zeroflag_o = (ex_data_o==32'b0); 
	
	always @(*)
	begin 
		if(ctrl_aluop_i[5])
			ex_zeroflag_o = ~pre_ex_zeroflag_o; 
		else
			ex_zeroflag_o = pre_ex_zeroflag_o; 
	end 
	
	//wire `WORD  add_result_o;
		wire [31:0] add_result_o;
	//wire `WORD add_operand2_i; 
		reg [31:0] add_operand2_i;
	reg 	lt_set; 
	wire 	add_carry_o;  

	
	always @(*)
	begin 
		if(ctrl_aluop_i[3])
			add_operand2_i = ~rr_datars2_i; 
		else
			add_operand2_i = rr_datars2_i;
	end 
	
	HCA32b Adder_U0(
		.A 	(rr_datars1_i),
		.B		(add_operand2_i),
		.cin  (ctrl_aluop_i[3]),
		.S    (add_result_o),
		.cout (add_carry_o)
	); 
	
	always @(*)
	begin 
		if((rr_datars1_i[31]^rr_datars2_i[31])&ctrl_aluop_i[4])
			lt_set = ~add_result_o[31]; 
		else 
			lt_set = add_result_o[31]; 
	end 

	always @(*)
	begin 
		case (ctrl_aluop_i[2:0])
			3'h0: ex_data_o = add_result_o;
			3'h1: ex_data_o  = {31'b0,lt_set};
			3'h2: ex_data_o  = rr_datars1_i&rr_datars2_i;  
			3'h3: ex_data_o  = rr_datars1_i|rr_datars2_i;  
			3'h4: ex_data_o  = rr_datars1_i^rr_datars2_i;  
			3'h5: ex_data_o  = rr_datars1_i<<rr_datars2_i;  
			3'h6: ex_data_o  = rr_datars1_i>>rr_datars2_i;  
			3'h7: ex_data_o  = rr_datars1_i>>>rr_datars2_i;  
			default : ex_data_o = 32'b0; 
		endcase 
	end 


endmodule 

/**
module ALU_tb(); 
	reg [31:0]  rr_datars1_i_tb; 
	reg [31:0]  rr_datars2_i_tb; 
	reg [4:0]	ctrl_aluop_i_tb; 
	wire  [31:0] ex_data_o_tb;
	wire 			ex_zeroflag_o_tb; 

	ALU A0_tb(rr_datars1_i_tb, rr_datars2_i_tb, ctrl_aluop_i_tb, ex_data_o_tb, ex_zeroflag_o_tb); 
	initial 
	begin 
		rr_datars1_i_tb = 32'b0; 
		rr_datars2_i_tb = 32'b0;  
		ctrl_aluop_i_tb = 5'b0; 
	end
	
	always 
	begin 
		#50 
			rr_datars1_i_tb = 32'h0; 
			rr_datars2_i_tb = 32'h0;  
			ctrl_aluop_i_tb = 5'h0; 
		#50 
			rr_datars1_i_tb = 32'hFACE; 
			rr_datars2_i_tb = 32'h0EADBEEF;  
			ctrl_aluop_i_tb = 5'h0; 
		#50 
			rr_datars1_i_tb = 32'h0; 
			rr_datars2_i_tb = 32'h0;  
			ctrl_aluop_i_tb = 5'h8;
		#50 
			rr_datars1_i_tb = 32'hE11A; 
			rr_datars2_i_tb = 32'h4E110;  
			ctrl_aluop_i_tb = 5'h8;
		#50 
			rr_datars1_i_tb = 32'hDEADBEEF; 
			rr_datars2_i_tb = 32'hBABEFACE;  
			ctrl_aluop_i_tb = 5'h8;	
		#50 
			rr_datars1_i_tb = 32'h0; 
			rr_datars2_i_tb = 32'h0;  
			ctrl_aluop_i_tb = 5'h9; 
		#50 
			rr_datars1_i_tb = 32'hE11A; 
			rr_datars2_i_tb = 32'h4E110;  
			ctrl_aluop_i_tb = 5'h9;
		#50 
			rr_datars1_i_tb = 32'hDEADBEEF; 
			rr_datars2_i_tb = 32'hBABEFACE;  
			ctrl_aluop_i_tb = 5'h9;		
		#50 
			rr_datars1_i_tb = 32'hF0000000; 
			rr_datars2_i_tb = 32'h00000000;  
			ctrl_aluop_i_tb = 5'h9;		
		#50 
			rr_datars1_i_tb = 32'h00000000; 
			rr_datars2_i_tb = 32'hF0000000;  
			ctrl_aluop_i_tb = 5'h9;		
		#50 
			rr_datars1_i_tb = 32'hF0000000; 
			rr_datars2_i_tb = 32'hFFFFFFFF;  
			ctrl_aluop_i_tb = 5'h9;		
		#50 
			rr_datars1_i_tb = 32'hFFFFFFFF; 
			rr_datars2_i_tb = 32'hFFFFFFFF;  
			ctrl_aluop_i_tb = 5'h9;		
		#50 
			rr_datars1_i_tb = 32'hFFFFFFFF; 
			rr_datars2_i_tb = 32'h00000000;  
			ctrl_aluop_i_tb = 5'h9;		
		#50 
			rr_datars1_i_tb = 32'h0; 
			rr_datars2_i_tb = 32'h0;  
			ctrl_aluop_i_tb = 5'h19; 
		#50 
			rr_datars1_i_tb = 32'hE11A; 
			rr_datars2_i_tb = 32'h4E110;  
			ctrl_aluop_i_tb = 5'h19;
		#50 
			rr_datars1_i_tb = 32'hDEADBEEF; 
			rr_datars2_i_tb = 32'hBABEFACE;  
			ctrl_aluop_i_tb = 5'h19;		
		#50 
			rr_datars1_i_tb = 32'hF0000000; 
			rr_datars2_i_tb = 32'h00000000;  
			ctrl_aluop_i_tb = 5'h19;		
		#50 
			rr_datars1_i_tb = 32'h00000000; 
			rr_datars2_i_tb = 32'hF0000000;  
			ctrl_aluop_i_tb = 5'h19;		
		#50 
			rr_datars1_i_tb = 32'hF0000000; 
			rr_datars2_i_tb = 32'hFFFFFFFF;  
			ctrl_aluop_i_tb = 5'h19;		
		#50 
			rr_datars1_i_tb = 32'hFFFFFFFF; 
			rr_datars2_i_tb = 32'hFFFFFFFF;  
			ctrl_aluop_i_tb = 5'h19;		
		#50 
			rr_datars1_i_tb = 32'hFFFFFFFF; 
			rr_datars2_i_tb = 32'h00000000;  
			ctrl_aluop_i_tb = 5'h19;
	end 
endmodule 
**/
