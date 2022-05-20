module mips_pipe(
  // Input signals
  clk,
  rst_n,
  in_valid,
  instruction,
  output_reg,
  // Output signals
  out_valid,
  intruction_fail,
  out_1,
  out_2,
  out_3
);

//---------------------------------------------------------------------
//   PORT DECLARATION
//---------------------------------------------------------------------
input clk,rst_n,in_valid;
input [31:0]instruction; 
input [14:0]output_reg; 
//---------------------------------------------------------------------
//   logic declaration
//---------------------------------------------------------------------
logic [31:0] instruction_f,instruction_ff;
logic fail_1,fail_2,fail_3,out_valid1,out_valid2,out_valid3;
logic [14:0] reg1,reg2,reg3;
logic [4:0] rs,rt;
logic [31:0] rs_ad,rt_ad,rt_op,rs_op,a1,a2,a3,a4,a5,a6,out_1c,out_2c,out_3c,op;
logic fail_11,fail_22,fail_33;


output logic out_valid,intruction_fail;
output logic [31:0] out_1,out_2,out_3;

// ff_1
always @(posedge clk or negedge rst_n)begin
  if(~rst_n)begin
    instruction_f <= 0;
    fail_1 <= 0;
    out_valid1 <= 0;
    reg1<= 0;
  end
  else begin
    instruction_f <= instruction;
    fail_1 <= 0;
    out_valid1 <= in_valid;
    reg1 <= output_reg;
  end
end

// com_A
always@(*) begin
  rs = instruction_f [25:21];
  rt = instruction_f [20:16];
  fail_11 = fail_1; 
  case (rs)
    5'b10001:rs_ad=a1;
    5'b10010:rs_ad=a2;
    5'b01000:rs_ad=a3;
    5'b10111:rs_ad=a4;
    5'b11111:rs_ad=a5;
    5'b10000:rs_ad=a6;
      default:begin
      rs_ad = 0;  
      fail_11 = 1;
      end
  endcase
  case (rt)
    5'b10001:rt_ad=a1;
    5'b10010:rt_ad=a2;
    5'b01000:rt_ad=a3;
    5'b10111:rt_ad=a4;
    5'b11111:rt_ad=a5;
    5'b10000:rt_ad=a6;
      default:begin
      rt_ad = 0;
      fail_11 = 1;
      end
  endcase
end

// ff_2
always @(posedge clk or negedge rst_n)begin
  if(~rst_n)begin
    reg2 <= 0;
    out_valid2 <= 0;
    fail_2 <= 0;
    rs_op <= 0;
    rt_op <= 0;
    instruction_ff <= 0;
  end
  else begin
    reg2 <= reg1;
    out_valid2 <= out_valid1;
    fail_2 <= fail_11;
    rs_op <= rs_ad;
    rt_op <= rt_ad;
    instruction_ff <= instruction_f;
  end
end

// com_B
always@(*) begin
  if (~fail_2)begin
    fail_22 = fail_2;
    if (instruction_ff[31:26]==6'b000000)begin
      case(instruction_ff[5:0])
        6'b100000:op=rs_op + rt_op;
        6'b100100:op=rs_op & rt_op;
        6'b100101:op=rs_op | rt_op;
        6'b100111:op=~(rs_op|rt_op);
        6'b000000:op=rt_op << instruction_ff[10:6];
        6'b000010:op=rt_op >> instruction_ff[10:6];
          default:begin
            op=0;
            fail_22=1;
          end
      endcase
    end
    else if (instruction_ff[31:26]==6'b001000) op = rs_op + instruction_ff[15:0];
    else begin
      op = 0;
      fail_22 = 1;
    end
  end
  else begin
    op = 0;
    fail_22 = 1;
  end  
end

// ff_3
always @(posedge clk or negedge rst_n)begin
  if (~rst_n)begin
    reg3 <= 0;
    out_valid3 <= 0;
    fail_3 <= 0;
    a1 <= 0;
    a2 <= 0;
    a3 <= 0;
    a4 <= 0;
    a5 <= 0;
    a6 <= 0;
  end
  else begin
    reg3 <= reg2;
    out_valid3 <= out_valid2;
    if (~fail_22)begin
      fail_3 <= fail_22;
      if (instruction_ff [31:26] == 6'b000000)begin
        case(instruction_ff[15:11])
          5'b10001:a1<=op;
          5'b10010:a2<=op;
          5'b01000:a3<=op;
          5'b10111:a4<=op;
          5'b11111:a5<=op;
          5'b10000:a6<=op;
            default:begin
              a1 <= a1;
              a2 <= a2;
              a3 <= a3;
              a4 <= a4;
              a5 <= a5;
              a6 <= a6;
              fail_3 <= 1;
            end
        endcase
      end
       else begin
         case(instruction_ff[20:16])
          5'b10001:a1<=op;
          5'b10010:a2<=op;
          5'b01000:a3<=op;
          5'b10111:a4<=op;
          5'b11111:a5<=op;
          5'b10000:a6<=op;
            default:begin
              a1 <= a1;
              a2 <= a2;
              a3 <= a3;
              a4 <= a4;
              a5 <= a5;
              a6 <= a6;
              fail_3 <= 1;
            end
        endcase
       end 
    end  
    else begin
      fail_3 <= 1;
    end
  end
end

// com_C
always @ (*) begin
  fail_33 = fail_3;
  case (reg3[14:10])
    5'b10001:out_3c=a1;
    5'b10010:out_3c=a2;
    5'b01000:out_3c=a3;
    5'b10111:out_3c=a4;
    5'b11111:out_3c=a5;
    5'b10000:out_3c=a6;
      default:begin
        out_3c = 0;
        fail_33 = 1;
      end
  endcase
  case (reg3[9:5])
    5'b10001:out_2c=a1;
    5'b10010:out_2c=a2;
    5'b01000:out_2c=a3;
    5'b10111:out_2c=a4;
    5'b11111:out_2c=a5;
    5'b10000:out_2c=a6;
      default:begin
        out_2c = 0;
        fail_33 = 1;
      end
  endcase
  case (reg3[4:0])
    5'b10001:out_1c=a1;
    5'b10010:out_1c=a2;
    5'b01000:out_1c=a3;
    5'b10111:out_1c=a4;
    5'b11111:out_1c=a5;
    5'b10000:out_1c=a6;
      default:begin
        out_1c = 0;
        fail_33 = 1;
      end
  endcase
end

// ff_4
always @(posedge clk or negedge rst_n)begin
  if (~rst_n)begin
    out_valid <= 0;
    intruction_fail <= 0;
    out_1 <= 0;
    out_2 <= 0;
    out_3 <= 0;
  end
  else if (fail_33)begin
    out_valid <= out_valid3;
    intruction_fail <= 1;
    out_1 <= 0;
    out_2 <= 0;
    out_3 <= 0;
  end
  else begin
    out_valid <= out_valid3;
    intruction_fail <= 0;
    out_1 <= out_1c;
    out_2 <= out_2c;
    out_3 <= out_3c;
  end
end
endmodule
