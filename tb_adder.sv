`timescale 1ns/1ns
module tb_adder;

    logic [31:0] a, b, y;
    
    adder dut(a, b, y);
    
    initial begin
        // Teste 1: Soma básica
        a = 32'h00000004;
        b = 32'h00000004;
        #10;
        $display("4 + 4 = %h (Esperado: 00000008)", y);
        
        // Teste 2: Soma com overflow
        a = 32'hFFFFFFFC;
        b = 32'h0000000A;
        #10;
        $display("FFFFFFFC + A = %h (Esperado: 00000006)", y);
        
        // Teste 3: Soma máxima
        a = 32'hFFFFFFFF;
        b = 32'h00000001;
        #10;
        $display("FFFFFFFF + 1 = %h (Esperado: 00000000)", y);
        
        $finish;
    end

endmodule