`include "ALU.sv"
`include "Program_Memory.sv"
`include "Data_Memory.sv"
`include "PC_Adder.sv"
`include "MUX.sv"
`include "Control_Unit.sv"
`timescale 1ns/1ps
module Microcontroller(
  input clk, rst
); 
  
  parameter InsNumber = 4'd10;
  
  reg[11:0] Instruction_Mem[9:0];
  reg load_done;
  
  reg[7:0] PC, Acc, load_addr;
  reg[3:0] SR;
  reg[11:0] IR, PMem_LI;
  reg[7:0] DR, PMem_LA;
  wire PMem_LE;
  wire IR_E, DR_E, Acc_E, SR_E;
  wire[11:0] load_instr;
  
  wire[11:0] IR_Wire;

  wire ALU_E, PMem_E, DMem_E, DMem_WE, MUX1_sel, MUX2_sel, PC_E;
  wire[3:0] ALU_mode, SR_updated;
  wire[7:0] MUX2_Out, ALU_Out, DMem_DO, Adder_Out, PC_Wire;
  
  parameter LOAD = 2'b00, 
  			FETCH = 2'b01,
  			DECODE = 2'b10,
  			EXECUTE = 2'b11;
  reg[1:0] present_state, next_state;
  
  initial
    begin
      $readmemb("Instructions.txt", Instruction_Mem, 0,9);
      $dumpfile("dump.vcd");
      $dumpvars(1, Microcontroller);
    end
  
  Control_Unit CU(.present_state(present_state),
                  .IR(IR),
                  .SR(SR),
                  .PC_E(PC_E),
                  .Acc_E(Acc_E),
                  .SR_E(SR_E),
                  .IR_E(IR_E),
                  .DR_E(DR_E),
                  .PMem_E(PMem_E),
                  .DMem_E(DMem_E),
                  .DMem_WE(DMem_WE),
                  .ALU_E(ALU_E),
                  .MUX1_sel(MUX1_sel),
                  .MUX2_sel(MUX2_sel),
                  .PMem_LE(PMem_LE),
                  .ALU_mode(ALU_mode)
                 );                 
  
  ALU alu(.E(ALU_E),
          .Operand1(Acc),
          .Operand2(MUX2_Out),
          .mode(ALU_mode),
          .CFlags(SR),
          .Out(ALU_Out),
          .Flags(SR_updated)
         );
  
  Program_Memory PMem(.clk(clk),
                      .E(PMem_E),
                      .Addr(PC),
                      .I(IR_Wire),
                      .LE(PMem_LE),
                      .LA(load_addr),
                      .LI(load_instr)
                     );
  
  Data_Memory DMem(.clk(clk),
                   .E(DMem_E),
                   .WE(DMem_WE),
                   .Addr(IR[3:0]),
                   .DI(ALU_Out),
                   .DO(DMem_DO)
                  );
  
  MUX mux1(.In1(IR[7:0]),
           .In2(Adder_Out),
           .sel(MUX1_sel),
           .Out(PC_Wire)
          );
  
  MUX mux2(.In1(IR[7:0]),
           .In2(DR),
           .sel(MUX2_sel),
           .Out(MUX2_Out)
          );
  
  PC_Adder Adder(.In(PC),
                 .Out(Adder_Out)
                );
  
  always @(posedge clk)
    begin
      if (rst)
        begin
          load_addr <= 0;
          load_done <= 0;
        end
      else if(PMem_LE)
        begin
          if(~load_done)
          	load_addr <= load_addr + 8'h01;
          if (load_addr == InsNumber)
            begin
              load_addr <= 8'd0;
              load_done <= 8'b1;
            end
          else
            load_done <= 1'b0;
        end
    end
  
  assign load_instr = Instruction_Mem[load_addr];
        
  
  always @(posedge clk)
    begin
      if (rst)
        begin
          present_state <= LOAD;
          PC <= 0;
          Acc <= 0;
          SR <= 0;
          PMem_LI <= 0;
          PMem_LA <= 0;
        end
      
      else
        begin
          if(PC_E)
            PC <= PC_Wire;
          if(Acc_E)
            Acc <= ALU_Out;
          if (SR_E)
            SR <= SR_updated;
        end
    end
  
  always @(posedge clk)
    begin
      if(DR_E)
        DR <= DMem_DO;
      if(IR_E)
        IR <= IR_Wire;
    end
  
  always @(posedge clk) present_state <= next_state;

  always @(*)
    begin
      case(present_state)
        LOAD:
          begin
          	PC = 0;
            IR = 0;
            DR = 0;
            Acc = 0;
            SR = 0;
            if(load_done)
            	next_state = FETCH;
            else
              next_state = LOAD;
          end
        
        FETCH:
          begin
            next_state = DECODE;
          end
        
        DECODE:
          begin
            next_state = EXECUTE;
          end
          
        EXECUTE:
          begin
            next_state = FETCH;
          end
      endcase
    end
endmodule
