//////////////////////////////////////////
// bne_cpu_tb.sv (Testbench Only)       //
//////////////////////////////////////////

module bne_cpu_tb;
    logic clk = 0, reset;
    logic [31:0] pc;
    logic [31:0] instr;
    logic memwrite;
    logic [31:0] dataadr, writedata;
    logic [31:0] readdata = 0;

    // Instantiate CPU
    mips_extended cpu(
        .clk(clk), .reset(reset), .pc(pc), .instr(instr),
        .memwrite(memwrite), .dataadr(dataadr), .writedata(writedata),
        .readdata(readdata)
    );

    // Clock generator
    always #5 clk = ~clk;

    initial begin
        reset = 1; #10;
        reset = 0;

        // Test ADD: $3 = $1 + $2
        instr = 32'b000000_00001_00010_00011_00000_100000; // add $3, $1, $2
        #10;
        $display("ADD aluout = %0d", cpu.aluout);

        // Test SUB: $3 = $1 - $2
        instr = 32'b000000_00001_00010_00011_00000_100010; // sub $3, $1, $2
        #10;
        $display("SUB aluout = %0d", cpu.aluout);

        // Test SLT: $4 = ($1 < $2) ? 1 : 0
        instr = 32'b000000_00001_00010_00100_00000_101010; // slt $4, $1, $2
        #10;
        $display("SLT aluout = %0d", cpu.aluout);

        // Test ADDI: $3 = $1 + 1
        instr = 32'b001000_00001_00011_00000_00000_000001; // addi $3, $1, 1
        #10;
        $display("ADDI aluout = %0d", cpu.aluout);

        // Test BEQ: if $1 == $1 branch +1
        instr = 32'b000100_00001_00001_00000_00000_000001; // beq $1, $1, 1
        #10;
        $display("BEQ PC = %0d", cpu.pc);

        // Test BNE: if $1 != $2 branch +1
        instr = 32'b000101_00001_00010_00000_00000_000001; // bne $1, $2, 1
        #10;
        $display("BNE PC = %0d", cpu.pc);

        // Test J: jump to 16
        instr = 32'b000010_00000000000000000000010000; // j 16
        #10;
        $display("J PC = %0d", cpu.pc);

        // Test JAL: jump to 20 and link
        instr = 32'b000011_00000000000000000000010100; // jal 20
        #10;
        $display("JAL PC = %0d, $ra = %0d", cpu.pc, cpu.dp.rf.rf[31]);

        // Test JR: jump to value in $4
        cpu.dp.rf.rf[4] = 32'h00000030;
        instr = 32'b000000_00100_00000_00000_00000_001000; // jr $4
        #10;
        $display("JR PC = %0d", cpu.pc);

        $finish;
    end
endmodule
