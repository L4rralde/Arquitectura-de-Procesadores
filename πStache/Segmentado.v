/**
	Primer segmentado:
		Pipelined 1 Tudo o P1-Tudo
	Branch predictor not included yet 
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
	wire 	stall_pc; 
	PCGen	PCGen_u0(
		.clk_i 	(clk_i), 
		.rst_i	(rst_i), 
		.stall_i (stall_pc),
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
	
	wire stall_fr; 
	reg [63:0] reg_fr = 64'h1300000000; //{inst_fr, pc_fr};  
	always @(negedge clk_i)  //Fetch register
		if(!stall_fr)
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
	wire nop; 
	ControlUnit Ctrl_U0(
		.Inst_i 				(inst_fr),
		.nop_i				(nop), 
		.ctrl_Branch_o		(Branch), 
		.ctrl_MemRead_o	(MemRead), 
		.ctrl_MemtoReg_o	(MemtoReg), 
		.ctrl_ALUOp_o		(ALUOp),
		.ctrl_MemWrite_o	(MemWrite), 
		.ctrl_ALUSrc_o 	(ALUSrc), 
		.ctrl_RegWrite_o	(RegWrite)
	); 
	
	wire [31:0] inst_idr; 
	wire stall_idr; 
	wire MemRead_idr; 
	wire stall_exr;
	wire stall_memr; 	
	Hazard Haz_U0(
		.rs1_ifr_i		(inst_fr[19:15]), 
		.rs2_ifr_i		(inst_fr[24:20]), 
		.rd_idr_i 		(inst_idr[11:7]), 
		.MemRead_idr_i	(MemRead_idr), 
		.stall_pc_o		(stall_pc),
		.nop_o			(nop), 
		.stall_r_o		({stall_memr,stall_exr,stall_idr,stall_fr})  //[3:0]
	); 

	reg [169:0] reg_idr; 	//{	Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, ...
									//... RegWrite, inst_fr, se_data, rr_datars1, rr_datars2, pc_fr}
	always @(negedge clk_i)
		if(!stall_idr)
			reg_idr <= {Branch, 	MemRead, MemtoReg, ALUOp, 
							MemWrite, ALUSrc, RegWrite, inst_fr,
							se_data, rr_datars1, rr_datars2, pc_fr}; 
			//------------ID/EX pipeline register execution-------
	wire Branch_idr; 
	wire MemtoReg_idr; 
	wire [3:0] ALUOp_idr; 
	wire MemWrite_idr; 
	wire ALUSrc_idr; 
	wire RegWrite_idr; 
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
	
	//forawarding 
	reg [31:0] datars2_forward; 
	reg [31:0] ALU_datars1;
	wire [1:0] ALUrs1_forward;
	wire [1:0] ALUrs2_forward;
	wire [31:0] alu_result_exr; 
	wire [31:0] inst_exr; 
	wire RegWrite_exr;
	
	Forwarding FORD_U0(
		.rs1_idr			(inst_idr[19:15]),
		.rs2_idr			(inst_idr[24:20]), 
		.rd_exr			(inst_exr[11:7]),
		.rd_memr			(inst_memr[11:7]), 
		.RegWrite_exr	(RegWrite_exr), 
		.RegWrite_memr	(RegWrite_memr), 
		.ALU_src1_sel	(ALUrs1_forward),
		.ALU_src2_sel	(ALUrs2_forward)
	); 
	
	reg [31:0] ALU_datars1_1; 
	reg [31:0] ALU_datars1_2;
	//------------Fordwarded data Mux for ALU's data 1-------
	always @(*) begin 
		case(ALUrs1_forward[0])
			1'b0:	ALU_datars1_1 <= datars1_idr; 
			1'b1: ALU_datars1_1 <= alu_result_exr; 
		endcase
	end 
	always @(*) begin 
		case(ALUrs1_forward[0])
			1'b0:	ALU_datars1_2 <= wb_data_o; 
			1'b1: ALU_datars1_2 <= datars1_idr; 
		endcase
	end 
	always @(*) begin 
		case(ALUrs1_forward[1])
			1'b0:	ALU_datars1 <= ALU_datars1_1; 
			1'b1: ALU_datars1 <= ALU_datars1_2; 
		endcase
	end
	/**
	always @(*) begin 
		case(ALUrs1_forward)
			2'b00:	ALU_datars1 <= datars1_idr; 
			2'b01: 	ALU_datars1 <= alu_result_exr; 
			2'b10: 	ALU_datars1 <= wb_data_o;
			2'b11: 	ALU_datars1 <= datars1_idr;
		endcase
	end
	**/
	
	reg [31:0] ALU_datars2_1; 
	reg [31:0] ALU_datars2_2;
	//------------Fordwarded data Mux for ALU's data 1-------
	always @(*) begin 
		case(ALUrs2_forward[0])
			1'b0:	ALU_datars2_1 <= datars2_idr; 
			1'b1: ALU_datars2_1 <= alu_result_exr; 
		endcase
	end 
	always @(*) begin 
		case(ALUrs2_forward[0])
			1'b0:	ALU_datars2_2 <= wb_data_o; 
			1'b1: ALU_datars2_2 <= datars2_idr; 
		endcase
	end 
	always @(*) begin 
		case(ALUrs2_forward[1])
			1'b0:	datars2_forward <= ALU_datars2_1; 
			1'b1: datars2_forward <= ALU_datars2_2; 
		endcase
	end
	/**
	always @(*) begin 
		case(ALUrs2_forward)
			2'b00:	datars2_forward <= datars2_idr; 
			2'b01: 	datars2_forward <= alu_result_exr;
			2'b10: 	datars2_forward <= wb_data_o;
			2'b11: 	datars2_forward <= datars2_idr;
		endcase
	end
	**/	
	
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
	
			//------------EX/MEM pipeline register execution-------
	reg [101:0] reg_exr; //{Branch_idr, MemRead_idr, MemtoReg_idr, MemWrite_idr, ...
								//... RegWrite_idr, ex_zero, alu_result, datars2_idr, inst_idr}
	always @(negedge clk_i) begin
		if(!stall_exr) begin 
			reg_exr 		<= {	Branch_idr, MemRead_idr, MemtoReg_idr,
									MemWrite_idr, RegWrite_idr, ex_zero,
									alu_result, datars2_idr, inst_idr}; 		
			PC_branch 	<= ex_PC_branch;
		end 
	end
	wire Branch_exr; 
	wire MemRead_exr; 
	wire MemtoReg_exr; 
	wire MemWrite_exr; 
	wire zero_exr; 
	wire [31:0] datars2_exr;	
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
	
	//------------MEM/WB pipeline register execution------- 
	reg [97:0] reg_memr; 	//{	MemtoReg_exr, RegWrite_exr, memData_dato, ...
											//...	alu_result_exr, inst_exr}
	always @(negedge clk_i) begin 
		if(!stall_memr)
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

/**
		P1-Tudo main testbench 
**/
module Segmentado_tb(); 	
	reg clk_tb; 
	reg rst_tb; 
	wire [31:0] wb_data_o; 
	
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