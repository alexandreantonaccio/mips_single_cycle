module mips_sc_org(input  logic        clk, reset, 
	           output logic [31:0] writedata, dataadr, 
	           output logic        memwrite);
	
	  logic [31:0] pc, instr, readdata;
	  
	  // instantiate processor and memories
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