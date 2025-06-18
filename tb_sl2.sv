module tb_sl2;
    logic [31:0] a;
    logic [31:0] y;
    
    sl2 dut (.a(a), .y(y));
    
    initial begin
        $display("===================================");
        $display(" INÍCIO DO TESTE PARA SL2");
        $display("===================================");
        
        // Teste 1: Deslocamento básico
        a = 32'h00000001;
        #10;
        $display("\n[TESTE 1] Deslocamento básico (0x00000001)");
        $display("Entrada: a=%h", a);
        $display("Operação: a << 2");
        $display("Saída: y=%h", y);
        assert(y === 32'h00000004) else $error("Deslocamento básico falhou");
        
        // Teste 2: Deslocamento com carry
        a = 32'h40000000;
        #10;
        $display("\n[TESTE 2] Deslocamento com carry (0x40000000)");
        $display("Entrada: a=%h", a);
        $display("Operação: a << 2");
        $display("Saída: y=%h", y);
        assert(y === 32'h00000000) else $error("Deslocamento com carry falhou");
        
        // Teste 3: Deslocamento negativo
        a = 32'h80000000;
        #10;
        $display("\n[TESTE 3] Deslocamento negativo (0x80000000)");
        $display("Entrada: a=%h", a);
        $display("Operação: a << 2");
        $display("Saída: y=%h", y);
        assert(y === 32'h00000000) else $error("Deslocamento negativo falhou");
        
        // Teste 4: Deslocamento valor máximo
        a = 32'hFFFFFFFF;
        #10;
        $display("\n[TESTE 4] Deslocamento valor máximo (0xFFFFFFFF)");
        $display("Entrada: a=%h", a);
        $display("Operação: a << 2");
        $display("Saída: y=%h", y);
        assert(y === 32'hFFFFFFFC) else $error("Deslocamento FFFFFFFF falhou");
        
        // Teste 5: Deslocamento padrão
        a = 32'h12345678;
        #10;
        $display("\n[TESTE 5] Deslocamento padrão (0x12345678)");
        $display("Entrada: a=%h", a);
        $display("Operação: a << 2");
        $display("Saída: y=%h", y);
        assert(y === 32'h48D159E0) else $error("Deslocamento 12345678 falhou");
        
        $display("\n===================================");
        $display(" TODOS OS TESTES DO SL2 PASSARAM!");
        $display("===================================");
        $finish;
    end
endmodule