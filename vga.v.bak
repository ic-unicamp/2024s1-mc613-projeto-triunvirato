module vga(
  // Inputs da placa
  input CLOCK_50,
  input reset,

  // Input do top-module
  input [7:0] top_R,
  input [7:0] top_G,
  input [7:0] top_B,

  // Sinais para o Conversor Digital-Analógico
  output wire VGA_CLK,
  output [7:0] VGA_R,
  output [7:0] VGA_G,
  output [7:0] VGA_B,
  output VGA_SYNC_N,
  output VGA_BLANK_N,

  // Direto para o conector VGA
  output VGA_HS,
  output VGA_VS,

  // Para top-module
  output reg [10:0] x_coord,
  output reg [10:0] y_coord
);

  reg [10:0] h_counter;
  reg [10:0] v_counter;
  wire active_display;
  reg vga_clk_aux = 0;

  assign VGA_CLK = vga_clk_aux;
  assign VGA_BLANK_N = 1;
  assign VGA_SYNC_N = 1;
  assign VGA_HS = (h_counter < 96)? 0 : 1;
  assign VGA_VS = (v_counter < 2)? 0 : 1;
  assign active_display = ((h_counter >= 144) && (h_counter < 784) && (v_counter >= 35) && (v_counter < 515))? 1 : 0;
  assign VGA_R = (active_display)? top_R:0; 
  assign VGA_G = (active_display)? top_G:0;
  assign VGA_B = (active_display)? top_B:0;

  always @(posedge CLOCK_50) begin
    // if (reset == 0) begin
    //   vga_clk_aux = 0;
    // end
      vga_clk_aux = !vga_clk_aux;
  end

  always @(posedge VGA_CLK) begin
    if (reset == 0) begin
      h_counter = 0;
      v_counter = 0;
    end

    else begin
      h_counter = h_counter + 1;
      if (h_counter == 800) begin
        h_counter = 0;
        v_counter = v_counter + 1;
        if (v_counter == 525)
          v_counter = 0;
      end
    end

    x_coord = ((h_counter >= 144) && (h_counter < 784))? h_counter - 144: 0;
    y_coord = ((v_counter >= 35) && (v_counter < 515))? v_counter - 35: 0;
  end

endmodule