module jal_unit (
    input isJAL,
    input [31:0] imm,
    input [31:0] currentPC,
    output reg [31:0] updatedPC,
    output reg [31:0] linkReg

);
    wire linkRegPCValue = currentPC+4;
    always@(*)
    begin
        if(isJAL)
        begin
            updatedPC <= currentPC + imm;       //new pc is current + offset
            linkReg <= linkRegPCValue;         //return address (addr of next instruction) saved to rd
        end
    end
endmodule