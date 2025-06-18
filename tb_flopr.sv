module tb_flopr;
    logic clk, reset;
    logic [31:0] d, q;
    
    flopr #(32) dut (.clk(clk), .reset(reset), .d(d), .q(q));
    
    // Gerador de clock
    always begin
        $display("-----------------------------------");
        $display("[CLK] Clock baixo");
        clk = 0; #5;
        $display("[CLK] Clock alto");
        clk = 1; #5;
    end
    
    initial begin
        $display("===================================");
        $display(" INÍCIO DO TESTE PARA FLOPR (PC)");
        $display("===================================");
        
        // Teste 1: Reset
        reset = 1;
        d = 32'h12345678;
        $display("\n[TESTE 1] Reset ativo");
        $display("Entradas: reset=%b, d=%h", reset, d);
        #10;
        $display("Saída: q=%h", q);
        assert(q === 32'h0) else $error("Reset falhou");
        
        // Teste 2: Carregamento normal
        reset = 0;
        $display("\n[TESTE 2] Carregamento normal");
        $display("Entradas: reset=%b, d=%h", reset, d);
        #10;
        $display("Saída: q=%h", q);
        assert(q === 32'h12345678) else $error("Carregamento falhou");
        
        // Teste 3: Novo valor
        d = 32'hABCDEF01;
        $display("\n[TESTE 3] Novo valor");
        $display("Entradas: d=%h", d);
        #10;
        $display("Saída: q=%h", q);
        assert(q === 32'hABCDEF01) else $error("Atualização falhou");
        
        // Teste 4: Reset assíncrono
        d = 32'hDEADBEEF;
        $display("\n[TESTE 4] Reset assíncrono");
        $display("Entradas: d=%h", d);
        #5;
        reset = 1;
        $display("Ativando reset durante ciclo");
        #5;
        $display("Saída: q=%h", q);
        assert(q === 32'h0) else $error("Reset assíncrono falhou");
        
        $display("\n===================================");
        $display(" TODOS OS TESTES DO FLOPR PASSARAM!");
        $display("===================================");
        $finish;
    end
endmodule