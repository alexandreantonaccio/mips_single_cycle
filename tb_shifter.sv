`timescale 1ns/1ps

module tb_shifter;

    // Parâmetros de teste
    parameter TEST_COUNT = 20;
    parameter CLK_PERIOD = 10;
    
    // Sinais de entrada
    logic [31:0] a;
    logic [4:0]  shamt;
    logic        direction;  // 0 = direita, 1 = esquerda
    logic        clk;
    
    // Sinal de saída
    logic [31:0] y;
    
    // Instância do DUT (Device Under Test)
    shifter dut (
        .a(a),
        .shamt(shamt),
        .direction(direction),
        .y(y)
    );
    
    // Gerador de clock
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end
    
    // Variáveis para verificação
    integer i, errors = 0;
    logic [31:0] expected;
    
    // Tarefa para verificar resultado
    task check_result;
        input string test_name;
        begin
            if (y !== expected) begin
                $display("[ERRO] %s: Entrada = %h, Shamt = %0d, Direção = %b", 
                          test_name, a, shamt, direction);
                $display("       Esperado = %h, Obtido = %h", expected, y);
                errors = errors + 1;
            end
            else begin
                $display("[OK]   %s: Entrada = %h, Shamt = %0d, Direção = %b, Saída = %h", 
                         test_name, a, shamt, direction, y);
            end
        end
    endtask
    
    // Testes
    initial begin
        $display("\nIniciando teste do módulo shifter...");
        $display("====================================\n");
        
        // Teste 1: Deslocamento zero (não deve alterar)
        a = 32'h12345678;
        shamt = 0;
        direction = 1;  // esquerda
        expected = a;
        #10;
        check_result("Deslocamento zero");
        
        // Teste 2: Deslocamento mínimo para esquerda
        a = 32'h00000001;
        shamt = 1;
        direction = 1;  // esquerda
        expected = 32'h00000002;
        #10;
        check_result("Deslocamento esquerda 1 bit");
        
        // Teste 3: Deslocamento máximo para esquerda
        a = 32'h00000001;
        shamt = 31;
        direction = 1;  // esquerda
        expected = 32'h80000000;
        #10;
        check_result("Deslocamento esquerda 31 bits");
        
        // Teste 4: Deslocamento que causa overflow
        a = 32'hFFFFFFFF;
        shamt = 1;
        direction = 1;  // esquerda
        expected = 32'hFFFFFFFE;
        #10;
        check_result("Deslocamento esquerda com overflow");
        
        // Teste 5: Deslocamento mínimo para direita
        a = 32'h80000000;
        shamt = 1;
        direction = 0;  // direita
        expected = 32'h40000000;
        #10;
        check_result("Deslocamento direita 1 bit");
        
        // Teste 6: Deslocamento máximo para direita
        a = 32'h80000000;
        shamt = 31;
        direction = 0;  // direita
        expected = 32'h00000001;
        #10;
        check_result("Deslocamento direita 31 bits");
        
        // Teste 7: Deslocamento que zera o valor
        a = 32'h00000001;
        shamt = 16;
        direction = 0;  // direita
        expected = 32'h00000000;
        #10;
        check_result("Deslocamento direita que zera o valor");
        
        // Teste 8: Deslocamento com valores aleatórios
        $display("\nTestes aleatórios:");
        for (i = 0; i < TEST_COUNT; i = i + 1) begin
            a = $random;
            shamt = $urandom_range(0, 31);
            direction = $random % 2;
            
            // Calcula resultado esperado
            if (direction) begin
                expected = a << shamt;
            end else begin
                expected = a >> shamt;
            end
            
            #10;
            
            // Verifica resultado
            if (y !== expected) begin
                $display("[ERRO] Teste %0d: Entrada = %h, Shamt = %0d, Direção = %b", 
                         i, a, shamt, direction);
                $display("       Esperado = %h, Obtido = %h", expected, y);
                errors = errors + 1;
            end
            else begin
                $display("[OK]   Teste %0d: Entrada = %h, Shamt = %0d, Direção = %b, Saída = %h", 
                         i, a, shamt, direction, y);
            end
        end
        
        // Resumo do teste
        $display("\n====================================");
        $display("Testes concluídos com %0d erros", errors);
        $display("====================================\n");
        
        // Finaliza simulação
        $finish;
    end
    
endmodule