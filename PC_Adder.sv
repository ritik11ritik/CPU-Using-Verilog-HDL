`timescale 1ns/1ps
module PC_Adder(
  input[7:0] In,
  output[7:0] Out
);
  
  assign Out = In+1;
endmodule
