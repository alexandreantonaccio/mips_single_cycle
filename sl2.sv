module sl2(input  logic [31:0] a,
           output logic [31:0] y);
  assign y = {a[29:0], 2'b00};
endmodule