`timescale 1ns/1ns
`include "ProgramCounter/ProgramCounter.v"
`include "FetchStage/instr_mem.v"
`include "ProgramCounter/PC_Adder.v"

module fetch_stage_tb;

    reg [31:0] address;
    wire [31:0] instruction;

    reg [31:0] pcAdder;
    wire [31:0] incrementedPC;

    reg clk, reset;
    wire [31:0] nextPC;
    wire [31:0] PC;

    ProgramCounter pc2(.clk(clk), .reset(reset), .nextPC(nextPC), .PC(PC));
    PC_Adder pca1(.PC(PC), .incrementedPC(nextPC));
    instr_mem im1(.address(PC), .instruction(instruction));


    always #5 clk = ~clk;

    initial 
    begin
        $dumpfile("FetchStage/fetch_stage_tb.vcd");
        $dumpvars(0, fetch_stage_tb);

        clk = 0;
        reset = 0;
        //nextPC = 32'b0;
        pcAdder = 32'b0;
        reset = 1;
        #5;
        reset = 0;

        //assign nextPC = incrementedPC;
        #300;

        $display("TEST COMPLETE");
        $finish;
    end
    
endmodule