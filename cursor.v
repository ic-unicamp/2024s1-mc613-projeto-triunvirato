module cursor(
  input CLOCK_50,
  input reset,

  input [10:0] x_coord,
  input [10:0] y_coord,
  output reg is_on_cursor
);

  localparam [3:0] CURSOR_ARM_SIZE = 8;
  reg [10:0] cursor_vert_x;
  reg [10:0] cursor_vert_y;
  reg [10:0] cursor_hor_x;
  reg [10:0] cursor_hor_y;
  
  always @(posedge CLOCK_50) begin 
    if (~reset) begin 
      cursor_vert_x = 320;
      cursor_vert_y = 236;
      cursor_hor_x = 316;
      cursor_hor_y = 240;
      
    end
    
    else begin
      if (((x_coord >= cursor_hor_x && x_coord <= cursor_hor_x + CURSOR_ARM_SIZE && y_coord == cursor_hor_y) 
         ^ (y_coord >= cursor_vert_y && y_coord <= cursor_vert_y + CURSOR_ARM_SIZE && x_coord == cursor_vert_x))) begin 
        is_on_cursor = 1;
      end
      else
        is_on_cursor = 0;
    end
  end

endmodule