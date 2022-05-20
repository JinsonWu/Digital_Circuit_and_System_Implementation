module B2BCD(
  // Input signals
  clk,
  rst_n,
  in_valid,
  in_data,
  // Output signals
  out_valid,
  seg_100,
  seg_10,
  seg_1
);


input clk,rst_n,in_valid;
input  [3:0]in_data;
output logic [6:0] seg_100,seg_10,seg_1;
output logic out_valid;
//================================================================
// logic
//================================================================
logic [3:0] a,ar,b,br,c,cr,d,dr;
logic [2:0] next,state,cnt;
logic [3:0] a_1,b_1,c_1,d_1,b_2,c_2;
logic [3:0] a_3,b_3,c_3,d_3,b_4,c_4;
logic [3:0] out_a,out_b,out_c,out_d;
logic [2:0] com;
logic [6:0] mul_1,mul_1r,mul_2,mul_2r;
logic [7:0] num;
logic [3:0] units,tens,hundred;
logic [19:0] numr_shift;
//================================================================
// parameter
//================================================================
parameter   idle = 3'b000,
            sort = 3'b001,
            mul = 3'b010,
            store = 3'b011,
            shift = 3'b100,
            add = 3'b101,
            out = 3'b110;

parameter   num_0 = 7'b1111110,
            num_1 = 7'b0110000,
            num_2 = 7'b1101101,
            num_3 = 7'b1111001,
            num_4 = 7'b0110011,
            num_5 = 7'b1011011,
            num_6 = 7'b1011111,
            num_7 = 7'b1110000,
            num_8 = 7'b1111111,
            num_9 = 7'b1111011;
//================================================================
// com_A
//================================================================
always_comb begin
  next ='bx;
  case (state)
    idle : next = sort;
    sort : begin
            if(com == 6)
              next = mul;
            else
              next = sort;
          end
    mul : next = store;
    store : next = shift;
    shift : begin
              if(cnt == 7)
                next = out;
              else 
                next = add;
            end
    add : next = shift;
    out : next = idle;
    default : next = idle;
  endcase // state
end
//================================================================
// FF
//================================================================
always_ff @ (posedge clk or negedge rst_n)begin
  if(!rst_n)begin
    ar <= 0;
    br <= 0;
    cr <= 0;
    dr <= 0;
    a <= 0;
    b <= 0;
    c <= 0;
    d <= 0;
    cnt <= 0;
    mul_1r <= 0;
    mul_2r <= 0;
    numr_shift <= 0;
    hundred <= 0;
    tens <= 0;
    units <= 0;
    com <= 0;
    seg_100 <= 0;
    seg_10 <= 0;
    seg_1 <= 0;
    state <= idle;
    out_valid <= 0;
  end
  else begin
    state <= next;
    case(state)
      idle : begin
                seg_100 <= 0;
                seg_10 <= 0;
                seg_1 <= 0;
                out_valid <= 0;
                numr_shift <= 0;
                com <= 0;
            end
      sort : begin
              if(in_valid)begin
                a <= in_data;
                b <= a;
                c <= b;
                d <= c;
              end
              else begin
				ar <= a_1;
				br <= b_2;
				cr <= c_2;
				dr <= d_1;
				out_a <= a_3;
				out_b <= b_4;
				out_c <= c_4;
				out_d <= d_3;
              end
			  com <= com + 1;
            end
      mul : begin
              mul_1r <= mul_1;
              mul_2r <= mul_2;
            end
      store : numr_shift[7:0] <= num;
      shift : begin
                numr_shift <= numr_shift << 1;
                if (cnt == 7)
                  cnt <= 0;
                else 
                  cnt <= cnt + 1;
              end
      add : begin
              if(numr_shift[11:8] > 4 && numr_shift[15:12] > 4)
                numr_shift[19:8] <= numr_shift[19:8] + 51;
              else if (numr_shift[11:8] > 4)
                numr_shift[19:8] <= numr_shift[19:8] + 3;
              else if (numr_shift[15:12] >4) 
                numr_shift[19:12] <= numr_shift[19:12] + 3;
              else
                numr_shift <= numr_shift;
            end
      out : begin
              out_valid <= 1;
              case(numr_shift[19:16])
                0 : seg_100 <= num_0;
                1 : seg_100 <= num_1;
                2 : seg_100 <= num_2;
                3 : seg_100 <= num_3;
                4 : seg_100 <= num_4;
                5 : seg_100 <= num_5;
                6 : seg_100 <= num_6;
                7 : seg_100 <= num_7;
                8 : seg_100 <= num_8;
                9 : seg_100 <= num_9;
              endcase
              case(numr_shift[15:12])
                0 : seg_10 <= num_0;
                1 : seg_10 <= num_1;
                2 : seg_10 <= num_2;
                3 : seg_10 <= num_3;
                4 : seg_10 <= num_4;
                5 : seg_10 <= num_5;
                6 : seg_10 <= num_6;
                7 : seg_10 <= num_7;
                8 : seg_10 <= num_8;
                9 : seg_10 <= num_9;
              endcase
              case(numr_shift[11:8])
                0 : seg_1 <= num_0;
                1 : seg_1 <= num_1;
                2 : seg_1 <= num_2;
                3 : seg_1 <= num_3;
                4 : seg_1 <= num_4;
                5 : seg_1 <= num_5;
                6 : seg_1 <= num_6;
                7 : seg_1 <= num_7;
                8 : seg_1 <= num_8;
                9 : seg_1 <= num_9;
              endcase
            end
    endcase 
  end
end
//================================================================
// com for comparatorA
//================================================================
always_comb begin
	if(a > b)begin
		a_1 = a;
		b_1 = b;
	end
	else begin
		a_1 = b;
		b_1 = a;
	end
end

always_comb begin
	if(c > d)begin
		c_1 = c;
		d_1 = d;
	end
	else begin
		c_1 = d;
		d_1 = c;
	end
end

always_comb begin
	if(b_1 > c_1)begin
		b_2 = b_1;
		c_2 = c_1;
	end
	else begin
		b_2 = c_1;
		c_2 = b_1;
	end
end
//================================================================
// com for comparatorB
//================================================================
always_comb begin
	if(ar > br)begin
		a_3 = ar;
		b_3 = br;
	end
	else begin
		a_3 = br;
		b_3 = ar;
	end
end

always_comb begin
	if(cr > dr)begin
		c_3 = cr;
		d_3 = dr;
	end
	else begin
		c_3 = dr;
		d_3 = cr;
	end
end

always_comb begin
	if(b_3 > c_3) begin
		b_4 = b_3;
		c_4 = c_3;
	end
	else begin
		b_4 = c_3;
		c_4 = b_3;
	end
end
//================================================================
// com_B
//================================================================
always_comb begin
  mul_1 = out_a + out_c*10;
  mul_2 = out_b + out_d*10;
end
//================================================================
// com_C
//================================================================
always_comb begin
  num = mul_1r * mul_2r;
end

endmodule
