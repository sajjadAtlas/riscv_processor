module main_decoder (
    input [31:0] instruction,
    output reg [4:0] aluCtrl,
    output reg load, store, branch, regWrite, aluSrc, JAL, JALR, AUIPC,
    output reg [31:0] imm,
    output reg [4:0] rd,
    output reg [6:0] funct7,             
    output reg [2:0] funct3             
);
    always @(*) begin
        
        load = 0;
        store = 0;
        branch = 0;
        regWrite = 0;
        aluSrc = 0;
        JAL = 0;
        JALR = 0;
        AUIPC = 0;
        aluCtrl = 5'b0;

      
        case (instruction[6:0]) // opcode
            7'b0000011: begin // load
                load = 1;
                regWrite = 1;
                aluSrc = 1; // immediate for load
                imm = {{20{instruction[31]}}, instruction[31:20]}; // load immediate
                rd = instruction[11:7]; // destination
                funct3 = instruction[14:12]; // funct3
                funct7 = 7'b0; 
                aluCtrl = 5'b00000; 
            end
            7'b0100011: begin // store
                store = 1;
                aluSrc = 1; 
                imm = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]}; 
                rd = 5'b0; 
                funct3 = instruction[14:12];
                funct7 = 7'b0; 
                aluCtrl = 5'b00000; 
            end
            7'b1100011: begin 
                branch = 1;
                imm = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0}; 
                rd = 5'b0; 
                funct3 = instruction[14:12]; 
                funct7 = 7'b0; 
                aluCtrl = 5'b00001; 
            end
            7'b1101111: begin 
                JAL = 1;
                imm = {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0}; 
                rd = instruction[11:7]; 
                regWrite = 1;
                funct3 = 3'b0; 
                funct7 = 7'b0; 
                aluCtrl = 5'b00010; 
            end
            7'b1100111: begin 
                JALR = 1;
                imm = {{20{instruction[31]}}, instruction[31:20]}; 
                rd = instruction[11:7]; 
                regWrite = 1;
                funct3 = instruction[14:12]; 
                funct7 = 7'b0; 
                aluCtrl = 5'b00011; 
            end
            7'b0010111: begin 
                AUIPC = 1;
                imm = {{12{instruction[31]}}, instruction[31:12], 12'b0}; 
                rd = instruction[11:7]; 
                regWrite = 1;
                funct3 = 3'b0; 
                funct7 = 7'b0; 
                aluCtrl = 5'b00100; 
            end
            default: begin
               
            end
        endcase
    end
endmodule

