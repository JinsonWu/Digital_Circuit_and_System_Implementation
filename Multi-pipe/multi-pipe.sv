module pipe(
  // Input signals
  clk,
  rst_n,
  in_valid,
  in_data1,
  in_data2,
  
  // Output signals
  out_valid,
  out_data
);

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
input [2:0] in_data1,in_data2;
input in_valid,rst_n,clk;

output logic [7:0] out_data;
output logic out_valid;

//---------------------------------------------------------------------
//logic
//---------------------------------------------------------------------

logic [7:0] add;
logic [2:0] in1,in2,in2r;
logic [7:0] multi,multir;
logic [7:0] out_data1,out_data2;
logic valid1,valid2;

//---------------------------------------------------------------------
//calculation
//---------------------------------------------------------------------
always_ff @(posedge clk or negedge rst_n)begin
	if(~rst_n)begin
		valid1<= 0;
		out_data1 <= 0;
	end
	else begin
		if (in_valid)begin
			in1 <= in_data1;
			in2 <= in_data2;
			valid1 <= in_valid;
			out_data1 <= out_data;
		end
		else begin
			valid1 <= 0;
			out_data1 <= 0;
		end
	end
end

always_comb begin
	multi = in1 * in2;
end

always_ff @(posedge clk or negedge rst_n)begin
	if (~rst_n)begin
		valid2 <= 0;
		out_data2 <= 0;
	end
	else begin
		if (in_valid)begin
			multir <= multi;
			in2r <= in2;
			valid2 <= valid1;
			out_data2 <= out_data1;
		end
		else begin
			valid2 <= 0;
			out_data2 <= 0;
		end
	end
end 

always_comb begin
	add = multir + in2r;
end

always_ff @(posedge clk or negedge rst_n)begin
	if(~rst_n)begin
		out_data <= 0;
		out_valid <= 0;
	end
	else begin
		if(in_valid)begin
			out_valid <= 1;
			out_data <= add;
			out_valid <= valid2;
		end
		else begin
			out_valid <= 0;
			out_data <= 0;
		end
	end
end
endmodule


