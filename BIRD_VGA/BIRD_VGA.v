//Verilog HDL for "Lib6710_Personal", "BIRD_VGA" "behavioral"

module BIRD_VGA ( BIRD_GLYPH_NUMBER, BIRD_Y_POSITION, X, Y, DRAW_BIRD, RGB); 

   parameter BIRD_X_POSITION = 2'd20;
   parameter BIRD_WIDTH = 2'd10;
   parameter BIRD_HEIGHT = 2'd10;
   parameter BIRD_INVISIBLE_COLOR = 3'b001;

   input [4:0] X;
   input [7:0] Y;
   input [7:0] BIRD_Y_POSITION;
   input [1:0] BIRD_GLYPH_NUMBER;


   output reg [2:0] RGB;
   output reg 	    DRAW_BIRD;

   reg [2:0] 	    TEMP_RGB;
   

   always@(X or Y)
     begin
	if ((X >= BIRD_X_POSITION) && (Y >= BIRD_Y_POSITION) && (X < (BIRD_X_POSITION+BIRD_WIDTH)) && (Y < (BIRD_Y_POSITION+BIRD_HEIGHT)))
	  begin
	     case(BIRD_GLYPH_NUMBER)
	       2'b00: TEMP_RGB = 3'b110;
	       2'b01: TEMP_RGB = 3'b110;
	       2'b10: TEMP_RGB = 3'b110;
	       2'b11: TEMP_RGB = 3'b100;
	     endcase
	  end
	else
	  begin
	     TEMP_RGB = BIRD_INVISIBLE_COLOR;
	  end // else: !if((X >= BIRD_X_POSITION) && (Y >= BIRD_Y_POSITION) && (X < (BIRD_X_POSITION+BIRD_WIDTH)) && (Y < (BIRD_Y_POSITION+BIRD_HEIGHT)))

        RGB = TEMP_RGB;	
	DRAW_BIRD = (TEMP_RGB != BIRD_INVISIBLE_COLOR);	
     end // always@ (X, Y, BIRD_Y_POSITION, BIRD_GLYPH_NUMBER)
endmodule // BIRD_VGA

