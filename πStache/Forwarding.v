//No sirve
/**
	Dudas: 
		¿Para qué es el MUX que toma rs, rt y rd?
		¿Este módulo sólo controla los mux de los operandos de la ALU?
		¿Sólo compara los rd, verdad?
**/
module Forwarding(
	input [4:0] rs1_idr,
	input [4:0] rs2_idr, 
	input [4:0] rd_exr, 
	input [4:0] rd_memr,
	input RegWrite_exr,
	input RegWrite_memr, 
	output reg 	[1:0] ALU_src1_sel,  
	output reg 	[1:0] ALU_src2_sel
); 
	always@(*) begin 
		if((rs1_idr==rd_exr)&(rd_exr!=5'b0)&(RegWrite_exr)) 
			ALU_src1_sel <= 2'b01; 
		else begin 
			if((rs1_idr==rd_memr)&(rd_memr!=5'b0)&(RegWrite_memr))
				ALU_src1_sel <= 2'b10;
			else
				ALU_src1_sel <= 2'b00;
		end 
	end 
	always@(*) begin 
		if((rs2_idr==rd_exr)&(rd_exr!=5'b0)&(RegWrite_exr)) 
			ALU_src2_sel <= 2'b01; 
		else begin 
			if((rs2_idr==rd_memr)&(rd_memr!=5'b0)&(RegWrite_memr))
				ALU_src2_sel <= 2'b10;
			else
				ALU_src2_sel <= 2'b00;
		end 
	end  
endmodule 