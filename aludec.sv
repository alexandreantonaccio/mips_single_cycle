module aludec(input  logic [5:0] funct,
              input  logic [1:0] aluop,
              output logic [2:0] alucontrol);

  always_comb
    case(aluop)
      2'b00: alucontrol <= 3'b010;   // add
      2'b01: alucontrol <= 3'b110;   // sub
        2'b11: alucontrol <= 3'b111; // slti
      default: case(funct)
          6'b000000: alucontrol <= 3'b011; // SLL
            6'b001000: alucontrol <= 3'bxxx; // JR
            6'b100000: alucontrol <= 3'b010; // add
          6'b100010: alucontrol <= 3'b110; // sub
          6'b100100: alucontrol <= 3'b000; // and
          6'b100101: alucontrol <= 3'b001; // or
          6'b101010: alucontrol <= 3'b111; // slt
          default:   alucontrol <= 3'bxxx;
        endcase
    endcase
endmodule