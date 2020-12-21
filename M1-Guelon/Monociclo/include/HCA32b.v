//Ya funciona, pero hay que reducir las líneas de código 
//y ver cómo se puede generalizar para sumadores de n bits.

module HCA32b #(parameter ADDERWIDTH = 32)(
	input [ADDERWIDTH-1:0] A, 
	input [ADDERWIDTH-1:0] B, 
	input cin, 
	output [ADDERWIDTH-1:0] S,
	output cout
); 
	genvar i; 
	genvar j; 
	wire P [7:0][ADDERWIDTH-1:0]; 
	wire G [7:0][ADDERWIDTH-1:0]; 
	
	//------------------------
	//------Brent-kung--------
	generate
		for(i=0; i<ADDERWIDTH; i=i+1)
		begin : firstLayer
			if(i==0)
				prefix1 prfeices1(cin, cin, P[0][i], G[0][i]);
			else
				prefix1 prfeices1(A[i-1], B[i-1], P[0][i], G[0][i]);
		end
	endgenerate 
	
	generate
		for(i=0; i<ADDERWIDTH; i=i+1)
		begin : stage1
			if((i+1)%2==0)
				prefices preficesS1(P[0][i], P[0][i-1], G[0][i], G[0][i-1], P[1][i], G[1][i]);
			else
			begin 
				assign P[1][i] = P[0][i]; 
				assign G[1][i] = G[0][i];
			end
		end
	endgenerate
	//------------------------
	//------------------------
	
	
	//-------------------------
	//-------Kogge-Stone-------
	generate 
		for(j=1; j<5; j=j+1)
		begin : KoggeStone 
			for(i=0; i<ADDERWIDTH; i=i+1)
			begin : KSi
				if((i+1)%4==0 && i>2**j) 
					prefices preKS(P[j][i], P[j][i-2**j], G[j][i], G[j][i-2**j], P[j+1][i], G[j+1][i]);
				else
				begin 
					assign P[j+1][i] = P[j][i]; 
					assign G[j+1][i] = G[j][i];
				end
			end
		end
	endgenerate
	//-------------------------
	//-------------------------
	
	
	//------------------------------
	//----------Brent-Kung----------
	generate
		for(i=0; i<ADDERWIDTH; i=i+1)
		begin : stage6
			if((i-1)%4==0 && i>4) 
				prefices preficesS3(P[5][i], P[5][i-2], G[5][i], G[5][i-2], P[6][i], G[6][i]);
			else
			begin 
				assign P[6][i] = P[5][i]; 
				assign G[6][i] = G[5][i];
			end
		end
	endgenerate
	
	generate
		for(i=0; i<ADDERWIDTH; i=i+1)
		begin : stage7
			if(i%2==0 && i>0) 
				prefices preficesS3(P[6][i], P[6][i-1], G[6][i], G[6][i-1], P[7][i], G[7][i]);
			else
			begin 
				assign P[7][i] = P[6][i]; 
				assign G[7][i] = G[6][i];
			end
		end
	endgenerate
	//-----------------------------
	//-----------------------------
	
	
	//Sum with no carry out
	generate
		for(i=0; i<ADDERWIDTH; i=i+1)
		begin : lastLayer
			cinAdder Adders(A[i], B[i], G[7][i], S[i]); 
		end
	endgenerate
	
	//Carry out
	assign cout = (A[ADDERWIDTH-1]&B[ADDERWIDTH-1])|(A[ADDERWIDTH-1]&G[7][ADDERWIDTH-1]); 
	
endmodule 


module cinAdder(
	input A, 
	input B,
	input cin, 
	output S
); 
	assign S = A^B^cin; 
endmodule 

module prefices(
	input Ploc, 
	input Pant, 
	input Gloc, 
	input Gant,
	output Psal, 
	output Gsal
);
	assign Psal = Ploc&Pant; 
	assign Gsal = Gloc|(Ploc&Gant);	
endmodule 

module prefix1(
	input A, 
	input B, 
	output P, 
	output G
); 
	assign P = A|B; 
	assign G = A&B; 
endmodule

//Banco de pruebas
/**
module HCA32b_tb (); 
	reg 	[31:0] 	opeA; 
	reg 	[31:0] 	opeB; 
	reg 				Carryin; 
	wire 	[31:0]	Sal; 
	wire 				Carryout; 
	
	HCA32b Adder_U0(opeA, opeB, Carryin, Sal, Carryout);
	
	initial 
	begin 
		opeA = 32'b0; 
		opeB = 32'b0; 
		Carryin = 1'b0; 
	end 
	
	always
		begin 
		#50
			opeA = 32'hBABEFACE; 
			opeB = 32'hDEADBEEF; 
			Carryin = 1'b0; 
			
		#50 
			opeA = 32'h10; 
			opeB = 32'hBABE; 
			Carryin = 1'b0; 
		#50 
			opeA = 32'hDEAD; 
			opeB = 32'hBEEF; 
			Carryin = 1'b1;
		#50 
			opeA = 32'hFACE; 
			opeB = 32'h0FFA; 
			Carryin = 1'b1;
		#50
			opeA = 32'hDEADFACE; 
			opeB = 32'hBEEFBABE; 
			Carryin = 1'b0;	
		#50
			opeA = 32'h1; 
			opeB = 32'h1; 
			Carryin = 1'b1;
	end
	
endmodule 
**/

