	module main(
		// SINAIS BASICOS
		input CLOCK_50,

		// Botões para controle
		input right_but,
		input up_but,
		input down_but,
		input left_but,
		input [9:0] SW,

		// SINAIS DA VGA
		output wire VGA_CLK,
		output [7:0] VGA_R,
		output [7:0] VGA_G,
		output [7:0] VGA_B,
		output VGA_BLANK_N,
		output VGA_SYNC_N,

		output VGA_HS,
		output VGA_VS,
		// Para visores HEX
  		output [6:0] HEX0, // digito da direita
		output [6:0] HEX1,
		output [6:0] HEX2,
		output [6:0] HEX3,
		output [6:0] HEX4,
		output [6:0] HEX5 // digito da esquerda
	);
		wire reset;
		assign reset = SW[0];
		// Parâmetros
		parameter [6:0] SIZE = 8;
		parameter [6:0] STEP = 4;
		parameter [10:0] W_RES = 640;
		parameter [10:0] H_RES = 480;
		parameter [21:0] DIVISOR = 2000000;

		// Coordenadas da bola
		reg [10:0] ball_x;
		reg [10:0] ball_y;
		reg [2:0] last_button; 
		reg [21:0] cont;

		// Coordenadas de leitura do VGA
		wire [10:0] x_coord;
		wire [10:0] y_coord;
		wire [7:0] red_vga;
		wire [7:0] green_vga;
		wire [7:0] blue_vga;

		// Enable de escrita do buffer
		wire write_enable;
		// Cores do cursor - pintar
		reg [7:0] red_in;
		reg [7:0] green_in;
		reg [7:0] blue_in;
		// Coordenadas de escrita do buffer
		reg [10:0] top_x_coord;
		reg [10:0] top_y_coord;
		// Entrada do modulo buffer
		reg [7:0] red_data_in;
		reg [7:0] green_data_in;
		reg [7:0] blue_data_in;
		// Saída do modulo buffer
		wire [7:0] red_out;
		wire [7:0] green_out;
		wire [7:0] blue_out;
		// Coordenadas para zerar o buffer quando reset=0
		// saída do modulo zera_buffer
		wire [10:0] x_zera;
		wire [10:0] y_zera;

		// Enable de leitura do buffer
		// quando reset=1 (desligado)
		// lê baseado no botão pressionado pintar_but

		// Posição de pintar o cursor
		wire [10:0] pc_x;
		wire [10:0] pc_y;

		vga vga_inst(
			.CLOCK_50(CLOCK_50),
			.reset(reset),
			.top_R(red_vga),			// Dado a ser enviado
			.top_G(green_vga),		// Dado a ser enviado
			.top_B(blue_vga),			// Dado a ser enviado
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

		buffer red_buffer(
			.clock(CLOCK_50),
			.write_enable(write_enable),
			.reset(reset),
			.data_in(red_in),
			.data_in_x(top_x_coord),
			.data_in_y(top_y_coord),
			.data_out(red_out),
			.data_out_x(x_coord),
			.data_out_y(y_coord)
		);

		buffer green_buffer(
			.clock(CLOCK_50),
			.reset(reset),
			.write_enable(write_enable),
			.data_in(green_in),
			.data_in_x(top_x_coord),
			.data_in_y(top_y_coord),
			.data_out(green_out),
			.data_out_x(x_coord),
			.data_out_y(y_coord)
		);

		buffer blue_buffer(
			.clock(CLOCK_50),
			.reset(reset),
			.write_enable(write_enable),
			.data_in(blue_in),
			.data_in_x(top_x_coord),
			.data_in_y(top_y_coord),
			.data_out(blue_out),
			.data_out_x(x_coord),
			.data_out_y(y_coord)
		);

		zera_buffer inst_zera_buffer(
			.reset(reset),
			.clock(CLOCK_50),
			.x_coord(x_zera),
			.y_coord(y_zera)
		);

		pinta_cursor inst_pinta_cursor(
			.reset(reset),
			.clock(CLOCK_50),
			.x_cursor(ball_x),
			.y_cursor(ball_y),
			.SIZE(SIZE),
			.x_coord(pc_x),
			.y_coord(pc_y)
		);

		display red_display(
			.clk(CLOCK_50),
			.entrada(red_in),
			.digito0(HEX4),
			.digito1(HEX5)
		);
		
		display green_display(
			.clk(CLOCK_50),
			.entrada(green_in),
			.digito0(HEX2),
			.digito1(HEX3)
		);
		
		display blue_display(
			.clk(CLOCK_50),
			.entrada(blue_in),
			.digito0(HEX0),
			.digito1(HEX1)
		);

		assign write_enable = reset ? SW[1] : 0;

		wire borda_esq;
		assign borda_esq = (x_coord == ball_x && y_coord >= ball_y && y_coord <= ball_y + SIZE + 1); 
		wire borda_dir;
		assign borda_dir = (x_coord == ball_x + SIZE + 1 && y_coord >= ball_y && y_coord <= ball_y + SIZE + 1);
		wire borda_sup;
		assign borda_sup = (y_coord == ball_y && x_coord >= ball_x && x_coord <= ball_x + SIZE + 1);
		wire borda_inf;
		assign borda_inf = (y_coord == ball_y + SIZE + 1 && x_coord >= ball_x && x_coord <= ball_x + SIZE + 1);

		wire cursor;
		assign cursor = (x_coord >= ball_x + 1 && x_coord <= ball_x + SIZE && y_coord >= ball_y + 1 && y_coord <= ball_y + SIZE);

		wire borda;
		assign borda = borda_sup | borda_inf | borda_esq | borda_dir;

		// Registradores que vão direto para o VGA
		assign red_vga = (cursor) ? red_in : ((borda) ? 0 : red_out);
		assign green_vga = (cursor) ? green_in : ((borda) ? 0 : green_out);
		assign blue_vga = (cursor) ? blue_in : ((borda) ? 0 : blue_out);

		// assign green_vga = (y_coord >= ball_y +  1 && y_coord <= ball_y + SIZE && x_coord >= ball_x + 1 && x_coord <= ball_x + SIZE) ? green_in : green_out;
		// assign blue_vga = (y_coord >= ball_y + 1 && y_coord <= ball_y + SIZE && x_coord >= ball_x + 1 && x_coord <= ball_x + SIZE) ? blue_in: blue_out;

		// Controlador do cursor
		always @(posedge CLOCK_50) begin

			if (reset == 0) begin
				// Centralizar o cursor
				ball_x = ((W_RES/2) - (SIZE/2));
				ball_y = ((H_RES/2) - (SIZE/2));

				// Reiniciar last_button
				last_button = 3'b111;
				end

			else begin

				cont = cont + 1;
				if (cont == DIVISOR) begin
					cont = 0;
					if (!up_but | !down_but | !left_but | !right_but) begin
						if (!up_but) begin
							last_button = 3'b000;
							end
						else if (!down_but) begin
							last_button = 3'b001;
							end
						else if (!left_but) begin
							last_button = 3'b010;
							end
						else if (!right_but) begin
							last_button = 3'b011;
							end
						end

					if (last_button != 3'b111) begin
						case (last_button)
						3'b000:  begin  // UP
								if (ball_y < STEP) ball_y = 0;
								else ball_y = ball_y - STEP;
								end
						3'b001: begin // DOWN
								if (ball_y + STEP + SIZE > H_RES) ball_y = (H_RES - SIZE);
								else ball_y = ball_y + STEP;
								end
						3'b010: begin // LEFT
								if (ball_x <= STEP) ball_x = 0;
								else ball_x = ball_x - STEP;
								end
						3'b011: begin // Right
								if (ball_x + STEP + SIZE >= W_RES) ball_x = (W_RES - SIZE);
								else ball_x = ball_x + STEP;
								end
						endcase

							last_button = 3'b111;
						end            
					end
				end
			end

		// Controlador da posição de escrita
		always @(posedge CLOCK_50) begin

			if (reset == 0) begin
				top_x_coord = x_zera;
				top_y_coord = y_zera;
				end
			
			else begin
				top_x_coord = pc_x;
				top_y_coord = pc_y;
				end
			end

		wire red_01;
		assign red_01 = SW[9];
		wire red_02;
		assign red_02 = SW[8];
		wire green_01;
		assign green_01 = SW[7];
		wire green_02;
		assign green_02 = SW[6];
		wire blue_01;
		assign blue_01 = SW[5];
		wire blue_02;
		assign blue_02 = SW[4];
		wire all_white;
		assign all_white = SW[3];
		wire all_black;
		assign all_black = SW[2];
		reg [21:0] cont_switch;

		always @(posedge CLOCK_50) begin

			if (reset == 0)  begin
				red_in = 0;
				green_in = 0;
				blue_in = 0;
				cont_switch = 0;			
				end

			else begin

				cont_switch = cont_switch + 1;
				if (cont_switch == DIVISOR) begin
					if (all_white) begin
						red_in = 255;
						green_in = 255;
						blue_in = 255;
						end

					else if (all_black) begin
						red_in = 0;
						green_in = 0;
						blue_in = 0;
						end

					else begin
						red_in[5:0] = 0;
						green_in[5:0] = 0;
						blue_in[5:0] = 0;
						red_in[7] = red_01 ? 1 : 0;
						red_in[6] = red_02 ? 1 : 0;
						green_in[7] = green_01 ? 1 : 0;
						green_in[6] = green_02 ? 1 : 0;
						blue_in[7] = blue_01 ? 1 : 0;
						blue_in[6] = blue_02 ? 1 : 0;						
						end

					end
				end
			end


	endmodule