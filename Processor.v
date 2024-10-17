module PipelinedProcessor (
    input clock,
    input reset,
    output [31:0] pc
);
    wire [31:0] instruction;
    wire [31:0] pc_next;
    wire [31:0] regData1, regData2;
    wire [4:0] rd;
    wire [31:0] writeData;
    wire regWrite;
    
    wire load, store, branch, JAL, JALR, AUIPC, aluSrc;
    wire [4:0] aluCtrl;
    wire [31:0] imm;

// pipeline registers
    reg [31:0] IF_ID_instruction;
    reg [31:0] IF_ID_pc;
    reg [4:0] ID_EX_rd;
    reg [31:0] ID_EX_regData1, ID_EX_regData2, ID_EX_imm;
    reg ID_EX_load, ID_EX_store, ID_EX_branch, ID_EX_JAL, ID_EX_JALR, ID_EX_AUIPC, ID_EX_aluSrc;
    reg [4:0] ID_EX_aluCtrl;
    
    wire [31:0] aluResult;
    wire branchTaken;

    reg [31:0] pc_reg;
    always @(posedge clock or posedge reset) begin
        if (reset) begin
            pc_reg <= 32'b0;
        end else begin
            pc_reg <= pc_next; // Update PC to next value
        end
    end

    assign pc = pc_reg;

    InstructionMemory inst_mem(
        .address(pc_reg),
        .data(instruction)
    );

    // Register File
    RegisterFile reg_file(
        .clock(clock),
        .reset(reset),
        .write(regWrite),
        .rs1(IF_ID_instruction[19:15]), // source 1
        .rs2(IF_ID_instruction[24:20]), // source 2
        .rd(rd),                         // destination
        .writeData(writeData),           // data to write
        .regData1(regData1),             // dutput for rs1
        .regData2(regData2)              // dutput for rs2
    );

    // Control Unit (Decoder)
    main_decoder decoder(
        .instruction(IF_ID_instruction),
        .aluCtrl(aluCtrl),
        .load(load),
        .store(store),
        .branch(branch),
        .regWrite(regWrite),
        .aluSrc(aluSrc),
        .JAL(JAL),
        .JALR(JALR),
        .AUIPC(AUIPC),
        .opCode(),
        .funct7(),
        .funct3(),
        .rs1(),
        .rs2(),
        .rd(rd),
        .imm(imm)
    );

    // IF Stage
    always @(posedge clock or posedge reset) begin
        if (reset) begin
            IF_ID_instruction <= 32'b0;
            IF_ID_pc <= 32'b0;
        end else begin
            IF_ID_instruction <= instruction; // fetch instruction
            IF_ID_pc <= pc_reg;                // store PC value
        end
    end

    // ID Stage
    always @(posedge clock or posedge reset) begin
        if (reset) begin
            ID_EX_rd <= 5'b0;
            ID_EX_regData1 <= 32'b0;
            ID_EX_regData2 <= 32'b0;
            ID_EX_imm <= 32'b0;
            ID_EX_load <= 0;
            ID_EX_store <= 0;
            ID_EX_branch <= 0;
            ID_EX_JAL <= 0;
            ID_EX_JALR <= 0;
            ID_EX_AUIPC <= 0;
            ID_EX_aluSrc <= 0;
            ID_EX_aluCtrl <= 5'b0;
        end else begin
            ID_EX_rd <= rd;                     // rd for the EX stage
            ID_EX_regData1 <= regData1;        // source register 1 data
            ID_EX_regData2 <= regData2;        // source register 2 data
            ID_EX_imm <= imm;                   // immediate value
            ID_EX_load <= load;                 // load control signal
            ID_EX_store <= store;               // store control signal
            ID_EX_branch <= branch;             // branch control signal
            ID_EX_JAL <= JAL;                   // JAL control signal
            ID_EX_JALR <= JALR;                 // JALR control signal
            ID_EX_AUIPC <= AUIPC;               // AUIPC control signal
            ID_EX_aluSrc <= aluSrc;             // ALU source control signal
            ID_EX_aluCtrl <= aluCtrl;           // ALU control signals
        end
    end

    
    ALU alu(
        .operand1(ID_EX_regData1),          
        .operand2(ID_EX_aluSrc ? ID_EX_imm : ID_EX_regData2), // Source 2 (Immediate if ALU src)
        .ALUop(ID_EX_aluCtrl),              
        .funct7(),
        .funct3(),
        .branchTaken(branchTaken),           
        .result(aluResult)                  
    );

 
    always @(posedge clock or posedge reset) begin
        if (reset) begin
            writeData <= 32'b0; 
        end else begin
            if (ID_EX_load) begin
               
            end else if (ID_EX_store) begin
                
            end
        end
    end

    always @(posedge clock or posedge reset) begin
        if (reset) begin
            writeData <= 32'b0;
        end else begin
            if (ID_EX_load) begin
                writeData <= aluResult; 
            end else if (ID_EX_JAL || ID_EX_JALR || ID_EX_AUIPC) begin
                writeData <= pc_next;             end
        end
    end

    
    assign pc_next = pc_reg + (ID_EX_branch && branchTaken ? ID_EX_imm : 4); 

endmodule
