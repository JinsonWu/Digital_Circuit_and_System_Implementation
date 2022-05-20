module conv(
  // Input signals
  clk,
  rst_n,
  image_valid,
  filter_valid,
  in_data,
  // Output signals
  out_valid,
  out_data
);
//-------------------------------------------------//
//port declaration
//-------------------------------------------------//
input clk;
input rst_n;
input image_valid;
input filter_valid;
input signed [5:0] in_data;
output logic out_valid;
output logic signed [11:0] out_data;
//-------------------------------------------------//
//logic decalaration
//-------------------------------------------------//
logic signed [5:0] image[0:6][0:6];
logic signed [5:0] filter[0:2][0:2];
logic [6:0] count;
logic [5:0] out_count;
logic [5:0] a,b,i,j,c,d,k,l;  
logic [1:0] next,state;
//-------------------------------------------------//
//parameter
//-------------------------------------------------//
parameter		idle = 2'b00,
				cal = 2'b01,
				out = 2'b10;
//-------------------------------------------------//
//state
//-------------------------------------------------//
always_comb begin
	next = 'bx;
	case (state)
		idle : next = cal; 
		cal : begin
				if(count == 48)
					next = out;
				else
					next = cal;
			end
		out : begin
				if (out_count == 24)
					next = idle;
				else 
					next = out;
			end
	endcase 
end
//-------------------------------------------------//
//convolution
//-------------------------------------------------//
always_ff @ (posedge clk or negedge rst_n)begin
	if (~rst_n)begin
		out_data <= 0;
		out_valid <= 0;
		out_count <= 0;
		state <= idle;
		count <= 0;
		i <= 0;
		j <= 0;
		a <= 0;
		b <= 0;
		k <= 0;
		l <= 0;
		c <= 0;
		d <= 0;
	end
	else begin
		state <= next;
		case (state)
			idle : begin
						out_data <= 0;
						out_valid <= 0;
						out_count <= 0;
						count <= 0;
					end
			cal : begin
						if (filter_valid)begin
							filter[i][j] <= in_data;
							if (i == 2 && j == 2)begin
								j <= 0;
								i <= 0;
							end
							else if (j == 2)begin
								j <= 0;
								i <= i + 1;
							end 
							else begin
								j <= j + 1;
								i <= i;
							end
						end
						else begin
							if (image_valid)begin
								count <= count + 1;
								image[a][b] <= in_data;
								if (a == 6 && b == 6)begin
									b <= 0;
									a <= 0;
								end
								else if (b == 6)begin
									b <= 0;
									a <= a + 1;
								end
								else begin
									b <= b + 1;
									a <= a;
								end
							end
							else 
								image <= image;
							filter <= filter;
						end
					end
				out : begin
						if (out_count <= 24)begin
							out_valid <= 1;
							out_count <= out_count + 1;
							out_data <=(filter[0][0] * image[0+c][0+d] +
										filter[0][1] * image[0+c][1+d] +
										filter[0][2] * image[0+c][2+d] +
										filter[1][0] * image[1+c][0+d] +
										filter[1][1] * image[1+c][1+d] +
										filter[1][2] * image[1+c][2+d] +
										filter[2][0] * image[2+c][0+d] +
										filter[2][1] * image[2+c][1+d] +
										filter[2][2] * image[2+c][2+d] );
							if (c == 4 && d == 4)begin
								d <= 0;
								c <= 0;
							end
							else if (d == 4)begin
								d <= 0;
								c <= c + 1;
							end
							else begin
								d <= d + 1;
								c <= c;
							end	
						end
						else begin
							out_count <= 0;
							out_valid <= 0;
							out_data <= 0;
						end
					end
		endcase
	end
end
endmodule 



