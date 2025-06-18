module shifter(
    input  logic [31:0] a,          // Valor de entrada
    input  logic [4:0]  shamt,       // Quantidade de deslocamento (0-31)
    input  logic        direction,   // Direção: 0 = direita, 1 = esquerda
    output logic [31:0] y            // Valor deslocado
);
    always_comb begin
        if (direction) begin
            y = a << shamt;        // Deslocamento para esquerda
        end else begin
            y = a >> shamt;        // Deslocamento para direita
        end
    end
endmodule