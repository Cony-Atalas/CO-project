
module testbench();	
reg clk,rst;
initial 
begin	
	clk = 0;
	rst = 1;
	#35 rst=0;
end

always #30 clk=~clk;

mips b_mips(clk,rst);

endmodule
