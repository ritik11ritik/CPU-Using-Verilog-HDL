`timescale 1ns/1ps
module MUX(
  input[7:0] In1, In2,
  input sel,
  output[7:0] Out
);
  
  assign Out = (sel==1)?In2:In1;
endmodule