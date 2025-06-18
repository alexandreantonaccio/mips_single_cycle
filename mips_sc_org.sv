//Top level do processador MIPS de ciclo unico 32 bits
//Baseado no trabalho do Caskman, disponível em:https://github.com/Caskman/MIPS-Processor-in-Verilog
//E também no artigo disponível em : https://medium.com/@LambdaMamba/building-a-mips-single-cycle-processor-in-verilog-9a3fac6321d
module mips_sc_org(input  logic        clk, reset, 
	           output logic [31:0] writedata, dataadr, 
	           output logic        memwrite);
	
	  logic [31:0] pc, instr, readdata;
	  
	    mips cpu (
		 .clk      (clk),
		 .reset    (reset),
		 .pc       (pc),
		 .instr    (instr),
		 .memwrite (memwrite),
		 .aluout   (dataadr),
		 .writedata(writedata),
		 .readdata (readdata)
	  );
	  imem imem(pc[7:2], instr);
	  dmem dmem(clk, memwrite, dataadr, writedata, readdata);
endmodule