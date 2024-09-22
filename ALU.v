module ALU(input [31:0] operand1,
           input [31:0] operand2,
           input [3:0] ALUop,
           input [6:0] funct7,
           input [2:0] funct3,
           output reg branchTaken,
           output reg [31:0] result);

           integer msb = 0;
           integer i = 0;
           wire op1_sign = operand1[31];
           wire op2_sign = operand2[31];
           reg [31:0] temp = operand1;
           always@(*)
           begin

                case(ALUop)

                    4'b0000: 
                    begin
                    
                        case ({funct7, funct3})
                            10'b0000000000: result = operand1 + operand1;  //ADD
                            10'b0000100000: result = operand1 - operand2; //SUB
                            10'b0000000100: result = operand1 ^ operand2; //XOR
                            10'b0000000110: result = operand1 | operand2; //OR
                            10'b0000000111: result = operand1 & operand2; //AND
                            10'b0000000001: result = operand1 << operand2; //LSL
                            10'b0000000101: result = operand1 >> operand2; //LSR
                            10'b0100000101: begin  //ASR
                                msb = operand1[31];
                                result = operand1 >> operand2;
                                for(i = 0;i<operand2;i++)
                                begin
                                    result[31-i] = msb;
                                end
                            end
                            10'b0000000010: begin //SLT
                                if(op1_sign != op2_sign)
                                begin
                                    result = (op1_sign==1)?1:0;
                                end
                                else if ((op1_sign == op2_sign)) 
                                begin
                                    result = (operand1[30:0]<operand2[30:0])?1:0;
                                end
                                
                            end
                            10'b0000000011: result = (operand1<operand2)?1:0; //SLTU
                            default: result = 0;
                        endcase
                    end
                    4'b0001:
                    begin
                        case (funct)
                            3'b000: result = operand1 + operand2; //ADDI
                            3'b100: result = operand1 ^ operand1; //XORI
                            3'b110: result = operand1 | operand2; //ORI
                            3'b111: result = operand1 & operand2; //ANDI
                            3'b001: begin //LSLI
                                if(operand2[11:5]==0)
                                begin
                                    result = operand1 << operand2[4:0];
                                end
                            end
                            3'b101: begin 
                                if(operand2[11:5]==0) //LSRI
                                begin
                                    result = operand1 >> operand2[4:0];
                                end
                                else if(operand[11:5] == 7'b0100000) //ASRI
                                begin
                                    msb = operand1[31];
                                    result = operand1 >> operand2[4:0];
                                    for(i = 0;i<operand2[4:0];i++)
                                    begin
                                        result[31-i] = msb;
                                    end
                                end
                            end
                            3'b010: begin //SLTI
                                if(op1_sign != op2_sign)
                                begin
                                    result = (op1_sign==1)?1:0;
                                end
                                else if ((op1_sign == op2_sign)) 
                                begin
                                    result = (operand1[30:0]<operand2[30:0])?1:0;
                                end
                            end
                            3'b011: result = (operand1<operand2)>1:0;
                            

                            default: result = 0;
                        endcase
                    end
                    4'b0010: //LB, LH, LW, LBU, LHU, SB, SH, SW
                    begin
                        if(funct3 == 3'b000 || funct3 == 3'b001 || funct3 == 3'b010 || funct3 == 3'b100 || funct3 ==  3'b101)
                        begin
                            result = operand1 + operand2; //to get memory address, add offset (in op2) to base address (op1)
                        end
                    end
                    4'b0011:
                    begin
                        case (funct3)
                            3'b000: branchTaken = (($signed(operand1)-$signed(operand2))==0)?1:0; //BEQ
                            3'b001: branchTaken = (($signed(operand1)-$signed(operand2))!=0)?1:0; //BNE
                            3'b100: branchTaken = (($signed(operand1)-$signed(operand2))<0)?1:0; //BLT
                            3'b101: branchTaken = (($signed(operand1)-$signed(operand2))>=0)?1:0; //BGE
                            3'b110: branchTaken = ((operand1-operand2)<0)?1:0;  //BLTI
                            3'b111: branchTaken = ((operand1-operand2)>=0)?1:0; //BGEU
                            default: branchTaken = 0;
                        endcase
                    end
                    4'b0100:
                    begin
                        result <= temp + 4;        //write pc + 4 to the result of ALU, this goes to reg file
                        //operand1 = operand1 + imm; //update current PC
                    end
                    4'b0101:
                    begin
                        result = operand2 << 12;
                    end
                    
                    default: result = 0;
                endcase

           end
endmodule

