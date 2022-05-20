module MS(
	rst_n , 
	clk , 
	maze ,
	in_valid ,
	out_valid,
	maze_not_valid,
	out_x, 
	out_y
);
			
input rst_n, clk, maze ,in_valid ;
output reg out_valid;
output reg maze_not_valid;
output reg [3:0]out_x, out_y ;

//---------------------------------------------------------//
//logic
//---------------------------------------------------------//
logic [3:0] x,y,i,j,a,l,g,cnt;
logic [6:0] step;
logic [3:0] turn;
logic [3:0] array [14:0][14:0];
logic map [14:0][14:0];
logic [3:0]x_reg[11:0];
logic [3:0]y_reg[11:0];
logic out_cnt;
				
//---------------------------------------------------------//
//design
//---------------------------------------------------------//
always_ff @ (posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		i <= 0;
		j <= 0;
	end
	else begin
		if (in_valid)begin
			map[i][j] <= maze;
			if (j ==14 && i ==14)begin
				j <= 0;
				i <= 0;
			end
			else if (i ==14)begin
				i <= 0;
				j <= j + 1;
			end
			else begin
				i <= i + 1;
				j <= j;
			end
		end
		else begin
			if(array[13][13][0] == 1'b1)begin
				i <= 0;
				j <= 0;
			end
			else begin
				i <= i;
				j <= j;
			end
		end
	end
end

always_ff @ (posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		a <= 0;
		g <= 0;
		l <= 0;
		cnt <= 0;
		step <= 1;
		turn <= 1;
	end
	else begin
		if (i == 1 && j == 0)begin
			for(g = 0;g <15;g++)begin
				for (l = 0;l <15;l++)begin
					array[g][l] <= 4'b0;
				end
			end
			for(cnt = 0;cnt < 12;cnt++)begin
				x_reg[cnt] <= 1;
				y_reg[cnt] <= 1;
			end
		end
		else if (array[13][13][0] != 1'b1)begin
			if(j >=13)begin
				step <= step + 1;
				a <= 0;
				for (a = 0;a < turn;a++)begin
					case(array[x_reg[a]][y_reg[a]][3:1])
						3'd0 : begin
								if(map[x_reg[a] + 1][y_reg[a]] == 0 && map[x_reg[a]][y_reg[a] + 1] == 0)begin
									x_reg[a] <= x_reg[a];
									y_reg[a] <= y_reg[a] + 1;
									x_reg[a + 1] <= x_reg[a] + 1;
									y_reg[a + 1] <= y_reg[a];
									array[x_reg[a] + 1][y_reg[a]] <= {3'd2,1'b1};
									array[x_reg[a]][y_reg[a] + 1] <= {3'd1,1'b1}; 
									turn <= turn + 1;
								end
								else if(map[x_reg[a] + 1][y_reg[a]] == 0)begin
									x_reg[a] <= x_reg[a] + 1;
									y_reg[a] <= y_reg[a];
									turn <= turn;
									array[x_reg[a] + 1][y_reg[a]] <= {3'd2,1'b1};
								end
								else if(map[x_reg[a]][y_reg[a] + 1] == 0)begin
									x_reg[a] <= x_reg[a];
									y_reg[a] <= y_reg[a] + 1;
									turn <= turn;
									array[x_reg[a]][y_reg[a] + 1] <= {3'd1,1'b1}; 
								end
								else 
									turn <= turn - 1;
							end							
						3'd1 : begin	
								if(map[x_reg[a] + 1][y_reg[a]] == 0 && map[x_reg[a]][y_reg[a] + 1] == 0 && map[x_reg[a] - 1][y_reg[a]] == 0)begin
									x_reg[a] <= x_reg[a];
									y_reg[a] <= y_reg[a] + 1;
									x_reg[a + 1] <= x_reg[a] + 1;
									y_reg[a + 1] <= y_reg[a];
									x_reg[a + 2] <= x_reg[a] - 1;
									y_reg[a + 2] <= y_reg[a];
									array[x_reg[a] + 1][y_reg[a]] <= {3'd2,1'b1};
									array[x_reg[a]][y_reg[a] + 1] <= {3'd1,1'b1}; 
									array[x_reg[a] - 1][y_reg[a]] <= {3'd4,1'b1}; 
									turn <= turn + 2;
								end
								else if(map[x_reg[a] + 1][y_reg[a]] == 0 && map[x_reg[a]][y_reg[a] + 1] == 0)begin
									x_reg[a] <= x_reg[a];
									y_reg[a] <= y_reg[a] + 1;
									x_reg[a + 1] <= x_reg[a] + 1;
									y_reg[a + 1] <= y_reg[a];
									array[x_reg[a] + 1][y_reg[a]] <= {3'd2,1'b1};
									array[x_reg[a]][y_reg[a] + 1] <= {3'd1,1'b1}; 
									turn <= turn + 1;
								end
								else if(map[x_reg[a] - 1][y_reg[a]] == 0 && map[x_reg[a]][y_reg[a] + 1] == 0)begin
									x_reg[a] <= x_reg[a];
									y_reg[a] <= y_reg[a] + 1;
									x_reg[a + 1] <= x_reg[a] - 1;
									y_reg[a + 1] <= y_reg[a];
									array[x_reg[a] - 1][y_reg[a]] <= {3'd4,1'b1};
									array[x_reg[a]][y_reg[a] + 1] <= {3'd1,1'b1}; 
									turn <= turn + 1;
								end
								else if(map[x_reg[a] + 1][y_reg[a]] == 0 && map[x_reg[a] - 1][y_reg[a]] == 0)begin
									x_reg[a] <= x_reg[a] + 1;
									y_reg[a] <= y_reg[a];
									x_reg[a + 1] <= x_reg[a] - 1;
									y_reg[a + 1] <= y_reg[a];
									array[x_reg[a] + 1][y_reg[a]] <= {3'd2,1'b1};
									array[x_reg[a] - 1][y_reg[a]] <= {3'd4,1'b1}; 
									turn <= turn + 1;
								end
								else if(map[x_reg[a] + 1][y_reg[a]] == 0)begin
									x_reg[a] <= x_reg[a] + 1;
									y_reg[a] <= y_reg[a];
									turn <= turn;
									array[x_reg[a] + 1][y_reg[a]] <= {3'd2,1'b1};
								end
								else if(map[x_reg[a] - 1][y_reg[a]] == 0)begin
									x_reg[a] <= x_reg[a] - 1;
									y_reg[a] <= y_reg[a];
									turn <= turn;
									array[x_reg[a] - 1][y_reg[a]] <= {3'd4,1'b1};
								end
								else if(map[x_reg[a]][y_reg[a] + 1] == 0)begin
									x_reg[a] <= x_reg[a];
									y_reg[a] <= y_reg[a] + 1;
									turn <= turn;
									array[x_reg[a]][y_reg[a] + 1] <= {3'd1,1'b1};
								end
								else begin
									x_reg[a] <= 1;
									y_reg[a] <= 1;
									turn <= turn - 1;
								end
							end	
						3'd2 : begin
								if(map[x_reg[a] + 1][y_reg[a]] == 0 && map[x_reg[a]][y_reg[a] + 1] == 0 && map[x_reg[a]][y_reg[a] - 1] == 0)begin
									x_reg[a] <= x_reg[a];
									y_reg[a] <= y_reg[a] + 1;
									x_reg[a + 1] <= x_reg[a] + 1;
									y_reg[a + 1] <= y_reg[a];
									x_reg[a + 2] <= x_reg[a];
									y_reg[a + 2] <= y_reg[a] - 1;
									array[x_reg[a] + 1][y_reg[a]] <= {3'd2,1'b1};
									array[x_reg[a]][y_reg[a] + 1] <= {3'd1,1'b1}; 
									array[x_reg[a]][y_reg[a] - 1] <= {3'd3,1'b1}; 
									turn <= turn + 2;
								end
								else if(map[x_reg[a] + 1][y_reg[a]] == 0 && map[x_reg[a]][y_reg[a] + 1] == 0)begin
									x_reg[a] <= x_reg[a];
									y_reg[a] <= y_reg[a] + 1;
									x_reg[a + 1] <= x_reg[a] + 1;
									y_reg[a + 1] <= y_reg[a];
									array[x_reg[a] + 1][y_reg[a]] <= {3'd2,1'b1};
									array[x_reg[a]][y_reg[a] + 1] <= {3'd1,1'b1}; 
									turn <= turn + 1;
								end
								else if(map[x_reg[a]][y_reg[a] - 1] == 0 && map[x_reg[a]][y_reg[a] + 1] == 0)begin
									x_reg[a] <= x_reg[a];
									y_reg[a] <= y_reg[a] + 1;
									x_reg[a + 1] <= x_reg[a];
									y_reg[a + 1] <= y_reg[a] - 1;
									array[x_reg[a]][y_reg[a] - 1] <= {3'd3,1'b1};
									array[x_reg[a]][y_reg[a] + 1] <= {3'd1,1'b1}; 
									turn <= turn + 1;
								end
								else if(map[x_reg[a] + 1][y_reg[a]] == 0 && map[x_reg[a]][y_reg[a] - 1] == 0)begin
									x_reg[a] <= x_reg[a] + 1;
									y_reg[a] <= y_reg[a];
									x_reg[a + 1] <= x_reg[a];
									y_reg[a + 1] <= y_reg[a] - 1;
									array[x_reg[a] + 1][y_reg[a]] <= {3'd2,1'b1};
									array[x_reg[a]][y_reg[a] - 1] <= {3'd3,1'b1}; 
									turn <= turn + 1;
								end
								else if(map[x_reg[a] + 1][y_reg[a]] == 0)begin
									x_reg[a] <= x_reg[a] + 1;
									y_reg[a] <= y_reg[a];
									turn <= turn;
									array[x_reg[a] + 1][y_reg[a]] <= {3'd2,1'b1};
								end
								else if(map[x_reg[a]][y_reg[a] - 1] == 0)begin
									x_reg[a] <= x_reg[a];
									y_reg[a] <= y_reg[a] - 1;
									turn <= turn;
									array[x_reg[a]][y_reg[a] - 1] <= {3'd3,1'b1};
								end
								else if(map[x_reg[a]][y_reg[a] + 1] == 0)begin
									x_reg[a] <= x_reg[a];
									y_reg[a] <= y_reg[a] + 1;
									turn <= turn;
									array[x_reg[a]][y_reg[a] + 1] <= {3'd1,1'b1};
								end
								else 
									x_reg[a] <= 1;
									y_reg[a] <= 1;
									turn <= turn - 1;
							end	
						3'd3 : begin	
								if(map[x_reg[a] + 1][y_reg[a]] == 0 && map[x_reg[a]][y_reg[a] - 1] == 0 && map[x_reg[a] - 1][y_reg[a]] == 0)begin
									x_reg[a] <= x_reg[a];
									y_reg[a] <= y_reg[a] - 1;
									x_reg[a + 1] <= x_reg[a] + 1;
									y_reg[a + 1] <= y_reg[a];
									x_reg[a + 2] <= x_reg[a] - 1;
									y_reg[a + 2] <= y_reg[a];
									array[x_reg[a] + 1][y_reg[a]] <= {3'd2,1'b1};
									array[x_reg[a]][y_reg[a] - 1] <= {3'd3,1'b1}; 
									array[x_reg[a] - 1][y_reg[a]] <= {3'd4,1'b1}; 
									turn <= turn + 2;
								end
								else if(map[x_reg[a] + 1][y_reg[a]] == 0 && map[x_reg[a]][y_reg[a] - 1] == 0)begin
									x_reg[a] <= x_reg[a];
									y_reg[a] <= y_reg[a] - 1;
									x_reg[a + 1] <= x_reg[a] + 1;
									y_reg[a + 1] <= y_reg[a];
									array[x_reg[a] + 1][y_reg[a]] <= {3'd2,1'b1};
									array[x_reg[a]][y_reg[a] - 1] <= {3'd3,1'b1}; 
									turn <= turn + 1;
								end
								else if(map[x_reg[a] - 1][y_reg[a]] == 0 && map[x_reg[a]][y_reg[a] - 1] == 0)begin
									x_reg[a] <= x_reg[a];
									y_reg[a] <= y_reg[a] - 1;
									x_reg[a + 1] <= x_reg[a] - 1;
									y_reg[a + 1] <= y_reg[a];
									array[x_reg[a] - 1][y_reg[a]] <= {3'd4,1'b1};
									array[x_reg[a]][y_reg[a] - 1] <= {3'd3,1'b1}; 
									turn <= turn + 1;
								end
								else if(map[x_reg[a] + 1][y_reg[a]] == 0 && map[x_reg[a] - 1][y_reg[a]] == 0)begin
									x_reg[a] <= x_reg[a] + 1;
									y_reg[a] <= y_reg[a];
									x_reg[a + 1] <= x_reg[a] - 1;
									y_reg[a + 1] <= y_reg[a];
									array[x_reg[a] + 1][y_reg[a]] <= {3'd2,1'b1};
									array[x_reg[a] - 1][y_reg[a]] <= {3'd4,1'b1};
									turn <= turn + 1;
								end
								else if(map[x_reg[a] + 1][y_reg[a]] == 0)begin
									x_reg[a] <= x_reg[a] + 1;
									y_reg[a] <= y_reg[a];
									turn <= turn;
									array[x_reg[a] + 1][y_reg[a]] <= {3'd2,1'b1};
								end
								else if(map[x_reg[a] - 1][y_reg[a]] == 0)begin
									x_reg[a] <= x_reg[a] - 1;
									y_reg[a] <= y_reg[a];
									turn <= turn;
									array[x_reg[a] - 1][y_reg[a]] <= {3'd4,1'b1};
								end
								else if(map[x_reg[a]][y_reg[a] - 1] == 0)begin
									x_reg[a] <= x_reg[a];
									y_reg[a] <= y_reg[a] - 1;
									turn <= turn;
									array[x_reg[a]][y_reg[a] - 1] <= {3'd3,1'b1}; 
								end
								else 
									x_reg[a] <= 1;
									y_reg[a] <= 1;
									turn <= turn - 1;
							end
						3'd4 : begin
								if(map[x_reg[a] - 1][y_reg[a]] == 0 && map[x_reg[a]][y_reg[a] + 1] == 0 && map[x_reg[a]][y_reg[a] - 1] == 0)begin
									x_reg[a] <= x_reg[a];
									y_reg[a] <= y_reg[a] + 1;
									x_reg[a + 1] <= x_reg[a] - 1;
									y_reg[a + 1] <= y_reg[a];
									x_reg[a + 2] <= x_reg[a];
									y_reg[a + 2] <= y_reg[a] - 1;
									array[x_reg[a] - 1][y_reg[a]] <= {3'd4,1'b1};
									array[x_reg[a]][y_reg[a] + 1] <= {3'd1,1'b1}; 
									array[x_reg[a]][y_reg[a] - 1] <= {3'd3,1'b1}; 
									turn <= turn + 2;
								end
								else if(map[x_reg[a] - 1][y_reg[a]] == 0 && map[x_reg[a]][y_reg[a] + 1] == 0)begin
									x_reg[a] <= x_reg[a];
									y_reg[a] <= y_reg[a] + 1;
									x_reg[a + 1] <= x_reg[a] - 1;
									y_reg[a + 1] <= y_reg[a];
									array[x_reg[a] - 1][y_reg[a]] <= {3'd4,1'b1};
									array[x_reg[a]][y_reg[a] + 1] <= {3'd1,1'b1}; 
									turn <= turn + 1;
								end
								else if(map[x_reg[a]][y_reg[a] - 1] == 0 && map[x_reg[a]][y_reg[a] + 1] == 0)begin
									x_reg[a] <= x_reg[a];
									y_reg[a] <= y_reg[a] + 1;
									x_reg[a + 1] <= x_reg[a];
									y_reg[a + 1] <= y_reg[a] - 1;
									array[x_reg[a]][y_reg[a] - 1] <= {3'd3,1'b1};
									array[x_reg[a]][y_reg[a] + 1] <= {3'd1,1'b1}; 
									turn <= turn + 1;
								end
								else if(map[x_reg[a] - 1][y_reg[a]] == 0 && map[x_reg[a]][y_reg[a] - 1] == 0)begin
									x_reg[a] <= x_reg[a] - 1;
									y_reg[a] <= y_reg[a];
									x_reg[a + 1] <= x_reg[a];
									y_reg[a + 1] <= y_reg[a] - 1;
									array[x_reg[a] - 1][y_reg[a]] <= {3'd4,1'b1};
									array[x_reg[a]][y_reg[a] - 1] <= {3'd3,1'b1};
									turn <= turn + 1;
								end
								else if(map[x_reg[a] - 1][y_reg[a]] == 0)begin
									x_reg[a] <= x_reg[a] - 1;
									y_reg[a] <= y_reg[a];
									turn <= turn;
									array[x_reg[a] - 1][y_reg[a]] <= {3'd4,1'b1};
								end
								else if(map[x_reg[a]][y_reg[a] - 1] == 0)begin
									x_reg[a] <= x_reg[a];
									y_reg[a] <= y_reg[a] - 1;
									turn <= turn;
									array[x_reg[a]][y_reg[a] - 1] <= {3'd3,1'b1};
								end
								else if(map[x_reg[a]][y_reg[a] + 1] == 0)begin
									x_reg[a] <= x_reg[a];
									y_reg[a] <= y_reg[a] + 1;
									turn <= turn;
									array[x_reg[a]][y_reg[a] + 1] <= {3'd1,1'b1};
								end
								else 
									x_reg[a] <= 1;
									y_reg[a] <= 1;
									turn <= turn - 1;
							end
							default : begin
										x_reg[a] <= 1;
										y_reg[a] <= 1;
										turn <= turn - 1;
									end
					endcase
				end
			end
			else begin
				a <= 0;
				turn <= 1;
				step <= step;
			end
		end
		else begin	
			a <= 0;
			turn <= 1;
			step <= step;
		end
	end
end

//array[3:1](direction)
//1 from upward
//2 from left
//3 from downward
//4 form right
				
always_ff @ (posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		out_valid <= 0;
		maze_not_valid <= 0;
		out_x <= 0;
		out_y <= 0;
		x <= 13;
		y <= 13;
		out_cnt <= 0;
	end
	else begin
		if(turn == 0)begin
			out_valid <= 0;
			maze_not_valid <= 0;
			out_x <= 0;
			out_y <= 0;
		end
		else begin
			if (out_x == 1 && out_y == 1)begin
				out_valid <= 0;
				maze_not_valid <= 1;
				out_x <= 0;
				out_y <= 0;
				out_cnt <= 0;
			end
			else if (array[13][13][0] == 1'b1 && !in_valid)begin
				if(out_cnt)begin
					out_valid <= 1;
					out_x <= x;
					out_y <= y;
					case(array[x][y][3:1])
						3'd0 : begin
								x <= x;
								y <= y;
							end
						3'd1 : begin
								x <= x;
								y <= y - 1;
							end
						3'd2 : begin
								x <= x - 1;
								y <= y;
							end
						3'd3 : begin
								x <= x;
								y <= y + 1;
							end
						3'd4 : begin
								x <= x + 1;
								y <= y;
							end
							default : begin
										x <= x;
										y <= y;
										maze_not_valid <= 1;
									end
					endcase
				end
				else begin
					out_cnt <= 1;
					out_valid <= 1;
					out_x <= step;
					out_y <= step;
				end
			end
			else begin
				out_valid <= 0;
				maze_not_valid <= 1;
				out_x <= 0;
				out_y <= 0;
			end
		end
	end
end

endmodule
					
						
				