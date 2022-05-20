module pipeline(
  // Input signals
	clk,
	rst_n,
    in,
    in_valid,
  // Output signals
	out,
	out_valid

);

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
input clk,rst_n,in_valid;
input [3:0] in;
output logic [31:0] out;
output logic out_valid;

//---------------------------------------------------------------------
//   Logic DECLARATION                         
//---------------------------------------------------------------------
logic [7:0] in_1;
logic [15:0] in_2;
logic [4:0] count;
//---------------------------------------------------------------------
//   Design                        
//---------------------------------------------------------------------
always_ff @(posedge clk or negedge rst_n)begin
	if (~rst_n)begin
		out = 0;
		out_valid = 0;
		in_1 <= 0;
		in_2 <= 0;
		count <= 0;
	end
	else begin
		count <= count +1;
		in_1 <= in*in;
		in_2 <= in_1*in_1;
		out = in_2*in_2;
		if (count <= 16 && out !=0)
			out_valid = 1;
		else begin
			out_valid = 0;
			out = 0;
		end
	end
end
endmodule


