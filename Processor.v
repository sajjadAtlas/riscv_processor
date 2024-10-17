module PipelinedProcessor (
    input clock,
    input reset
);

    
    wire [31:0] instruction_IF, instruction_ID;
    wire [31:0] PC_IF, PC_ID, PC_EX, nextPC_ID, nextPC_EX;
    wire [31:0] imm_ID, imm_EX;
    wire [31:0] regData1_ID, regData2_ID, regData1_EX, regData2_EX;
    wire [31:0] aluResult_EX, aluResult_MEM;
    wire [31:0] writeData_WB;
    wire [4:0] rd_ID, rd_EX;
    wire load_ID, store_ID, regWrite_ID, branch_ID;
    wire JAL_ID, JALR_ID, AUIPC_ID;
    wire branchTaken_EX;

  
    reg [31:0] PC;
    always @(posedge clock or posedge reset) begin
        if (reset)
            PC <= 32'b0; 
        else
            PC <= nextPC_EX; 
    end

    instr_mem IM(
        .address(PC),
        .instruction(instruction_IF)
    );

    always @(posedge clock) begin
        if (!reset) begin
            PC_IF <= PC; 
        end
    end

   
    reg [31:0] instruction_ID_reg;
    reg [31:0] PC_ID_reg;
    
    always @(posedge clock) begin
        if (!reset) begin
            instruction_ID_reg <= instruction_IF;
            PC_ID_reg <= PC_IF;
        end
    end

    main_decoder decoder(
        .instruction(instruction_ID_reg),
        .aluCtrl(aluCtrl),
        .load(load_ID),
        .store(store_ID),
        .branch(branch_ID),
        .regWrite(regWrite_ID),
        .aluSrc(aluSrc),
        .JAL(JAL_ID),
        .JALR(JALR_ID),
        .AUIPC(AUIPC_ID),
        .funct3(funct3),
        .funct7(funct7),
        .rd(rd_ID),
        .imm(imm_ID)
    );

    RegisterFile regFile(
        .clock(clock),
        .reset(reset),
        .write(regWrite_ID),
        .rs1(instruction_ID_reg[19:15]),
        .rs2(instruction_ID_reg[24:20]),
        .rd(rd_ID),
        .writeData(writeData_WB),
        .regData1(regData1_ID),
        .regData2(regData2_ID)
    );

   
    reg [31:0] imm_EX_reg;
    reg [31:0] regData1_EX_reg, regData2_EX_reg;
    reg [4:0] rd_EX_reg;
    reg load_EX, store_EX, regWrite_EX, JAL_EX, JALR_EX, AUIPC_EX;

    always @(posedge clock) begin
        if (!reset) begin
            imm_EX_reg <= imm_ID;
            regData1_EX_reg <= regData1_ID;
            regData2_EX_reg <= regData2_ID;
            rd_EX_reg <= rd_ID;
            load_EX <= load_ID;
            store_EX <= store_ID;
            regWrite_EX <= regWrite_ID;
            JAL_EX <= JAL_ID;
            JALR_EX <= JALR_ID;
            AUIPC_EX <= AUIPC_ID;
        end
    end

    
    ALU alu(
        .operand1(regData1_EX_reg),
        .operand2(aluSrc ? imm_EX_reg : regData2_EX_reg),
        .ALUop(aluCtrl),
        .funct7(funct7),
        .funct3(funct3),
        .branchTaken(branchTaken_EX),
        .result(aluResult_EX)
    );

    
    always @(*) begin
        if (branch_ID && branchTaken_EX) begin
            nextPC_EX = PC_ID_reg + imm_EX_reg; 
        end else if (JAL_EX) begin
            nextPC_EX = PC_ID_reg + imm_EX_reg; 
        end else if (JALR_EX) begin
            nextPC_EX = (regData1_EX_reg + imm_EX_reg) & 32'b11111111111111111111111111111100; 
        end else begin
            nextPC_EX = PC_ID_reg + 4; 
        end
    end

    
    reg [31:0] aluResult_MEM_reg;
    reg [31:0] regData2_MEM_reg;
    reg load_MEM, store_MEM, regWrite_MEM;

    always @(posedge clock) begin
        if (!reset) begin
            aluResult_MEM_reg <= aluResult_EX;
            regData2_MEM_reg <= regData2_EX_reg;
            load_MEM <= load_EX;
            store_MEM <= store_EX;
            regWrite_MEM <= regWrite_EX;
        end
    end

    
    datamemory DM(
        .address(aluResult_MEM_reg),
        .write(store_MEM),
        .writeData(regData2_MEM_reg),
        .read(load_MEM),
        .readData(writeData_WB) 
    );

    
    always @(posedge clock) begin
        if (!reset) begin
           
            writeData_WB <= load_MEM ? readData : aluResult_MEM_reg;
        end
    end

endmodule

