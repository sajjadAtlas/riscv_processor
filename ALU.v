module ALU(
    input [31:0] operand1,
    input [31:0] operand2,
    input [3:0] ALUop,
    input [6:0] funct7,
    input [2:0] funct3,
    output reg branchTaken,
    output reg [31:0] result
);

    integer msb = 0;
    integer i = 0;
    wire op1_sign = operand1[31];
    wire op2_sign = operand2[31];
    
    always @(*) begin
        // Default assignments
        result = 32'b0;  // Default to zero
        branchTaken = 1'b0;  // Default to false

        case (ALUop)
            4'b0000: begin // R-Type operations
                case ({funct7, funct3})
                    10'b0000000000: result <= operand1 + operand2; // ADD
                    10'b0000100000: result <= operand1 - operand2; // SUB
                    10'b0000000100: result <= operand1 ^ operand2; // XOR
                    10'b0000000110: result <= operand1 | operand2; // OR
                    10'b0000000111: result <= operand1 & operand2; // AND
                    10'b0000000001: result <= operand1 << operand2[4:0]; // LSL
                    10'b0000000101: result <= operand1 >> operand2[4:0]; // LSR
                    10'b0100000101: begin  // ASR
                        result <= operand1 >>> operand2[4:0]; // Arithmetic shift right
                    end
                    10'b0000000010: result <= (operand1 < operand2) ? 1 : 0; // SLT
                    10'b0000000011: result <= ($unsigned(operand1) < $unsigned(operand2)) ? 1 : 0; // SLTU
                    default: result <= 32'b0; // Default case
                endcase
            end

            4'b0001: begin // I-Type operations
                case (funct3)
                    3'b000: result <= operand1 + operand2; // ADDI
                    3'b100: result <= operand1 ^ operand2; // XORI
                    3'b110: result <= operand1 | operand2; // ORI
                    3'b111: result <= operand1 & operand2; // ANDI
                    3'b001: result <= operand1 << operand2[4:0]; // LSLI
                    3'b101: begin
                        if (funct7[5] == 1'b0) // LSRI
                            result <= operand1 >> operand2[4:0];
                        else // ASRI
                            result <= operand1 >>> operand2[4:0];
                    end
                    3'b010: result <= (operand1 < operand2) ? 1 : 0; // SLTI
                    3'b011: result <= ($unsigned(operand1) < $unsigned(operand2)) ? 1 : 0; // SLTIU
                    default: result <= 32'b0; // Default case
                endcase
            end

            4'b0010: // Load/Store address calculation
                if (funct3 == 3'b000 || funct3 == 3'b001 || funct3 == 3'b010 || funct3 == 3'b100 || funct3 == 3'b101) begin
                    result <= operand1 + operand2; // Memory address calculation
                end

            4'b0011: begin // Branch operations
                case (funct3)
                    3'b000: branchTaken <= ($signed(operand1) == $signed(operand2)); // BEQ
                    3'b001: branchTaken <= ($signed(operand1) != $signed(operand2)); // BNE
                    3'b100: branchTaken <= ($signed(operand1) < $signed(operand2)); // BLT
                    3'b101: branchTaken <= ($signed(operand1) >= $signed(operand2)); // BGE
                    3'b110: branchTaken <= (operand1 < operand2); // BLTU
                    3'b111: branchTaken <= (operand1 >= operand2); // BGEU
                    default: branchTaken <= 1'b0; // Default case
                endcase
            end

            4'b0100: // JAL and JALR
                result <= operand1 + 32'd4; // PC + 4

            4'b0101: // LUI
                result <= operand2 << 12; // Load upper immediate

            default: result <= 32'b0; // Default case
        endcase
    end
endmodule


