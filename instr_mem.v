module instr_mem(input [31:0] address,
                 output reg [31:0] instruction);


    reg [31:0] mem [63:0];

    integer i;
    initial 
    begin
        for (i = 0; i<64; i++) begin
            mem[i] = 32'b0;
        end
        mem[0] = 32'h000000B3;
        mem[1] = 32'h000000A3;
      
        

        
    end

    always@(*)
    begin
        instruction = mem[address[31:2]]; //divide address by 4 to get index of instruction in the memory array
    end

endmodule