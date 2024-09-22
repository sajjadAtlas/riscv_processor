module PC_Adder(input [31:0] PC,
                input isBranch,
                input isJump,
                input reg 
                output reg [31:0] incrementedPC);

  
    always@(*)
    begin
    //going to add mux here for branching
    
        incrementedPC <= PC+4;  
        
        
        
    end

endmodule