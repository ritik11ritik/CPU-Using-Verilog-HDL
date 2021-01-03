`timescale 1ns/1ps
module Control_Unit(
  input[1:0] present_state,
  input [11:0] IR,
  input [3:0] SR,
  output reg PC_E, Acc_E, SR_E, IR_E, DR_E, PMem_E, DMem_E, DMem_WE, ALU_E, MUX1_sel, MUX2_sel, PMem_LE,
  output reg[3:0] ALU_mode
);
  
  parameter LOAD = 2'b00, 
  			FETCH = 2'b01,
  			DECODE = 2'b10,
  			EXECUTE = 2'b11;
  
  always @(*)
    begin
      PC_E = 0;
      Acc_E = 0;
      SR_E = 0;
      IR_E = 0;
      DR_E = 0;
      PMem_E = 0;
      DMem_E = 0;
      DMem_WE = 0;
      ALU_E = 0;
      MUX1_sel = 1'b0;
      MUX2_sel = 1'b0;
      ALU_mode = 4'b0000;
      PMem_LE = 0;
      
      if(present_state == LOAD)
        begin
          PMem_LE = 1;
          PMem_E = 1;
        end
      
      else if(present_state == FETCH)
        begin
          IR_E = 1;
          PMem_E = 1;
        end
      
      else if(present_state == DECODE)
        begin
          if (IR[11:9] == 4'b001)
            begin
              DR_E = 1;
              DMem_E = 1;
            end
        end
      
      else if(present_state == EXECUTE)
        begin
          if (IR[11:8] == 4'b0000)
            begin
              PC_E = 1;
              MUX1_sel = 1;
            end
          
          else if(IR[11:8] == 4'b0001)
            begin
              PC_E = 1;
              MUX1_sel = 0;
            end
          
          else if(IR[11:9] == 3'b001)
            begin
              PC_E = 1;
              Acc_E = IR[8];
              SR_E = 1;
              DMem_E = !(IR[8]);
              DMem_WE = !(IR[8]);
              ALU_E = 1;
              ALU_mode = IR[7:4];
              MUX1_sel = 1;
              MUX2_sel = 1;
            end
          
          else if(IR[11:10] == 2'b01)
            begin
              PC_E = 1;
              MUX1_sel = SR[IR[9:8]];
            end
          
          else if(IR[11] == 1'b1)
            begin
              PC_E = 1;
              Acc_E = 1;
              SR_E = 1;
              ALU_E = 1;
              ALU_mode = {1'b0,IR[10:8]};
              MUX1_sel = 1;
              MUX2_sel = 0;
            end  
          else
            begin
              PC_E = 1;
              MUX1_sel = 0;
            end
        end
    end
endmodule
      
      

  
  
  