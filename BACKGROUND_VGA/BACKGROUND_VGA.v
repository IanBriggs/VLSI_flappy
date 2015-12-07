module BACKGROUND_VGA ( Y, RGB );

   parameter GROUND_START = 3'd230;

   input [7:0] Y;
   
   output reg [2:0] RGB;

   reg [2:0] 	    TEMP_RGB;

   always@(Y)
     begin
	if (Y >= GROUND_START)
	  begin
	     TEMP_RGB = 3'b001;
	  end
	else
	  begin
	     TEMP_RGB = 3'b010;
	  end
	RGB = TEMP_RGB;
     end // always@ (Y)
endmodule // BACKGROUND_VGA
