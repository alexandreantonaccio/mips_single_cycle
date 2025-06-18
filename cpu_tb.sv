`timescale 1ns/1ps

module tb_cpu();

    logic clk, reset;
    logic [31:0] writedata, dataadr;
    logic memwrite;
    
    mips_sc_org dut (
        .clk(clk),
        .reset(reset),
        .writedata(writedata),
        .dataadr(dataadr),
        .memwrite(memwrite)
    );
   
    always begin
        clk = 1; #5;
        clk = 0; #5;
    end

    initial begin

        reset = 1;
        #10; 
        reset = 0;
        
        #1000;
        
        $finish;
    end
    initial begin
		  forever @(negedge clk) begin
			 if (!reset) begin
				$display("t0=%h t1=%h t2=%h t3=%h t4=%h t5=%h t6=%h t7=%h",
							dut.cpu.dp.rf.rf[8],  // $t0
							dut.cpu.dp.rf.rf[9],  // $t1
							dut.cpu.dp.rf.rf[10], // $t2
							dut.cpu.dp.rf.rf[11], // $t3
							dut.cpu.dp.rf.rf[12], // $t4
							dut.cpu.dp.rf.rf[13], // $t5
							dut.cpu.dp.rf.rf[14], // $t6
							dut.cpu.dp.rf.rf[15]);// $t7
							
			 end
		  end
		end

endmodule