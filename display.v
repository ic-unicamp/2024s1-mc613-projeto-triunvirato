module display(
    input clk,
    input [7:0] entrada,
    output reg [6:0] digito0, // digito da direita
    output reg [6:0] digito1
);

    reg [4:0] digito0bin, digito1bin;

    always @(negedge clk) begin
        digito0bin = {entrada[3:0]};
        digito1bin = {entrada[7:4]};

        case(digito0bin)
            4'b0000: digito0 = 7'b1000000; // 0
            4'b0001: digito0 = 7'b1111001; // 1
            4'b0010: digito0 = 7'b0100100; // 2
            4'b0011: digito0 = 7'b0110000; // 3
            4'b0100: digito0 = 7'b0011001; // 4
            4'b0101: digito0 = 7'b0010010; // 5
            4'b0110: digito0 = 7'b0000010; // 6
            4'b0111: digito0 = 7'b1111000; // 7
            4'b1000: digito0 = 7'b0000000; // 8
            4'b1001: digito0 = 7'b0010000; // 9
            4'b1010: digito0 = 7'b0001000; // a
            4'b1011: digito0 = 7'b0000011; // b
            4'b1100: digito0 = 7'b1000110; // c
            4'b1101: digito0 = 7'b0100001; // d
            4'b1110: digito0 = 7'b0000110; // e
            4'b1111: digito0 = 7'b0001110; // f
            default: digito0 = 7'b1111111; // entrada inválida
        endcase
        
        case(digito1bin)
            4'b0000: digito1 = 7'b1000000; // 0
            4'b0001: digito1 = 7'b1111001; // 1
            4'b0010: digito1 = 7'b0100100; // 2
            4'b0011: digito1 = 7'b0110000; // 3
            4'b0100: digito1 = 7'b0011001; // 4
            4'b0101: digito1 = 7'b0010010; // 5
            4'b0110: digito1 = 7'b0000010; // 6
            4'b0111: digito1 = 7'b1111000; // 7
            4'b1000: digito1 = 7'b0000000; // 8
            4'b1001: digito1 = 7'b0010000; // 9
            4'b1010: digito1 = 7'b0001000; // a
            4'b1011: digito1 = 7'b0000011; // b
            4'b1100: digito1 = 7'b1000110; // c
            4'b1101: digito1 = 7'b0100001; // d
            4'b1110: digito1 = 7'b0000110; // e
            4'b1111: digito1 = 7'b0001110; // f
            default: digito1 = 7'b1111111; // entrada inválida
        endcase
    end

endmodule