//synopsys translate_off 
//synopsys translate_on


module VM(
    //Input 
    clk,
    rst_n,
    price_in_valid,
    in_coin_valid,
    coin_in,
    btn_coin_rtn,
    btn_buy_item,
    price_in,
    //OUTPUT
    monitor,
    out_valid,
    out
);

    //Input 
input clk;
input rst_n;
input price_in_valid;
input in_coin_valid;
input [5:0] coin_in;
input btn_coin_rtn;
input [2:0] btn_buy_item;
input [4:0] price_in;
    //OUTPUT
output logic [8:0] monitor;
output logic out_valid;
output logic [3:0] out;
//---------------------------------------------------------------------
//  LOGIC DECLARATION                             
//---------------------------------------------------------------------
logic [3:0] state;
logic [3:0] out_50,out_20,out_10,out_5,out_1,ans_50,ans_20,ans_10,ans_5,ans_1;
logic [4:0] product_0,product_1,product_2,product_3,product_4,product_5,product_6,product;
logic signed [9:0] left;
logic [3:0] next;
logic [2:0] item;
logic err,item_rtn;
//----------Parameter--------//
//---------------------------//
parameter   idle = 4'b0000,
            check = 4'b0001,
            buy = 4'b0010,
            fifty = 4'b0011,
            twenty = 4'b0100,
            ten = 4'b0101,
            five = 4'b0110,
            one = 4'b0111,
            payment = 4'b1000,
			item_out = 4'b1001,
			back_50 = 4'b1010,
			back_20 = 4'b1011,
			back_10 = 4'b1100,
			back_5 = 4'b1101,
			back_1 = 4'b1110;
//------------FSM------------//
//---------------------------//
always_comb begin
    next = 'bx;
    case(state)
        idle :  next = check;
        check : begin
                    if (price_in_valid || in_coin_valid)
                        next = check;
                    else begin
                        if (monitor > 0 && err == 0)
                            next = buy;
                        else
                            next = check;
                    end
                end
        buy : begin
				if (left >= 50) next = fifty;
				else if (left >= 20) next = twenty;
				else if (left >= 10) next = ten;
				else if (left >= 5) next = five;
				else if (left > 0) next = one;
				else next = payment;
			end
		fifty : next = buy;
        twenty : next = buy;
        ten : next = buy;
        five : next = buy;
        one : next = buy;
        payment : next = item_out;
        item_out : next = back_50;
        back_50 : next = back_20;
        back_20 : next = back_10;
        back_10 : next = back_5;
        back_5 : next = back_1;
        back_1 : next = idle;
            default : next = idle;
	endcase
end

//-----------COUNT SIGNAL----------//
//----------------------------------//
always_ff @(posedge clk or negedge rst_n)begin
    if (~rst_n)begin
        state <= idle;
        monitor <= 0;
        out_50 <= 0;
		out_20 <= 0;
        out_10 <= 0;
        out_5 <= 0;
        out_1 <= 0;
        left <= 0;
		product <= 0;
        product_0 <= 0;
        product_1 <= 0;
        product_2 <= 0;
        product_3 <= 0;
        product_4 <= 0;
        product_5 <= 0;
        product_6 <= 0; 
        ans_50 <= 0;
		ans_20 <= 0;
        ans_10 <= 0;
        ans_5 <= 0;
        ans_1 <= 0;
        err <= 0;
		out_valid <= 0;
		out <= 0;
    end
    else begin
        state <= next;
        case (state)
            idle : begin
   					out_valid <= 0;
					out <= 0;
					monitor <= monitor;
                end
			check : begin
						out_valid <= 0;
						out <= 0;
                        if (price_in_valid) begin
                            product_6 <= price_in;
                            product_5 <= product_6;
                            product_4 <= product_5;
                            product_3 <= product_4;
                            product_2 <= product_3;
                            product_1 <= product_2;
                            product_0 <= product_1;
                        end   
                        else begin
                            product_0 <= product_0;
                            product_1 <= product_1;
                            product_2 <= product_2;
                            product_3 <= product_3;
                            product_4 <= product_4;
                            product_5 <= product_5;
                            product_6 <= product_6;
                            if (in_coin_valid) begin
                                monitor <= monitor + coin_in;
								err <= 0;
							end
                            else begin
								if (~btn_coin_rtn)begin
									case (btn_buy_item)
										3'd0 : left <= monitor;
										3'd1 : left <= monitor - product_0;
										3'd2 : left <= monitor - product_1;
										3'd3 : left <= monitor - product_2;
										3'd4 : left <= monitor - product_3;
										3'd5 : left <= monitor - product_4;
										3'd6 : left <= monitor - product_5;
										3'd6 : left <= monitor - product_6;
											default : left <= monitor;
									endcase
									if (monitor < product) begin
										left <= 0;
										err <= 1;
									end
									else begin
										err <= 0;
										monitor <= 0;
									end
								end
								else begin
									left <= monitor;
									monitor <= 0;
								end
							end
                        end
						item <= btn_buy_item;
						item_rtn <= btn_coin_rtn;
					end
			buy :   begin
                        out <= 0;
                        out_valid <= 0;
                    end
			fifty : begin
                        out_50 <= out_50 + 1;
                        left <= left - 50;
                    end
			twenty : begin
                        left <= left - 20;
						out_20 <= out_20 + 1;
                    end
            ten : begin
                    left <= left - 10;
                    out_10 <= out_10 + 1;
                end
            five : begin
                    left <= left - 5;
                    out_5 <= out_5 + 1;
                end
            one : begin
                    left <= left - 1;
                    out_1 <= out_1 + 1;
                end
            payment : begin
                    left <= 0;
                    out_50 <= 0;
					out_20 <= 0;
                    out_10 <= 0;
                    out_5 <= 0;
                    out_1 <= 0;
                    ans_50 <= out_50;
					ans_20 <= out_20;
                    ans_10 <= out_10;
                    ans_5 <= out_5;
                    ans_1 <= out_1;
					
                end
			item_out : begin
						out_valid <= 1;
						if (~err) begin
							if (~item_rtn)
								out <= item;
							else
								out <= 0;
						end
						else
							out <= 0;
					end
			back_50 : begin	
						out_valid <= 1;
						if (~err)
							out <= ans_50;
						else 
							out <= 0;
					end	
			back_20 : begin	
						out_valid <= 1;
						if (~err)
							out <= ans_20;
						else 
							out <= 0;
					end	
			back_10 : begin	
						out_valid <= 1;
						if (~err)
							out <= ans_10;
						else 
							out <= 0;
					end	
			back_5 : begin	
						out_valid <= 1;
						if (~err)
							out <= ans_5;
						else 
							out <= 0;
					end	
			back_1 : begin	
						out_valid <= 1;
						if (~err)
							out <= ans_1;
						else 
							out <= 0;
					end	
                default : begin
                              left <= left;
                              out_50 <= out_50;
							  out_20 <= out_20;
                              out_10 <= out_10;
                              out_5 <= out_5;
                              out_1 <= out_1;
                              ans_50 <= ans_50;
                              ans_10 <= ans_20;
                              ans_20 <= ans_10;
                              ans_5 <= ans_5;
                              ans_1 <= ans_1;
							  out <= 0;
							  out_valid <= 0;
                        end
        endcase
    end
end



//-----------OUTPUT SIGNAL----------//
//----------------------------------//
//--------------------------------------------------------

//----------------------------------------------------------------



endmodule
