module top(
  input clk_25mhz,
  output [2:0] ca,
  output a,
  output b,
  output c,
  output d,
  output e,
  output f,
  output g
);


initial 
begin
    ca = 3'b110;
end


reg [36:0] timer;

wire [11:0] val;

always @(posedge clk_25mhz) 
begin
  timer <= timer + 1;
  if (timer >= 2500000) //0.1s
  begin
    val <= val + 1;
    timer <= 0;
  end
    

end 


wire [3:0] dig = (ca == 'b011 ? val[11:8] : ca == 'b101 ? val[7:4] : val[3:0]);
reg clear;

h27seg hex (
 .hex(dig),
 .erase(clear),
 .s7({g, f, e, d, c, b, a})
);

reg [17:0] count;

always @(posedge clk_25mhz) begin
    count <= count + 1;
  if(count[17]) begin
    count <= 0;
    ca <= {ca[1:0], ca[2]};
  end
end

always @(ca)
begin
  case(ca)
    3'b110 : clear <= 0;
    3'b101 : clear <= ~|val[11:4]; //equivalent to mod 16 in base 2
    3'b011 : clear <= ~|val[11:8]; //equivalent to mod 256 in base 2
    default : clear <= 0;
  endcase
end

endmodule

