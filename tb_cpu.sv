`timescale 1ns/1ps

module tb_cpu();

    logic clk, reset;
    logic [31:0] writedata, dataadr;
    logic memwrite;

    mips_sc_org dut (
        .clk(clk),
        .reset(reset),
        .writedata(writedata),
        .dataadr(dataadr),
        .memwrite(memwrite)
    );

    always begin
        clk = 1; #5;
        clk = 0; #5;
    end

    initial begin
        // --- SETUP ---
        // ALTERADO: Carrega o novo programa para a imem. A dmem continua a mesma.
        $readmemh("teste_sw_addr0.txt", dut.imem.RAM);
        $readmemh("data.txt", dut.dmem.RAM);

        // --- RESET ---
        reset = 1;
        #15;
        
        // --- INÍCIO DA EXECUÇÃO E VERIFICAÇÃO INICIAL ---
        reset = 0;
        #1;

        $display("\n=======================================================");
        // ALTERADO: Verifica o endereço 0x00 (índice 0)
        $display("--- Valor INICIAL em dmem[0x00]: %d (0x%h)", dut.dmem.RAM[0], dut.dmem.RAM[0]);
        $display("=======================================================\n");

        // --- ESPERA DETERMINÍSTICA PELA FINALIZAÇÃO ---
        // ALTERADO: O novo programa para em PC=0x08
        wait (dut.pc == 32'h00000008);
        #10;
        
        // --- VERIFICAÇÃO FINAL ---
        $display("\n=======================================================");
        $display("--- Programa Finalizado (PC=%h) ---", dut.pc);
        // ALTERADO: Verifica o endereço 0x00 (índice 0) novamente
        $display("--- Valor FINAL em dmem[0x00]: %d (0x%h)", dut.dmem.RAM[0], dut.dmem.RAM[0]);

        // ALTERADO: Verifica se o valor final é 999
        if (dut.dmem.RAM[0] == 999) begin
            $display(">>> SUCESSO: O valor 999 foi escrito corretamente na memoria!");
        end else begin
            $display(">>> FALHA: O valor na memoria eh diferente do esperado!");
        end
        $display("=======================================================\n");

        $finish;
    end

    // Bloco de monitoramento
    initial begin
        forever @(negedge clk) begin
            if (!reset && dut.pc < 32'h00000008) begin
                $display("PC=0x%h | $t0(val)=%d | memwrite=%b",
                    dut.pc,
                    dut.cpu.dp.rf.rf[8],  // Registrador $t0
                    dut.memwrite
                );
            end
        end
    end

endmodule