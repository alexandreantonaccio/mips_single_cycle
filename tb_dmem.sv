module tb_dmem;
    logic clk, we;
    logic [31:0] a, wd;
    logic [31:0] rd;
    
    dmem dut (.clk(clk), .we(we), .a(a), .wd(wd), .rd(rd));
    
    // Gerador de clock
    always begin
        clk = 0; #5;
        clk = 1; #5;
    end
    
    initial begin
        $display("===================================");
        $display(" INÍCIO DO TESTE PARA DMEM");
        $display("===================================");
        
        we = 0;
        a = 0;
        wd = 0;
        
        // Teste 1: Leitura inicial
        #10;
        $display("\n[TESTE 1] Leitura inicial (memória não inicializada)");
        $display("Entradas: we=%b, a=%h, wd=%h", we, a, wd);
        $display("Saída: rd=%h", rd);
        assert($isunknown(rd)) else $error("Leitura inicial falhou");
        
        // Teste 2: Escrita e leitura
        we = 1;
        a = 4;  // Endereço 4 (word-aligned)
        wd = 32'hA5A5A5A5;
        $display("\n[TESTE 2] Escrita no endereço 4");
        $display("Entradas: we=%b, a=%h, wd=%h", we, a, wd);
        #10;  // Espera borda de subida
        
        we = 0;
        #10;
        $display("Leitura após escrita");
        $display("Entradas: we=%b, a=%h", we, a);
        $display("Saída: rd=%h", rd);
        assert(rd === 32'hA5A5A5A5) else $error("Escrita/leitura 1 falhou");
        
        // Teste 3: Escrita em outro endereço
        we = 1;
        a = 8;
        wd = 32'h5A5A5A5A;
        $display("\n[TESTE 3] Escrita no endereço 8");
        $display("Entradas: we=%b, a=%h, wd=%h", we, a, wd);
        #10;
        
        we = 0;
        a = 8;
        #10;
        $display("Leitura após escrita");
        $display("Entradas: we=%b, a=%h", we, a);
        $display("Saída: rd=%h", rd);
        assert(rd === 32'h5A5A5A5A) else $error("Escrita/leitura 2 falhou");
        
        // Teste 4: Não escrita com we=0
        we = 0;
        a = 4;
        wd = 32'hDEADBEEF;
        $display("\n[TESTE 4] Tentativa de escrita com we=0");
        $display("Entradas: we=%b, a=%h, wd=%h", we, a, wd);
        #10;
        $display("Leitura do mesmo endereço");
        $display("Saída: rd=%h", rd);
        assert(rd === 32'hA5A5A5A5) else $error("Proteção escrita falhou");
        
        $display("\n===================================");
        $display(" TODOS OS TESTES DA DMEM PASSARAM!");
        $display("===================================");
        $finish;
    end
endmodule