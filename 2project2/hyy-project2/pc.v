

module pc(PC,NPC,Clk,Reset);

input [31:2]NPC;
input Clk;
input Reset;
output reg [31:2]PC;

always @(negedge Clk)
begin
    if(Reset==1)
        PC <= 30'b00_0000_0000_0000_0000_1100_0000_0000;
    else
        PC <= NPC;
end

endmodule
