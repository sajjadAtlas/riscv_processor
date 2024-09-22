`timescale 1ns/1ns
`include "ExecuteStage/ALU.v"

module ALU_tb;

    reg [31:0] operand1;
    reg [31:0] operand2;
    reg [3:0] ALUop;
    wire [31:0] result;
    reg [6:0] funct7;
    reg [2:0] funct3;
    ALU a1(.operand1(operand1), .operand2(operand2),.ALUop(ALUop), .result(result), .funct7(funct7), .funct3(funct3));

    initial 
        begin

            $dumpfile("ExecuteStage/ALU_tb.vcd");
            $dumpvars(0, ALU_tb);

          
            funct3 = 3'b010;
            funct7 = 7'b0000000;
            operand1 = -5;
            operand2 = 5;
            ALUop = 4'b0000;
            #10;
            funct3 = 3'b010;
            funct7 = 7'b0000000;
            operand1 = 5;
            operand2 = 7;
            ALUop = 4'b0000;
            #10;
            operand1 = 7;
            operand2 = 5;
            ALUop = 4'b0000;
            #10;
            operand1 = -7;
            operand2 = -5;
            ALUop = 4'b0000;
            #10;
            operand1 = -7;
            operand2 = -7;
            ALUop = 4'b0000;
            #10;
            operand1 = -7;
            operand2 = -8;
            ALUop = 4'b0000;
            #10;
            funct3 = 3'b011;
            funct7 = 7'b0000000;
            operand1 = 5;
            operand2 = 5;
            ALUop = 4'b0000;
            #10;
            
            operand1 = -5;
            operand2 = 5;
            ALUop = 4'b0000;
            #10;
           
            operand1 = 4;
            operand2 = 5;
            ALUop = 4'b0000;
            #10;

            operand1 = 5;
            operand2 = -5;
            ALUop = 4'b0000;
            #10;
            operand1 = -2;
            operand2 = -3;
            ALUop = 4'b0000;
            #10;
            operand1 = -3;
            operand2 = -2;
            ALUop = 4'b0000;
            #10;

            $display("TEST COMPLETED");
        end
    endmodule