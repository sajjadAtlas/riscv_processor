module branch_unit (
    input branchTaken,
    input isBranchInstr,
    input [31:0] imm,
    input [31:0] currentPC,
    output reg [31:0] updatedPC
);

    always@(*)
    begin
        if(branchTaken && isBranchInstr)   //Checks if A) the ALU approves the branch instruction to be taken, meaning the comparison has the right value, and B) if a branch instr was sent to the processor
        begin
            updatedPC <= currentPC + imm;
        end
        else
        begin
            updatedPC <= currentPC + 4;
        end
        
    end

    
endmodule