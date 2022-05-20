module Sort_pipe(
  // Input signals
  clk,
  rst_n,
  in_valid,
  in_number1,
  in_number2,
  in_number3,
  in_number4,
  // Output signals
  out_valid,
  out_number1,
  out_number2,
  out_number3,
  out_number4
);

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
input [4:0] in_number1,in_number2,in_number3,in_number4;
input in_valid,rst_n,clk;
logic [4:0] f1_1,f1_2,f1_3,f1_4;
logic [4:0] f2_1,f2_2,f2_3,f2_4;


output logic [4:0] out_number1,out_number2,out_number3,out_number4;
output logic out_valid;

logic [4:0]l1_1,l1_2,l1_3,l1_4;
logic [4:0]l2_2,l2_3;
logic [4:0]l3_1,l3_2,l3_3,l3_4;
logic [4:0]l4_2,l4_3;
logic in_valid_f1,in_valid_f2;



always_ff@(posedge clk or negedge rst_n) begin//ff 1 
	if (!rst_n)begin
		f1_1 <= 0 ;
		f1_2 <= 0 ;
		f1_3 <= 0 ;
		f1_4 <= 0 ;
	end
	else begin
		f1_1 <= in_number1;
		f1_2 <= in_number2 ;
		f1_3 <= in_number3 ;
		f1_4 <= in_number4 ;
		in_valid_f1 <= in_valid;
	end
end


always_comb begin // A
	if(f1_1>=f1_2)begin
		l1_1 = f1_1;
		l1_2 = f1_2;
	end
	else begin
		l1_1 = f1_2;
		l1_2 = f1_1;
	end
end

always_comb begin // B
	if(f1_3>=f1_4)begin
		l1_3 = f1_3;
		l1_4 = f1_4;
	end
	else begin
		l1_3 = f1_4;
		l1_4 = f1_3;
	end
end

always_comb begin // C
	if(l1_2>=l1_3)begin
		l2_2 = l1_2;
		l2_3 = l1_3;
	end
	else begin
		l2_2 = l1_3;
		l2_3 = l1_2;
	end
end

always_ff@(posedge clk or negedge rst_n) begin //ff 2 
	if (!rst_n)begin
		in_valid_f2 <= 0;
		f2_1 <= 0;
		f2_2 <= 0;
		f2_3 <= 0;
		f2_4 <= 0;
	end
	else begin 
		f2_1 <= l1_1;
		f2_2 <= l2_2 ;
		f2_3 <= l2_3 ;
		f2_4 <= l1_4 ;
		in_valid_f2 <= in_valid_f1;
	end
end

always_comb begin // D
	if(f2_1>=f2_2)begin
		l3_1 = f2_1;
		l3_2 = f2_2;
	end
	else begin
		l3_1 = f2_2;
		l3_2 = f2_1;
	end
end

always_comb begin // E
	if(f2_3>=f2_4)begin
		l3_3 = f2_3;
		l3_4 = f2_4;
	end
	else begin
		l3_3 = f2_4;
		l3_4 = f2_3;
	end
end

always_comb begin // F
	if(l3_2>=l3_3)begin
		l4_2 = l3_2;
		l4_3 = l3_3;
	end
	else begin
		l4_2 = l3_3;
		l4_3 = l3_2;
	end
end

always_ff@(posedge clk or negedge rst_n) begin //ff 3 and output 
	if (!rst_n)begin
		out_valid <= 0;
		out_number1 <= 0;
		out_number2 <= 0;
		out_number3 <= 0;
		out_number4 <= 0;
	end
	else begin
		out_number1 <= l3_1 ;
		out_number2 <= l4_2 ;
		out_number3 <= l4_3 ;
		out_number4 <= l3_4 ;
		out_valid <= in_valid_f2 ;
	end
end


endmodule
