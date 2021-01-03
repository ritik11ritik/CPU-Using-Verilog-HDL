`timescale 1ns/1ps
module Data_Memory(
  input E, WE, clk,
  input[3:0] Addr,
  input[7:0] DI,
  output[7:0] DO
);
  
  reg[7:0] DMem[15:0];
  
  assign DO = (E==1)?DMem[Addr]:0;
  
  always @(posedge clk)
    begin
      if (E && WE)
        begin
          DMem[Addr] <= DI;
      	end
    end
endmodule