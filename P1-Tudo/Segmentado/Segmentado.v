/**
	Primer segmentado:
		Pipelined 1 Tudo o P1-Tudo
**/
module Segmentado(
	input clk_i,
	input rst_i, 
	output reg [31:0] wb_data_o
); 
	//------------Instruction fetch---------------
	//--------------------------------------------
	wire 	[31:0] 	PC_current; 
	reg 	[31:0] 	PC_next; 

	PCGen	PCGen_u0(
		.clk_i 	(clk_i), 
		.rst_i	(rst_i), 
		.PC_i 	(PC_next), 
		.PC_o		(PC_current) //To be registered in Fetch latches.
	); 
	wire [31:0] if_inst; 
	msinc MemInst_U0(
		.clk_i	(clk_i), 
		.WE		(1'b0), 
		.AddrR 	(PC_current[13:2]), 
		.AddrW 	(12'b0), 
		.DataW 	(32'b0), 
		.DataR 	(if_inst)	//To be registered in Fetch latches.
	); 
	
	reg [31:0] PC_branch =32'b0; 
	//wire [31:0] PC_branch
	wire PCSrc; 
	always @(*) begin 
		if(PCSrc)
			PC_next <= PC_branch; 
		else
			PC_next <= PC_current+4; 
	end
	
	reg [63:0] reg_fr; //{inst_fr, pc_fr};  
	always @(posedge clk_i)  //Fetch register
		reg_fr <= {if_inst, PC_current};  
	wire [31:0] pc_fr;
	wire [31:0] inst_fr; 
	assign pc_fr 	= reg_fr[31:0]; 
	assign inst_fr	= reg_fr[63:32]; 
	//---------End of instruction fetch---------
	//-----------------------------------------
	
	//-----------Instruction Decode-------------
	//------------------------------------------
	wire [31:0] rr_datars1; 
	wire [31:0] rr_datars2; 
	wire RegWrite_memr;	
	wire [31:0] inst_memr; 
	Rfile Registers_u0(
		.clk_i 	(clk_i), 
		.we_i		(RegWrite_memr), 
		.addrs1	(inst_fr[19:15]),
		.addrs2 	(inst_fr[24:20]), 
		.addrd	(inst_memr[11:7]), 
		.datard 	(wb_data_o), 
		.datars1 (rr_datars1), 
		.datars2 (rr_datars2)
	); 
	
	wire [31:0] se_data; 
	signExtend signExtender_U0(
		.instruction_i		(inst_fr), 
		.word_o				(se_data)
	);	
	
	wire Branch; 
	wire MemRead; 
	wire MemtoReg;
	wire RegWrite;	
	wire [3:0] ALUOp; 
	wire MemWrite; 
	wire ALUSrc; 
	ControlUnit Ctrl_U0(
		.Inst_i 				(inst_fr), 
		.ctrl_Branch_o		(Branch), 
		.ctrl_MemRead_o	(MemRead), 
		.ctrl_MemtoReg_o	(MemtoReg), 
		.ctrl_ALUOp_o		(ALUOp),
		.ctrl_MemWrite_o	(MemWrite), 
		.ctrl_ALUSrc_o 	(ALUSrc), 
		.ctrl_RegWrite_o	(RegWrite)
	); 
	
	reg [169:0] reg_idr; //{	Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, ...
								//... RegWrite, inst_fr, se_data, rr_datars1, rr_datars2, pc_fr}
	always @(posedge clk_i)
		reg_idr <= {Branch, 	MemRead, MemtoReg, ALUOp, 
						MemWrite, ALUSrc, RegWrite, inst_fr,
						se_data, rr_datars1, rr_datars2, pc_fr}; 
	wire Branch_idr; 
	wire MemRead_idr; 
	wire MemtoReg_idr; 
	wire [3:0] ALUOp_idr; 
	wire MemWrite_idr; 
	wire ALUSrc_idr; 
	wire RegWrite_idr; 
	wire [31:0] inst_idr; 
	wire [31:0] se_data_idr; 
	wire [31:0] datars1_idr; 
	wire [31:0] datars2_idr;
	wire [31:0] pc_idr; 
	assign Branch_idr 	= reg_idr[169]; 
	assign MemRead_idr 	= reg_idr[168];  
	assign MemtoReg_idr	= reg_idr[167]; 
	assign ALUOp_idr		= reg_idr[166:163]; 
	assign MemWrite_idr	= reg_idr[162]; 
	assign ALUSrc_idr		= reg_idr[161]; 
	assign RegWrite_idr	= reg_idr[160]; 
	assign inst_idr		= reg_idr[159:128]; 
	assign se_data_idr	= reg_idr[127:96];  
	assign datars1_idr 	= reg_idr[95:64]; 
	assign datars2_idr 	= reg_idr[63:32];
	assign pc_idr			= reg_idr[31:0]; 
	//-------End of instruction Decode----------
	//------------------------------------------
	

	//-----------------Execute------------------
	//------------------------------------------
	wire [31:0] ex_PC_branch;  
	HCA32b 	Adder_U2(
		.A		(pc_idr),
		.B 	(se_data_idr), 
		.cin	(1'b0),
		.S		(ex_PC_branch)
	); 
	
	//Muxes for forawarding 
	reg [31:0] datars2_forward; 
	reg [31:0] ALU_datars1;
	reg [1:0] ALUrs1_forward_flag = 2'b0; 
	reg [2:0] ALUrs2_forward_flag = 2'b0;	
	wire [31:0] alu_result_exr; 
	always @(*) begin 
		case(ALUrs1_forward_flag)
			2'b00:	ALU_datars1 <= datars1_idr; 
			2'b01: 	ALU_datars1 <= wb_data_o;
			2'b10: 	ALU_datars1 <= alu_result_exr;
			default: ALU_datars1 <= datars1_idr;
		endcase
	end
	always @(*) begin 
		case(ALUrs2_forward_flag)
			2'b00:	datars2_forward <= datars2_idr; 
			2'b01: 	datars2_forward <= wb_data_o;
			2'b10: 	datars2_forward <= alu_result_exr;
			default: datars2_forward <= datars2_idr;
		endcase
	end 	 	
	
	reg [31:0] ALU_datars2; 
	always @(*) begin 
		if(ALUSrc_idr)
			ALU_datars2 <= se_data_idr; 
		else
			ALU_datars2 <= datars2_forward; 
	end 
	
	wire [5:0] ctrl_alu; 
	ALUControl ALUC_U0(
		.ALUOp_i 			(ALUOp_idr),
		.Control_ALUOp_o	(ctrl_alu)
	); 
	
	wire [31:0] alu_result;
	wire ex_zero; 
	ALU	ALU_U0(
		.rr_datars1_i	(ALU_datars1),
		.rr_datars2_i	(ALU_datars2),  
		.ctrl_aluop_i 	(ctrl_alu), 
		.ex_data_o		(alu_result), 
		.ex_zeroflag_o (ex_zero)
	);
	//Modificar shift left 1 de PC branch. 
	reg [101:0] reg_exr; //{Branch_idr, MemRead_idr, MemtoReg_idr, MemWrite_idr, ...
								//... RegWrite_idr, ex_zero, alu_result, datars2_idr, inst_idr}
	always @(posedge clk_i) begin 
		reg_exr 		<= {	Branch_idr, MemRead_idr, MemtoReg_idr,
								MemWrite_idr, RegWrite_idr, ex_zero,
								alu_result, datars2_idr, inst_idr}; 		
		PC_branch 	<= ex_PC_branch;
	end
	wire Branch_exr; 
	wire MemRead_exr; 
	wire MemtoReg_exr; 
	wire MemWrite_exr; 
	wire RegWrite_exr; 
	wire zero_exr; 
	wire [31:0] datars2_exr;	
	wire [31:0] inst_exr; 
	assign Branch_exr 		= reg_exr[101]; 
	assign MemRead_exr 		= reg_exr[100]; 
	assign MemtoReg_exr		= reg_exr[99]; 	
	assign MemWrite_exr		= reg_exr[98]; 
	assign RegWrite_exr		= reg_exr[97]; 
	assign zero_exr			= reg_exr[96]; 
	assign alu_result_exr	= reg_exr[95:64]; 
	assign datars2_exr		= reg_exr[63:32];	
	assign inst_exr			= reg_exr[31:0]; 

	//--------------End of Execute--------------
	//------------------------------------------

	
	//---------------Memory access--------------
	//------------------------------------------
	wire [31:0] memData_dato; 
	msinc_Data MemData_U0(
		.clk_i 	(clk_i), 
		.WE 		(MemWrite_exr), 
		.RE		(MemRead_exr), 
		.Addr		(alu_result_exr[13:2]), 
		.DataW 	(datars2_exr), 
		.DataR	(memData_dato)
	); 
	
	assign PCSrc = Branch_exr&zero_exr; 
	
	reg [97:0] reg_memr; //{	MemtoReg_exr, RegWrite_exr, memData_dato, ...
								//...	alu_result_exr, inst_exr}
	always @(posedge clk_i) begin 
		reg_memr <=   {MemtoReg_exr, RegWrite_exr, memData_dato, 
							alu_result_exr, inst_exr};
	end 
	wire MemtoReg_memr;
	wire [31:0] memData_memr; 
	wire [31:0] alu_result_memr;
	assign MemtoReg_memr		= reg_memr[97];
	assign RegWrite_memr		= reg_memr[96];
	assign memData_memr		= reg_memr[95:64]; 
	assign alu_result_memr	= reg_memr[63:32];
	assign inst_memr			= reg_memr[31:0];
	
	//-----------End of memory access-----------
	//------------------------------------------
	
	
	//----------------Write Back---------------
	//-----------------------------------------
	always @(*) begin 
		if(MemtoReg_memr)
			wb_data_o <= memData_memr; 
		else 
			wb_data_o <= alu_result_memr; 
	end 
	//------------End of Write Back------------
	//------------------------------------------
	
endmodule	


module Segmentado_tb(); 	
	reg clk_tb; 
	reg rst_tb; 
	wire wb_data_o; 
	
	Segmentado s0_tb(clk_tb, rst_tb, wb_data_o); 
	initial begin 
		clk_tb <= 1'b0; 
		rst_tb <= 1'b1; 
	end 
	
	always begin 
		#50
		clk_tb <= ~clk_tb; 
	end 
endmodule 
