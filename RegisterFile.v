module RegisterFile (
    input clock,
    input reset,
    input write,
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input [31:0] writeData,
    output wire [31:0] regData1,
    output wire [31:0] regData2
);

reg [31:0] regFile [31:0];
assign regData1 = regFile[rs1];
assign regData2 = regFile[rs2];

always@(posedge clock or posedge reset)
begin
    if(reset)
    begin
        for(integer i = 0;i<32;i++)
        begin
            regFile[i] = 32'b0;
        end
        regFile[rd] <= 0;
    end
    else if(write && !reset)
    begin
        regFile[rd] <= writeData;
    end
    
end


    
endmodule