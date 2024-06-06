module pinta_cursor(
    input reset,
    input clock,
    input [10:0] x_cursor,
    input [10:0] y_cursor,
    input [6:0] SIZE,
    output reg [10:0] x_coord,
    output reg [10:0] y_coord
);

    always @(posedge clock) begin

        if (reset == 0) begin
            x_coord = x_cursor;
            y_coord = y_cursor;
            end

        else begin
            if (x_coord >= x_cursor + SIZE) begin
                x_coord = x_cursor;
                if (y_coord >= y_cursor + SIZE)
                    y_coord = y_cursor;
                else y_coord = y_coord + 1;
                end
            else x_coord = x_coord + 1;
            end
        end



endmodule