`timescale 1ns/1ps
module Program_Memory(
  input E, LE, clk,
  input[7:0] Addr, LA,
  input [11:0] LI,
  output[11:0] I
);

  reg[11:0] PMem[255:0];
  assign I = (E)?PMem[Addr]:12'b0;
  
  always @(posedge clk)
    begin
      if (LE==1)
        begin
          PMem[LA] = LI;
        end
    end
  
endmodule