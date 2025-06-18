module maindec(input  logic [5:0] op,
               output logic       memtoreg, memwrite,
               output logic       branch, alusrc,
               output logic       regdst, regwrite,
               output logic       jump, jr,
               output logic [1:0] aluop);

  logic [9:0] controls;

  assign {regwrite, regdst, alusrc, branch, memwrite,
          memtoreg, jump,jr, aluop} = controls;

  always_comb
    case(op)
      6'b000000: controls <= 10'b1100000010; // RTYPE
      6'b100011: controls <= 10'b1010010000; // LW
      6'b101011: controls <= 10'b0010100000; // SW
      6'b000100: begin
            controls <= 10'b0001000001; // BEQ
            $display("BEQ");
        end
        6'b000101: begin
            controls <= 10'b0001000001; // BNE
            $display("BNE");
        end
      6'b001010: controls <= 10'b1010000011; // SLTI 
        6'b001000: controls <= 10'b1010000000; // ADDI
      6'b000010: controls <= 10'b0000001000; // J
      default:   controls <= 10'bxxxxxxxxx;
    endcase
endmodule