module controller(input  logic [5:0] op, funct,
                  input  logic       zeroNzero,
                  output logic       memtoreg, memwrite,
                  output logic       pcsrc, alusrc,
                  output logic       regdst, regwrite,
                  output logic       jump, jr,
                  output logic [2:0] alucontrol);

  logic [1:0] aluop;
  logic       branch;

  maindec md(op, memtoreg, memwrite, branch,
             alusrc, regdst, regwrite, jump, jr, aluop);
  aludec  ad(funct, aluop, alucontrol);

  assign pcsrc = branch & zeroNzero;
endmodule