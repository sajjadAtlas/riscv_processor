module ProgramCounter(input clk,
                      input reset,
                      input [31:0] nextPC,
                      output reg [31:0] PC
                      );


    always@(posedge clk or posedge reset)
    begin

        if(reset)
        begin
            PC <= 0;
        end

        else
        begin
            PC <= nextPC;
        end
    end

endmodule

