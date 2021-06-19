module signExtend(
	//input 		`WORD instruction_i, 
	input 		[31:0] instruction_i, 
	output reg 	[31:0] word_o
); 
	always @(*)
	begin 
		case(instruction_i[6:0])  
			7'b0000011: word_o <= $signed(instruction_i[31:20]); //I-type instruction
			7'b0010011: word_o <= $signed(instruction_i[31:20]); //I-type instruction
			7'b0100011: word_o <= $signed({instruction_i[31:25],instruction_i[11:7]}); //S-type instruction
			7'b1100011: word_o <= $signed({instruction_i[31], instruction_i[7], instruction_i[30:25], instruction_i[11:8], 1'b0}); //B-type Instruction
			7'b1100111: word_o <= $signed({instruction_i[31], instruction_i[19:12], instruction_i[20], instruction_i[30:21], 1'b0}); //J-type Instruction
			7'b1101111: word_o <= $signed({instruction_i[31], instruction_i[19:12], instruction_i[20], instruction_i[30:21], 1'b0}); //J-type Instruction
			default : 	word_o <= 32'b0; 
		endcase 
	end 

endmodule 