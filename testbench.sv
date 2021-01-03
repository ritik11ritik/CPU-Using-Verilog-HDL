`timescale 1ns/1ps
module tb;
  reg clk, rst;
  
  Microcontroller uc(
    clk, rst
  );
  
  always #10 clk = ~clk;

  initial
    begin
      
      clk = 0;
      rst = 1;
      #100
      rst = 0;
      
      #1000
      $finish;
    end
endmodule
      