module tb_imem;
    logic [5:0] a;
    logic [31:0] rd;

    logic [31:0] temp_mem[0:3];  // memória temporária

    imem dut (.a(a), .rd(rd));

    initial begin
        $display("===================================");
        $display(" INÍCIO DO TESTE PARA IMEM");
        $display("===================================");
		  
		  
        // Inicializa vetor temporário com os dados
        temp_mem[0] = 32'h00000000;
        temp_mem[1] = 32'h11111111;
        temp_mem[2] = 32'h22222222;
        temp_mem[3] = 32'h33333333;

        // Escreve os dados no arquivo
        $writememh("code_test.txt", temp_mem);

        $display("Memória inicializada com valores:");
        $display("Endereço 0: 00000000");
        $display("Endereço 1: 11111111");
        $display("Endereço 2: 22222222");
        $display("Endereço 3: 33333333");
		  
		  $readmemh("code_test.txt", dut.RAM);
		  
        // Testes de leitura
        a = 0;
        #10;
        $display("\n[TESTE 1] Leitura endereço 0");
        $display("Entrada: a=%d", a);
        $display("Saída: rd=%h", rd);
        assert(rd === 32'h00000000) else $error("Leitura addr 0 falhou");

        a = 1;
        #10;
        $display("\n[TESTE 2] Leitura endereço 1");
        $display("Entrada: a=%d", a);
        $display("Saída: rd=%h", rd);
        assert(rd === 32'h11111111) else $error("Leitura addr 1 falhou");

        a = 2;
        #10;
        $display("\n[TESTE 3] Leitura endereço 2");
        $display("Entrada: a=%d", a);
        $display("Saída: rd=%h", rd);
        assert(rd === 32'h22222222) else $error("Leitura addr 2 falhou");

        a = 64;
        #10;
        $display("\n[TESTE 4] Leitura endereço fora do range (64)");
        $display("Entrada: a=%d", a);
        $display("Saída: rd=%h", rd);
        assert($isunknown(rd)) else $error("Leitura fora do range falhou");

        $display("\n===================================");
        $display(" TODOS OS TESTES DA IMEM PASSARAM!");
        $display("===================================");
        $finish;
    end
endmodule
