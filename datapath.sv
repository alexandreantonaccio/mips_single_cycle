module datapath(input  logic       clk, reset,
                input  logic       memtoreg, pcsrc,
                input  logic       alusrc, regdst,
                input  logic       regwrite, jump, jr, jal, // Adicionado jal
                input  logic [2:0] alucontrol,
                output logic       zeroNzero,
                output logic [31:0] pc,
                input  logic [31:0] instr,
                output logic [31:0] aluout, writedata,
                input  logic [31:0] readdata);

  logic [4:0]  writereg_mux, writereg;
  logic [31:0] pcnext, pcnextbr, pcplus4, pcbranch, pcjump;
  logic [31:0] signimmsh;
  logic [31:0] srca, srcb;
  logic [31:0] result, result_final; // 'result' renomeado para 'result_final'
  logic [31:0] signimm;
  assign signimm = {{16{instr[15]}}, instr[15:0]};

  flopr #(32) pcreg(clk, reset, pcnext, pc);
  adder       pcadd1(pc, 32'b100, pcplus4);
  shifter immsh(
      .a        (signimm),
      .shamt    (5'd2),
      .direction(1'b1),
      .y        (signimmsh)
    );
  adder       pcadd2(pcplus4, signimmsh, pcbranch);
  mux2 #(32)  pcbrmux(pcplus4, pcbranch, pcsrc, pcnextbr);
  mux2 #(32)  pcjumpmux({pcplus4[31:28], instr[25:0], 2'b00},
                        srca,
                        jr,
                        pcjump);
  // O sinal de jump agora também é ativado por 'jal'
  mux2 #(32)  pcmux(pcnextbr, pcjump, jump | jr | jal, pcnext);

  // MUX para selecionar o dado a ser escrito no registrador: resultado da ALU/memória ou PC+4
  mux2 #(32)  jalmux(result_final, pcplus4, jal, result);

  regfile     rf(.clk(clk), .reset(reset), .we3(regwrite), // Conecte o reset
                 .ra1(instr[25:21]), .ra2(instr[20:16]), .wa3(writereg), 
                 .wd3(result), .rd1(srca), .rd2(writedata));

  // MUX original para selecionar entre Rt e Rd
  mux2 #(5)   wrmux_orig(instr[20:16], instr[15:11],
                        regdst, writereg_mux);
  
  // Novo MUX para selecionar o registrador de destino: o da instrução ou $ra (31) para JAL
  mux2 #(5)   wrmux_jal(writereg_mux, 5'b11111, jal, writereg);

  mux2 #(32)  resmux(aluout, readdata, memtoreg, result_final);

  mux2 #(32)  srcbmux(writedata, signimm, alusrc, srcb);
  alu         alu(srca, srcb, instr[10:6], alucontrol, aluout, zero, notzero);

  muxBEQBNE muxBEQBNE (
      .BeqBne   (instr[26]),
      .zero     (zero),
      .notzero  (notzero),
      .zeroNzero(zeroNzero)
  );
endmodule