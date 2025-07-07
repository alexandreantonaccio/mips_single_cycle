module alu(input  logic [31:0] a, b,
           input  logic [4:0]  shamt,
           input  logic [2:0]  alucontrol,
           output logic [31:0] result,
           output logic        zero,
           output logic        notzero);

  always_comb begin
    case(alucontrol)
      3'b010: result = a + b;
      3'b110: result = a - b;
      3'b000: result = a & b;
      3'b001: result = a | b;
      3'b111: result = (a < b) ? 1 : 0;
      3'b011: result = a << shamt;
      default: result = 32'bx;
    endcase
	 // Adicione esta linha dentro do always_comb do seu alu.sv
$display("ALU DEBUG: srca=%h, srcb=%h, alucontrol=%b, result=%h", a, b, alucontrol, a + b);
  end

  assign zero = (result == 32'b0);
  assign notzero = (result != 32'b0);
endmodule