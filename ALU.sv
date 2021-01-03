`timescale 1ns/1ps
module ALU(
  input[3:0] mode, CFlags,
  input[7:0] Operand1, Operand2,
  input E,
  output [7:0] Out,
  output [3:0] Flags
);
  
  reg[8:0] Res;
  reg Z,C,S,O;
  assign Out = Res[7:0];
  
  always @(*)
    begin
      Z = !(|Res[7:0]);
  	  O = Res[8];
    end
  
  assign Flags = {Z,C,S,O};
  
  
  always @(*)
    begin
      Res = 9'b000000000;
      case(mode)
        4'h0:
          begin
            Res = Operand1 + Operand2;
            C = Res[8];
          end
        4'h1:
          begin
            Res = Operand1 - Operand2;
            S = (Operand1 < Operand2)?1'b1:1'b0;
          end
        4'h2:
          Res = Operand1;
        4'h3:
          Res = Operand2;
        4'h4:
          Res = Operand1 & Operand2;
        4'h5:
          Res = Operand1 | Operand2;
        4'h6:
          Res = Operand1 ^ Operand2;
        4'h7:
          begin
            Res = Operand2 - Operand1;
            S = (Operand2 < Operand1)?1'b1:1'b0;
          end
        4'h8:
          Res = Operand2 + 1;
        4'h9:
          Res = Operand2 - 1;
        4'ha:
          Res = (Operand2 << Operand1[2:0]) | (Operand2 >> 8-Operand1[2:0]);
        4'hb:
          Res = (Operand2 >> Operand1[2:0]) | (Operand2 << 8-Operand1[2:0]);
        4'hc:
          Res = Operand2 << Operand1[2:0];
        4'hd:
          Res = Operand2 >> Operand1[2:0];
        4'he:
          Res = Operand2 >>> Operand1[2:0];
        4'hf:
          begin
            Res = 0 - Operand2;
            S = (0 < Operand2)?1'b1:1'b0;
          end
        default:
          Res = Operand1+Operand2;            
      endcase
    end
endmodule
    