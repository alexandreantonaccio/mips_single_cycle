module tb_signext;
    logic [15:0] a;
    logic [31:0] y;
    
    signext dut (.a(a), .y(y));
    
    initial begin
        $display("===================================");
        $display(" INÍCIO DO TESTE PARA SIGNEXT");
        $display("===================================");
        
        // Teste 1: Número positivo
        a = 16'h7FFF;
        #10;
        $display("\n[TESTE 1] Número positivo (0x7FFF)");
        $display("Entrada: a=%h", a);
        $display("Saída: y=%h", y);
        assert(y === 32'h00007FFF) else $error("Extensão positiva falhou");
        
        // Teste 2: Número negativo
        a = 16'h8000;
        #10;
        $display("\n[TESTE 2] Número negativo (0x8000)");
        $display("Entrada: a=%h", a);
        $display("Saída: y=%h", y);
        assert(y === 32'hFFFF8000) else $error("Extensão negativa falhou");
        
        // Teste 3: Zero
        a = 16'h0000;
        #10;
        $display("\n[TESTE 3] Zero (0x0000)");
        $display("Entrada: a=%h", a);
        $display("Saída: y=%h", y);
        assert(y === 32'h00000000) else $error("Extensão zero falhou");
        
        // Teste 4: Valor máximo negativo
        a = 16'hFFFF;
        #10;
        $display("\n[TESTE 4] Valor máximo negativo (0xFFFF)");
        $display("Entrada: a=%h", a);
        $display("Saída: y=%h", y);
        assert(y === 32'hFFFFFFFF) else $error("Extensão FFFF falhou");
        
        // Teste 5: Valor intermediário
        a = 16'h1234;
        #10;
        $display("\n[TESTE 5] Valor intermediário (0x1234)");
        $display("Entrada: a=%h", a);
        $display("Saída: y=%h", y);
        assert(y === 32'h00001234) else $error("Extensão 1234 falhou");
        
        $display("\n===================================");
        $display(" TODOS OS TESTES DO SIGNEXT PASSARAM!");
        $display("===================================");
        $finish;
    end
endmodule