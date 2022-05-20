module adv_pipe(
  // Input signals
	clk,
	rst_n,
    in_valid,
    in_1,
    in_2,
    in_3,
  // Output signals
	out_valid,
	out
);

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
input clk,rst_n,in_valid;
input [30:0] in_1,in_2;
input [31:0] in_3;
output logic [63:0] out;
output logic out_valid;
//---------------------------------------------------------------------
//   LOGIC DECLARATION                         
//---------------------------------------------------------------------
logic valid1,valid2,valid3,valid4,valid5;
logic [30:0] in1r,in2r;
logic [31:0] m1,m2,m4,add,in3r,m2r;
logic [32:0] m3; 
logic [16:0] m3r;
logic [15:0] a,ar,arr,arrr,b,br,brr,brrr,c,cr,crr,crrr,d,dr,drr,drrr,out1,out1r,out1rr,out2,out2r,m1r;
//---------------------------------------------------------------------
//   DESIGN                        
//---------------------------------------------------------------------
always_ff @ (posedge clk or negedge rst_n)begin
	if(~rst_n)begin
		valid1 <= 0;
		in1r <= 0;
		in2r <= 0;
		in3r <= 0;
	end
	else begin
		valid1 <= in_valid;
		in1r <= in_1;
		in2r <= in_2;
		in3r <= in_3;
	end
end

always_comb begin
	add = in1r + in2r;
end

always_ff @ (posedge clk or negedge rst_n)begin	
	if(~rst_n)begin
		valid2 <= 0;
		a <= 0;
		b <= 0;
		c <= 0;
		d <= 0;
	end
	else begin
		a <= in3r[31:16];
		b <= in3r[15:0];
		c <= add [31:16];
		d <= add [15:0];
		valid2 <= valid1;
	end
end

always_comb begin	
	m1 = (b * d);
end

always_ff @ (posedge clk or negedge rst_n)begin
	if(~rst_n)begin
		valid3 <= 0;
		ar <= 0;
		br <= 0;
		cr <= 0;
		dr <= 0;
		m1r <= 0;
		out1 <= 0;
	end
	else begin
		out1 <= m1[15:0];
		valid3 <= valid2;
		ar <= a;
		br <= b;
		cr <= c;
		dr <= d;
		m1r <= m1[31:16];
	end
end

always_comb begin
	m2 = m1r + (cr*br);
end

always_ff @ (posedge clk or negedge rst_n)begin
	if (~rst_n)begin
		valid4 <= 0;
		arr <= 0;
		brr <= 0;
		crr <= 0;
		drr <= 0;
		m2r <= 0;
		out1r <= 0;
	end
	else begin
		arr <= ar;
		brr <= br;
		crr <= cr;
		drr <= dr;
		m2r <= m2;
		out1r <= out1;
		valid4 <= valid3;
	end
end

always_comb begin
	m3 = m2r + (arr*drr);
end

always_ff @ (posedge clk or negedge rst_n)begin
	if (~rst_n)begin
		valid5 <= 0;
		arrr <= 0;
		brrr <= 0;
		crrr <= 0;
		drrr <= 0;
		m3r <= 0;
		out2 <= 0;
		out1rr <= 0;
	end
	else begin
		arrr <= arr;
		brrr <= brr;
		crrr <= crr;
		drrr <= drr;
		m3r <= m3[32:16];
		out1rr <= out1r;
		out2 <= m3[15:0];
		valid5 <= valid4;
	end
end

always_comb begin
	m4 = (arrr * crrr) + m3r;
end

always_ff @ (posedge clk or negedge rst_n) begin
	if(~rst_n)begin
		out_valid <= 0;
		out <= 0;
	end
	else begin
		out_valid <= valid5;
		out <= {m4,out2,out1rr};
	end
end
endmodule
