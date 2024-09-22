module main_decoder(input [31:0] instruction,
                    output reg [4:0] aluCtrl,
                    output reg load,
                    output reg store,
                    output reg branch,
                    output reg regWrite,
                    output reg aluSrc,
                    output reg JAL,
                    output reg JALR,
                    output reg AUIPC,
                    output reg [6:0] opCode,
                    output reg [6:0] funct7,
                    output reg [2:0] funct3,
                    output reg [4:0] rs1,
                    output reg [4:0] rs2,
                    output reg [4:0] rd,
                    output reg [31:0] imm);


    always@(*)
    begin
        opCode = instruction[6:0];
        
        case (opCode)
            7'b0110011: begin                   //R-Type instruction
                funct3 <= instruction[14:12]; //specifies which type of arithmetic instruction
                funct7 <= instruction[31:25]; //further specification
                rs1 <= instruction[19:15];    //source and destination registers
                rs2 <= instruction[24:20];
                rd <= instruction[11:7];
                load <= 0;       //R-type doesnt write or read from memory, but it writes to a register, hence regWrite
                store <= 0;
                regWrite <= 1;
                branch <= 0;
                JAL <= 0;
                aluSrc <= 0;      //alu input is from a reg
                imm <= 32'b0;
                aluCtrl <= 4'b0000;    //this code will indicate R-type instructions in the alu control unit
            end
            7'b0010011: begin         //I-Type instruction
                funct3 <= instruction[14:12];   
                rs1 <= instruction[19:15];
                rd <= instruction[11:7];
                load <= 0;       //I-Type arithmetics don't write or read from memory
                store <= 0;
                regWrite <= 1;      //register write takes place, hence rd
                branch <= 0;
                JAL <= 0;
                aluSrc <= 1;       //alu input will draw on an immediate value instead of another register operand
                imm <= {{20{instruction[31]}}, instruction[31:20]};    /*here we sign extend the immediate because the alu takes 32 bit operants while the immediate is 12 bit, hence replicating the sign bit 20x*/      
                aluCtrl <= 4'b0001;
            end
            7'b0000011: begin //Load instructions, I-type
                funct3 <= instruction[14:12];   
                rs1 <= instruction[19:15];
                rd <= instruction[11:7];
                load <= 1;                   //load instructions read from memory, and write to a register
                store <= 0;
                regWrite <= 1;
                branch <= 0;
                JAL <= 0;
                aluSrc <= 1;
                imm <= {{20{instruction[31]}}, instruction[31:20]};    //offset added to the rs1 value
                aluCtrl <= 4'b0010;

            end
            7'b0100011: begin //S-Type instructions (storing)
                funct3 <= instruction[14:12]; 
                rs1 <= instruction[19:15];        //address of memory
                rs2 <= instruction[24:20];        //data to be stored 
                load <= 0;
                store <= 1;               //store instructions read from reg, write to memory
                regWrite <= 0;
                branch <= 0;
                JAL <= 0;
                aluSrc <= 1;
                imm <= {{21{instruction[31]}}, instruction[30:25],instruction[11:7]};        //offset used to get memory address, added to rs1
                aluCtrl <= 4'b0010;
            end
            7'b1100011: begin  //B-Type instructions (branching)
                funct3 <= instruction[14:12];
                rs1 <= instruction[19:15];    //source and destination registers
                rs2 <= instruction[24:20];
                load <= 0;          //branching doesnt write any regs or read/write from memory
                store <= 0;
                regWrite <= 0;
                branch <= 1;         //branching will just cause pc mux to use a different input instead of just +4
                JAL <= 0;
                aluSrc <= 1;
                imm <= {{20{instruction[31]}},instruction[7],instruction[30:25],instruction[11:8], 1'b0};     //concatenate the immediate value in B-Type instructions, sign extend and left shift too
                aluCtrl <= 4'b0011;
            end
            7'b1101111: begin //JAL instruction (JAL)
                rd <= instruction[11:7];         //where the return address is stored
                load <= 0;
                store <= 0;
                regWrite <= 1;         //JALs perform a register write
                branch <= 0;
                JAL <= 1;
                aluSrc <= 1;
                imm <= {{13{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21]};    //offset added to PC, tells the program where to go when instr is executed
                aluCtrl <= 4'b0100;
            end
            7'b1100111: begin   //JALR instruction, which is an I-Type 
                funct3 <= instruction[14:12];
                rs1 <= instruction[19:15];        //base address that offset gets added to
                rd <= instruction[24:20];          //return address
                load <= 0;
                store <= 0;
                regWrite <= 1;
                branch <= 0;
                JALR <= 1;
                aluSrc <= 1;
                imm <= {{20{instruction[31]}}, instruction[31:20]};
                aluCtrl <= 4'b0100;
            end
            7'b0110111: begin //U-Type instruction, LUI (Load Upper Immediate)
                rd <= instruction[11:7]; //This instruction loads an immediate into the upper 20 bits of rd, while the other 12 are 0;
                load <= 0;
                store <= 0;
                regWrite <= 1;
                branch <= 0;
                JAL <= 0;
                aluSrc <= 1;
                imm <= {{13{instruction[31]}},instruction[30:12]};
                aluCtrl <= 4'b0101;
            end
            7'b0010111: begin //U-Type instruction, AUIPC
                rd <= instruction[11:7]; //This instruction adds a 20 bit immediate to the upper 20 bits of the PC. The result of the operation is stored in rd
                load <= 0;
                store <= 0;
                regWrite <= 1;
                branch <= 0;
                JAL <= 0;
                AUIPC <= 1;
                aluSrc <= 1;
                imm <= {{13{instruction[31]}},instruction[30:12]};
                aluCtrl <= 4'b0100;
            end 



            default: begin
                funct3 <= 3'b0;
                funct7 <= 7'b0;
                rs1 <= 5'b0;
                rs2 <= 5'b0;
                rd <= 5'b0;
                load <= 0;
                store <= 0;
                branch <= 0;
                regWrite <= 0;
                aluSrc <= 0;
                JAL <= 0;
                imm <= 32'b0;
                aluCtrl <= 4'b1111;
                
            end
        endcase
        





    end

endmodule