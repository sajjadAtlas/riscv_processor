This project is a pipelined RISCV-V processor implementing the 32-bit instruction set. It's meant as an exercise for learning verilog as well as processor design and generally computer architecture. It's definitely a work in progress,
; I want to add branch prediction for example, that would be cool to implement. I need to test the branching/jump instructions a bit more.




Future Changes:

-Implement branch prediction to improve efficiency - right now branches are wasting time
-Add flushing/stalling pipeline
-could add muxes to choose value of pc for some instructions
-design UVM testbench for the ALU 



General Issues:

-Get rid of unnecessary files - some of the instruction module files (branch, etc) not needed anymore
-need to test more extensively, right now there are probably bugs need more rigorous test benches
-clean up the code lol

Recent Changes:

-implemented 5 stage pipeline, integrated auipc, branch, jalr, jal - need to test these more though
