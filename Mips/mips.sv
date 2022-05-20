module mips(
    // Input signals
    instruction,
    // Output signals
    out
);

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
input [31:0] instruction;

output logic [6:0] out;

//---------------------------------------------------------------------
//   Logic DECLARATION                         
//---------------------------------------------------------------------
logic [15:0] rs_out,rt_out;
logic [16:0] op;
//---------------------------------------------------------------------a
//   Your design                        
//---------------------------------------------------------------------
register_file_for_rs rs1(.read_port(rs_out),.address(instruction[25:21]));
register_file_for_rt rt1(.read_port(rt_out),.address(instruction[20:16]));
always @(instruction,rs_out,rt_out) begin      	
	if (instruction[29] == 0) begin
    	case(instruction[5:0])
		6'b100000 : op = rs_out + rt_out;
		6'b100100 : op = rs_out & rt_out;
		6'b100101 : op = rs_out | rt_out;
        6'b100111 : op = ~(rs_out | rt_out);
        6'b000000 : op = rt_out << (instruction[10:6]);
		6'b000010 : op = rt_out >> (instruction[10:6]);
            default : op = 0;
        endcase
    end
    else  op = rs_out + instruction [15:0];
    case(op[3:0])
    4'd0 : out = 7'b1111110;
    4'd1 : out = 7'b0110000;
    4'd2 : out = 7'b1101101;
    4'd3 : out = 7'b1111001;
    4'd4 : out = 7'b0110011;
    4'd5 : out = 7'b1011011;
    4'd6 : out = 7'b1011111;
    4'd7 : out = 7'b1110000;
    4'd8 : out = 7'b1111111;
    4'd9 : out = 7'b1111011;
    4'd10 : out = 7'b1110111;
    4'd11 : out = 7'b0011111;
    4'd12 : out = 7'b1001110;
    4'd13 : out = 7'b0111101;
    4'd14 : out = 7'b1001111;
    4'd15 : out = 7'b1000111;
        default : out = 0;
    endcase
end
endmodule



//---------------------------------------------------------------------
//   Register design from TA (RS)                        
//---------------------------------------------------------------------
module register_file_for_rs(
    address,
    read_port
);
input [4:0] address;
output logic [15:0] read_port;

always_comb begin
    case(address)
    5'b01101:read_port = 32'd12;
    5'b01110:read_port = 32'd38;
    5'b10001:read_port = 32'd27;
    5'b10010:read_port = 32'd150;
    5'b11011:read_port = 32'd379;
    5'b11101:read_port = 32'd142;
    5'b11111:read_port = 32'd1508;
    default: read_port = 0;
    endcase
end

endmodule

//---------------------------------------------------------------------
//   Register design from TA (RT)                        
//---------------------------------------------------------------------
module register_file_for_rt(
    address,
    read_port
);
input [4:0] address;
output logic [15:0] read_port;

always_comb begin
    case(address)
    5'b01101:read_port = 32'd12;
    5'b01110:read_port = 32'd38;
    5'b10001:read_port = 32'd27;
    5'b10010:read_port = 32'd150;
    5'b11011:read_port = 32'd379;
    5'b11101:read_port = 32'd142;
    5'b11111:read_port = 32'd1508;
    default: read_port = 0;
    endcase
end

endmodule
