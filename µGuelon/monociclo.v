/* ---------------------------------------------------------
 * Project Name	: Single-cycle processor. 
 * File 				: monociclo.v
 * Organization 	: Research Center in Computing (CIC-IPN)
 * Author(s) 		: Emmanuel Larralde
 * Email(s)			: ealarralde@gmail.com
 *References		:
 *---------------------------------------------------------
*/


//`include "include/lagartoII_const.vh"

//ALUOp not defined yet
//ControlUnit not defined yet

module monociclo(
	input clk_i, 
	input rst_i, 
	//output `WORD wb_dato_o
	output reg [31:0] wb_dato_o 
); 

	//wire  `WORD if_inst_i; 
	wire  [31:0] if_inst_i; 
	reg [31:0] PC_next;
	
	//functional unit which calculates next pc
	PCGen PCGen_U0(
		.clk_i (clk_i),		//CLK signal
		.rst_i (rst_i), 		//Async reset signal. Reset if rst_i=0
		.PC_i (PC_next), 
		.PC_o  (if_inst_i)	//Generated pc
	); 
	
	//wire `WORD if_inst_o; 
	wire [31:0] if_inst_o; 
	
	//functional block for program memory.
	msinc MemInst_U0(
		.clk_i (clk_i), 				//CLK signal
		.WE    (1'b0), 				//Write-enable signal, but here is fixed always to 0
		.AddrR (if_inst_i[13:2]), 	//Address for reading a register, for this case, pc.
		.AddrW (12'b0), 				//Address for writing in a register. Unused here.
		.DataW (32'b0), 				//Data to write. Unused here.
		.DataR (if_inst_o)			//Data just read, for this case, current instruction.
	);
	
	
//Read Register Stage
	//wire `WORD rr_datars1_o;
	wire [31:0] rr_datars1_o;
	//wire `WORD rr_datars2_o;	
	wire [31:0] rr_datars2_o;	
	wire 			RegWrite; 
	//RiscV registers unit. Sync RAM memory
	Rfile  ReadRegister_U0(
		.clk_i   (clk_i),					//CLK signal
		.we_i	   (RegWrite),				//Write enable signal
		.addrs1  (if_inst_o[19:15]),	//Address of Source Register 1 (rs1).
		.addrs2  (if_inst_o[24:20]),	//Address of Source Register 2 (rs2).
		.addrd   (if_inst_o[11:7]),	//Address of Destination Register (rd). 
		.datard  (wb_dato_o), 			//Data for rd
		.datars1 (rr_datars1_o),		//Data of rs1
		.datars2 (rr_datars2_o)			//Data of rs2
	); 

	
//Execution stage
	wire 			ex_zero_o; 
	reg [31:0] alu_datars2_i; 
	//Main integer ALU
	//wire `WORD ;
	wire [31:0] alu_result_o;
	//wire [31:0] alu_result_o;	
	wire ALUSrc; 
	wire [31:0] se_data_o; 
	always @(*)
	begin 
		if(ALUSrc)	
			alu_datars2_i <= se_data_o; 
		else
			alu_datars2_i <= rr_datars2_o; 
	end 
	
	wire [5:0] ctrl_alu_i; 
	ALU ALU_U0(
		.rr_datars1_i  (rr_datars1_o),	//First operand
		.rr_datars2_i  (alu_datars2_i), 	//Second operand
		.ctrl_aluop_i  (ctrl_alu_i), 				//ALU signal from control unit		
		.ex_data_o     (alu_result_o),	//Result of operation	
		.ex_zeroflag_o (ex_zero_o)			//Zero Flag. Activated when result equals to 0. 
	);

	//Type I datapath
	signExtend signExtender_U0(
		.instruction_i (if_inst_o), 	//Instruction
		.word_o (se_data_o)				//Generated word with sign-extended immediate
	); 

	//Type S datapath
	wire MemWrite; 
	wire MemRead; 
	wire [31:0] memData_dato_o; 
	msinc_Data MemData_U0(
		.clk_i (clk_i), 			//CLK signal
		.WE    (MemWrite), 			//Write-enable signal, but here is fixed always to 0
		.RE 	 (MemRead),
		.Addr (alu_result_o[13:2]), 	//Address for reading a register, for this case, pc.
		.DataW (rr_datars2_o), 	//Data to write. Unused here.
		.DataR (memData_dato_o)		//Data just read, for this case, current instruction.
	);
	
	//Other Multiplexors
	wire MemtoReg; 
	always @(*)
	begin 
		if(MemtoReg)
			wb_dato_o <= memData_dato_o; 
		else 
			wb_dato_o <= alu_result_o; 
	end 
	
	//PC flow
	
	wire [31:0] PC_branch;
	HCA32b Adder_U2(
		.A 	(if_inst_i),
		.B		(se_data_o),
		.cin  (1'b0),
		.S    (PC_branch)
	); 	

	wire PCSrc; 
	always @(*)
	begin 
		if(PCSrc)
			PC_next <= PC_branch;
		else
			PC_next <= if_inst_i+4;
	end 
	
	//Control stage
	wire [3:0] ALUOp; 
	ALUControl ALUC_U0(
		.ALUOp_i 			(ALUOp), 
		.Control_ALUOp_o  (ctrl_alu_i)
	); 
	
	wire Branch;
	ControlUnit Ctrol_U0( 
		.Inst_i 	(if_inst_o), 
		.ctrl_Branch_o 	(Branch), 
		.ctrl_MemRead_o 	(MemRead), 
		.ctrl_MemtoReg_o	(MemtoReg), 
		.ctrl_ALUOp_o	 	(ALUOp), 
		.ctrl_MemWrite_o	(MemWrite), 
		.ctrl_ALUSrc_o		(ALUSrc), 
		.ctrl_RegWrite_o	(RegWrite)
	); 
	
	assign PCSrc = ex_zero_o&Branch; 
	
	
endmodule 

//Module for monociclo testbench. 
module monociclo_tb(); 
	reg clk_i_tb;  
	reg rst_i_tb; 
	//wire `WORD wb_dato_o_tb; 
		wire [31:0] wb_dato_o_tb; 
	
	monociclo U0_tb(clk_i_tb, rst_i_tb, wb_dato_o_tb); 
	
	initial begin 
		clk_i_tb = 1'b0; 
		rst_i_tb = 1'b1; 
	end 
	
	always begin 
		#50
		clk_i_tb = ~clk_i_tb; 
	end 
endmodule 

