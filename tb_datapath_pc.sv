`timescale 1ns/1ns
module tb_datapath_pc;

    // --- Sinais ---
    logic clk, reset;
    logic memtoreg, pcsrc, alusrc, regdst, regwrite, jump, jr;
    logic [2:0] alucontrol;
    logic zeroNzero;
    logic [31:0] pc;
    logic [31:0] instr; // Não inicialize aqui, faremos no initial
    logic [31:0] aluout, writedata;
    logic [31:0] readdata = 0;
    
    // --- Instância do Datapath (DUT) ---
    datapath dut(
        .clk(clk),
        .reset(reset),
        .memtoreg(memtoreg),
        .pcsrc(pcsrc),
        .alusrc(alusrc),
        .regdst(regdst),
        .regwrite(regwrite),
        .jump(jump),
        .jr(jr),
        .alucontrol(alucontrol),
        .zeroNzero(zeroNzero),
        .pc(pc),
        .instr(instr),
        .aluout(aluout),
        .writedata(writedata),
        .readdata(readdata)
    );
    
    // --- Gerador de Clock ---
    always begin
        clk = 0; #5;
        clk = 1; #5;
    end
    
    // --- Bloco de Testes ---
    initial begin
        // --- Estado Inicial e Reset ---
        reset = 1;
        instr = 32'h00000000; // NOP
        memtoreg = 0; pcsrc = 0; alusrc = 0; regdst = 0;
        regwrite = 0; jump = 0; jr = 0; alucontrol = 3'b010; // ADD
        #10; // Espera um ciclo para o reset propagar
        
        // Teste 1: Reset
        $display("Reset: PC = %h (Esperado: 00000000)", pc);
        
        // --- Testes Sequenciais ---
        reset = 0;
        #10;
        $display("Ciclo 1: PC = %h (Esperado: 00000004)", pc);
        
        #10;
        $display("Ciclo 2: PC = %h (Esperado: 00000008)", pc);
        
        // --- Teste 4: Jump ---
        // PC está em 0x08. pcplus4 será 0x0C.
        jump = 1;
        instr = 32'h0800000A; // j 0x0A (endereço alvo 0x28)
        #10;
        $display("Jump: PC = %h (Esperado: 00000028)", pc);
        jump = 0; // Desliga o jump para o próximo ciclo

        // --- Teste 5: Branch ---
        // PC em 0x28. pcplus4 = 0x2C.
        // O offset e -4 (FFFC), shiftado, vira -16 (FFFFFFF0)
        // Endereço do branch = 0x2C + (-16) = 0x1C
        pcsrc = 1; // Habilita a seleção do branch
        instr = 32'h1000FFFC; // beq $0, $0, -4
        #10;
        $display("Branch: PC = %h (Esperado: 0000001c)", pc);
        pcsrc = 0; // Desliga o pcsrc para o próximo ciclo

        // --- Teste 6: JR (Jump Register) ---
        // PC está em 0x1C.
        // PASSO 6.1: Precisamos primeiro ESCREVER o endereço de pulo em um registrador.
        // Vamos escrever 0x100 no registrador $t0 (reg 8) usando 'addi $t0, $zero, 0x100'
        $display("--- Preparando para o JR: Escrevendo 0x100 em $t0 ---");
        regwrite = 1;     // Habilita escrita no registrador
        alusrc = 1;       // Usa o imediato como fonte da ALU
        regdst = 0;       // Escreve no registrador 'rt' ($t0)
        alucontrol = 3'b010; // Operação de ADD
        instr = 32'h20080100; // addi $t0, $zero, 0x100
        #10; // Deixa o ciclo de clock completar a escrita

        // Agora o PC está em 0x20 e o registrador $t0 contém 0x100.
        $display("PC apos ADDI: %h (Esperado: 00000020)", pc);

        // PASSO 6.2: Agora, com o valor em $t0, EXECUTAMOS o JR.
        $display("--- Executando JR $t0 ---");
        regwrite = 0;     // Desabilita escrita
        alusrc = 0;       // ALU usa registrador como fonte
        jr = 1;           // Habilita o controle do JR
        instr = 32'h01000008; // jr $t0 (lê registrador rs=8, que é $t0)
        #10; // Deixa o ciclo de clock completar o pulo
        
        $display("JR: PC = %h (Esperado: 00000100)", pc);
        
        $finish;
    end

endmodule