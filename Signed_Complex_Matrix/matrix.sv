module matrix(
    //Input 
    clk,
    rst_n,
    in_valid,
    in_real,
    in_image,
    //OUTPUT
    out_valid,
    out_real,
    out_image,
    busy
);

    //Input 
input clk;
input rst_n;
input in_valid;
input signed[6:0]in_real;
input signed[6:0]in_image;
    //OUTPUT
output logic out_valid;
output logic signed[8:0] out_real;
output logic signed[8:0] out_image;
output logic busy;

logic signed[6:0] ar [0:3];
logic signed[6:0] ai [0:3];
logic signed[6:0] br [0:3];
logic signed[6:0] bi [0:3];
logic signed[6:0] arr [0:3];
logic signed[6:0] air [0:3];
logic signed[6:0] brr [0:3];
logic signed[6:0] bir [0:3];
logic signed[6:0] r [0:3];
logic signed[6:0] i [0:3];
logic [2:0] cnt_r,cnt_i,j,jr,zero;
logic l,lr;
logic signed [14:0] out_r;
logic signed [14:0] out_i;

always_ff @ (posedge clk or negedge rst_n)begin
	if(~rst_n)begin
		busy <= 0;
		l <= 0;
		zero <= 0;
	end
	else begin
		busy <= 0;
		if(in_valid)begin
			case(cnt_r)
				0 : ar[0] <= in_real;
				1 : ar[1] <= in_real;
				2 : ar[2] <= in_real;
				3 : ar[3] <= in_real;
				4 : br[0] <= in_real;
				5 : br[1] <= in_real;
				6 : br[2] <= in_real;
				7 : br[3] <= in_real;
			endcase
			case(cnt_i)
				0 : ai[0] <= in_image;
				1 : ai[1] <= in_image;
				2 : ai[2] <= in_image;
				3 : ai[3] <= in_image;
				4 : bi[0] <= in_image;
				5 : bi[1] <= in_image;
				6 : bi[2] <= in_image;
				7 : bi[3] <= in_image;
			endcase
			if (cnt_r == 7 && cnt_i ==7)begin
				cnt_r <= 0;
				cnt_i <= 0;
				l <= 1;
			end
			else begin
				cnt_r <= cnt_r + 1;
				cnt_i <= cnt_i + 1;
			end
		end
		else begin
			cnt_r <= 0;
			cnt_i <= 0;
			if (out_valid) 
				zero <= zero + 1;
			else 
				zero <= zero;
		end
	end
end
			
always_ff @ (posedge clk or negedge rst_n)begin
	if(~rst_n)begin
		j <= 0;
		lr <= 0;
	end
	else begin
		lr <= l;
		if(l)begin
			case (j)
				0 : begin
					r <= r;
					i <= i;
					arr <= ar;
					air <= ai;
					brr <= br;
					bir <= bi;
					end
				1 : begin
					r[0] <= arr[0];
					r[1] <= arr[1];
					r[2] <= brr[0];
					r[3] <= brr[2];
					i[0] <= air[0];
					i[1] <= air[1];
					i[2] <= bir[0];
					i[3] <= bir[2];
					end
				2 : begin
					r <= r;
					i <= i;
					end
				3 : begin
					r[0] <= arr[0];
					r[1] <= arr[1];
					r[2] <= brr[1];
					r[3] <= brr[3];
					i[0] <= air[0];
					i[1] <= air[1];
					i[2] <= bir[1];
					i[3] <= bir[3];
					end
				4 : begin
					r <= r;
					i <= i;
					end
				5 : begin
					r[0] <= arr[2];
					r[1] <= arr[3];
					r[2] <= brr[0];
					r[3] <= brr[2];
					i[0] <= air[2];
					i[1] <= air[3];
					i[2] <= bir[0];
					i[3] <= bir[2];
					end
				6 : begin
					r <= r;
					i <= i;
					end
				7 : begin
					r[0] <= arr[2];
					r[1] <= arr[3];
					r[2] <= brr[1];
					r[3] <= brr[3];
					i[0] <= air[2];
					i[1] <= air[3];
					i[2] <= bir[1];
					i[3] <= bir[3];
					end
			endcase
			if(j == 7)
				j <= 0;
			else 
				j <= j + 1;
		end
		else begin
			r <= r;
			i <= i;
		end
	end
end
		
always_comb begin
	out_r = r[0]*r[2] - i[0]*i[2] + r[1]*r[3] - i[1]*i[3];
	out_i = r[0]*i[2] + i[0]*r[2] + r[1]*i[3] + i[1]*r[3];
end

always_ff @ (posedge clk or negedge rst_n)begin
	if(~rst_n)begin
		out_valid <= 0;
		out_image <= 0;
		out_real <= 0;
	end
	else begin
		if(lr)begin
			if (zero >= 5)begin
				out_valid <= 0;
				out_real <= 0;
				out_image <= 0;
			end
			else if(j % 2 == 0)begin
				out_valid <= 1;
				out_real <= out_r[14:6];
				out_image <= out_i[14:6];
			end
			else begin
				out_valid <= 0;
				out_real <= 0;
				out_image <= 0;
			end
		end
		else begin
			out_valid <= 0;
			out_real <= 0;
			out_image <= 0;
		end
	end	
end

endmodule