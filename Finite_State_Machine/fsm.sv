module coin(
  // Input signals
	clk,
	rst_n,
    in_coin,
    in_valid,
  // Output signals
	out_valid,
	out_one_coin,
    out_five_coin,
    out_ten_coin

);

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
input clk,rst_n,in_valid;
input [5:0] in_coin;
output logic [2:0] out_one_coin, out_five_coin, out_ten_coin;
output logic out_valid;
//---------------------------------------------------------------------
//   LOGIC DECLARATION                         
//---------------------------------------------------------------------
logic [5:0] in_coin_reg;
logic [2:0] state,next,out1,out5,out10;
//---------------------------------------------------------------------
//   State DECLARATION                         
//---------------------------------------------------------------------
parameter idle = 3'b000,
		  check = 3'b001, 
          ten = 3'b010,
          five = 3'b011,
          one = 3'b100,
          out = 3'b101;
//---------------------------------------------------------------------
//   Finite State Machine                        
//---------------------------------------------------------------------
//State Register
always @ (posedge clk or negedge rst_n)begin
    if (~rst_n)begin
		state <= idle;
		out_valid <= 0;
		in_coin_reg <= 0;
		out1 <= 0;
		out5 <= 0;
		out10 <= 0;
		out_ten_coin <= 0;
		out_five_coin <= 0;
		out_one_coin <= 0;
	end
	else begin
		state <= next;
		if(in_valid) in_coin_reg <= in_coin;
		else begin
			case (state) 
			idle : out_valid <= 0;
			check : out_valid <= 0 ;
			ten : begin in_coin_reg <= in_coin_reg - 10;
						out10 <= out10 + 1;
						out5 <= out5;
						out1 <= out1;
						out_valid <= 0;
					end
			five : begin in_coin_reg <= in_coin_reg - 5;
						 out5 <= out5 + 1;
						 out10 <= out10;
						 out1 <= out1;
						 out_valid <= 0;
					end
			one : begin in_coin_reg <= in_coin_reg - 1;
						out1 <= out1 + 1;
						out10 <= out10;
						out5 <= out5;
						out_valid <= 0;
					end
			out :  begin 
						out_valid <= 1;
						out10 <= 0;
						out5 <= 0;
						out1 <= 0;
						out_ten_coin <= out10;
						out_five_coin <= out5;
						out_one_coin <= out1;
					end
			default : begin
						out1 <= out1;
						out5 <= out5;
						out10 <= out10;
						out_one_coin <= 0;
						out_five_coin <= 0;
						out_ten_coin <= 0;
						in_coin_reg <= in_coin_reg;
					  end
			endcase
		end
	end
end
always_comb begin
	next = 'bx;                 
	case (state)
		idle : begin
				if (in_valid) next = check;
				else next = idle;
			   end
		check : begin
					if (in_coin_reg >= 10) next = ten;
					else if (in_coin_reg >= 5) next = five;
					else if (in_coin_reg > 0) next = one;
					else if (in_coin_reg == 0) next = out;
					else next = idle;
				end
		ten : next = check;
		five : next = check;
		one : next =  check;
		out : next = idle;
		default : next = idle ;
	endcase
end
endmodule			
