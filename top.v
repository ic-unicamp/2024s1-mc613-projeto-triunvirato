module top(
  // Inputs da placa
  input CLOCK_50,
  input reset,

  // Sinais para o Conversor Digital-Analógico
  output wire VGA_CLK,
  output [7:0] VGA_R,
  output [7:0] VGA_G,
  output [7:0] VGA_B,
  output VGA_SYNC_N,
  output VGA_BLANK_N,

  // Direto para o conector VGA
  output VGA_HS,
  output VGA_VS

  // Para top-module
);

  wire [10:0] x_coord;
  wire [10:0] y_coord;

  wire [7:0] top_R;
  wire [7:0] top_G;
  wire [7:0] top_B;

  

  vga vga_base(
    .CLOCK_50(CLOCK_50),
    .reset(reset),
    .top_R(top_R),
    .top_G(top_G),
    .top_B(top_B),
    .VGA_CLK(VGA_CLK),
    .VGA_R(VGA_R),
    .VGA_G(VGA_G),
    .VGA_B(VGA_B),
    .VGA_BLANK_N(VGA_BLANK_N),
    .VGA_SYNC_N(VGA_SYNC_N),
    .VGA_HS(VGA_HS),
    .VGA_VS(VGA_VS),
    .x_coord(x_coord),
    .y_coord(y_coord)
  );


  wire is_on_cursor;

  cursor cursor_inst(
    .CLOCK_50(CLOCK_50),
    .reset(reset),
    .x_coord(x_coord),
    .y_coord(y_coord),
    .is_on_cursor(is_on_cursor)
  );


  assign top_R = (is_on_cursor) ? 50 : 255;
  assign top_G = (is_on_cursor) ? 50 : 255;
  assign top_B = (is_on_cursor) ? 50 : 255;

endmodule