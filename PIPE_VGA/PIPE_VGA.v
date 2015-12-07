module PIPE_VGA ( PIPE_X_POSITION, PIPE_Y_HOLE_POSITION, X, Y, DRAW_PIPE, RGB );

   parameter PIPE_WIDTH = 2'd30;
   parameter PIPE_HOLE_SIZE = 2'd30;

   
   input [8:0] X;
   input [7:0] Y;
   input [7:0] PIPE_Y_HOLE_POSITION;
   input [8:0] PIPE_X_POSITION;


   output reg [2:0] RGB;
   output reg 	    DRAW_PIPE;

   reg [2:0] 	    TEMP_RGB;
   
   
   always@(X or Y)
     begin
	if ((X <= PIPE_X_POSITION) && (X > (PIPE_X_POSITION+PIPE_WIDTH)) && ((Y < PIPE_Y_HOLE_POSITION) || (Y > (PIPE_Y_HOLE_POSITION+PIPE_HOLE_SIZE)))) 
	  begin
	     TEMP_RGB = 3'b101;
	  end
	else
	  begin
	     TEMP_RGB = 3'b000;
	  end

	RGB = TEMP_RGB;
	DRAW_PIPE = (TEMP_RGB == 3'b000);
     end
   
endmodule
