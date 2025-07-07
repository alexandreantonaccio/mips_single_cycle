module regfile(input  logic        clk, reset, // Adicione o 'reset' aqui
               input  logic        we3, 
               input  logic [4:0]  ra1, ra2, wa3, 
               input  logic [31:0] wd3, 
               output logic [31:0] rd1, rd2);

  logic [31:0] rf[31:0];

  always_ff @(posedge clk, posedge reset) begin
  $display("REGFILE READ: ra1=%d, ra2=%d", ra1, ra2);
    if (reset) begin
        for (int i = 0; i < 32; i++) begin
            rf[i] <= 32'b0;
        end
    end else if (we3 && wa3 != 0) begin
        rf[wa3] <= wd3;
    end
  end

  assign rd1 = rf[ra1];
  assign rd2 = rf[ra2];
endmodule