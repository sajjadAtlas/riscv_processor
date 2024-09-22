`timescale 1ns/1ns
`include "ProgramCounter.v"
`include "PC_Adder.v"

module ProgramCounter_tb;

    reg [31:0] nextPC;
    reg clk;
    reg reset;

    wire [31:0] PC;

    ProgramCounter pc1(.clk(clk), .reset(reset), .nextPC(nextPC), .PC(PC));
    
    always #5 clk = ~clk;

    initial
    begin


        $dumpfile("ProgramCounter_tb.vcd");
        $dumpvars(0, ProgramCounter_tb);
        clk = 0;
        reset = 0;
        nextPC = 32'b0;

        reset = 1;
        #10;
        reset = 0;
        
        nextPC = 32'h00004;
        #10;
        nextPC = 32'h00008;

        #10;
        reset = 1;
        #10;
        reset = 0;

        nextPC = 32'h0000C;

        #100;

        $display("TEST COMPLETE");
        $finish;

    end
        
endmodule
