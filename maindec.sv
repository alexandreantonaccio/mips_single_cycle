module maindec(input  logic [5:0] op, funct, // Adicionado funct como input
               output logic       memtoreg, memwrite,
               output logic       branch, alusrc,
               output logic       regdst, regwrite,
               output logic       jump, jr, jal,
               output logic [1:0] aluop);

  logic [10:0] controls;

  assign {regwrite, regdst, alusrc, branch, memwrite,
          memtoreg, jump, jr, jal, aluop} = controls;

  always_comb
    case(op)
      // --- INÍCIO DA ALTERAÇÃO ---
      6'b000000: // Instrução Tipo-R
        if (funct == 6'b001000) // É um JR? (funct code para JR é 0x08)
          // Controles para JR: jr=1, regwrite=0, o resto é 0 ou don't care
          controls <= 11'b00000001000;
        else
          // Controles para outras instruções Tipo-R (add, sub, etc.)
          controls <= 11'b11000000010;
      // --- FIM DA ALTERAÇÃO ---

      6'b100011: controls <= 11'b10100100000; // LW
      6'b101011: controls <= 11'b00101000000; // SW
      6'b000100: begin
                  controls <= 11'b00010000001; // BEQ
                  $display("BEQ");
                end
      6'b000101: begin
                  controls <= 11'b00010000001; // BNE
                  $display("BNE");
                end
      6'b001010: controls <= 11'b10100000011; // SLTI
      6'b001000: controls <= 11'b10100000000; // ADDI
      6'b000010: controls <= 11'b00000010000; // J
      6'b000011: controls <= 11'b10000010100; // JAL
      default:   controls <= 11'bxxxxxxxxxxx;
    endcase
endmodule