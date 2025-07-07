module dmem(input  logic       clk, we,
            input  logic [31:0] a, wd,
            output logic [31:0] rd);

    logic [31:0] RAM[63:0];

    // Bloco de inicialização para carregar o arquivo de dados
    initial begin
        $readmemh("data.txt", RAM);
    end

    // O restante do módulo permanece o mesmo
    assign rd = RAM[a[31:2]]; // word aligned

    always_ff @(posedge clk)
        if (we) begin
            RAM[a[31:2]] <= wd;
            $display("DMEM WRITE: Address=0x%h, Data=0x%h", a, wd);
        end
endmodule