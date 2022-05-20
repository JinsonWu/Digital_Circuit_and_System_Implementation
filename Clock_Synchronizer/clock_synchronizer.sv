module cdc(
  // Input signals
	clk1,
    clk2,
	rst_n,
    in_valid,
    in,
  // Output signals
	out_valid,
    out_valid_back,
	out,
    out_back
);

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
input clk1,clk2,rst_n,in_valid;
input [3:0] in;
output logic [3:0] out;
output logic [4:0] out_back;
output logic out_valid,out_valid_back;
//---------------------------------------------------------------------
//   LOGIC DECLARATION                         
//---------------------------------------------------------------------
logic [3:0] in_1,in_2,in_1r,in_2r,in_1rr,in_1rrr,in_1rrrr;
logic v1,v2,v3,v4,v5,v6,cnt,p1,p2,k,kr,krr;
logic [4:0] add,addr;
integer i;
//---------------------------------------------------------------------
//   DESIGN                        
//---------------------------------------------------------------------

//out_back
always_ff @ (posedge clk1 or negedge rst_n)begin
	if(~rst_n)begin
		in_1 <= 0;
		v1 <= 0;
	end
	else begin
		if(in_valid) begin
			v1 <= in_valid;
			in_1 <= in;
			if (in_1 == in)
				k <= 1;
			else 
				k <= 0;
		end
		else begin
			v1 <= 0;
			in_1 <= in_1;
			if (clk2)
				k <= 0;
			else
				k <= k;
		end
	end			
end

always_ff @ (posedge clk1 or negedge rst_n) begin
	if(~rst_n) begin
		in_1r <= 0;
		v2 <= 0;
	end
	else begin
		in_1r <= in_1;
		v2 <= v1;
	end
end

always_ff @ (posedge clk1 or negedge rst_n) begin
	if(~rst_n) begin
		in_1rr <= 0;
		v3 <= 0;
	end
	else begin
		in_1rr <= in_1r;
		v3 <= v2;
	end
end

always_ff @ (posedge clk1 or negedge rst_n) begin
	if(~rst_n) begin
		in_1rrr <= 0;
		v4 <= 0;
	end
	else begin
		in_1rrr <= in_1rr;
		v4 <= v3;
	end
end

always_ff @ (posedge clk1 or negedge rst_n) begin
	if(~rst_n) begin
		in_1rrrr <= 0;
		v5 <= 0;
	end
	else begin
		in_1rrrr <= in_1rrr;
		v5 <= v4;
	end
end

always_comb begin
	add = in_1rrrr + 5;
end

always_ff @ (posedge clk1 or negedge rst_n)begin
	if (~rst_n)begin 
		v6 <= 0;
		addr <= 0;
	end
	else begin
		v6 <= v5;
		if(addr != add)begin
			addr <= add;
		end
		else begin
			addr <= addr;
		end
	end
end

always_ff @ (posedge clk1 or negedge rst_n)begin
	if(~rst_n)begin
		out_valid_back <= 0;
		out_back <= 0;
	end
	else begin
		out_valid_back <= v6;
		out_back <= addr;
	end
end
//--------------------------------------------------
//out
always_ff @ (posedge clk2 or negedge rst_n) begin
	if (~rst_n) begin
		in_2 <= 0;
		kr <= 0;
	end
	else begin
		kr <= k;
		in_2 <= in_1;
	end
end

always_ff @ (posedge clk2 or negedge rst_n)begin
	if(~rst_n)begin
		in_2r <= 0;
		krr <= 0;
	end
	else begin
		krr <= kr;
		in_2r <= in_2;
	end
end

always_ff @ (posedge clk2 or negedge rst_n)begin
	if(~rst_n)begin
		out_valid <= 0;
		out <= 0;
	end
	else begin
		out <= in_2r;
		if (out != in_2r || krr == 1)begin
			out_valid <= 1;
		end
		else 
			out_valid <= 0;
	end
end
endmodule

