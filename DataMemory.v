module datamemory (
    input [31:0] address,
    input write,
    input [31:0] writeData,
    input read,
    output reg [31:0] readData
);
    
    reg  [31:0] mem [63:0];


    initial begin
        for(integer i = 0;i<64;i++)
        begin
            reg[i] = 32'b0;
        end
    end

    always@(*)
    begin
        if (write) 
        begin
            mem[address] <= writeData
        end
    end

    if (read) begin
        assign readData = mem[address];
    end

endmodule