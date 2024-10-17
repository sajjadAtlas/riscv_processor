module auipc_unit (
    input isAUIPC,            
    input [31:0] currentPC,   
    input [31:0] imm,         
    output reg [31:0] updatedPC  
);

    always@(*) begin
        if (isAUIPC) begin
            // AUIPC: Add immediate (shifted by 12) to the current PC
            updatedPC <= currentPC + (imm << 12);
        end
        else begin
            updatedPC <= currentPC; // No change if not AUIPC
        end
    end
    
endmodule
