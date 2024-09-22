module auipc_unit (
    input [31:0] currentPC,
    input [31:0] imm,
    output reg [31:0] updatedPC
);

    always@(*)
    begin
        updatedPC <= currentPC + (imm << 12);
    end
    
endmodule
