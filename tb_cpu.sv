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

        // --- RESET ---
        reset = 1;
        #15;
        
        // --- INICIO DA EXECUÇÃO E VERIFICAÇÃO INICIAL ---
        reset = 0;
        #1;

        //$display("\n=======================================================");
        // ALTERADO: Verifica o endereco 0x00 (índice 0)
        //$display("--- Valor INICIAL em dmem[0x00]: %d (0x%h)", dut.dmem.RAM[0], dut.dmem.RAM[0]);
        //$display("=======================================================\n");

        // --- ESPERA DETERMINÍSTICA PELA FINALIZAÇÃO ---
        // ALTERADO: O novo programa para em PC=0x08
        //wait (dut.pc == 32'h00000008);
        #1000;
        
        // --- VERIFICAÇÃO FINAL ---
        //$display("\n=======================================================");
        //$display("--- Programa Finalizado (PC=%h) ---", dut.pc);
        // ALTERADO: Verifica o endereco 0x00 (indice 0) novamente
        //$display("--- Valor FINAL em dmem[0x00]: %d (0x%h)", dut.dmem.RAM[0], dut.dmem.RAM[0]);

        // ALTERADO: Verifica se o valor final é 999
        //if (dut.dmem.RAM[0] == 999) begin
        //    $display(">>> SUCESSO: O valor 999 foi escrito corretamente na memoria!");
        //end else begin
        //    $display(">>> FALHA: O valor na memoria eh diferente do esperado!");
        //end
        //$display("=======================================================\n");

        $finish;
    end

    // Bloco de monitoramento
    initial begin
    forever @(negedge clk) begin
				$display("pc =%h t0=%h t1=%h t2=%h t3=%h t4=%h t5=%h t6=%h t7=%h memwrite%b",
							dut.pc,               // pc
							dut.cpu.dp.rf.rf[8],  // $t0
							dut.cpu.dp.rf.rf[9],  // $t1
							dut.cpu.dp.rf.rf[10], // $t2
							dut.cpu.dp.rf.rf[11], // $t3
							dut.cpu.dp.rf.rf[12], // $t4
							dut.cpu.dp.rf.rf[13], // $t5
							dut.cpu.dp.rf.rf[14], // $t6
							dut.cpu.dp.rf.rf[15], // $t7
                dut.memwrite
            );
		 end
	end

endmodule