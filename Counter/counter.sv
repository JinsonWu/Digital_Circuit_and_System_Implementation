module Counter(
  // Input signals
	clk,
	rst_n,
  // Output signals
	clk2,
	out_valid

);

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
input clk,rst_n;

output logic clk2,out_valid;

logic [2:0] counter;
always @(posedge clk or negedge rst_n)
begin
	if(~rst_n) begin
		clk2 <= 0;
		out_valid <= 0;
		counter <= 0;
	end else begin
		counter <= counter + 1;
		out_valid <= 0;
		if(counter == 1) begin
			counter <= 0;
			clk2 <= ~clk2;
			out_valid <= 1;
		end

	end
end
endmodule
