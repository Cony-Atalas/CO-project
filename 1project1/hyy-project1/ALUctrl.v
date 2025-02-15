module ALUctrl( op, func, ALUctr);

input [5:0]op;
input [5:0]func;
output reg [3:0]ALUctr;

parameter R = 6'b000000;

always @(*)begin
    
    case(op)
    R:begin
    //P168
        ALUctr[3]=(!func[4]&!func[3]&func[2]&func[1])+(!func[5]&!func[4]&!func[3]&!func[2]&!func[0])+(!func[5]&!func[4]&!func[3]&func[2]&!func[1]&!func[0])+(!func[5]&!func[4]&!func[3]&!func[2]&func[1]&func[0]);
        ALUctr[2]=(func[5]&!func[4]&!func[3]&!func[2]&func[1])+(func[5]&!func[4]&func[3]&!func[2]&func[1])+(!func[5]&!func[4]&!func[3]&func[1]&func[0])+(!func[5]&!func[4]&!func[3]&func[2]&!func[0]);
        ALUctr[1]=(func[5]&!func[4]&func[3]&!func[2]&func[1])+(func[5]&!func[4]&!func[3]&func[2]&!func[1])+(!func[5]&!func[4]&!func[3]&!func[2]&!func[0])+(!func[5]&!func[4]&!func[3]&func[2]&func[1]);
        ALUctr[0]=(func[5]&!func[4]&!func[3]&func[2]&!func[0])+(!func[5]&!func[4]&!func[3]&!func[2]&func[1])+(func[5]&!func[4]&!func[3]&!func[2]&!func[0])+(func[5]&!func[4]&func[3]&!func[2]&func[1]&!func[0])+(!func[5]&!func[4]&!func[3]&func[2]&func[1]&!func[0]);
        //{!func[2]&func[1],(func[3]&!func[2]&func[1])+(!func[3]&func[2]&!func[1]),(!func[3]&!func[1]&!func[0])+(!func[2]&func[1]&!func[0])};
    end

    default:begin
    //P167
        ALUctr[3]=!op[5]&!op[4]&op[3]&op[2]&op[1]&!op[0];
        ALUctr[2]=(!op[5]&!op[4]&!op[3]&op[2]&!op[1])+(!op[5]&!op[4]&op[3]&!op[2]&op[1]);
        ALUctr[1]=(!op[5]&!op[4]&op[3]&!op[2]&op[1])+(!op[5]&!op[4]&op[3]&op[2]&!op[1]);
        ALUctr[0]=(!op[5]&!op[4]&op[3]&!op[2]&!op[0])+(!op[5]&!op[4]&op[3]&!op[2]&!op[0])
               +(op[5]&!op[4]&!op[3]&!op[2]&!op[1]&!op[0])
                +(op[5]&!op[4]&!op[3]&op[2]&!op[1]&!op[0])
                +(op[5]&!op[4]&op[3]&!op[2]&!op[1]&!op[0]);
        //ALUctr[3:0] = {1'b0,!op[5]&!op[4]&!op[3]&op[2]&!op[1]&!op[0],!op[5]&!op[4]&op[3]&op[2]&!op[1]&op[0],(!op[5]&!op[4]&!op[3]&!op[2]&!op[1]&!op[0])+(!op[5]&!op[4]&op[3]&!op[2]&!op[1]&!op[0])};
    end
    endcase

end

endmodule
