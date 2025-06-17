`timescale 1ns/1ps

module bne_cpu_tb;
  // Clock and reset
  logic clk;
  logic reset;
  
  // CPU outputs
  logic [31:0] writedata;
  logic [31:0] dataadr;
  logic        memwrite;

  // Instantiate DUT
  bne_cpu dut (
    .clk(clk),
    .reset(reset),
    .writedata(writedata),
    .dataadr(dataadr),
    .memwrite(memwrite)
  );

  // Clock generation: 10ns period
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Reset pulse
  initial begin
    reset = 1;
    #20;
    reset = 0;
  end

  // Instruction memory initialization via file
  initial begin
    $readmemh("program.txt", dut.imem.RAM);
    $display(">> IMEM loaded from program.txt");
  end

  // Data memory initialization via file
  initial begin
    $readmemh("data.txt", dut.dmem.RAM);
    $display(">> DMEM loaded from data.txt");
  end

  // Registers initialization
  initial begin
    dut.cpu.dp.rf.rf[1] = 32'h00000003; // $1 = 3
    dut.cpu.dp.rf.rf[2] = 32'h00000002; // $2 = 2
    $display(">> Inicializados: $1 = %h, $2 = %h",
             dut.cpu.dp.rf.rf[1], dut.cpu.dp.rf.rf[2]);
  end

  // Monitor outputs
  initial begin
    $display("Time | PC    | Instr     | DataAdr   | MemWrite | WriteData");
    $monitor("%4dns | %h | %h | %h | %b       | %h",
             $time, dut.pc, dut.instr, dut.dataadr,
             memwrite, writedata);
  end

  // Run simulation
  initial begin
    #500; // enough cycles to exercise all ops
    $display("Simulation complete.");
    $finish;
  end
endmodule
