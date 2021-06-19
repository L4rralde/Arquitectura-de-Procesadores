module ControlUnit(
	input	 [31:0]	Inst_i,
	input  nop_i, 
	output ctrl_Branch_o,  
	output ctrl_MemRead_o, 
	output ctrl_MemtoReg_o, 
	output reg [3:0] ctrl_ALUOp_o, 
	output ctrl_MemWrite_o, 
	output ctrl_ALUSrc_o, 
	output ctrl_RegWrite_o
); 
	wire [6:0] opcode;
	wire [2:0] funct3; 
	wire [6:0] funct7; 
	
	assign opcode = Inst_i[6:0]; 
	assign funct3 = Inst_i[14:12]; 
	assign funct7 = Inst_i[31:25]; 
	
	assign ctrl_Branch_o 	= opcode[6]&(~nop_i); 
	assign ctrl_MemRead_o 	= (~(|{opcode[6:4], opcode[2]}))&(~nop_i); 
	assign ctrl_MemtoReg_o 	= ctrl_MemRead_o; 
	assign ctrl_MemWrite_o	= ({opcode[6:4], opcode[2]}==4'b0100)&(~nop_i);
	assign ctrl_ALUSrc_o 	= (~opcode[6])&(opcode[5]^opcode[4])&(~nop_i); 
	assign ctrl_RegWrite_o 	= ((~opcode[5])|opcode[4]|opcode[2])&(~nop_i); 
	
	wire [3:0] ALUOp_B; 
	wire [3:0] ALUOp_I; 
	wire [3:0] ALUOp_R;
	
	ROM_B ROM_U0(
		.Addr_i	(funct3), 
		.DataR_o	(ALUOp_B)
	);
	ROM_I ROM_U1(
		.Addr_i	({funct7[5],funct3}), 
		.DataR_o	(ALUOp_I)
	); 	
	ROM_R ROM_U2(
		.Addr_i	({funct7[5],funct3}), 
		.DataR_o	(ALUOp_R)
	); 
	always @(*)
		if(nop_i)
			ctrl_ALUOp_o <= 4'b0000;
		else
			case({opcode[6:4], opcode[2]})  
				4'b1100: ctrl_ALUOp_o <= ALUOp_B; 	//Branches
				4'b0000: ctrl_ALUOp_o <= 4'b0000; 	//Load
				4'b0100: ctrl_ALUOp_o <= 4'b0000;	//Store
				4'b0010: ctrl_ALUOp_o <= ALUOp_I; 	//Inmediates
				4'b0110: ctrl_ALUOp_o <= ALUOp_R; 	//Register
																//ALUOp_R can be used for both 0010 and 0110 cases. 
				default: ctrl_ALUOp_o <= 4'b1111; 
			endcase   
endmodule 

module ROM_B(
	input 		[2:0] Addr_i,  
	output reg	[3:0] DataR_o
); 
	reg [3:0] ROM [2:0]; 	
	always @(*)
		DataR_o <= ROM[Addr_i]; 
	initial 
		$readmemh("ROMB_Control.hex", ROM); 
endmodule 

module ROM_I(
	input 		[3:0] Addr_i,  
	output reg	[3:0] DataR_o
); 
	reg [3:0] ROM [3:0]; 	
	always @(*)
		DataR_o <= ROM[Addr_i]; 
	initial 
		$readmemh("ROMI_Control.hex", ROM); 
endmodule 

module ROM_R(
	input 		[3:0] Addr_i,  
	output reg	[3:0] DataR_o
); 
	reg [3:0] ROM [3:0]; 	
	always @(*)
		DataR_o <= ROM[Addr_i]; 
	initial 
		$readmemh("ROMR_Control.hex", ROM); 
endmodule 

/**
	All instructions capable of:
		beq
		bne 
		blt 
		bge
		bltu
		bgeu
		lw
		sw
		addi
		slti
		sltiu
		xori
		ori
		andi 
		slli
		srli
		srai
		add
		sub 
		sll
		slt
		sltu
		xor
		srl
		sra
		or
		and 
**/