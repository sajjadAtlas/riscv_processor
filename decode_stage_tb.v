`timescale 1ns/1ns
`include "ProgramCounter/ProgramCounter.v"
`include "FetchStage/instr_mem.v"
`include "ProgramCounter/PC_Adder.v"
`include "DecodeStage/MainDecoder.v"
`include "DecodeStage/RegisterFile.v"
module decode_stage_tb;
    
    reg [31:0] address;
    wire [31:0] instruction;

    reg [31:0] pcAdder;
    wire [31:0] incrementedPC;

    reg clk, reset;
    wire [31:0] nextPC;
    wire [31:0] PC;
    wire [4:0] aluCtrl;
    wire [6:0] opCode;
    wire [6:0] funct7;
    wire [4:0] rs1, rs2, rd;
    wire [2:0] funct3;
    wire [31:0] imm;
    wire load, store, branch, regWrite, aluSrc, JAL, JALR, AUIPC;
    reg [31:0] inputWriteData;
    wire [31:0] regData1;
    wire [31:0] regData2;

    ProgramCounter pc2(.clk(clk), .reset(reset), .nextPC(nextPC), .PC(PC));
    PC_Adder pca1(.PC(PC), .incrementedPC(nextPC));
    instr_mem im1(.address(PC), .instruction(instruction));

    main_decoder md1(.instruction(instruction), .aluCtrl(aluCtrl),
                     .load(load), .store(store), .branch(branch), .regWrite(regWrite), .aluSrc(aluSrc),
                     .JAL(JAL), .opCode(opCode), .funct7(funct7), .funct3(funct3), .rs1(rs1), .rs2(rs2),
                     .rd(rd), .imm(imm), .JALR(JALR), .AUIPC(AUIPC));

    RegisterFile rf1(.clock(clk), .reset(reset), .rs1(rs1), .rs2(rs2), .rd(rd), .writeData(inputWriteData), .regData1(regData1), .regData2(regData2), .write(regWrite));


    always #5 clk = ~clk;


    initial 
    begin
        $dumpfile("DecodeStage/decode_stage_tb.vcd");
        $dumpvars(0, decode_stage_tb);

        clk = 0;
        reset = 0;
        pcAdder = 32'b0;
        reset = 1;
        #5;
        reset = 0;

        inputWriteData = 32'b1;

        #200;

        $display("TEST COMPLETE");

        $finish;

    end



endmodule