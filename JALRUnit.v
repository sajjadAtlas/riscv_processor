module jalr_unit (
    input isJALR,
    input [31:0] imm,
    input [31:0] currentPC,
    input [31:0] rs1,
    output reg [31:0] updatedPC,
    output reg [31:0] linkReg
);
    
    always@(*)
    begin
        if(isJALR)
        begin
            updatedPC <= rs1 + imm; //program jumps to base pc address + offset -> use the address that JAL stores in rd as the rs1 if you want to return from a routine
            linkReg = currentPC + 4; //for returning, just write linkReg data to a reg that is always set to zero (x0)
        end
    end
endmodule