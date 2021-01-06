module ALUControl(
	input [3:0] ALUOp_i, 
	output reg [5:0] Control_ALUOp_o
); 
	always @(*) 
	begin 
		case(ALUOp_i)
			4'b0000: Control_ALUOp_o <= 6'b000000; //Add
			4'b0001: Control_ALUOp_o <= 6'b001000;	//Add and not(sr2)+1
			4'b0010: Control_ALUOp_o <= 6'b001001; //Not and set less than
			4'b0011: Control_ALUOp_o <= 6'b101001; //Used to be shift. Now is LT and not(zero)
			4'b0100: Control_ALUOp_o <= 6'b000011; //or
			4'b0101: Control_ALUOp_o <= 6'b000010; //and
			4'b0110: Control_ALUOp_o <= 6'b000100; //xor 
			4'b0111: Control_ALUOp_o <= 6'b100100; //xor and not(zero) 
			4'b1000: Control_ALUOp_o <= 6'b000101; //Shift left
			4'b1001: Control_ALUOp_o <= 6'b000110; //Shift right
			4'b1010: Control_ALUOp_o <= 6'b000111; //Shift right arithmetic
			//4'b1011 not defined yet
			4'b1100: Control_ALUOp_o <= 6'b011001; //Not, add, less than and unsigned
			4'b1101: Control_ALUOp_o <= 6'b111001; //Not, add, not(zero) and unsigned
			//4'b1110 not defined yet
			//This can be enhanced!
			default: Control_ALUOp_o <= 6'b111111; 
		endcase
	end

endmodule  

	/**control_aluop_i: 
	 bit 4 : Unsgined. lt{i}u
	 bit 3 : Negative. A+not(B)+1=A-B
	 bits [2:0] : Choose from add, lt, and, or, xor, sll, srl, sra
	**/